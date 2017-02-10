From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v7 0/5] Update LZ4 compressor module
Date: Fri, 10 Feb 2017 09:14:23 +0900
Message-ID: <20170210001423.GB25078@bbox>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1486321748-19085-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170208233121.GA16728@bbox>
 <20170209002436.GA103792@gmail.com>
 <20170209052425.GA4678@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>,
        <akpm@linux-foundation.org>, <bongkyu.kim@lge.com>,
        <rsalvaterra@gmail.com>, <sergey.senozhatsky@gmail.com>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <anton@enomsg.org>,
        <ccross@android.com>, <keescook@chromium.org>,
        <tony.luck@intel.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from LGEAMRELO13.lge.com ([156.147.23.53]:60488 "EHLO
        lgeamrelo13.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbdBJAPE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 19:15:04 -0500
In-Reply-To: <20170209052425.GA4678@zzz>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Eric,

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

Thanks for looking this.

If you have a fix, could you send a patch? I'm happy to test it.
