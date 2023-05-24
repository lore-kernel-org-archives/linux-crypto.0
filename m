Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE2DC7EE23
	for <linux-crypto@archiver.kernel.org>; Wed, 24 May 2023 09:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjEXJlU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 May 2023 05:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjEXJk6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2023 05:40:58 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82B0130;
        Wed, 24 May 2023 02:40:42 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q1kyn-00CkGv-K5; Wed, 24 May 2023 17:40:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 24 May 2023 17:40:25 +0800
Date:   Wed, 24 May 2023 17:40:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: starfive - Add RSA algo support
Message-ID: <ZG3biep8vAWQ5ZgA@gondor.apana.org.au>
References: <20230516075752.659287-1-jiajie.ho@starfivetech.com>
 <20230516075752.659287-3-jiajie.ho@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516075752.659287-3-jiajie.ho@starfivetech.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 16, 2023 at 03:57:52PM +0800, Jia Jie Ho wrote:
>
> +static struct akcipher_alg starfive_rsa = {
> +	.encrypt = starfive_rsa_enc,
> +	.decrypt = starfive_rsa_dec,
> +	.sign = starfive_rsa_dec,
> +	.verify = starfive_rsa_enc,
> +	.set_pub_key = starfive_rsa_set_pub_key,
> +	.set_priv_key = starfive_rsa_set_priv_key,
> +	.max_size = starfive_rsa_max_size,
> +	.init = starfive_rsa_init_tfm,
> +	.exit = starfive_rsa_exit_tfm,
> +	.base = {
> +		.cra_name = "rsa",
> +		.cra_driver_name = "starfive-rsa",
> +		.cra_flags = CRYPTO_ALG_TYPE_AKCIPHER |
> +			     CRYPTO_ALG_ASYNC |

Why did you set the ASYNC flag? Your implementation appears to
be completely synchronous.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
