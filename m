Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42FFA1E411D;
	Fri,  8 Nov 2024 10:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731061781; cv=none; b=O9iOqvM78N4DFSNyIFZBxEEdJA/uVD2MvH4c2vOwAXmUnorAb4p+Rb7ybO9hngSjV55neXYPFnaLdUYr2tmtlEgsJlCJg29JlqnVN0AfAhYRiq6hf8DYdRsLKbthpZl9MoYhaUr4cHgKQIE0HjobF3P3nb3q/hg2rUP+77iGTa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731061781; c=relaxed/simple;
	bh=yGAsqIt3+hE4ufw4XgUXmn0redvklmExhdj/fGOyTEo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d4GP83k5XLFTQv2QLZqVF+xS2DdD2oxa/96teSiad56syg0U71hpcq800hpG6QGSsawmNipO+qZsjA9P0No8Dm3VXPpxwAUDWdwZ0ci8n+LYsFJ2Zr4ugIb2+C/wpaTtELm8hNOCmhnqx8JXR6dGNCpLRqkdiD5gtc+/E0gvwFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=FZNyGGmX; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="FZNyGGmX"
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 38757120032;
	Fri,  8 Nov 2024 13:29:37 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 38757120032
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1731061777;
	bh=ErezDdZ5Plws8x0YH4acUuHPN0MVqpPlBAf7hHZc5Gs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=FZNyGGmX1dQHOY1VKg4T5xgSsBymy3kWYlww/EUKVzc4uqjWRHj/+aX+gTLQaDV3o
	 5cBhAGiQvmQUO5pQNUrHomkdSLSRiRs+al65aezAa0Vc5TTDF68mVuFyu3bkXZqitF
	 15BkSLALI0G/lt93RCdKML2MPa3GwqH5LV/kZX5x5BvJ4y9cTK8hUaRSTwyTrjHUpq
	 Oq1OAXdX9vCRg2cvUq6ndx79zpTjSg7Ekh/r2x4W1IR91Dw9aX3s3Rdf3n4iDE9bAP
	 2uQCcI87tPDzJvZcnJdUj56tk/U3CvWd6NLNsumqh6HSYqEhEYgGhsCrh4BavxNZu3
	 2GzjKwHBNm71A==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri,  8 Nov 2024 13:29:37 +0300 (MSK)
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
Subject: [PATCH v10 06/22] crypto: amlogic - Drop status field from meson_flow
Date: Fri, 8 Nov 2024 13:28:51 +0300
Message-ID: <20241108102907.1788584-7-avromanov@salutedevices.com>
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
X-KSMG-AntiSpam-Info: LuaCore: 41 0.3.41 623e98d5198769c015c72f45fabbb9f77bdb702b, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;smtp.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/11/08 08:34:00 #26834472
X-KSMG-AntiVirus-Status: Clean, skipped

This field is used only to check for timeout. But there is more
convenient way to achive the same goal.

Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 13 +++++++++----
 drivers/crypto/amlogic/amlogic-gxl-core.c   |  1 -
 drivers/crypto/amlogic/amlogic-gxl.h        |  2 --
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 18e9e2d39b1f..dc0b100c5de2 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -219,13 +219,18 @@ static int meson_cipher(struct skcipher_request *areq)
 	}
 
 	reinit_completion(&mc->chanlist[flow].complete);
-	mc->chanlist[flow].status = 0;
 	meson_dma_start(mc, flow);
-	wait_for_completion_interruptible_timeout(&mc->chanlist[flow].complete,
-						  msecs_to_jiffies(500));
-	if (mc->chanlist[flow].status == 0) {
+
+	err = wait_for_completion_interruptible_timeout(&mc->chanlist[flow].complete,
+							msecs_to_jiffies(500));
+	if (err == 0) {
 		dev_err(mc->dev, "DMA timeout for flow %d\n", flow);
 		err = -EINVAL;
+	} else if (err < 0) {
+		dev_err(mc->dev, "Waiting for DMA completion is failed (%d)\n", err);
+	} else {
+		/* No error */
+		err = 0;
 	}
 
 	dma_unmap_single(mc->dev, phykeyiv, keyivlen, DMA_TO_DEVICE);
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 44e71e917e5e..9259ad0417d1 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -53,7 +53,6 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
 	for (flow = 0; flow < mc->flow_cnt; flow++) {
 		if (mc->chanlist[flow].irq == irq) {
 			if (meson_dma_ready(mc, flow)) {
-				mc->chanlist[flow].status = 1;
 				complete(&mc->chanlist[flow].complete);
 				return IRQ_HANDLED;
 			}
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index cb70277c3a31..0dde7662ae37 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -59,7 +59,6 @@ struct meson_desc {
  * @engine:	ptr to the crypto_engine for this flow
  * @keylen:	keylen for this flow operation
  * @complete:	completion for the current task on this flow
- * @status:	set to 1 by interrupt if task is done
  * @irq:	IRQ number for amlogic-crypto
  * @t_phy:	Physical address of task
  * @tl:		pointer to the current ce_task for this flow
@@ -68,7 +67,6 @@ struct meson_desc {
 struct meson_flow {
 	struct crypto_engine *engine;
 	struct completion complete;
-	int status;
 	int irq;
 	unsigned int keylen;
 	dma_addr_t t_phy;
-- 
2.34.1

