From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 4/4] crypto: RSA padding algorithm
Date: Fri, 27 Nov 2015 21:17:27 +0800
Message-ID: <20151127131727.GA29625@gondor.apana.org.au>
References: <1448574808-11320-2-git-send-email-andrew.zaborowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56658 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbbK0NRb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Nov 2015 08:17:31 -0500
Content-Disposition: inline
In-Reply-To: <1448574808-11320-2-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrew Zaborowski <andrew.zaborowski@intel.com> wrote:
> +static void pkcs1pad_free(struct akcipher_instance *inst)
> +{
> +       struct crypto_akcipher_spawn *spawn =
> +               crypto_instance_ctx(akcipher_crypto_instance(inst));

Please add an akcipher_instance_ctx helper instead.

> +       inst->alg.base.cra_init = pkcs1pad_init_tfm;
> +       inst->alg.base.cra_exit = pkcs1pad_exit_tfm;

This is obsolete.  Please use akcipher's init/exit functions instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
