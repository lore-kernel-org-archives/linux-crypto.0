Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721587;
	b=lOGLnxrjp57DFianaouIvFZlheDOuZM9AzbKDuihLiudJDyySEOSczzP2mSPTpC2wioV
	 A3+TmZN70d6Ljcq6srab7qhIo3gHuhd9qEYZS9rLV5imdJDPsCzRPL4v9xt9zyVMMNwqZ
	 WkUYy9JN6bxFHOfb/3JKk2Z9k5RBC56Neush0QqjzPpckQVizpgGIYEWWxnfWb13C6CqL
	 h2FqPqx67U385GRj0AYJMyLO3J1EUZ6p6EX7rlJJwnU9RXSpggLH1sGx/VoB3hKWBWcH9
	 x5BBNa716OpMIR7Xk/OpUNKhWBqoLDJ9V+8GMiJc1i5Y2xsF4efG4p0y2AEuWV5r6Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721587;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NWye7nZFqyd09wjqBqg26yH/OXa66ZCjw/Hj8r91FQs=;
	b=c+HdErmKoYxzCj3wR4V42RrC3aUFJf+ltB6Hx6Ex5cdNM2ha8OAznp13eLT90cwkz1Sb
	 o0zE/J1MtrhdQXIqUTzUEXxiWSevghOafKMb/rCXkJ+ZEEhu93656aA0nxMCvwBwCn7tL
	 ACCucjBz+GKwNDoIqEeH5DLrdh8e2u65KdcT4lL3C4ocf688aL5gSATkKXxMxIam3r8j4
	 wUZ9CuBBAYTbvUX+tD2ACjpnbW4QOSPequyCnIeNH2EPdW7Oa18LKp7b19Cz/aT79mkrH
	 lX8p5wUfYIGXWlIpfdfkBrQbJGMnhNqRKUOPRzJXhHkfBfcHhThX43XCR2qSy6MZZAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fFY5krPE;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74DD606A32D
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C74DD606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fFY5krPE
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso53574775e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721585; x=1796326385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NWye7nZFqyd09wjqBqg26yH/OXa66ZCjw/Hj8r91FQs=;
        b=fFY5krPES0QvD3oTK9dRL3IAWap3JMB54RjpsjWjUtVL32r/1hLA39NTgeteKl7cp6
         ekbWY19jjuWjIV0bVAsLTluM0VkXYAdmeRkirGFEe5oghpgG6ipf6XSq6XtSTWOqYdz3
         /Xz+OTGUDS7yqEpuYVMAsvqIkZcKrKONkRrsGulbTo2AJ3gQpqzIKrsLHGY5hEppiLHb
         SZoTflkGY+Hg1lRVrcGvCzI614rTgs7nmIENs261OKgwz1f/91ZpRoLn0u+1LVfQy6P4
         PGp7vX4DmIuEBBkBK067iXqTmf+zsUz8NGR0pGGmK6A53Vq5jlSq4lG/RzUXtg5/a/6r
         eE/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721585; x=1796326385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NWye7nZFqyd09wjqBqg26yH/OXa66ZCjw/Hj8r91FQs=;
        b=f8A9JwKAlGwoTE082mkNywYVdbYo0Q5fDlcHXl2Uxyxo4Bjh7gqkN2z8Dzk53IEjjh
         QCKv/Jh620mS9TAXxcBLeeeOeDUCPDjK1dRYp46GH2AUAg6UB7GBXnkpEmJKQjrkY2Rq
         KYKYmd/jYFpukSS85zvDZuRPgmNBgue/dkaHuMy/DqTiPI6N4T62KXZje1SCVrQ8AGFu
         9c0tz8OzQXBk6RvFEeicEyE0n6yeGf+nBW2cABSsz1RL+yRQ51uj7TQ16+Vh7orJ7pRE
         fVHhVwb1aayVbi9bR6xK1y+YPQd2jntWI+efrx/YXnHSTNo5MkKOXSbJUBZS0iPtLY84
         DuAA==
X-Gm-Message-State: APuU4Z/VPy3OoCsRB+0oxcI5SFPmMe3g9JQFPa7fDvDWEfP0RuM2EUUI
	Fe2kIFE1yO/nf8gHj1i4m7L87lJeCLCrXky6flS5DrV43tlmpNzKGW/L
X-Gm-Gg: AZFdTZfl8SQYtr4kTI4rBrpYJF/hpIYfBCu+LFDlk5BaoVNUgxXtaeqYJpUM/RylXy1
	elgiI4C3/kAkF4w2yUcLWA6RmSpuWNgavsvROgx/rTdWBrJRGzg9QHetSxlLhQ2DQqZ13LjxMSI
	CNU/2m1uDPU0rnrWrJonnEgEZy6C+vf6Syn7dqONUPGtgic3vv1rRPJYsmBtvkZiBvrXltXVgFr
	wv/Q9Va3ml3HfRH6Jj44GKEeMAGBEA8e4sP0UeU8xBfE1AhZHtnxSc7SUyNDTXLpyaGjA47ePFE
	5vTuIsIsBQJFkxy/MEWIqw2v6wnDYZLbaz7T0nKQrqlxEbQywgPeGoKPm/fUL279G/q7ZyKrWx9
	2fURVFX9Zbm3Ro+5Odnl7ke6JW4iJ+RrZ5iX3SK4UtcwG4/TPKcft/M4CFUgaGGpZsgAWMeJDaz
	TUnAg+1oi9+Oxgtq1ZtfTPU3LN3kTSGEPu09+Q3KLVLjPAQpg8GDiFHau+n9mAad8Otp958jejF
	EJds+tV7nrRU93A2xgMAOhzcacOjLgj928Hdp+zrXb4hTVopSQ2JRWOngDAkWigLG65VZC+rWV7
	VkD0L55OA4fDqyzWTLacwndIT58ccFrqUK+wrDMAxmCfWZQFXsVIngQP3ccqWnjPpwg=
X-Received: by 2002:a05:600c:4f16:b0:4a2:47:b79c with SMTP id 5b1f17b1804b1-4bb8882a66emr495180995e9.32.1795721585086;
        Thu, 26 Nov 2026 11:33:05 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:04 -0800 (PST)
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
Subject: [PATCH v13 04/25] crypto: amlogic - Add platform data
Date: Thu, 26 Nov 2026 20:32:20 +0100
Message-ID: <20261126193241.1471372-5-jnieto.alaber@gmail.com>
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

To support other Amlogic SoC's we have to
use platform data: descriptors and status registers
offsets are individual for each SoC series.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c |  2 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c   | 22 +++++++++++++++++----
 drivers/crypto/amlogic/amlogic-gxl.h        | 11 +++++++++++
 3 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index bcaed2f413d3..c458548f29b2 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -234,7 +234,7 @@ static int meson_cipher(struct skcipher_request *areq)
 
 	reinit_completion(&mc->chanlist[flow].complete);
 	mc->chanlist[flow].status = 0;
-	writel(mc->chanlist[flow].t_phy | 2, mc->base + (flow << 2));
+	writel(mc->chanlist[flow].t_phy | 2, mc->base + ((mc->pdata->descs_reg + flow) << 2));
 	wait_for_completion_interruptible_timeout(&mc->chanlist[flow].complete,
 						  msecs_to_jiffies(500));
 	if (mc->chanlist[flow].status == 0) {
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index b6933be39a37..24ef7d5a5607 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 
 #include "amlogic-gxl.h"
@@ -30,9 +31,10 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
 
 	for (flow = 0; flow < mc->flow_cnt; flow++) {
 		if (mc->chanlist[flow].irq == irq) {
-			p = readl(mc->base + ((0x04 + flow) << 2));
+			p = readl(mc->base + ((mc->pdata->status_reg + flow) << 2));
 			if (p) {
-				writel_relaxed(0xF, mc->base + ((0x4 + flow) << 2));
+				writel_relaxed(0xF, mc->base +
+					      ((mc->pdata->status_reg + flow) << 2));
 				mc->chanlist[flow].status = 1;
 				complete(&mc->chanlist[flow].complete);
 				return IRQ_HANDLED;
@@ -254,6 +256,10 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	if (!mc)
 		return -ENOMEM;
 
+	mc->pdata = of_device_get_match_data(&pdev->dev);
+	if (!mc->pdata)
+		return -EINVAL;
+
 	mc->dev = &pdev->dev;
 	platform_set_drvdata(pdev, mc);
 
@@ -307,9 +313,17 @@ static void meson_crypto_remove(struct platform_device *pdev)
 	meson_free_chanlist(mc, mc->flow_cnt - 1);
 }
 
+static const struct meson_pdata meson_gxl_pdata = {
+	.descs_reg = 0x0,
+	.status_reg = 0x4,
+};
+
 static const struct of_device_id meson_crypto_of_match_table[] = {
-	{ .compatible = "amlogic,gxl-crypto", },
-	{}
+	{
+		.compatible = "amlogic,gxl-crypto",
+		.data = &meson_gxl_pdata,
+	},
+	{},
 };
 MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
 
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index 9f1ef87333ae..e0bc5c39bf2c 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -78,6 +78,16 @@ struct meson_flow {
 #endif
 };
 
+/*
+ * struct meson_pdata - SoC series dependent data.
+ * @reg_descs:	offset to descriptors register
+ * @reg_status:	offset to status register
+ */
+struct meson_pdata {
+	u32 descs_reg;
+	u32 status_reg;
+};
+
 /*
  * struct meson_dev - main container for all this driver information
  * @base:	base address of amlogic-crypto
@@ -93,6 +103,7 @@ struct meson_dev {
 	void __iomem *base;
 	struct clk *busclk;
 	struct device *dev;
+	const struct meson_pdata *pdata;
 	struct meson_flow *chanlist;
 	atomic_t flow;
 	int flow_cnt;
-- 
2.47.3

