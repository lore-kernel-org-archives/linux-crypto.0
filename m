From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v7 0/5] Update LZ4 compressor module
Date: Thu, 9 Feb 2017 10:20:24 -0800
Message-ID: <20170209182024.GA92711@gmail.com>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1486321748-19085-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170208233121.GA16728@bbox>
 <20170209002436.GA103792@gmail.com>
 <20170209052425.GA4678@zzz>
 <20170209110540.GC3575@bierbaron.springfield.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org,
        bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com
To: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170209110540.GC3575@bierbaron.springfield.local>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Feb 09, 2017 at 12:05:40PM +0100, Sven Schmidt wrote:
> > Because of how LZ4_ARCH64 is defined, it needs to be '#if LZ4_ARCH64'.
> > 
> > But I also think the way upstream LZ4 does 64-bit detection could have just been
> > left as-is; it has a function which gets inlined:
> > 
> > 	static unsigned LZ4_64bits(void) { return sizeof(void*)==8; }
> > 
> > Eric
> 
> does this apply for LZ4_isLittleEndian() as well? As a reminder:
> 	
> 	static unsigned LZ4_isLittleEndian(void)
> 	{
> 		/* don't use static : performance detrimental */
> 		const union { U32 u; BYTE c[4]; } one = { 1 };
> 
> 		return one.c[0];
> 	}
> 
> It is surely easier to read and understand using these functions in favor of the macros.

Yes, it makes sense to retain LZ4_isLittleEndian() too, mainly so that the call
sites don't need to be changed and we have less chance of introducing bugs.

I also believe the *implementation* of LZ4_isLittleEndian() using the union
"hack" to detecting endianness works fine and will get optimized correctly,
though we could replace it with an #ifdef __LITTLE_ENDIAN__ if we wanted to.  (I
am sure that upstream LZ4 would do that if it was guaranteed to work, but
upstream LZ4 needs to detect endianness reliably across many more different
compilers, compiler versions, and platforms than the Linux kernel does, and
there is no standard preprocessor macro for doing so.)

Eric
