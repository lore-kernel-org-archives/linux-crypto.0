Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22CB3AF67C;
	Thu, 28 May 2026 09:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959391; cv=none; b=eWyomY+lKQRTU8bvtrf7Ui4epTGbFz7fdGaCYcVvVZr84FYLq42v4NdxuzXCFFocuHMrFL7e3rYqJuR83s+rkJteD7Y8PfJ+JoabW8ria0ZI106urvBqwdUWYxOsCyLwfD15hQzYgMaqkjXbd3LV+iYVWixEZMoKusBG4akigI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959391; c=relaxed/simple;
	bh=5Pmjn+ztmMrgnlm74oBBbo6EUluEiD9cCOgWsGrMha8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LwOu6jQXC0S0DqDXh383Dedz6vF/WWAvekTt4OJnM2z8nos16GK4YJgpTO16OSQfnwzOcIXFhf2uIii2SAAJ16vJ/XuCIkgc/CjkUnQHV0SA+5ynqikEPKQ1f5tR9ELlee/6474IyUHw8kKaVSz4/ctOfTQO17R9sz/sBVBprPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=ROJAGqFm; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="ROJAGqFm"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 4231B1A36FE;
	Thu, 28 May 2026 09:09:47 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 0BE4B60495;
	Thu, 28 May 2026 09:09:47 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 698CE10888CB5;
	Thu, 28 May 2026 11:09:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959386; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=xKJBjvpBTiYz28369BMq8WqlUyUro9t2c5FC6cwFWis=;
	b=ROJAGqFmq482coHZC+I4TtwTJnJViloKrSWQhNb6WKu9/mNMFO/TRSdkwVx73Sf5hx+JZh
	Cr6CBvz295dWrRToJLMv87HvQWxC3sq6372B8LvUuYRBuTK5G/asdUsFbX+BOwFocee9Ny
	dXKio5v89DBu/RdzxgSzeqzMzVP3XBIagohvQhUCgqGi3wC2/+4+9At9GNO8VdYBd/M9sb
	wRMd3Z60Y2retZqV2B/hiLhWJd+RKNf53ZFXU/r8UgCnfbZiVyYjm7MqQOjooOGTufjSvh
	nwS4fUuYZqe48mCFFisfBVFe6Xt69WlBkeAAxLJ0xD7G38zOWhYpUBjxt2DM3w==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:34 +0200
Subject: [PATCH 21/29] crypto: talitos - Export common channel and error
 handling routines
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-21-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=6201;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=5Pmjn+ztmMrgnlm74oBBbo6EUluEiD9cCOgWsGrMha8=;
 b=xh2AQWTNu2V1pwKAKRD4UJ4AQhsqDpek7OmaA92TqMBNh4BP3kuKa8nHTtfxXC/CS3jiwoBO3
 bhz/n9faRT9A2Fpe0PK4CAev0KlIuZcbjEGkE4qmWL1fgFJSOhTaqwu
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Remove the static qualifier from flush_channel(), current_desc_hdr(),
report_eu_error(), and talitos_error(); add the talitos_ prefix where
missing; and declare them in talitos.h.

These routines will be called from the upcoming SEC1/SEC2 compilation
units, so they need to be externally visible.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos.c | 36 +++++++++++++++++++-----------------
 drivers/crypto/talitos/talitos.h |  5 +++++
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index c4a311a8e7fd..827d075ecfaa 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -439,7 +439,7 @@ static void sec2_dma_unmap_request(struct device *dev,
 /*
  * process what was done, notify callback of error if not
  */
-static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
+void talitos_flush_channel(struct device *dev, int ch, int error, int reset_ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_request *request, saved_req;
@@ -507,13 +507,13 @@ static void talitos1_done_##name(unsigned long data)			\
 	unsigned long flags;						\
 									\
 	if (ch_done_mask & 0x10000000)					\
-		flush_channel(dev, 0, 0, 0);			\
+		talitos_flush_channel(dev, 0, 0, 0);			\
 	if (ch_done_mask & 0x40000000)					\
-		flush_channel(dev, 1, 0, 0);			\
+		talitos_flush_channel(dev, 1, 0, 0);			\
 	if (ch_done_mask & 0x00010000)					\
-		flush_channel(dev, 2, 0, 0);			\
+		talitos_flush_channel(dev, 2, 0, 0);			\
 	if (ch_done_mask & 0x00040000)					\
-		flush_channel(dev, 3, 0, 0);			\
+		talitos_flush_channel(dev, 3, 0, 0);			\
 									\
 	/* At this point, all completed channels have been processed */	\
 	/* Unmask done interrupts for channels completed later on. */	\
@@ -534,13 +534,13 @@ static void talitos2_done_##name(unsigned long data)			\
 	unsigned long flags;						\
 									\
 	if (ch_done_mask & 1)						\
-		flush_channel(dev, 0, 0, 0);				\
+		talitos_flush_channel(dev, 0, 0, 0);			\
 	if (ch_done_mask & (1 << 2))					\
-		flush_channel(dev, 1, 0, 0);				\
+		talitos_flush_channel(dev, 1, 0, 0);			\
 	if (ch_done_mask & (1 << 4))					\
-		flush_channel(dev, 2, 0, 0);				\
+		talitos_flush_channel(dev, 2, 0, 0);			\
 	if (ch_done_mask & (1 << 6))					\
-		flush_channel(dev, 3, 0, 0);				\
+		talitos_flush_channel(dev, 3, 0, 0);			\
 									\
 	/* At this point, all completed channels have been processed */	\
 	/* Unmask done interrupts for channels completed later on. */	\
@@ -585,7 +585,7 @@ static __be32 sec2_search_desc_hdr_in_request(struct talitos_request *request,
 /*
  * locate current (offending) descriptor
  */
-static __be32 current_desc_hdr(struct device *dev, int ch)
+__be32 talitos_current_desc_hdr(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct talitos_request *request;
@@ -622,7 +622,7 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
 /*
  * user diagnostics; report root cause of error based on execution unit status
  */
-static void report_eu_error(struct device *dev, int ch, __be32 desc_hdr)
+void talitos_report_eu_error(struct device *dev, int ch, __be32 desc_hdr)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int i;
@@ -719,9 +719,10 @@ static int sec1_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
 		if (v_lo & TALITOS1_CCPSR_LO_SA)
 			dev_err(dev, "static assignment error\n");
 		if (v_lo & TALITOS1_CCPSR_LO_EU)
-			report_eu_error(dev, ch, current_desc_hdr(dev, ch));
+			talitos_report_eu_error(
+				dev, ch, talitos_current_desc_hdr(dev, ch));
 
-		flush_channel(dev, ch, error, 1);
+		talitos_flush_channel(dev, ch, error, 1);
 		priv->ops->reset_channel(dev, ch);
 	}
 
@@ -768,7 +769,8 @@ static int sec2_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
 		if (v_lo & TALITOS2_CCPSR_LO_IEU)
 			dev_err(dev, "invalid exec unit error\n");
 		if (v_lo & TALITOS2_CCPSR_LO_EU)
-			report_eu_error(dev, ch, current_desc_hdr(dev, ch));
+			talitos_report_eu_error(
+				dev, ch, talitos_current_desc_hdr(dev, ch));
 		if (v_lo & TALITOS2_CCPSR_LO_GB)
 			dev_err(dev, "gather boundary error\n");
 		if (v_lo & TALITOS2_CCPSR_LO_GRL)
@@ -778,7 +780,7 @@ static int sec2_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
 		if (v_lo & TALITOS2_CCPSR_LO_SRL)
 			dev_err(dev, "scatter return/length error\n");
 
-		flush_channel(dev, ch, error, reset_ch);
+		talitos_flush_channel(dev, ch, error, reset_ch);
 
 		if (reset_ch) {
 			priv->ops->reset_channel(dev, ch);
@@ -803,7 +805,7 @@ static int sec2_talitos_handle_error(struct device *dev, u32 isr, u32 isr_lo)
 /*
  * recover from error interrupts
  */
-static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
+void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int ch, reset_dev;
@@ -818,7 +820,7 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 
 		/* purge request queues */
 		for (ch = 0; ch < priv->num_channels; ch++)
-			flush_channel(dev, ch, -EIO, 1);
+			talitos_flush_channel(dev, ch, -EIO, 1);
 
 		/* reset and reinitialize the device */
 		init_device(dev);
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index 46de1bf1ef27..98b2cb5115f8 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -561,6 +561,11 @@ void talitos_cra_exit(struct crypto_tfm *tfm);
 int talitos_register_common(struct device *dev,
 			    struct talitos_alg_template *template);
 
+void talitos_flush_channel(struct device *dev, int ch, int error, int reset_ch);
+__be32 talitos_current_desc_hdr(struct device *dev, int ch);
+void talitos_error(struct device *dev, u32 isr, u32 isr_lo);
+void talitos_report_eu_error(struct device *dev, int ch, __be32 desc_hdr);
+
 /* Hardware RNG */
 
 int talitos_register_rng(struct device *dev);

-- 
2.54.0

