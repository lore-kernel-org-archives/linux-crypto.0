Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AC448C3E6
	for <linux-crypto@vger.kernel.org>; Wed,  3 Jun 2026 19:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780515202; cv=none; b=P0um1oErOM7Qy++SrAA2MmPKufR8Qm11jmzjoXJQTp5HSGK1DNj63mNEGMXYKklK9bgFjUBxLNG3TBMi6xXfOo02c86ILmYZz3O5FcOQirxraf5RdXngi+RheAA9WNqasaAad+HJyd9h/kcLTNq7dF4eqhnaGN4AVp5Z3BhUvmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780515202; c=relaxed/simple;
	bh=E2BoMMqHmb4m6HISOqo1PzsH3ma67EoluTCi8dNuvt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kR+Ak5Sy8ofWVDt22SSm76tGP2IfY1yUqn2gPArXOzlpCum5ZIvGMdlExZt60sYndTZvihmGg0J8Jcvk14wiVzdhBE7UHwcj/rDpFzrYT4VButKw05W25bz/VY9eBM1i7YeW1TZOGrS1wT+5LYLPC5NaXnPBiF0PfudCzzNCB3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fiC2mzPI; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fiC2mzPI"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c0c379e8ffso29971445ad.3
        for <linux-crypto@vger.kernel.org>; Wed, 03 Jun 2026 12:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780515198; x=1781119998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=abcAtysgPo8fPIvDr/C83T0b13oygP3XUdGQbpd2FaQ=;
        b=fiC2mzPIq3x17R8HzUgJHF49Z64/jVKobLQATYZEyYm7pWK86KL6/w6MrDrcNeuf2z
         YnAKG5gCHj8LjvaEWueeGovXerLyuu9l/b4WXfq2sj9lkVcNbZ8Gzh3hLPT7ks2j+8f+
         P6aKh2WTioYy9KHpFBAIsA/zdQetO7PgVzpiHBQ7uyvYGXCpeRmOTqNqbAsv0J+fW4ya
         pQyNpXIP8Mc8X1NiAzDQxFwj4OjZfzI9QK514u38LCuvOLrbwbwjO0m76wI92rl4EmoY
         V/cruF/A5quL9RCA90UmIoLYbzIKQRV80zEKcliwB6fmbZtrOWm9//PAnx014Kgot+EX
         3SJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780515198; x=1781119998;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=abcAtysgPo8fPIvDr/C83T0b13oygP3XUdGQbpd2FaQ=;
        b=aedhm6z+XMcVlrz8phURmhLluEevpv2Ooxfl3HV0a9V+puGunSelSVveD7+2HlvVwd
         17JnxT6Wp/nX/3h5O0hjC/eJrAqSZaHEijZgAYesKZ4JykRhpiEZh4yCYXGpJvBFmoNZ
         L2ccscjdURG4fUk4cd2XwwL2ATGj17ff0MaFsg9UX8bx52WQmkxtvZWHK4PFORl+1oJP
         8e9JC/Yanj8y5LbCjqjMStV5Q0l5QOrCdB/FFQ7LrAlwZmfz12skYfzBzoq5OcznQDDR
         g8hjExa92IQqHv8OI9L4z5UcL1a8y/xFwd8dAxqGsg+y0mmNzj5uJ5Is8Vl897IPdL1r
         SHiQ==
X-Gm-Message-State: AOJu0Ywa2HrjCtGlNx2ONDVKLZUAPMyNRGOjfvNv+mkjc4ab3gWBCvhL
	G/F2E1pq2I41ohG580nnt3nTfjULps81LjdlgWNIeXNz3bOzd3iN09JLHm3AwULc
X-Gm-Gg: Acq92OFCbNb1991jtMyHpCC5qiEoK5/hoiflJ4hBIFk/aeCHMFPp4GRoW8ExnOmBVpX
	0YTJa+ojpspuiwnWFm9Yac/i0JM/MQU4lA8m+3JQ71tkDH5+mNaJD3pcyqu6F6UidUjUmznARNc
	UKQg7IKTTqLHIqFoMj3q4cf7VRcIiaFjGtFyhS5R5w79YsbFpyCqqfSFfHs11dtVuLB4VmNd/jV
	4lvYI0Tr7GMKsmqf9daSQXGUjmKIZrRaB6CDlI6+TiT1s2us2RAsUKqcP/rhNW+s3nqWgCBsaH9
	H4YowaSwGWnOKGFoGFFjBZXZt+/dnI3FhfZu5I0/dAKWEKJMiVEwoETaiLD/txLxlYGKoG8mieP
	/W7Gj8XR9bbL6gjUoTOgRA7kG5TZjiuOkqFUNXoKwvXOuiay34AbG9XxIh7oif/WIrCdpDftOuK
	MNP6VpQpg9/BAlUeIAQ3Db6GTOUGavfKdSUWcEjgTspXMSuMg3i8K1vk1oHbDKBDJuajMRyVDMJ
	q1cGEvD0Koafk7BxDNaY4u98mbRLFeFseu2NW1vqtaWjw==
X-Received: by 2002:a17:903:22ce:b0:2c0:b5c1:8e3e with SMTP id d9443c01a7336-2c1639ec7f3mr50111925ad.8.1780515197630;
        Wed, 03 Jun 2026 12:33:17 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f890b2sm34211065ad.26.2026.06.03.12.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 12:33:16 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: talitos: replace in_be32/out_be32 with ioread32be/iowrite32be
Date: Wed,  3 Jun 2026 12:33:00 -0700
Message-ID: <20260603193300.7695-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert ppc4xx-specific in_be32/out_be32 and the setbits32/clrbits32
macros to the portable ioread32be/iowrite32be helpers.

Add HAS_IOMEM dependency as these accessors need it.

Add COMPILE_TEST for extra compile coverage.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/Kconfig   |   3 +-
 drivers/crypto/talitos.c | 379 ++++++++++++++++++++-------------------
 2 files changed, 192 insertions(+), 190 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3449b3c9c6ad..d5d2a663d171 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -262,7 +262,8 @@ config CRYPTO_DEV_TALITOS
 	select CRYPTO_HASH
 	select CRYPTO_LIB_DES
 	select HW_RANDOM
-	depends on FSL_SOC
+	depends on FSL_SOC || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  Say 'Y' here to use the Freescale Security Engine (SEC)
 	  to offload cryptographic algorithm computation.
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 584508963241..583bfbe118b5 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -143,18 +143,20 @@ static int reset_channel(struct device *dev, int ch)
 	bool is_sec1 = has_ftr_sec1(priv);
 
 	if (is_sec1) {
-		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
-			  TALITOS1_CCCR_LO_RESET);
+		iowrite32be(ioread32be(priv->chan[ch].reg + TALITOS_CCCR_LO) |
+				    (TALITOS1_CCCR_LO_RESET),
+			    priv->chan[ch].reg + TALITOS_CCCR_LO);
 
-		while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR_LO) &
-			TALITOS1_CCCR_LO_RESET) && --timeout)
+		while ((ioread32be(priv->chan[ch].reg + TALITOS_CCCR_LO) &
+			TALITOS1_CCCR_LO_RESET) &&
+		       --timeout)
 			cpu_relax();
 	} else {
-		setbits32(priv->chan[ch].reg + TALITOS_CCCR,
-			  TALITOS2_CCCR_RESET);
+		iowrite32be(ioread32be(priv->chan[ch].reg + TALITOS_CCCR) | (TALITOS2_CCCR_RESET),
+			    priv->chan[ch].reg + TALITOS_CCCR);
 
-		while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
-			TALITOS2_CCCR_RESET) && --timeout)
+		while ((ioread32be(priv->chan[ch].reg + TALITOS_CCCR) & TALITOS2_CCCR_RESET) &&
+		       --timeout)
 			cpu_relax();
 	}
 
@@ -164,17 +166,19 @@ static int reset_channel(struct device *dev, int ch)
 	}
 
 	/* set 36-bit addressing, done writeback enable and done IRQ enable */
-	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, TALITOS_CCCR_LO_EAE |
-		  TALITOS_CCCR_LO_CDWE | TALITOS_CCCR_LO_CDIE);
+	iowrite32be(ioread32be(priv->chan[ch].reg + TALITOS_CCCR_LO) |
+			    (TALITOS_CCCR_LO_EAE | TALITOS_CCCR_LO_CDWE | TALITOS_CCCR_LO_CDIE),
+		    priv->chan[ch].reg + TALITOS_CCCR_LO);
 	/* enable chaining descriptors */
 	if (is_sec1)
-		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
-			  TALITOS_CCCR_LO_NE);
+		iowrite32be(ioread32be(priv->chan[ch].reg + TALITOS_CCCR_LO) | (TALITOS_CCCR_LO_NE),
+			    priv->chan[ch].reg + TALITOS_CCCR_LO);
 
 	/* and ICCR writeback, if available */
 	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
-		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
-		          TALITOS_CCCR_LO_IWSE);
+		iowrite32be(ioread32be(priv->chan[ch].reg + TALITOS_CCCR_LO) |
+				    (TALITOS_CCCR_LO_IWSE),
+			    priv->chan[ch].reg + TALITOS_CCCR_LO);
 
 	return 0;
 }
@@ -186,15 +190,14 @@ static int reset_device(struct device *dev)
 	bool is_sec1 = has_ftr_sec1(priv);
 	u32 mcr = is_sec1 ? TALITOS1_MCR_SWR : TALITOS2_MCR_SWR;
 
-	setbits32(priv->reg + TALITOS_MCR, mcr);
+	iowrite32be(ioread32be(priv->reg + TALITOS_MCR) | (mcr), priv->reg + TALITOS_MCR);
 
-	while ((in_be32(priv->reg + TALITOS_MCR) & mcr)
-	       && --timeout)
+	while ((ioread32be(priv->reg + TALITOS_MCR) & mcr) && --timeout)
 		cpu_relax();
 
 	if (priv->irq[1]) {
 		mcr = TALITOS_MCR_RCA1 | TALITOS_MCR_RCA3;
-		setbits32(priv->reg + TALITOS_MCR, mcr);
+		iowrite32be(ioread32be(priv->reg + TALITOS_MCR) | (mcr), priv->reg + TALITOS_MCR);
 	}
 
 	if (timeout == 0) {
@@ -237,19 +240,25 @@ static int init_device(struct device *dev)
 
 	/* enable channel done and error interrupts */
 	if (is_sec1) {
-		clrbits32(priv->reg + TALITOS_IMR, TALITOS1_IMR_INIT);
-		clrbits32(priv->reg + TALITOS_IMR_LO, TALITOS1_IMR_LO_INIT);
+		iowrite32be(ioread32be(priv->reg + TALITOS_IMR) & ~(TALITOS1_IMR_INIT),
+			    priv->reg + TALITOS_IMR);
+		iowrite32be(ioread32be(priv->reg + TALITOS_IMR_LO) & ~(TALITOS1_IMR_LO_INIT),
+			    priv->reg + TALITOS_IMR_LO);
 		/* disable parity error check in DEU (erroneous? test vect.) */
-		setbits32(priv->reg_deu + TALITOS_EUICR, TALITOS1_DEUICR_KPE);
+		iowrite32be(ioread32be(priv->reg_deu + TALITOS_EUICR) | (TALITOS1_DEUICR_KPE),
+			    priv->reg_deu + TALITOS_EUICR);
 	} else {
-		setbits32(priv->reg + TALITOS_IMR, TALITOS2_IMR_INIT);
-		setbits32(priv->reg + TALITOS_IMR_LO, TALITOS2_IMR_LO_INIT);
+		iowrite32be(ioread32be(priv->reg + TALITOS_IMR) | (TALITOS2_IMR_INIT),
+			    priv->reg + TALITOS_IMR);
+		iowrite32be(ioread32be(priv->reg + TALITOS_IMR_LO) | (TALITOS2_IMR_LO_INIT),
+			    priv->reg + TALITOS_IMR_LO);
 	}
 
 	/* disable integrity check error interrupts (use writeback instead) */
 	if (priv->features & TALITOS_FTR_HW_AUTH_CHECK)
-		setbits32(priv->reg_mdeu + TALITOS_EUICR_LO,
-		          TALITOS_MDEUICR_LO_ICE);
+		iowrite32be(ioread32be(priv->reg_mdeu + TALITOS_EUICR_LO) |
+				    (TALITOS_MDEUICR_LO_ICE),
+			    priv->reg_mdeu + TALITOS_EUICR_LO);
 
 	return 0;
 }
@@ -342,10 +351,8 @@ static int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 
 	/* GO! */
 	wmb();
-	out_be32(priv->chan[ch].reg + TALITOS_FF,
-		 upper_32_bits(request->dma_desc));
-	out_be32(priv->chan[ch].reg + TALITOS_FF_LO,
-		 lower_32_bits(request->dma_desc));
+	iowrite32be(upper_32_bits(request->dma_desc), priv->chan[ch].reg + TALITOS_FF);
+	iowrite32be(lower_32_bits(request->dma_desc), priv->chan[ch].reg + TALITOS_FF_LO);
 
 	spin_unlock_irqrestore(&priv->chan[ch].head_lock, flags);
 
@@ -463,56 +470,60 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 /*
  * process completed requests for channels that have done status
  */
-#define DEF_TALITOS1_DONE(name, ch_done_mask)				\
-static void talitos1_done_##name(unsigned long data)			\
-{									\
-	struct device *dev = (struct device *)data;			\
-	struct talitos_private *priv = dev_get_drvdata(dev);		\
-	unsigned long flags;						\
-									\
-	if (ch_done_mask & 0x10000000)					\
-		flush_channel(dev, 0, 0, 0);			\
-	if (ch_done_mask & 0x40000000)					\
-		flush_channel(dev, 1, 0, 0);			\
-	if (ch_done_mask & 0x00010000)					\
-		flush_channel(dev, 2, 0, 0);			\
-	if (ch_done_mask & 0x00040000)					\
-		flush_channel(dev, 3, 0, 0);			\
-									\
-	/* At this point, all completed channels have been processed */	\
-	/* Unmask done interrupts for channels completed later on. */	\
-	spin_lock_irqsave(&priv->reg_lock, flags);			\
-	clrbits32(priv->reg + TALITOS_IMR, ch_done_mask);		\
-	clrbits32(priv->reg + TALITOS_IMR_LO, TALITOS1_IMR_LO_INIT);	\
-	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
-}
+#define DEF_TALITOS1_DONE(name, ch_done_mask)                                                 \
+	static void talitos1_done_##name(unsigned long data)                                  \
+	{                                                                                     \
+		struct device *dev = (struct device *)data;                                   \
+		struct talitos_private *priv = dev_get_drvdata(dev);                          \
+		unsigned long flags;                                                          \
+                                                                                              \
+		if (ch_done_mask & 0x10000000)                                                \
+			flush_channel(dev, 0, 0, 0);                                          \
+		if (ch_done_mask & 0x40000000)                                                \
+			flush_channel(dev, 1, 0, 0);                                          \
+		if (ch_done_mask & 0x00010000)                                                \
+			flush_channel(dev, 2, 0, 0);                                          \
+		if (ch_done_mask & 0x00040000)                                                \
+			flush_channel(dev, 3, 0, 0);                                          \
+                                                                                              \
+		/* At this point, all completed channels have been processed */               \
+		/* Unmask done interrupts for channels completed later on. */                 \
+		spin_lock_irqsave(&priv->reg_lock, flags);                                    \
+		iowrite32be(ioread32be(priv->reg + TALITOS_IMR) & ~(ch_done_mask),            \
+			    priv->reg + TALITOS_IMR);                                         \
+		iowrite32be(ioread32be(priv->reg + TALITOS_IMR_LO) & ~(TALITOS1_IMR_LO_INIT), \
+			    priv->reg + TALITOS_IMR_LO);                                      \
+		spin_unlock_irqrestore(&priv->reg_lock, flags);                               \
+	}
 
 DEF_TALITOS1_DONE(4ch, TALITOS1_ISR_4CHDONE)
 DEF_TALITOS1_DONE(ch0, TALITOS1_ISR_CH_0_DONE)
 
-#define DEF_TALITOS2_DONE(name, ch_done_mask)				\
-static void talitos2_done_##name(unsigned long data)			\
-{									\
-	struct device *dev = (struct device *)data;			\
-	struct talitos_private *priv = dev_get_drvdata(dev);		\
-	unsigned long flags;						\
-									\
-	if (ch_done_mask & 1)						\
-		flush_channel(dev, 0, 0, 0);				\
-	if (ch_done_mask & (1 << 2))					\
-		flush_channel(dev, 1, 0, 0);				\
-	if (ch_done_mask & (1 << 4))					\
-		flush_channel(dev, 2, 0, 0);				\
-	if (ch_done_mask & (1 << 6))					\
-		flush_channel(dev, 3, 0, 0);				\
-									\
-	/* At this point, all completed channels have been processed */	\
-	/* Unmask done interrupts for channels completed later on. */	\
-	spin_lock_irqsave(&priv->reg_lock, flags);			\
-	setbits32(priv->reg + TALITOS_IMR, ch_done_mask);		\
-	setbits32(priv->reg + TALITOS_IMR_LO, TALITOS2_IMR_LO_INIT);	\
-	spin_unlock_irqrestore(&priv->reg_lock, flags);			\
-}
+#define DEF_TALITOS2_DONE(name, ch_done_mask)                                                \
+	static void talitos2_done_##name(unsigned long data)                                 \
+	{                                                                                    \
+		struct device *dev = (struct device *)data;                                  \
+		struct talitos_private *priv = dev_get_drvdata(dev);                         \
+		unsigned long flags;                                                         \
+                                                                                             \
+		if (ch_done_mask & 1)                                                        \
+			flush_channel(dev, 0, 0, 0);                                         \
+		if (ch_done_mask & (1 << 2))                                                 \
+			flush_channel(dev, 1, 0, 0);                                         \
+		if (ch_done_mask & (1 << 4))                                                 \
+			flush_channel(dev, 2, 0, 0);                                         \
+		if (ch_done_mask & (1 << 6))                                                 \
+			flush_channel(dev, 3, 0, 0);                                         \
+                                                                                             \
+		/* At this point, all completed channels have been processed */              \
+		/* Unmask done interrupts for channels completed later on. */                \
+		spin_lock_irqsave(&priv->reg_lock, flags);                                   \
+		iowrite32be(ioread32be(priv->reg + TALITOS_IMR) | (ch_done_mask),            \
+			    priv->reg + TALITOS_IMR);                                        \
+		iowrite32be(ioread32be(priv->reg + TALITOS_IMR_LO) | (TALITOS2_IMR_LO_INIT), \
+			    priv->reg + TALITOS_IMR_LO);                                     \
+		spin_unlock_irqrestore(&priv->reg_lock, flags);                              \
+	}
 
 DEF_TALITOS2_DONE(4ch, TALITOS2_ISR_4CHDONE)
 DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE)
@@ -549,8 +560,8 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
 	dma_addr_t cur_desc;
 	__be32 hdr = 0;
 
-	cur_desc = ((u64)in_be32(priv->chan[ch].reg + TALITOS_CDPR)) << 32;
-	cur_desc |= in_be32(priv->chan[ch].reg + TALITOS_CDPR_LO);
+	cur_desc = ((u64)ioread32be(priv->chan[ch].reg + TALITOS_CDPR)) << 32;
+	cur_desc |= ioread32be(priv->chan[ch].reg + TALITOS_CDPR_LO);
 
 	if (!cur_desc) {
 		dev_err(dev, "CDPR is NULL, giving up search for offending descriptor\n");
@@ -584,70 +595,60 @@ static void report_eu_error(struct device *dev, int ch, __be32 desc_hdr)
 	int i;
 
 	if (!desc_hdr)
-		desc_hdr = cpu_to_be32(in_be32(priv->chan[ch].reg + TALITOS_DESCBUF));
+		desc_hdr = cpu_to_be32(ioread32be(priv->chan[ch].reg + TALITOS_DESCBUF));
 
 	switch (desc_hdr & DESC_HDR_SEL0_MASK) {
 	case DESC_HDR_SEL0_AFEU:
-		dev_err(dev, "AFEUISR 0x%08x_%08x\n",
-			in_be32(priv->reg_afeu + TALITOS_EUISR),
-			in_be32(priv->reg_afeu + TALITOS_EUISR_LO));
+		dev_err(dev, "AFEUISR 0x%08x_%08x\n", ioread32be(priv->reg_afeu + TALITOS_EUISR),
+			ioread32be(priv->reg_afeu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL0_DEU:
-		dev_err(dev, "DEUISR 0x%08x_%08x\n",
-			in_be32(priv->reg_deu + TALITOS_EUISR),
-			in_be32(priv->reg_deu + TALITOS_EUISR_LO));
+		dev_err(dev, "DEUISR 0x%08x_%08x\n", ioread32be(priv->reg_deu + TALITOS_EUISR),
+			ioread32be(priv->reg_deu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL0_MDEUA:
 	case DESC_HDR_SEL0_MDEUB:
-		dev_err(dev, "MDEUISR 0x%08x_%08x\n",
-			in_be32(priv->reg_mdeu + TALITOS_EUISR),
-			in_be32(priv->reg_mdeu + TALITOS_EUISR_LO));
+		dev_err(dev, "MDEUISR 0x%08x_%08x\n", ioread32be(priv->reg_mdeu + TALITOS_EUISR),
+			ioread32be(priv->reg_mdeu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL0_RNG:
-		dev_err(dev, "RNGUISR 0x%08x_%08x\n",
-			in_be32(priv->reg_rngu + TALITOS_ISR),
-			in_be32(priv->reg_rngu + TALITOS_ISR_LO));
+		dev_err(dev, "RNGUISR 0x%08x_%08x\n", ioread32be(priv->reg_rngu + TALITOS_ISR),
+			ioread32be(priv->reg_rngu + TALITOS_ISR_LO));
 		break;
 	case DESC_HDR_SEL0_PKEU:
-		dev_err(dev, "PKEUISR 0x%08x_%08x\n",
-			in_be32(priv->reg_pkeu + TALITOS_EUISR),
-			in_be32(priv->reg_pkeu + TALITOS_EUISR_LO));
+		dev_err(dev, "PKEUISR 0x%08x_%08x\n", ioread32be(priv->reg_pkeu + TALITOS_EUISR),
+			ioread32be(priv->reg_pkeu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL0_AESU:
-		dev_err(dev, "AESUISR 0x%08x_%08x\n",
-			in_be32(priv->reg_aesu + TALITOS_EUISR),
-			in_be32(priv->reg_aesu + TALITOS_EUISR_LO));
+		dev_err(dev, "AESUISR 0x%08x_%08x\n", ioread32be(priv->reg_aesu + TALITOS_EUISR),
+			ioread32be(priv->reg_aesu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL0_CRCU:
-		dev_err(dev, "CRCUISR 0x%08x_%08x\n",
-			in_be32(priv->reg_crcu + TALITOS_EUISR),
-			in_be32(priv->reg_crcu + TALITOS_EUISR_LO));
+		dev_err(dev, "CRCUISR 0x%08x_%08x\n", ioread32be(priv->reg_crcu + TALITOS_EUISR),
+			ioread32be(priv->reg_crcu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL0_KEU:
-		dev_err(dev, "KEUISR 0x%08x_%08x\n",
-			in_be32(priv->reg_pkeu + TALITOS_EUISR),
-			in_be32(priv->reg_pkeu + TALITOS_EUISR_LO));
+		dev_err(dev, "KEUISR 0x%08x_%08x\n", ioread32be(priv->reg_pkeu + TALITOS_EUISR),
+			ioread32be(priv->reg_pkeu + TALITOS_EUISR_LO));
 		break;
 	}
 
 	switch (desc_hdr & DESC_HDR_SEL1_MASK) {
 	case DESC_HDR_SEL1_MDEUA:
 	case DESC_HDR_SEL1_MDEUB:
-		dev_err(dev, "MDEUISR 0x%08x_%08x\n",
-			in_be32(priv->reg_mdeu + TALITOS_EUISR),
-			in_be32(priv->reg_mdeu + TALITOS_EUISR_LO));
+		dev_err(dev, "MDEUISR 0x%08x_%08x\n", ioread32be(priv->reg_mdeu + TALITOS_EUISR),
+			ioread32be(priv->reg_mdeu + TALITOS_EUISR_LO));
 		break;
 	case DESC_HDR_SEL1_CRCU:
-		dev_err(dev, "CRCUISR 0x%08x_%08x\n",
-			in_be32(priv->reg_crcu + TALITOS_EUISR),
-			in_be32(priv->reg_crcu + TALITOS_EUISR_LO));
+		dev_err(dev, "CRCUISR 0x%08x_%08x\n", ioread32be(priv->reg_crcu + TALITOS_EUISR),
+			ioread32be(priv->reg_crcu + TALITOS_EUISR_LO));
 		break;
 	}
 
 	for (i = 0; i < 8; i++)
 		dev_err(dev, "DESCBUF 0x%08x_%08x\n",
-			in_be32(priv->chan[ch].reg + TALITOS_DESCBUF + 8*i),
-			in_be32(priv->chan[ch].reg + TALITOS_DESCBUF_LO + 8*i));
+			ioread32be(priv->chan[ch].reg + TALITOS_DESCBUF + 8 * i),
+			ioread32be(priv->chan[ch].reg + TALITOS_DESCBUF_LO + 8 * i));
 }
 
 /*
@@ -675,7 +676,7 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 
 		error = -EINVAL;
 
-		v_lo = in_be32(priv->chan[ch].reg + TALITOS_CCPSR_LO);
+		v_lo = ioread32be(priv->chan[ch].reg + TALITOS_CCPSR_LO);
 
 		if (v_lo & TALITOS_CCPSR_LO_DOF) {
 			dev_err(dev, "double fetch fifo overflow error\n");
@@ -718,11 +719,14 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 		if (reset_ch) {
 			reset_channel(dev, ch);
 		} else {
-			setbits32(priv->chan[ch].reg + TALITOS_CCCR,
-				  TALITOS2_CCCR_CONT);
-			setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, 0);
-			while ((in_be32(priv->chan[ch].reg + TALITOS_CCCR) &
-			       TALITOS2_CCCR_CONT) && --timeout)
+			iowrite32be(ioread32be(priv->chan[ch].reg + TALITOS_CCCR) |
+					    (TALITOS2_CCCR_CONT),
+				    priv->chan[ch].reg + TALITOS_CCCR);
+			iowrite32be(ioread32be(priv->chan[ch].reg + TALITOS_CCCR_LO) | (0),
+				    priv->chan[ch].reg + TALITOS_CCCR_LO);
+			while ((ioread32be(priv->chan[ch].reg + TALITOS_CCCR) &
+				TALITOS2_CCCR_CONT) &&
+			       --timeout)
 				cpu_relax();
 			if (timeout == 0) {
 				dev_err(dev, "failed to restart channel %d\n",
@@ -749,73 +753,71 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 	}
 }
 
-#define DEF_TALITOS1_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
-static irqreturn_t talitos1_interrupt_##name(int irq, void *data)	       \
-{									       \
-	struct device *dev = data;					       \
-	struct talitos_private *priv = dev_get_drvdata(dev);		       \
-	u32 isr, isr_lo;						       \
-	unsigned long flags;						       \
-									       \
-	spin_lock_irqsave(&priv->reg_lock, flags);			       \
-	isr = in_be32(priv->reg + TALITOS_ISR);				       \
-	isr_lo = in_be32(priv->reg + TALITOS_ISR_LO);			       \
-	/* Acknowledge interrupt */					       \
-	out_be32(priv->reg + TALITOS_ICR, isr & (ch_done_mask | ch_err_mask)); \
-	out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);			       \
-									       \
-	if (unlikely(isr & ch_err_mask || isr_lo & TALITOS1_IMR_LO_INIT)) {    \
-		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
-		talitos_error(dev, isr & ch_err_mask, isr_lo);		       \
-	}								       \
-	else {								       \
-		if (likely(isr & ch_done_mask)) {			       \
-			/* mask further done interrupts. */		       \
-			setbits32(priv->reg + TALITOS_IMR, ch_done_mask);      \
-			/* done_task will unmask done interrupts at exit */    \
-			tasklet_schedule(&priv->done_task[tlet]);	       \
-		}							       \
-		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
-	}								       \
-									       \
-	return (isr & (ch_done_mask | ch_err_mask) || isr_lo) ? IRQ_HANDLED :  \
-								IRQ_NONE;      \
-}
+#define DEF_TALITOS1_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)                             \
+	static irqreturn_t talitos1_interrupt_##name(int irq, void *data)                         \
+	{                                                                                         \
+		struct device *dev = data;                                                        \
+		struct talitos_private *priv = dev_get_drvdata(dev);                              \
+		u32 isr, isr_lo;                                                                  \
+		unsigned long flags;                                                              \
+                                                                                                  \
+		spin_lock_irqsave(&priv->reg_lock, flags);                                        \
+		isr = ioread32be(priv->reg + TALITOS_ISR);                                        \
+		isr_lo = ioread32be(priv->reg + TALITOS_ISR_LO);                                  \
+		/* Acknowledge interrupt */                                                       \
+		iowrite32be(isr & (ch_done_mask | ch_err_mask), priv->reg + TALITOS_ICR);         \
+		iowrite32be(isr_lo, priv->reg + TALITOS_ICR_LO);                                  \
+                                                                                                  \
+		if (unlikely(isr & ch_err_mask || isr_lo & TALITOS1_IMR_LO_INIT)) {               \
+			spin_unlock_irqrestore(&priv->reg_lock, flags);                           \
+			talitos_error(dev, isr & ch_err_mask, isr_lo);                            \
+		} else {                                                                          \
+			if (likely(isr & ch_done_mask)) {                                         \
+				/* mask further done interrupts. */                               \
+				iowrite32be(ioread32be(priv->reg + TALITOS_IMR) | (ch_done_mask), \
+					    priv->reg + TALITOS_IMR);                             \
+				/* done_task will unmask done interrupts at exit */               \
+				tasklet_schedule(&priv->done_task[tlet]);                         \
+			}                                                                         \
+			spin_unlock_irqrestore(&priv->reg_lock, flags);                           \
+		}                                                                                 \
+                                                                                                  \
+		return (isr & (ch_done_mask | ch_err_mask) || isr_lo) ? IRQ_HANDLED : IRQ_NONE;   \
+	}
 
 DEF_TALITOS1_INTERRUPT(4ch, TALITOS1_ISR_4CHDONE, TALITOS1_ISR_4CHERR, 0)
 
-#define DEF_TALITOS2_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)	       \
-static irqreturn_t talitos2_interrupt_##name(int irq, void *data)	       \
-{									       \
-	struct device *dev = data;					       \
-	struct talitos_private *priv = dev_get_drvdata(dev);		       \
-	u32 isr, isr_lo;						       \
-	unsigned long flags;						       \
-									       \
-	spin_lock_irqsave(&priv->reg_lock, flags);			       \
-	isr = in_be32(priv->reg + TALITOS_ISR);				       \
-	isr_lo = in_be32(priv->reg + TALITOS_ISR_LO);			       \
-	/* Acknowledge interrupt */					       \
-	out_be32(priv->reg + TALITOS_ICR, isr & (ch_done_mask | ch_err_mask)); \
-	out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);			       \
-									       \
-	if (unlikely(isr & ch_err_mask || isr_lo)) {			       \
-		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
-		talitos_error(dev, isr & ch_err_mask, isr_lo);		       \
-	}								       \
-	else {								       \
-		if (likely(isr & ch_done_mask)) {			       \
-			/* mask further done interrupts. */		       \
-			clrbits32(priv->reg + TALITOS_IMR, ch_done_mask);      \
-			/* done_task will unmask done interrupts at exit */    \
-			tasklet_schedule(&priv->done_task[tlet]);	       \
-		}							       \
-		spin_unlock_irqrestore(&priv->reg_lock, flags);		       \
-	}								       \
-									       \
-	return (isr & (ch_done_mask | ch_err_mask) || isr_lo) ? IRQ_HANDLED :  \
-								IRQ_NONE;      \
-}
+#define DEF_TALITOS2_INTERRUPT(name, ch_done_mask, ch_err_mask, tlet)                              \
+	static irqreturn_t talitos2_interrupt_##name(int irq, void *data)                          \
+	{                                                                                          \
+		struct device *dev = data;                                                         \
+		struct talitos_private *priv = dev_get_drvdata(dev);                               \
+		u32 isr, isr_lo;                                                                   \
+		unsigned long flags;                                                               \
+                                                                                                   \
+		spin_lock_irqsave(&priv->reg_lock, flags);                                         \
+		isr = ioread32be(priv->reg + TALITOS_ISR);                                         \
+		isr_lo = ioread32be(priv->reg + TALITOS_ISR_LO);                                   \
+		/* Acknowledge interrupt */                                                        \
+		iowrite32be(isr & (ch_done_mask | ch_err_mask), priv->reg + TALITOS_ICR);          \
+		iowrite32be(isr_lo, priv->reg + TALITOS_ICR_LO);                                   \
+                                                                                                   \
+		if (unlikely(isr & ch_err_mask || isr_lo)) {                                       \
+			spin_unlock_irqrestore(&priv->reg_lock, flags);                            \
+			talitos_error(dev, isr & ch_err_mask, isr_lo);                             \
+		} else {                                                                           \
+			if (likely(isr & ch_done_mask)) {                                          \
+				/* mask further done interrupts. */                                \
+				iowrite32be(ioread32be(priv->reg + TALITOS_IMR) & ~(ch_done_mask), \
+					    priv->reg + TALITOS_IMR);                              \
+				/* done_task will unmask done interrupts at exit */                \
+				tasklet_schedule(&priv->done_task[tlet]);                          \
+			}                                                                          \
+			spin_unlock_irqrestore(&priv->reg_lock, flags);                            \
+		}                                                                                  \
+                                                                                                   \
+		return (isr & (ch_done_mask | ch_err_mask) || isr_lo) ? IRQ_HANDLED : IRQ_NONE;    \
+	}
 
 DEF_TALITOS2_INTERRUPT(4ch, TALITOS2_ISR_4CHDONE, TALITOS2_ISR_4CHERR, 0)
 DEF_TALITOS2_INTERRUPT(ch0_2, TALITOS2_ISR_CH_0_2_DONE, TALITOS2_ISR_CH_0_2_ERR,
@@ -834,8 +836,7 @@ static int talitos_rng_data_present(struct hwrng *rng, int wait)
 	int i;
 
 	for (i = 0; i < 20; i++) {
-		ofl = in_be32(priv->reg_rngu + TALITOS_EUSR_LO) &
-		      TALITOS_RNGUSR_LO_OFL;
+		ofl = ioread32be(priv->reg_rngu + TALITOS_EUSR_LO) & TALITOS_RNGUSR_LO_OFL;
 		if (ofl || !wait)
 			break;
 		udelay(10);
@@ -850,8 +851,8 @@ static int talitos_rng_data_read(struct hwrng *rng, u32 *data)
 	struct talitos_private *priv = dev_get_drvdata(dev);
 
 	/* rng fifo requires 64-bit accesses */
-	*data = in_be32(priv->reg_rngu + TALITOS_EU_FIFO);
-	*data = in_be32(priv->reg_rngu + TALITOS_EU_FIFO_LO);
+	*data = ioread32be(priv->reg_rngu + TALITOS_EU_FIFO);
+	*data = ioread32be(priv->reg_rngu + TALITOS_EU_FIFO_LO);
 
 	return sizeof(u32);
 }
@@ -862,10 +863,9 @@ static int talitos_rng_init(struct hwrng *rng)
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	unsigned int timeout = TALITOS_TIMEOUT;
 
-	setbits32(priv->reg_rngu + TALITOS_EURCR_LO, TALITOS_RNGURCR_LO_SR);
-	while (!(in_be32(priv->reg_rngu + TALITOS_EUSR_LO)
-		 & TALITOS_RNGUSR_LO_RD)
-	       && --timeout)
+	iowrite32be(ioread32be(priv->reg_rngu + TALITOS_EURCR_LO) | (TALITOS_RNGURCR_LO_SR),
+		    priv->reg_rngu + TALITOS_EURCR_LO);
+	while (!(ioread32be(priv->reg_rngu + TALITOS_EUSR_LO) & TALITOS_RNGUSR_LO_RD) && --timeout)
 		cpu_relax();
 	if (timeout == 0) {
 		dev_err(dev, "failed to reset rng hw\n");
@@ -873,7 +873,8 @@ static int talitos_rng_init(struct hwrng *rng)
 	}
 
 	/* start generating */
-	setbits32(priv->reg_rngu + TALITOS_EUDSR_LO, 0);
+	iowrite32be(ioread32be(priv->reg_rngu + TALITOS_EUDSR_LO) | (0),
+		    priv->reg_rngu + TALITOS_EUDSR_LO);
 
 	return 0;
 }
-- 
2.54.0

