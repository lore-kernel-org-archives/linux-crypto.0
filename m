Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030E32C3265;
	Tue, 24 Jun 2025 13:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773187; cv=none; b=tyDY63Ev1d4qPoZxf1VZ5j0ybwcQRX7TUUXoq2zyE168wtkFUWtYMb9bZQtlNosoacDeBqbu3Otz7S3NaKIVb1LBQ/PTvFpM6DrbZNh9BqPEtAKq42Owc1/eA7Sr/75rWzQJ3xqSjsv5A804wv9za+tkT7A4RvwvB6DRRwh5ueA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773187; c=relaxed/simple;
	bh=jGJI0bD+O7z6RA7QZQsykkUaoVK4LN1YZQvzQv+NE9U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IjNSFmMIw/r267MSqzO3WwLXGuqXKjKEmuGVSUDoza/oBUwwjL6HuC8HxZbbxRUkdiUeohgRk4WcU8TebNbngvVNBC5DWp2FUI81lTc0696qNju35OFgCGyRmcTACfU3qoWcJhtFHcx7yEvSpkWs6vTX1QeoiUglT9NkehB7ii4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=awaUhgay; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="awaUhgay"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-553bcf41440so463560e87.3;
        Tue, 24 Jun 2025 06:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773184; x=1751377984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+SOYtw5N8V1W/8HjyEXXVA2dBh8//SmboKULJ8eZ2dw=;
        b=awaUhgayVooKi5Cqyh5alKPB8VBNfeZqYeiGN9M7m9gdaamgs3yPJR1ver9TTSmD2r
         o1SWsq7+mwyfCI5mO3ldktMRtNf5/opd6XjvCbsTUyeckadCb0HG0jMxpFzInQjvk2Qa
         SKz4n7lN7+vyf+IZxXwHv5qW/L4EgHIf0X2cC5ceqhDVeX6g5v+f0/DhPEN9akIieuJ3
         c8cr8pSMIPWFfWgEBJT/DqzdrsNWhkmfhkJ1ziqCoqBL51pREtvrCs1Y9GureN2EW2Fx
         FZvspOnCNWN0xgtzw0mwoW5/8ELowYrmesvc0Y4v/96TaLfLrZdNKuT4NeR56gU00Zs7
         tgsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773184; x=1751377984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+SOYtw5N8V1W/8HjyEXXVA2dBh8//SmboKULJ8eZ2dw=;
        b=AMv62BTJp29YF59bdmpKiwv/hKQ4XAWhVnK4aO0R/dlfugyPeG4PHkOfUTyWKPvYnZ
         HiDh+kEj1idwpTSe4DsHuixCJpq8mORk5ZDWdAXA0+GBYGCyWiQ6aL8d6GUg2lsKbmUR
         7TVvHIrhazHs3cIBiWYD2li9uQxxHPNUXg4x9uCRSseWWkKiUhestjWbFZg1yeDNmVZ1
         fyp6FC92Ex4fHwq01k0/7mjuhhGKptaaU1sBcfmOhYhbOLI1DNR9uMhF2GhDPHxx5LPn
         5udPpRVroVrOhdih2lC1+L9H3CGop7P9Er9AdV82CwcppTuZWEwzdrA8B7NS5GTCV1GR
         AYmg==
X-Forwarded-Encrypted: i=1; AJvYcCX284CsNACu0jYCxaUrecFuL0VXw/twCElIgAKSanPqp0pJ2cym/1/XTGUeVMDf3TaiXeA7rlUrEe4W@vger.kernel.org, AJvYcCXw6TpL1tFZ9vPpouEDOxNqsBhUJ18FveWJ/LlQVCLb9FRxHTgovnR/ke7tv1ZRDGEjLXA9UAFGiFLhGzeJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwphqxaKDzTlSN9sYPkTB+W91MTlzBs5jOuGmOVIej/wZPE/7Lk
	sm5LZMaG18xkOHmCHA3kUnaHCmgX/zFiPfMJHqrfGLy2udZ9SzGyYT9i
X-Gm-Gg: ASbGncvcRgHPZ8hBf/2AIDPEpl98PMAp+yUKW83JZmfOnRQEUr7F8q20GMZNQ66W9w7
	PXZEvy6bfgJ293ntM2N9GdAvmmhYkrzUPSUmF/SX7CE/PsAQWvFhpLaKiKK/VTdNcHGaIgabMKO
	LLImKSXCD1f5icRAK/gb+GUgZU3PiwBPk3Fv1GEAPX+20oQoZFt5Tw+4/uq/v5NTraxLMZFkJvH
	C+UAaGiIBQkMwKjdTx5UyqsLDgk/jy0KJcv1oHh7lHSuF9tmn8Z3TYCMS1veRmVFSPUn7LdyUMT
	TSvix//9qe+75dPIpthBiZ3zKHjJq9UsdF4OIalFx8Tgm99xDQB+1Km6Ldpl68XvU+rLVP2mekL
	HgXdc8AQjVXNx1xGuBR9O5133RcJfYuA3DYFxZGVbwHp+Lxfi4q3KqWgX/flY4Jp9Giaxya5g
X-Google-Smtp-Source: AGHT+IE12D8YIPSuzd8ZFmyOV+t4aSAtt702FpdsVE+qQZhOojJTiEYmpgrPUspu2EzIEcL1+cnh3w==
X-Received: by 2002:ac2:5f61:0:b0:554:f74b:78c1 with SMTP id 2adb3069b0e04-554f74b7c00mr680882e87.43.1750773183947;
        Tue, 24 Jun 2025 06:53:03 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:03 -0700 (PDT)
From: Alexey Romanov <romanov.alexey2000@gmail.com>
To: neil.armstrong@linaro.org,
	clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	khilman@baylibre.com,
	jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v12 01/22] crypto: amlogic - Don't hardcode IRQ count
Date: Tue, 24 Jun 2025 16:51:53 +0300
Message-Id: <20250624135214.1355051-2-romanov.alexey2000@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
References: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IRQ count is no longer hardcoded, and make it part of
struct meson_flow. We need this for extend driver support for
other Amlogic SoC's.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c |  2 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c   | 47 ++++++++++++---------
 drivers/crypto/amlogic/amlogic-gxl.h        |  8 ++--
 3 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 29048da6f50a..b19032f92415 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -19,7 +19,7 @@
 
 static int get_engine_number(struct meson_dev *mc)
 {
-	return atomic_inc_return(&mc->flow) % MAXFLOW;
+	return atomic_inc_return(&mc->flow) % mc->flow_cnt;
 }
 
 static bool meson_cipher_need_fallback(struct skcipher_request *areq)
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 1c18a5b8470e..dc35d7304eb0 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -28,8 +28,8 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
 	int flow;
 	u32 p;
 
-	for (flow = 0; flow < MAXFLOW; flow++) {
-		if (mc->irqs[flow] == irq) {
+	for (flow = 0; flow < mc->flow_cnt; flow++) {
+		if (mc->chanlist[flow].irq == irq) {
 			p = readl(mc->base + ((0x04 + flow) << 2));
 			if (p) {
 				writel_relaxed(0xF, mc->base + ((0x4 + flow) << 2));
@@ -110,7 +110,7 @@ static int meson_debugfs_show(struct seq_file *seq, void *v)
 	struct meson_dev *mc __maybe_unused = seq->private;
 	int i;
 
-	for (i = 0; i < MAXFLOW; i++)
+	for (i = 0; i < mc->flow_cnt; i++)
 		seq_printf(seq, "Channel %d: nreq %lu\n", i,
 #ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
 			   mc->chanlist[i].stat_req);
@@ -153,14 +153,32 @@ static void meson_free_chanlist(struct meson_dev *mc, int i)
  */
 static int meson_allocate_chanlist(struct meson_dev *mc)
 {
+	struct platform_device *pdev = to_platform_device(mc->dev);
 	int i, err;
 
-	mc->chanlist = devm_kcalloc(mc->dev, MAXFLOW,
+	mc->flow_cnt = platform_irq_count(pdev);
+	if (mc->flow_cnt <= 0) {
+		dev_err(mc->dev, "No IRQs defined\n");
+		return -ENODEV;
+	}
+
+	mc->chanlist = devm_kcalloc(mc->dev, mc->flow_cnt,
 				    sizeof(struct meson_flow), GFP_KERNEL);
 	if (!mc->chanlist)
 		return -ENOMEM;
 
-	for (i = 0; i < MAXFLOW; i++) {
+	for (i = 0; i < mc->flow_cnt; i++) {
+		mc->chanlist[i].irq = platform_get_irq(pdev, i);
+		if (mc->chanlist[i].irq < 0)
+			return mc->chanlist[i].irq;
+
+		err = devm_request_irq(mc->dev, mc->chanlist[i].irq,
+				       meson_irq_handler, 0, "aml-crypto", mc);
+		if (err < 0) {
+			dev_err(mc->dev, "Cannot request IRQ for flow %d\n", i);
+			return err;
+		}
+
 		init_completion(&mc->chanlist[i].complete);
 
 		mc->chanlist[i].engine = crypto_engine_alloc_init(mc->dev, true);
@@ -230,7 +248,7 @@ static void meson_unregister_algs(struct meson_dev *mc)
 static int meson_crypto_probe(struct platform_device *pdev)
 {
 	struct meson_dev *mc;
-	int err, i;
+	int err;
 
 	mc = devm_kzalloc(&pdev->dev, sizeof(*mc), GFP_KERNEL);
 	if (!mc)
@@ -250,19 +268,6 @@ static int meson_crypto_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	for (i = 0; i < MAXFLOW; i++) {
-		mc->irqs[i] = platform_get_irq(pdev, i);
-		if (mc->irqs[i] < 0)
-			return mc->irqs[i];
-
-		err = devm_request_irq(&pdev->dev, mc->irqs[i], meson_irq_handler, 0,
-				       "gxl-crypto", mc);
-		if (err < 0) {
-			dev_err(mc->dev, "Cannot request IRQ for flow %d\n", i);
-			return err;
-		}
-	}
-
 	err = clk_prepare_enable(mc->busclk);
 	if (err != 0) {
 		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
@@ -292,7 +297,7 @@ static int meson_crypto_probe(struct platform_device *pdev)
 error_alg:
 	meson_unregister_algs(mc);
 error_flow:
-	meson_free_chanlist(mc, MAXFLOW - 1);
+	meson_free_chanlist(mc, mc->flow_cnt - 1);
 	clk_disable_unprepare(mc->busclk);
 	return err;
 }
@@ -307,7 +312,7 @@ static void meson_crypto_remove(struct platform_device *pdev)
 
 	meson_unregister_algs(mc);
 
-	meson_free_chanlist(mc, MAXFLOW - 1);
+	meson_free_chanlist(mc, mc->flow_cnt - 1);
 
 	clk_disable_unprepare(mc->busclk);
 }
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index d68094ffb70a..9f1ef87333ae 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -22,8 +22,6 @@
 #define MESON_OPMODE_ECB 0
 #define MESON_OPMODE_CBC 1
 
-#define MAXFLOW 2
-
 #define MAXDESC 64
 
 #define DESC_LAST BIT(18)
@@ -62,6 +60,7 @@ struct meson_desc {
  * @keylen:	keylen for this flow operation
  * @complete:	completion for the current task on this flow
  * @status:	set to 1 by interrupt if task is done
+ * @irq:	IRQ number for amlogic-crypto
  * @t_phy:	Physical address of task
  * @tl:		pointer to the current ce_task for this flow
  * @stat_req:	number of request done by this flow
@@ -70,6 +69,7 @@ struct meson_flow {
 	struct crypto_engine *engine;
 	struct completion complete;
 	int status;
+	int irq;
 	unsigned int keylen;
 	dma_addr_t t_phy;
 	struct meson_desc *tl;
@@ -85,7 +85,7 @@ struct meson_flow {
  * @dev:	the platform device
  * @chanlist:	array of all flow
  * @flow:	flow to use in next request
- * @irqs:	IRQ numbers for amlogic-crypto
+ * @flow_cnt:	flow count for amlogic-crypto
  * @dbgfs_dir:	Debugfs dentry for statistic directory
  * @dbgfs_stats: Debugfs dentry for statistic counters
  */
@@ -95,7 +95,7 @@ struct meson_dev {
 	struct device *dev;
 	struct meson_flow *chanlist;
 	atomic_t flow;
-	int irqs[MAXFLOW];
+	int flow_cnt;
 #ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
 	struct dentry *dbgfs_dir;
 #endif
-- 
2.34.1

