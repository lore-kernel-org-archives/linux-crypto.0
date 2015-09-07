From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [RFC PATCH] crypto: RSA padding transform
Date: Mon, 7 Sep 2015 07:31:56 -0700
Message-ID: <55ED9FDC.60602@intel.com>
References: <1441494029-6765-1-git-send-email-andrew.zaborowski@intel.com>
 <35165141.6IIWPIRvUD@myon.chronox.de>
 <CAOq732JmhBh7kqDH1mMhUz1MXz9zJSx1jaqdBMjgDVvtraSrrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbbIGOde (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Sep 2015 10:33:34 -0400
In-Reply-To: <CAOq732JmhBh7kqDH1mMhUz1MXz9zJSx1jaqdBMjgDVvtraSrrQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/06/2015 07:33 AM, Andrzej Zaborowski wrote:
> Probably yes, I also read about the decision to use iov buffers, this
> will have a bigger effect on code.

The more I think about the sgl support the more it looks to me like it wasn't
a good idea. It will be copied into a flat buffer somewhere along the way anyway.
Like in the example below.

I have that conversion already done, and for SW it looks like the data is copied 4 times
for a single operation:
1 - from sgl to flat buffer, because MPI doesn't take sgls, (if the src has more ents)
2 - from buff to MPI, then, after operation
3 - export from MPI to a buff and
4 - from buff to sgl (if is the output sg it also fragmented).

I can see now that with all these padding schemes there will be more buffer copied
on top of this, so I wonder if it still make sense.
Herbert?

> 
> +     src = kmalloc(ctx->key_size,
>>> +                     (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
>>> +                     GFP_KERNEL : GFP_ATOMIC);
>>> +     if (!src)
>>> +             return -ENOMEM;
>>> +
>>> +     /* Reuse output buffer, add padding in the input */
>>> +     child_req->src = src;
>>> +     child_req->src_len = ctx->key_size;
>>> +     child_req->dst = req->dst;
>>> +     child_req->dst_len = req->dst_len;
