Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B67C2B9F8
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 16:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B59D2611C2
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 16:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbhEYQRZ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 May 2021 12:17:25 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:33752 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232561AbhEYQRY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 May 2021 12:17:24 -0400
Received: from localhost (mailhub3.si.c-s.fr [192.168.12.233])
        by localhost (Postfix) with ESMTP id 4FqK2137DzzB7k2;
        Tue, 25 May 2021 18:15:53 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id jqBU9LutuFUq; Tue, 25 May 2021 18:15:53 +0200 (CEST)
Received: from vm-hermes.si.c-s.fr (vm-hermes.si.c-s.fr [192.168.25.253])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4FqK2120ZlzB7DJ;
        Tue, 25 May 2021 18:15:53 +0200 (CEST)
Received: by vm-hermes.si.c-s.fr (Postfix, from userid 33)
        id C888764E; Tue, 25 May 2021 18:20:18 +0200 (CEST)
Received: from 37.173.125.11 ([37.173.125.11]) by messagerie.c-s.fr (Horde
 Framework) with HTTP; Tue, 25 May 2021 18:20:18 +0200
Date:   Tue, 25 May 2021 18:20:18 +0200
Message-ID: <20210525182018.Horde.RpVsAs9V_zh-RmbuxnlQTQ2@messagerie.c-s.fr>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Shubhankar Kuranagatti <shubhankarvk@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
Subject: Re: [PATCH] drivers: crypto: talitos.c: Replace space with tabs
In-Reply-To: <20210525140903.nqj5rdohduzemm4l@kewl-virtual-machine>
User-Agent: Internet Messaging Program (IMP) H5 (6.2.3)
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Shubhankar Kuranagatti <shubhankarvk@gmail.com> a écrit :

> Tabs have been used instead of spaces for indentation
> This is done to maintain code uniformity(LINDENT).

Nack.

The changes done by this patch break linux codying style. For  
instance, additional lines alignment must match open parenthesis.

Did you run checkpatch.pl on your path ?

>
> Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
> ---
>  drivers/crypto/talitos.c | 198 +++++++++++++++++++--------------------
>  1 file changed, 99 insertions(+), 99 deletions(-)
>
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 25c9f825b8b5..e40f78ec8c4b 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -174,7 +174,7 @@ static int reset_channel(struct device *dev, int ch)
>  	/* and ICCR writeback, if available */
>  	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
>  		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
> -		          TALITOS_CCCR_LO_IWSE);
> +				TALITOS_CCCR_LO_IWSE);
>
>  	return 0;
>  }
> @@ -249,7 +249,7 @@ static int init_device(struct device *dev)
>  	/* disable integrity check error interrupts (use writeback instead) */
>  	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
>  		setbits32(priv->reg_mdeu + TALITOS_EUICR_LO,
> -		          TALITOS_MDEUICR_LO_ICE);
> +				TALITOS_MDEUICR_LO_ICE);
>
>  	return 0;
>  }
> @@ -2276,12 +2276,12 @@ static struct talitos_alg_template driver_algs[] = {
>  			.maxauthsize = SHA1_DIGEST_SIZE,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -			             DESC_HDR_SEL0_AESU |
> -		                     DESC_HDR_MODE0_AESU_CBC |
> -		                     DESC_HDR_SEL1_MDEUA |
> -		                     DESC_HDR_MODE1_MDEU_INIT |
> -		                     DESC_HDR_MODE1_MDEU_PAD |
> -		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
> +			DESC_HDR_SEL0_AESU |
> +			DESC_HDR_MODE0_AESU_CBC |
> +			DESC_HDR_SEL1_MDEUA |
> +			DESC_HDR_MODE1_MDEU_INIT |
> +			DESC_HDR_MODE1_MDEU_PAD |
> +			DESC_HDR_MODE1_MDEU_SHA1_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> @@ -2321,13 +2321,13 @@ static struct talitos_alg_template driver_algs[] = {
>  			.setkey = aead_des3_setkey,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -			             DESC_HDR_SEL0_DEU |
> -		                     DESC_HDR_MODE0_DEU_CBC |
> -		                     DESC_HDR_MODE0_DEU_3DES |
> -		                     DESC_HDR_SEL1_MDEUA |
> -		                     DESC_HDR_MODE1_MDEU_INIT |
> -		                     DESC_HDR_MODE1_MDEU_PAD |
> -		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
> +					DESC_HDR_SEL0_DEU |
> +					DESC_HDR_MODE0_DEU_CBC |
> +					DESC_HDR_MODE0_DEU_3DES |
> +					DESC_HDR_SEL1_MDEUA |
> +					DESC_HDR_MODE1_MDEU_INIT |
> +					DESC_HDR_MODE1_MDEU_PAD |
> +					DESC_HDR_MODE1_MDEU_SHA1_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> @@ -2413,13 +2413,13 @@ static struct talitos_alg_template driver_algs[] = {
>  			.setkey = aead_des3_setkey,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -			             DESC_HDR_SEL0_DEU |
> -		                     DESC_HDR_MODE0_DEU_CBC |
> -		                     DESC_HDR_MODE0_DEU_3DES |
> -		                     DESC_HDR_SEL1_MDEUA |
> -		                     DESC_HDR_MODE1_MDEU_INIT |
> -		                     DESC_HDR_MODE1_MDEU_PAD |
> -		                     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
> +					DESC_HDR_SEL0_DEU |
> +					DESC_HDR_MODE0_DEU_CBC |
> +					DESC_HDR_MODE0_DEU_3DES |
> +					DESC_HDR_SEL1_MDEUA |
> +					DESC_HDR_MODE1_MDEU_INIT |
> +					DESC_HDR_MODE1_MDEU_PAD |
> +					DESC_HDR_MODE1_MDEU_SHA224_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> @@ -2438,13 +2438,13 @@ static struct talitos_alg_template driver_algs[] = {
>  			.setkey = aead_des3_setkey,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC |
> -				     DESC_HDR_MODE0_DEU_3DES |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
> +					DESC_HDR_SEL0_DEU |
> +					DESC_HDR_MODE0_DEU_CBC |
> +					DESC_HDR_MODE0_DEU_3DES |
> +					DESC_HDR_SEL1_MDEUA |
> +					DESC_HDR_MODE1_MDEU_INIT |
> +					DESC_HDR_MODE1_MDEU_PAD |
> +					DESC_HDR_MODE1_MDEU_SHA224_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.alg.aead = {
> @@ -2460,12 +2460,12 @@ static struct talitos_alg_template driver_algs[] = {
>  			.maxauthsize = SHA256_DIGEST_SIZE,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -			             DESC_HDR_SEL0_AESU |
> -		                     DESC_HDR_MODE0_AESU_CBC |
> -		                     DESC_HDR_SEL1_MDEUA |
> -		                     DESC_HDR_MODE1_MDEU_INIT |
> -		                     DESC_HDR_MODE1_MDEU_PAD |
> -		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
> +					DESC_HDR_SEL0_AESU |
> +					DESC_HDR_MODE0_AESU_CBC |
> +					DESC_HDR_SEL1_MDEUA |
> +					DESC_HDR_MODE1_MDEU_INIT |
> +					DESC_HDR_MODE1_MDEU_PAD |
> +					DESC_HDR_MODE1_MDEU_SHA256_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> @@ -2505,13 +2505,13 @@ static struct talitos_alg_template driver_algs[] = {
>  			.setkey = aead_des3_setkey,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -			             DESC_HDR_SEL0_DEU |
> -		                     DESC_HDR_MODE0_DEU_CBC |
> -		                     DESC_HDR_MODE0_DEU_3DES |
> -		                     DESC_HDR_SEL1_MDEUA |
> -		                     DESC_HDR_MODE1_MDEU_INIT |
> -		                     DESC_HDR_MODE1_MDEU_PAD |
> -		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
> +					DESC_HDR_SEL0_DEU |
> +					DESC_HDR_MODE0_DEU_CBC |
> +					DESC_HDR_MODE0_DEU_3DES |
> +					DESC_HDR_SEL1_MDEUA |
> +					DESC_HDR_MODE1_MDEU_INIT |
> +					DESC_HDR_MODE1_MDEU_PAD |
> +					DESC_HDR_MODE1_MDEU_SHA256_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> @@ -2530,13 +2530,13 @@ static struct talitos_alg_template driver_algs[] = {
>  			.setkey = aead_des3_setkey,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_DEU |
> -				     DESC_HDR_MODE0_DEU_CBC |
> -				     DESC_HDR_MODE0_DEU_3DES |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
> +					DESC_HDR_SEL0_DEU |
> +					DESC_HDR_MODE0_DEU_CBC |
> +					DESC_HDR_MODE0_DEU_3DES |
> +					DESC_HDR_SEL1_MDEUA |
> +					DESC_HDR_MODE1_MDEU_INIT |
> +					DESC_HDR_MODE1_MDEU_PAD |
> +					DESC_HDR_MODE1_MDEU_SHA256_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.alg.aead = {
> @@ -2552,12 +2552,12 @@ static struct talitos_alg_template driver_algs[] = {
>  			.maxauthsize = SHA384_DIGEST_SIZE,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -			             DESC_HDR_SEL0_AESU |
> -		                     DESC_HDR_MODE0_AESU_CBC |
> -		                     DESC_HDR_SEL1_MDEUB |
> -		                     DESC_HDR_MODE1_MDEU_INIT |
> -		                     DESC_HDR_MODE1_MDEU_PAD |
> -		                     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
> +					DESC_HDR_SEL0_AESU |
> +					DESC_HDR_MODE0_AESU_CBC |
> +					DESC_HDR_SEL1_MDEUB |
> +					DESC_HDR_MODE1_MDEU_INIT |
> +					DESC_HDR_MODE1_MDEU_PAD |
> +					DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.alg.aead = {
> @@ -2575,13 +2575,13 @@ static struct talitos_alg_template driver_algs[] = {
>  			.setkey = aead_des3_setkey,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -			             DESC_HDR_SEL0_DEU |
> -		                     DESC_HDR_MODE0_DEU_CBC |
> -		                     DESC_HDR_MODE0_DEU_3DES |
> -		                     DESC_HDR_SEL1_MDEUB |
> -		                     DESC_HDR_MODE1_MDEU_INIT |
> -		                     DESC_HDR_MODE1_MDEU_PAD |
> -		                     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
> +				DESC_HDR_SEL0_DEU |
> +				DESC_HDR_MODE0_DEU_CBC |
> +				DESC_HDR_MODE0_DEU_3DES |
> +				DESC_HDR_SEL1_MDEUB |
> +				DESC_HDR_MODE1_MDEU_INIT |
> +				DESC_HDR_MODE1_MDEU_PAD |
> +				DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.alg.aead = {
> @@ -2597,12 +2597,12 @@ static struct talitos_alg_template driver_algs[] = {
>  			.maxauthsize = SHA512_DIGEST_SIZE,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -			             DESC_HDR_SEL0_AESU |
> -		                     DESC_HDR_MODE0_AESU_CBC |
> -		                     DESC_HDR_SEL1_MDEUB |
> -		                     DESC_HDR_MODE1_MDEU_INIT |
> -		                     DESC_HDR_MODE1_MDEU_PAD |
> -		                     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
> +					DESC_HDR_SEL0_AESU |
> +					DESC_HDR_MODE0_AESU_CBC |
> +					DESC_HDR_SEL1_MDEUB |
> +					DESC_HDR_MODE1_MDEU_INIT |
> +					DESC_HDR_MODE1_MDEU_PAD |
> +					DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.alg.aead = {
> @@ -2620,13 +2620,13 @@ static struct talitos_alg_template driver_algs[] = {
>  			.setkey = aead_des3_setkey,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -			             DESC_HDR_SEL0_DEU |
> -		                     DESC_HDR_MODE0_DEU_CBC |
> -		                     DESC_HDR_MODE0_DEU_3DES |
> -		                     DESC_HDR_SEL1_MDEUB |
> -		                     DESC_HDR_MODE1_MDEU_INIT |
> -		                     DESC_HDR_MODE1_MDEU_PAD |
> -		                     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
> +					DESC_HDR_SEL0_DEU |
> +					DESC_HDR_MODE0_DEU_CBC |
> +					DESC_HDR_MODE0_DEU_3DES |
> +					DESC_HDR_SEL1_MDEUB |
> +					DESC_HDR_MODE1_MDEU_INIT |
> +					DESC_HDR_MODE1_MDEU_PAD |
> +					DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.alg.aead = {
> @@ -2642,12 +2642,12 @@ static struct talitos_alg_template driver_algs[] = {
>  			.maxauthsize = MD5_DIGEST_SIZE,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -			             DESC_HDR_SEL0_AESU |
> -		                     DESC_HDR_MODE0_AESU_CBC |
> -		                     DESC_HDR_SEL1_MDEUA |
> -		                     DESC_HDR_MODE1_MDEU_INIT |
> -		                     DESC_HDR_MODE1_MDEU_PAD |
> -		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
> +					DESC_HDR_SEL0_AESU |
> +					DESC_HDR_MODE0_AESU_CBC |
> +					DESC_HDR_SEL1_MDEUA |
> +					DESC_HDR_MODE1_MDEU_INIT |
> +					DESC_HDR_MODE1_MDEU_PAD |
> +					DESC_HDR_MODE1_MDEU_MD5_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> @@ -2664,12 +2664,12 @@ static struct talitos_alg_template driver_algs[] = {
>  			.maxauthsize = MD5_DIGEST_SIZE,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
> -				     DESC_HDR_SEL0_AESU |
> -				     DESC_HDR_MODE0_AESU_CBC |
> -				     DESC_HDR_SEL1_MDEUA |
> -				     DESC_HDR_MODE1_MDEU_INIT |
> -				     DESC_HDR_MODE1_MDEU_PAD |
> -				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
> +					DESC_HDR_SEL0_AESU |
> +					DESC_HDR_MODE0_AESU_CBC |
> +					DESC_HDR_SEL1_MDEUA |
> +					DESC_HDR_MODE1_MDEU_INIT |
> +					DESC_HDR_MODE1_MDEU_PAD |
> +					DESC_HDR_MODE1_MDEU_MD5_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.alg.aead = {
> @@ -2686,13 +2686,13 @@ static struct talitos_alg_template driver_algs[] = {
>  			.setkey = aead_des3_setkey,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
> -			             DESC_HDR_SEL0_DEU |
> -		                     DESC_HDR_MODE0_DEU_CBC |
> -		                     DESC_HDR_MODE0_DEU_3DES |
> -		                     DESC_HDR_SEL1_MDEUA |
> -		                     DESC_HDR_MODE1_MDEU_INIT |
> -		                     DESC_HDR_MODE1_MDEU_PAD |
> -		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
> +					DESC_HDR_SEL0_DEU |
> +					DESC_HDR_MODE0_DEU_CBC |
> +					DESC_HDR_MODE0_DEU_3DES |
> +					DESC_HDR_SEL1_MDEUA |
> +					DESC_HDR_MODE1_MDEU_INIT |
> +					DESC_HDR_MODE1_MDEU_PAD |
> +					DESC_HDR_MODE1_MDEU_MD5_HMAC,
>  	},
>  	{	.type = CRYPTO_ALG_TYPE_AEAD,
>  		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
> @@ -2839,9 +2839,9 @@ static struct talitos_alg_template driver_algs[] = {
>  			.setkey = skcipher_des3_setkey,
>  		},
>  		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> -			             DESC_HDR_SEL0_DEU |
> -		                     DESC_HDR_MODE0_DEU_CBC |
> -		                     DESC_HDR_MODE0_DEU_3DES,
> +					DESC_HDR_SEL0_DEU |
> +					DESC_HDR_MODE0_DEU_CBC |
> +					DESC_HDR_MODE0_DEU_3DES,
>  	},
>  	/* AHASH algorithms. */
>  	{	.type = CRYPTO_ALG_TYPE_AHASH,
> @@ -3131,7 +3131,7 @@ static int hw_supports(struct device *dev,  
> __be32 desc_hdr_template)
>
>  	if (SECONDARY_EU(desc_hdr_template))
>  		ret = ret && (1 << SECONDARY_EU(desc_hdr_template)
> -		              & priv->exec_units);
> +				& priv->exec_units);
>
>  	return ret;
>  }
> @@ -3176,7 +3176,7 @@ static int talitos_remove(struct  
> platform_device *ofdev)
>
>  static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
>  						    struct talitos_alg_template
> -						           *template)
> +							*template)
>  {
>  	struct talitos_private *priv = dev_get_drvdata(dev);
>  	struct talitos_crypto_alg *t_alg;
> --
> 2.17.1


