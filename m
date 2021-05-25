Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651A5C2B9F8
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 14:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D63A6142C
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 14:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhEYOKo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 May 2021 10:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbhEYOKm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 May 2021 10:10:42 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6C2C06138A;
        Tue, 25 May 2021 07:09:11 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e22so7095166pgv.10;
        Tue, 25 May 2021 07:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=/e/U7fJSKZcxIXMCK9KEbqze3faq7Ma38vE17vz3Eew=;
        b=sZyV1JRgqBTJUzU9kC79SFBnSi59ha8SrAbANym0TkB3kwzAzUc4S6bPzMnBhuABhX
         E5oycWiHYtUwHjgvF/OWKm0lALmh3qmvumn+xt5StR+ctBuL7Udv9fhlmaf9Bo1Hd386
         KtsErfwpv4A8o2dNYPAR73g3dfIgGSE5FfmNoWZZIIevrbg/2dHCz68guIypXrAfUeCX
         wlW8u1+/p7N4JYanwLviOIFNrXs+gNHa3/r12zi5DXF5XEmGUWtcCxeJ/Y7o3Ly8QMB+
         zm7hC0RG5X+p3JWgQWFujyEmGhK/3GZn3vQ4vYMb91CH2xXS5aEYiI/L9kptF07f47Ol
         pwxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=/e/U7fJSKZcxIXMCK9KEbqze3faq7Ma38vE17vz3Eew=;
        b=BpFYUYQwZUWx+Ow+q18ERtlKrCOKyJ1G4e6SM0oQcR98ZOFpXh1Ty3P/0KD9q2hREL
         +fqdRmtaJKYw+SIAHLSqEzNCiLyaazPOW4/Z/e7WXwP+orsL1qsboy9RfhpobzmbRIfL
         XvgoxJ+ihiMWNkoZAvGEyPttdk9IkLDND9xd5U+12KySEij5/2tZN3GhcUeDy49SnS7/
         kD1wOgmQjkjCiHJNNPnD2fvUiQORoFYxT8iKjzm3rUAxrJ8+dAcC3FTTu5O4NEIo74k1
         l0vxK+h1vXPv2s8FMVo9kbwCviqvVHSYlLjuQQ5PqWCVz8A8lFnOx7eCFPrUtjxmq6Pg
         Fyxg==
X-Gm-Message-State: AOAM533rGJf0aVkFG9T/P8wINWtkmk/qBmeyhxiR+zoH+vzc6ajrTLM8
        jtndDFm/oyUrpz3fuiHmWOQFZPuNyCm/+w==
X-Google-Smtp-Source: ABdhPJyYt+R+UVgIkdhTMizVfpi6Z/QOUz982iqTjZ2WyVI1eHeZT7XbKEJqfFVXxpIBNeub/Kr4qw==
X-Received: by 2002:a05:6a00:a:b029:2e0:d1b:59d6 with SMTP id h10-20020a056a00000ab02902e00d1b59d6mr30310027pfk.27.1621951750960;
        Tue, 25 May 2021 07:09:10 -0700 (PDT)
Received: from localhost ([106.193.2.10])
        by smtp.gmail.com with ESMTPSA id h24sm14090798pfn.180.2021.05.25.07.09.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 May 2021 07:09:10 -0700 (PDT)
Date:   Tue, 25 May 2021 19:39:03 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: crypto: talitos.c: Replace space with tabs
Message-ID: <20210525140903.nqj5rdohduzemm4l@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Tabs have been used instead of spaces for indentation
This is done to maintain code uniformity(LINDENT).

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 drivers/crypto/talitos.c | 198 +++++++++++++++++++--------------------
 1 file changed, 99 insertions(+), 99 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 25c9f825b8b5..e40f78ec8c4b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -174,7 +174,7 @@ static int reset_channel(struct device *dev, int ch)
 	/* and ICCR writeback, if available */
 	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
 		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
-		          TALITOS_CCCR_LO_IWSE);
+				TALITOS_CCCR_LO_IWSE);
 
 	return 0;
 }
@@ -249,7 +249,7 @@ static int init_device(struct device *dev)
 	/* disable integrity check error interrupts (use writeback instead) */
 	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
 		setbits32(priv->reg_mdeu + TALITOS_EUICR_LO,
-		          TALITOS_MDEUICR_LO_ICE);
+				TALITOS_MDEUICR_LO_ICE);
 
 	return 0;
 }
@@ -2276,12 +2276,12 @@ static struct talitos_alg_template driver_algs[] = {
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_AESU |
-		                     DESC_HDR_MODE0_AESU_CBC |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
+			DESC_HDR_SEL0_AESU |
+			DESC_HDR_MODE0_AESU_CBC |
+			DESC_HDR_SEL1_MDEUA |
+			DESC_HDR_MODE1_MDEU_INIT |
+			DESC_HDR_MODE1_MDEU_PAD |
+			DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
@@ -2321,13 +2321,13 @@ static struct talitos_alg_template driver_algs[] = {
 			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
+					DESC_HDR_SEL0_DEU |
+					DESC_HDR_MODE0_DEU_CBC |
+					DESC_HDR_MODE0_DEU_3DES |
+					DESC_HDR_SEL1_MDEUA |
+					DESC_HDR_MODE1_MDEU_INIT |
+					DESC_HDR_MODE1_MDEU_PAD |
+					DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
@@ -2413,13 +2413,13 @@ static struct talitos_alg_template driver_algs[] = {
 			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
+					DESC_HDR_SEL0_DEU |
+					DESC_HDR_MODE0_DEU_CBC |
+					DESC_HDR_MODE0_DEU_3DES |
+					DESC_HDR_SEL1_MDEUA |
+					DESC_HDR_MODE1_MDEU_INIT |
+					DESC_HDR_MODE1_MDEU_PAD |
+					DESC_HDR_MODE1_MDEU_SHA224_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
@@ -2438,13 +2438,13 @@ static struct talitos_alg_template driver_algs[] = {
 			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
+					DESC_HDR_SEL0_DEU |
+					DESC_HDR_MODE0_DEU_CBC |
+					DESC_HDR_MODE0_DEU_3DES |
+					DESC_HDR_SEL1_MDEUA |
+					DESC_HDR_MODE1_MDEU_INIT |
+					DESC_HDR_MODE1_MDEU_PAD |
+					DESC_HDR_MODE1_MDEU_SHA224_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
@@ -2460,12 +2460,12 @@ static struct talitos_alg_template driver_algs[] = {
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_AESU |
-		                     DESC_HDR_MODE0_AESU_CBC |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
+					DESC_HDR_SEL0_AESU |
+					DESC_HDR_MODE0_AESU_CBC |
+					DESC_HDR_SEL1_MDEUA |
+					DESC_HDR_MODE1_MDEU_INIT |
+					DESC_HDR_MODE1_MDEU_PAD |
+					DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
@@ -2505,13 +2505,13 @@ static struct talitos_alg_template driver_algs[] = {
 			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
+					DESC_HDR_SEL0_DEU |
+					DESC_HDR_MODE0_DEU_CBC |
+					DESC_HDR_MODE0_DEU_3DES |
+					DESC_HDR_SEL1_MDEUA |
+					DESC_HDR_MODE1_MDEU_INIT |
+					DESC_HDR_MODE1_MDEU_PAD |
+					DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
@@ -2530,13 +2530,13 @@ static struct talitos_alg_template driver_algs[] = {
 			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
+					DESC_HDR_SEL0_DEU |
+					DESC_HDR_MODE0_DEU_CBC |
+					DESC_HDR_MODE0_DEU_3DES |
+					DESC_HDR_SEL1_MDEUA |
+					DESC_HDR_MODE1_MDEU_INIT |
+					DESC_HDR_MODE1_MDEU_PAD |
+					DESC_HDR_MODE1_MDEU_SHA256_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
@@ -2552,12 +2552,12 @@ static struct talitos_alg_template driver_algs[] = {
 			.maxauthsize = SHA384_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_AESU |
-		                     DESC_HDR_MODE0_AESU_CBC |
-		                     DESC_HDR_SEL1_MDEUB |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
+					DESC_HDR_SEL0_AESU |
+					DESC_HDR_MODE0_AESU_CBC |
+					DESC_HDR_SEL1_MDEUB |
+					DESC_HDR_MODE1_MDEU_INIT |
+					DESC_HDR_MODE1_MDEU_PAD |
+					DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
@@ -2575,13 +2575,13 @@ static struct talitos_alg_template driver_algs[] = {
 			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES |
-		                     DESC_HDR_SEL1_MDEUB |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
+				DESC_HDR_SEL0_DEU |
+				DESC_HDR_MODE0_DEU_CBC |
+				DESC_HDR_MODE0_DEU_3DES |
+				DESC_HDR_SEL1_MDEUB |
+				DESC_HDR_MODE1_MDEU_INIT |
+				DESC_HDR_MODE1_MDEU_PAD |
+				DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
@@ -2597,12 +2597,12 @@ static struct talitos_alg_template driver_algs[] = {
 			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_AESU |
-		                     DESC_HDR_MODE0_AESU_CBC |
-		                     DESC_HDR_SEL1_MDEUB |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
+					DESC_HDR_SEL0_AESU |
+					DESC_HDR_MODE0_AESU_CBC |
+					DESC_HDR_SEL1_MDEUB |
+					DESC_HDR_MODE1_MDEU_INIT |
+					DESC_HDR_MODE1_MDEU_PAD |
+					DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
@@ -2620,13 +2620,13 @@ static struct talitos_alg_template driver_algs[] = {
 			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES |
-		                     DESC_HDR_SEL1_MDEUB |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
+					DESC_HDR_SEL0_DEU |
+					DESC_HDR_MODE0_DEU_CBC |
+					DESC_HDR_MODE0_DEU_3DES |
+					DESC_HDR_SEL1_MDEUB |
+					DESC_HDR_MODE1_MDEU_INIT |
+					DESC_HDR_MODE1_MDEU_PAD |
+					DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
@@ -2642,12 +2642,12 @@ static struct talitos_alg_template driver_algs[] = {
 			.maxauthsize = MD5_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_AESU |
-		                     DESC_HDR_MODE0_AESU_CBC |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
+					DESC_HDR_SEL0_AESU |
+					DESC_HDR_MODE0_AESU_CBC |
+					DESC_HDR_SEL1_MDEUA |
+					DESC_HDR_MODE1_MDEU_INIT |
+					DESC_HDR_MODE1_MDEU_PAD |
+					DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
@@ -2664,12 +2664,12 @@ static struct talitos_alg_template driver_algs[] = {
 			.maxauthsize = MD5_DIGEST_SIZE,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
+					DESC_HDR_SEL0_AESU |
+					DESC_HDR_MODE0_AESU_CBC |
+					DESC_HDR_SEL1_MDEUA |
+					DESC_HDR_MODE1_MDEU_INIT |
+					DESC_HDR_MODE1_MDEU_PAD |
+					DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
@@ -2686,13 +2686,13 @@ static struct talitos_alg_template driver_algs[] = {
 			.setkey = aead_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
+					DESC_HDR_SEL0_DEU |
+					DESC_HDR_MODE0_DEU_CBC |
+					DESC_HDR_MODE0_DEU_3DES |
+					DESC_HDR_SEL1_MDEUA |
+					DESC_HDR_MODE1_MDEU_INIT |
+					DESC_HDR_MODE1_MDEU_PAD |
+					DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
 		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
@@ -2839,9 +2839,9 @@ static struct talitos_alg_template driver_algs[] = {
 			.setkey = skcipher_des3_setkey,
 		},
 		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES,
+					DESC_HDR_SEL0_DEU |
+					DESC_HDR_MODE0_DEU_CBC |
+					DESC_HDR_MODE0_DEU_3DES,
 	},
 	/* AHASH algorithms. */
 	{	.type = CRYPTO_ALG_TYPE_AHASH,
@@ -3131,7 +3131,7 @@ static int hw_supports(struct device *dev, __be32 desc_hdr_template)
 
 	if (SECONDARY_EU(desc_hdr_template))
 		ret = ret && (1 << SECONDARY_EU(desc_hdr_template)
-		              & priv->exec_units);
+				& priv->exec_units);
 
 	return ret;
 }
@@ -3176,7 +3176,7 @@ static int talitos_remove(struct platform_device *ofdev)
 
 static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 						    struct talitos_alg_template
-						           *template)
+							*template)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_crypto_alg *t_alg;
-- 
2.17.1

