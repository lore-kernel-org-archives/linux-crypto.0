Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1085EC43458
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBBDD206F2
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 19:07:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="tfzjc700"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730747AbgGUTHp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 15:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730423AbgGUTGx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 15:06:53 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57030C0619E7
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:52 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id q15so3869009wmj.2
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2020 12:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ye5KXYszmUgdMbY4hh8QVlVaUGxv1nepx3RABTuuOAw=;
        b=tfzjc700oDwIeA6AfrGfykH3kyfdSnlGuXAtw7rlEs2sqChfm9e66NbTlsiCAnTCAH
         ukPXWe1iXZdk2l/CuLY0rEr53GSthOVUi9wXetBm9bksJs702Dlv3RIbhQeTqWUQIh7p
         r+mgASOfxxit9305rDF5kl0nijlhRxi6ZOGZ7zaEf9U3mrvngfLycy+vhmUaH1kxTlqf
         R8tRDJI+Kl/44383BQ3ClvD4qUSSNrY8E0NGiZm+x4PYUsYSOAHTa+WW0VjezwHquyBm
         DHV01uBDeaITYHIAxU4hUZ1udtmG+3NrZYqkeqD/Zkw5W5dIUIjF4iZTvip9Io3GQAUv
         oVVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ye5KXYszmUgdMbY4hh8QVlVaUGxv1nepx3RABTuuOAw=;
        b=GQCnlQZagmFOjI8pe2uymAdOrx+ZSvoIlersVDAt7j0EE4az2uApZTY41O/zHEH2M2
         g+Sb+8Jrq58/fV66JM76aCiSHb5d5Y2BU3luD0cF8SjbDwKKaBAdZC3b4k0eAdiIHkZ7
         z91n/ARJRKa5Yme72abj45P9x1XZBMdPDioazyKKedELSkaOnzyVqIzLGUI6t0RqZvno
         N1vMrQ3Gv4XDh7pId4rOFgFluWdHM20lreDe8Dyiy028kqq55L0xrLB6sF4nMYgKl83g
         L83C2E8oYaDSkou/jolMdgFR4RrgQz7EGyN2UnXLAswfyVCFRfkV18UxdC1xURHQiR54
         uoLg==
X-Gm-Message-State: AOAM530WvD6NsmiXBGN7Wil+r4PgX8OePLpEYnC5V6rAxKWg4BkH9lJM
        NhXQoK40o4mmqoF8AoisUH8V/Q==
X-Google-Smtp-Source: ABdhPJzb+/Jf6SzNRba4/X5n0mL30RVfn9A1CixCesbvq+n+zkE8/N5h1I8WtJNpO0PGMn3Oy7EkVg==
X-Received: by 2002:a1c:56c3:: with SMTP id k186mr4185031wmb.21.1595358411059;
        Tue, 21 Jul 2020 12:06:51 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id s14sm25794848wrv.24.2020.07.21.12.06.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 12:06:50 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 10/17] crypto: sun8i-ce: handle different error registers
Date:   Tue, 21 Jul 2020 19:06:24 +0000
Message-Id: <1595358391-34525-11-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
References: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Error registers are different across SoCs.
This patch handle those difference.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c | 62 ++++++++++++++++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  |  8 +++
 2 files changed, 62 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 0b47a51e1cfc..4cc98180be3f 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -40,7 +40,8 @@ static const struct ce_variant ce_h3_variant = {
 	.ce_clks = {
 		{ "bus", 0, 200000000 },
 		{ "mod", 50000000, 0 },
-		}
+		},
+	.esr = ESR_H3,
 };
 
 static const struct ce_variant ce_h5_variant = {
@@ -51,7 +52,8 @@ static const struct ce_variant ce_h5_variant = {
 	.ce_clks = {
 		{ "bus", 0, 200000000 },
 		{ "mod", 300000000, 0 },
-		}
+		},
+	.esr = ESR_H5,
 };
 
 static const struct ce_variant ce_h6_variant = {
@@ -64,7 +66,8 @@ static const struct ce_variant ce_h6_variant = {
 		{ "bus", 0, 200000000 },
 		{ "mod", 300000000, 0 },
 		{ "ram", 0, 400000000 },
-		}
+		},
+	.esr = ESR_H6,
 };
 
 static const struct ce_variant ce_a64_variant = {
@@ -75,7 +78,8 @@ static const struct ce_variant ce_a64_variant = {
 	.ce_clks = {
 		{ "bus", 0, 200000000 },
 		{ "mod", 300000000, 0 },
-		}
+		},
+	.esr = ESR_A64,
 };
 
 static const struct ce_variant ce_r40_variant = {
@@ -86,7 +90,8 @@ static const struct ce_variant ce_r40_variant = {
 	.ce_clks = {
 		{ "bus", 0, 200000000 },
 		{ "mod", 300000000, 0 },
-		}
+		},
+	.esr = ESR_R40,
 };
 
 /*
@@ -102,6 +107,7 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 {
 	u32 v;
 	int err = 0;
+	struct ce_task *cet = ce->chanlist[flow].tl;
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	ce->chanlist[flow].stat_req++;
@@ -131,19 +137,56 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 			msecs_to_jiffies(ce->chanlist[flow].timeout));
 
 	if (ce->chanlist[flow].status == 0) {
-		dev_err(ce->dev, "DMA timeout for %s\n", name);
+		dev_err(ce->dev, "DMA timeout for %s (tm=%d) on flow %d\n", name,
+			ce->chanlist[flow].timeout, flow);
 		err = -EFAULT;
 	}
 	/* No need to lock for this read, the channel is locked so
 	 * nothing could modify the error value for this channel
 	 */
 	v = readl(ce->base + CE_ESR);
-	if (v) {
+	switch (ce->variant->esr) {
+	case ESR_H3:
+		/* Sadly, the error bit is not per flow */
+		if (v) {
+			dev_err(ce->dev, "CE ERROR: %x for flow %x\n", v, flow);
+			err = -EFAULT;
+			print_hex_dump(KERN_INFO, "TASK: ", DUMP_PREFIX_NONE, 16, 4,
+				       cet, sizeof(struct ce_task), false);
+		}
+		if (v & CE_ERR_ALGO_NOTSUP)
+			dev_err(ce->dev, "CE ERROR: algorithm not supported\n");
+		if (v & CE_ERR_DATALEN)
+			dev_err(ce->dev, "CE ERROR: data length error\n");
+		if (v & CE_ERR_KEYSRAM)
+			dev_err(ce->dev, "CE ERROR: keysram access error for AES\n");
+		break;
+	case ESR_A64:
+	case ESR_H5:
+	case ESR_R40:
 		v >>= (flow * 4);
+		v &= 0xF;
+		if (v) {
+			dev_err(ce->dev, "CE ERROR: %x for flow %x\n", v, flow);
+			err = -EFAULT;
+			print_hex_dump(KERN_INFO, "TASK: ", DUMP_PREFIX_NONE, 16, 4,
+				       cet, sizeof(struct ce_task), false);
+		}
+		if (v & CE_ERR_ALGO_NOTSUP)
+			dev_err(ce->dev, "CE ERROR: algorithm not supported\n");
+		if (v & CE_ERR_DATALEN)
+			dev_err(ce->dev, "CE ERROR: data length error\n");
+		if (v & CE_ERR_KEYSRAM)
+			dev_err(ce->dev, "CE ERROR: keysram access error for AES\n");
+		break;
+	case ESR_H6:
+		v >>= (flow * 8);
 		v &= 0xFF;
 		if (v) {
 			dev_err(ce->dev, "CE ERROR: %x for flow %x\n", v, flow);
 			err = -EFAULT;
+			print_hex_dump(KERN_INFO, "TASK: ", DUMP_PREFIX_NONE, 16, 4,
+				       cet, sizeof(struct ce_task), false);
 		}
 		if (v & CE_ERR_ALGO_NOTSUP)
 			dev_err(ce->dev, "CE ERROR: algorithm not supported\n");
@@ -153,7 +196,10 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
 			dev_err(ce->dev, "CE ERROR: keysram access error for AES\n");
 		if (v & CE_ERR_ADDR_INVALID)
 			dev_err(ce->dev, "CE ERROR: address invalid\n");
-		}
+		if (v & CE_ERR_KEYLADDER)
+			dev_err(ce->dev, "CE ERROR: key ladder configuration error\n");
+		break;
+	}
 
 	return err;
 }
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 084a962b8d4f..eea0847dc1e8 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -65,6 +65,12 @@
 #define CE_ERR_ADDR_INVALID	BIT(5)
 #define CE_ERR_KEYLADDER	BIT(6)
 
+#define ESR_H3	0
+#define ESR_A64	1
+#define ESR_R40	2
+#define ESR_H5	3
+#define ESR_H6	4
+
 #define CE_DIE_ID_SHIFT	16
 #define CE_DIE_ID_MASK	0x07
 
@@ -94,12 +100,14 @@ struct ce_clock {
  * @has_t_dlen_in_bytes:	Does the request size for cipher is in
  *				bytes or words
  * @ce_clks:	list of clocks needed by this variant
+ * @esr:	The type of error register
  */
 struct ce_variant {
 	char alg_cipher[CE_ID_CIPHER_MAX];
 	u32 op_mode[CE_ID_OP_MAX];
 	bool has_t_dlen_in_bytes;
 	struct ce_clock ce_clks[CE_MAX_CLOCKS];
+	int esr;
 };
 
 struct sginfo {
-- 
2.26.2

