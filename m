Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2719B2D2382;
	Tue, 24 Jun 2025 13:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773193; cv=none; b=X6jSfcLcXwCE9u7Q2Sgl2GyDpWMVLoY3FYfCYfu1NVFFwglHiw/aBgYCG9gD4yDOADHMeHTgW8am18DQwuY98XyA5hIZmMyDfYZgR60Tr1kPbftQnkojJm2qADzb4T4k8UpeY9Nf9erH3OcyQERGEFokvQKOP6XNcCuXEJt3d/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773193; c=relaxed/simple;
	bh=z9EPqHJSBCA6RvprrExQuE9AaXikN2VLQlv6VHq0eOY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hkgRyQvdd/oK56KdpxkexLu+nncg2RF8puVePViUCWsJAGpa7KuwBZXxRm2bUmjtxHqTcjvE9/9Z0Neibfci3VZd/IoC54P2/0/7OWQ0DJPX1pWTkGYQHSEYZerKVKcyIcqHKPC4Uz6jDvFANB/PjC8+X0OzkJxG/TvUysNH5Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GNeWmTPs; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GNeWmTPs"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-553d771435fso410451e87.3;
        Tue, 24 Jun 2025 06:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773189; x=1751377989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LOH1XofXvP/3fMrR28Yvu3oSZ/7CVBEt7HLdvRWECt0=;
        b=GNeWmTPs7QNwOM6gYNE/oNO62jGrb7TVK892PAxnPhF/Kwk0pQut6qFo1LYOD4LLNB
         YPa6zVi8H28EPtAtHA568k5wl7nsW3JjbF9f5A2/ZobM1zpJJB+BrspzQDWTzarpcyJJ
         MEZmOMybJ0E0tv2D/0nEhZVm+qbowYd5UBQUkfjs6XZxbohgWWvwQBu5Wa0m2y25uCds
         L7N+DdAkrAWJAB5GzXsYKfTIeX92vYog1E6J6SOdPo1ZmjET7T/l2lrIOYFuXsatL41o
         By13u6PDdmYZONf6kPEBHnLRTzfjG0HiiCV3eYvJ0hJvHaMx3mVJANdg3d53bnVC9neq
         +YrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773189; x=1751377989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LOH1XofXvP/3fMrR28Yvu3oSZ/7CVBEt7HLdvRWECt0=;
        b=nln0v2ODNJBuKIGNuUjElAEsnKvjCd+8i+z/0BZtpQ23AzkcphE9sg1ejJsmvlfbxV
         8JJ2xqcsNodRiyik7U2ATdEVwbHpw9NBkxlhs0q6Hq/p6eZaGVyGiEbggfhVIq6ACoPm
         YT4W10MhTtUqhj5uvrpddi5g/r9BTmkcP5gA1hcL4aMqa2GhxXdnnV5fHQNgLx+eaStX
         +wnuPQOLnD5UUXA8uJcRp3Dy7xh47YBfBL0AQdv4E/oBKy3Q941W6YpAw4o83P/a4brb
         40NgwyYhGHCI7TVtB3RxwtcdyIuUZyhc3YiBlZn5R5iOFs9RrrZOXUkrPgOf3u9eRtPq
         ZngA==
X-Forwarded-Encrypted: i=1; AJvYcCU2b4onf2DkLFcc+TW8iJmQQwQLm9aWyhhEICDX7tMlP+rKWyuWSXf68zoAhJ5nLA/EgH4b95nPXCiO@vger.kernel.org, AJvYcCWYk3FpWHMJIUhumVwoAQXoz9mG1xaSaTUrtoBkG6E1ZkwJvHU/cunRt7IDnWK3vtN24dd6ydfdtJfujrqZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy3JKiAJkX4kgRh0fHnjrA/Qyqng/FWAwN31Q0B0RDxZWZ0ADz
	wjm7ohCqf1FwW/uYuRIa8C3UV0e4nlhp++3exVnjGVV7Y0f2vqKM279b
X-Gm-Gg: ASbGncsXUG6Z6jYm+NeXjZ8qgB8KN+V2srBoc0ThPhpeDjLK5dSBsDEz5OokX5D+N/1
	1+QuceLoOjb8Fr3PIIrNgLqi+O40uQ0IkZFpBWeG4dfzkjjxb6+uceX7tPJtcoVa/3+5FPXn+An
	EKLFQka70pLa2hLYrtJd0FicsvCbc51fg8I27n2VUBIa2amxy/AfRnkjQX5h/vomk1LvBqNZOHY
	wg6Oppx3CHEPBnMRwsN/MZfDP82+hRFa1UMCCd0H5xSEF1OVLncR31cIbnNye7o0JDfAu1HoZpx
	+nYNxzAdaNKa2pPMj16OOZ65X44anio7ojPexOCJACq1/x76lBev7GLPVEeZYIXDsttmM7kclra
	Ef2efYcJ1PBKcT7VDvCuII2GJU9AwW9+2k0q61AhebTRZ1dDbTZ4XHwoxOk2JnA==
X-Google-Smtp-Source: AGHT+IHTyCe/FN5IR8181aO2FrwcATp3fU0/WyX0ea0RPA+5nhuEUmv38QxaI8BQxCM5Yp3mS3ZujQ==
X-Received: by 2002:a05:6512:1104:b0:553:aa32:4106 with SMTP id 2adb3069b0e04-553e3bdb2f0mr4751311e87.23.1750773189026;
        Tue, 24 Jun 2025 06:53:09 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:08 -0700 (PDT)
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
Subject: [PATCH v12 04/22] crypto: amlogic - Add MMIO helpers
Date: Tue, 24 Jun 2025 16:51:56 +0300
Message-Id: <20250624135214.1355051-5-romanov.alexey2000@gmail.com>
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

Add MMIO access helpers: meson_dma_start() and meson_dma_ready().

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c |  2 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c   | 24 ++++++++++++++++-----
 drivers/crypto/amlogic/amlogic-gxl.h        |  2 ++
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 7eff3ae7356f..1fe916b0a138 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -225,7 +225,7 @@ static int meson_cipher(struct skcipher_request *areq)
 
 	reinit_completion(&mc->chanlist[flow].complete);
 	mc->chanlist[flow].status = 0;
-	writel(mc->chanlist[flow].t_phy | 2, mc->base + ((mc->pdata->descs_reg + flow) << 2));
+	meson_dma_start(mc, flow);
 	wait_for_completion_interruptible_timeout(&mc->chanlist[flow].complete,
 						  msecs_to_jiffies(500));
 	if (mc->chanlist[flow].status == 0) {
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 90b539401b71..e617dddf5e2b 100644
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
index e0bc5c39bf2c..0ccf6542995f 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -161,6 +161,8 @@ struct meson_alg_template {
 #endif
 };
 
+void meson_dma_start(struct meson_dev *mc, int flow);
+
 int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		     unsigned int keylen);
 int meson_cipher_init(struct crypto_tfm *tfm);
-- 
2.34.1

