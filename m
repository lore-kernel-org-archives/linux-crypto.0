Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780880;
	b=cl8f+daQajbpRLfZGDTtrM0Kv7ni40/5allzL+BOUOCmiAF1WxZRp+U1CwC1o1rfS7+P
	 8NwM7FS+DAJWHua2D1GQiZjzQl4vLUIHCtBxGuUdZUm9ce9D5Wxc9DSV3Dva/DXBC9YkK
	 gfXtSyhiXTSxJh55Yolm+HJn7x9unmJ0MHhdGxud02fJxFw3zUH54uiRPc481ndSOaH4U
	 UDBRv4RW5oWiWe7lqxPPogwZNkhDJHcLHCO7QDfSDTUFUgvPQAbQGrzSB7Ju2kqM1cicI
	 EWiIPvXVKjxjXci+dCfwInXh1U16rfL3jPwZt4il6lhUReF8y+RFIGun1Ip+qKaB6Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780880;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NWye7nZFqyd09wjqBqg26yH/OXa66ZCjw/Hj8r91FQs=;
	b=fslldnYvvKr3A83FmI2Q6SqzfvmdRzpHjd6Xzfirk+uyMfyBUHrZ30YnB9e82LFhDmgC
	 KW+Foduhaqw117OM1ncWDFc8kGTOi+/3JJBmFX7xy10f1brVQXBeIQqaU8UyArWmQnDic
	 ihVkmg085Sww7odfGlZ8z2loEWvREj21L0UQP0ZVF8lgLRqCkAca+a11GrdMvb4ZlD7eX
	 XO7UHo8DDp9EHBi0W0Q5wbeuUFaa3g1oslv1dFZ262p6VAJqkBZnAvF869wBHMZHpN6Ed
	 Dqp7SDU8MPDRF7dGbxGyrnX2+k8gMaoo/t+LZde6PjcrVM1CVEYn2pON7xl+S4ZJkmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JUPBlY9p;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E84606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7E84606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JUPBlY9p
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso42780525e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780878; x=1796385678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NWye7nZFqyd09wjqBqg26yH/OXa66ZCjw/Hj8r91FQs=;
        b=JUPBlY9pt61vylmxI85yUFmomu1+wJME9sHD0ZAEoeSCfgXzU/aLQT1FyP7viFF/fj
         J4Jxi3KLP/4EFTAkIKIIgGb29HNyRqw626iOFkFbJrdQtSbDKkU9m5fqTALP9+JdyAuv
         4p3iYCbolNpasK2EJYk771bMw+io6kcw32mOUNfW8cbj7NQ1CEWcVfhqIHrHDTR+1ATZ
         lvSLSi1t2EH0cS2eDJP01Kg+WmL8/x4dDpaxI517ff6nDs45ZkfbTby/a38aCV6+rKC9
         mEuyHHLgu8YRU5Bxxlmb/sW2Eu6KQqqw6QCFW+xZmKQ5bQkwm5lzIve3zl38jeXTtlND
         oZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780878; x=1796385678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NWye7nZFqyd09wjqBqg26yH/OXa66ZCjw/Hj8r91FQs=;
        b=qNua5YTLFY2rxIb1W3n2rcOgcYsxykOPtS/RsEMIKIzCYbGjPNPIgjiwduhspPezB3
         Ub41Zg8pYcW+QZJvwT9KJ/DrttOegJCVhaSKT7lcifnSsC/gZpjCdgJOCibD36Lc3oIh
         fHmoxhSEh59jlO+3KHGORoSqivYlm83LdbWLxXxD5WrY9sjzxRpng5tqvBsrhnXRjvW9
         yXnaNr2qIahojY+mDDDkVHEDw4x9MVX5k8oSwopeBSV9kKX8dyfV1LXDLUAt/qv4lZau
         FuFqu2y/0qhYK8pVdMMtPAxL6AswbRsnMlv+JxfmmqxKm66M7L0JF2uTLqgYh5rh23Ya
         CiMA==
X-Gm-Message-State: APuU4Z8Pg8xMMXwAY5jKkcA0tSnfUCt5zhmvO8Ue69WLMC3HZFvsuKMW
	3bJZO7b2mdZMhCFADNs9NCvuq5qrecAKiEURF4sZSpbN/6d4neJ690C2xjh9k8MI3N8=
X-Gm-Gg: AZFdTZcmR0qBh4cB1XIEAAjdfQu1xv+mzp+y24wnJJHzPLXzZDq8R4tr5qUIj79RiVO
	9Bge9QePBubUsLQMw7qlRUgmWfah9JsKoOshwKh65ZndMwopDWMysu70FOBsau6g19Qh5UqC4Fm
	xCalDgNRx/bGq0GzW0Iva9q+WpTw/Pmfm2VA7VjEvqJKHPRNYjZwqRjnO3q6OJEwHHEnJ6kfWLS
	tDza8gULYvcES4NEadCDLODW6Sbsc1AFQd4opHLKzqe0ycKZJulXo2ALpIadys6MYDHXQiEt4F5
	m5zrBjqPBHzvtuJmGJVqgpkDYv338K3yxWBiv+RK1D5+BRijFtOYE9NAzoRciv4Z37+gL3/FH4L
	SKNuibjxnAuqjMad3cti09+iIZqM/W/jtNkKtt1qeZnlX/O/xITUUtFzX4lZIrZHm0LHJ+SAQXH
	SbMSH9psq10ql/L4e3iTAohlVFd6v9il+wTvaGox8XJ8bf+a4X65Sr9uxdhLfxZIrWl7oPXneFN
	CIwtNxIoAhJs0An1TOfSyByOGF8sh/Ws1drfAlm7ibAnkB9j84E/aqb9C/UWhmMQE9WoW4yQIbx
	jWBJBkitSkL+l460bIEQeWb6aclp5Rkk5tkckCadLCwb9PM=
X-Received: by 2002:a05:600c:3ba3:b0:4bb:7571:5743 with SMTP id 5b1f17b1804b1-4bb88813444mr557829315e9.27.1795780877738;
        Fri, 27 Nov 2026 04:01:17 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:17 -0800 (PST)
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
Subject: [PATCH v14 04/30] crypto: amlogic - Add platform data
Date: Fri, 27 Nov 2026 13:00:37 +0100
Message-ID: <20261127120103.1532882-5-jnieto.alaber@gmail.com>
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

