Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2901DA23;
	Tue,  3 Jun 2025 12:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748954592; cv=none; b=D1BzdQtKEAsAYcn2gTZfvKUeh+dDWNPNcDAvSVjqfQkeBMxzc8vSVhfB80UFb2fdztt9IrKOPO1e8M0a6EvVtUVFDs4GfWfN/hJso7g2SGaPMYShQuz7LOzut9xO6T/dmsm19l21XJZYJ1KYdVQUyq8P/As/0jEJbxooDczRbsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748954592; c=relaxed/simple;
	bh=X3UoIH++OYx2usys2hzi8D2TEk8q8cSwOWciSg+252g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uPNVu8YBCrOt+9LAsnalrpLPuIWpfx8IxGbK7/2Td/tJPuouRuJDdn4DHjZ5HEs2G4tYwmlxsi+5svI8qd6GzG3IwUs1L8RjeNv3qyvMV5MvdTGs4qvZtEkkiO38mCFoaXp003qRJX+zQpkU7X7Daibq7yqDyXqph7BstMiulLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=MafX5J0z; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="MafX5J0z"
Received: from fllvem-sh04.itg.ti.com ([10.64.41.54])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTP id 553Ch1v23511963;
	Tue, 3 Jun 2025 07:43:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1748954581;
	bh=9o+tbWi21efdEZjj8br6IoiYP0j/TfMplNNHCa+bVPA=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=MafX5J0zT24HxGFi1xuP2pmlmBJk6fPlDNUrz/VLt2wBzFqanccd4YHQVZm2W7LB4
	 uin6dB1nceQ+j/4504L9cHjAJY4BOHrk9uzJyjAZCEPQ4oOc0VZf9PqHdEL6+5ClOy
	 hw4mMpI30s/ZmGJtUL2BAKvGOR3v/cj3ei+vlkbc=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
	by fllvem-sh04.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 553Ch1RF3607266
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Tue, 3 Jun 2025 07:43:01 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Tue, 3
 Jun 2025 07:43:00 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Tue, 3 Jun 2025 07:43:00 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 553Cgxh4439453;
	Tue, 3 Jun 2025 07:43:00 -0500
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
	<m-chawdhry@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 1/2] dt-bindings: crypto: Add binding for TI DTHE V2
Date: Tue, 3 Jun 2025 18:07:28 +0530
Message-ID: <20250603124217.957116-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250603124217.957116-1-t-pratham@ti.com>
References: <20250603124217.957116-1-t-pratham@ti.com>
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

