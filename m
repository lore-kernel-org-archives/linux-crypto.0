Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BFC2D29AC;
	Tue, 24 Jun 2025 13:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773194; cv=none; b=DKPVD9CvWgb4GaP4szxKNwnoGIUiVigQRyfrm3oWZsrYccyIlvg1R4pDVrs027PoPAegq7CqA0klyY6b/wyyKbixnxrAAp7ICoNh2ezPf2aCtotMlaj63EbHbQOOQVjkZRNvV6OI26iasPxtrFnGIlNqm4IgbyDkGPMxSS4sMuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773194; c=relaxed/simple;
	bh=wAiu7Ep5WNnOFsxOMhXPGOgkSRT6mcbYnmGWGIM6TOY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sdue2Nor2V9J9NiK0SV791cInikss9pG8hIEyS0AgV4QafpzB3kM4JzEhzRmIvv3+olA7va+nbXtrrygcifPjyPH3vOmHJp+jEhGEtRg86MpNVLKLWSnWjwdcX7/i9EjHtF0orgWupP1r9XZTNuvotno0OafGoxsVF5pgEvgyl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GmhVqbog; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GmhVqbog"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-54b09cb06b0so5697446e87.1;
        Tue, 24 Jun 2025 06:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773190; x=1751377990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdsAREnVdCt9SeWtKGm+rHn88INXvbkZnfp0wLc869s=;
        b=GmhVqbogbIcNkvNqIS0m9SsclqQXoRvoZS+apvAU4PYsBIGzBNzi56YwuMV7JOME2B
         SRTYDqgqhjmG5RHW0CCOtbWagAHyude68lsIodLZH/gbVRCGkIidaXxNv2pEaAjmksG9
         XHTSt71nvjtz00ZExnIj52ofNp/T5aQKX4XjE8foj27P2GEHF+bd6VcXamgoUhTxXAOP
         BbErx5+fjZXXOeK9lqrvVbQ8jRDt+Lz0FJ4xxiWdeerNEfml4gUr2KxKd85ieyIA7tx0
         Cp/VNQxJcX/eiOiDhSEcGSKDxIooJIkl88Mt+XofUsZUekFJO5ItZ9v6KqcgneHanJRL
         Chcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773190; x=1751377990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vdsAREnVdCt9SeWtKGm+rHn88INXvbkZnfp0wLc869s=;
        b=R01omKLvGm5Ueo4SyW9WfE1OZ6txRmzYVMPBD7ixT+WEpcu8v1XUe9SNYprMkhA/w2
         hJwuteaLtT5L9kGUvMd2BhP6uJZ7Ds6yDeMNL6aHDlo90ri8H8FZNZBWUiwlLqKf/00g
         dU35Ps0PV98Veoo7BNP+PVjJR2bLlAI/q3RJvdFXSoLkaBOwFiegRfKOhXXhV2/MAv5a
         kXjJYFak4f4n4FJui639AMM0n6inL4J8w2KAy1d3ULdo3a+8fyA9Qn1SNvIV9PQNsqNW
         bIas1wBvYTzagA9h/D90roUWw3+qyBbz4H3XjXtrBp8P6/6EmG0AO24NMVIaMfLp59B/
         sm7A==
X-Forwarded-Encrypted: i=1; AJvYcCVkJIYFFPGa6ZtsLSHX4Z6Ugx/ax6X3xfYDIatVluoncRnceF7jlFzjxO14HEKnAj0/7IZp2E0GZgxcZ0Au@vger.kernel.org, AJvYcCWFGxJTOBh0nPJNHZgsA7dO8PNOFnvzMAU6FVpEWfkzfe/a55KjLSLjaII6naJ2OpF6WeXdDMNM4QxW@vger.kernel.org
X-Gm-Message-State: AOJu0YxefsMSrlE6K4pMx7mXdxFrM9t4OKizh56nFKhv/Ewft3Xe+NAD
	3RuCvKPGHPAHx9NPo3Q0sKnl7TkJH/3X0eQkRgLkqANjgnCvCiw4irZC
X-Gm-Gg: ASbGncu9mwxK62CJwxkpUmjtQTxGYOtGkgoMrZbwZk/ZIoLWTvy897LeITRIx29B3h/
	vtGRLqa7ci3zyRa/2O6kxh0fEBnK7oD+HauY2iRA8jxYxeLiLr9c2M6saUZdqt4Wd9A8xQb9Iyi
	BadHFpbTv3XQZJk71bUrjklHVc3FEjxxLTYb5c3U0H/co7BHo7QQ5uJtXtA5izJP+cw+HJ8pL4M
	VGGKj9xM67/oweyy+/fm5Em9TwhEeU0C2VRsmtzn+WAz11fEiATfo6OdorMul7hy73nqq1x2FCs
	yGsAyNyfMUz5cpwHYbTNGiHifEqC9P3keG3mchTrJTYD3BTltBjbYDKzkqQzWLVSsfjqgKsT0p9
	4wnMSlaRLhut4NERLhg3G/u3m6JNUnDq5PFPUeGY02GVL4rQA3+0y2zJmxadbwKGQ+xzOxqbU
X-Google-Smtp-Source: AGHT+IHRQ+es1ViPpy1TP/xCK8UXRNsKN+lvj7mDfW+b0g8VSAHmPjV3EZwtYNIFBaB5ZTamT7yIuw==
X-Received: by 2002:a05:6512:3055:b0:553:6526:82cd with SMTP id 2adb3069b0e04-553e3ba82ccmr4130662e87.13.1750773190332;
        Tue, 24 Jun 2025 06:53:10 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:09 -0700 (PDT)
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
Subject: [PATCH v12 05/22] crypto: amlogic - Move get_engine_number()
Date: Tue, 24 Jun 2025 16:51:57 +0300
Message-Id: <20250624135214.1355051-6-romanov.alexey2000@gmail.com>
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

Move get_engine_number() function from cipher.c to core.c

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 9 ++-------
 drivers/crypto/amlogic/amlogic-gxl-core.c   | 5 +++++
 drivers/crypto/amlogic/amlogic-gxl.h        | 2 ++
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 1fe916b0a138..18e9e2d39b1f 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -17,11 +17,6 @@
 #include <crypto/internal/skcipher.h>
 #include "amlogic-gxl.h"
 
-static int get_engine_number(struct meson_dev *mc)
-{
-	return atomic_inc_return(&mc->flow) % mc->flow_cnt;
-}
-
 static bool meson_cipher_need_fallback(struct skcipher_request *areq)
 {
 	struct scatterlist *src_sg = areq->src;
@@ -282,7 +277,7 @@ int meson_skdecrypt(struct skcipher_request *areq)
 	rctx->op_dir = MESON_DECRYPT;
 	if (meson_cipher_need_fallback(areq))
 		return meson_cipher_do_fallback(areq);
-	e = get_engine_number(op->mc);
+	e = meson_get_engine_number(op->mc);
 	engine = op->mc->chanlist[e].engine;
 	rctx->flow = e;
 
@@ -300,7 +295,7 @@ int meson_skencrypt(struct skcipher_request *areq)
 	rctx->op_dir = MESON_ENCRYPT;
 	if (meson_cipher_need_fallback(areq))
 		return meson_cipher_do_fallback(areq);
-	e = get_engine_number(op->mc);
+	e = meson_get_engine_number(op->mc);
 	engine = op->mc->chanlist[e].engine;
 	rctx->flow = e;
 
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index e617dddf5e2b..44e71e917e5e 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -22,6 +22,11 @@
 
 #include "amlogic-gxl.h"
 
+int meson_get_engine_number(struct meson_dev *mc)
+{
+	return atomic_inc_return(&mc->flow) % mc->flow_cnt;
+}
+
 void meson_dma_start(struct meson_dev *mc, int flow)
 {
 	u32 offset = (mc->pdata->descs_reg + flow) << 2;
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index 0ccf6542995f..cb70277c3a31 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -161,6 +161,8 @@ struct meson_alg_template {
 #endif
 };
 
+int meson_get_engine_number(struct meson_dev *mc);
+
 void meson_dma_start(struct meson_dev *mc, int flow);
 
 int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
-- 
2.34.1

