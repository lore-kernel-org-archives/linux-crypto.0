Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D98357D10
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 12:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783428842; cv=none; b=SJFN2V0X9erxuAjblcWTnRoq9eenf++Ms1jYi4Y0rZBda2LxlfPJ6INswkUeaFqHQbayUOHm/3FEcys1Z9dvrc9mFedZ2/LLDL34QXvOq3YabfA9amAMgqexRLEyGjOTQATlsre3p764yL1ba1C6jr47RW9xvTROcE1Nzs+83EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783428842; c=relaxed/simple;
	bh=EjuF0ELSTrkiKLRleI4uqXD1+TO9XfuqJzol5iOj13I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cp7+Mc2KcJTr+ctgglXt9q4ihCPT7pDmgzXOejFdnV80WCMji4iXgKj/jlHqFG7BOAEmiSwVG5vh5YWv8OLsk6/1wXQ939IMJMtqtvWMxXuYx9DaX8S7g99u+7Hppu6zMO6iRuNIX3gAm4W1QC5hrYoqZksw9wU6amC7Twt/UWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=ZDvgTNc7; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="ZDvgTNc7"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c8fee9f63d5so2303048a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 05:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1783428841; x=1784033641; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4kx3Zw6tOxJTm94LnN99zbJzvwBuruxhjYqu5k+0DmQ=;
        b=ZDvgTNc7AXADVIryCnfao0uaYwi+vfpLKcUKasaKRNtibJtd9RdsgX8yUShX02TLd6
         TXvI3t30AGI+gO3OA8EOfXa+DtbPNmbxGpp+4xTKSkwo40dd5n6g1lbSD05AQJ7QZZxJ
         lotUIe2WEVnDf8ynz7V0p/LdDrE68GI5CYz7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783428841; x=1784033641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4kx3Zw6tOxJTm94LnN99zbJzvwBuruxhjYqu5k+0DmQ=;
        b=UrHBqeA3dpPTXlyPlC2VAMagvbG+KQ7dNGUBwFQsl4/j+z8TMm/qhEfpvcrZYS3rc5
         4GFyRNnhUGRDIu+QRa9rx/2xFA/ZItFKdP8prP1LZtxwpYjUDU6XDTVwrwLemR4XUzsJ
         +Mjr7O60/HCv24IJf0jFiDpKvOrBJwiBWnWGKmnIhUlFuAix5RP2U/bs33eNWZtnFUOw
         gsYcRZUV6fDMGG3iZF/oXGoyzwijEsCs7UgeUhFsNi85lGOOYchCelQBjAaMcTIpH4/4
         XzM6PyCYofqnjO5g4rplYY7fdWQcGDc2vfadlRSBUyMTWBtL9j4etvw7iT/KD8NUpJ4P
         pOsQ==
X-Gm-Message-State: AOJu0Ywrnss1p4TFpL63XgWnYTfnciKmTDk6eNkFY3Z7M/pW0lqzS2I3
	IBPD7PKA7yzuS/s416ND8aq9SdxAQA4tWl7y915lvx+s2DGCAm1no+GmRHXWAD+g0oNW8jwGzAv
	ZhPmc
X-Gm-Gg: AfdE7cmXZpXVcVtY1BsEERW2njeLBn8jXLvTXDcHANnwrUfLI3DiqQnTsK9TDPolC19
	fScYVIpNQnre6vhCdIA5dUVuRmC3zhRIPnkp8n+HTY6RREsoyiIURR8Z+YhtrPi3uTvUEuZ0XAk
	/3AP3s9Eyinb4YHJgyMcvzsapUE4MRQO6dHRaIiM2LrOMr/3pPQizl+unEcKWLTf75M8s1BUFgp
	QxnlT9L9kEvNmqdXLXtd6YsRFBXEP3ManMy9OcTnHjwXYRFicyzo+Wm/Ao4oz7L2yGer40Pfz2u
	p+snegBivLxgIAsyAyB8AdiaQemdaIuLu4FYw54ATXnCk5fiH+3elJxXbNa8CFLgpXlLFbe+Xr2
	MYc/6mXdTjHD0sD7gjtcj7YZbIcL7kUc2pBdxHr1cLl/f8nQW/bEv6x0t/yNulmgAUKeLNpOXts
	VAH3M5tgOf2kz11HQcC+UE2jo558WS7+Ztth7U7eWlSt87BDrnwudhsvbqAsZbBKU7fM2zH3Ajm
	IiJNSDxVdb//wEPhQAfLNUSF6pyQQR7c5O8xavrpLSk4gqsqqJiJzadNcDDinAPfJs=
X-Received: by 2002:a05:6a21:62cc:b0:3b3:241f:66c6 with SMTP id adf61e73a8af0-3c08edb777emr6445113637.26.1783428841051;
        Tue, 07 Jul 2026 05:54:01 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b659fa13bsm7945671c88.15.2026.07.07.05.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 05:54:00 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk@kernel.org,
	conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v16 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Tue,  7 Jul 2026 18:23:08 +0530
Message-Id: <20260707125311.2398031-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260707125311.2398031-1-pavitrakumarm@vayavyalabs.com>
References: <20260707125311.2398031-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
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
index 0000000000000..fe33ea361a8e1
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
@@ -0,0 +1,50 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Synopsys DesignWare Security Protocol Accelerator(SPAcc) Crypto Engine
+
+maintainers:
+  - Ross Bannerman <rbannerm@synopsys.com>
+
+description: |
+  The Synopsys DWC Security Protocol Accelerator (SPAcc), which is a
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
+        reg = <0x40000000 0x3ffff>;
+        interrupts = <28>;
+        clocks = <&clock>;
+    };
--
2.25.1

