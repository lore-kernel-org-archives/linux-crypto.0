From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 3/3] crypto: kpp - Add ECDH software support
Date: Tue, 31 May 2016 14:55:25 +0800
Message-ID: <20160531065525.GC13948@gondor.apana.org.au>
References: <1462830041-7582-1-git-send-email-salvatore.benedetto@intel.com>
 <1462830041-7582-4-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56917 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbcEaHiE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 03:38:04 -0400
Content-Disposition: inline
In-Reply-To: <1462830041-7582-4-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 09, 2016 at 10:40:41PM +0100, Salvatore Benedetto wrote:
>
> +	do {
> +		if (tries++ >= MAX_TRIES)
> +			goto err_retries;
> +
> +		ecc_point_mult(pk, &curve->g, priv, NULL, curve->p, ndigits);
> +
> +	} while (ecc_point_is_zero(pk));

You might want to read this again.  The original code did this
because it changed the private key in the loop, in your code
priv is constant...

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
