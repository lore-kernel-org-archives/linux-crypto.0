From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v7 0/5] Update LZ4 compressor module
Date: Wed, 8 Feb 2017 21:24:25 -0800
Message-ID: <20170209052425.GA4678@zzz>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1486321748-19085-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <20170208233121.GA16728@bbox>
 <20170209002436.GA103792@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>,
        akpm@linux-foundation.org, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com, sergey.senozhatsky@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, anton@enomsg.org, ccross@android.com,
        keescook@chromium.org, tony.luck@intel.com
To: Minchan Kim <minchan@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35383 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751525AbdBIGb0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2017 01:31:26 -0500
Content-Disposition: inline
In-Reply-To: <20170209002436.GA103792@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Also I noticed another bug, this time in LZ4_count():

> #if defined(CONFIG_64BIT)
> #define LZ4_ARCH64 1
> #else
> #define LZ4_ARCH64 0
> #endif
...
> #ifdef LZ4_ARCH64
>        if ((pIn < (pInLimit-3))
>                && (LZ4_read32(pMatch) == LZ4_read32(pIn))) {
>                pIn += 4; pMatch += 4;
>        }
> #endif

Because of how LZ4_ARCH64 is defined, it needs to be '#if LZ4_ARCH64'.

But I also think the way upstream LZ4 does 64-bit detection could have just been
left as-is; it has a function which gets inlined:

	static unsigned LZ4_64bits(void) { return sizeof(void*)==8; }

Eric
