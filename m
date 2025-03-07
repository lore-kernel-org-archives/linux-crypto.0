Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5360A28E8
	for <linux-crypto@vger.kernel.org>; Fri,  7 Mar 2025 08:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741335253; cv=none; b=UDDZZUoB59JEJ8Vb9UlfTX4XBpYEHgMWMvlZ5BVH9pD9TzQDOKjvqeZdMWReDoJKYDIRoiFnH+tM9KFHsOxd2VF+D8OKA0xZpm6UPZIIFGQBuxNUiR67lX0IcUYnc48gnuiYPhsH96I2JmPewgSjOKnxtCg0fvpg1E+hBwzzeUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741335253; c=relaxed/simple;
	bh=ifGvzz7OBeukTcY2WHZgJTC0sTUnzBW2FA4VRpqiGVM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ce+u6IMYNRr7b/2NKJH2Cor5Q5j207kkkmlNnH4gI6TmbW4qMhAAZvXAN0SBtNoAlsAqFJAGAm2q5+6eA3igAJrUC4p2vwOaRsze9J5DzkJlr/SShq8IopUNk017vaI7RyjymVVxDyh6cTsxX9eESU/Cy23YjYnoyLe0J9+aT6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KMBMPdqH; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KMBMPdqH"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-39130728338so37989f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 07 Mar 2025 00:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741335250; x=1741940050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dC1LPCsdF2Z42Jp+jxNOAqnbNIqpSsoAUsorj5VopVg=;
        b=KMBMPdqHIcvtrRYMqa1cuM5cYuFr4kR2eMIkNJiGRsCjrgmJirF/zIWLq3aHvzdqlY
         RZyeCv5Ki8zgKhMJ4mgIO9rrG8heCihpx6qyw7Ohu0kYS7xSg/MBycQ4V7jMUO+IiIMg
         KzIp+sgisv3yxD/v/UVEl4Ie5opmHkdAvTEARu/7dnIiQr+feSEzt59U9oAe9g7h8k2g
         mgFfgILr8JQnX0CVmBaZsmETUM2cEfLVBolRnW5k4h0Hvz2nB2MkIfrzdeZegyefahkS
         3LZ74EoL+FjvgL4gbAvfiuQVV2rIeh8JGVV6pUBfR+DW/uEZfC45uE9bmW6ftu6iFO+Z
         Rruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741335250; x=1741940050;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dC1LPCsdF2Z42Jp+jxNOAqnbNIqpSsoAUsorj5VopVg=;
        b=KSFJPpdUXnZL4paAuoX3xWBWcSvYXEt1vXCWJwa1LXe0jHcx2PgPovGY+27/73VtAH
         ruQxpX1KanfAciDZpBbYwgzdq9ZbeANrP89tqLratJVVkroEhQl3i2hH4klec7PNAFGV
         jKz6bTvx7oZ8zcD1geISEj+G77bvoxL7jlhxVfunJYdEFJCVgwYfHNFNSwEB4W8sEDTt
         LzO6nrGONv2964t8gsRKUDTUnTnZPESu+K/5MUPgus6G/JgnRj03wTKENFGQRcNy4n9Y
         y1Fbfz1IdQR3NPdTw7J63N/khqPDCOvJgVWGD6jVhYVIz8K0OYWUcREaA8Ex/xfBByXg
         RiHg==
X-Forwarded-Encrypted: i=1; AJvYcCV2O3+7jaZdsU7fFwf7ELzOXovDWehU88rwYF6fSi5NVY9E6yx1YD6Si16SD73bhB6vAewkKjwcv9cJFEM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhSE5lUYA8iI93Q6sPEUI0RjNlOiNFL4n3s1EYKTMGGNtNyeuO
	zjmJF/LejdN9p3FZM1PP65Yf8lzhBdJWZKNOgT/XVKZvJ3aUnZBoKrwU2pWO+tY=
X-Gm-Gg: ASbGncvaMknWgDM18syh3EjaEs6Y92RuDnT+F1QGw0KsMBS0zPivalIBotcT6DkY6wI
	H/QxXHFwm4R5RJi4rTO0UcyDcnkpQB7U3rJX+yFnXjCsg9rlVJB6ldCR7pGouL6bGoksTWz0ecs
	72wTqdkK9O0mASiSLPN/hl+xi4mCtVxR55W30cyN+5/g12FK6K4TFBSuXlvP2CSdogX2RsgFLDI
	3iYp1Wq8dsUof1JsWmT/LXvxynmupMVQUfCVeKtKIkIYkuM8injN7WaVmYkguMY+moVHHd92HSB
	7CKiGobVfK3wyjyXLHkHK2NEuux1Zs6o5iC1IhLUOThyn+I4z6Z9JYvCtVs=
X-Google-Smtp-Source: AGHT+IHUpH+Xyh16N+1wZEqp2m7qpL812EuSHBMLvRKqepcXSU9SdbYHDp2gAq5aCXZu0H8xpH08Dg==
X-Received: by 2002:a5d:6c62:0:b0:38d:be5e:b2a7 with SMTP id ffacd0b85a97d-391353f0678mr390435f8f.10.1741335249622;
        Fri, 07 Mar 2025 00:14:09 -0800 (PST)
Received: from krzk-bin.. ([178.197.206.225])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c01cb82sm4691799f8f.51.2025.03.07.00.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 00:14:09 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH] dt-bindings: rng: rockchip,rk3588-rng.: Drop unnecessary status from example
Date: Fri,  7 Mar 2025 09:14:06 +0100
Message-ID: <20250307081406.35242-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Device nodes are enabled by default, so no need for 'status = "okay"' in
the DTS example.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
index 757967212f55..ca71b400bcae 100644
--- a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
@@ -53,7 +53,6 @@ examples:
         interrupts = <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH 0>;
         clocks = <&scmi_clk SCMI_HCLK_SECURE_NS>;
         resets = <&scmi_reset SCMI_SRST_H_TRNG_NS>;
-        status = "okay";
       };
     };
 
-- 
2.43.0

