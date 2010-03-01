From: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [PATCH v2] compiler: prevent dead store elimination
Date: Mon, 1 Mar 2010 10:29:44 +0100
Message-ID: <19339.35080.637800.292674@pilspetsen.it.uu.se>
References: <4B8984EE.8090605@gmail.com>
	<20100228095520.GA29531@one.firstfloor.org>
	<4B8A8D17.2040208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mikael Pettersson <mikpe@it.uu.se>, penberg@cs.helsinki.fi,
	Brian Gerst <brgerst@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Herbert@gondor.apana.org.au
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fanny.its.uu.se ([130.238.4.241]:8176 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab0CAJ35 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Mar 2010 04:29:57 -0500
In-Reply-To: <4B8A8D17.2040208@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Roel Kluin writes:
 > Due to optimization A call to memset() may be removed as a dead store when

_______________________^ lower-case a

 > the buffer is not used after its value is overwritten. The new function
 > secure_bzero() ensures a section of memory is padded with zeroes.
 > 
 > >From the GCC manual, section 5.37:
 > If your assembler instructions access memory in an unpredictable
 > fashion, add `memory' to the list of clobbered registers. This will
 > cause GCC to not keep memory values cached in registers across the
 > assembler instruction and not optimize stores or loads to that memory.

This paragraph, while accurate, is unrelated to the contents of this
patch. Note that in an asm(), a "memory" clobber (see barrier()) is
not at all the same thing as a memory operand "m"(...), which is what
we're using here. Just drop this bit.

 > Every byte in the [p,p+n[ range must be used. If you only use the
 > first byte, via e.g. asm("" :: "m"(*(char*)p)), then the compiler
 > _will_ skip scrubbing bytes beyond the first.
and then
 > This works with
 > gcc-3.2.3 up to gcc-4.4.3.

You've edited my comments and put them together in a way that doesn't
quite make sense. In particular, "This works" doesn't refer to the
previous text but the local-struct-of-variable-size trick. The text
should read something like:

To prevent a memset() from being eliminated, the compiler must belive
that the memory area is used after the memset(). Also, every byte in
the memory area must be used. If only the first byte is used, via e.g.
asm("" :: "m"(*(char*)p)), then the compiler _will_ skip scrubbing
bytes beyond the first.

The trick is to define a local type of the same size as the memory
area, and use it for the "m" operand in a dummy asm():

	static inline void fake_memory_use(void *p, size_t n)
	{
		struct __scrub { char c[n]; }
		asm("" : : "m"(*(struct __scrub *)p));
	}

This looks strange, n being a variable, but has been confirmed to
work with gcc-3.2.3 up to gcc-4.4.3.

 > diff --git a/include/linux/compiler.h b/include/linux/compiler.h
 > index 188fcae..2f14199 100644
 > --- a/include/linux/compiler.h
 > +++ b/include/linux/compiler.h
 > @@ -302,4 +302,15 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 >   */
 >  #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 >  
 > +/*
 > + * Dead store elimination is an optimization that may remove a write to a
 > + * buffer that is not used anymore. Use ARRAY_KEEP_STORE after a write when
 > + * the scrub is required for security reasons.
 > + */
 > +#define ARRAY_KEEP_STORE(p, n)				\

1. This doesn't need to be a macro. Please make it a static inline function.
2. Its function is to "fake" a use of a memory area, which allows us to prevent
   unwanted DSE elsewhere. So this should be fake_memory_use() or something.

 > +	do {						\
 > +		struct __scrub { typeof(*p) c[n]; };	\

The typeof(*p) suggestion doesn't work. It would require p to always be
a pointer type with an accurate (for memset) sizeof(*p). In general however
we'll memset some array described by a void*/size_t pair, and typeof in
that case is useless. The original'struct __scrub { char c[n]; };' was Ok.

 >  extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
 >  extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
 > +extern void secure_bzero(void *, __kernel_size_t);

Why is this __kernel_size_t and not just plain size_t? It's not
a user-space API.
