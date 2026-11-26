Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721609;
	b=IBDDXg3Rig7pUB0eppzSBReoWGrFIM8WkhlBeIRfkIxb0miewvLMkf53qGwDNh5KqXfU
	 Uv4PAG0QsbSMXZzlhf3Dc+8B0H+DW/92cBQIUq2D/m9Vxm1UJD/1+3x4TifnS6Lad30sU
	 i1fJmXFH/3KmPk2cxWcusWbHNcVvbWoewlJh704viY7mFW6V0dDEXiQXwvCjotLICRRnC
	 7YCnOrzb0l73cR+MSnKABRh4aS0WDaSXtTZy/iKAAYkz63wHZOvABVAPzmeeGbyFLHKIR
	 iZizTYSUJ6WyblZZXDS6i0jNgeGUmRdwjZl9nEJdLHo7pIuqXfd1g5Gz+dJGg6ChnUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721609;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=JDAQR0t8kY5iGUVaxptzIa8OAS8vI1YyQp0Tt2BgYTk=;
	b=KNkAocSCXNF7h8zN2magUUT5dwOi8gcxZ0IYcFdTjUFn2qH+8q9yXP3O1+2z0jkpqtdm
	 KjEAf8ZnTe69GPN7M+Vs0MuO8rc25E5V9GT4ACLWq2lIS5qa24NygoJlfr75ntGHVUr8i
	 PyiDUBuBEoR2UUTJmvHdh/yHY6BooY/AZ3jtHRADqLesSQM+caWO6hbmDQiIXlkX+jfWy
	 ZUGiLhSkBZraycZSWox0SE8u35aeVP0FIiOKl/pWajVGHGXZYz52z9IjEk7VMTqcNFs25
	 0sog0a1vVopk60dWftRX7tp4sd/KfWK2YCaXsVeM4A86ySwxugwAM3SkDJC6RvIXWtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pQxv8Eco;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC9F606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1CC9F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pQxv8Eco
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a00so60044885e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721608; x=1796326408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JDAQR0t8kY5iGUVaxptzIa8OAS8vI1YyQp0Tt2BgYTk=;
        b=pQxv8EcoJPiNdYwehYifva6qGeGaUn+n5F7ATm32BB02o+TG7WkcdUTDLibFgKM024
         NFi84sunYevZSDRcCDFPOz/YH3RI0i6bHDnXfEnQWgwG0XjECwQwdXkQNre/atv3dQzS
         9YMdQbl2Rb8go/Lg4mMqkSDGYuCzdvgYO4C6nhBbQZKiKgc+d5d8o9H/hcyKBTBkJAi4
         jYygo4dsz9qZtRnSY/ok3c4kCU3TlHBlgprVn2qC6PWqt/sg52qi/dN8/90hULnCDYi9
         hweIwebq5pOtRyanTXJSdNcmNO7HyIbishKDjogMqIW7g3amMIpKAcWr3y68fKboQ4+K
         Foww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721608; x=1796326408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JDAQR0t8kY5iGUVaxptzIa8OAS8vI1YyQp0Tt2BgYTk=;
        b=m9Drwzf6oUSmP3vIMohgdAdDjWhzBWVGFFMTf+IeKiVT3owiHY4BvEGbkTQQu7M97l
         4X2eus+YR+K6imkbVQ07x/yAy5RpSt+kNKnT96dLHBMr8AqUVmdV6Y04ZrDNdps058f6
         DXUrfJWALqaI0Rs/HLO93+UPy29mTzef5Udz+HQCq+N6SXBKT6jSiIO9gCrwSppBao5H
         GjTm6DQC1aZgXLTp0ExJnJW4T0oYO8BYy4EhQFSj4buX6AOBYr8cB9rgSTlCob4bIi15
         Y0yRF4kQdFoAdEEzwgs0fJ+clzzi+cXWnjj9QpTrBToTlNqJbQTqQYTnzMZLjIbAqGRd
         nYog==
X-Gm-Message-State: APuU4Z9O0xO3UYkaycvHar23NAeudj2uBF5sp5NQYS36FTpyzeIywFLb
	v5G0VZ0U6B2f9Az2RKATe0DRa+3E8/U0tyrJRoeaoaIeQKUxLENBEf/s
X-Gm-Gg: AZFdTZc7EfHNOCiW0bYplIyVCJ1uun2e7RKfbtN/Orbg/5dkkTNCPcyhbAyc+pu/G/r
	rozqeouBDh0w32rO2T0eur+8OR018QUtHwC7fjpBeYG4CvuK8VR7Kvrx4X21+eiy4oPH2afmYb0
	qRTdc5xNyoXy7DnBGns4FGsR6i7x9JCMxwmCaMzuf2fwZ8LhzOB9b7uMu3pM7sqnE7DLvZxAjC7
	FRph7hIkBj4pZVaZ1qilLe9Q3HmtWsTkeT85mHrCFlcvOvfbzt92ql6b//tKAqS41CaseD/Lgar
	h39ciHQRMKATa/4qkEeDK53A6QRwjyKVvaDffcizTqtDqOxeEy5vYpGCKfT/cJYImIDJOH6RTeG
	ZAMi2dgI1pgv/KJ/Sv34BFOo3WWov5w0BLlboppn1lrdF4izB52ecLJqH6JSzNv1d/6UsuWhSpl
	f9HsyUz41Wn2DSX7anP+xHVcOMWP2aYdnqoTcbnXjkQetT4R9v73aEuo2aOBuoh/RhRPARNLO2a
	nTlN4CPf3v8WVXXIGv524ZdWqRWV9QxV3f93UrTeF8UKdKoNQ2/KWAWWt+IwLoPwcUVimZ6/r7w
	CqqTTEls8bOt75GYKAYDaRKYmh6+MJ7Hj96x/I76HghECA==
X-Received: by 2002:a05:600c:4f4e:b0:4bb:6c71:b268 with SMTP id 5b1f17b1804b1-4bb8882672fmr465544385e9.6.1795721607669;
        Thu, 26 Nov 2026 11:33:27 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:26 -0800 (PST)
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
Subject: [PATCH v13 17/25] crypto: amlogic - Add support for A1-series
Date: Thu, 26 Nov 2026 20:32:33 +0100
Message-ID: <20261126193241.1471372-18-jnieto.alaber@gmail.com>
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

This platform data also can be used for S4 as fallback.
Tested via tcrypt module and with custom tests.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 08d89db14788..3a6bac10bb04 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -298,6 +298,14 @@ static const struct meson_pdata meson_axg_pdata = {
 	.support_192bit_key = true,
 };
 
+static const struct meson_pdata meson_a1_pdata = {
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
@@ -311,6 +319,14 @@ static const struct of_device_id meson_crypto_of_match_table[] = {
 		.compatible = "amlogic,axg-crypto",
 		.data = &meson_axg_pdata,
 	},
+	{
+		.compatible = "amlogic,a1-crypto",
+		.data = &meson_a1_pdata,
+	},
+	{
+		.compatible = "amlogic,s4-crypto",
+		.data = &meson_a1_pdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
-- 
2.47.3

