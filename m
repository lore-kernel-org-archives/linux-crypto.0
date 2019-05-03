Return-Path: <SRS0=LfhG=TD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D5F8C43219
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 13:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3ED2D2075E
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 13:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbfECN0C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 May 2019 09:26:02 -0400
Received: from [5.180.42.13] ([5.180.42.13]:38092 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727282AbfECN0B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 May 2019 09:26:01 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hMRK3-0005l8-DJ; Fri, 03 May 2019 14:05:27 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hMRK0-0002TU-Bu; Fri, 03 May 2019 14:05:24 +0800
Date:   Fri, 3 May 2019 14:05:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH 3/7] crypto: caam - convert top level drivers to libraries
Message-ID: <20190503060524.kyc3ktst5k3hu2kb@gondor.apana.org.au>
References: <20190425162501.4565-1-horia.geanta@nxp.com>
 <20190425162501.4565-4-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190425162501.4565-4-horia.geanta@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 25, 2019 at 07:24:57PM +0300, Horia Geantă wrote:
>
> @@ -3511,43 +3511,17 @@ static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
>  	alg->exit = caam_aead_exit;
>  }
>  
> -static int __init caam_algapi_init(void)
> +int caam_algapi_init(struct device *ctrldev)
>  {
>  	struct device_node *dev_node;
>  	struct platform_device *pdev;
> -	struct caam_drv_private *priv;
> +	struct caam_drv_private *priv = dev_get_drvdata(ctrldev);
>  	int i = 0, err = 0;
>  	u32 aes_vid, aes_inst, des_inst, md_vid, md_inst, ccha_inst, ptha_inst;
>  	u32 arc4_inst;
>  	unsigned int md_limit = SHA512_DIGEST_SIZE;
>  	bool registered = false, gcm_support;
>  
> -	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
> -	if (!dev_node) {
> -		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
> -		if (!dev_node)
> -			return -ENODEV;
> -	}
> -
> -	pdev = of_find_device_by_node(dev_node);
> -	if (!pdev) {
> -		of_node_put(dev_node);
> -		return -ENODEV;
> -	}
> -
> -	priv = dev_get_drvdata(&pdev->dev);
> -	of_node_put(dev_node);
> -
> -	/*
> -	 * If priv is NULL, it's probably because the caam driver wasn't
> -	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
> -	 */
> -	if (!priv) {
> -		err = -ENODEV;
> -		goto out_put_dev;
> -	}
> -
> -
>  	/*
>  	 * Register crypto algorithms the device supports.
>  	 * First, detect presence and attributes of DES, AES, and MD blocks.

This introduces two new warnings regarding unused variables.  Please
fix and resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
