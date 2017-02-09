From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: Re: [PATCH v7 0/5] Update LZ4 compressor module
Date: Thu, 9 Feb 2017 12:05:40 +0100
Message-ID: <20170209110540.GC3575@bierbaron.springfield.local>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1486321748-19085-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170208233121.GA16728@bbox>
 <20170209002436.GA103792@gmail.com>
 <20170209052425.GA4678@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org,
        bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170209052425.GA4678@zzz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Eric,

On Wed, Feb 08, 2017 at 09:24:25PM -0800, Eric Biggers wrote:
> Also I noticed another bug, this time in LZ4_count():
> 
> > #if defined(CONFIG_64BIT)
> > #define LZ4_ARCH64 1
> > #else
> > #define LZ4_ARCH64 0
> > #endif
> ...
> > #ifdef LZ4_ARCH64
> >        if ((pIn < (pInLimit-3))
> >                && (LZ4_read32(pMatch) == LZ4_read32(pIn))) {
> >                pIn += 4; pMatch += 4;
> >        }
> > #endif
> 
> Because of how LZ4_ARCH64 is defined, it needs to be '#if LZ4_ARCH64'.
> 
> But I also think the way upstream LZ4 does 64-bit detection could have just been
> left as-is; it has a function which gets inlined:
> 
> 	static unsigned LZ4_64bits(void) { return sizeof(void*)==8; }
> 
> Eric

does this apply for LZ4_isLittleEndian() as well? As a reminder:
	
	static unsigned LZ4_isLittleEndian(void)
	{
		/* don't use static : performance detrimental */
		const union { U32 u; BYTE c[4]; } one = { 1 };

		return one.c[0];
	}

It is surely easier to read and understand using these functions in favor of the macros.

Thanks,

Sven
