Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D648C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D34720838
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 15:34:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q23wTPyo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404459AbfIFPer (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 11:34:47 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42787 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404530AbfIFPer (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 11:34:47 -0400
Received: by mail-ed1-f68.google.com with SMTP id y91so6654268ede.9
        for <linux-crypto@vger.kernel.org>; Fri, 06 Sep 2019 08:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dAAzGIhCxm/LOlY3aIkQquAnjHh7ebzmiAzVPFgI/KM=;
        b=Q23wTPyo/IDB0k86RcU1LdA6PC6GQVp/ymINwkN9vWPzrchWqGqaHxq2SHOvgU0cnk
         2aebNFHszd8If63VmgQSUEVhu288E3K4t5Yl+i5gSJ/2EYDQ3cHU1Fu915r9Le37Lgc8
         EgLfC6jX9QIXiAHpth4VOeKsXNHVrJ8VDeagci5GVPxpU9jPunsH0lJQeRMRkdupgDyT
         zgGP/CBxMmAPmGK5AlYOxzGnI7IKETuiTXlLuYk95nRUbIECT9jFxw698eomXDRvjsGj
         pqGULd89fR4OjWYxGUw6worQqCXTXJsJVI2TCaPMVsbLm3J1k9SHxL5+QhYRdvCMM1PM
         j9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dAAzGIhCxm/LOlY3aIkQquAnjHh7ebzmiAzVPFgI/KM=;
        b=VjA1CelaJAh/BnL4NwRFRl21GVULh11Sq6A/nX7jrNFygWMb3blsOVzAkRuyB4uuHd
         e7/3aTnlXU1E70pXeL3u2MClA4TN716IvOtI2FcXqON2r2zDv0BUEJQAbIFqSECBo68K
         cibtHU0Vajt7aeZQ9kO1EdO3GTZMUOVT+BaQcVNOLpNlIav2gEMVPkLEe5sHgCDLdHFL
         obQ4kJ4k6aGfSv0ucxihG27Yh1pRBDe4WHFiVCVKulvBPlX+o/3DmkkWjpwzinxDcBto
         fuUVb/+htPaJ2CsekKIeMhcw193uXOXlfg/gnV3ViAq3gaHS+qCETAPON9bBlGovNU0+
         vsdA==
X-Gm-Message-State: APjAAAVS626kXwHwY/W4imrVABKaLQj+D9dWwng+M05jh2zNR1RlyCr0
        5i3kchgm3adsOZVhv6K/A4oi/9As
X-Google-Smtp-Source: APXvYqwJ2Sj3LL5qSFgJ1JKg/o5fY5a3ukTK/AISXyKrc7XLO2fOVZS+aMJLFNCDgJRoIEqEogTemQ==
X-Received: by 2002:a50:ed89:: with SMTP id h9mr10209322edr.217.1567784084108;
        Fri, 06 Sep 2019 08:34:44 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id c22sm995218eds.30.2019.09.06.08.34.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 08:34:43 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 6/6] crypto: inside-secure - Probe transform record cache RAM sizes
Date:   Fri,  6 Sep 2019 16:31:53 +0200
Message-Id: <1567780313-1579-7-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567780313-1579-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1567780313-1579-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch actually probes the transform record cache data and
administration RAM sizes, instead of making assumptions, and then
configures the TRC based on the actually probed values.
This allows the driver to work with EIP197 HW that has TRC RAM
sizes different from those of the Marvell EIP197B/D variants.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 229 ++++++++++++++++++++++++++------
 drivers/crypto/inside-secure/safexcel.h |  21 +--
 2 files changed, 200 insertions(+), 50 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index a607786..a34bf8c 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -28,63 +28,205 @@
 module_param(max_rings, uint, 0644);
 MODULE_PARM_DESC(max_rings, "Maximum number of rings to use.");
 
-static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
+static void eip197_trc_cache_setupvirt(struct safexcel_crypto_priv *priv)
 {
-	u32 val, htable_offset;
-	int i, cs_rc_max, cs_ht_wc, cs_trc_rec_wc, cs_trc_lg_rec_wc;
-
-	if (priv->version == EIP197D_MRVL) {
-		cs_rc_max = EIP197D_CS_RC_MAX;
-		cs_ht_wc = EIP197D_CS_HT_WC;
-		cs_trc_rec_wc = EIP197D_CS_TRC_REC_WC;
-		cs_trc_lg_rec_wc = EIP197D_CS_TRC_LG_REC_WC;
-	} else {
-		/* Default to minimum "safe" settings */
-		cs_rc_max = EIP197B_CS_RC_MAX;
-		cs_ht_wc = EIP197B_CS_HT_WC;
-		cs_trc_rec_wc = EIP197B_CS_TRC_REC_WC;
-		cs_trc_lg_rec_wc = EIP197B_CS_TRC_LG_REC_WC;
+	int i;
+
+	/*
+	 * Map all interfaces/rings to register index 0
+	 * so they can share contexts. Without this, the EIP197 will
+	 * assume each interface/ring to be in its own memory domain
+	 * i.e. have its own subset of UNIQUE memory addresses.
+	 * Which would cause records with the SAME memory address to
+	 * use DIFFERENT cache buffers, causing both poor cache utilization
+	 * AND serious coherence/invalidation issues.
+	 */
+	for (i = 0; i < 4; i++)
+		writel(0, priv->base + EIP197_FLUE_IFC_LUT(i));
+
+	/*
+	 * Initialize other virtualization regs for cache
+	 * These may not be in their reset state ...
+	 */
+	for (i = 0; i < priv->config.rings; i++) {
+		writel(0, priv->base + EIP197_FLUE_CACHEBASE_LO(i));
+		writel(0, priv->base + EIP197_FLUE_CACHEBASE_HI(i));
+		writel(EIP197_FLUE_CONFIG_MAGIC,
+		       priv->base + EIP197_FLUE_CONFIG(i));
 	}
+	writel(0, priv->base + EIP197_FLUE_OFFSETS);
+	writel(0, priv->base + EIP197_FLUE_ARC4_OFFSET);
+}
 
-	/* Enable the record cache memory access */
-	val = readl(priv->base + EIP197_CS_RAM_CTRL);
-	val &= ~EIP197_TRC_ENABLE_MASK;
-	val |= EIP197_TRC_ENABLE_0;
-	writel(val, priv->base + EIP197_CS_RAM_CTRL);
+static void eip197_trc_cache_banksel(struct safexcel_crypto_priv *priv,
+				     u32 addrmid, int *actbank)
+{
+	u32 val;
+	int curbank;
+
+	curbank = addrmid >> 16;
+	if (curbank != *actbank) {
+		val = readl(priv->base + EIP197_CS_RAM_CTRL);
+		val = (val & ~EIP197_CS_BANKSEL_MASK) |
+		      (curbank << EIP197_CS_BANKSEL_OFS);
+		writel(val, priv->base + EIP197_CS_RAM_CTRL);
+		*actbank = curbank;
+	}
+}
 
-	/* Clear all ECC errors */
-	writel(0, priv->base + EIP197_TRC_ECCCTRL);
+static u32 eip197_trc_cache_probe(struct safexcel_crypto_priv *priv,
+				  int maxbanks, u32 probemask)
+{
+	u32 val, addrhi, addrlo, addrmid;
+	int actbank;
 
 	/*
-	 * Make sure the cache memory is accessible by taking record cache into
-	 * reset.
+	 * And probe the actual size of the physically attached cache data RAM
+	 * Using a binary subdivision algorithm downto 32 byte cache lines.
 	 */
-	val = readl(priv->base + EIP197_TRC_PARAMS);
-	val |= EIP197_TRC_PARAMS_SW_RESET;
-	val &= ~EIP197_TRC_PARAMS_DATA_ACCESS;
-	writel(val, priv->base + EIP197_TRC_PARAMS);
+	addrhi = 1 << (16 + maxbanks);
+	addrlo = 0;
+	actbank = min(maxbanks - 1, 0);
+	while ((addrhi - addrlo) > 32) {
+		/* write marker to lowest address in top half */
+		addrmid = (addrhi + addrlo) >> 1;
+		eip197_trc_cache_banksel(priv, addrmid, &actbank);
+		writel((addrmid | (addrlo << 16)) & probemask,
+			priv->base + EIP197_CLASSIFICATION_RAMS +
+			(addrmid & 0xffff));
+
+		/* write marker to lowest address in bottom half */
+		eip197_trc_cache_banksel(priv, addrlo, &actbank);
+		writel((addrlo | (addrhi << 16)) & probemask,
+			priv->base + EIP197_CLASSIFICATION_RAMS +
+			(addrlo & 0xffff));
+
+		/* read back marker from top half */
+		eip197_trc_cache_banksel(priv, addrmid, &actbank);
+		val = readl(priv->base + EIP197_CLASSIFICATION_RAMS +
+			    (addrmid & 0xffff));
+
+		if (val == ((addrmid | (addrlo << 16)) & probemask)) {
+			/* read back correct, continue with top half */
+			addrlo = addrmid;
+		} else {
+			/* not read back correct, continue with bottom half */
+			addrhi = addrmid;
+		}
+	}
+	return addrhi;
+}
+
+static void eip197_trc_cache_clear(struct safexcel_crypto_priv *priv,
+				   int cs_rc_max, int cs_ht_wc)
+{
+	int i;
+	u32 htable_offset, val, offset;
 
-	/* Clear all records */
+	/* Clear all records in administration RAM */
 	for (i = 0; i < cs_rc_max; i++) {
-		u32 val, offset = EIP197_CLASSIFICATION_RAMS + i * EIP197_CS_RC_SIZE;
+		offset = EIP197_CLASSIFICATION_RAMS + i * EIP197_CS_RC_SIZE;
 
 		writel(EIP197_CS_RC_NEXT(EIP197_RC_NULL) |
 		       EIP197_CS_RC_PREV(EIP197_RC_NULL),
 		       priv->base + offset);
 
-		val = EIP197_CS_RC_NEXT(i+1) | EIP197_CS_RC_PREV(i-1);
+		val = EIP197_CS_RC_NEXT(i + 1) | EIP197_CS_RC_PREV(i - 1);
 		if (i == 0)
 			val |= EIP197_CS_RC_PREV(EIP197_RC_NULL);
 		else if (i == cs_rc_max - 1)
 			val |= EIP197_CS_RC_NEXT(EIP197_RC_NULL);
-		writel(val, priv->base + offset + sizeof(u32));
+		writel(val, priv->base + offset + 4);
+		/* must also initialize the address key due to ECC! */
+		writel(0, priv->base + offset + 8);
+		writel(0, priv->base + offset + 12);
 	}
 
 	/* Clear the hash table entries */
 	htable_offset = cs_rc_max * EIP197_CS_RC_SIZE;
 	for (i = 0; i < cs_ht_wc; i++)
 		writel(GENMASK(29, 0),
-		       priv->base + EIP197_CLASSIFICATION_RAMS + htable_offset + i * sizeof(u32));
+		       priv->base + EIP197_CLASSIFICATION_RAMS +
+		       htable_offset + i * sizeof(u32));
+}
+
+static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
+{
+	u32 val, dsize, asize;
+	int cs_rc_max, cs_ht_wc, cs_trc_rec_wc, cs_trc_lg_rec_wc;
+	int cs_rc_abs_max, cs_ht_sz;
+	int maxbanks;
+
+	/* Setup (dummy) virtualization for cache */
+	eip197_trc_cache_setupvirt(priv);
+
+	/*
+	 * Enable the record cache memory access and
+	 * probe the bank select width
+	 */
+	val = readl(priv->base + EIP197_CS_RAM_CTRL);
+	val &= ~EIP197_TRC_ENABLE_MASK;
+	val |= EIP197_TRC_ENABLE_0 | EIP197_CS_BANKSEL_MASK;
+	writel(val, priv->base + EIP197_CS_RAM_CTRL);
+	val = readl(priv->base + EIP197_CS_RAM_CTRL);
+	maxbanks = ((val&EIP197_CS_BANKSEL_MASK)>>EIP197_CS_BANKSEL_OFS) + 1;
+
+	/* Clear all ECC errors */
+	writel(0, priv->base + EIP197_TRC_ECCCTRL);
+
+	/*
+	 * Make sure the cache memory is accessible by taking record cache into
+	 * reset. Need data memory access here, not admin access.
+	 */
+	val = readl(priv->base + EIP197_TRC_PARAMS);
+	val |= EIP197_TRC_PARAMS_SW_RESET | EIP197_TRC_PARAMS_DATA_ACCESS;
+	writel(val, priv->base + EIP197_TRC_PARAMS);
+
+	/* Probed data RAM size in bytes */
+	dsize = eip197_trc_cache_probe(priv, maxbanks, 0xffffffff);
+
+	/*
+	 * Now probe the administration RAM size pretty much the same way
+	 * Except that only the lower 30 bits are writable and we don't need
+	 * bank selects
+	 */
+	val = readl(priv->base + EIP197_TRC_PARAMS);
+	/* admin access now */
+	val &= ~(EIP197_TRC_PARAMS_DATA_ACCESS | EIP197_CS_BANKSEL_MASK);
+	writel(val, priv->base + EIP197_TRC_PARAMS);
+
+	/* Probed admin RAM size in admin words */
+	asize = eip197_trc_cache_probe(priv, 0, 0xbfffffff) >> 4;
+
+	/* Clear any ECC errors detected while probing! */
+	writel(0, priv->base + EIP197_TRC_ECCCTRL);
+
+	/*
+	 * Determine optimal configuration from RAM sizes
+	 * Note that we assume that the physical RAM configuration is sane
+	 * Therefore, we don't do any parameter error checking here ...
+	 */
+
+	/* For now, just use a single record format covering everything */
+	cs_trc_rec_wc = EIP197_CS_TRC_REC_WC;
+	cs_trc_lg_rec_wc = EIP197_CS_TRC_REC_WC;
+
+	/*
+	 * Step #1: How many records will physically fit?
+	 * Hard upper limit is 1023!
+	 */
+	cs_rc_abs_max = min_t(uint, ((dsize >> 2) / cs_trc_lg_rec_wc), 1023);
+	/* Step #2: Need at least 2 words in the admin RAM per record */
+	cs_rc_max = min_t(uint, cs_rc_abs_max, (asize >> 1));
+	/* Step #3: Determine log2 of hash table size */
+	cs_ht_sz = __fls(asize - cs_rc_max) - 2;
+	/* Step #4: determine current size of hash table in dwords */
+	cs_ht_wc = 16<<cs_ht_sz; /* dwords, not admin words */
+	/* Step #5: add back excess words and see if we can fit more records */
+	cs_rc_max = min_t(uint, cs_rc_abs_max, asize - (cs_ht_wc >> 4));
+
+	/* Clear the cache RAMs */
+	eip197_trc_cache_clear(priv, cs_rc_max, cs_ht_wc);
 
 	/* Disable the record cache memory access */
 	val = readl(priv->base + EIP197_CS_RAM_CTRL);
@@ -104,8 +246,11 @@ static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
 	/* Configure the record cache #2 */
 	val = EIP197_TRC_PARAMS_RC_SZ_LARGE(cs_trc_lg_rec_wc) |
 	      EIP197_TRC_PARAMS_BLK_TIMER_SPEED(1) |
-	      EIP197_TRC_PARAMS_HTABLE_SZ(2);
+	      EIP197_TRC_PARAMS_HTABLE_SZ(cs_ht_sz);
 	writel(val, priv->base + EIP197_TRC_PARAMS);
+
+	dev_info(priv->dev, "TRC init: %dd,%da (%dr,%dh)\n",
+		 dsize, asize, cs_rc_max, cs_ht_wc + cs_ht_wc);
 }
 
 static void eip197_init_firmware(struct safexcel_crypto_priv *priv)
@@ -129,7 +274,7 @@ static void eip197_init_firmware(struct safexcel_crypto_priv *priv)
 		/* clear the scratchpad RAM using 32 bit writes only */
 		for (i = 0; i < EIP197_NUM_OF_SCRATCH_BLOCKS; i++)
 			writel(0, EIP197_PE(priv) +
-				  EIP197_PE_ICE_SCRATCH_RAM(pe) + (i<<2));
+				  EIP197_PE_ICE_SCRATCH_RAM(pe) + (i << 2));
 
 		/* Reset the IFPP engine to make its program mem accessible */
 		writel(EIP197_PE_ICE_x_CTRL_SW_RESET |
@@ -309,7 +454,7 @@ static int eip197_load_firmwares(struct safexcel_crypto_priv *priv)
 
 static int safexcel_hw_setup_cdesc_rings(struct safexcel_crypto_priv *priv)
 {
-	u32 hdw, cd_size_rnd, val;
+	u32 cd_size_rnd, val;
 	int i, cd_fetch_cnt;
 
 	cd_size_rnd  = (priv->config.cd_size +
@@ -337,7 +482,8 @@ static int safexcel_hw_setup_cdesc_rings(struct safexcel_crypto_priv *priv)
 		writel(EIP197_xDR_DESC_MODE_64BIT | (priv->config.cd_offset << 16) |
 		       priv->config.cd_size,
 		       EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_DESC_SIZE);
-		writel(((cd_fetch_cnt * (cd_size_rnd << hdw)) << 16) |
+		writel(((cd_fetch_cnt *
+			 (cd_size_rnd << priv->hwconfig.hwdataw)) << 16) |
 		       (cd_fetch_cnt * priv->config.cd_offset),
 		       EIP197_HIA_CDR(priv, i) + EIP197_HIA_xDR_CFG);
 
@@ -356,12 +502,12 @@ static int safexcel_hw_setup_cdesc_rings(struct safexcel_crypto_priv *priv)
 
 static int safexcel_hw_setup_rdesc_rings(struct safexcel_crypto_priv *priv)
 {
-	u32 hdw, rd_size_rnd, val;
+	u32 rd_size_rnd, val;
 	int i, rd_fetch_cnt;
 
 	/* determine number of RD's we can fetch into the FIFO as one block */
 	rd_size_rnd = (EIP197_RD64_FETCH_SIZE +
-		      BIT(priv->hwconfig.hwdataw) - 1) >>
+		       (BIT(priv->hwconfig.hwdataw) - 1)) >>
 		      priv->hwconfig.hwdataw;
 	if (priv->flags & SAFEXCEL_HW_EIP197) {
 		/* EIP197: try to fetch enough in 1 go to keep all pipes busy */
@@ -371,7 +517,7 @@ static int safexcel_hw_setup_rdesc_rings(struct safexcel_crypto_priv *priv)
 	} else {
 		/* for the EIP97, just fetch all that fits minus 1 */
 		rd_fetch_cnt = ((1 << priv->hwconfig.hwrfsize) /
-			       rd_size_rnd) - 1;
+				rd_size_rnd) - 1;
 	}
 
 	for (i = 0; i < priv->config.rings; i++) {
@@ -385,7 +531,8 @@ static int safexcel_hw_setup_rdesc_rings(struct safexcel_crypto_priv *priv)
 		       priv->config.rd_size,
 		       EIP197_HIA_RDR(priv, i) + EIP197_HIA_xDR_DESC_SIZE);
 
-		writel(((rd_fetch_cnt * (rd_size_rnd << hdw)) << 16) |
+		writel(((rd_fetch_cnt *
+			 (rd_size_rnd << priv->hwconfig.hwdataw)) << 16) |
 		       (rd_fetch_cnt * priv->config.rd_offset),
 		       EIP197_HIA_RDR(priv, i) + EIP197_HIA_xDR_CFG);
 
diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
index 19049f1..6ddc6d1 100644
--- a/drivers/crypto/inside-secure/safexcel.h
+++ b/drivers/crypto/inside-secure/safexcel.h
@@ -178,6 +178,12 @@
 #define EIP197_TRC_ECCADMINSTAT			0xf0838
 #define EIP197_TRC_ECCDATASTAT			0xf083c
 #define EIP197_TRC_ECCDATA			0xf0840
+#define EIP197_FLUE_CACHEBASE_LO(n)		(0xf6000 + (32 * (n)))
+#define EIP197_FLUE_CACHEBASE_HI(n)		(0xf6004 + (32 * (n)))
+#define EIP197_FLUE_CONFIG(n)			(0xf6010 + (32 * (n)))
+#define EIP197_FLUE_OFFSETS			0xf6808
+#define EIP197_FLUE_ARC4_OFFSET			0xf680c
+#define EIP197_FLUE_IFC_LUT(n)			(0xf6820 + (4 * (n)))
 #define EIP197_CS_RAM_CTRL			0xf7ff0
 
 /* EIP197_HIA_xDR_DESC_SIZE */
@@ -321,6 +327,9 @@
 #define EIP197_ADDRESS_MODE			BIT(8)
 #define EIP197_CONTROL_MODE			BIT(9)
 
+/* EIP197_FLUE_CONFIG */
+#define EIP197_FLUE_CONFIG_MAGIC		0xc7000004
+
 /* Context Control */
 struct safexcel_context_record {
 	u32 control0;
@@ -396,6 +405,8 @@ struct safexcel_context_record {
 #define EIP197_TRC_ENABLE_1			BIT(5)
 #define EIP197_TRC_ENABLE_2			BIT(6)
 #define EIP197_TRC_ENABLE_MASK			GENMASK(6, 4)
+#define EIP197_CS_BANKSEL_MASK			GENMASK(14, 12)
+#define EIP197_CS_BANKSEL_OFS			12
 
 /* EIP197_TRC_PARAMS */
 #define EIP197_TRC_PARAMS_SW_RESET		BIT(0)
@@ -413,19 +424,11 @@ struct safexcel_context_record {
 #define EIP197_TRC_PARAMS2_RC_SZ_SMALL(n)	((n) << 18)
 
 /* Cache helpers */
-#define EIP197B_CS_RC_MAX			52
-#define EIP197D_CS_RC_MAX			96
+#define EIP197_CS_TRC_REC_WC			64
 #define EIP197_CS_RC_SIZE			(4 * sizeof(u32))
 #define EIP197_CS_RC_NEXT(x)			(x)
 #define EIP197_CS_RC_PREV(x)			((x) << 10)
 #define EIP197_RC_NULL				0x3ff
-#define EIP197B_CS_TRC_REC_WC			59
-#define EIP197D_CS_TRC_REC_WC			64
-#define EIP197B_CS_TRC_LG_REC_WC		73
-#define EIP197D_CS_TRC_LG_REC_WC		80
-#define EIP197B_CS_HT_WC			64
-#define EIP197D_CS_HT_WC			256
-
 
 /* Result data */
 struct result_data_desc {
-- 
1.8.3.1

