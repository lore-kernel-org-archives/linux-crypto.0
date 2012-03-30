From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: user - Fix lookup of algorithms with IV
	generator
Date: Fri, 30 Mar 2012 17:21:13 +0800
Message-ID: <20120330092112.GC27551@gondor.apana.org.au>
References: <20120329070347.GD1021@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:39377 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755181Ab2C3JVO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Mar 2012 05:21:14 -0400
Content-Disposition: inline
In-Reply-To: <20120329070347.GD1021@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 29, 2012 at 09:03:47AM +0200, Steffen Klassert wrote:
> We lookup algorithms with crypto_alg_mod_lookup() when instantiating via
> crypto_add_alg(). However, algorithms that are wrapped by an IV genearator
> (e.g. aead or genicv type algorithms) need special care. The userspace
> process hangs until it gets a timeout when we use crypto_alg_mod_lookup()
> to lookup these algorithms. So export the lookup functions for these
> algorithms and use them in crypto_add_alg().
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Both applied to crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
