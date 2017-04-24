From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif_aead - Require setkey before accept(2)
Date: Mon, 24 Apr 2017 16:43:24 +0800
Message-ID: <20170424084324.GA20473@gondor.apana.org.au>
References: <2439869.UPpkkqdW7f@positron.chronox.de>
 <20170421111127.GA13925@gondor.apana.org.au>
 <2572320.UaipMWf1ob@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:44640 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1166969AbdDXIoN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Apr 2017 04:44:13 -0400
Content-Disposition: inline
In-Reply-To: <2572320.UaipMWf1ob@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 21, 2017 at 06:35:07PM +0200, Stephan Müller wrote:
>
> After checking again, IMHO that is no unreleated cleanup or even a cleanup at 
> all.
> 
> void *private used to be struct crypto_aead and is now struct aead_tfm. struct 
> crypto_aead is found in private->aead. Hence, the patch assigned private to 
> tfm and then obtained the struct crypto_aead pointer. As this was not 
> necessary before, it is a required extension IMHO.

Fair enough.

But what about the change in aead_sock_destruct? Can you explain why
it is no longer possible to obtain the tfm from ctx->aead_req?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
