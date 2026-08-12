Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD39450401
	for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 17:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786557075; cv=none; b=Ku1E0ndA70M6NkzbnzSm88oh9Olf/JP351KqA0T03/E4/PXveXV322TZuPbCGM7SAubmoIJo+yGH7dYKRob7r2FmfawlS7X8bzns5e/ou3BH7JwXBVg7qyMBkd0RlROHZ/+CA+BfTWL7/e2C70YSiB6I/IEjD3NU4saLKCMaRn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786557075; c=relaxed/simple;
	bh=HugAla5NxeGvUAW6ybPWIq/99Qvbl3GRpGgOPmECK8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ax3yqDFDiBumQ6AZF4N81vIheTw6FtMz7X9L2AChrK1tpvY3NW2cT9Y1QoYx3jA331OFihefjITb8GLt9IGHoLcuCJi9su/QnhX+sflTFTdugpdcXpaiOCOoBErK2tZ9waEjmoJcgAko28lleeXAMe5xrccXLu7ig/3CsuYrjf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=eYb2/InX; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="eYb2/InX"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cc73e322dbso16777655ad.1
        for <linux-crypto@vger.kernel.org>; Wed, 12 Aug 2026 10:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1786557073; x=1787161873; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=eYb2/InX0tN6LvnVetGYJZIaVlBoINmN2iAPelG02FqTUSRfoh6gSJlo9Smxvv/+Qz
         7eBLhFeoj3wtFGodM17o+Hd1VGcYUTIE8CXa8GPdfwozpigk5R6UKs1yLVNlr97G6OAW
         wM99vd4+rkunWwx7UJPuJD8e9McXGMMHfJgPk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786557073; x=1787161873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=AxWCwfKQn0yIb4nfnJLOeYFjn4KlG9qJss2BXRrt0qUZR9d58JQMlrYlfke09uPPAL
         h59axy4TI52qZoqvxhLVQQdMlbgNbNnMyYM5Nq1RlxoeimZYI4P5xz17orOP9hEqhP6o
         Qfb527Z0cdLy6WGV0IDPySiC3oaaG1dN4t9Ty5SkdoSwMaCpPJh3vGcqZjdTMdYa82k9
         2cmU6DdwxELZGE77RH0kJFKDTH1kb8c922rs0qWXockE4jagzF+l0fjTl0WQOWcDn+E4
         UK1CCHA8hnt+TwOGWtKFvxRnt5mGhPEenZMhb8lSHJduuSEEPSybg04YbnFffwnIZNI+
         xLxQ==
X-Gm-Message-State: AOJu0YzHc3JxUDiQ4vmK6dKg67WCmN73lcOo5f3I8dVrSrf6CcMXEg8H
	nkzs6SwfsZWSOAEwqLYJ+PEJjppYVivPznXMd97jh3DHADinIrTVRsGI84ML+dGyzzFydTfK6vU
	9jmofTQI=
X-Gm-Gg: AR+sD10luFpysMxDxJnHdDiTpDvKXpkur4NXGhgoGoqp8lkXcAj/mkHdpdxWGxH0Ch8
	d8+3/Pp+glwb9ID9cjRAEYa6PFXvHnx9arKKUZd2wfUcC2ImHFhBs8om4qGjEZSjccebJ1tWZJ4
	iiisZDDCYzUkVAmPSTwQzg+FlEmGe4GDq3U9YPCgkYDfisWlSdCxYhXhZ3xkFk7TiCZkz23Hk0q
	o3SFjw9RziqUOOW22x1Bn6s8rltjiG6+b50ED5UbtJeV6+cjZSUpmwn9o8b+gvn+NN6xXcETDip
	IPUKEEwkAUpE6V8UZtdo5kKZLnQ5YQFcSMmBwiyFzH16LvXXCJr3trb5FQ60vC8ddWUi7Ee8VdN
	3YfXGmRsyns236VKC2mZq0Cn7h5Bir+7fhhZye8qVDAQotBTIbeHJooGpO0ZLOJNG85ZxbeY0sc
	xilUrApJO16PuHh+BLIONcMm9RD3dQh0ILy11t2SLTxOULMmKFDECe9S/buunxKHBAGRQk01m48
	f8snggHRRRQ94kCwPIJq8rBHoZxBCniQKn+4Y/weelokkgycTY4Po9w6z+/cBkdBmCDhrHC08FD
	dDxtssuzyqJiaLBkiH4IAcydtCO1
X-Received: by 2002:a05:6a20:1605:b0:3c3:a9e1:a819 with SMTP id adf61e73a8af0-3cc552bf23dmr198878637.24.1786557073610;
        Wed, 12 Aug 2026 10:51:13 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141245540fesm18482258c88.9.2026.08.12.10.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 10:51:12 -0700 (PDT)
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
Subject: [PATCH v22 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Wed, 12 Aug 2026 23:20:17 +0530
Message-Id: <20260812175020.666558-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260812175020.666558-1-pavitrakumarm@vayavyalabs.com>
References: <20260812175020.666558-1-pavitrakumarm@vayavyalabs.com>
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

