Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780885;
	b=m2vIiJRFSVr09xUxMpPad+l0+Cz+kU16gbQltdtxovAlwuYIMgCJL9eMVSn1B3erxcOW
	 BDcWOsy4TNebBr4+wNFuF67UwkGsPYjmX02idiehQjvJEUwoVrgRvjKKcOR2S2t4Z0NfI
	 96U3BFwBGvI+paNf4njTzLJGdXQor/mDfSClw6Hv5O2JUDrtXqE92A/8nW+QUcY2AbzD0
	 E4gd+I7/tU+UxrqSuiCa4J9OIlXOJ7muQ3Fv+LDD+4oIWJK4PrQliyKGBmDrW3kXyoYr0
	 1ALcNZ8J6mt2SmnYgYOwYjEPl1xVXHgpC1AZ9nFPgWvutcEGzpN0dZ7laG/eDL9Lg2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780885;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GbFTXgWz4qbUUEtYKh+mkh290tQbhLkX/pW25drgstk=;
	b=lsUwC3Q0SNWzf4jENw7kCHxkEsYnaBvppiauzFaVeNi6nHdXWt6TV/pMkKuhlGiCtOak
	 2dLCPE8vTICTHMBF4T0GryYKXhWQCtfPA6+3rE8uOXaLR246n9WpHj36kHh5b5DyW1OIp
	 XgdKMgwOttMybQSKMJyQikSxouGt23YWa1gOnr22BorkR2FztcsS/DjkPR7/R7iv8CkH5
	 VXLrpRJ60+tcPBlqdCHTXfHMGy65EcwGWKFh1ZfibbpjarcjxGvKQykTTN2cy9S+NcorK
	 eLFeCafmJdrseXpbmVuKOfKsqn7RbxsLvEFWHW88BBOk0915VH/NAPCP3rZUQV+GuFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QgW07CBs;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD304606A338
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD304606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QgW07CBs
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb6057b333so39040445e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780883; x=1796385683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GbFTXgWz4qbUUEtYKh+mkh290tQbhLkX/pW25drgstk=;
        b=QgW07CBsnJuCMS+Hnn/QCBspxzkSSt9WdyBVMSZFTsL0PEACgZGLurEAjZfSMcon/T
         EvkzjGgu3nHYJfeIVwxg6rDuFY3/Uoctju3Ht4XNoRovhkx94+AZryZf0pRaNwBpB+3F
         jg74NU4ZlJD8C3Aw1zMWGRDckzU4i+0uYFl57k4jsjfiRsr2NytafOy8Mwacuy0qjih0
         GUy9OVIsxCSMyNhRXph/BCASnCEDPYNxAjOWbofpvSgTEUJ89coqsneQkIxwaRu104OD
         //1UjQGrfZZ0H2HpWCekOsWZvmSAxiSwJ8hQ+x2Bpo9cGwTPTQ7t+ZkdQ5YeJAhwxi41
         l7Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780883; x=1796385683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GbFTXgWz4qbUUEtYKh+mkh290tQbhLkX/pW25drgstk=;
        b=2nDCDhm1Sf/CxgdwrNoCvgq8G3Q5z7xL7zv43D4rXzFgMykeSwfcNBDxD0gPcY81jl
         9cgs/vpIT6Z1bB5YlYf2AR8YVRZzbEdewb8JY5z1vAIhhmSJKCt/5/DhZdbdAPAMEqF4
         usva996V1eSl9msI6WELnUbWoxZliROks+eCzAvRO/6wWYW7gspahDBMlRSnDuj0JISJ
         A0i64ZnVkYbRfcXmAfuhnbVKwUhoAIKoA1OTz0yje82i240n4dL7HgAhV4KcoINI/X8G
         ZKnlU6nfa2tKZKy88RxULJGWqi9Kd3brGVM4aR10pXo/XiBz4dWu1vi4DWJ6u59rMBMf
         btZg==
X-Gm-Message-State: APuU4Z8AV950cACRZqYYeFTSieOD3LoVuPJtd8t1GIO1u63o/fNbTsvy
	Wix3qBy0IUOsSvSztFMlrwFbOCWJIklaAwJ+VzkFMo5HNc1B2D6bG4KO
X-Gm-Gg: AZFdTZdUQMzVdI78EZA85AXkL92QVS74vXaUmuS6agz3gIU6v/t8yuZsIVJIfzKweTE
	Kz+1KP9qwJMqmtgwPPPTCOcJaN1Xa7scPmJUF4++YKlCVTGd8MQ2gg6DnqiDBfLJYPg2GBfj89V
	dL8z16paAW2CLmjFZp+Jyo7AK9w41NBDEsKkicwezc49DpVHQqOYOaYowwFL7l/5CI33IMmZn6F
	ntD4JSXR99WUo4MqT+/WM/o4QWlb0qqtEmXjCPXZvEssnx2XPRb+FQoan2UftB/y844KUGxkmdk
	WUF2sbOq1Q3WU9etKAPYLnKomUAlRuOs4jlhdmG4o5BGxG1hKK2y7zZvz1IX7eJNoOzviT5+t2U
	FMghx5P/irx6ZbH0FF1UyikoQ/wl50x6ueZB0kEOTFZo1f03KmkGfWaPpYIRT1TQG2nQOq8kUoY
	5oK8qUB7CO8pTeDne6AdL5bmKhojGCEzJLVKY+g7hYmFWNsVIK30tf9btV5ULm2wmsiO2i7uTmm
	GfQMkeNnkQOFe5zHcG94fniMBEdKZbGjoKs3OfbOtKTXWi/VjgyVCsg9nxqrSK7+3BSa+aIxcfH
	AsM+sYqYIZkEMbUxu4r8YU9cdvQUCTuQEUKAvwPHHAbnwYo=
X-Received: by 2002:a05:600d:18:b0:4bb:9001:1aa with SMTP id 5b1f17b1804b1-4bb900102b8mr353961815e9.10.1795780882841;
        Fri, 27 Nov 2026 04:01:22 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:21 -0800 (PST)
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
Subject: [PATCH v14 07/30] crypto: amlogic - Move get_engine_number()
Date: Fri, 27 Nov 2026 13:00:40 +0100
Message-ID: <20261127120103.1532882-8-jnieto.alaber@gmail.com>
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

