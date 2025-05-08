Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DE61C5D59;
	Thu,  8 May 2025 10:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746699636; cv=none; b=dTsySMtjYCDWoV1OGcy5tMotgMpzdZlnNWGGKr+FRuRJT4EpM7/T3q5/1cih2sMKxJL3ZUziUorTTVx7dS0jb55LOcLtOxuT/rBtWlnLQstxU8QUQVE3d8ySrUO4+BFJJgNJ/KKqLn+AQqp7Jwf3JKTSdOc9rVEpdEv4hgSpV30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746699636; c=relaxed/simple;
	bh=lSqIRxUmZm4AWVQH4oJ/nSKKRTQD0/VeIZXwE743ONw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZ1apwzpx6fO9GqnJZtmsOLy95p6BYkH3+7+/JoaBS1fPt7kCYKfOYwsORyVa4elHAXNJJbyrCtOdZcc5Nnxn2GiCs9McUxOOkzX56osPEYAkQciGNa1+JGniCx47fw4UR64gSNOWC/Z58kO1cJ845D4zbDdE0ELfNyPP5C1fSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ZCueXSvd; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ZCueXSvd"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 548AKRIm1642666
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 May 2025 05:20:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1746699627;
	bh=MnVLBozF9fH/K3g5BWn/Ig8ulDGxgIJKkBYrwb5xGYU=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=ZCueXSvdfjO7wS95upT+vBQuL6wpwA/S6Uk5ddWJNct+q5nth/B7dJ3h7Dg/m53M8
	 Z+xM7m/U7EBKbZKN1aLTaeVd5FEekEjj/Bp7PVTIMigTRVwLiK85I8D7Nzddxj73bS
	 oGFViyhOHijEHjkPZPUb4xJuBeIB3LVg2suKFd40=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 548AKRJJ032178
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 8 May 2025 05:20:27 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 8
 May 2025 05:20:27 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 8 May 2025 05:20:27 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 548AKPtV008847;
	Thu, 8 May 2025 05:20:26 -0500
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
Subject: [PATCH v4 1/2] dt-bindings: crypto: Add binding for TI DTHE V2
Date: Thu, 8 May 2025 15:37:40 +0530
Message-ID: <20250508101723.846210-3-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508101723.846210-2-t-pratham@ti.com>
References: <20250508101723.846210-2-t-pratham@ti.com>
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
index b119ae6b5f14..b990850b4994 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24552,6 +24552,12 @@ S:	Odd Fixes
 F:	drivers/clk/ti/
 F:	include/linux/clk/ti.h
 
+TI DATA TRANSFORM AND HASHING ENGINE (DTHE) V2 CRYPTO ACCELERATOR DRIVER
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

