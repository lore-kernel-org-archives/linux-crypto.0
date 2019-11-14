Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48312C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 14:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1505D2070E
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 14:48:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gFm9i5+Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfKNOsi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 09:48:38 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55346 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbfKNOsh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 09:48:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so5954810wmb.5;
        Thu, 14 Nov 2019 06:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=osQPobpkOPnRC9LXPzS0ICaLsSaTgnPD7uH0HuL7bsg=;
        b=gFm9i5+Q4erupPrQYD6hQx0NKLe5zgJP0SlHfMTD5BEfvWIDz3mr2NfUsaFysX/mnR
         Oc4VITBDZYrIqiwZ34l3GoJ/SqxuSi+xhAK8kgFJmXlsxxGL3QiVtJhpK45COXk1LvRm
         2KyIpi8iT9VNeB0r6mhX9TLucAi1QK5L0nS2KlhrhL6b8xNI59NenZqwa07IsRxULGW/
         x7PSuPd6cU3YImqIKoFRnSEw9S9DsPhMdM5VhNqkw+GATxDqeY5X9fYIwCS+uFBWA1ir
         W7eJGT/xmmMTWz/j3hv0t/Hs8b3/UWpk2/K29up+DWHC2flGpj+wXH/UNnWQ8csAAm6q
         jnKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=osQPobpkOPnRC9LXPzS0ICaLsSaTgnPD7uH0HuL7bsg=;
        b=nXhGpzfppKAs31As9HgYo8GThiUdvamGQmp9ZaklR7vh7ZrE19HxY+XjAnjJhJanEb
         n4T9Quql8UaY70Xkdj82QeOSvkco/BGDdbkk72Q0z2ZcZFRKeuymvpurX+xsEZcyCFAh
         q0npBWO9+fgR1aWELkC75bN/6nn2T9Vw4fwOp679smX9Hibfm8y0QSUzMY3ji8Qoy0fP
         BAb0wV8SrVU3pAUJ0/5CKNl1cvm9NcnO7hUOFWf2KO9nf6RhQVu8uah/7ECkW9flLRnv
         Bnzz0Ca9tiQ4XJcnkKx/9OpaT6ntgxA05K0VSAVyWvq01YUt3A7zco90aSjp8m3PYhC6
         imfA==
X-Gm-Message-State: APjAAAWH0YqRZKVzxYG+LyFoTv8Az96Mwp4X5A/Cqosy3CotTGIsKjFZ
        xp1UVgqyr12LsKYACdbJJyQ=
X-Google-Smtp-Source: APXvYqy6S2n65N2oW3nP74LsGjZD7yPbedKs0jyxo0652I/j5zyvyuAQz5KODGEsdg2mDL2R1jlh+Q==
X-Received: by 2002:a7b:ce08:: with SMTP id m8mr8188339wmc.68.1573742914630;
        Thu, 14 Nov 2019 06:48:34 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id v9sm7153223wrs.95.2019.11.14.06.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 06:48:34 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/3] crypto: sun4i-ss: add the A33 variant of SecuritySystem
Date:   Thu, 14 Nov 2019 15:48:12 +0100
Message-Id: <20191114144812.22747-4-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191114144812.22747-1-clabbe.montjoie@gmail.com>
References: <20191114144812.22747-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The A33 SecuritySystem has a difference with all other SS, it give SHA1 digest
directly in BE.
So this patch adds variant support in sun4i-ss.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 .../crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 22 ++++++++++++++++++-
 .../crypto/allwinner/sun4i-ss/sun4i-ss-hash.c |  5 ++++-
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  |  9 ++++++++
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
index 814cd12149a9..d35a05843c22 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <crypto/scatterwalk.h>
 #include <linux/scatterlist.h>
@@ -22,6 +23,14 @@
 
 #include "sun4i-ss.h"
 
+static const struct ss_variant ss_a10_variant = {
+	.sha1_in_be = false,
+};
+
+static const struct ss_variant ss_a33_variant = {
+	.sha1_in_be = true,
+};
+
 static struct sun4i_ss_alg_template ss_algs[] = {
 {       .type = CRYPTO_ALG_TYPE_AHASH,
 	.mode = SS_OP_MD5,
@@ -323,6 +332,12 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 		return PTR_ERR(ss->base);
 	}
 
+	ss->variant = of_device_get_match_data(&pdev->dev);
+	if (!ss->variant) {
+		dev_err(&pdev->dev, "Missing Security System variant\n");
+		return -EINVAL;
+	}
+
 	ss->ssclk = devm_clk_get(&pdev->dev, "mod");
 	if (IS_ERR(ss->ssclk)) {
 		err = PTR_ERR(ss->ssclk);
@@ -484,7 +499,12 @@ static int sun4i_ss_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id a20ss_crypto_of_match_table[] = {
-	{ .compatible = "allwinner,sun4i-a10-crypto" },
+	{ .compatible = "allwinner,sun4i-a10-crypto",
+	  .data = &ss_a10_variant
+	},
+	{ .compatible = "allwinner,sun8i-a33-crypto",
+	  .data = &ss_a33_variant
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, a20ss_crypto_of_match_table);
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
index 91cf58db3845..c791d6935c65 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-hash.c
@@ -478,7 +478,10 @@ static int sun4i_hash(struct ahash_request *areq)
 	/* Get the hash from the device */
 	if (op->mode == SS_OP_SHA1) {
 		for (i = 0; i < 5; i++) {
-			v = cpu_to_be32(readl(ss->base + SS_MD0 + i * 4));
+			if (ss->variant->sha1_in_be)
+				v = cpu_to_le32(readl(ss->base + SS_MD0 + i * 4));
+			else
+				v = cpu_to_be32(readl(ss->base + SS_MD0 + i * 4));
 			memcpy(areq->result + i * 4, &v, 4);
 		}
 	} else {
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
index 60425ac75d90..2b4c6333eb67 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
@@ -131,7 +131,16 @@
 #define SS_SEED_LEN 192
 #define SS_DATA_LEN 160
 
+/*
+ * struct ss_variant - Describe SS hardware variant
+ * @sha1_in_be:		The SHA1 digest is given by SS in BE, and so need to be inverted.
+ */
+struct ss_variant {
+	bool sha1_in_be;
+};
+
 struct sun4i_ss_ctx {
+	const struct ss_variant *variant;
 	void __iomem *base;
 	int irq;
 	struct clk *busclk;
-- 
2.23.0

