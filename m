Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12B53B0AED;
	Thu, 28 May 2026 09:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779959395; cv=none; b=lrf5QCtdZicaSnR2g34wYClLNVSnsaCAwknWMChJMwq6E9rRcuRz/7EsrVK3W4mkzsmWS7UAhKXqnsS+BRpheagjjdlHPKpR+vAryBfk6yD0UY9u6Cnr1Uahfwqbsk8Ob+VI04evE/kSpTsjdxa2Kd4d0SxRldWwgSZV4rGpVB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779959395; c=relaxed/simple;
	bh=iq70Z8rbnGJlAOc3vpwLwwU40krFOpjeZrtcjWh8hY8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g17R5lJoJ0BOU3qHdxfjAfJAJloJQXonrhuOJo+UosCq/68dtoG9IZ9QAQ0ZYNgD5MCgVm1okOYu/iOt1Tae7EwTFaHPeqkictF3Yp19vTar6Hl8zKSi84mDgnk5F833ADRk5cu3sy5tG5TKOBilv8prHrhmsB04CoArM8j/A64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=ARGNcOqd; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="ARGNcOqd"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id BE280C62447;
	Thu, 28 May 2026 09:09:51 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 9791C60495;
	Thu, 28 May 2026 09:09:51 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 3CFBD10888C9D;
	Thu, 28 May 2026 11:09:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779959391; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=rOqCDyfSNrhyPoftsOduoHVV0/bL+E9q6q6nwQdNV2w=;
	b=ARGNcOqdgGhpfXmxki2ftNFaOmKvrQ27lVln/sJzW+l+Oar4pVy/Y3gZd84fC9aasm/LAh
	kHBdM9/Vy6IqmlXScJ/+N2Z5iRTXpwDLassaUeLkfwo4cXaoLEL6zeepo3PxzgtKhUxvEx
	2jMwZAdi0qTMj18tPsKoeezsb1Gk0BAcxs7scF7UUOGh+Cak5lYHDb+jHVjYZTgKvsAjt8
	bkG8krCFqP8F6dYRNj2ILeAZER55QOPy7aLutX6W2rSTn8m5CxKWaDcQrpHWUnHDiiXR89
	99gj6uFvakIHBjDfDsDTUiKNZ+o4LEn2oUhqRQk4SGQ7DCn6M07mSiUzDLttYw==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Thu, 28 May 2026 11:08:37 +0200
Subject: [PATCH 24/29] crypto: talitos - Introduce per-SEC-version pointer
 helper ops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-7-1-rc1_talitos_cleanup-v1-24-cb1ad6cdea49@bootlin.com>
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
In-Reply-To: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779959350; l=6271;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=iq70Z8rbnGJlAOc3vpwLwwU40krFOpjeZrtcjWh8hY8=;
 b=sLeUZtfrQBV4rqisNOhhukRpkMacJo6Q8jho3Mfflwems6Ogq81UDLNird/egl3q/I6vNZKja
 EwoYoQE8YTpBqG6wDNq3IX401mhv5okv6VxOTyCuiikq5yXspxrTIB2
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Introduce struct talitos_ptr_ops to abstract SEC1/SEC2 differences
in pointer handling behind per-SEC-version ops.  Add ptr_ops to
struct talitos_private and struct talitos_ctx, and register the
appropriate SEC1 or SEC2 implementation at probe time.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-sec1.c | 36 +++++++++++++++++++++++++++++++
 drivers/crypto/talitos/talitos-sec2.c | 40 +++++++++++++++++++++++++++++++++++
 drivers/crypto/talitos/talitos.c      |  2 ++
 drivers/crypto/talitos/talitos.h      | 12 +++++++++++
 4 files changed, 90 insertions(+)

diff --git a/drivers/crypto/talitos/talitos-sec1.c b/drivers/crypto/talitos/talitos-sec1.c
index 695d531aa7f4..ef1bd19b6772 100644
--- a/drivers/crypto/talitos/talitos-sec1.c
+++ b/drivers/crypto/talitos/talitos-sec1.c
@@ -73,6 +73,33 @@ static irqreturn_t talitos1_interrupt_##name(int irq, void *data)	       \
 
 DEF_TALITOS1_INTERRUPT(4ch, TALITOS1_ISR_4CHDONE, TALITOS1_ISR_4CHERR, 0)
 
+static void sec1_to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
+				unsigned int len)
+{
+	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
+	ptr->len1 = cpu_to_be16(len);
+}
+
+static void sec1_copy_talitos_ptr(struct talitos_ptr *dst_ptr,
+				  struct talitos_ptr *src_ptr)
+{
+	dst_ptr->ptr = src_ptr->ptr;
+	dst_ptr->len1 = src_ptr->len1;
+}
+
+static unsigned short sec1_from_talitos_ptr_len(struct talitos_ptr *ptr)
+{
+	return be16_to_cpu(ptr->len1);
+}
+
+static void sec1_to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val)
+{
+}
+
+static void sec1_to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val)
+{
+}
+
 static int sec1_reset_device(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
@@ -286,6 +313,14 @@ static void sec1_init_task(struct device *dev)
 			     (unsigned long)dev);
 }
 
+static const struct talitos_ptr_ops sec1_ptr_ops = {
+	.to_talitos_ptr = sec1_to_talitos_ptr,
+	.copy_talitos_ptr = sec1_copy_talitos_ptr,
+	.from_talitos_ptr_len = sec1_from_talitos_ptr_len,
+	.to_talitos_ptr_ext_set = sec1_to_talitos_ptr_ext_set,
+	.to_talitos_ptr_ext_or = sec1_to_talitos_ptr_ext_or,
+};
+
 static const struct talitos_ops sec1_ops = {
 	.probe_irq = sec1_talitos_probe_irq,
 	.init_task = sec1_init_task,
@@ -302,4 +337,5 @@ static const struct talitos_ops sec1_ops = {
 void talitos_register_sec1(struct talitos_private *priv)
 {
 	priv->ops = &sec1_ops;
+	priv->ptr_ops = &sec1_ptr_ops;
 }
diff --git a/drivers/crypto/talitos/talitos-sec2.c b/drivers/crypto/talitos/talitos-sec2.c
index 962e7cd43631..14f0ca13e6e5 100644
--- a/drivers/crypto/talitos/talitos-sec2.c
+++ b/drivers/crypto/talitos/talitos-sec2.c
@@ -79,6 +79,37 @@ DEF_TALITOS2_DONE(ch0, TALITOS2_ISR_CH_0_DONE)
 DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
 DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
 
+static void sec2_to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
+				unsigned int len)
+{
+	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
+	ptr->len = cpu_to_be16(len);
+	ptr->eptr = upper_32_bits(dma_addr);
+}
+
+static void sec2_copy_talitos_ptr(struct talitos_ptr *dst_ptr,
+				  struct talitos_ptr *src_ptr)
+{
+	dst_ptr->ptr = src_ptr->ptr;
+	dst_ptr->len = src_ptr->len;
+	dst_ptr->eptr = src_ptr->eptr;
+}
+
+static unsigned short sec2_from_talitos_ptr_len(struct talitos_ptr *ptr)
+{
+	return be16_to_cpu(ptr->len);
+}
+
+static void sec2_to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val)
+{
+	ptr->j_extent = val;
+}
+
+static void sec2_to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val)
+{
+	ptr->j_extent |= val;
+}
+
 static int sec2_reset_channel(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
@@ -311,6 +342,14 @@ static __be32 sec2_search_desc_hdr_in_request(struct talitos_request *request,
 	return 0;
 }
 
+static const struct talitos_ptr_ops sec2_ptr_ops = {
+	.to_talitos_ptr = sec2_to_talitos_ptr,
+	.copy_talitos_ptr = sec2_copy_talitos_ptr,
+	.from_talitos_ptr_len = sec2_from_talitos_ptr_len,
+	.to_talitos_ptr_ext_set = sec2_to_talitos_ptr_ext_set,
+	.to_talitos_ptr_ext_or = sec2_to_talitos_ptr_ext_or,
+};
+
 static const struct talitos_ops sec2_ops = {
 	.probe_irq = sec2_talitos_probe_irq,
 	.init_task = sec2_init_task,
@@ -327,4 +366,5 @@ static const struct talitos_ops sec2_ops = {
 void talitos_register_sec2(struct talitos_private *priv)
 {
 	priv->ops = &sec2_ops;
+	priv->ptr_ops = &sec2_ptr_ops;
 }
diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index 152618998819..0e4bd130ac6d 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -668,6 +668,8 @@ int talitos_init_common(struct talitos_ctx *ctx,
 	/* select done notification */
 	ctx->desc_hdr_template |= DESC_HDR_DONE_NOTIFY;
 
+	ctx->ptr_ops = priv->ptr_ops;
+
 	return 0;
 }
 
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index ae0bdb2ea78e..09d4e8fb0e62 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -140,6 +140,16 @@ struct talitos_channel {
 	int tail;
 };
 
+struct talitos_ptr_ops {
+	void (*to_talitos_ptr)(struct talitos_ptr *ptr, dma_addr_t addr,
+			       unsigned int len);
+	void (*copy_talitos_ptr)(struct talitos_ptr *dst_ptr,
+				 struct talitos_ptr *src_ptr);
+	unsigned short (*from_talitos_ptr_len)(struct talitos_ptr *ptr);
+	void (*to_talitos_ptr_ext_set)(struct talitos_ptr *ptr, u8 val);
+	void (*to_talitos_ptr_ext_or)(struct talitos_ptr *ptr, u8 val);
+};
+
 struct talitos_ops {
 	int (*probe_irq)(struct platform_device *ofdev);
 	void (*init_task)(struct device *dev);
@@ -183,6 +193,7 @@ struct talitos_private {
 	unsigned int desc_types;
 
 	const struct talitos_ops *ops;
+	const struct talitos_ptr_ops *ptr_ops;
 
 	/* SEC Compatibility info */
 	unsigned long features;
@@ -213,6 +224,7 @@ struct talitos_private {
 
 struct talitos_ctx {
 	struct device *dev;
+	const struct talitos_ptr_ops *ptr_ops;
 	int ch;
 	__be32 desc_hdr_template;
 	u8 key[TALITOS_MAX_KEY_SIZE];

-- 
2.54.0

