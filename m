From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH v2 6/7] crypto: omap-aes: Add support for GCM mode
Date: Wed, 8 Jul 2015 13:45:42 +0530
Message-ID: <559CDC2E.7060505@ti.com>
References: <1436283109-13318-1-git-send-email-lokeshvutla@ti.com> <1436283109-13318-7-git-send-email-lokeshvutla@ti.com> <20150708041838.GA12744@gondor.apana.org.au> <559CCA63.4080609@ti.com> <20150708074805.GA18991@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>,
	<linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:49812 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932997AbbGHISj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 04:18:39 -0400
In-Reply-To: <20150708074805.GA18991@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 08 July 2015 01:18 PM, Herbert Xu wrote:
> On Wed, Jul 08, 2015 at 12:29:47PM +0530, Lokesh Vutla wrote:
>>
>>>> +	if (req->assoclen + req->cryptlen == 0) {
>>>> +		scatterwalk_map_and_copy(ctx->auth_tag, req->dst, 0, authlen,
>>>> +					 1);
>>>> +		return 0;
>>>> +	}
>>>
>>> How can this be right? Did you enable the selftest?
>> Why not? Self tests are passed for this case.
>>
>> As per the equation given in GCM spec[1], we can see that
>> if assoclen and cryptlen is 0, then output of GCM  is just E(K, Y0)
>> where Y0 = IV||(0^31)1
>> I have E(K, Y0) calculated in previous step. And copying it
>> to destination if assoclen and cryptlen is 0.
>>
>> Correct me if I am wrong.
> 
> It should be E(K, Y0) ^ GHASH(0).  So unless GHASH(0) == 0, your
> code doesn't work.
Yes, thats right. I have considered that.
So, we need GHASH(H, {}, {}).
As per the spec, 
GHASH(H, A, C) = X(m + n + 1). 
					m = n = 0 in our case.

X0 = 0
X1 = (X(m  + n) ^ (len(A) || len(C)) . H
X1 = 0 . H		(GF(128) Multiplication)
X1 = 0	

The same thing is given in the Test case 1 of the spec. GHASH(H, {}, {}) = 0

Thanks and regards,
Lokesh

> 
> Cheers,
> 
