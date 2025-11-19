//
// This file was auto-generated using the following command:
//
// jai modules/lz4/generate.jai
//



LZ4_VERSION_MAJOR :: 1;
LZ4_VERSION_MINOR :: 9;
LZ4_VERSION_RELEASE :: 4;

LZ4_VERSION_NUMBER :: LZ4_VERSION_MAJOR *100*100 + LZ4_VERSION_MINOR *100 + LZ4_VERSION_RELEASE;

LZ4_MEMORY_USAGE_MIN :: 10;
LZ4_MEMORY_USAGE_DEFAULT :: 14;
LZ4_MEMORY_USAGE_MAX :: 20;

LZ4_MEMORY_USAGE :: LZ4_MEMORY_USAGE_DEFAULT;

LZ4_MAX_INPUT_SIZE :: 0x7E000000;

LZ4_HASHLOG :: LZ4_MEMORY_USAGE-2;
LZ4_HASHTABLESIZE :: 1 << LZ4_MEMORY_USAGE;
LZ4_HASH_SIZE_U32 :: 1 << LZ4_HASHLOG;

LZ4_STREAM_MINSIZE :: (1 << LZ4_MEMORY_USAGE) + 32;

LZ4_STREAMDECODE_MINSIZE :: 32;

LZ4HC_CLEVEL_MIN :: 3;
LZ4HC_CLEVEL_DEFAULT :: 9;
LZ4HC_CLEVEL_OPT_MIN :: 10;
LZ4HC_CLEVEL_MAX :: 12;

LZ4HC_DICTIONARY_LOGSIZE :: 16;
LZ4HC_MAXD :: 1<<LZ4HC_DICTIONARY_LOGSIZE;
LZ4HC_MAXD_MASK :: LZ4HC_MAXD - 1;

LZ4HC_HASH_LOG :: 15;
LZ4HC_HASHTABLESIZE :: 1 << LZ4HC_HASH_LOG;
LZ4HC_HASH_MASK :: LZ4HC_HASHTABLESIZE - 1;

LZ4_STREAMHC_MINSIZE :: 262200;

LZ4_versionNumber :: () -> s32 #foreign liblz4;
LZ4_versionString :: () -> *u8 #foreign liblz4;

/*-************************************
*  Simple Functions
**************************************/
/*! LZ4_compress_default() :
*  Compresses 'srcSize' bytes from buffer 'src'
*  into already allocated 'dst' buffer of size 'dstCapacity'.
*  Compression is guaranteed to succeed if 'dstCapacity' >= LZ4_compressBound(srcSize).
*  It also runs faster, so it's a recommended setting.
*  If the function cannot compress 'src' into a more limited 'dst' budget,
*  compression stops *immediately*, and the function result is zero.
*  In which case, 'dst' content is undefined (invalid).
*      srcSize : max supported value is LZ4_MAX_INPUT_SIZE.
*      dstCapacity : size of buffer 'dst' (which must be already allocated)
*     @return  : the number of bytes written into buffer 'dst' (necessarily <= dstCapacity)
*                or 0 if compression fails
* Note : This function is protected against buffer overflow scenarios (never writes outside 'dst' buffer, nor read outside 'source' buffer).
*/
LZ4_compress_default :: (src: *u8, dst: *u8, srcSize: s32, dstCapacity: s32) -> s32 #foreign liblz4;

/*! LZ4_decompress_safe() :
*  compressedSize : is the exact complete size of the compressed block.
*  dstCapacity : is the size of destination buffer (which must be already allocated), presumed an upper bound of decompressed size.
* @return : the number of bytes decompressed into destination buffer (necessarily <= dstCapacity)
*           If destination buffer is not large enough, decoding will stop and output an error code (negative value).
*           If the source stream is detected malformed, the function will stop decoding and return a negative result.
* Note 1 : This function is protected against malicious data packets :
*          it will never writes outside 'dst' buffer, nor read outside 'source' buffer,
*          even if the compressed block is maliciously modified to order the decoder to do these actions.
*          In such case, the decoder stops immediately, and considers the compressed block malformed.
* Note 2 : compressedSize and dstCapacity must be provided to the function, the compressed block does not contain them.
*          The implementation is free to send / store / derive this information in whichever way is most beneficial.
*          If there is a need for a different format which bundles together both compressed data and its metadata, consider looking at lz4frame.h instead.
*/
LZ4_decompress_safe :: (src: *u8, dst: *u8, compressedSize: s32, dstCapacity: s32) -> s32 #foreign liblz4;

/*! LZ4_compressBound() :
Provides the maximum size that LZ4 compression may output in a "worst case" scenario (input data not compressible)
This function is primarily useful for memory allocation purposes (destination buffer size).
Macro LZ4_COMPRESSBOUND() is also provided for compilation-time evaluation (stack memory allocation for example).
Note that LZ4_compress_default() compresses faster when dstCapacity is >= LZ4_compressBound(srcSize)
inputSize  : max supported value is LZ4_MAX_INPUT_SIZE
return : maximum output size in a "worst case" scenario
or 0, if input size is incorrect (too large or negative)
*/
LZ4_compressBound :: (inputSize: s32) -> s32 #foreign liblz4;

/*! LZ4_compress_fast() :
Same as LZ4_compress_default(), but allows selection of "acceleration" factor.
The larger the acceleration value, the faster the algorithm, but also the lesser the compression.
It's a trade-off. It can be fine tuned, with each successive value providing roughly +~3% to speed.
An acceleration value of "1" is the same as regular LZ4_compress_default()
Values <= 0 will be replaced by LZ4_ACCELERATION_DEFAULT (currently == 1, see lz4.c).
Values > LZ4_ACCELERATION_MAX will be replaced by LZ4_ACCELERATION_MAX (currently == 65537, see lz4.c).
*/
LZ4_compress_fast :: (src: *u8, dst: *u8, srcSize: s32, dstCapacity: s32, acceleration: s32) -> s32 #foreign liblz4;

/*! LZ4_compress_fast_extState() :
*  Same as LZ4_compress_fast(), using an externally allocated memory space for its state.
*  Use LZ4_sizeofState() to know how much memory must be allocated,
*  and allocate it on 8-bytes boundaries (using `malloc()` typically).
*  Then, provide this buffer as `void* state` to compression function.
*/
LZ4_sizeofState :: () -> s32 #foreign liblz4;
LZ4_compress_fast_extState :: (state: *void, src: *u8, dst: *u8, srcSize: s32, dstCapacity: s32, acceleration: s32) -> s32 #foreign liblz4;

/*! LZ4_compress_destSize() :
*  Reverse the logic : compresses as much data as possible from 'src' buffer
*  into already allocated buffer 'dst', of size >= 'targetDestSize'.
*  This function either compresses the entire 'src' content into 'dst' if it's large enough,
*  or fill 'dst' buffer completely with as much data as possible from 'src'.
*  note: acceleration parameter is fixed to "default".
*
* *srcSizePtr : will be modified to indicate how many bytes where read from 'src' to fill 'dst'.
*               New value is necessarily <= input value.
* @return : Nb bytes written into 'dst' (necessarily <= targetDestSize)
*           or 0 if compression fails.
*
* Note : from v1.8.2 to v1.9.1, this function had a bug (fixed un v1.9.2+):
*        the produced compressed content could, in specific circumstances,
*        require to be decompressed into a destination buffer larger
*        by at least 1 byte than the content to decompress.
*        If an application uses `LZ4_compress_destSize()`,
*        it's highly recommended to update liblz4 to v1.9.2 or better.
*        If this can't be done or ensured,
*        the receiving decompression function should provide
*        a dstCapacity which is > decompressedSize, by at least 1 byte.
*        See https://github.com/lz4/lz4/issues/859 for details
*/
LZ4_compress_destSize :: (src: *u8, dst: *u8, srcSizePtr: *s32, targetDstSize: s32) -> s32 #foreign liblz4;

/*! LZ4_decompress_safe_partial() :
*  Decompress an LZ4 compressed block, of size 'srcSize' at position 'src',
*  into destination buffer 'dst' of size 'dstCapacity'.
*  Up to 'targetOutputSize' bytes will be decoded.
*  The function stops decoding on reaching this objective.
*  This can be useful to boost performance
*  whenever only the beginning of a block is required.
*
* @return : the number of bytes decoded in `dst` (necessarily <= targetOutputSize)
*           If source stream is detected malformed, function returns a negative result.
*
*  Note 1 : @return can be < targetOutputSize, if compressed block contains less data.
*
*  Note 2 : targetOutputSize must be <= dstCapacity
*
*  Note 3 : this function effectively stops decoding on reaching targetOutputSize,
*           so dstCapacity is kind of redundant.
*           This is because in older versions of this function,
*           decoding operation would still write complete sequences.
*           Therefore, there was no guarantee that it would stop writing at exactly targetOutputSize,
*           it could write more bytes, though only up to dstCapacity.
*           Some "margin" used to be required for this operation to work properly.
*           Thankfully, this is no longer necessary.
*           The function nonetheless keeps the same signature, in an effort to preserve API compatibility.
*
*  Note 4 : If srcSize is the exact size of the block,
*           then targetOutputSize can be any value,
*           including larger than the block's decompressed size.
*           The function will, at most, generate block's decompressed size.
*
*  Note 5 : If srcSize is _larger_ than block's compressed size,
*           then targetOutputSize **MUST** be <= block's decompressed size.
*           Otherwise, *silent corruption will occur*.
*/
LZ4_decompress_safe_partial :: (src: *u8, dst: *u8, srcSize: s32, targetOutputSize: s32, dstCapacity: s32) -> s32 #foreign liblz4;

/*-*********************************************
*  Streaming Compression Functions
***********************************************/
LZ4_stream_t :: LZ4_stream_u;

LZ4_createStream :: () -> *LZ4_stream_t #foreign liblz4;
LZ4_freeStream :: (streamPtr: *LZ4_stream_t) -> s32 #foreign liblz4;

/*! LZ4_resetStream_fast() : v1.9.0+
*  Use this to prepare an LZ4_stream_t for a new chain of dependent blocks
*  (e.g., LZ4_compress_fast_continue()).
*
*  An LZ4_stream_t must be initialized once before usage.
*  This is automatically done when created by LZ4_createStream().
*  However, should the LZ4_stream_t be simply declared on stack (for example),
*  it's necessary to initialize it first, using LZ4_initStream().
*
*  After init, start any new stream with LZ4_resetStream_fast().
*  A same LZ4_stream_t can be re-used multiple times consecutively
*  and compress multiple streams,
*  provided that it starts each new stream with LZ4_resetStream_fast().
*
*  LZ4_resetStream_fast() is much faster than LZ4_initStream(),
*  but is not compatible with memory regions containing garbage data.
*
*  Note: it's only useful to call LZ4_resetStream_fast()
*        in the context of streaming compression.
*        The *extState* functions perform their own resets.
*        Invoking LZ4_resetStream_fast() before is redundant, and even counterproductive.
*/
LZ4_resetStream_fast :: (streamPtr: *LZ4_stream_t) -> void #foreign liblz4;

/*! LZ4_loadDict() :
*  Use this function to reference a static dictionary into LZ4_stream_t.
*  The dictionary must remain available during compression.
*  LZ4_loadDict() triggers a reset, so any previous data will be forgotten.
*  The same dictionary will have to be loaded on decompression side for successful decoding.
*  Dictionary are useful for better compression of small data (KB range).
*  While LZ4 accept any input as dictionary,
*  results are generally better when using Zstandard's Dictionary Builder.
*  Loading a size of 0 is allowed, and is the same as reset.
* @return : loaded dictionary size, in bytes (necessarily <= 64 KB)
*/
LZ4_loadDict :: (streamPtr: *LZ4_stream_t, dictionary: *u8, dictSize: s32) -> s32 #foreign liblz4;

/*! LZ4_compress_fast_continue() :
*  Compress 'src' content using data from previously compressed blocks, for better compression ratio.
* 'dst' buffer must be already allocated.
*  If dstCapacity >= LZ4_compressBound(srcSize), compression is guaranteed to succeed, and runs faster.
*
* @return : size of compressed block
*           or 0 if there is an error (typically, cannot fit into 'dst').
*
*  Note 1 : Each invocation to LZ4_compress_fast_continue() generates a new block.
*           Each block has precise boundaries.
*           Each block must be decompressed separately, calling LZ4_decompress_*() with relevant metadata.
*           It's not possible to append blocks together and expect a single invocation of LZ4_decompress_*() to decompress them together.
*
*  Note 2 : The previous 64KB of source data is __assumed__ to remain present, unmodified, at same address in memory !
*
*  Note 3 : When input is structured as a double-buffer, each buffer can have any size, including < 64 KB.
*           Make sure that buffers are separated, by at least one byte.
*           This construction ensures that each block only depends on previous block.
*
*  Note 4 : If input buffer is a ring-buffer, it can have any size, including < 64 KB.
*
*  Note 5 : After an error, the stream status is undefined (invalid), it can only be reset or freed.
*/
LZ4_compress_fast_continue :: (streamPtr: *LZ4_stream_t, src: *u8, dst: *u8, srcSize: s32, dstCapacity: s32, acceleration: s32) -> s32 #foreign liblz4;

/*! LZ4_saveDict() :
*  If last 64KB data cannot be guaranteed to remain available at its current memory location,
*  save it into a safer place (char* safeBuffer).
*  This is schematically equivalent to a memcpy() followed by LZ4_loadDict(),
*  but is much faster, because LZ4_saveDict() doesn't need to rebuild tables.
* @return : saved dictionary size in bytes (necessarily <= maxDictSize), or 0 if error.
*/
LZ4_saveDict :: (streamPtr: *LZ4_stream_t, safeBuffer: *u8, maxDictSize: s32) -> s32 #foreign liblz4;

/*-**********************************************
*  Streaming Decompression Functions
*  Bufferless synchronous API
************************************************/
LZ4_streamDecode_t :: LZ4_streamDecode_u;

LZ4_createStreamDecode :: () -> *LZ4_streamDecode_t #foreign liblz4;
LZ4_freeStreamDecode :: (LZ4_stream: *LZ4_streamDecode_t) -> s32 #foreign liblz4;

/*! LZ4_setStreamDecode() :
*  An LZ4_streamDecode_t context can be allocated once and re-used multiple times.
*  Use this function to start decompression of a new stream of blocks.
*  A dictionary can optionally be set. Use NULL or size 0 for a reset order.
*  Dictionary is presumed stable : it must remain accessible and unmodified during next decompression.
* @return : 1 if OK, 0 if error
*/
LZ4_setStreamDecode :: (LZ4_streamDecode: *LZ4_streamDecode_t, dictionary: *u8, dictSize: s32) -> s32 #foreign liblz4;

/*! LZ4_decoderRingBufferSize() : v1.8.2+
*  Note : in a ring buffer scenario (optional),
*  blocks are presumed decompressed next to each other
*  up to the moment there is not enough remaining space for next block (remainingSize < maxBlockSize),
*  at which stage it resumes from beginning of ring buffer.
*  When setting such a ring buffer for streaming decompression,
*  provides the minimum size of this ring buffer
*  to be compatible with any source respecting maxBlockSize condition.
* @return : minimum ring buffer size,
*           or 0 if there is an error (invalid maxBlockSize).
*/
LZ4_decoderRingBufferSize :: (maxBlockSize: s32) -> s32 #foreign liblz4;

/*! LZ4_decompress_*_continue() :
*  These decoding functions allow decompression of consecutive blocks in "streaming" mode.
*  A block is an unsplittable entity, it must be presented entirely to a decompression function.
*  Decompression functions only accepts one block at a time.
*  The last 64KB of previously decoded data *must* remain available and unmodified at the memory position where they were decoded.
*  If less than 64KB of data has been decoded, all the data must be present.
*
*  Special : if decompression side sets a ring buffer, it must respect one of the following conditions :
*  - Decompression buffer size is _at least_ LZ4_decoderRingBufferSize(maxBlockSize).
*    maxBlockSize is the maximum size of any single block. It can have any value > 16 bytes.
*    In which case, encoding and decoding buffers do not need to be synchronized.
*    Actually, data can be produced by any source compliant with LZ4 format specification, and respecting maxBlockSize.
*  - Synchronized mode :
*    Decompression buffer size is _exactly_ the same as compression buffer size,
*    and follows exactly same update rule (block boundaries at same positions),
*    and decoding function is provided with exact decompressed size of each block (exception for last block of the stream),
*    _then_ decoding & encoding ring buffer can have any size, including small ones ( < 64 KB).
*  - Decompression buffer is larger than encoding buffer, by a minimum of maxBlockSize more bytes.
*    In which case, encoding and decoding buffers do not need to be synchronized,
*    and encoding ring buffer can have any size, including small ones ( < 64 KB).
*
*  Whenever these conditions are not possible,
*  save the last 64KB of decoded data into a safe buffer where it can't be modified during decompression,
*  then indicate where this data is saved using LZ4_setStreamDecode(), before decompressing next block.
*/
LZ4_decompress_safe_continue :: (LZ4_streamDecode: *LZ4_streamDecode_t, src: *u8, dst: *u8, srcSize: s32, dstCapacity: s32) -> s32 #foreign liblz4;

/*! LZ4_decompress_*_usingDict() :
*  These decoding functions work the same as
*  a combination of LZ4_setStreamDecode() followed by LZ4_decompress_*_continue()
*  They are stand-alone, and don't need an LZ4_streamDecode_t structure.
*  Dictionary is presumed stable : it must remain accessible and unmodified during decompression.
*  Performance tip : Decompression speed can be substantially increased
*                    when dst == dictStart + dictSize.
*/
LZ4_decompress_safe_usingDict :: (src: *u8, dst: *u8, srcSize: s32, dstCapacity: s32, dictStart: *u8, dictSize: s32) -> s32 #foreign liblz4;

LZ4_decompress_safe_partial_usingDict :: (src: *u8, dst: *u8, compressedSize: s32, targetOutputSize: s32, maxOutputSize: s32, dictStart: *u8, dictSize: s32) -> s32 #foreign liblz4;

LZ4_i8 :: s8;
LZ4_byte :: u8;
LZ4_u16 :: u16;
LZ4_u32 :: u32;

LZ4_stream_t_internal :: struct {
    hashTable:     [4096] LZ4_u32;
    dictionary:    *LZ4_byte;
    dictCtx:       *LZ4_stream_t_internal;
    currentOffset: LZ4_u32;
    tableType:     LZ4_u32;
    dictSize:      LZ4_u32;
}

LZ4_stream_u :: union {
    minStateSize:      [16416] u8;
    internal_donotuse: LZ4_stream_t_internal;
}

/*! LZ4_initStream() : v1.9.0+
*  An LZ4_stream_t structure must be initialized at least once.
*  This is automatically done when invoking LZ4_createStream(),
*  but it's not when the structure is simply declared on stack (for example).
*
*  Use LZ4_initStream() to properly initialize a newly declared LZ4_stream_t.
*  It can also initialize any arbitrary buffer of sufficient size,
*  and will @return a pointer of proper type upon initialization.
*
*  Note : initialization fails if size and alignment conditions are not respected.
*         In which case, the function will @return NULL.
*  Note2: An LZ4_stream_t structure guarantees correct alignment and size.
*  Note3: Before v1.9.0, use LZ4_resetStream() instead
**/
LZ4_initStream :: (buffer: *void, size: u64) -> *LZ4_stream_t #foreign liblz4;

/*! LZ4_streamDecode_t :
*  Never ever use below internal definitions directly !
*  These definitions are not API/ABI safe, and may change in future versions.
*  If you need static allocation, declare or allocate an LZ4_streamDecode_t object.
**/
LZ4_streamDecode_t_internal :: struct {
    externalDict: *LZ4_byte;
    prefixEnd:    *LZ4_byte;
    extDictSize:  u64;
    prefixSize:   u64;
}

LZ4_streamDecode_u :: union {
    minStateSize:      [32] u8;
    internal_donotuse: LZ4_streamDecode_t_internal;
}

/*! Obsolete compression functions (since v1.7.3) */
LZ4_compress :: (src: *u8, dest: *u8, srcSize: s32) -> s32 #foreign liblz4;
LZ4_compress_limitedOutput :: (src: *u8, dest: *u8, srcSize: s32, maxOutputSize: s32) -> s32 #foreign liblz4;
LZ4_compress_withState :: (state: *void, source: *u8, dest: *u8, inputSize: s32) -> s32 #foreign liblz4;
LZ4_compress_limitedOutput_withState :: (state: *void, source: *u8, dest: *u8, inputSize: s32, maxOutputSize: s32) -> s32 #foreign liblz4;
LZ4_compress_continue :: (LZ4_streamPtr: *LZ4_stream_t, source: *u8, dest: *u8, inputSize: s32) -> s32 #foreign liblz4;
LZ4_compress_limitedOutput_continue :: (LZ4_streamPtr: *LZ4_stream_t, source: *u8, dest: *u8, inputSize: s32, maxOutputSize: s32) -> s32 #foreign liblz4;

/*! Obsolete decompression functions (since v1.8.0) */
LZ4_uncompress :: (source: *u8, dest: *u8, outputSize: s32) -> s32 #foreign liblz4;
LZ4_uncompress_unknownOutputSize :: (source: *u8, dest: *u8, isize: s32, maxOutputSize: s32) -> s32 #foreign liblz4;

/* Obsolete streaming functions (since v1.7.0)
* degraded functionality; do not use!
*
* In order to perform streaming compression, these functions depended on data
* that is no longer tracked in the state. They have been preserved as well as
* possible: using them will still produce a correct output. However, they don't
* actually retain any history between compression calls. The compression ratio
* achieved will therefore be no better than compressing each chunk
* independently.
*/
LZ4_create :: (inputBuffer: *u8) -> *void #foreign liblz4;
LZ4_sizeofStreamState :: () -> s32 #foreign liblz4;
LZ4_resetStreamState :: (state: *void, inputBuffer: *u8) -> s32 #foreign liblz4;
LZ4_slideInputBuffer :: (state: *void) -> *u8 #foreign liblz4;

/*! Obsolete streaming decoding functions (since v1.7.0) */
LZ4_decompress_safe_withPrefix64k :: (src: *u8, dst: *u8, compressedSize: s32, maxDstSize: s32) -> s32 #foreign liblz4;
LZ4_decompress_fast_withPrefix64k :: (src: *u8, dst: *u8, originalSize: s32) -> s32 #foreign liblz4;

/*! Obsolete LZ4_decompress_fast variants (since v1.9.0) :
*  These functions used to be faster than LZ4_decompress_safe(),
*  but this is no longer the case. They are now slower.
*  This is because LZ4_decompress_fast() doesn't know the input size,
*  and therefore must progress more cautiously into the input buffer to not read beyond the end of block.
*  On top of that `LZ4_decompress_fast()` is not protected vs malformed or malicious inputs, making it a security liability.
*  As a consequence, LZ4_decompress_fast() is strongly discouraged, and deprecated.
*
*  The last remaining LZ4_decompress_fast() specificity is that
*  it can decompress a block without knowing its compressed size.
*  Such functionality can be achieved in a more secure manner
*  by employing LZ4_decompress_safe_partial().
*
*  Parameters:
*  originalSize : is the uncompressed size to regenerate.
*                 `dst` must be already allocated, its size must be >= 'originalSize' bytes.
* @return : number of bytes read from source buffer (== compressed size).
*           The function expects to finish at block's end exactly.
*           If the source stream is detected malformed, the function stops decoding and returns a negative result.
*  note : LZ4_decompress_fast*() requires originalSize. Thanks to this information, it never writes past the output buffer.
*         However, since it doesn't know its 'src' size, it may read an unknown amount of input, past input buffer bounds.
*         Also, since match offsets are not validated, match reads from 'src' may underflow too.
*         These issues never happen if input (compressed) data is correct.
*         But they may happen if input data is invalid (error or intentional tampering).
*         As a consequence, use these functions in trusted environments with trusted data **only**.
*/
LZ4_decompress_fast :: (src: *u8, dst: *u8, originalSize: s32) -> s32 #foreign liblz4;

LZ4_decompress_fast_continue :: (LZ4_streamDecode: *LZ4_streamDecode_t, src: *u8, dst: *u8, originalSize: s32) -> s32 #foreign liblz4;

LZ4_decompress_fast_usingDict :: (src: *u8, dst: *u8, originalSize: s32, dictStart: *u8, dictSize: s32) -> s32 #foreign liblz4;

/*! LZ4_resetStream() :
*  An LZ4_stream_t structure must be initialized at least once.
*  This is done with LZ4_initStream(), or LZ4_resetStream().
*  Consider switching to LZ4_initStream(),
*  invoking LZ4_resetStream() will trigger deprecation warnings in the future.
*/
LZ4_resetStream :: (streamPtr: *LZ4_stream_t) -> void #foreign liblz4;

/*-************************************
*  Block Compression
**************************************/
/*! LZ4_compress_HC() :
*  Compress data from `src` into `dst`, using the powerful but slower "HC" algorithm.
* `dst` must be already allocated.
*  Compression is guaranteed to succeed if `dstCapacity >= LZ4_compressBound(srcSize)` (see "lz4.h")
*  Max supported `srcSize` value is LZ4_MAX_INPUT_SIZE (see "lz4.h")
* `compressionLevel` : any value between 1 and LZ4HC_CLEVEL_MAX will work.
*                      Values > LZ4HC_CLEVEL_MAX behave the same as LZ4HC_CLEVEL_MAX.
* @return : the number of bytes written into 'dst'
*           or 0 if compression fails.
*/
LZ4_compress_HC :: (src: *u8, dst: *u8, srcSize: s32, dstCapacity: s32, compressionLevel: s32) -> s32 #foreign liblz4;

/*! LZ4_compress_HC_extStateHC() :
*  Same as LZ4_compress_HC(), but using an externally allocated memory segment for `state`.
* `state` size is provided by LZ4_sizeofStateHC().
*  Memory segment must be aligned on 8-bytes boundaries (which a normal malloc() should do properly).
*/
LZ4_sizeofStateHC :: () -> s32 #foreign liblz4;
LZ4_compress_HC_extStateHC :: (stateHC: *void, src: *u8, dst: *u8, srcSize: s32, maxDstSize: s32, compressionLevel: s32) -> s32 #foreign liblz4;

/*! LZ4_compress_HC_destSize() : v1.9.0+
*  Will compress as much data as possible from `src`
*  to fit into `targetDstSize` budget.
*  Result is provided in 2 parts :
* @return : the number of bytes written into 'dst' (necessarily <= targetDstSize)
*           or 0 if compression fails.
* `srcSizePtr` : on success, *srcSizePtr is updated to indicate how much bytes were read from `src`
*/
LZ4_compress_HC_destSize :: (stateHC: *void, src: *u8, dst: *u8, srcSizePtr: *s32, targetDstSize: s32, compressionLevel: s32) -> s32 #foreign liblz4;

/*-************************************
*  Streaming Compression
*  Bufferless synchronous API
**************************************/
LZ4_streamHC_t :: LZ4_streamHC_u;

/*! LZ4_createStreamHC() and LZ4_freeStreamHC() :
*  These functions create and release memory for LZ4 HC streaming state.
*  Newly created states are automatically initialized.
*  A same state can be used multiple times consecutively,
*  starting with LZ4_resetStreamHC_fast() to start a new stream of blocks.
*/
LZ4_createStreamHC :: () -> *LZ4_streamHC_t #foreign liblz4;
LZ4_freeStreamHC :: (streamHCPtr: *LZ4_streamHC_t) -> s32 #foreign liblz4;

/*
These functions compress data in successive blocks of any size,
using previous blocks as dictionary, to improve compression ratio.
One key assumption is that previous blocks (up to 64 KB) remain read-accessible while compressing next blocks.
There is an exception for ring buffers, which can be smaller than 64 KB.
Ring-buffer scenario is automatically detected and handled within LZ4_compress_HC_continue().

Before starting compression, state must be allocated and properly initialized.
LZ4_createStreamHC() does both, though compression level is set to LZ4HC_CLEVEL_DEFAULT.

Selecting the compression level can be done with LZ4_resetStreamHC_fast() (starts a new stream)
or LZ4_setCompressionLevel() (anytime, between blocks in the same stream) (experimental).
LZ4_resetStreamHC_fast() only works on states which have been properly initialized at least once,
which is automatically the case when state is created using LZ4_createStreamHC().

After reset, a first "fictional block" can be designated as initial dictionary,
using LZ4_loadDictHC() (Optional).

Invoke LZ4_compress_HC_continue() to compress each successive block.
The number of blocks is unlimited.
Previous input blocks, including initial dictionary when present,
must remain accessible and unmodified during compression.

It's allowed to update compression level anytime between blocks,
using LZ4_setCompressionLevel() (experimental).

'dst' buffer should be sized to handle worst case scenarios
(see LZ4_compressBound(), it ensures compression success).
In case of failure, the API does not guarantee recovery,
so the state _must_ be reset.
To ensure compression success
whenever `dst` buffer size cannot be made >= LZ4_compressBound(),
consider using LZ4_compress_HC_continue_destSize().

Whenever previous input blocks can't be preserved unmodified in-place during compression of next blocks,
it's possible to copy the last blocks into a more stable memory space, using LZ4_saveDictHC().
Return value of LZ4_saveDictHC() is the size of dictionary effectively saved into 'safeBuffer' (<= 64 KB)

After completing a streaming compression,
it's possible to start a new stream of blocks, using the same LZ4_streamHC_t state,
just by resetting it, using LZ4_resetStreamHC_fast().
*/
LZ4_resetStreamHC_fast :: (streamHCPtr: *LZ4_streamHC_t, compressionLevel: s32) -> void #foreign liblz4;
LZ4_loadDictHC :: (streamHCPtr: *LZ4_streamHC_t, dictionary: *u8, dictSize: s32) -> s32 #foreign liblz4;

LZ4_compress_HC_continue :: (streamHCPtr: *LZ4_streamHC_t, src: *u8, dst: *u8, srcSize: s32, maxDstSize: s32) -> s32 #foreign liblz4;

/*! LZ4_compress_HC_continue_destSize() : v1.9.0+
*  Similar to LZ4_compress_HC_continue(),
*  but will read as much data as possible from `src`
*  to fit into `targetDstSize` budget.
*  Result is provided into 2 parts :
* @return : the number of bytes written into 'dst' (necessarily <= targetDstSize)
*           or 0 if compression fails.
* `srcSizePtr` : on success, *srcSizePtr will be updated to indicate how much bytes were read from `src`.
*           Note that this function may not consume the entire input.
*/
LZ4_compress_HC_continue_destSize :: (LZ4_streamHCPtr: *LZ4_streamHC_t, src: *u8, dst: *u8, srcSizePtr: *s32, targetDstSize: s32) -> s32 #foreign liblz4;

LZ4_saveDictHC :: (streamHCPtr: *LZ4_streamHC_t, safeBuffer: *u8, maxDictSize: s32) -> s32 #foreign liblz4;

LZ4HC_CCtx_internal :: struct {
    hashTable:        [32768] LZ4_u32;
    chainTable:       [65536] LZ4_u16;
    end:              *LZ4_byte; /* next block here to continue on current prefix */
    prefixStart:      *LZ4_byte; /* Indexes relative to this position */
    dictStart:        *LZ4_byte; /* alternate reference for extDict */
    dictLimit:        LZ4_u32; /* below that point, need extDict */
    lowLimit:         LZ4_u32; /* below that point, no more dict */
    nextToUpdate:     LZ4_u32; /* index from which to continue dictionary update */
    compressionLevel: s16;
    /* favor decompression speed if this flag set,
    otherwise, favor compression ratio */
    favorDecSpeed:    LZ4_i8;

    dirty:            LZ4_i8; /* stream has to be fully reset if this flag is set */
    dictCtx:          *LZ4HC_CCtx_internal;
}

LZ4_streamHC_u :: union {
    minStateSize:      [262200] u8;
    internal_donotuse: LZ4HC_CCtx_internal;
}

/* LZ4_initStreamHC() : v1.9.0+
* Required before first use of a statically allocated LZ4_streamHC_t.
* Before v1.9.0 : use LZ4_resetStreamHC() instead
*/
LZ4_initStreamHC :: (buffer: *void, size: u64) -> *LZ4_streamHC_t #foreign liblz4;

/* deprecated compression functions */
LZ4_compressHC :: (source: *u8, dest: *u8, inputSize: s32) -> s32 #foreign liblz4;
LZ4_compressHC_limitedOutput :: (source: *u8, dest: *u8, inputSize: s32, maxOutputSize: s32) -> s32 #foreign liblz4;
LZ4_compressHC2 :: (source: *u8, dest: *u8, inputSize: s32, compressionLevel: s32) -> s32 #foreign liblz4;
LZ4_compressHC2_limitedOutput :: (source: *u8, dest: *u8, inputSize: s32, maxOutputSize: s32, compressionLevel: s32) -> s32 #foreign liblz4;
LZ4_compressHC_withStateHC :: (state: *void, source: *u8, dest: *u8, inputSize: s32) -> s32 #foreign liblz4;
LZ4_compressHC_limitedOutput_withStateHC :: (state: *void, source: *u8, dest: *u8, inputSize: s32, maxOutputSize: s32) -> s32 #foreign liblz4;
LZ4_compressHC2_withStateHC :: (state: *void, source: *u8, dest: *u8, inputSize: s32, compressionLevel: s32) -> s32 #foreign liblz4;
LZ4_compressHC2_limitedOutput_withStateHC :: (state: *void, source: *u8, dest: *u8, inputSize: s32, maxOutputSize: s32, compressionLevel: s32) -> s32 #foreign liblz4;
LZ4_compressHC_continue :: (LZ4_streamHCPtr: *LZ4_streamHC_t, source: *u8, dest: *u8, inputSize: s32) -> s32 #foreign liblz4;
LZ4_compressHC_limitedOutput_continue :: (LZ4_streamHCPtr: *LZ4_streamHC_t, source: *u8, dest: *u8, inputSize: s32, maxOutputSize: s32) -> s32 #foreign liblz4;

LZ4_createHC :: (inputBuffer: *u8) -> *void #foreign liblz4;
LZ4_freeHC :: (LZ4HC_Data: *void) -> s32 #foreign liblz4;

LZ4_slideInputBufferHC :: (LZ4HC_Data: *void) -> *u8 #foreign liblz4;
LZ4_compressHC2_continue :: (LZ4HC_Data: *void, source: *u8, dest: *u8, inputSize: s32, compressionLevel: s32) -> s32 #foreign liblz4;
LZ4_compressHC2_limitedOutput_continue :: (LZ4HC_Data: *void, source: *u8, dest: *u8, inputSize: s32, maxOutputSize: s32, compressionLevel: s32) -> s32 #foreign liblz4;
LZ4_sizeofStreamStateHC :: () -> s32 #foreign liblz4;
LZ4_resetStreamStateHC :: (state: *void, inputBuffer: *u8) -> s32 #foreign liblz4;

/* LZ4_resetStreamHC() is now replaced by LZ4_initStreamHC().
* The intention is to emphasize the difference with LZ4_resetStreamHC_fast(),
* which is now the recommended function to start a new stream of blocks,
* but cannot be used to initialize a memory segment containing arbitrary garbage data.
*
* It is recommended to switch to LZ4_initStreamHC().
* LZ4_resetStreamHC() will generate deprecation warnings in a future version.
*/
LZ4_resetStreamHC :: (streamHCPtr: *LZ4_streamHC_t, compressionLevel: s32) -> void #foreign liblz4;

#scope_file


#if OS == .WINDOWS  liblz4 :: #library "windows/lib/liblz4";
#if OS == .MACOS    liblz4 :: #library "macos/lib/liblz4";
#if OS == .LINUX    liblz4 :: #library "linux/lib/liblz4";
#if OS == .ANDROID  liblz4 :: #library "android/lib/liblz4";

