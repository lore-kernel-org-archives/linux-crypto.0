Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D47C2BBCA
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 10:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2639F23F57
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 10:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387811AbgLKKJD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Dec 2020 05:09:03 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33354 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394175AbgLKKIn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Dec 2020 05:08:43 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1knfL2-0004mr-6E; Fri, 11 Dec 2020 21:07:49 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Dec 2020 21:07:48 +1100
Date:   Fri, 11 Dec 2020 21:07:48 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Tomaszx Kowalik <tomaszx.kowalik@intel.com>
Subject: Re: [PATCH 2/3] crypto: qat - add AES-XTS support for QAT GEN4
 devices
Message-ID: <20201211100748.GA994@gondor.apana.org.au>
References: <20201201142451.138221-1-giovanni.cabiddu@intel.com>
 <20201201142451.138221-3-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201142451.138221-3-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 01, 2020 at 02:24:50PM +0000, Giovanni Cabiddu wrote:
>
> @@ -1293,6 +1366,12 @@ static int qat_alg_skcipher_init_xts_tfm(struct crypto_skcipher *tfm)
>  	if (IS_ERR(ctx->ftfm))
>  		return PTR_ERR(ctx->ftfm);
>  
> +	ctx->tweak = crypto_alloc_cipher("aes", 0, 0);
> +	if (IS_ERR(ctx->tweak)) {
> +		crypto_free_skcipher(ctx->ftfm);
> +		return PTR_ERR(ctx->tweak);
> +	}
> +
>  	reqsize = max(sizeof(struct qat_crypto_request),
>  		      sizeof(struct skcipher_request) +
>  		      crypto_skcipher_reqsize(ctx->ftfm));

This may clash with the work that Ard is doing on simpler ciphers.

So I think this should switch over to using the library interface
for aes.  What do you think Ard?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
