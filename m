Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C751C04AAC
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 047072184E
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfEWGMG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 02:12:06 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:47428 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfEWGMG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 02:12:06 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hTgxQ-0001Dr-VE; Thu, 23 May 2019 14:12:05 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hTgxO-0001EP-Sx; Thu, 23 May 2019 14:12:02 +0800
Date:   Thu, 23 May 2019 14:12:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256)
 failure because of invalid input
Message-ID: <20190523061202.ic2vgimgzvvm6dzc@gondor.apana.org.au>
References: <1557919546-360-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557919546-360-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 15, 2019 at 02:25:45PM +0300, Iuliana Prodan wrote:
>
> @@ -1058,6 +1105,14 @@ static int __init caam_pkc_init(void)
>  		goto out_put_dev;
>  	}
>  
> +	/* allocate zero buffer, used for padding input */
> +	zero_buffer = kzalloc(CAAM_RSA_MAX_INPUT_SIZE - 1, GFP_DMA |
> +			      GFP_KERNEL);
> +	if (!zero_buffer) {
> +		err = -ENOMEM;
> +		goto out_put_dev;
> +	}
> +
>  	err = crypto_register_akcipher(&caam_rsa);
>  	if (err)
>  		dev_warn(ctrldev, "%s alg registration failed\n",

This patch does not apply on top of the caam patch-series from Horia.
You're also going to leak zero_buffer if crypto_register_akcipher
fails.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
