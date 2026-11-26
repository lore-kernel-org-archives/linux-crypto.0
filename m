Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721592;
	b=QWoJ8XlZ3IfOd3kamiU3nG8NM4sMKALbykCxbTCBqOoJEUhYU7fSV9oBc1bINDhjLTu+
	 9mqv21Fpqot7y8ZIyjsAt2NY9Pt/Yx0dCyvjdXm9bPzvVv3kMVfhCBA69S5MwK+2y+3U1
	 Z8udXjxU3kOtRGfSR4F+Qo6aAugLHiyizcn1XLJHGvKj9uB1bNITfkHGmxyYJNrPmPDpO
	 qIkRmpLyTVLsEASdPx3bquLELxnQEIhl0L7JFQfBX+AKwyt3xT1VDMzXqejhWSKVutVOH
	 EstpdLpNXOFjxIqVSaf0kzrK2V2hb7tET67tbf2OrgurW39VMaZiDTy+R9MFKDmKSFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721592;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GbFTXgWz4qbUUEtYKh+mkh290tQbhLkX/pW25drgstk=;
	b=VSXdt5iL7BdJEkB5w3mfbBfh/IxmtVKu1Np6ypBS8FAkjW06kJ9oxHsdkuteFSn5gZXV
	 Nly+ro+U14Clv5DxdZah7jl7K4EFwyMdvFYyfiszVX0nrHGkIqNrR9XTG8lD6NLcrOf1N
	 8wPjOH1AzD+55ol/a8jLVs9bFgVtQYxVe6ZfZban65nfpU8b0IW6Z/SglmGP2vV7DDo3J
	 2coSRhj9KMhksFhn7xUcjAh+fjYRReazeG6s+3snCdiy5z3wHomBTSkBE1KZK0ks6mE2k
	 b0I9H/q+6zMCfppgE44MzHlgbHsUx/OzQGLj8Iy5zC1M+Naj2kghlWncxvXhelpjRxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=H5yR1Spc;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9C1606A31E
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E9C1606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=H5yR1Spc
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4ad6219f7d8so6657309f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721590; x=1796326390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GbFTXgWz4qbUUEtYKh+mkh290tQbhLkX/pW25drgstk=;
        b=H5yR1SpcIfm/+Um92xmFVgeqN8Xd5UvNySTN7DyQigMR8YxRLYBUlMWR8c55p7Qdn/
         m6/8lArbbRqsxiM0TdoAS5NBRGXA9TNjx7+CJ524qnlUie49nBkq/1QejsELWajXi6E/
         Qt4QeqNzifk9/qY8RaE7LQESp5039moQEUPP5I4ljbVnqpd1vBLCushS66t/EsQ1L4oY
         K3URC7zJ8BMPthv5coAMI+8qUktqRG8UnK2Y4cKoAVEk14m4Or2xCBl++yOekbiqgjFJ
         /8lOO4Ez5+7X/G7PD9mdXDnCoYPex/mqvTt3Rf/TWlXaifII0Jv6ayy5+0cTLsQaM9ZB
         Jlbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721590; x=1796326390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GbFTXgWz4qbUUEtYKh+mkh290tQbhLkX/pW25drgstk=;
        b=UFKn8NY/5aP7J2zzllNis2ILtQu/G/jPaVkzWnXpWo+2UqSZxEr3ihQmmykwGlVXOu
         cK8Nz8G5Llu7k9XAIlp2sq4aiQfB+1IhXOk28ph4nqBPdE00BwzmQ9DXrZmBun/GWl26
         H1a48wvmWm/Kdslpp4YMMPh/pWDSCpS/sSVDLWc0dZeg5ftJPvk3FtIcgtT5UdmJSUDA
         74fwQrdVYcP7qECv2GlahB4pJQEO3bakDAp6Bl3c4XXfPmpMllebJe9qAnfCwUjtKo5N
         OGiOuZEvX74FC5OKUeLZzL3HD348atj2KY2MbTHh1Kk0Q4m5nqNXp9b2BQZ5GDkBbUJh
         SBTw==
X-Gm-Message-State: APuU4Z8OYE7mu8+9yJCwB30ZThg04ne5xTWlmiZ2XCB2iCQ/p849Aat0
	HEP0Hj1l0S+7ms4KPMVulJvFIaPtInfZ1cmsqrdJv5b9yIARdtEQ1/Nz
X-Gm-Gg: AZFdTZdX1Dl5d7B2itINu+OXADVjT5jua9bxL5GtUCCYbajLZz/aYPeeH3+y72tf0TI
	e90rhlFixWwEfqIyDLBBauX/L5gT3y5f14TRKHBRuLOFs/6ixYVuKlYJK4AohL6PN1eqxrBnQ2W
	a3ubJ06WpoufLygql7NhhStoKlGGcpogQ16/TKKb46I1pcy9gn/DGju1BNYQB4bxeUf/x1MwGwu
	zH4XmFKYFIwNOSiRyNLjv1En8fBQSWC9IbcBIONgU8YvbsuDxO4xrF7oX1/f7Xu6el/4rm8RKhz
	5ip+7fdC0PG4oblQz/vWCG6UNyyp9rDwgz+c5eHRcP0g1MhSn8aW6oMDCrc/6r2i+5rcGH0l3t7
	F9CvL7t4PiHbi9p71vWC3oYlomiEMmqxtG6nQpYZaLpT31tQxSnUUYRPyftwJOeygscORZfN7fD
	6KvAlXjJcwfi1wPiOYvp1NMyUHbr6ZlOPEJ0EhFlwRDyCVRegHGqOPJFuqlFwn2aRocrM7hGhmL
	izKXLEiqUnY5EG/rZ01kJJfjIJTDS6LHRZTI45DOhWGtTUDsHW0hauHBII4sTuQWtL4QVeFEygy
	SP6Ut9No9+CQ941FDXyRoPR+c78MF0oMMdzyEVR1PSEOrCsMe7tugysAuNJMQQntiI8=
X-Received: by 2002:a05:600c:3ba9:b0:4a2:1050:aff with SMTP id 5b1f17b1804b1-4bb8881c741mr514973795e9.6.1795721590419;
        Thu, 26 Nov 2026 11:33:10 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:09 -0800 (PST)
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
Subject: [PATCH v13 07/25] crypto: amlogic - Move get_engine_number()
Date: Thu, 26 Nov 2026 20:32:23 +0100
Message-ID: <20261126193241.1471372-8-jnieto.alaber@gmail.com>
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

Move get_engine_number() function from cipher.c to core.c

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 9 ++-------
 drivers/crypto/amlogic/amlogic-gxl-core.c   | 5 +++++
 drivers/crypto/amlogic/amlogic-gxl.h        | 2 ++
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 62aa82e1cb5d..f6c13d8fcb47 100644
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
@@ -297,7 +292,7 @@ int meson_skdecrypt(struct skcipher_request *areq)
 	rctx->op_dir = MESON_DECRYPT;
 	if (meson_cipher_need_fallback(areq))
 		return meson_cipher_do_fallback(areq);
-	e = get_engine_number(op->mc);
+	e = meson_get_engine_number(op->mc);
 	engine = op->mc->chanlist[e].engine;
 	rctx->flow = e;
 
@@ -315,7 +310,7 @@ int meson_skencrypt(struct skcipher_request *areq)
 	rctx->op_dir = MESON_ENCRYPT;
 	if (meson_cipher_need_fallback(areq))
 		return meson_cipher_do_fallback(areq);
-	e = get_engine_number(op->mc);
+	e = meson_get_engine_number(op->mc);
 	engine = op->mc->chanlist[e].engine;
 	rctx->flow = e;
 
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index b972df44e8b5..58d56f352dd6 100644
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
index 64f2f0e63f12..e14cd5021add 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -159,6 +159,8 @@ struct meson_alg_template {
 #endif
 };
 
+int meson_get_engine_number(struct meson_dev *mc);
+
 void meson_dma_start(struct meson_dev *mc, int flow);
 
 int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
-- 
2.47.3

