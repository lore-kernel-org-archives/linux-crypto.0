Return-Path: <SRS0=aQ9n=XM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70C9C4CEC9
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 10:58:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46BB21670
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 10:58:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t3cFc+ZR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfIQK6O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Sep 2019 06:58:14 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39476 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfIQK6O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Sep 2019 06:58:14 -0400
Received: by mail-ed1-f68.google.com with SMTP id g12so2890807eds.6
        for <linux-crypto@vger.kernel.org>; Tue, 17 Sep 2019 03:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=u/Sm1prVqqcjmrC0TkhDmYSkIyM0/8Ira8vhNotBsJ4=;
        b=t3cFc+ZRi61WxXl9kN2IpU+mfOWeicoMYxupWZ9LW4OCnDYbGqjKfF2gQJ5sifN31n
         CSr05jcrswMKKaXx9uu66d+MjbU4bFsa8YOrRSisdRt/7FLCfzXI9Ac4vMp5wb9b+6Mh
         LYC9afkQeT+ntOsxY3Tu1mKVyLRIV8t7dYpnyDscyOSj4Xuj36zNiItxl7dodl4QvlbI
         i1KmG24RqwDFb32Af4MIDoYUKuFHHP19KNvP6XML/+VNzJj+80dgIcUE00K0yG+5b1NB
         +/rLOdF3y1hDP+f34YpAmNV6kRx8KWDdIlxr4ochgO5y3maGWX0rnewuxL3WDZYoQVxq
         JcNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=u/Sm1prVqqcjmrC0TkhDmYSkIyM0/8Ira8vhNotBsJ4=;
        b=Z7lSY8MlkHPvEy1EROQ9mz0zLZ7+Yuk01o+YNcLc7BoMvk+Cr832aAFixTv7kRx0kn
         GKlsDnSL6SkbOPQgq5kamed/iHJuv5A+yrsnf72tb/sKXX3LgVHCfcA0UBx5lusJZjny
         Qp76shgGPDaSgfxMWH0+URWssjDT0/x/O0sBDoTxpM43SbTz942aIQasyfDCnDbGx5In
         MQGnvYETH3gFiQdxrbtqjA/KThFx63BPcsz2j4KYTOsZPZAT9Nv847XDFdsCIhHkn4DC
         vNylLoQcCCWvxmSn5udhcbOXQ0MPSeqMoErC+7eF3ge/4vIIkuCb2+Cm+sin/l3wUaDW
         T/Og==
X-Gm-Message-State: APjAAAVIR/mvmNULEe8kA9DqHG1vBJrtHFBRPw+R9g5CPWY6R9QNDlDh
        M9a0Y4KO6kF4ZjMw6S3SeU+EoLFc
X-Google-Smtp-Source: APXvYqweOfAVn4j77s/Fuid/sNy/1X+6wVVBfA8ri3BT2jCPI3n7qhf7dMGgPLHfOvhEaJN2l3cHjg==
X-Received: by 2002:a17:906:8258:: with SMTP id f24mr4186663ejx.234.1568717891680;
        Tue, 17 Sep 2019 03:58:11 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id i53sm367253eda.33.2019.09.17.03.58.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 03:58:11 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 2/2] crypto: inside-secure - Fixed corner case TRC admin RAM probing issue
Date:   Tue, 17 Sep 2019 11:55:19 +0200
Message-Id: <1568714119-29945-3-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568714119-29945-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568714119-29945-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixed a corner case admin RAM probing issue witnessed on the
Xilinx VCU118 FPGA development board with an EIP197 configuration with
4096 words of admin RAM, of which only 2050 were recognised.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 48 ++++++++++++++++++++++-----------
 drivers/crypto/inside-secure/safexcel.h |  2 ++
 2 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index ac3e1ed..ed34118 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -75,9 +75,9 @@ static void eip197_trc_cache_banksel(struct safexcel_crypto_priv *priv,
 }
 
 static u32 eip197_trc_cache_probe(struct safexcel_crypto_priv *priv,
-				  int maxbanks, u32 probemask)
+				  int maxbanks, u32 probemask, u32 stride)
 {
-	u32 val, addrhi, addrlo, addrmid;
+	u32 val, addrhi, addrlo, addrmid, addralias, delta, marker;
 	int actbank;
 
 	/*
@@ -87,32 +87,37 @@ static u32 eip197_trc_cache_probe(struct safexcel_crypto_priv *priv,
 	addrhi = 1 << (16 + maxbanks);
 	addrlo = 0;
 	actbank = min(maxbanks - 1, 0);
-	while ((addrhi - addrlo) > 32) {
+	while ((addrhi - addrlo) > stride) {
 		/* write marker to lowest address in top half */
 		addrmid = (addrhi + addrlo) >> 1;
+		marker = (addrmid ^ 0xabadbabe) & probemask; /* Unique */
 		eip197_trc_cache_banksel(priv, addrmid, &actbank);
-		writel((addrmid | (addrlo << 16)) & probemask,
+		writel(marker,
 			priv->base + EIP197_CLASSIFICATION_RAMS +
 			(addrmid & 0xffff));
 
-		/* write marker to lowest address in bottom half */
-		eip197_trc_cache_banksel(priv, addrlo, &actbank);
-		writel((addrlo | (addrhi << 16)) & probemask,
-			priv->base + EIP197_CLASSIFICATION_RAMS +
-			(addrlo & 0xffff));
+		/* write invalid markers to possible aliases */
+		delta = 1 << __fls(addrmid);
+		while (delta >= stride) {
+			addralias = addrmid - delta;
+			eip197_trc_cache_banksel(priv, addralias, &actbank);
+			writel(~marker,
+			       priv->base + EIP197_CLASSIFICATION_RAMS +
+			       (addralias & 0xffff));
+			delta >>= 1;
+		}
 
 		/* read back marker from top half */
 		eip197_trc_cache_banksel(priv, addrmid, &actbank);
 		val = readl(priv->base + EIP197_CLASSIFICATION_RAMS +
 			    (addrmid & 0xffff));
 
-		if (val == ((addrmid | (addrlo << 16)) & probemask)) {
+		if ((val & probemask) == marker)
 			/* read back correct, continue with top half */
 			addrlo = addrmid;
-		} else {
+		else
 			/* not read back correct, continue with bottom half */
 			addrhi = addrmid;
-		}
 	}
 	return addrhi;
 }
@@ -150,7 +155,7 @@ static void eip197_trc_cache_clear(struct safexcel_crypto_priv *priv,
 		       htable_offset + i * sizeof(u32));
 }
 
-static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
+static int eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
 {
 	u32 val, dsize, asize;
 	int cs_rc_max, cs_ht_wc, cs_trc_rec_wc, cs_trc_lg_rec_wc;
@@ -183,7 +188,7 @@ static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
 	writel(val, priv->base + EIP197_TRC_PARAMS);
 
 	/* Probed data RAM size in bytes */
-	dsize = eip197_trc_cache_probe(priv, maxbanks, 0xffffffff);
+	dsize = eip197_trc_cache_probe(priv, maxbanks, 0xffffffff, 32);
 
 	/*
 	 * Now probe the administration RAM size pretty much the same way
@@ -196,11 +201,18 @@ static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
 	writel(val, priv->base + EIP197_TRC_PARAMS);
 
 	/* Probed admin RAM size in admin words */
-	asize = eip197_trc_cache_probe(priv, 0, 0xbfffffff) >> 4;
+	asize = eip197_trc_cache_probe(priv, 0, 0x3fffffff, 16) >> 4;
 
 	/* Clear any ECC errors detected while probing! */
 	writel(0, priv->base + EIP197_TRC_ECCCTRL);
 
+	/* Sanity check probing results */
+	if (dsize < EIP197_MIN_DSIZE || asize < EIP197_MIN_ASIZE) {
+		dev_err(priv->dev, "Record cache probing failed (%d,%d).",
+			dsize, asize);
+		return -ENODEV;
+	}
+
 	/*
 	 * Determine optimal configuration from RAM sizes
 	 * Note that we assume that the physical RAM configuration is sane
@@ -251,6 +263,7 @@ static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
 
 	dev_info(priv->dev, "TRC init: %dd,%da (%dr,%dh)\n",
 		 dsize, asize, cs_rc_max, cs_ht_wc + cs_ht_wc);
+	return 0;
 }
 
 static void eip197_init_firmware(struct safexcel_crypto_priv *priv)
@@ -737,7 +750,10 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
 	writel(GENMASK(30, 20), EIP197_HIA_AIC_G(priv) + EIP197_HIA_AIC_G_ACK);
 
 	if (priv->flags & SAFEXCEL_HW_EIP197) {
-		eip197_trc_cache_init(priv);
+		ret = eip197_trc_cache_init(priv);
+		if (ret)
+			return ret;
+
 		priv->flags |= EIP197_TRC_CACHE;
 
 		ret = eip197_load_firmwares(priv);
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index e473dab..0b95389 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -442,6 +442,8 @@ struct safexcel_context_record {
 #define EIP197_TRC_PARAMS2_RC_SZ_SMALL(n)	((n) << 18)
 
 /* Cache helpers */
+#define EIP197_MIN_DSIZE			1024
+#define EIP197_MIN_ASIZE			8
 #define EIP197_CS_TRC_REC_WC			64
 #define EIP197_CS_RC_SIZE			(4 * sizeof(u32))
 #define EIP197_CS_RC_NEXT(x)			(x)
-- 
1.8.3.1

