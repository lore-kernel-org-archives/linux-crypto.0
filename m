Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686D13033CF
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 11:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771501314; cv=none; b=k9y6Ko+EW9KaOrvgfbAH2H2rQnIR5rCz20lwf6FBNVdjVkWaDezgLzKC8NRLUnbU/3M1Tx+QG3Srpw2LJ2q1PmxL+LliTD4ZCxTFX1PqjlBwPtdvmnAbxnGMydIQQBav6r3h0tF92pZ3/BAFnQnSl4OhtAkYQNqB5xigbcJ3vRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771501314; c=relaxed/simple;
	bh=1rCkpkHyHE3IPuAx81k2bwmc4nwhuww71wQ9MS0fnZE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dcJkF5KWSEkhS/IIdp1LFknfApRzrp+I2kbVC6Jxj/Fb+LfllYsw7Xs7Jh9NpwBLWxqAyBvFaRk9hre6glVLuWYs3gAzsZiRPlfn/6YTVAGNQX6ml7vkMLDo2cnKaMj89TCGE35MdXZRm7zGC7cHoGxHfGIDOY5hcUrrU4hLilo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=g+eMhbPS; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="g+eMhbPS"
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2aaf43014d0so5751045ad.2
        for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 03:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1771501313; x=1772106113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3WO3LsK3AW3by8XZxWRGcuY2BsjgbgR+h9RmVDdaQIY=;
        b=g+eMhbPSxdYoyNcYp9yBsWjIvVdSW/veIgXfaDfM5rVoBDS6ghPZv+CcNGlynJKK/M
         TVmoenvgCfIxV6sjUV//fM+blW6EYDpABbiCZbtVKoPWTQYtNEDJ45gc/w9zHPX/4FoZ
         84DVt925dLHODzB1XygjVsCGAeF1aTJzMn3tA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771501313; x=1772106113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3WO3LsK3AW3by8XZxWRGcuY2BsjgbgR+h9RmVDdaQIY=;
        b=PnjhPKuJpqn0yfEuKdNlWay/MSgx7KrOSEicylJegK5mr+xLDLZ9RvJCUjJgqQxzOf
         oC35KEKDTWBAqF3JimJcDIQ9xMooI+Eqq+zohbn1R8ICRqA5uJ8b320IuE5J43phCvWp
         wGzxVWXFfdCA2Ro1gM8R+sfPsKPblgS4Ez+bJNH5kGuJH56s9hqOXiZ5lcLZjYWBwxaG
         5EcNb0RpLO5xacgZ3pQxoPsWRtR8d03CVRIpuRfF/whPdZ6mlZlmULXuvjhMN9aR4aGA
         ixf6Pz5vHhfQ1g6kKqOi72AC1jrqh6pMCSDqb44+vHfI1CKrlOrwPa6Y5qpqVmVXiNsv
         0qUg==
X-Gm-Message-State: AOJu0YxpjY9RnX9Gx8KNKNtTpHuqi7jIIBAqxBjp3s870rOCc9znjkmZ
	oJ2JyMu4TOcGJxPrFWA9MnXLanlE8Q8LQDxexsLjo5CFMOOE5+HjP9Bb4NgQDP/uY3wwfoa86sa
	iH4ZBTvk=
X-Gm-Gg: AZuq6aJKanPjrKr5HGMTCaCu/QXeDRP5P4Re62DgolbDNTaOS/qXaJhl/95F7aI9hnz
	4MzVtRH9yf/7CXU59reH8I4RZ7xF2m4RuudLf08tI5pUd9vVRHkh0K9pEV6LptnYK/pEiiAYwvJ
	KehYuIMVq78AOc/nXk/moHgR84NGer2/qWx3s1i3GnMCzjb782oBL7g/xyO8h6KtshDYslubrq0
	lBMj11YnqcX+Up/8LacYEZ0h+ralnW9LliMPuGdHf8oXlOpgA20U4qZJrCKP9gw+ZMCpYZeZZ8D
	i/sSNW5Ev7QB4agzfxXQH+d4nh171Ezj+/8fOEV1NuZjcqtIliz2rBjovgO7p1n1ykBvLcj0hgH
	b5CSvITO//7VE5gLcEhFhDAXh0XpcPYGiCrqMd+O9hp9HakYrwv8T+VeLAOjjZwh9hLsaRyruzU
	1lNyCveLnmGMedQyM+/km+dDA6XRLNJexMwBPXWqTBZL0jbVVobmV0cBYHZKn8pH7arGI/6yY2O
	6ALWssmr09hzZ/UwBja5+y+jpOBEn22IKMue4/2IWHa0SzXCFKiIpamBDPGW5oW8fI=
X-Received: by 2002:a17:903:46ce:b0:2a9:4450:abbc with SMTP id d9443c01a7336-2ab4cfbc9d9mr241204505ad.26.1771501312744;
        Thu, 19 Feb 2026 03:41:52 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm27442358a91.2.2026.02.19.03.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 03:41:52 -0800 (PST)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk+dt@kernel.org,
	conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v10 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Thu, 19 Feb 2026 17:11:27 +0530
Message-Id: <20260219114130.779720-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260219114130.779720-1-pavitrakumarm@vayavyalabs.com>
References: <20260219114130.779720-1-pavitrakumarm@vayavyalabs.com>
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
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
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

