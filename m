Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F32226171;
	Thu,  6 Feb 2025 09:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738833694; cv=none; b=UVvsbwbu8b4wEWz1newY1ONfIcVwb5ABjfwJzkoPujG7zJ/suGTYVpurW/po4FVsjIQK7DYadN+6OKEh9Jtho0MRM4hHH1EKMvfQCUjSryaS2xR0BeUNpDDPTknn6eAUdxmMUJjKWcZEyYRMIokPkjhQ5uYJu5klTcO9mUN3oNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738833694; c=relaxed/simple;
	bh=7xGHQ4iVocGMs1d/dulWAD7seQNbiZgu21sSSeDsyPg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K5ifybALguv9KKc5S9yE+rw9g/YDZx/wUmcHNp5pcFr85m5SHi1uMbL/KJqDcb/c6lpWkaQ91aQzvTlLW+smVtOFnRWVF6QtkZW/DV9xxlG172iz8JnRzF04PD75J+PpMovvxvSGtKSKdwQuqyUHMaYq7J3ef0pYsEr9u+MOeac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=qNJSzotH; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="qNJSzotH"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 5169LIih3525916
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Feb 2025 03:21:18 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1738833678;
	bh=jX+BsNnJhq2mryQxr8s7JIl4isTBBIXZ+aJFSDZ21XE=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=qNJSzotH5ss/CdG3DNblTNxg3K0eTxfR8+CY5xkuzeDL95Cj/lpaLsIAkzRgSrs/R
	 aFoMJ7SRxFi4QPAEf00KyDjuJUvm+YTDbBaiyB1csaUZCob78UGbN+cN7pOgt/hJtJ
	 JmfjLiPiSURdKCE7gsXMC3EoCmMJeIMNapnZ98nk=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 5169LI3b023406
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 6 Feb 2025 03:21:18 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 6
 Feb 2025 03:21:17 -0600
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 6 Feb 2025 03:21:18 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 5169LGFJ129535;
	Thu, 6 Feb 2025 03:21:17 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski
	<krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Catalin Marinas
	<catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Vignesh Raghavendra
	<vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Kamlesh Gurudasani
	<kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
Subject: [PATCH RFC 1/3] dt-bindings: crypto: Add binding for TI DTHE V2 driver
Date: Thu, 6 Feb 2025 14:44:30 +0530
Message-ID: <20250206-dthe-v2-aes-v1-1-1e86cf683928@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com>
References: <20250206-dthe-v2-aes-v1-0-1e86cf683928@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.2
Content-Transfer-Encoding: 8bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Add new DT binding for Texas Instruments DTHE V2 crypto driver.

DTHE V2 is introduced as a part of TI AM62L SoC and can currently be
only found in it.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
PS: Please note that the dmas option in dt-bindings is subject to change in
future as dma driver is not finalized yet. Any updated changes will be
sent in the next version of the patch.

 .../devicetree/bindings/crypto/ti,dthev2.yaml      | 50 ++++++++++++++++++++++
 MAINTAINERS                                        |  6 +++
 2 files changed, 56 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml b/Documentation/devicetree/bindings/crypto/ti,dthev2.yaml
new file mode 100644
index 0000000000000000000000000000000000000000..9c871fe191ae0a3341d047d4565ec1e1bf1f21ef
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
+      - ti,dthe-v2
+
+  reg:
+    maxItems: 1
+
+  dmas:
+    items:
+      - description: 'AES Engine RX DMA Channel'
+      - description: 'AES Engine TX DMA Channel'
+      - description: 'SHA Engine TX DMA Channel'
+
+  dma-names:
+    items:
+      - const: rx
+      - const: tx1
+      - const: tx2
+
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
+
+    crypto: crypto@40800000 {
+		compatible = "ti,dthe-v2";
+		reg = <0x00 0x40800000 0x00 0x10000>;
+
+		dmas = <&main_bcdma 0 0xc701 0>, <&main_bcdma 0 0x4700 0>, <&main_bcdma 0 0xc700 0>;
+		dma-names = "tx", "rx", "tx2";
+	};
diff --git a/MAINTAINERS b/MAINTAINERS
index 0d65aa9093f63ed8f09bee3d6f31fe6d8e0d16b6..e3a32533cf3922d799439b14453248d23350bb18 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23433,6 +23433,12 @@ S:	Odd Fixes
 F:	drivers/clk/ti/
 F:	include/linux/clk/ti.h
 
+TI DATA TRANSFORM AND HASHING ENGINE (DTHE) V2 CRYPTO ACCELERATOR DRIVER
+M:	T Pratham <t-pratham@ti.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	Documentation/devicetree/bindings/crypto/ti,dthe-v2.yaml
+
 TI DAVINCI MACHINE SUPPORT
 M:	Bartosz Golaszewski <brgl@bgdev.pl>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)

-- 
2.34.1

