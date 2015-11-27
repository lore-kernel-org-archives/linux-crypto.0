From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 3/4] crypto: akcipher: add akcipher declarations
 needed by templates.
Date: Fri, 27 Nov 2015 21:12:14 +0800
Message-ID: <20151127131213.GA29590@gondor.apana.org.au>
References: <1448574808-11320-1-git-send-email-andrew.zaborowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42584 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbbK0NMT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Nov 2015 08:12:19 -0500
Content-Disposition: inline
In-Reply-To: <1448574808-11320-1-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrew Zaborowski <andrew.zaborowski@intel.com> wrote:
>
> @@ -75,9 +76,22 @@ static int crypto_akcipher_init_tfm(struct crypto_tfm *tfm)
>        return 0;
> }
> 
> +static void crypto_akcipher_free_instance(struct crypto_instance *inst)
> +{
> +       struct akcipher_instance *akcipher = akcipher_instance(inst);
> +
> +       if (!akcipher->free) {
> +               inst->tmpl->free(inst);
> +               return;
> +       }

You don't need this bit.  AEAD has it because there were legacy
templates but you are starting from a clean slate.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
