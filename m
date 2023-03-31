Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C14FC76196
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 09:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjCaJwP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 05:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjCaJvl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 05:51:41 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177861D863;
        Fri, 31 Mar 2023 02:49:52 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1piBOC-00Al6w-Tq; Fri, 31 Mar 2023 17:49:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 Mar 2023 17:49:44 +0800
Date:   Fri, 31 Mar 2023 17:49:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     meenakshi.aggarwal@nxp.com
Cc:     horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        leonard.crestez@nxp.com, aisheng.dong@nxp.com
Subject: Re: [PATCH] crypto: caam - refactor RNG initialization
Message-ID: <ZCasuK+eZh15hojV@gondor.apana.org.au>
References: <20230320073848.697473-1-meenakshi.aggarwal@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320073848.697473-1-meenakshi.aggarwal@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 20, 2023 at 08:38:48AM +0100, meenakshi.aggarwal@nxp.com wrote:
>
> @@ -619,7 +712,7 @@ static bool needs_entropy_delay_adjustment(void)
>  /* Probe routine for CAAM top (controller) level */
>  static int caam_probe(struct platform_device *pdev)
>  {
> -	int ret, ring, gen_sk, ent_delay = RTSDCTL_ENT_DLY_MIN;
> +	int ret, ring;
>  	u64 caam_id;
>  	const struct soc_device_attribute *imx_soc_match;
>  	struct device *dev;
> @@ -629,10 +722,8 @@ static int caam_probe(struct platform_device *pdev)
>  	struct caam_perfmon __iomem *perfmon;
>  	struct dentry *dfs_root;
>  	u32 scfgr, comp_params;
> -	u8 rng_vid;
>  	int pg_size;
>  	int BLOCK_OFFSET = 0;
> -	bool pr_support = false;
>  	bool reg_access = true;

This patch does not apply against cryptodev.  There is no reg_access
in my tree.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
