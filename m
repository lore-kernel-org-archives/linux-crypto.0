From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: async hash & hmac
Date: Fri, 11 May 2012 19:37:28 +1000
Message-ID: <20120511093728.GA28475@gondor.apana.org.au>
References: <CALLzPKYuFWAbzB8EQ=QxWe+kpFqkEZRVJVimtVUNsw39miUntA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:48629 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758155Ab2EKJhb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 May 2012 05:37:31 -0400
Content-Disposition: inline
In-Reply-To: <CALLzPKYuFWAbzB8EQ=QxWe+kpFqkEZRVJVimtVUNsw39miUntA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 11, 2012 at 11:58:03AM +0300, Kasatkin, Dmitry wrote:
> Hello,
> 
> When allocating hmac like: crypto_alloc_ahash("hmac(sha1)", ..),
> it is actually fallsback to  "shash" hmac and software shash hash
> implementation..
> Even when HW accelerator provides AHASH it will not be used with hmac.
> 
> Basically HW driver needs to provide its own implementation for async
> hmac, like I did for omap-sham.
> 
> 		.cra_name		= "hmac(sha1)",
> 		.cra_driver_name	= "omap-hmac-sha1",
> 
> Is that correct, right?

We can add an async version of hmac if your hardware does not
have direct support for it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
