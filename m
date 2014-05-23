From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 1/6] SP800-90A Deterministic Random Bit Generator
Date: Sat, 24 May 2014 05:10:07 +0800
Message-ID: <20140523211007.GA20955@gondor.apana.org.au>
References: <4917794.FPSphFc8Fa@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	aquini@redhat.com, jeremy.wayne.powell@gmail.com,
	clemens@ladisch.de, pwalten@au1.ibm.com, joe@perches.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:58850 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaEWVKP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 May 2014 17:10:15 -0400
Content-Disposition: inline
In-Reply-To: <4917794.FPSphFc8Fa@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan Mueller <smueller@chronox.de> wrote:
>
> +       memset(&drbg_algs[i], 0, sizeof(struct crypto_alg));
> +       if (pr) {
> +               memcpy(drbg_algs[i].cra_name, "drbg(pr(", 8);
> +               memcpy(drbg_algs[i].cra_driver_name, "drbg_pr_", 8);
> +               pos = 8;

You shouldn't use the brackets here since this not a real template.
Just use one name for both cra_name and cra_driver_name.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
