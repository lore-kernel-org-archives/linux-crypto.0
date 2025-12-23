Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CC434D393
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 20:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766521202; cv=none; b=kQaL5qFnrpCH+QxlUaBBCD16L6Tj7oHmP+fLr06LPnKsu6CUpuQYwvpi64ZUxfbA38i9pQPagEYEPMHQoB+VsqkCzyag1IiugPFm8X5KMDkEe7ejgJv3pWpJVp0LJ+r+LMupMPaxr18PaKOmEsXFyrta1RY3crK8t6aN0N84lUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766521202; c=relaxed/simple;
	bh=YtDrhz214maGpV2hZoz5P9MBOOxn5+fyXOlqcl1OMZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEVDaj+Co2ZOqWAXi/qvO2j6LWRjG5qNk5o3vpmGackI4lN5srNjDnONgZhGbngDWP+rXI4a9wlKcgp1Q6PhQvJN4r9cQCB/2047gA0wiKoHlfYuteZ71ucYcnebeTLiLS4AryB1MxXlfCiX6ZOp7sHX+jAV0goW92dcw4XM5ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=Itpb3JsL; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="Itpb3JsL"
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-7f121c00dedso7147628b3a.0
        for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 12:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1766521197; x=1767125997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XOr56XFFvJYItbaYZCF01MB/OVR35Ya4WEl16UdXyiE=;
        b=Itpb3JsLEKrwXU7kw7Dt/7ASbLZ2yWR8oobjE6bPXQIqq9EhR3K46S+Jd9qgF1iZnX
         M8MwRyf7+/VloXbvxwQdqI/eTwDvLyUFkuhyP1+8Uu+pTqt5agyp0hSqQeQtPdYuI4+J
         vGk8rhBDC3rmSjddEsJWEWWyid1FwzSewDHgjFkbyKylAjrPWXyXBQtNzpMyvaQVctIK
         4EnhuaoBNXK5F3hqvYKe/Uz9NXdVSywebgvzt7pzux4Q16SG9pLQEzcwKX825//VAgJQ
         tV+Ox13CxdCy3hhSw0eAyPUj1VKUsud3aHOI6GeAhdmnvfcg0/24TS0s9NLGlRfGB7Gc
         /d0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766521197; x=1767125997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XOr56XFFvJYItbaYZCF01MB/OVR35Ya4WEl16UdXyiE=;
        b=mkKgtc1dxnlZd+xovzqMCmaWMAkpuhoIyahj/116GhJAdh4DXsVkqOBnZHAFDlLCog
         G86rOGG4SXrG/GRBt7/srVzFYgnD0AK256NzS4Qw+q1E75bU95uIMpFIDhRf/99qobuH
         QiJ+RVXm+j62lKvl0yigzZbMZVvYy9FKvTPFN62yD6GymkTTYPI4R3bmBSV2hGeodsof
         Wm2j5nDa0xkmisASlsXcFJfVlnKHgMnCumHDQr6zkrCxilTj+/UoiDlA60VTwWVrWvap
         2IMNX/A/UnpxPGituSwqstzrQqYxvFfRjuZoA5sg6EvhGe30eQvJx4aIAQY4j6xV75aH
         GT7A==
X-Forwarded-Encrypted: i=1; AJvYcCWTb24Gpt0cadQxd2xyxeM2bsnjO+cgQ+6McLGmCVdv5RiEEN+sJKeqdlalzSruoqFk+Gjoz3dBOD1uKS8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3gCVUbkc64A+IhkLv8UPRupTQJ7rMkvLBfmNp7Y6DXxXtdclo
	2F8WB5+oDSdrQuHSfqwlEhWCyj1Tr4LiZdCz+jskbgy17cWGpTSIUvioRU5sUGDERoo=
X-Gm-Gg: AY/fxX7UCOoVmvVDPGEiqrAUQSbO+wva+Wq/V6724e7DDy4R3+0jWaGm3oJjoiJFI0a
	MrEn64GWBEHCs0/js12B2FPso/BI8itBlFqKBEh5gZcYzOUUzvxu69G/O6VaHJsQbGTf6G6vijz
	3f1Kv2j7fSkB2Fg+EXRpHSt73jI2gpPNl7FGrgQiYcsZAg2ldQ4pWTQkgXlwEvEmMd/H3Ekt5Ys
	Q9u5dULu4lZ/a5hAW1N8Pi7762CLGjbx8nOghBna35pW1d6Q8mFmoDPae0LZZ3kXxNvfyGN35P8
	zQPKlKoRB/95+g/cYUq64NKavRGZKJUfZv93adG0Sl/RmULhQG/PnBjbRaf1QjOCHEc/nOrEioG
	9uIXOudKWexWyE2gOQuh76BoHDhvS09sYot4e0DwBWgCCwUfNR+pWVO5MAfpyl8yvEOsXJSr0Cf
	p8QqdjJoTZQgDNG3gynsiruNjh4I2pFO7s40chEpTW96p7nKPR7bwHeLmjNAjlLWe4GJ9/2GLrs
	BqAYHoo
X-Google-Smtp-Source: AGHT+IEPFyQyinZIGZrAoM6IvYr08l7wEvqvRLZX8wkQv3+jdTfbwpmbaxqGPLI1nIRPqBYzainggQ==
X-Received: by 2002:a05:6a20:430f:b0:350:8066:6ebd with SMTP id adf61e73a8af0-376a81dcc63mr16097918637.13.1766521196919;
        Tue, 23 Dec 2025 12:19:56 -0800 (PST)
Received: from fedora (dh207-15-53.xnet.hr. [88.207.15.53])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c1e7cbfa619sm12567549a12.36.2025.12.23.12.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 12:19:56 -0800 (PST)
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
	mturquette@baylibre.com,
	sboyd@kernel.org,
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
	linux-usb@vger.kernel.org,
	linux-clk@vger.kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v3 02/15] dt-bindings: usb: Add Microchip LAN969x support
Date: Tue, 23 Dec 2025 21:16:13 +0100
Message-ID: <20251223201921.1332786-3-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251223201921.1332786-1-robert.marko@sartura.hr>
References: <20251223201921.1332786-1-robert.marko@sartura.hr>
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

 .../bindings/usb/microchip,lan9691-dwc3.yaml  | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/microchip,lan9691-dwc3.yaml

diff --git a/Documentation/devicetree/bindings/usb/microchip,lan9691-dwc3.yaml b/Documentation/devicetree/bindings/usb/microchip,lan9691-dwc3.yaml
new file mode 100644
index 000000000000..6b49ef0a6bdd
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/microchip,lan9691-dwc3.yaml
@@ -0,0 +1,68 @@
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
+    #include <dt-bindings/clock/microchip,lan9691.h>
+
+    usb@300000 {
+        compatible = "microchip,lan9691-dwc3", "snps,dwc3";
+        reg = <0x300000 0x80000>;
+        interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&clks GCK_GATE_USB_DRD>,
+                 <&clks GCK_ID_USB_REFCLK>;
+        clock-names = "bus_early", "ref";
+    };
-- 
2.52.0

