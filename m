From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 0/3] AF_ALG interface for akcipher
Date: Wed, 22 Jul 2015 09:14:51 +0200
Message-ID: <1819774.HTm7Ulf2x1@tachyon.chronox.de>
References: <3908391.JkjAozYBaW@tachyon.chronox.de> <20150722013241.GA31240@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47986 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256AbbGVHPA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 03:15:00 -0400
In-Reply-To: <20150722013241.GA31240@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 22. Juli 2015, 09:32:41 schrieb Herbert Xu:

Hi Herbert,

> 
> I think we should finish the conversion of the only in-kernel
> user of RSA before we add the user-space interface.  Otherwise
> this unnecessarily ties our hands to the current API.

Agreed.

After my question around the SGL vs linear buffers I was under the impression 
that it was decided.

So I will wait until the discussion is completed.

> 
> For example, do we want an SG interface for the input and output?

The question is whether the SGL overhead is still acceptable for the small 
buffer size we have to consider when talking about raw asymmetric ciphers. For 
RSA, it seems that the max size 4096 bits for the generic implementation. For 
other implementations, I would not expect much larger sizes. Thus, we talk 
about 512 bytes or one 1kbytes maximum operation size.

When ECC comes into picture, the sizes are even significanly smaller.

If I understood correctly, we do not want to support full hybrid asymmetric 
operations (like PKCS1, OAEP and the like) where large buffers are to be 
handled.

On the other hand, what about using struct scatterlist as the API input 
parameter. In addition, we allow cipher implementations to traverse only one 
SG entry which implies a linear buffer operation. But the API is open for full 
SG operation if needed in the future. To inform the caller about the minimum 
size of an SG entry, we may use another integer value similar to alignmask. 
So, if Tadeusz's hardware wants one linear buffer, the integer is 256 or 512 
where the caller must create the buffers of at least this size. As all input 
data would fit into that one buffer, there the caller only needs to allocate 
one SG.

-- 
Ciao
Stephan
