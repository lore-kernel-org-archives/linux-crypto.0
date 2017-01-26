From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: Re: [PATCH v5 0/5] Update LZ4 compressor module
Date: Thu, 26 Jan 2017 15:15:37 +0100
Message-ID: <20170126141537.GA7185@bierbaron.springfield.local>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1485417455-31726-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170126091953.GA2829@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, anton@enomsg.org, ccross@android.com,
        keescook@chromium.org, tony.luck@intel.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mxchg02.rrz.uni-hamburg.de ([134.100.38.112]:45707 "EHLO
        mxchg02.rrz.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752030AbdAZOPq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2017 09:15:46 -0500
Content-Disposition: inline
In-Reply-To: <20170126091953.GA2829@zzz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 26, 2017 at 01:19:53AM -0800, Eric Biggers wrote:
> On Thu, Jan 26, 2017 at 08:57:30AM +0100, Sven Schmidt wrote:
> > 
> > This patchset is for updating the LZ4 compression module to a version based
> > on LZ4 v1.7.3 allowing to use the fast compression algorithm aka LZ4 fast
> > which provides an "acceleration" parameter as a tradeoff between
> > high compression ratio and high compression speed.
> > 
> > We want to use LZ4 fast in order to support compression in lustre
> > and (mostly, based on that) investigate data reduction techniques in behalf of
> > storage systems.
> > 
> > Also, it will be useful for other users of LZ4 compression, as with LZ4 fast
> > it is possible to enable applications to use fast and/or high compression
> > depending on the usecase.
> > For instance, ZRAM is offering a LZ4 backend and could benefit from an updated
> > LZ4 in the kernel.
> > 
>

Hey Eric,
 
> Hi Sven,
> 
> [For some reason I didn't receive patch 1/5 and had to get it from patchwork...
> I'm not sure why.  I'm subscribed to linux-crypto but not linux-kernel.]

that's weird. I just experienced the first patch takes a little longer to get delivered because of its size.
Please let me know if the problem occurs again.
 
> The proposed patch defines LZ4_MEMORY_USAGE to 10 which means that LZ4
> compression will use a hash table of only 1024 bytes, containing only 256
> entries, to find matches.  This differs from upstream LZ4 1.7.3, which uses
> LZ4_MEMORY_USAGE of 14, as well as the previous LZ4 included in the Linux
> kernel, both of which specify the hash table size to be 16384 bytes, containing
> 4096 entries.
> 
> Given that varying the hash table size is a trade-off between memory usage,
> speed, and compression ratio, is this an intentional difference and has it been
> benchmarked?
> 

I believe I had some troubles with LZ4_MEMORY_USAGE of 14. But I may be wrong.
I will test that again and eventually adapt that value.

> Also, in lz4defs.h:
> 
> > #if defined(__x86_64__)
> >        typedef U64             reg_t;   /* 64-bits in x32 mode */
> > #else
> >        typedef size_t reg_t;    /* 32-bits in x32 mode */
> > #endif
> 
> Are you sure this really needed over just always using size_t?
>

No, actually there's just one use of that value and the upstream version uses size_t instead of reg_t 
in that particular place. So I will replace it with size_t.
 
> > #if LZ4_ARCH64
> > #ifdef __BIG_ENDIAN__
> > #define LZ4_NBCOMMONBYTES(val) (__builtin_clzll(val) >> 3)
> > #else
> > #define LZ4_NBCOMMONBYTES(val) (__builtin_clzll(val) >> 3)
> > #endif
> > #else
> > #ifdef __BIG_ENDIAN__
> > #define LZ4_NBCOMMONBYTES(val) (__builtin_clz(val) >> 3)
> > #else
> > #define LZ4_NBCOMMONBYTES(val) (__builtin_ctz(val) >> 3)
> > #endif
> > #endif
> 
> LZ4_NBCOMMONBYTES() is defined incorrectly for 64-bit little endian; it should
> be using __builtin_ctzll().
> 

Indeed! Using the same values in if and else does not make sense at all.
Thank you for pointing that one out. I will fix it.

> Nit: can you also clean up the weird indentation (e.g. double tabs) in
> lz4defs.h?
> 
> Thanks,
> 
> Eric
> 

I'm wondering why checkpatch does not point out this kind of styling problem?
I did fix that in the other files but I think I missed lz4defs.h. Will fix the indentation.

Thanks,

Sven
