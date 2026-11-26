Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721585;
	b=qp923bT28Rh1vVwFKuUUBvCFVCdVbapBIi0U9hDcWW0N70XoSipj4nbP0viLzj1pBjzQ
	 PXeMl21Oo1vkQIR2eUrNGXbxTl+cpTk9fr1TTT9JKlo2bZmOgpvkdt11R7hwD1fQRUFW2
	 MRHDXvoNr1RPRU0DYtUpY3iLYKX/N+vFVw6XYR5O76LBk6nT7LBAhqx41vPD7KmwVGgcL
	 1+nVSvB/eHoK7fUdb4TxEmTbfBgcw2GIT5CraXn9CKpuS7iqn6DeIPUi5WlQn260tcvcB
	 kg/yUQzYZvJXiaZ7XM4GOpa7thTx7hTIc6Exge6snX5+8dxaRlk7ZEk7UhT46tTRmjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721585;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RbnehnxFa5VmvpfZVJ74/P+D94YlubLC2LA1THJEzhg=;
	b=0b0wQfBO0X9uHY6013ZeMVw81XODzs6OtCU/xT8Y9Vl6P2ahll+juHA5pNiwOSQuX3ae
	 Eyyih3up+zeQDQ7kjQ0u6iv9hImkVwJ5W5I0xIE3yu5huvhxXpbH+YgXquo4Q5hoT0frd
	 FB028xpLvZTVRkjRg6QEFdH4a43gK2fWLZK9BjawwA50DvU2IQ53LFhQVz3pV4eB0jWhx
	 8W5Wxs7arOXBM8FdhwShoOEDF9YBbhvKgY6zlzb6JAMjY6BCJsS21P8+ZhJURsPkr4Njw
	 JwruuyA5ciU13YZfPSuc0Fr4hanRF2y1SPYGMRGsiqfZBT0PQc587HvDpl/r/+CxJhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G4BhX02D;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7870F606A31E
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7870F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=G4BhX02D
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso57791725e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721584; x=1796326384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RbnehnxFa5VmvpfZVJ74/P+D94YlubLC2LA1THJEzhg=;
        b=G4BhX02D8BJgjbER5BdDi4/rxfsMpC1oyafv/7PG13K9N79cmg/jlDip6FWY+gWXw3
         K9bWi3N11Z3MFZ3sBqAAUtvt60Rwsn+I5iJ+C2sI0l9oIgjH55J8f1x8zqL43eXmwpOr
         jZqadKGBpQQoWB/IPtJFHRtPpSs1e+iv3ooFdOcJOwMV+dPETPGodPCZ88g1P4hLc+1r
         Z1AQUI5xkJktZCpwp4dlBEtPnyY6ZqRMDA9h6SgAKnorVlE6X9bhxhc7tX7DKHaQ7pWp
         Yo4wKXnXJ1JFNzVRsCANs1ICUFCdNqRAXC7wv4PiJYOrysSUZZ01tkO+2lDknNrnhFqF
         J8Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721584; x=1796326384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RbnehnxFa5VmvpfZVJ74/P+D94YlubLC2LA1THJEzhg=;
        b=YQBF3QiJKoI5RrqnSC5zDdWV1rL2At+XCz2YRftTChfhzcRXKO02HjO5Q5Qesbzse1
         /zRJQhMXnZjtstN7TnUzuQY3V41jSSIxXd5kBCPvmv83CnFDnk8RP0Op5aXfLiezLfYA
         QYLNRnnFzw+036TrYZ/IC+0ygaYLDfh0bqCAttx3wtowmjbua/VKM/AvNnokF49DnPq/
         7I0npo2qdl76hyCIvVE/O3kOFLyLjJX8eKWkjY6Z2aYuMIGNytT30PBxjwvlTMMYZ/Zy
         e0LcG2NgsVSpmPnJbZ5PP/IFaP77+gDGk+jleD6BDdjkKeLimLUzkotwdO7xM2f0wBQE
         lfxg==
X-Gm-Message-State: APuU4Z/edBoYZN+RgBA70pzREkDk0ZLVnPbcyrecCnEfFEnCIFAUUM/Z
	j+NAPDP4Op+QfIZOCzrG449A3C5JlidUd1fcRYcDv0zWIQ7MuANBfW1e
X-Gm-Gg: AZFdTZe2aNe2394c9HTda8OjfOn4zyJcR6GzTqzbtilI30KuYcSpQNEcmJtHr6XuREQ
	rkRLYB1L8uXHQrUCZrC0diOwToO9I0as19SI/UazbBjeL6jx5Xu+fTcEa8VoiHD4/eV285lKhX5
	PGhUA/FS26fZ8EsyEl3uCrPIwpd5S8DvQlM2iTfPFOZRwL5xjhCeGhTUbek7m2/iWq92oaFnym4
	E+a7oiBfDmjy6+NQkJAxusdobLbuh1fhWOQbqIIRW7RLpscktxpA99poghhWcjoVfvMd1nac6k5
	z13A3tJ9XTw8OYxxkVEIhfNs59Mn1GZbbnwk+JKepeEGrra3q/OzeYxSCLo/iZAlxjGQj/ftkaa
	m2ZF/FtgmP2n8egg6ZmJ6+RNolMINhM+YPFTng/4TM7XnUtpZ2L0qejqBhkh0eRdZAEPoNpcOGD
	3lSvukNhmSp08J0i71znc9oTJw77dIXQWPwCluDFibTYzVMeHO0XEeLDcmDLEOyckuj5db6bLl/
	kTNmBdAXvhffKYczFVWQoPL9iZd1g5kXvpMSFvUaV/q9zqmASmhuzomhKvy3OsfutIAahNPMPcJ
	oZh+5VQL3oR48elcoclSYL0FBkUrnrDrddcbwgJ9hfMHFw==
X-Received: by 2002:a05:600c:530f:b0:4bb:68b9:f615 with SMTP id 5b1f17b1804b1-4bb88810b22mr439873885e9.17.1795721583733;
        Thu, 26 Nov 2026 11:33:03 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:03 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v13 03/25] crypto: amlogic - Don't hardcode IRQ count
Date: Thu, 26 Nov 2026 20:32:19 +0100
Message-ID: <20261126193241.1471372-4-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexey Romanov <romanov.alexey2000@gmail.com>

IRQ count is no longer hardcoded, and make it part of
struct meson_flow. We need this for extend driver support for
other Amlogic SoC's.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c |  2 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c   | 48 +++++++++++----------
 drivers/crypto/amlogic/amlogic-gxl.h        |  8 ++--
 3 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index d78815b0547d..bcaed2f413d3 100644
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
index 48dbdf452034..b6933be39a37 100644
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
@@ -111,7 +111,7 @@ static int meson_debugfs_show(struct seq_file *seq, void *v)
 	struct meson_dev *mc __maybe_unused = seq->private;
 	int i;
 
-	for (i = 0; i < MAXFLOW; i++)
+	for (i = 0; i < mc->flow_cnt; i++)
 		seq_printf(seq, "Channel %d: nreq %lu\n", i,
 #ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
 			   mc->chanlist[i].stat_req);
@@ -154,13 +154,31 @@ static void meson_free_chanlist(struct meson_dev *mc, int i)
  */
 static int meson_allocate_chanlist(struct meson_dev *mc)
 {
+	struct platform_device *pdev = to_platform_device(mc->dev);
 	int i, err;
 
-	mc->chanlist = devm_kzalloc_objs(mc->dev, struct meson_flow, MAXFLOW);
+	mc->flow_cnt = platform_irq_count(pdev);
+	if (mc->flow_cnt <= 0) {
+		dev_err(mc->dev, "No IRQs defined\n");
+		return -ENODEV;
+	}
+
+	mc->chanlist = devm_kzalloc_objs(mc->dev, struct meson_flow, mc->flow_cnt);
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
 
 	mc = devm_kzalloc_obj(&pdev->dev, *mc);
 	if (!mc)
@@ -254,19 +272,6 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	for (i = 0; i < MAXFLOW; i++) {
-		mc->irqs[i] = platform_get_irq(pdev, i);
-		if (mc->irqs[i] < 0) {
-			err = mc->irqs[i];
-			goto error_chanlist;
-		}
-
-		err = devm_request_irq(&pdev->dev, mc->irqs[i], meson_irq_handler, 0,
-				       "gxl-crypto", mc);
-		if (err < 0)
-			goto error_chanlist;
-	}
-
 	err = meson_register_algs(mc);
 	if (err)
 		goto error_alg;
@@ -285,8 +290,7 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	return 0;
 error_alg:
 	meson_unregister_algs(mc);
-error_chanlist:
-	meson_free_chanlist(mc, MAXFLOW - 1);
+	meson_free_chanlist(mc, mc->flow_cnt - 1);
 	return err;
 }
 
@@ -300,7 +304,7 @@ static void meson_crypto_remove(struct platform_device *pdev)
 
 	meson_unregister_algs(mc);
 
-	meson_free_chanlist(mc, MAXFLOW - 1);
+	meson_free_chanlist(mc, mc->flow_cnt - 1);
 }
 
 static const struct of_device_id meson_crypto_of_match_table[] = {
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
2.47.3

