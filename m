Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721605;
	b=IFCQtL9OYpq+1Xp4ZTRGcgaDqtPRmfjMMVxTqmR18/bX7Ks4cUMyFHBhW2DjU2Gj5cFA
	 Bc/ap9wzGjVL3bzWka5bgZZEc0DyJHWUHppp5mmeENgdY+fx85/hkW9EiXozWqaHghvN9
	 7d+Ylh9elauL/DIpDLe2Ohu89DcVIjqdwk5i7kWAitOgR4FbhJQbF8Sz47GGfG/RWpmbO
	 dUjCon+6jxQyXcM0d6Nu9bEciiqlBNCR9Nd4LCZSdLEAYAJ4pmtFXbGh0VVSfUQIegCon
	 qB9j/dOkcXamF+i5avzKcxT9hMiQlt6T05j86tzXF6YwmlEjiPsz98iOGINb9T3tPZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721605;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MZ3xsoglCFbUSUZhb0QwwHkubepyifev4aez9qIahDI=;
	b=Nt9tL0QT0eMwWw2TojqeixN2kCXzZDJM7e8AI48R+xGs3qRFWqsrPRqbEu0JCrcHJjdO
	 DC7Gf0X8Ra3YIgxwQGWv7ip7HuSBi4ZPt/R1L9EmmXbZ85KSt+u8+/Dzvpet8i5jy5wCd
	 pYMHWJ/GBkKXrLVpSlGAWASaHmy3Y7cpivftWRro1I2EdCcbFgLFy52FNbvcMcFckRiBE
	 LSsohGweChhGMxNR50nX4Z0T9pCeLyEQPhxy3wz1ofv8zbFVw4n3icpGfBuUqeDDiUytu
	 LQi7LswxqeFbx+6rdDLzGYrHM6afqRgVNoRkoEoSuqxRmfYvoyHRf1e2PUZjY1MAP0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EhYPefAu;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86893606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86893606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EhYPefAu
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso52982835e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721604; x=1796326404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MZ3xsoglCFbUSUZhb0QwwHkubepyifev4aez9qIahDI=;
        b=EhYPefAusGPmoB/IQaaCviMmVmd3aEFWZHmY615tiNrhrj+js7SMBsIdObpnT1/Lc7
         XJmUicrtw8B1wiXaB1A64+/UVkzoq6zcEjX7NMKXmdrGOO+2AiAZA0BYwy9KZRJzLetJ
         skTrFXyy4Qbk7sHrN6OQuYqIjoAoebRhG0Ic7Gv8csbb/sFJF7t7gNm7HuCMexZneFya
         FDXNSo5JFWEknNeifM+MbmCfeXMlpObWPZ03OAmX+g6zsvv8ap72p4+KQjbdA1la2mxm
         NW1nDTpGJm9g4/x3kQGVb65bXdf1fZxCz67u9EOCiS+nrn/7jHOqAzUQQ7mCaorTmrQV
         KIGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721604; x=1796326404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MZ3xsoglCFbUSUZhb0QwwHkubepyifev4aez9qIahDI=;
        b=jjunxPwuVoWbhaYjlkNVjU/Bc6FkoYzX6DnfIUMKWaYcIEeF4GXWlcgiE9hHpc2T8A
         AvDwOQplLYBcdHzZBN1jmwzvsI/nLvRI8yfIvQjHI71oo31poiFu2FKQJ1ELUKHElTg2
         QWC+/ap8rOfgxBYg2GQ9ELRMswMH/UsLB8ibGnS6ZKA6rDYhl9hnH8J2qmnPv6s8vwiG
         pk1JNytyo9BO1zlkE+89yh0ZEE76tj1e0TDQiae3k/fcTmI1qS8SPb+QYn/ASwYPymix
         H1d+rU+Keq24F5greR81K2heCTupTbuWFjaWtOGbSbr4zDFxY+TlT0f2kjar6VrB4aWb
         iDwg==
X-Gm-Message-State: APuU4Z/qRRLVp60Ms3sdAyGF3on46lgCeOkhLdFyjQnxaJXZMmTt8M9x
	SO324/gf+MqXoCREUqss0660IqRZUruL9Yl1MUXuz8EYBovioy8yLIf/
X-Gm-Gg: AZFdTZc+jaEI/PxAyr4TGHkcKA5IG/mUi5u+4SWNJMVavDMyofpozA1Knj8TYpl+SLW
	zSwV1x6rR7q0xt8aleFHAzNGkCbV52P//mOjwQRZMtyxEo0LJzQydjRs0P6dWg4tVjhlammiH2h
	PGIYcc5RojF39OrF/w5D2R9y0iw6VFluwwoRMgnJ6CjKMb3fyP8QkKDuKSNR1bCXD5eym1atDuQ
	rAmS1GGsbfrlW4PjKAgSO51OjBMZRwwGUb2vHTXS6ztHtnyw4DChHRsfEFMUTXzxgcUi4KsG9cu
	JldQU1mEriEkf2CWndY4Dp2pVRfOD7R1bqa4OPl6p05g5YA4OHdVRDv00ZS8GeOeaxNnJGoT0yt
	3nriNlJ8nAjt66nZLh9lMqy7CT59D6a6LqhuLxbZklxz47MQW1dUjWTwmZgglwa0KI7xBrTkSjW
	5Wz67rQCTZxSh17wVm0cXNKRpj4gNdkQFuraUuWeuElj3lI2zV+c0Lk0i9zVrgFSYkLu22VOYfL
	nw1sWlLPOSp2s77rUohbZbNZb0sYs+kRWy94F9VH4bjuZJ9p5Hb1DBAuNqVySeyUZ4awlypK+E5
	cMNSjnrF+d++wRWnQ+cq+bLFJ7b5qkVDoEMkEKEeNoFdTg==
X-Received: by 2002:a05:600c:a0d:b0:4a1:825a:56fd with SMTP id 5b1f17b1804b1-4bb88826c1fmr424253185e9.32.1795721604012;
        Thu, 26 Nov 2026 11:33:24 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:23 -0800 (PST)
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
Subject: [PATCH v13 16/25] crypto: amlogic - Add support for AXG-series
Date: Thu, 26 Nov 2026 20:32:32 +0100
Message-ID: <20261126193241.1471372-17-jnieto.alaber@gmail.com>
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

Tested via tcrypt module and with custom tests.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 0fb0da20e06b..08d89db14788 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -290,6 +290,14 @@ static const struct meson_pdata meson_g12a_pdata = {
 	.support_192bit_key = false,
 };
 
+static const struct meson_pdata meson_axg_pdata = {
+	.descs_reg = 0x0,
+	.status_reg = 0x8,
+	.setup_desc_cnt = 3,
+	.hasher_supported = true,
+	.support_192bit_key = true,
+};
+
 static const struct of_device_id meson_crypto_of_match_table[] = {
 	{
 		.compatible = "amlogic,gxl-crypto",
@@ -299,6 +307,10 @@ static const struct of_device_id meson_crypto_of_match_table[] = {
 		.compatible = "amlogic,g12a-crypto",
 		.data = &meson_g12a_pdata,
 	},
+	{
+		.compatible = "amlogic,axg-crypto",
+		.data = &meson_axg_pdata,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, meson_crypto_of_match_table);
-- 
2.47.3

