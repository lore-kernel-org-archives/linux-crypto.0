Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3293B6364
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 11:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786448084; cv=none; b=iMsEw9iO/0dNbPc2VdkuCXJKq+gJt17n556v8iDUez8UlAIMVNSNVNS+Utu1J84yypt1K6E7dQ1w0xuLOAKf6bOSExJVeHOivJFnAJEFN2+j1ujlCMUuMEtXx45vIFZ6q0bMk72vtbqa3NTGaVrtJZFTOe4vdnsstAndN0o6x8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786448084; c=relaxed/simple;
	bh=HugAla5NxeGvUAW6ybPWIq/99Qvbl3GRpGgOPmECK8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UaOczson/Z9DwAZjXzkh11hkDFVnSJTewVS+9kE+Hpujt+UcTdrmAOphke8GqDpMphvL/pbp7EAiPrtpe0eHulf4zdrhItdSb+P/yKGJOJi/MgI0kCO5/e0qIF5U4oIEQEM10h1soFg5okcvMSM4xPOqWbepN2ykMA4h63Jb9gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=VErvF6rh; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="VErvF6rh"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cbb7926836eso2089012a12.3
        for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 04:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1786448081; x=1787052881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=VErvF6rhBQV52HlRwiyNV6MTZbdTOJwQbw6aPjS6ME5Vweg5M3HbbK/1mv2lDo+JqQ
         18UUNQXQchZdRty/jS/xktsClNFtoyt37yrknYUR4lGdQFMEKev3qX08wELEJMeXxj8Z
         uknysr/nCcNi+qe9f9MgoeQg1Sx3yYE5CfGK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786448081; x=1787052881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=j/2PdgmVIkiW7XIGkKbHhxC//7oMx4JcUib2zfDWdQvYlbTsVdiv8JgtXkSm/awTif
         5V5bGOSrL3oaTpzVsuN3TpvSxYH+d+GtYIykJlgeSFLW/yBD/nvnk3u24v0nUPlUMr1S
         aZ2q0KeorlaGVVg3rDYRQfPHmZloribAmmm80/WUagfxGjVOqhEVy5K1UU30uK5Km/LN
         T0/oOrl8g/y/+DJRUPuN37qH6LUmiodU/n9b8vA0ssY5+5Smo68HCs23t7lTizElG4gB
         i5kXV47d03yTaQ+uev4S/gUF9pB0XU1QRbBif32Tn0OKqMghAFBZuPqrx6+Lgu328yWw
         gLmA==
X-Gm-Message-State: AOJu0YzdKXQfROZ2MJW+igDImt33wwecXtZblw6u6Nc7iIFbMLEJt0r0
	fmD5D343ll2d5dxD6kd9IYs1rB4fRJyUrgAzkf02q2oX+XAtjm8YEsdkkr1x62C5dy87yHuKdNR
	1YmfCReg=
X-Gm-Gg: AR+sD12f3ux2ic7VQlnURiU/pqqtB4KB77gjDGIK4ejf8/vNQth+anMyziIR0jM0Q38
	dAscoadHu3EPwu+n0oBCEUSuqRos2cQ8byLkjSdkLDKV8wWzyS6/VQSQFQEiq0vU89a9oylBD9n
	ycETnj47dPasvhmOITHbF8fnioFggM6S2p/8pCwOBgcy5bnqfmkxZrta+f+plapk/gtVuWHEabr
	xIDPFuGdkpWhw5lD8IvVj2AKSpxFB3XeTqoUDWYCa+QTp996dSCn3r4Gth1mO+7O9CaOIB78Vle
	1LWn8mk6LHAQk2PUTF6YsWonHxha/IlbG6fGmnO35AFIdTfSP7NqIA+fd8vDbxkmcHvF7Hy0OVg
	cA1aiuRVdr5aCEHH2debg+j5suX8ST5ETNwPkIGVuDZ0/qeH3NVuFT4bg/JMw1m3QHgUs/3CmWC
	y67ELZgJ5jyEF1MSKp0PMQJtpgPenIvLvGwCWzugiVrmJUBQrVC0v/uUC7iPfvDnYE/Cyreijqb
	P2B7ISJ07QAxFxplrQT5+uH1AdJ1Edesb9XC1Czbjmx8Aw3ff67im6p061xtAzLxeP7uD4nn8nD
	4/9VtBTE9oBtLlAvDr20wkqLW+rT
X-Received: by 2002:a05:6a21:6005:b0:3b3:1b38:d9c3 with SMTP id adf61e73a8af0-3cc2b8dd9b6mr3789115637.4.1786448081272;
        Tue, 11 Aug 2026 04:34:41 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1412035e08dsm4983584c88.1.2026.08.11.04.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 04:34:40 -0700 (PDT)
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
Subject: [PATCH v21 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Tue, 11 Aug 2026 17:03:47 +0530
Message-Id: <20260811113350.632737-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260811113350.632737-1-pavitrakumarm@vayavyalabs.com>
References: <20260811113350.632737-1-pavitrakumarm@vayavyalabs.com>
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

