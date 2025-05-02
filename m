Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFBC22578C;
	Fri,  2 May 2025 12:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746188143; cv=none; b=KDGIdT+aB+oaVCHTt3vJPWYH0vG0qO68bQ3sX0xul+JrG7SdjL+I2Tm7+Jo/62zrYuV1i1doNHqAxh3OM33QLaMy/zGpJk+O4sQpHmiBei0S7u1Sk45VHo4eWP9rqFFlBRFKmr8z7/jShJ7K09CjdA9LE5pDwmk2Sea0j1WJQhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746188143; c=relaxed/simple;
	bh=RQTjaKlnmR4CPbHdwkYSo++ZB4obufIqV6sHErpgvKQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qVU+rqPemwogCYp7J/ZSohVRlREUrkcljLG9RwYy6PLPvWkl9KogoPYjIxDqN2JpBfh0DuYjQN3xuC74mjwWu2jaFD1wG/lt2SulzRnhnEdAKdLw0SYnrmfWthEdIQcLkuiVUm4dze+tybUtWxKnO9YYH9oh40tQMECXwp6xCkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=RVn6sXT7; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="RVn6sXT7"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 542CFX7S231006
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 2 May 2025 07:15:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1746188133;
	bh=whOOFLLQnPzAziiszL8i89v/ulccVbMoA21O38qwiYM=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=RVn6sXT7izlwwYcEIk4KSnN4q2ei/dTJE6+QRkJawLwWfOYDhHqhhTEcGHe4SA96J
	 u2c6MMU+WyUflCnbsK2dji0ju4dy9hAt7fKoUql3051EuHYyu9omGtcculDZA5r8jY
	 +Q6Yn50Qp4xAqdUD+nj+9nPMLmhG8SjJHzg2W0IM=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 542CFXYa052569
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 2 May 2025 07:15:33 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 2
 May 2025 07:15:32 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 2 May 2025 07:15:32 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 542CFVBI087379;
	Fri, 2 May 2025 07:15:32 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
CC: Kamlesh Gurudasani <kamlesh@ti.com>,
        Vignesh Raghavendra
	<vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/2] dt-bindings: crypto: Add binding for TI DTHE V2
Date: Fri, 2 May 2025 17:21:16 +0530
Message-ID: <20250502121253.456974-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250502121253.456974-2-t-pratham@ti.com>
References: <20250502121253.456974-2-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Add DT binding for Texas Instruments DTHE V2 crypto accelerator.

DTHE V2 is introduced as a part of TI AM62L SoC and can currently be
only found in it.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 .../devicetree/bindings/crypto/ti,dthev2.yaml | 55 +++++++++++++++++++
 MAINTAINERS                                   |  6 ++
 2 files changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,dthev2.yaml

diff --git a/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml b/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml
new file mode 100644
index 000000000000..68ed9923eebb
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml
@@ -0,0 +1,55 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/ti,dthev2.yaml#
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
+    cbass_main {
+        #address-cells = <2>;
+        #size-cells = <2>;
+
+        crypto@40800000 {
+          compatible = "ti,am62l-dthev2";
+          reg = <0x00 0x40800000 0x00 0x10000>;
+
+          dmas = <&main_bcdma 0 0 0x4700 0>,
+                <&main_bcdma 0 0 0xc701 0>,
+                <&main_bcdma 0 0 0xc700 0>;
+          dma-names = "rx", "tx1", "tx2";
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index e2e2942779eb..406a746d8a69 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24445,6 +24445,12 @@ S:	Odd Fixes
 F:	drivers/clk/ti/
 F:	include/linux/clk/ti.h
 
+TI DATA TRANSFORM AND HASHING ENGINE (DTHE) V2 CRYPTO ACCELERATOR DRIVER
+M:	T Pratham <t-pratham@ti.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	Documentation/devicetree/bindings/crypto/ti,dthev2.yaml
+
 TI DAVINCI MACHINE SUPPORT
 M:	Bartosz Golaszewski <brgl@bgdev.pl>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
2.43.0

