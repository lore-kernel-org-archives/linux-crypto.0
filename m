From: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Subject: Re: [RFC PATCH] crypto: RSA padding transform
Date: Tue, 8 Sep 2015 18:09:53 +0200
Message-ID: <CAOq732LoTvUzDTM7vRHU3QCHeuL0vD4Bh24kqB0R8i0yCQdsJw@mail.gmail.com>
References: <1441494029-6765-1-git-send-email-andrew.zaborowski@intel.com>
	<CAOq732JmhBh7kqDH1mMhUz1MXz9zJSx1jaqdBMjgDVvtraSrrQ@mail.gmail.com>
	<55ED9FDC.60602@intel.com>
	<1807044.IVByMVeBDE@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35868 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbbIHQJz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 Sep 2015 12:09:55 -0400
Received: by wicgb1 with SMTP id gb1so84375497wic.1
        for <linux-crypto@vger.kernel.org>; Tue, 08 Sep 2015 09:09:54 -0700 (PDT)
In-Reply-To: <1807044.IVByMVeBDE@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On 7 September 2015 at 19:54, Stephan Mueller <smueller@chronox.de> wrote:
> Am Montag, 7. September 2015, 07:31:56 schrieb Tadeusz Struk:
>>I can see now that with all these padding schemes there will be more buffer
>>copied on top of this, so I wonder if it still make sense.
>>Herbert?
>
> When the padding stuff comes into play, I think the SGL approach avoids
> memcpy() invocations.
>
> For example, Andrzej's approach currently is to copy the *entire* source data
> into a buffer where the padding is added.
>
> With SGLs, Andrzej only needs a buffer with the padding (which I would think
> could even reside on the stack, provided some bounds checks are done), and
> modify the SGL by preprending the padding buffer to the SGL with the source
> data.

Yes, in the case of the padding schemes, using sgl's would actually
save a memcpy both on encrypt/sign and decrypt/verify.  Whether it'd
actually help I'm not sure -- the number of pointers you need to
touch, etc. may add up to around 128/256 bytes of memory access
anyway.

You couldn't use buffers on stack though unless you only support
synchronous underlying RSA implementations.  What you could do, for
example in sign(), is use a static buffer pre-filled with the pad
bytes of specific length.

Best regards
