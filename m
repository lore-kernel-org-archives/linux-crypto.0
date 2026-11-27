Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780904;
	b=IexuuJFtJhiE3Kj2xyqAFkQyM/lYYx4nK1SQiPH53Kij0YESGB1k9Iwt6gY1yjUklTrm
	 tZjR+dJXGYoKm4YSBD327rBB+RPr0GqfKA0WlZrPHMSdAPzd9OH7Bu3m4YAE6SNqxX2ku
	 Xk6Nu+qA7c49vOhLDI/CGLHPSZpPAtGE9KnPZVOsCwgGCtF9nwEAxLa8m9Fsavej7qGQE
	 skXRxdYo/hd4mPStYpVcNnTCqDiK2sa9nFlYD64Im+yPcTyFF2cKMBp+P2nb71viVk85N
	 vFNLMVRE2gmH/xb1hnWkyiGIbScO356K9Ys3DXDLv2/HMxEEjcvKJQwmhYzGNM5cfNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780904;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CkraiMujrKuYrzSwo1OuAMt+g+COsPr5VU70SHz5/kg=;
	b=DhJIa/OzZHXiyLrx2sKNmACvjY/Xmu4FKyisw/ZC5ll6TLSiLvEEov3NBhcBc3PIxJn1
	 STy3AVSSg5SwygWmG4JcDpnTDlHcYHiOmwVt1rg4bUm01cNgUtn/C61kbVMK4xu8r7rub
	 hJuT2UumUfT36VJtu74hp3FduYk/XH+47WQdLv+8moIFzwEsNIlnsfBRbfj55DYQf17Px
	 RAEBc9aDqRBSzLtbcNkKKk5U19KZarVlQD0o7K1wjPZCN9qcgWVh05QDanDdwq1RHQtyX
	 VB+PanEr3nfwqPcYRveo5lAvA/4emi3KkaJO+/Xu5QIVEP4NBSHAPNIBgd/qXDQXPbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GQNHAXqT;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED38606A324
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CED38606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GQNHAXqT
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb85e07aadso98373125e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780902; x=1796385702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CkraiMujrKuYrzSwo1OuAMt+g+COsPr5VU70SHz5/kg=;
        b=GQNHAXqTzQTV19CnY39mKVY/F+gY0PU8KexYHBp3hLDSHlitu4pBS+ScoYKdtU4EpE
         6RigTMNam4o352wvNVkuIsrLoVquDM7bJH+O2meUEqip2m27ww2XirNG4+TTc+QZgUpd
         Bfyedf/ntldTJ3yfl7xip9XQsZ5YEo04WlMse8/pXVKG7rN3IK+roMkucxJBt1q9g2Bc
         6HYfl3EtAMu5Z3B8kYIaLY+wal7ShBsng/giO0C/lYkWdo+cCRcZtU2WphQUHdx+WRgS
         0aazhhNKvOGiPIbYYlvX49WiId9Ry/z1/SM4ZmHIsFXL2Fc7c96GQMdp4sO2u/jqKEZt
         JOVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780902; x=1796385702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CkraiMujrKuYrzSwo1OuAMt+g+COsPr5VU70SHz5/kg=;
        b=eoeSRUVftktVxAnlz+/GbN3xehngyoBqxiDMIZQK7LOkKC4YiCHYxRu8ymqIUalMb7
         uj1GRYcBa/UuBAXX/oUAqBFJMjPdRORt22tKEr6iSTPlLlVVt8nIQXhjOCd476I25z+c
         d0PiYTOwVwhAE0/aoUWW2Exa6LIbSm2KUdBNG3cSTc2kF2iXl48G/GlvnpK5TlropiRr
         L8fBYo226w4GB58cK40UeoMXbgLZol9YEA+PS/X4qHb+fYbqmmp4mu80wjW7U4Ez1CTj
         ChF295Z2lV6GvxMSiPangpo2isONYVxVtYxvnbKr4SX1/3DLOD8wWvZbUsAwNSIG/9/K
         UL1Q==
X-Gm-Message-State: APuU4Z936DSfkgEJaLyB+RBOElmjSLy9id+3F+U9mLAroVV33rlf9aSa
	R5KKVi2sH9FRIKP7lbpVNCZwK9k1WFLE9Wy9+EliUE3iqihHBR8fMOuH
X-Gm-Gg: AZFdTZfLVhsx1bkYmDtq0Qr/lm12faq0yJcrMp05cZmLr/Slja9V7PWH9k7evBqFU4l
	vAkkk0kSaQLm2SCZrsIF8Ey2i3wdO+d4PESkkoq31+tgNZXhru/JhmBcDDE+Wnrw7JX+LKZvkjx
	WrZqOtNt5IETqZkUhndrRRXue7MGvk/Hx9HaBxEAjWgDRFEozyspUk74qNK7EAbogTaVoYEZwwK
	E9DB+LqtzanNkmNdPLzi+S1O3ineXVz+gVq5DGi+fgbfd9WaQtxIjrfU+/7K9OadBNd1aw9YJxi
	FVt68+i87/hRbNSFxO3A8IAUgtGqAP/vYdqZwAPGHW+PjIIU52b2obDy7XixIGn8tNDeJQt9RJ/
	vYAmAr/zksZ+2LzvqYPoqztZwMO0zXg9AkfcicjXcmTLC2SZ3YAvlhQNQ7F6vU4ScRTnUzWkU6y
	6jJi1qmJse0Id88DXtfAZ7snbSm66xjeyqyx7RlA++qBMRNJltPoVUvE3ghXV5ZXxTqGO8lOV9+
	PntlDs0k4DjTEwuWipC5KyxdAgt55IXq4c6XMise56lu9sv5YhlWIq7aza76qs5UoMeSiUtqq7w
	nMo9lzjQH+dgF7aFv/vaX9oF2r1K1gy0gdXoi9RYk8GD4EJT
X-Received: by 2002:a05:600c:a4b:b0:4a1:dade:f049 with SMTP id 5b1f17b1804b1-4bb88806292mr505131085e9.15.1795780900684;
        Fri, 27 Nov 2026 04:01:40 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:40 -0800 (PST)
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
Subject: [PATCH v14 15/30] crypto: amlogic - Add support for G12-series
Date: Fri, 27 Nov 2026 13:00:48 +0100
Message-ID: <20261127120103.1532882-16-jnieto.alaber@gmail.com>
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

Tested via tcrypt module and with custom tests.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index f530e238812e..0fb0da20e06b 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -282,11 +282,23 @@ static const struct meson_pdata meson_gxl_pdata = {
 	.support_192bit_key = true,
 };
 
+static const struct meson_pdata meson_g12a_pdata = {
+	.descs_reg = 0x0,
+	.status_reg = 0x8,
+	.setup_desc_cnt = 1,
+	.hasher_supported = true,
+	.support_192bit_key = false,
+};
+
 static const struct of_device_id meson_crypto_of_match_table[] = {
 	{
 		.compatible = "amlogic,gxl-crypto",
 		.data = &meson_gxl_pdata,
 	},
+	{
+		.compatible = "amlogic,g12a-crypto",
+		.data = &meson_g12a_pdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
-- 
2.47.3

