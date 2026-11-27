Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780887;
	b=TxwAWMGg9Lv6EviwrVr75avEXw+nVnsNtbQMBQ1Q/t5GP8zEyJSLUDgmeUW0Z6CVigd2
	 O5dIz7ymaHl4Gnnz2mMFbPI9EygA37pi5rOesXMJNCC3pfyDOtaGWjofL1NY9lHnISkbq
	 4wfHRALDeR49nsuBhUdN0g7BJ6Z71SlFdL1Xj+nTWQJBcAB7MKD16vdpX4yLdbUrIa7K4
	 zoS/qHDUK2SUnf46esO1qp3EUhmGbfDuou/aeXr/mTbnqn7XY0XbxCwMxnMsemSp+rSue
	 eWnC0VieT/VwfraQEHwTGIZQZkrNFuqEayI0w7L1u0tHPRlWlyX/5LEa7mRcDnb+ZtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780887;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KMyqFUlA/AvT12hLb9IrqwnM+Bo9I2ifCE4zJcXn8o8=;
	b=xFlGi7TChWwPfl90pZDJkAHWFICI5Q2ny+Q7whs9b0sypEN+pefIJhwOairT3WDZd7SC
	 I5hnXv3n6hayqLwtzP7s6lPeTGi0MY09D77oQxBseDq3KBaOJqq7l/FFH0O2jhpjZZMJQ
	 9h9bovZ6TzozpKv1O7OldSZnp0Fh/a4W1ytNRAbD7PAQXW8z4chRxs1gjmd7yE5p76nkn
	 zZ/y23fjTy+E2MoCfeVEX/HF3wKj5b2dV7uYTxyN2jYhJsWzZZFuLdAYOMaWH3Lgj7hHB
	 gkK3tZfxT0ZhOL0gTnA/xsF1srI6ehNUSVTQlEt5rdUd3F4xiAtnzQG/kuZSbJ+G49g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hmvBd2rE;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F58606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13F58606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hmvBd2rE
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb702a7548so73187815e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780885; x=1796385685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KMyqFUlA/AvT12hLb9IrqwnM+Bo9I2ifCE4zJcXn8o8=;
        b=hmvBd2rEJrxmd9LIBu1zPmhNdiS8GN7FqWnzJNp9wnqsDtykYcfNbqPjWpU7gJHnhm
         0lowOxWSUMLn7zEIsGGTD+bhXoVCHHNS4F6sC1God8Q4wPOwkuewWJTRHlBJWfnRUOQM
         6ndyzeYX2uPWQoAVZttxaF+Gb6nilx7mqmabq+US2xooQM8rWh7ZQb+De6vvoGMsf+z7
         DHCsyNrV0n4kquGnBoxTZskNsaMr30Om3l+wapAP9L9VjkV5qtW3rr+HrL8H4tX+i6es
         i6sSHGlg0+HouA/VV1qcWRKNPbDntvDLHWaBGPGnMHxfAkSig/2DBb0WNBEm50d/OADc
         A9bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780885; x=1796385685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KMyqFUlA/AvT12hLb9IrqwnM+Bo9I2ifCE4zJcXn8o8=;
        b=gyDT8sgWdLZGfqWTMSnueomH/HoY4OpIF3PfcOOh4MMI7j+O6ByvMEh/hhqGJxx1LK
         RN5fT0PNoe7BTsRXSwTrgCuKdjDZYGtZiPWnvmpKLEcdTWJTMgFvpFnK/5XPLU/9PUJs
         WiLlm0zxWE4dOpbtvvLLH0fpJ/KyfvMVaHHanBMdifylWkXIG52naXcLcSnn+gw5OqMK
         AiX6W4ts4vj4DZ+Nxx6WsYX0/lAU78+WNqogBPzM3J/E8B2vTaH5O9cGK4uc1TBJsFSX
         395yFCfMKMp6b8dQQerWZw4cdUnjo5yEMhp/cSQCui+2cwxSPkacCQyet3D622XiMlpT
         feOA==
X-Gm-Message-State: APuU4Z/0+z29p8KmXU9/8nrcnGUoVR50q/QPU9M3zJVWjHLsgTFXpwO9
	G/FgOVyeiz2jS3TIiP+JAQayBLHP834sC9qS9Hy47VsejkqgP8Livu/x
X-Gm-Gg: AZFdTZfTNk3/jjjOSCMQQG8dlZwko3ZUrf6UC9EGGAxS0Mn8dYM91rhTUyHOB7/nwsM
	d/5PRUyhyfIuk9g/Ry+rTMXHCn7z59sZz59AQNaQapdaNv757Q/gIrg9LS+1zaTvQH/4saVaseE
	WIjycvVKLUzm30wA9E6dzdPwmWEwkl52QI/Uz4wJChM9q26n9U+0LOdiZCgm/N7by9r8/UuId88
	T1MkN8+yDhS7WfR7/O1E+M48SSl2KgjQVTLKPl5PUsfeeHnk70WVQVh+MNyxhoZ7c1gBQyrGXCK
	gXG/LXP2XXkIeg0El5EjkeqUr6ReIRYUJq4y1oqGemjD8YC5qaccoq18E9Bgpo+SHnM2FNrg9o+
	aWTa38zFmq3YWwcFZsYZ2SQVQFqFhOp2wsy5sHqr06ngB+A620JTYK07me+qZm1n6HD5C3TpHc3
	YzSVM0tn347EEd4+Vh8vxwlekdtlCeCmo7RUUPbf8u+ZJG22bXvKqRQ6Fwv8GkwxQ+Zl9MqY54V
	MGhK+NHZZGJ3Jrt/LU90YKhNKB4xyf0790V7djs69lgd9qiTHCxG/kR5/ehFHHFIx3u+Y8lZnb3
	TcWNKw/3KaWbykjqu4KbI38Z2TSb+kI6VYk8rcVxh1+p4pNh5zhl1HjLAuGLFrXCcaQ3
X-Received: by 2002:a05:600c:1548:b0:4bb:7347:d5df with SMTP id 5b1f17b1804b1-4bb88814405mr505901515e9.13.1795780885387;
        Fri, 27 Nov 2026 04:01:25 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:23 -0800 (PST)
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
Subject: [PATCH v14 08/30] crypto: amlogic - Drop status field from meson_flow
Date: Fri, 27 Nov 2026 13:00:41 +0100
Message-ID: <20261127120103.1532882-9-jnieto.alaber@gmail.com>
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

