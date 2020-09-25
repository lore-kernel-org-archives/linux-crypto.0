Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B43AC4363D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 07:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3544223718
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 07:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgIYHgq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 03:36:46 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53018 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbgIYHgq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 03:36:46 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kLiHO-0006SK-8x; Fri, 25 Sep 2020 17:36:31 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 25 Sep 2020 17:36:29 +1000
Date:   Fri, 25 Sep 2020 17:36:29 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     arnd@arndb.de, davem@davemloft.net, mripard@kernel.org,
        wens@csie.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 6/7] crypto: sun4i-ss: enabled stats via debugfs
Message-ID: <20200925073629.GA18921@gondor.apana.org.au>
References: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
 <1600627038-40000-7-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600627038-40000-7-git-send-email-clabbe@baylibre.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Sep 20, 2020 at 06:37:17PM +0000, Corentin Labbe wrote:
>
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> index f3bdf465b02e..2ec359eaa4cf 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> @@ -34,6 +34,10 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
>  	struct sg_mapping_iter mi, mo;
>  	unsigned int oi, oo; /* offset for in and out */
>  	unsigned long flags;
> +#ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_DEBUG
> +	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
> +	struct sun4i_ss_alg_template *algt;
> +#endif
>  
>  	if (!areq->cryptlen)
>  		return 0;
> @@ -50,6 +54,12 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
>  		scatterwalk_map_and_copy(backup_iv, areq->src, areq->cryptlen - ivsize, ivsize, 0);
>  	}
>  
> +#ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_DEBUG
> +	algt = container_of(alg, struct sun4i_ss_alg_template, alg.crypto);
> +	algt->stat_opti++;
> +	algt->stat_bytes += areq->cryptlen;
> +#endif

Please do

	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN4I_SS_DEBUG)) {
		...
	}

instead so this always gets compiled.

> +#ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_DEBUG
> +	/* Ignore error of debugfs */
> +	ss->dbgfs_dir = debugfs_create_dir("sun4i-ss", NULL);
> +	ss->dbgfs_stats = debugfs_create_file("stats", 0444, ss->dbgfs_dir, ss,
> +					      &sun4i_ss_debugfs_fops);
> +#endif

The calls too be done under an if statement.  Only the assignments
need to use the ifdef.

> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
> index 163962f9e284..a98a2c05089b 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
> @@ -13,6 +13,7 @@
>  
>  #include <linux/clk.h>
>  #include <linux/crypto.h>
> +#include <linux/debugfs.h>

Please add this into the c files that actually use debugfs, and
not here.

>  #include <linux/io.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> @@ -152,6 +153,10 @@ struct sun4i_ss_ctx {
>  #ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG
>  	u32 seed[SS_SEED_LEN / BITS_PER_LONG];
>  #endif
> +#ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_DEBUG
> +	struct dentry *dbgfs_dir;
> +	struct dentry *dbgfs_stats;
> +#endif

You just need to add forward declarations for struct dentry.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
