Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5402C3268;
	Tue, 24 Jun 2025 13:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773189; cv=none; b=RBTKfTQEmT8OvGp8gruzTBbLoeInZM+ffn81UuyEfF18MIefoBY9lPVp+rVKE/LoLhXl5/87V2HHVPlz5Rc+DbVsK/0LWXc8E33n4VYnS1krMzfND6J8kVTQkcqrk9pPh+AYqRhUnHdKtjucLD3gq7EIsBEe9Fg9UvmaeaJRVZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773189; c=relaxed/simple;
	bh=u4MgYo4pR/T6KjzWlS699XIQygygNOdTo6AXfPXd/oA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q1f74TXd9RuPsBsChi4TYowDlslScTjmvyBnczkll9MEqEv6NRG9xNaRL3hrIViCaz/SD6fsnN5w0ke0xlYSc7nUs7678hLmmRAg9ncVwskya+1GRNdMC/rTfGnOLp7CHMMsZLmuzLIKt75NXYem9y7JmsPUwPtkLQ4cXCC7BPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i08JcJ01; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i08JcJ01"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-553dceb342fso414031e87.0;
        Tue, 24 Jun 2025 06:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773186; x=1751377986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UzoQtJ2+Gby/Cw80qh1dP5yN37TDjaDpOb4iIQblBnY=;
        b=i08JcJ01ZVMmsyA0OMov3iRKgCg3aDK/urXJSXhsUjihJdbjL/+uo6b3KieaL8B4hk
         rcgBLFKf/5KjxEo45IC+CStQqQRdC/lnz8GfBazDdcCTGkUMmdSEOX25tN+kc6fnCShZ
         V7+MXAHI37aIcmnndzhw48qbwZR2Prld1Jlf3NwpMIz9y+Hm7uplL3dBvlPlDXEiIQuR
         C+HF6srh85iJzcZg5fIGZ312vd79BQsghjMnBlsdKBPp18YhB9Rj8UA3WNWoDi7W5Qra
         Gk/F3T7P2dkH7D3+qDAPM76x2rws2LARD2Juzrh5kux9i/lg7zRwQzDa4nlK8t+cRN91
         55YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773186; x=1751377986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UzoQtJ2+Gby/Cw80qh1dP5yN37TDjaDpOb4iIQblBnY=;
        b=Q494SN3vj3DEuLHqlN7u4RkAKaIAlE5znx/xiwTYQXQ1LpY7S8D9x/HDl9DxSkof5v
         Jr0z4OvIuQ/Tc34pUcZ0P/vQrNzFvzPuqHP3rWOgF5Hqb7GkZbniYhtBCAjVHrkUnAXU
         mMJtYOqvQlfcCh/RWPu4uF4SM8Yojkz9dF+KkAV6+71+iDZsFuW6Q9+LZhwrbltjMFE4
         axRAtvrGM2biQYCxomoOBGOYb4CpPjZ7tgw3P6oxjgl7DGno8FehfKJnC3/5S696aeC9
         2qHSxYDnTLZ0BbeiZKYv6QZANLoQQoTt4UMG5uj1vxMYFDSjVFx5tGdfsnZfsL/VftBE
         TBDg==
X-Forwarded-Encrypted: i=1; AJvYcCUJy/0Wg5hPZ63uRTiccrxnX76135G0V/3RXvX0ufw/nPxJU7wXeUUC5pPf2L2+nbuaI/rAf8E/inz/@vger.kernel.org, AJvYcCUMIiVzFNeLB2x42A0quCQbqyqeBfKrlXoG9fHvhfvv7Rch81zfT6+1bHXdPGZJgcBbQ9qVnhrbGVseaxPz@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl7JDNDuRJWyYxhX0rm2cKAZY+xIEHIvUDcAq0xYqOKWS7g3fg
	CLsn/yMd09eqV5bOgWh7gKia4sdU7qcdwuEbOPeJtvvKfJ2ciYj+ie4n
X-Gm-Gg: ASbGncs6rbgGU6qC03D8fi32H6x1zgj6QAT1N1/8mZlYIpmDglc63vjb/8z9N/PQeic
	bA6XkIj8y7w3cIdX0ENgDtTMpv+CJPDD7x/ZB42iWRVmFFkXdKUNnrky1BsYB7ThoEs/NDBjxc2
	fPd2JYrm0UiH9ocqgv9v0hVHLi4X4Un9IhvE7Kpb2c3v5SJB8j6xTkVWE8+BWsQSSkpRF7xJ4xw
	cmXpNty12UkKeWc1uZsg+9IkUYkL+NnjTyuCK0hgfYPcGaYMpBMF0gx4Ilq4885UfVipr6ac5iG
	KccEPkbxxeWyNmB2+ZSMFWxGymEbWl5+vBv0Rc6wO9fy5XT778mmwttDKpmVJ/jEQBaS1Zggvjq
	hx/THjOBB2jZLji/fgxt+lipdc/g8V74fAOA5PkbOZ3IhBja2nIGM8v57QRpKNA==
X-Google-Smtp-Source: AGHT+IFMNI8Veoel+fiiWLgZH3VVejMWZ1Zn0rb/ht0ioBubOtSiNdwqsWxi4IL2PzRtmQkU0o+yIQ==
X-Received: by 2002:a05:6512:ac4:b0:553:ae47:6856 with SMTP id 2adb3069b0e04-553e3b9a603mr5057869e87.10.1750773186027;
        Tue, 24 Jun 2025 06:53:06 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:05 -0700 (PDT)
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
Subject: [PATCH v12 02/22] crypto: amlogic - Add platform data
Date: Tue, 24 Jun 2025 16:51:54 +0300
Message-Id: <20250624135214.1355051-3-romanov.alexey2000@gmail.com>
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
index b19032f92415..7eff3ae7356f 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -225,7 +225,7 @@ static int meson_cipher(struct skcipher_request *areq)
 
 	reinit_completion(&mc->chanlist[flow].complete);
 	mc->chanlist[flow].status = 0;
-	writel(mc->chanlist[flow].t_phy | 2, mc->base + (flow << 2));
+	writel(mc->chanlist[flow].t_phy | 2, mc->base + ((mc->pdata->descs_reg + flow) << 2));
 	wait_for_completion_interruptible_timeout(&mc->chanlist[flow].complete,
 						  msecs_to_jiffies(500));
 	if (mc->chanlist[flow].status == 0) {
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index dc35d7304eb0..d7e455f73c04 100644
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
 
@@ -317,9 +323,17 @@ static void meson_crypto_remove(struct platform_device *pdev)
 	clk_disable_unprepare(mc->busclk);
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
2.34.1

