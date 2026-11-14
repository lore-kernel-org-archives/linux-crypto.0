Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794666188;
	b=d7PVN1rh0HJT+lKOqIvio72PwOXHz6bOgNPMbC9R3rpnYl7iM6y14gIpWikfklxBfhVy
	 PxtRdnGI3xg7IeHHPd14ZQVavZBesbgbWC5fE5Pqdn1O9JBuakbO88aVGmtb++0xdtVRf
	 yaO5PYz7s6P1kWaKp+qf6RWss5+qRySGyN/iywbLdAoLwv4PhP4AYVBR/zcXRw48oLzs+
	 /IJhJjVHnOAf1NvDe6U6vzOFGhzNqh41466+0b1hUxh31HYBwrlC3KQNYyQD3CakYz/d2
	 k4ovCzBjnEkx4MrgplQg7Vl6UgdHd9aNpMPOOoQU1W/EhpiCb2+Tsd1mjV9bjn8yb9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794666188;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
	b=hti148rWqwcKqfKxS8Edwyo0E23EzwJmjXvPxReHTMBpB3Pp+419tQqq5vLbfG+1BFNS
	 LOLYNj8H+pQ7RchhhE58ER6/sF95ZlUHLKNJnMIcKRClkRG35VGfdn9BOV2h+Fx5n8OnJ
	 ZGN86TNEcUk3pwGXkeh7S27hqOBGhQ7jVeU4w27oMcdeUb00a+jKo9SXMhS7VCctnt4MX
	 BgzBvyVqsIersE0QZCjNavVCyzzsA9XnvMZGSIL6+jYf1mlBU5EEztuIIlOvRxe3nC2/K
	 G1bBX8gUO+JRJ0s2rTc3/s4ILs1hcym1GeLWMMEaDIKfKy0Pp/KqOOoVX0kcMTCeEtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=h6CH2d5c;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CE3606A89F
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 14:23:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79CE3606A89F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=h6CH2d5c
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-15dd124bbe7so1588447c88.1
        for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 06:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1794666187; x=1795270987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=h6CH2d5cZulXWdcrO/5m7J1I2pa8dAU4NSQNCd1KiHK40tsF63ZW/S5CXt9oCBP67Q
         /teSmYtZEopIvfYIztsk026KkPB5YaG4LitPfHwZHkTrhL5sdOzmBSwPD+i+d0JmTN3e
         wUNcK1kQMuCFQ6dY9SXOEVJ8D7QMZJ9jPane0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794666187; x=1795270987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=pZ0Q4nezshjZJ1cI/KU2T+gXw3hkx47W+Lq/OwQ+qZVqD49JNdDV0dxbJVGsVyrbGF
         xKRVOFyOkcGzGb8ndQKgUqGs2WK4j9m0ddDhMyohy90pHMw0ZKVew4w+Ew1l0st44Re5
         PsMRHTTIKOLdlwoPvxtQeYgb0ijeZfp5yCkclCSKIgfN4CzzYLk5T/RB4dR2AgBuS0H9
         s1LNvYBiG0QYQwk4+ycxs4jxqRq0lC8W/fV+5MNxjlzToEsG68sW1gFktDNqOn5qe77j
         wku8PkW100s8ZMh3DboKIvdOtdmZ83D7dIEFwxx9TxgRCJocfvgfyqfZBB9mz/681k3D
         B6tQ==
X-Gm-Message-State: APuU4Z8pMGe5LoSdBpO32uozVBUk7PWI9zmyoMoXD6CVGYeYWTk3G/Fy
	LQ2SSGmcAnPfjlFHhg9afrAWFcPjZwGhJxXKszZc+uyEc3Bdzu4gN9xaPCvkuJ/m7aBuyoxrGH+
	+//uj
X-Gm-Gg: AYBFou1p5mK0dE2WsTK8FuxFTngScRKpCSPHbvqtEprrudgn3I7DwvjGNjBvx3XOa5j
	QMalhg/wxMq8TKARG3zXAu07gqnD8gffqiZUWtFNGXzNsmwana7uPgUoJNivLFK9xJmw48fnlJ0
	lf+g1AE/Xx0K6vJMfkyVGJX3l5p/A0xU/DPWKHC5oR07rqxA41cgjs3tuNr/ecmYZn7W6eQrUQY
	swI8oDFNCZgDFR3r6mqViweZTqKoYoBvSoA5jLMclueLfFCbg56DTtUfG87A7SJoqW4GO6JyoO6
	Y6184QpZWohJ1SoqX7iLimkLNI4BMRzsEZ+OdUAnCZ78bQiO2MV27Rz0IBI3JyCDnEOOcYq8APO
	KEUQtbgp8rUE/efPHAtEA1k8MZGBVxMNB0XjPeEtha9B1rkWGh7ZBY05bUHIi5J/5tzpMh2iQEu
	veJtJdUsfo6b6Vo0/WNaSfK1DwulSWpxXl4+t5btenOG7Fo29RhytMz8kxM7ea7C9rHouQBlN7V
	7oeh0iEUPEfehO9/NNL5AmbSL9tJzGExoVB7e1XXcy816KfkIExqAaD1JyeXFv7G1WVh3T0ysmB
	E0jO6OAuUfK/x0KogAfUCEyoXIdOGGjxZrBdkVAELwk1+1r37eHoyzkJC6AeQRtBQju5lmlQNsO
	iwCl9zOM5jTcqzWfz0vml+wvrUdGo54IeTaR+WRHwn3AeA7ij85AvYrOwBiFBW3NDwlT5
X-Received: by 2002:a05:7022:298:b0:199:7dff:f9cc with SMTP id a92af1059eb24-1b5031b0afcmr4540930c88.42.1794666186364;
        Sat, 14 Nov 2026 06:23:06 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50316e195sm19376962c88.8.2026.11.14.06.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 06:23:05 -0800 (PST)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk@kernel.org,
	conor+dt@kernel.org,
	ruud.derwig@gf.com,
	rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	nazim.khan@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v29 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Sat, 14 Nov 2026 19:52:09 +0530
Message-Id: <20261114142212.716906-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261114142212.716906-1-pavitrakumarm@vayavyalabs.com>
References: <20261114142212.716906-1-pavitrakumarm@vayavyalabs.com>
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

Add DT bindings related to the SPAcc driver for Documentation.
DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
Engine is a crypto IP designed by Synopsys.

Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Acked-by: Ross Bannerman <rbannerm@synopsys.com>
Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/snps,dwc-spacc.yaml       | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml

diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
new file mode 100644
index 0000000000000..a337f7b473cc7
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
@@ -0,0 +1,50 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Synopsys DesignWare Security Protocol Accelerator (SPAcc) Crypto Engine
+
+maintainers:
+  - Ross Bannerman <rbannerm@synopsys.com>
+
+description: |
+  The Synopsys DWC Security Protocol Accelerator (SPAcc) is a
+  semiconductor IP designed to accelerate cryptographic operations,
+  such as encryption, decryption, and hashing.
+
+  In this configuration, the SPAcc IP is instantiated within the Synopsys
+  NSIMOSCI virtual SoC platform, a SystemC simulation environment used for
+  software development and testing. The device is accessed as a memory-mapped
+  peripheral and generates interrupts to the ARC interrupt controller.
+
+properties:
+  compatible:
+    items:
+      - const: snps,nsimosci-hs-spacc
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    crypto@40000000 {
+        compatible = "snps,nsimosci-hs-spacc";
+        reg = <0x40000000 0x40000>;
+        interrupts = <28>;
+        clocks = <&clock>;
+    };
--
2.25.1

