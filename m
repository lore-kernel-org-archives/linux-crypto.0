From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: Re: [PATCH] lz4: fix performance regressions
Date: Tue, 14 Feb 2017 11:33:44 +0100
Message-ID: <20170214103344.GA5475@bierbaron.springfield.local>
References: <20170210001311.GA25078@bbox>
 <1486898178-17125-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1486898178-17125-2-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170212233802.GA29621@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: minchan@kernel.org, akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, anton@enomsg.org, ccross@android.com,
        keescook@chromium.org, tony.luck@intel.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170212233802.GA29621@zzz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Eric,

On Sun, Feb 12, 2017 at 03:38:02PM -0800, Eric Biggers wrote:
> Hi Sven,
> 
> On Sun, Feb 12, 2017 at 12:16:18PM +0100, Sven Schmidt wrote:
> >  /*-************************************
> >   *	Reading and writing into memory
> >   **************************************/
> > +typedef union {
> > +	U16 u16;
> > +	U32 u32;
> > +	size_t uArch;
> > +} __packed unalign;
> > 
> > -static inline U16 LZ4_read16(const void *memPtr)
> > +static FORCE_INLINE __maybe_unused U16 LZ4_read16(const void *ptr)
> >  {
> > -	U16 val;
> > -
> > -	memcpy(&val, memPtr, sizeof(val));
> > -
> > -	return val;
> > +	return ((const unalign *)ptr)->u16;
> >  }
> > 
> > -static inline U32 LZ4_read32(const void *memPtr)
> > +static FORCE_INLINE __maybe_unused U32 LZ4_read32(const void *ptr)
> >  {
> > -	U32 val;
> > -
> > -	memcpy(&val, memPtr, sizeof(val));
> > -
> > -	return val;
> > +	return ((const unalign *)ptr)->u32;
> >  }
> > 
> > -static inline size_t LZ4_read_ARCH(const void *memPtr)
> > +static FORCE_INLINE __maybe_unused size_t LZ4_read_ARCH(const void *ptr)
> >  {
> > -	size_t val;
> > -
> > -	memcpy(&val, memPtr, sizeof(val));
> > -
> > -	return val;
> > +	return ((const unalign *)ptr)->uArch;
> >  }
> > 
> > -static inline void LZ4_write16(void *memPtr, U16 value)
> > +static FORCE_INLINE __maybe_unused void LZ4_write16(void *memPtr, U16 value)
> >  {
> > -	memcpy(memPtr, &value, sizeof(value));
> > +	((unalign *)memPtr)->u16 = value;
> >  }
> > 
> > -static inline void LZ4_write32(void *memPtr, U32 value)
> > -{
> > -	memcpy(memPtr, &value, sizeof(value));
> > +static FORCE_INLINE __maybe_unused void LZ4_write32(void *memPtr, U32 value) {
> > +	((unalign *)memPtr)->u32 = value;
> >  }
> > 
> > -static inline U16 LZ4_readLE16(const void *memPtr)
> > +static FORCE_INLINE __maybe_unused U16 LZ4_readLE16(const void *memPtr)
> >  {
> > -#ifdef __LITTLE_ENDIAN__
> > +#if LZ4_LITTLE_ENDIAN
> >  	return LZ4_read16(memPtr);
> >  #else
> >  	const BYTE *p = (const BYTE *)memPtr;
> > @@ -137,19 +143,19 @@ static inline U16 LZ4_readLE16(const void *memPtr)
> >  #endif
> >  }
> 
> Since upstream LZ4 is intended to be compiled at -O3, this may allow it to get
> away with using memcpy() for unaligned memory accesses.  The reason it uses
> memcpy() is that, other than a byte-by-byte copy, it is the only portable way to
> express unaligned memory accesses.  But the Linux kernel is sometimes compiled
> optimized for size (-Os), and I wouldn't be *too* surprised if some of the
> memcpy()'s don't always get inlined then, which could be causing the performance
> regression being observed.  (Of course, this could be verified by checking
> whether CONFIG_CC_OPTIMIZE_FOR_SIZE=y is set, then reading the assembly.)
> 
> But I don't think accessing a __packed structure directly is the right
> alternative.  Instead, Linux already includes macros for unaligned memory
> accesses which have been optimized for every supported architecture.  Those
> should just be used instead, e.g. like this:
> 
> static FORCE_INLINE U16 LZ4_read16(const void *ptr)
> {
> 	return get_unaligned((const u16 *)ptr);
> }
> 
> static FORCE_INLINE U32 LZ4_read32(const void *ptr)
> {
> 	return get_unaligned((const u32 *)ptr);
> }
> 
> static FORCE_INLINE size_t LZ4_read_ARCH(const void *ptr)
> {
> 	return get_unaligned((const size_t *)ptr);
> }
> 
> static FORCE_INLINE void LZ4_write16(void *memPtr, U16 value)
> {
> 	put_unaligned(value, (u16 *)memPtr);
> }
> 
> static FORCE_INLINE void LZ4_write32(void *memPtr, U32 value)
> {
> 	put_unaligned(value, (u32 *)memPtr);
> }
> 
> static FORCE_INLINE U16 LZ4_readLE16(const void *memPtr)
> {
> 	return get_unaligned_le16(memPtr);
> }
> 
> static FORCE_INLINE void LZ4_writeLE16(void *memPtr, U16 value)
> {
> 	return put_unaligned_le16(value, memPtr);
> }
> 
> static FORCE_INLINE void LZ4_copy8(void *dst, const void *src)
> {
> 	if (LZ4_64bits()) {
> 		u64 a = get_unaligned((const u64 *)src);
> 		put_unaligned(a, (u64 *)dst);
> 	} else {
> 		u32 a = get_unaligned((const u32 *)src);
> 		u32 b = get_unaligned((const u32 *)src + 1);
> 		put_unaligned(a, (u32 *)dst);
> 		put_unaligned(b, (u32 *)dst + 1);
> 	}
> }
> 
> 
> Note that I dropped __maybe_unused as it's not needed on inline functions.
> That should be done everywhere else the patch proposes to add it too.
> 
> > -#if LZ4_ARCH64
> > -#ifdef __BIG_ENDIAN__
> > -#define LZ4_NBCOMMONBYTES(val) (__builtin_clzll(val) >> 3)
> > +static FORCE_INLINE unsigned int LZ4_NbCommonBytes(register size_t val)
> > +{
> > +#if LZ4_LITTLE_ENDIAN
> > +#if LZ4_ARCH64 /* 64 Bits Little Endian */
> > +#if defined(LZ4_FORCE_SW_BITCOUNT)
> > +	static const int DeBruijnBytePos[64] = {
> > +		0, 0, 0, 0, 0, 1, 1, 2, 0, 3, 1, 3, 1, 4, 2, 7,
> > +		0, 2, 3, 6, 1, 5, 3, 5, 1, 3, 4, 4, 2, 5, 6, 7,
> > +		7, 0, 1, 2, 3, 3, 4, 6, 2, 6, 5, 5, 3, 4, 5, 6,
> > +		7, 1, 2, 4, 6, 4, 4, 5, 7, 2, 6, 5, 7, 6, 7, 7
> > +	};
> > +
> > +	return DeBruijnBytePos[((U64)((val & -(long long)val)
> > +		* 0x0218A392CDABBD3FULL)) >> 58];
> >  #else
> > -#define LZ4_NBCOMMONBYTES(val) (__builtin_ctzll(val) >> 3)
> > -#endif
> > +	return (__builtin_ctzll((U64)val) >> 3);
> > +#endif /* defined(LZ4_FORCE_SW_BITCOUNT) */
> > +#else /* 32 Bits Little Endian */
> > +#if defined(LZ4_FORCE_SW_BITCOUNT)
> > +	static const int DeBruijnBytePos[32] = {
> > +		0, 0, 3, 0, 3, 1, 3, 0, 3, 2, 2, 1, 3, 2, 0, 1,
> > +		3, 3, 1, 2, 2, 2, 2, 0, 3, 1, 2, 0, 1, 0, 1, 1
> > +	};
> > +
> > +	return DeBruijnBytePos[((U32)((val & -(S32)val)
> > +		* 0x077CB531U)) >> 27];
> >  #else
> > -#ifdef __BIG_ENDIAN__
> > -#define LZ4_NBCOMMONBYTES(val) (__builtin_clz(val) >> 3)
> > +	return (__builtin_ctz((U32)val) >> 3);
> > +#endif /* defined(LZ4_FORCE_SW_BITCOUNT) */
> > +#endif /* LZ4_ARCH64 */
> > +#else /* Big Endian */
> > +#if LZ4_ARCH64 /* 64 Bits Big Endian */
> > +#if defined(LZ4_FORCE_SW_BITCOUNT)
> > +	unsigned int r;
> > +
> > +	if (!(val >> 32)) {
> > +		r = 4;
> > +	} else {
> > +		r = 0;
> > +		val >>= 32;
> > +	}
> > +
> > +	if (!(val >> 16)) {
> > +		r += 2;
> > +		val >>= 8;
> > +	} else {
> > +		val >>= 24;
> > +	}
> > +
> > +	r += (!val);
> > +
> > +	return r;
> >  #else
> > -#define LZ4_NBCOMMONBYTES(val) (__builtin_ctz(val) >> 3)
> > -#endif
> > -#endif
> > +	return (__builtin_clzll((U64)val) >> 3);
> > +#endif /* defined(LZ4_FORCE_SW_BITCOUNT) */
> > +#else /* 32 Bits Big Endian */
> > +#if defined(LZ4_FORCE_SW_BITCOUNT)
> > +	unsigned int r;
> > +
> > +	if (!(val >> 16)) {
> > +		r = 2;
> > +		val >>= 8;
> > +	} else {
> > +		r = 0;
> > +		val >>= 24;
> > +	}
> > +
> > +	r += (!val);
> > +
> > +	return r;
> > +#else
> > +	return (__builtin_clz((U32)val) >> 3);
> > +#endif /* defined(LZ4_FORCE_SW_BITCOUNT) */
> > +#endif /* LZ4_ARCH64 */
> > +#endif /* LZ4_LITTLE_ENDIAN */
> > +}
> 
> The reason LZ4_NbCommonBytes() in upstream LZ4 is so complicated is that it
> needs to provide portable fallbacks that work on *any* platform and compiler.
> This isn't needed in the Linux kernel, and it should just call the functions
> already defined that do the right thing:
> 
> static FORCE_INLINE unsigned int LZ4_NbCommonBytes(register size_t val)
> {
>         if (LZ4_isLittleEndian())
>                 return __ffs(val) >> 3;
>         else
>                 return (BITS_PER_LONG - 1 - __fls(val)) >> 3;
> }                      
> 
> To be clear, when I said that upstream LZ4 shouldn't generally be changed, I'm
> primarily talking about the core code, not the platform-specific parts.  What we
> need to do is define platform-specific stuff, like LZ4_read*(), LZ4_write*(),
> LZ4_NbCommonBytes(), LZ4_64bits(), and FORCE_INLINE, in a way that makes sense
> for the Linux kernel and the environment it's compiled in.  Also I think it's
> fine, and maybe even necessary for performance, to *add* inline or FORCE_INLINE
> in some places too, given that LZ4 in Linux may get compiled with a lower
> optimization level than that intended to be used for upstream LZ4 --- though it
> may be worth considering updating the Makefile to just always compile the LZ4
> files with -O3 instead.  What should be avoided is making unnecessary changes to
> the *users* of the platform-specific code or to the core (de)compression
> parameters or templates.
> 
> Eric

I'm very thankful for your effort here! I included all your proposed changes (as well as -O3 as compiler flag in the Makefile)
and noticed further improvements concerning the performance in ZRAM (compared to current LZ4 in 4.10 RC8 as well as the previous changes discussed
here). I would never have thought that the NBcommonBytes function can be re-written in such an easy way, since the current LZ4 in the kernel
uses similar approach checking for 64/32 bit and endianess.

Also, thanks for your very detailed remarks. That's really helpful to me.

Regards,

Sven
