Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5061E25FE;
	Fri,  8 Nov 2024 10:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.18.73.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731061776; cv=none; b=plCACXiClE0Mm597e/oV6Mqq7/c7rP2S11M+hBj+OPs/Rh9nZbLgxczajfR7PfyI+dMr3cJ5OInX2FxyV8c4ABO/91065ljingzpwE3dk1VrrFSA+vcLt6kiUrpcUV3z56f/JuW0mZRtk3rCPKydpfTStJ2quqOrx9/MJwUO3tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731061776; c=relaxed/simple;
	bh=zLOdLDR/i2rydrCGAMvwD23X1bnSRXz3k/qrCuHwlmQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jkrpmzq1eh/Lv0+Fk4NNvAet3lZ1kcEo1Zq+WJa+Xkmwqn/tDD+8+mmtzC6Xln1sL62J4tCE9MB84Cmcz0tBigYmc0QUd4r9NgzLFV1OXruNLkIMesXZWJJesIUAxvW/TmrEvOLKklTOhL3fINiPA41qulEqh2ufJZS3hgc4gJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=ALg/pMMO; arc=none smtp.client-ip=37.18.73.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="ALg/pMMO"
Received: from p-infra-ksmg-sc-msk01.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 09BB510002D;
	Fri,  8 Nov 2024 13:29:27 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 09BB510002D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1731061767;
	bh=n7yS5BfqEtjFuahTd+E4xz9oNoQPNY9yD1bCD9GxrBw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=ALg/pMMO+0DydHi3ZO290M4rHyu334JGC95TRXqMNApfCtdCqXrNqFnrjaZHSTsHp
	 xhvttBBfboy+DrrTIMvdUd34+6qQFSsslK7cm4qq8l7px92wfjHj5R3ILPla/TI1R1
	 05tYnVWw4fcZlAfEVroURhCJmLZXQon5zOkZVBF9qhQ+5t7vQA3uIeANFe3XmAl/J5
	 nEXSoqWGP3T6HZkho7lXQHMqoSyERWrGLSQFGK/joVxoIhQqsI/VG9Cf8iQ3gCqjHA
	 tSuBItrf8MIo+GQUyu5fMvtNLi6A6KEgKsaoCQxkFk+9C3ZbdWcIm3MCmixchJeVI5
	 I26/Oe3jx86VA==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri,  8 Nov 2024 13:29:26 +0300 (MSK)
From: Alexey Romanov <avromanov@salutedevices.com>
To: <neil.armstrong@linaro.org>, <clabbe@baylibre.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <krzk+dt@kernel.org>,
	<conor+dt@kernel.org>, <khilman@baylibre.com>, <jbrunet@baylibre.com>,
	<martin.blumenstingl@googlemail.com>, <vadim.fedorenko@linux.dev>
CC: <linux-crypto@vger.kernel.org>, <linux-amlogic@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kernel@salutedevices.com>, "Alexey
 Romanov" <avromanov@salutedevices.com>
Subject: [PATCH v10 02/22] crypto: amlogic - Add platform data
Date: Fri, 8 Nov 2024 13:28:47 +0300
Message-ID: <20241108102907.1788584-3-avromanov@salutedevices.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241108102907.1788584-1-avromanov@salutedevices.com>
References: <20241108102907.1788584-1-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-a-m2.sberdevices.ru (172.24.196.120) To
 p-i-exch-a-m1.sberdevices.ru (172.24.196.116)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 189039 [Nov 08 2024]
X-KSMG-AntiSpam-Version: 6.1.1.7
X-KSMG-AntiSpam-Envelope-From: avromanov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 41 0.3.41 623e98d5198769c015c72f45fabbb9f77bdb702b, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/11/08 08:34:00 #26834472
X-KSMG-AntiVirus-Status: Clean, skipped

To support other Amlogic SoC's we have to
use platform data: descriptors and status registers
offsets are individual for each SoC series.

Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
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

