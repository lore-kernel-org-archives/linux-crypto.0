Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7E31E47A5
	for <linux-crypto@vger.kernel.org>; Fri,  1 Nov 2024 21:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730495628; cv=none; b=taSn213lQpuVD8e3OtdYDPA825JOd/RdtdJEEas6K3/7pnGs4CTBQ/IfMLsHJOkgq/nvxCgxWv7OPOX5ZbpVmIk1t/MVie9Ei0BN0+MOGj4fBJj0Ln8Twa43bbwB2Qz0JDxtMU+4hb+lK2Oq8rvtQfCK4KDxcZ4FBPNnn/+lyhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730495628; c=relaxed/simple;
	bh=j7iW1feqAWso+Tat91tAHo+FMkx1wlBjbAqAJjmwQzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKl9JvXWzG9dBShiF+s8VCjglV1XIu52yexYYrLQVG0d9NRSVoDyTHSzzWgsRxvbQuF4Wxr3AAHvX2rx7vopJKcyLFnk6xLUYA+weiXzEFKl+7z32tyKtMjnXS0HKv22YI4/y8aAOP3VTunQm7cmk513/k6A0AOir6TjSYT0sO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=bq4OAVe2; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bq4OAVe2"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-720c2db824eso1911827b3a.0
        for <linux-crypto@vger.kernel.org>; Fri, 01 Nov 2024 14:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1730495623; x=1731100423; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/gmaslziIHUfTRq5OT9nnJb5IIrBuXYj22iGCA2p1Vw=;
        b=bq4OAVe2CcyY8Fz3NqUZ/Slhb2Tb1KQKZzuPuj339Kq4z/TmpFCUmx9xq5brm94bO3
         in9evA3ATgn/4YteOw6GL1sm12igoFoYyvlwN5kyqNGv/qjwHUZPDAh0E0Iiq3BukwzX
         wfnrRHizTvXvfrFyU3WoT1UiNvkOPQnpQDxjE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730495623; x=1731100423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/gmaslziIHUfTRq5OT9nnJb5IIrBuXYj22iGCA2p1Vw=;
        b=O8DOdsccRA6G/DI+3zUw42uD3xWNUJK0YfqrfmpP59lfTkksRZI4+r7cW/WxH6/hUq
         9ySFjhKmXV5F6jEBvkTzK32Kdpb1UPS/WmTKvdWkBMOEOQvu0HuahOIK7n8NxQCcWz29
         xzWKnFgVK8Dor1ymJFgxxhaalAEiJR/VIZFoZGFhEcJqCqwwyjfVFxyxbJrB2aGxfQoZ
         f5CcFfQCcGfBQ8Vs+EEQi/+z5XrM3exN1cihAWTRkVC+k99y/DJrlpMIbIYLCCIN6jdL
         zvcT6IeRQVFLavzgUhSqw4dBC3jzyWGNFhxmiE3Jvrn4jaiS2KjTdX0+j8Rrrg1Yjvt1
         lNTQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5CCUJM8TaZTf59KwW/F9Us+y6SSNCp0njdQizPhui84ZyKbM1vGf7cjYYyy0eZlN35yQr06/xuPHod0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHgHKSKRGkSdX6U18TeP2j+TLCuYEloS9So2A8pZ7tAU685S6S
	4DxyMOLB8Ytwyn1yQMz9+q7Xr1mo1g7tUsH7AwOnIFuuES9fJLBW/g721vCEbQ==
X-Google-Smtp-Source: AGHT+IEAOefh63wQIqfkUJOl5klZYVKP7yCEGttqmKZtHp1y5vUat4ZKI34uorr+hfkqicJydf5fHA==
X-Received: by 2002:a05:6a20:cd91:b0:1cf:3c60:b8d3 with SMTP id adf61e73a8af0-1d9a83cf404mr30917513637.19.1730495623421;
        Fri, 01 Nov 2024 14:13:43 -0700 (PDT)
Received: from lbrmn-mmayer.ric.broadcom.net ([192.19.161.248])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ee452a995bsm2898250a12.21.2024.11.01.14.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2024 14:13:42 -0700 (PDT)
Received: by lbrmn-mmayer.ric.broadcom.net (Postfix, from userid 1000)
	id 029D06FE; Fri,  1 Nov 2024 14:13:42 -0700 (PDT)
From: Markus Mayer <mmayer@broadcom.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Conor Dooley <conor+dt@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>
Cc: Markus Mayer <mmayer@broadcom.com>,
	Device Tree Mailing List <devicetree@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] dt-bindings: rng: add binding for BCM74110 RNG
Date: Fri,  1 Nov 2024 14:13:14 -0700
Message-ID: <20241101211316.91345-2-mmayer@broadcom.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241101211316.91345-1-mmayer@broadcom.com>
References: <20241101211316.91345-1-mmayer@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a binding for the random number generator used on the BCM74110.

Signed-off-by: Markus Mayer <mmayer@broadcom.com>
---
 .../bindings/rng/brcm,bcm74110-rng.yaml       | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm74110-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm74110-rng.yaml b/Documentation/devicetree/bindings/rng/brcm,bcm74110-rng.yaml
new file mode 100644
index 000000000000..8e89d4a70b53
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm74110-rng.yaml
@@ -0,0 +1,35 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/brcm,bcm74110-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: BCM74110 Random number generator
+
+description:
+  Random number generator used on the BCM74110.
+
+maintainers:
+  - Markus Mayer <mmayer@broadcom.com>
+  - Florian Fainelli <florian.fainelli@broadcom.com>
+
+properties:
+  compatible:
+    enum:
+      - brcm,bcm74110-rng
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    rng@83ba000 {
+        compatible = "brcm,bcm74110-rng";
+        reg = <0x83ba000 0x14>;
+    };
-- 
2.47.0

