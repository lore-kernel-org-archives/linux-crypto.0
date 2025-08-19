Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38B91990C7;
	Tue, 19 Aug 2025 06:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755586771; cv=none; b=R3OhUCfLO3GLK8SBRTrDqZrPVPN9/6qt+5AMaDWxc4QtUAfReNjYg4S1MXPDv9tJAf6gxiqo2/rX7x0SXhYRs6Sa08h8SLwtYZqA/bFuqZYCYLjcgQTEibTtHCB4n54UdmsnhAAsYrDkQenEd+J70QEhWmsrWWuFPafgNeZufKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755586771; c=relaxed/simple;
	bh=AfsvnBJTR3hcQR6RFlIfxqkp1b4j/uQrr8x9twyT0S4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QxKzuP71hq8fevAg0ohhM4S4rUqYnP0v23b8J0tSjuAOuWHvjMkFWyreitmUqWqN5Ar917uUnZQqJxClDaFDkqiU4HyCjSWwiT2LIZ/PHCas6AjWte7Xij6E1LgE3O3BocG1BSn4CGgsuoxiED3O6tao2WZqOLsls5Qovr0qI7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=tSeBSlC/; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="tSeBSlC/"
Received: from lelvem-sh01.itg.ti.com ([10.180.77.71])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTP id 57J6xL7S3254958;
	Tue, 19 Aug 2025 01:59:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1755586761;
	bh=EF0yM92ZpWpm9tf7xKah94pD5yLEZNulHKSkYq+gOls=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=tSeBSlC/PB33q+b2YLwZaCgHRYFt3ZbM0xPHuPHoBRB/02GQzX4e1q2wMJZYLPTc5
	 P3/ta0bipEmq2SetZRWpDR21E1PgQvvsnSGeBL4tY6YAzFlp6J5gsgz7fe5sOgnPlt
	 ljgChW5VgBe45Oz4rsnX6GHM2vBwwEeHHW5l+SYA=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
	by lelvem-sh01.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 57J6xLlA210101
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Tue, 19 Aug 2025 01:59:21 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Tue, 19
 Aug 2025 01:59:21 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55 via
 Frontend Transport; Tue, 19 Aug 2025 01:59:20 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 57J6xJaN2303301;
	Tue, 19 Aug 2025 01:59:20 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller"
	<davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski
	<krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
CC: T Pratham <t-pratham@ti.com>,
        Krzysztof Kozlowski
	<krzysztof.kozlowski@linaro.org>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Kamlesh
 Gurudasani <kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Vignesh
 Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal
 Mahaveer <vishalm@ti.com>,
        Kavitha Malarvizhi <k-malarvizhi@ti.com>
Subject: [PATCH v6 1/2] dt-bindings: crypto: Add binding for TI DTHE V2
Date: Tue, 19 Aug 2025 11:42:44 +0530
Message-ID: <20250819065844.3337101-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250819065844.3337101-1-t-pratham@ti.com>
References: <20250819065844.3337101-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Add DT binding for Texas Instruments DTHE V2 cryptography engine.

DTHE V2 is introduced as a part of TI AM62L SoC and can currently be
only found in it.

Signed-off-by: T Pratham <t-pratham@ti.com>
Reviewed-By: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../bindings/crypto/ti,am62l-dthev2.yaml      | 50 +++++++++++++++++++
 MAINTAINERS                                   |  6 +++
 2 files changed, 56 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml

diff --git a/Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml b/Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml
new file mode 100644
index 000000000000..5486bfeb2fe8
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml
@@ -0,0 +1,50 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/ti,am62l-dthev2.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: K3 SoC DTHE V2 crypto module
+
+maintainers:
+  - T Pratham <t-pratham@ti.com>
+
+properties:
+  compatible:
+    enum:
+      - ti,am62l-dthev2
+
+  reg:
+    maxItems: 1
+
+  dmas:
+    items:
+      - description: AES Engine RX DMA Channel
+      - description: AES Engine TX DMA Channel
+      - description: SHA Engine TX DMA Channel
+
+  dma-names:
+    items:
+      - const: rx
+      - const: tx1
+      - const: tx2
+
+required:
+  - compatible
+  - reg
+  - dmas
+  - dma-names
+
+additionalProperties: false
+
+examples:
+  - |
+    crypto@40800000 {
+        compatible = "ti,am62l-dthev2";
+        reg = <0x40800000 0x10000>;
+
+        dmas = <&main_bcdma 0 0 0x4700 0>,
+               <&main_bcdma 0 0 0xc701 0>,
+               <&main_bcdma 0 0 0xc700 0>;
+        dma-names = "rx", "tx1", "tx2";
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index fe168477caa4..0f5bb8ad7653 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25169,6 +25169,12 @@ S:	Odd Fixes
 F:	drivers/clk/ti/
 F:	include/linux/clk/ti.h
 
+TI DATA TRANSFORM AND HASHING ENGINE (DTHE) V2 CRYPTO DRIVER
+M:	T Pratham <t-pratham@ti.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	Documentation/devicetree/bindings/crypto/ti,am62l-dthev2.yaml
+
 TI DAVINCI MACHINE SUPPORT
 M:	Bartosz Golaszewski <brgl@bgdev.pl>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
2.43.0

