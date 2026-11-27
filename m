Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780882;
	b=SHXmmy8gFsNdfV3BtjQljvkTjohDD+cK2/00EUzD8DFuFClGjJSEh36QvFYmLkekTyBL
	 HTRxZlE5PoQh+alsVUmMLDI1lIXe0KsJb/oS5XycaJJDhYSLdOl5hARSaaUlvtVG2Fq2m
	 HOLjF583PEWdu0H4FT6Kl4LPkZaX3SpX36Q8XL0k0bTUeUKSDivpfrMlsOw47+VzHzbV9
	 UupXYks1rLthXhUXQ7mYQHLjBxkFGrb2G8Gtbsf+8LA4+xZ6hC9GCe7YeuonHPGPPADJX
	 yH/HAvgByEg4B8LizqQ/c28/3nurC7SkwEaQ+JM1gFZAye+pZQJl9fUhlWrqZNVt1xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780882;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4dPCbEZZdSDry+u4vUWC6GFpLLhoS8x3SOrFseRsQ00=;
	b=CrIUZfqu4PowrytLcSjVNqaY/nTmQGsTkBLN3Qu1K8U0l4/E359NER8FtF3Kwe+aW04z
	 pX/Xmj/esQwIoobFehfVd6CcmqKHt7jQqfBS1jHj1YN+6UC4b6NSL0X/20cyJFZqcPPhE
	 owadcg3QkQAOeeNhy2EYkpKaNu0pRG4Y/K9qiEh2pbRbDCe/9S7vUASer0WDzwdBfoI5Z
	 YihGxx5EnyiOSc3T5ZdbM70YZzqCSCXgMRI6PrACx3z0O1rsraVGy9rJIja5DKNybb7Uh
	 L69Hokx3N5E7XO9hbH/3MUTcnchG8YnYNCP2Ynxlo2x4QGjBStINpK3zH8ywXIxb0zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d4xKKHNH;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B71C606A334
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B71C606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=d4xKKHNH
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bb55cda775so49683325e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780881; x=1796385681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4dPCbEZZdSDry+u4vUWC6GFpLLhoS8x3SOrFseRsQ00=;
        b=d4xKKHNHOcsd2BrwPv+xi41xFXXKqemuYyxrZtEMrZIjPRyiG+ywE7LI8HmL/yRpp0
         AHTshpNcMsSAVSjr9q7WtaWrBeswZRYMznU9279fQYXzKlWXkBiijzaAE4A2sr/+eoGL
         78Aky1O8+CrvBSOcA9WNnt09FuvMxNBx3g2z1N0F7kHmKjJdWNAR3w5LX1Y/3CPAaybI
         XxZR/CCUSTlpHKqxefVWEOlIAfm2BgmoKa8MolC9W11OZ4n2Jt64Ckp6hFAz1rmefH0y
         br+uA6fiaYWq2ATEqAqpnnDGvNv5KWkjJkj10xjWCaA4Bgu3ZrinEpX/5rEKsSGcmBE0
         Xg/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780881; x=1796385681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4dPCbEZZdSDry+u4vUWC6GFpLLhoS8x3SOrFseRsQ00=;
        b=ATNnETO1I7YsiRoKHQoUiXJlPRPaM/tybR0Um7Gu+hn5QsOTUO4TGlQdOj7OHFQ5iD
         NGWL3KCoo9T1uIne2WOlW2pJ3FzitKDs1Rkj4lSioJTHmuoeS97B9MbIq1Ot3W1EgC0C
         4k4QPX/lItJ8Yv/3FbgYdO1CHJjI9LE6Kyd8YYmBh2kqLXL8GXmj75RpvdgSkMECr5vN
         DDfwGflxIPfu5zaXRsXrwJQoXMxgr2o+q8+Cj+2dxsFTS8hOgHRbva2LYPOvn9cMOKqn
         W9F8yQsy6BxX6WYjMfI9GpabVgkgZavxZj3mFk+FuqC81VnfcgEoNg1eS3tDthp0tQKy
         MdZg==
X-Gm-Message-State: APuU4Z8B9zSzbjKtJ4tiYsB3KKGtMwAw2nzCG4WWrAdOKsabNPGUVNNG
	2brKc7pwS8dnckcXs7yTWSP0GSP2dEVXIqq+gFUpGcCscumDYlQk/x68
X-Gm-Gg: AZFdTZfBj7gW/5HECdVFCN0iJNEgDoj2PmwGRGtyoDNEZ6o9VogvmiYYQ95qYbmzIiL
	7m+vfohbdEHpYeBjDY7A4b3bPzog0z/L56DmLAxcXUK/980ZHsH4w3Tjzbs0k/KYRjzjjlbpFUh
	aueis44hyMsJ44zw1mr61r2XvwclQSR/lRfu/t49vB1Ra3lbcztFShvOyxKrGJQr5yfZ4xnee+j
	/uSmDGomE449GBzIyIiPb2MQjZhW/fyAAZkk1tC4aaqGYjQ/fCoKehJuX5kg0BwlDVd2Z1DdQCj
	w2PzwNenXdgrmV3CAEaZ6Jh1OVKD8R8oUb4I4Po0b1PDvFTDMhEjDoX3WC0Vrdpd61avtbS58T0
	TCzXIqE2JOm34PHrzevFmz3+zlUVREvfSRuI14Rm0wqBRzjOumbs1Emi96GGEOhDFSdJYpJB/vL
	JIGCNhAkJVdNKcBTiA/Z+anQJvAnBeyXCJvIIph5KdfOamR9wlK6GZOuZj+DmBtrHTyKqYc+T5Q
	6xDRJZpg0na/5Sh/SK4DfL2Gvw2k7GZcCY+jAAp5VGrDf3O6nRWNEHG3dUSf4Djq88nB9wEDZlJ
	nRrjyPE9W6wmviYeNctDxZvxDVcIUSPpY3Q32kx6JwGh0bXo3kvcAU9/aSWt8vH9XGQj
X-Received: by 2002:a05:600c:e553:b0:4bb:9457:3c93 with SMTP id 5b1f17b1804b1-4bb94573c9amr293754675e9.2.1795780880469;
        Fri, 27 Nov 2026 04:01:20 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:19 -0800 (PST)
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
Subject: [PATCH v14 06/30] crypto: amlogic - Add MMIO helpers
Date: Fri, 27 Nov 2026 13:00:39 +0100
Message-ID: <20261127120103.1532882-7-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
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

Add MMIO access helpers: meson_dma_start() and meson_dma_ready().

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c |  2 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c   | 24 ++++++++++++++++-----
 drivers/crypto/amlogic/amlogic-gxl.h        |  2 ++
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index c458548f29b2..62aa82e1cb5d 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -234,7 +234,7 @@ static int meson_cipher(struct skcipher_request *areq)
 
 	reinit_completion(&mc->chanlist[flow].complete);
 	mc->chanlist[flow].status = 0;
-	writel(mc->chanlist[flow].t_phy | 2, mc->base + ((mc->pdata->descs_reg + flow) << 2));
+	meson_dma_start(mc, flow);
 	wait_for_completion_interruptible_timeout(&mc->chanlist[flow].complete,
 						  msecs_to_jiffies(500));
 	if (mc->chanlist[flow].status == 0) {
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 37224d75edfb..b972df44e8b5 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -22,18 +22,32 @@
 
 #include "amlogic-gxl.h"
 
+void meson_dma_start(struct meson_dev *mc, int flow)
+{
+	u32 offset = (mc->pdata->descs_reg + flow) << 2;
+
+	writel(mc->chanlist[flow].t_phy | 2, mc->base + offset);
+}
+
+static bool meson_dma_ready(struct meson_dev *mc, int flow)
+{
+	u32 offset = (mc->pdata->status_reg + flow) << 2;
+	u32 data = readl(mc->base + offset);
+
+	if (data)
+		writel_relaxed(0xF, mc->base + offset);
+
+	return data;
+}
+
 static irqreturn_t meson_irq_handler(int irq, void *data)
 {
 	struct meson_dev *mc = (struct meson_dev *)data;
 	int flow;
-	u32 p;
 
 	for (flow = 0; flow < mc->flow_cnt; flow++) {
 		if (mc->chanlist[flow].irq == irq) {
-			p = readl(mc->base + ((mc->pdata->status_reg + flow) << 2));
-			if (p) {
-				writel_relaxed(0xF, mc->base +
-					      ((mc->pdata->status_reg + flow) << 2));
+			if (meson_dma_ready(mc, flow)) {
 				mc->chanlist[flow].status = 1;
 				complete(&mc->chanlist[flow].complete);
 				return IRQ_HANDLED;
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index 5149dc6e9f60..64f2f0e63f12 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -159,6 +159,8 @@ struct meson_alg_template {
 #endif
 };
 
+void meson_dma_start(struct meson_dev *mc, int flow);
+
 int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		     unsigned int keylen);
 int meson_cipher_init(struct crypto_tfm *tfm);
-- 
2.47.3

