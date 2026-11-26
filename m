Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721584;
	b=mZGGIHzoAx0qWkaio/C1338ZTVtoGhfwZFB8vLvfjheXutjHamjEet/Uow0oWXEcpCcY
	 DNgqmuT66qCBOfxQPWCljXLIOvEIqDyTEWuQw1qxrkFO7stxPqu57nwoBYWAglz1EX662
	 j3yh9il4AL7vAb8yPPmFdGWSXa1NN/lxDpPSJbnQresIFu+4fFStwDs/y6VMeGKqn3xNH
	 HOVvMiKRuD5Utt6DrSO3yFVwNN2kSIFenMxh6ue13lszfJtpXnR7N+Jttvv4miZuQjI2x
	 nZxblOo2f6sRVf3Uj3hpW1tO68RWd7wXLBb6bXl4N89LqElt8aGU6a7RLDHkUrXYewQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721584;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LiLmIUs0OkCCdpFo34dseBA6Y4Jh270a70ul1A3BXtY=;
	b=lPixDWCNcq07m/x8jQ1TBm4pVRb00NPUdA0FvtqgKHBYxLcPgykbouDQnORYhZdbNltO
	 eF3yUotNmjsXifOf7maFo9ezrpvNhS9qj2mIRWhrakw4iax3gn1s4SxFvnRHw1brV/Jc2
	 5ZlhCic8Fhi5pjcddt+7ajIJ5Nth2M6XM66b0l1qYNo6jOrJiB4CIhX+kg31hKswz3Nqx
	 gJO2wOiiliuv0SvbrfkmlX6+acblT7f0SyWVuh7aM1Wusn0DE0rN1kE9gL7iDoanQrj0d
	 di0SLUAqc2WoTJzM2jOK62M6+LELc+q0cp5kiSabtPQNdYNWmpne1FIxJ87DcuBB++g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PK7FZMEj;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA62606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AA62606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PK7FZMEj
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bba5e17728so20517755e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721582; x=1796326382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LiLmIUs0OkCCdpFo34dseBA6Y4Jh270a70ul1A3BXtY=;
        b=PK7FZMEj2ahDV0413m3lXgX7CE0JHmhr2KLv/BNO80Xo+lgBmtdswxm0q5g/0cF+j/
         ARJWAyvuezvB1nVD0HV/LXi+8k8xbYgpq5x6+uWTFxCfvUMN5OUnzL1pOaFWeFxlpM1c
         UoOjUKDiPj4bAz5zMc5R7lNOoxA+zUyBUqN+azA2dxHMty3tFEllSmL1qaQIsOPRfhCJ
         /BWic2boMqcBFLlSNBIvMZ9jAV4SpIZm+Vvrvpj2Cl+oCiGoLNd8bDxhLH1wXQzdxtqT
         CnFCBOdw+eunnNs6Uo303/FsNvzjZzDHQ8IiKV9dlxUMYIzE5EMCj/Jeo6Olf1W+SNNi
         14GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721582; x=1796326382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LiLmIUs0OkCCdpFo34dseBA6Y4Jh270a70ul1A3BXtY=;
        b=LE3yraLe8ipZxIZOkH8YYi8gR1dSRQGSfevf0q2CHQ5TfsxTRzpwnd5Krmf3c1nVeZ
         Kjk5L7GK0IscUMzZ7+yiOf6zO19rKCVoGBgHQIIPnBB0hzU5MwaVFh2+lLW6qeX7wc2D
         3aZ0pd7ZC/G/BGOdHZK4Iw/tKH7S3ftsexKUvufNwAY2D00r1DF/VNgO+BcPkHlIVAUs
         cofpECo53vpvcImwrelGoqeYNl/r7SddAuJtHDxN8lDy6sEb72xxpXTSp/YLAZHhSO4T
         02zOurhBPv4AQUnyf/Q8XUVcF4/6JdU9itWiD8/4csgfJDXPqRZwmCBGNUK2wxq3iLWF
         V0Cw==
X-Gm-Message-State: APuU4Z83tVm14PXZNBzc9Zo6f5/yBY2ndbMgSLaDrS+cbEkztW2SY71L
	9UBryYv7CjiMH0X08JmUAt+58pPkh0MHY9DPb2MBb6wqmWtEckhRqdno
X-Gm-Gg: AZFdTZfCEikhLwy5z9htJb8S5xmLXBoec+h5I/tdA+ECtRVO0I8yammlxnoYFM595CL
	UeT5GDuThJ45zJLU0/qgB0//s21RhONdEmDitGe/4D3tJPsJvIrC1EXhimQ93aPhaSdfQlImsR3
	1X2n9238gxt9FtnXXimc96+oO299ryA5TuFMAyeWhKuq24Wtw1Z2+JOfaSH4wGm7Oi5e+StUoJy
	K1GW40AoEO+UjIkdfUKyl631uA5yaw19f4uA8qL20mLwEO0WqyrEmPGSL3yeYAb/PBg+wCipXVd
	zE+6Fwy33Hsw4YtAqW4qR70NJ9EFGX0dW28QhQf6/MJ8rP4dixyhLqCY7gJZwiRaPGrPQ4WYOjQ
	7x3eW5YIzikuNsfQBdoPnD3nE131rjtaaK9DZY9rFsoG0EQjAU2npyicziyittCZnpIj1m+qwPH
	zqhZhobItiojrBA6fETzQu60pjIHmbobdBernv8/A2mJEooBMsF42UGbOO/5c/gfDez9963lsQE
	WOXYbC1+dZHbPhxIB8ZgVQbB9E0KupyBj5uoXrqH9P4FVrTKcv2Yuq2TIgk6HerIKiI9BtDEoTP
	7GLh5fxSMt7UU6KMgy1tMIsw/Up4/x0H6E/GUm+Qy94e+Q==
X-Received: by 2002:a05:600c:4f4e:b0:4bb:6c71:b268 with SMTP id 5b1f17b1804b1-4bb8882672fmr465522865e9.6.1795721582273;
        Thu, 26 Nov 2026 11:33:02 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:01 -0800 (PST)
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
Subject: [PATCH v13 02/25] dt-bindings: crypto: amlogic,gxl-crypto: support new SoC's
Date: Thu, 26 Nov 2026 20:32:18 +0100
Message-ID: <20261126193241.1471372-3-jnieto.alaber@gmail.com>
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
2.47.3

