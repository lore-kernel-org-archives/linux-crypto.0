Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190812DCC1F;
	Tue, 24 Jun 2025 13:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773219; cv=none; b=nJrqIHiILXmsJ547fbbniVfC/PWVQ0yB/uLKjGNlHuDxNEBc3PIXu0gMEYVvLSlny40Y9Ub4jC4pwKpzh61YYpl2QJr5HoMVuvrEZIwS0p4t9tmaJVHQAscAuVpjY0AV9Q2nr3u1cVV90tAW5nVoiSe2cQURYx/T3ZnkvnZiJwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773219; c=relaxed/simple;
	bh=UtgYoR2X57K5tJsVteFObkUGXRzhdTxd5+e9rq/oEL0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hAeIpvXGQc2npkhGbPRhjHgxC5CQBoaQ0o7wNb3ilHdxNKZJZ94wvuSb97KgO5FaFmF9enlXs1x9bVfrl9XFkUyBWI7xlIJWvvhbr5Znw37ND3AhtdFsTYVgD6wytvEm8zKgsNLgKq0GeoNe17Tsihwo2E7ZX7Q6dNColn4akVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ddg4Nzs1; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ddg4Nzs1"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-553bcba4ff8so5497507e87.2;
        Tue, 24 Jun 2025 06:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773215; x=1751378015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1pNAOsr7oBRaoQ01PVf9vESlXHVYj7tbDwKZX+rkhTE=;
        b=ddg4Nzs143r8s31P7djlYLYjGBUdNQ78ym5NKD8bKGujkKPeNzBJFvVN3Zz9Z0dreW
         GtvXe5Ia49DYH30tNutqnLZnP5q4Gqui3JMm31OKrItwMsoZt9SLfXuKPd4k9QNk95F9
         hm2yKmo9iiNbPOAbuGgYGQADpiZ0iZFPJ0seEaaflZeCHbkE0GOy1wIygGGeC7gIN9QF
         3cLATIqulkyzEhQB1cYJ5qf37IxYMCUEI4tjjYSGTCOyINrknhbwO3AHTElpQoUV4KkD
         oo9tlcJ8X82k4V5I10AIz8DxIV2uFRpirCa/XYn0sF2WEs7KIJw+aOOkNM3ofiJjhfGN
         wSig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773215; x=1751378015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1pNAOsr7oBRaoQ01PVf9vESlXHVYj7tbDwKZX+rkhTE=;
        b=wGULi2E+HiH6fmB1VSpw/gVhggV8bsM9r+0FLyD8edKjX4MbgfJUobulP5qetqYvG/
         B67zDeas7O2/Rxqw0MDx9xER+1QVUd4yHZV1pM9SNwPb4yM+AEsN8D+nvmaO8kkZtK2Z
         p8rt01DcSxszsnYIUGgo0Id9A5AeC5UqOzEmGvl1YE3MwUuIeWOYiYjFDunyMF/l9VjX
         ZTPl+vmGdHsXa1q+/CAR+8T0IT5CDMPk5ceKScour5YkCXfBviqVRK9ALmG1q0g4XCeZ
         GMgGxycxBEsfq8J7+4uvrReZ+u5rhyhV2Qhrw+cURkg2bEG7w2vBAS4SFm/wC/eiMoJS
         oWGg==
X-Forwarded-Encrypted: i=1; AJvYcCV0BbdnoAmk34YfSU5EXvOn8UUJqIZDaEjLOCGDg4lysiMjLEnrzsohCYg/+O1rnN5/zBKGkf2Af+O5@vger.kernel.org, AJvYcCVN4lEdODMWXw9SMI0jRv8wW3UWtRUNzskZA2CnWYWQ7WRd+VYjg4rjOZgNc2ZOftoyFpGU4LzIxoA/xomv@vger.kernel.org
X-Gm-Message-State: AOJu0YzF6LSoVF/pTg3EnwWQ1tqM8WvbQgqoTcioYM06JbqcYQ7vWUEx
	rRVFw0MCbAqzdhVcCn8UqHl4FoP560a5azVP4gS0nnlvnpkbByVEEZ75
X-Gm-Gg: ASbGncv8m95ggJ8yAYYlhQ0QKSFMJcxbZlVC+KBPZT/j+paOAe0DT1XPYHJse0vZlY4
	0dFj8qUPq1n1mU9Y9CqCWj+dHRqECEuY87OvdDhq/ht5Gh9NpKB4kT5yw5/UiL9HBEEE0x8Hs40
	vaCaJY7kRFwu4/WbbXSdwkWcb7b+F2oyQTi6okXhAif76tLqqAkebBHmFs4G8N1jbebwyJoeaIw
	A2DW5kt4mlkN1mAEtAkiE0/cTmrt0oT6zoz6eaxDcC3o4bK5POqVnJAK/zAxM2S4Niys0mncvc3
	5SkmekTeOKnqzmwUJcZ4jFsjEv77oprxak3M+BHo4L+iY7QNsjaeNWAiXKcEu1P8YSzGqxiwfKc
	gbOpWImT4/yofe6tVuHybbX1A6Yph4Gd7k4Eh86Hg3UbDsb9VHL8dw+8b/sEYxjayuXsk+i35
X-Google-Smtp-Source: AGHT+IFHoqsn5l+6wnf/gfhqMIvTUVLCfhefWnXG0QHSCeZSMNDwhCUiamUKfO/EUExW2EQxIREwaw==
X-Received: by 2002:a05:6512:3e0d:b0:553:50c6:b86c with SMTP id 2adb3069b0e04-553e3d15539mr4868398e87.57.1750773214903;
        Tue, 24 Jun 2025 06:53:34 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:53:34 -0700 (PDT)
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
Subject: [PATCH v12 17/22] dt-bindings: crypto: amlogic,gxl-crypto: support new SoC's
Date: Tue, 24 Jun 2025 16:52:09 +0300
Message-Id: <20250624135214.1355051-18-romanov.alexey2000@gmail.com>
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

Now crypto module available at G12A/G12B/S4/A1/SM1/AXG.

1. Add new compatibles:
  - amlogic,g12a-crypto
  - amlogic,axg-crypto
  - amlogic,a1-crypto
  - amlogic,s4-crypto (uses a1-crypto as fallback)

Difference between this compatibles:
 * Different registers offset and the number of setup descriptors.
 * GXL doesn't support hashing like the others.
 * G12A/B and A1/S4 crypto HW don't support 192 AES key.
 * GXL, G12A/B and AXG require a reverse IV key before processing.

2. Add power-domains in schema, which is required only for A1.
This is specific vendor design: in old SoC's power domain for
crypto HW was not configurable, but in A1-series it is configurable.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/amlogic,gxl-crypto.yaml   | 24 +++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
index fdc39797a2a9..106a9d1fed69 100644
--- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
@@ -11,8 +11,16 @@ maintainers:
 
 properties:
   compatible:
-    items:
-      - const: amlogic,gxl-crypto
+    oneOf:
+      - items:
+          - enum:
+              - amlogic,s4-crypto
+          - const: amlogic,a1-crypto
+      - enum:
+          - amlogic,gxl-crypto
+          - amlogic,axg-crypto
+          - amlogic,g12a-crypto
+          - amlogic,a1-crypto
 
   reg:
     maxItems: 1
@@ -24,12 +32,24 @@ properties:
   clocks:
     maxItems: 1
 
+  power-domains:
+    maxItems: 1
+
 required:
   - compatible
   - reg
   - interrupts
   - clocks
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          const: amlogic,a1-crypto
+    then:
+      required:
+        - power-domains
+
 additionalProperties: false
 
 examples:
-- 
2.34.1

