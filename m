Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C355DC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 04:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbiKRE7n (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Nov 2022 23:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbiKRE7n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Nov 2022 23:59:43 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C107A5BD4E
        for <linux-crypto@vger.kernel.org>; Thu, 17 Nov 2022 20:59:40 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1ovtTS-00FUKq-0x; Fri, 18 Nov 2022 12:59:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Nov 2022 12:59:34 +0800
Date:   Fri, 18 Nov 2022 12:59:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        kirill.shutemov@linux.intel.com, richard@nod.at,
        viro@zeniv.linux.org.uk,
        sathyanarayanan.kuppuswamy@linux.intel.com, jpoimboe@kernel.org,
        elliott@hpe.com, x86@kernel.org, jussi.kivilinna@iki.fi
Subject: Re: [PATCH v4 1/4] crypto: aria: add keystream array into request ctx
Message-ID: <Y3cRNuYd92QUthDC@gondor.apana.org.au>
References: <20221113165645.4652-1-ap420073@gmail.com>
 <20221113165645.4652-2-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113165645.4652-2-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Nov 13, 2022 at 04:56:42PM +0000, Taehee Yoo wrote:
>
> @@ -130,6 +135,13 @@ static int aria_avx_ctr_encrypt(struct skcipher_request *req)
>  	return err;
>  }
>  
> +static int aria_avx_init_tfm(struct crypto_skcipher *tfm)
> +{
> +	crypto_skcipher_set_reqsize(tfm, sizeof(struct aria_avx_request_ctx));
> +
> +	return 0;
> +}
> +
>  static struct skcipher_alg aria_algs[] = {
>  	{
>  		.base.cra_name		= "__ecb(aria)",
> @@ -160,6 +172,7 @@ static struct skcipher_alg aria_algs[] = {
>  		.setkey			= aria_avx_set_key,
>  		.encrypt		= aria_avx_ctr_encrypt,
>  		.decrypt		= aria_avx_ctr_encrypt,
> +		.init			= aria_avx_init_tfm,
>  	}
>  };

You need to set the new flag CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE
or else users of sync_skcipher may pick up this algorithm and
barf.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
