From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC PATCH] crypto: RSA padding transform
Date: Mon, 07 Sep 2015 19:54:09 +0200
Message-ID: <1807044.IVByMVeBDE@tauon.atsec.com>
References: <1441494029-6765-1-git-send-email-andrew.zaborowski@intel.com> <CAOq732JmhBh7kqDH1mMhUz1MXz9zJSx1jaqdBMjgDVvtraSrrQ@mail.gmail.com> <55ED9FDC.60602@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33795 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbbIGRyV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Sep 2015 13:54:21 -0400
In-Reply-To: <55ED9FDC.60602@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 7. September 2015, 07:31:56 schrieb Tadeusz Struk:

Hi Tadeusz,

>On 09/06/2015 07:33 AM, Andrzej Zaborowski wrote:
>> Probably yes, I also read about the decision to use iov buffers, this
>> will have a bigger effect on code.
>
>The more I think about the sgl support the more it looks to me like it wasn't
>a good idea. It will be copied into a flat buffer somewhere along the way
>anyway. Like in the example below.
>
>I have that conversion already done, and for SW it looks like the data is
>copied 4 times for a single operation:
>1 - from sgl to flat buffer, because MPI doesn't take sgls, (if the src has
>more ents) 2 - from buff to MPI, then, after operation
>3 - export from MPI to a buff and
>4 - from buff to sgl (if is the output sg it also fragmented).
>
>I can see now that with all these padding schemes there will be more buffer
>copied on top of this, so I wonder if it still make sense.
>Herbert?

When the padding stuff comes into play, I think the SGL approach avoids 
memcpy() invocations.

For example, Andrzej's approach currently is to copy the *entire* source data 
into a buffer where the padding is added.

With SGLs, Andrzej only needs a buffer with the padding (which I would think 
could even reside on the stack, provided some bounds checks are done), and 
modify the SGL by preprending the padding buffer to the SGL with the source 
data.

>
>> +     src = kmalloc(ctx->key_size,
>> 
>>>> +                     (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
>>>> +                     GFP_KERNEL : GFP_ATOMIC);
>>>> +     if (!src)
>>>> +             return -ENOMEM;
>>>> +
>>>> +     /* Reuse output buffer, add padding in the input */
>>>> +     child_req->src = src;
>>>> +     child_req->src_len = ctx->key_size;
>>>> +     child_req->dst = req->dst;
>>>> +     child_req->dst_len = req->dst_len;
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
