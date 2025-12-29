Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14D4335564
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 18:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033619; cv=none; b=F2I1RuWukf/UgnnQU/Bsb4kY9Tv84AHyJ/EaN7gYMfQR2sGbvLR+NsnMaVeWHY3gO7e53ahya2sG8M9RVyPafXNkW2auOfYfbrzfjDw90zp/vbhqEqLhhmv36Qg/YVM7npPagjb0ycOq+Ko08R7TeS0iIfgTFDZTa5IgrxGh2bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033619; c=relaxed/simple;
	bh=dZfEjbKU/ouuTZTqPmjhpmJn3Qj+z3eYR6Bl3lD/xyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXQaD7RNubFoKb+tadGzPtKG7O6AFI4gpmbcRX45MGFuJa69qJgbJIry3XCEz/ISm+dQ4aIeJelOXn1J5HZazILmcHIbZMYPFVOZ1SXIhb8GhE/CK3BlB0z7HxibagBXAbOZz641AsYkkwSlifoYPa9mg9f3Smm/luBpsObY1G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=IyrgbF6F; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="IyrgbF6F"
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-477770019e4so78727645e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 10:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1767033615; x=1767638415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=11UWr6vQeMvr9imUXUNdMnB+gxpMnYAq1afoJQH8nw8=;
        b=IyrgbF6F0u28a5QzqGi50ibLI5sXMnrNs9w2nKZbHvTdLOMtT7fV5tB3XSXxbBin+z
         +F7iemGAgQcoJ9Flf47KNjfQBnI/iqSFjhlwBxAY1TytmO/7e4JOQPrNinsFzbE1kobm
         iwp1El2nfozKqd0uOOOIZy4E7W7vs7yG0bwPi2nR/PX0eYqAfLaqKeMcAVOr1MSg30k8
         YcRIl3dZsgbyi6YROamI3AWybGB52crReQbGZAHW/Wz+ded6FK7NZnz6cmqe3OQd5D4p
         FxFHbwh7lCbyarJxYMPPv6EjTjI0yKAlsapfEw6F7Nul42Yk6T7qVGvrs+Mor4Cok3iG
         uIww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033615; x=1767638415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=11UWr6vQeMvr9imUXUNdMnB+gxpMnYAq1afoJQH8nw8=;
        b=gXQtarXQPaSvcOj0BBXNGmw9TNueCh68saoDhfpSLm5+ErHYQNOYAp6khNhBEvwO4s
         ndGFrhS97YllYW6Zo4GstHQUo6zkIrU+hyUq+gR3pSijezoQ6lS+oPK44mkjMGcB2C6Z
         TGsdpmBoeGpKygUH6CKo2oFoebAh8yirW6CJOoVHsswQm63JEN5UynwiVOtg1QCSg7Bv
         EZqsF9s8paY7iRQ2/InCH5BRWzUrIonpeG9re1DzL2nUe96Yt72sRKuhnsc8aM1QRdIx
         T3+T31Or2c8TGXE1Nch4+a3z0CRd1iswnKILmPkAfU0Fg+RcpzBTMCZ4l5n+KzYI5AeS
         7sDA==
X-Forwarded-Encrypted: i=1; AJvYcCXmwxAgwpeJr978QqB6R53ntw86mRze9mTcL98cnS5Aa221picrW2AKa0T6Tp0DJ7Wn+f4afdp0sNf5KCg=@vger.kernel.org
X-Gm-Message-State: AOJu0YytTHu6abvo7z1jX3LB2nODm/WOBMvsPI7fjum+QtNBqEhRSe/G
	SqOZFkYQ5Of43Zntx8/sxgCatkHBFnkDVzA4y2hsUT1gRLSYaI3uuaE7+4CvreMUmtM=
X-Gm-Gg: AY/fxX4uV286FCklRIhxEiclBy9P6CaCznzRE117QEHrXLyIHWlHzHiIphU9XZLnyJU
	axOsBLt14aNDnMM/9+A58+X2t+C9P/i5C2qeI4RK7khxUMUR17pD2vJcjWXOkUUo5iCHH5l/+wc
	Y7UjLvEolX/ORJRsBEEivIJXyUsErr8ti1iFQy+N+Lc31fwwpZ1//oNWkRM1D0QX4CdI/yYa6HN
	bR4A6xWxizDzqdO2f7x12KE1I7Ow2keKiHKVVK7cVqpkHGgYStImrEegl9VEL23Ii17oH5P2I5E
	pazRI7/8al48slQw50rryEIu+4drJ4WwW3lbA/kIBP6lF9KvX0yLJNzqnM+3h/im2enWqg54YIg
	n94q1mFhUV41jlI5iMsg8AzLDPY1Xd/3d5AjeInUTpcS3ebyK5F6gpNeUMqqasD+Emi23SczznX
	X96SlGLt8s65L4PG/s/BeJi67BUh91NW/H/myQ0WF+mfQcHEN7ygN5lz0PSUe5WX5jdKfivLu1i
	Om3jz+tGQct6HdvZ2BZprePcvi2ClU01O99Qw4=
X-Google-Smtp-Source: AGHT+IHLaRW54exoV7d2gj+gL+Rt0y3shCu9zPoBut21wi+sGprCRHwNncaVYYsnvBzR7kb1R2Xvfw==
X-Received: by 2002:a05:600c:1f84:b0:479:3a87:2093 with SMTP id 5b1f17b1804b1-47d338a6109mr230056155e9.37.1767033615044;
        Mon, 29 Dec 2025 10:40:15 -0800 (PST)
Received: from fedora (cpezg-94-253-146-116-cbl.xnet.hr. [94.253.146.116])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm604907455e9.12.2025.12.29.10.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 10:40:14 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vkoul@kernel.org,
	andi.shyti@kernel.org,
	lee@kernel.org,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linusw@kernel.org,
	Steen.Hegelund@microchip.com,
	daniel.machon@microchip.com,
	UNGLinuxDriver@microchip.com,
	olivia@selenic.com,
	radu_nicolae.pirea@upb.ro,
	richard.genoud@bootlin.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	broonie@kernel.org,
	lars.povlsen@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v4 01/15] dt-bindings: usb: Add Microchip LAN969x support
Date: Mon, 29 Dec 2025 19:37:42 +0100
Message-ID: <20251229184004.571837-2-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229184004.571837-1-robert.marko@sartura.hr>
References: <20251229184004.571837-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Microchip LAN969x has DWC3 compatible controller, though limited to 2.0(HS)
speed, so document it.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
Changes in v2:
* Fix example indentation

 .../bindings/usb/microchip,lan9691-dwc3.yaml  | 66 +++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/microchip,lan9691-dwc3.yaml

diff --git a/Documentation/devicetree/bindings/usb/microchip,lan9691-dwc3.yaml b/Documentation/devicetree/bindings/usb/microchip,lan9691-dwc3.yaml
new file mode 100644
index 000000000000..08113eac74b8
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/microchip,lan9691-dwc3.yaml
@@ -0,0 +1,66 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/usb/microchip,lan9691-dwc3.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Microchip LAN969x SuperSpeed DWC3 USB SoC controller
+
+maintainers:
+  - Robert Marko <robert.marko@sartura.hr>
+
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - microchip,lan9691-dwc3
+  required:
+    - compatible
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - microchip,lan9691-dwc3
+      - const: snps,dwc3
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: Gated USB DRD clock
+      - description: Controller reference clock
+
+  clock-names:
+    items:
+      - const: bus_early
+      - const: ref
+
+unevaluatedProperties: false
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+
+allOf:
+  - $ref: snps,dwc3.yaml#
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    usb@300000 {
+        compatible = "microchip,lan9691-dwc3", "snps,dwc3";
+        reg = <0x300000 0x80000>;
+        interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&clks 12>, <&clks 11>;
+        clock-names = "bus_early", "ref";
+    };
-- 
2.52.0

