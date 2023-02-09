Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117E2C636D4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Feb 2023 09:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjBIJrf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Feb 2023 04:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjBIJrd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2023 04:47:33 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F87334C36;
        Thu,  9 Feb 2023 01:47:31 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pQ3W2-009E9r-OF; Thu, 09 Feb 2023 17:46:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Feb 2023 17:46:54 +0800
Date:   Thu, 9 Feb 2023 17:46:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor.dooley@microchip.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 4/4] crypto: starfive - Add hash and HMAC support
Message-ID: <Y+TBDqkjsuMiA/P7@gondor.apana.org.au>
References: <20230130154242.112613-1-jiajie.ho@starfivetech.com>
 <20230130154242.112613-5-jiajie.ho@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130154242.112613-5-jiajie.ho@starfivetech.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 30, 2023 at 11:42:42PM +0800, Jia Jie Ho wrote:
>
> +static inline int starfive_hash_wait_hmac_done(struct starfive_cryp_ctx *ctx)
> +{
> +	struct starfive_cryp_dev *cryp = ctx->cryp;
> +	u32 status;
> +
> +	return readl_relaxed_poll_timeout(cryp->base + STARFIVE_HASH_SHACSR, status,
> +					  (status & STARFIVE_HASH_HMAC_DONE), 10, 100000);
> +}
> +
> +static inline int starfive_hash_wait_busy(struct starfive_cryp_ctx *ctx)
> +{
> +	struct starfive_cryp_dev *cryp = ctx->cryp;
> +	u32 status;
> +
> +	return readl_relaxed_poll_timeout(cryp->base + STARFIVE_HASH_SHACSR, status,
> +					  !(status & STARFIVE_HASH_BUSY), 10, 100000);
> +}
> +
> +static inline int starfive_hash_wait_key_done(struct starfive_cryp_ctx *ctx)
> +{
> +	struct starfive_cryp_dev *cryp = ctx->cryp;
> +	u32 status;
> +
> +	return readl_relaxed_poll_timeout(cryp->base + STARFIVE_HASH_SHACSR, status,
> +					  (status & STARFIVE_HASH_KEY_DONE), 10, 100000);
> +}

Is there no IRQ mechanism for this?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
