Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721593;
	b=mLukoPEsyhLHKEHoBAOdSxF+IpEUj4hqVmOc7eyKzgMwHTGRXQblflfYkQjjUkOUCR3V
	 QivzgPF4B91miyVyRzKNNfaJEdbpzVTvsBaK2qN6XWT+g8ATCtuY2LaGkjTEEZwpxfnHs
	 SkoKm7gso9nAg1zwmrzBloDKTb7I5tmKvYwViN32avksLO22hXskkK0OJ1IZ+nukwmvh3
	 NZHPB+FQ6nifVHM6O+VnJ70539b8zoB/bYUFvFd2gIj405jyc30kwdB6/73UrlL944LCX
	 hawj+YK1rqgmqgEJ5VIIajKyRmlldaG2NExyUqJrVANMEbace54zNAIEHkjU2i0vHZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721593;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KMyqFUlA/AvT12hLb9IrqwnM+Bo9I2ifCE4zJcXn8o8=;
	b=x5RYZapaRTB+YMJKP3MfAobGphVhPn2nJZJ8bYa85TPMXeKFgYscDtlU5Wc4UVeTV6Kj
	 KjcTqHeVJjmNUAcqTN1rsY0b9O8bzo3ovmEd0saW+pdAh3EvbSSZnSLY/VC38PkTDyKBN
	 KC5xlpGCVNlUMP2qcbqVHZ53cuZsUFAbIG37dewDzUF7ZKQFmpySij1FBJ86okrQQ0NZA
	 US/PpqJZXu4szuaw6i0falqNwGhYh/Wv6C43AUbeHw1xJ20FutT/ffmB2PcylX7XYId+n
	 9xn4FXyYvFttofkVOA9Nk/YrEtV2NCYSwXkEwipArpeuhCJoXoEyhl/XutRaWQqIiHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XxDgi8QT;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71308606A32D
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71308606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XxDgi8QT
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so74410355e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721592; x=1796326392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KMyqFUlA/AvT12hLb9IrqwnM+Bo9I2ifCE4zJcXn8o8=;
        b=XxDgi8QT02dsNExn25lPHnbwnj7Qwk5uN+3TjT5DdBH4d47lL0PhgIeZxzMlS9HXay
         Hhy3K/8h0DFTghkVSBGsmdaqKr3tEiIeTSCjQQS0fyPmEIxad2xt688nEeJ8NvgFMDBB
         BtIdSY+dk9Fl7rUCxLcoZlh/Ke/J6IQuHLSzJIHTlMvkkSEdWy1ugpWimGxnwj+edOVR
         Omd6UkEBPMsqZkI87je6QezQA7cuL1W4rKOQ9YMo6etqdqZDJHSomsgkUJfJRctM52/A
         rKvXE8kTM2q/u7yG4yPXAJzF9Zvgd3TAjn3V+0ldWBwISEfRxgZM1Smdnkx06RfmZA2u
         I3dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721592; x=1796326392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KMyqFUlA/AvT12hLb9IrqwnM+Bo9I2ifCE4zJcXn8o8=;
        b=SdVZXdT0xbI64pqbXRd2EDmQy7FAIt2sPa4XUxoiP7OOv2RTej98CRIJvYUvyzvUPO
         PZQqISKHa5q7sA9lydO3L9WOku32aVMcmvsRuqty3gIXOMp4AKX45pXskWOGZgr5A5Wp
         /WUxYCpQ20EML9yGLxLECj0yjfVprDN255RBGP88WEh47V6UELwP/2PShub+rtk3FiOF
         Ogyv+Rvi1nKv2aYDpt5Eg3XPkVSLpWlkejUjwkPNhR2ZsIaDSADA7IVlHGqmG2MPWsjg
         uPhFxn5R+dtMSvkhDxZF8kN2aUcHIxKr9MkGzPsiy1x+YqKxndi4mL8yRnNwSTR9DemJ
         FahA==
X-Gm-Message-State: APuU4Z8TXJIXj4lvaT8ZZwqYg5CZBJJhGXcqkt9Rdwt1KBIUAcZhHJQ/
	AfxB0fEeNuegzXDKvNZ2HB7rPfPDdjCpt1fskjm++4HCX0C0uKKvezEM
X-Gm-Gg: AZFdTZc9GZTgwWwLBJiowZv73K5a84njFrRjuFWJBmVr0ZY2v3DP7NVV4LicrCOxGVP
	XzpbVHdkar2pxA5VqLYrwvMyqKNgachfQ/YzW4uaLCn40uaN0HxtAMl7ZY/ATt22JlruyX9+FNY
	7hOm7nNlAPFYUZgo93HlDsnUb60RhlvuGaEqOF+xVn71H2uZUxUgnJkXPyKyZPBcO/v2LF8vp9G
	UrpF3HWgNoAVIylNAtMK9zsWQfPzPkkq+d4jRrhRg6Qd3K6q6sz1L2XvKYl89MTpI6w+TqpQ3BZ
	uTJh+sK++x2peiYhrddaDkvtTxbBMXp5s3UWKkRtcRuc8C1Xt4ql7tIuZwdNwKPKNIGGk8K0CzD
	tg+FCEOj3wy34vVLsgOu/qtTlJ9Lf0mhid48f3yl3aRZVUKT7g1Td+1/vFX8AP7Lr73pnpbxfVp
	buXfiXPNZ5pafJYBtoO4SRz9IkepBP2kbh2vWhcM0e0jTTHjJeU3bhPGPWkOIedP3Ftj9m+E6oT
	+TDIE8SBIFyUW/Lmkd3gbKu9q3BMVWHRnzVC7JiFHyN1E9bGQH5Cr3v2lHPvMzDxFYFf02gaW7T
	Cs967J1roObHbptLRC6XYTKRgCoXSiSBIJTKEwYR50inbA==
X-Received: by 2002:a05:600c:4e16:b0:4bb:6f77:1e35 with SMTP id 5b1f17b1804b1-4bb88810991mr475888005e9.21.1795721591813;
        Thu, 26 Nov 2026 11:33:11 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:11 -0800 (PST)
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
Subject: [PATCH v13 08/25] crypto: amlogic - Drop status field from meson_flow
Date: Thu, 26 Nov 2026 20:32:24 +0100
Message-ID: <20261126193241.1471372-9-jnieto.alaber@gmail.com>
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

This field is used only to check for timeout. But there is more
convenient way to achive the same goal.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 13 +++++++++----
 drivers/crypto/amlogic/amlogic-gxl-core.c   |  1 -
 drivers/crypto/amlogic/amlogic-gxl.h        |  2 --
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index f6c13d8fcb47..cd94296e4d9a 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -228,13 +228,18 @@ static int meson_cipher(struct skcipher_request *areq)
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
index 58d56f352dd6..81d0e8731ab1 100644
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
index e14cd5021add..cf07c5fbc5bf 100644
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
2.47.3

