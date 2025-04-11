Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64CE20DD47;
	Fri, 11 Apr 2025 09:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744363305; cv=none; b=XqPEBPYvCG29DGFw51vPKzqx8UzG4hXmQs692/qnWDc9Xc5BSrOXKNwMhr/g/fpUnC8omx9UKhZrXnZtDdtYmetBObbQ012NKAMzYxjO00tWCIn6XG+aU8/kT6GwxBuGAwBPstZ8QnwARq/08WFNFBLDkdVD+0urcCldV/U2TME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744363305; c=relaxed/simple;
	bh=n80qSdW8hTLLcGl32QhQXaDVoMDW28TbTsrNFVne5NI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oXiLpiO6TtCoJwlU9aXvQBlx9Y+m9iaxkHusFdeLxSjYyETauFizR/sfbtGcAXafwmr/E+2mcnCcg+9xKwAe3Z11SZvDgpw4CsDSVfgfD+U6x00PPvsjjVqAhdH4ap8nEUjaSJhOy0DALzf0snodbQgvVWJjFJze+v5875awPLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=PNQE3AxW; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="PNQE3AxW"
Received: from lelv0265.itg.ti.com ([10.180.67.224])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 53B9LZXQ1534406
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 04:21:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1744363295;
	bh=1Wu8WdXy6XC8FsshlNNPex7drpLCmQqBKgIq5OVRccc=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=PNQE3AxWNu10DHVRfn6XEj3ib/qoUB2tEyVtDAjSO043WWshf1OoNjmkqYW70OzmI
	 EYzPTesedz0ZKpkLiYCiVkzvipKkP/24a1QYY8Q+u716OxFsceyCH4gCxaIBS4qxx6
	 Uf3v317TTnaGhDSU6KleM7YJJ6fLKpE1qbHl/HkU=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
	by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 53B9LZ2o016030
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 11 Apr 2025 04:21:35 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 11
 Apr 2025 04:21:34 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 11 Apr 2025 04:21:34 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 53B9LX2I053286;
	Fri, 11 Apr 2025 04:21:34 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
CC: Kamlesh Gurudasani <kamlesh@ti.com>, Praneeth Bajjuri <praneeth@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] dt-bindings: crypto: Add binding for TI DTHE V2
Date: Fri, 11 Apr 2025 14:43:21 +0530
Message-ID: <20250411091321.2925308-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250411091321.2925308-1-t-pratham@ti.com>
References: <20250411091321.2925308-1-t-pratham@ti.com>
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
 .../devicetree/bindings/crypto/ti,dthev2.yaml | 50 +++++++++++++++++++
 MAINTAINERS                                   |  6 +++
 2 files changed, 56 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/ti,dthev2.yaml

diff --git a/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml b/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml
new file mode 100644
index 000000000000..7d55f1bff822
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml
@@ -0,0 +1,50 @@
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
+    crypto@40800000 {
+      compatible = "ti,am62l-dthev2";
+      reg = <0x00 0x40800000 0x00 0x10000>;
+
+      dmas = <&main_bcdma 0 0 0x4700 0>,
+             <&main_bcdma 0 0 0xc701 0>,
+             <&main_bcdma 0 0 0xc700 0>;
+      dma-names = "rx", "tx1", "tx2";
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index bfcdf2bced61..90b640385b88 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24174,6 +24174,12 @@ S:	Odd Fixes
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
2.34.1

