Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7312D4B59;
	Tue, 24 Jun 2025 13:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773204; cv=none; b=sTgDbXXVYTaZOJuQzw71YTHslLLbB0aQ5rMe65VltB4tvmW3dZnHoL39scweFBskIfTo0Nxl2iOyQL5ODuBm5iIathUETiawy9JwoahCE96WWFVa+UZTE8QXo8FhEc75oiXSmBC30YCKnuIZRNI2kudiL4GUUrlzqBZdUGp6nMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773204; c=relaxed/simple;
	bh=enK0PIxbFqpjFBzDv39VclcyFKGwzSsKko/Tb3D2PFs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=diC2A+j0NWj4GrZ7yhNrP4Ymm/p7W1tiuojDVoY/NYcZ95OtwK2LKRWYOD8+7lP4RjzxrN/KF5MR/g5qN4qx7VXRIew5pSnXKhu5+r2zZOy87diBTCuBZnbAZw/q8DA0+80RLFT2GA79gWZ/Tkilagr4Ex5xYkkQ/4fJX5QmogQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PX6OWzQ9; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PX6OWzQ9"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-551efd86048so466263e87.3;
        Tue, 24 Jun 2025 06:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773201; x=1751378001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TwUHxKJnp5cLgpgYva+rlNxvXdISl3ekGoJdTDdzRBo=;
        b=PX6OWzQ94YYMz0SGvh87EZ4xNIyhYJlhasQCOU76yKL1j4TMna9Mzm96zIxeCMlOL4
         FKOkzZjyaE9UwXqLT2r3vTHwoy5ceuCql60XexDW3fDCSVec6jPUt7O70DWQoB5l/i99
         dh38m0lJRAGd1RONaqJvgG+8E1wjE/t3UnQ7zFS2Teu/XtIur/2CyrXvwxLSKggtuQYe
         of2fdDS7kf25/isMKg6AsPSnIn0yE78vAJKvYgRqA9uRzL32IaIm7+nwDV3/ZEvSmy+y
         8BkGE37rHySsEE8ToDh+V1HLqZROsa1Xq5v8FXf6EKltqCTvlpxg4wJch1tbTtlrOJpq
         L4Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773201; x=1751378001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TwUHxKJnp5cLgpgYva+rlNxvXdISl3ekGoJdTDdzRBo=;
        b=B/uh0c0oZSNlG8+byk/UuVHKo1CVht/QlbjTJxWHRP3Dhlgay0aGlbswuHe9NiFzbA
         IdNTI2XbNccjbhysreq0hq9dtfuvhAQTnezsb1wxZt/nIog1BGxPKlUC2/wOMu/+ilT4
         wlpx27P5bSEXQRNVGVWH4pj6dKbnhJTgh0FDqzHkb6Xw4dOnJ9r3mVM0OajUciFgNJiT
         56x1AgPOv/Gm0B9NoabMJBGH5w8U6CANSpgBOhkgoTXq/rgkjvRrBru5l1ZffUNdX0u3
         Wv/U0s8XTdbidNUYXx99iElGKrvnCYJktH+CvNl1l1kP+3IYLhJf9o4YCPVHB0jMXalh
         icPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTt7LWypJvOY0oduRdNDhPARdYswx3VRPGqgMMd8pfK9o4nV9Fpb0I6jFOrb1UIORWBXq2rccVDvjWRyi2@vger.kernel.org, AJvYcCVKh0DWx98eGDkN5kMF2aQ/AjnJNkWxiSzAdaZOIVLhyMcfF9srFXj6TKIZPzgG3aR+H2WXnMKl+kYG@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw8TD1Pk3FvR6/ppiRDwMrdtLdOfbc+3YFPYJnNbDF9xtXYmCJ
	vIrnHwGG9QcYDWkp6h8YYMDpC4LzFWc95uVKUG79reHfkfFIcN1cZg2S
X-Gm-Gg: ASbGnctaUCJ9GdSTDch+4wA0Fm3zJmnbD39YJbdECNYZ5oyLum7DFITA4pUbrOiX9DD
	BIgYxME4XeolDq6+7xNV5HgkxK11MpDibRXKT9ayOf7TvnTlnYB1kGyU04C070lj1ENo4YOwn2V
	wbK3AYmmBCjvbFyStKZng5wXzSPRH8+VDMS1L1RPc8Q2gFK2hvtppZ0dT1aL8pHQtRygRvKcy8q
	CwGpz1oOBkS/OcVpryevflJqph7VTPeFo7czgDj8mJxfHe8SG5gZWhtZmzTTljrVm8MO40OhyR+
	f4X9bYDQUPxXkehi9X4Lbut77L0OJc9riL/zmwLGO9S//7U2KVSMSw+HeQ3cCDncR9Ld4YVbAsI
	41khJl0ymlVLtPAE765ad6pE1+uAeY5y5sUe3IdZo1EcaSCVzQqEGqA46DNPwCg==
X-Google-Smtp-Source: AGHT+IFegUQyNWlfR73jyIeNSbKb+PL10eoaOMjltkUPqUsmae8e48puBzwbK+rUaYB2E2lscqlytg==
X-Received: by 2002:a05:6512:3d04:b0:553:28a6:4390 with SMTP id 2adb3069b0e04-553e3d0ce96mr4929973e87.47.1750773201274;
        Tue, 24 Jun 2025 06:53:21 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:20 -0700 (PDT)
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
Subject: [PATCH v12 12/22] crypto: amlogic - Use fallback for 192-bit keys
Date: Tue, 24 Jun 2025 16:52:04 +0300
Message-Id: <20250624135214.1355051-13-romanov.alexey2000@gmail.com>
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

Unforunately, not all Amlogic SoC's have a 192-bit key
support for AES algo. In this case, use fallback.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 7 +++++++
 drivers/crypto/amlogic/amlogic-gxl-core.c   | 1 +
 drivers/crypto/amlogic/amlogic-gxl.h        | 2 ++
 3 files changed, 10 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index df42940f1112..6070ee6b488e 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -41,6 +41,13 @@ static bool meson_cipher_need_fallback_sg(struct skcipher_request *areq,
 
 static bool meson_cipher_need_fallback(struct skcipher_request *areq)
 {
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
+	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx_dma(tfm);
+	struct meson_dev *mc = op->mc;
+
+	if (op->keymode == DESC_MODE_AES_192 && !mc->pdata->support_192bit_key)
+		return true;
+
 	if (areq->cryptlen == 0)
 		return true;
 
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 706db22b9f65..0f4b3db85031 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -279,6 +279,7 @@ static const struct meson_pdata meson_gxl_pdata = {
 	.status_reg = 0x4,
 	.setup_desc_cnt = 3,
 	.hasher_supported = false,
+	.support_192bit_key = true,
 };
 
 static const struct of_device_id meson_crypto_of_match_table[] = {
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index c4f65b541f83..1a15e6c0bf50 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -94,12 +94,14 @@ struct meson_flow {
  * @reg_status:	offset to status register
  * @setup_desc_cnt:	number of setup descriptor to configure.
  * @hasher_supported:	indecates whether hasher is supported.
+ * @support_192bit_key:	indicates whether platform support AES 192-bit key
  */
 struct meson_pdata {
 	u32 descs_reg;
 	u32 status_reg;
 	u32 setup_desc_cnt;
 	bool hasher_supported;
+	bool support_192bit_key;
 };
 
 /*
-- 
2.34.1

