Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1C638F941
	for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2026 16:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780592005; cv=none; b=Ax3dhdFOJb3Q+D/FrFyAhJj43S0yWtutk2pOSt/7Ft8nYKNYc8vQXQXV+53aSjO5EEOTjtF663MqOOOqrp21jVnTKW+MPj9iy8uHTven5s13FT91Iq3iAMzpGElT095d/DAqJingv6d9AnNIAG9ciMhgrdJH8tOv4TDiN+3PH8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780592005; c=relaxed/simple;
	bh=Pi3ty6ZmRfghCtXSjpKIOPSmrHPKajEkJKBaTvA3JEQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LQbRsM8TkbtsOg3GNaI6Y0/8Ot+CX+dFkaHsWK7Cx5ywi/q7VDafxeqwZ7BqCzBOKiJi7VI5ZAVa5Fpwp9prnrWXNknlX1aJd5mRtHZknSXlkboKy49oXaJ1MNaDJCsxsc7aX3Ng3VB2On9+s74byXdduOSQ/PyZFmruPLDqw9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=ALMPXl0A; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="ALMPXl0A"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-36bcbd7821fso447918a91.2
        for <linux-crypto@vger.kernel.org>; Thu, 04 Jun 2026 09:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1780592003; x=1781196803; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kztFs1HIc9U5D80MFSQD18XpUxKc9TZBddnvGjYw0h4=;
        b=ALMPXl0AH9JwrU2LXOf1dd9lK97CR5eGjR9dEHvEPdI7QziHCe5pVN64lhArSclXCE
         bKRF8zuz/7BcjEPq1ncQaopWm6BT3hCB44QmAbaAbRiDWHHG6s7gx9S9Ox/8udpLnBge
         vJmCsnCxk7U9O0C40xUzzR6MdY4OEXDWVjvMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780592003; x=1781196803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kztFs1HIc9U5D80MFSQD18XpUxKc9TZBddnvGjYw0h4=;
        b=gSbf0kMyL6gm7vAYDuAa3lY4JFfSwWz8/E2JUr5MJRdpYXKeQxUH31mIdzoGiwSkpu
         XMK8dHgaLm5idRv5VuGmdz8Aj75XNRmKDO7U+5cSHr9T/iW4pPlLxt6DJ74+LDigD3tU
         zg2aFQMLk+K332dTi0TVW8CpP4UPIKzOYkgVBpPvT1SpKjqe4mo0DVtslIXeBLFfsiFk
         NqraaA3bGiQMOY+Ey2MEAglSIJ5cr9ZEvcCiUEU5NcT65xACA9/sZpMu4C4LVuTWoe74
         kXznqXOEwCkAdbkwr1okW4DTnN8EIuq0ijc33Z6pXQMCmOy4VxXvHvx7Z2k0+XL33uqo
         +Waw==
X-Gm-Message-State: AOJu0Yxel1qM2JV3WkiNesYUMxHmLsni6qQgOsSaNE+WInCRyfu0sIC2
	R+OEPK0Go+WJ1KRCFATLYyxDnUGJTB2YAv/BLIjrxWIo+8H1BJRi2rLX14TP2pjJwCyocXi5nxT
	tPJBU
X-Gm-Gg: Acq92OEs3nPc8W9Zlwyv66B00NYgmdX7DAfhxHROLB8XBooHUkB3WZl7NTIRw+7gXKu
	ZnrUxv4SqbHtMmLqnQJ7fe043eGUE6QfdSFme+cQbdBfXp1Vz02Hgl2954422/+DxFmlsudx7mC
	8plDgJMVJVtmlNMH52zWPDr5dqeShcoA83bTg0dwgrEv9TTep4L6XlKYdwu0AEPZ0AVA8wg1vH2
	Y8OX4KTMyJ7nibPnub550qAprmH4o+740srP94apsV34IiePawV5wUG1RckcsBaa2ugS2VY6bRd
	IwnXy9syj2tatxAJbwf2nn1RhRVaLzRvK5t2QQgTzbxF5BmNxw98/CgoCaLZ0udKCRJ/o8EhxKm
	vuVf7A2DQ2F8XPvL2ID+v6ZA/aFqNMeBFNbYu0Li4TBYJx3D9denXIXxIsn2bLvBKTzLyvEE8K3
	nLUlZkxQpEnR2pqyOI0FKQnXEAkzWtxUm84jjgIx68mmUdepA5GLOA3bs/2Z33NAy785jRyUHsP
	SGQLv7pp/pBnnJb24ewko2iNJrii7YzMqdZqux9lXS4tHRSkDzgJDq+YqguWH9vPNVgKOMXQ+vx
	dw==
X-Received: by 2002:a17:90b:1642:b0:366:1bab:c3d6 with SMTP id 98e67ed59e1d1-36e30e13143mr8349487a91.10.1780592003243;
        Thu, 04 Jun 2026 09:53:23 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f711e7b53sm3689229a91.14.2026.06.04.09.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 09:53:22 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v13 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Thu,  4 Jun 2026 22:22:07 +0530
Message-Id: <20260604165210.1141842-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260604165210.1141842-1-pavitrakumarm@vayavyalabs.com>
References: <20260604165210.1141842-1-pavitrakumarm@vayavyalabs.com>
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
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/snps,dwc-spacc.yaml       | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml

diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
new file mode 100644
index 0000000000000..857e5c6d97fc9
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
+  - Ruud Derwig <Ruud.Derwig@synopsys.com>
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

