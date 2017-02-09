From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: Re: [PATCH v7 0/5] Update LZ4 compressor module
Date: Thu, 9 Feb 2017 12:02:11 +0100
Message-ID: <20170209110211.GB3575@bierbaron.springfield.local>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1486321748-19085-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170208233121.GA16728@bbox>
 <20170209002436.GA103792@gmail.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:64086 "EHLO
        mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751777AbdBILCS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 06:02:18 -0500
Content-Disposition: inline
In-Reply-To: <20170209002436.GA103792@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey Eric,

On Wed, Feb 08, 2017 at 04:24:36PM -0800, Eric Biggers wrote:
> On Thu, Feb 09, 2017 at 08:31:21AM +0900, Minchan Kim wrote:
> > 
> > Today, I did zram-lz4 performance test with fio in current mmotm and
> > found it makes regression about 20%.
> > 
> 
> This may or may not be the cause of the specific regression you're observing,
> but I just noticed that the proposed patch drops a lot of FORCEINLINE
> annotations from upstream LZ4.  The FORCEINLINE's are there for a reason,
> especially for the main decompression and compression functions which are
> basically "templates" that take in different sets of constant parameters, and
> should be left in.  We should #define FORCEINLINE to __always_inline somewhere,
> or just do a s/FORCEINLINE/__always_inline/g.
>

I generally just replaced "FORCE_INLINE" by "static inline". At least I thought so.
I rechecked and realised, I missed at least two of them (why did I not just use "search+replace"?).
So I think it's maybe safer and easier to eventually just use "FORCE_INLINE"
with the definition you suggested. Will try that.
 
> Note that the upstream LZ4 code is very carefully optimized, so we should not,
> in general, be changing things like when functions are force-inlined, what the
> hash table size is, etc.
> 
> [Also, for some reason linux-crypto is apparently still not receiving patch 1/5
> in the series.  It's missing from the linux-crypto archive at
> http://www.spinics.net/lists/linux-crypto/, so it's not just me.]
> 

I don't really know what to do about this. I think the matter is the size of the E-Mail.
Are there filters or something like that? Since in linux-kernel the patch seems to get delivered.
I could otherwise CC you if you wish.

Thanks,

Sven
