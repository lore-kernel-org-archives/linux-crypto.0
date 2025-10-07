Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB682367CD
	for <linux-crypto@vger.kernel.org>; Tue,  7 Oct 2025 06:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759819849; cv=none; b=f12wvcDSR7t9LyGIbdJ72dFS41fWtdEgFGD7lIvRRYmztsCVXGIijqBWLFpn5TsQ+yDgmsbvrxAoeYQUXzO39ydFg3cuPrtQs2MhjT9BDQRza61HvSJ+lWq/i5UeH8ay8EcvmptsGoxHGJRezqZ3Tlh6o6TcD3GySD7VMNt8P0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759819849; c=relaxed/simple;
	bh=VqneJzSj6ZAncie4Pm4kr22vBIPcmTH6MVSrCpJuRgA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PGuFQ+joDxt2nwx9FhvZYkcb10/0Psqy8+21kd+mpimsMfp2KgxGpq7d/jiOfeCvbSYlxMW6t0pTsbFTnVgUehqFHDNiGM5KRYeUKECYckoH+BQxWPJxcI1PCWRb6LpqXW9UAF3QgVtbCnrYCHW1K+UiT1nquVfgpACQXxrxP+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=SyLl3MJw; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="SyLl3MJw"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-782a77b5ec7so4925932b3a.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Oct 2025 23:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1759819845; x=1760424645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhMtSPXj9mr8UNmQXgxlkL8r6YPZnmm760J+NfJOOMc=;
        b=SyLl3MJw+2h4+xzwCacvKjyBJaPCgqOYk+vXfeSgM/0RIa4+fhE/kzw6Rpk041oc0f
         yyDPu9YMQ1YVO7b44g93/FEY2QHwF2qS7k/cplbAPWnfAmJz9NVbY3MNrPVdIIv0yjFU
         b8Gg/8CK/iZmFf/qOMcMbUcwAzALsvcPvCQro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759819845; x=1760424645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhMtSPXj9mr8UNmQXgxlkL8r6YPZnmm760J+NfJOOMc=;
        b=AeCfmV/iYxvyXl4SYSuX2lPFyZY4xJJ4zrmHZ7/SLMSm/7wawlsgdDbxG0j2blSMoX
         w8qKSkb51tm6xcU4ncFGV0NLdC/0AsPFYr40zmsLnLNC40SRIOH06UULDeQcrDxUv8/Q
         JFTVRrop2adHlXQ2EckLiSBSwpnRoRgM+z1OYeehnLsMn7GKzKghTncqsk011vv8bblR
         /qx+0QAPsoFzCgSmv2QFf9saGmgKwbti4ARq9xsOuDvejvIB9TbbZqQ5vGXLTPJQiMMe
         2fjx5alLU1ePO4oxOBAKjBfUYSU5p3tfme2DE2c/8Uq6mnLc27wlmBXblbyJS79g69YI
         TUjQ==
X-Gm-Message-State: AOJu0YylaR93PStlO4PvXRYfq74DkF6k5GrG8MYtJzzzPfJApehNikE4
	RkV3y3u20PUwD1FbhMXzJ9tdKXVxJDomtYRzZsH5IS5ig1uWGi6G9IZ8l1Dka17XPfzLDcZAwj2
	3pmlr3p0=
X-Gm-Gg: ASbGncvs1QSqogQvzVNZ/IpMyRDufvB3H8OXRilREutR9RRuLiRe9VlSKYGGYna0LsK
	2kKy6H6hzWmRS0aKVy/y+YSTvIYXOxviOVIfbsW5ln6gRXMWvOwGfXraHtFoNz4SxB3WKHLWsZx
	6fC095pIPvGNE1LfKIMW5mvNo0JAUsYAkkNvZSO1xgTIAKyxuNxWQwQqhv75ptBR4aa6RX8BKt2
	vh4HwIQxqnmNo6ERudhnqSQB8ydqioaMpKz+tDoLXoE0YB6jrdgL2NskOgnv/3HEz7CaJau/8qw
	TP8Mcd6EJiTocM4CTPkJlqRXTzHi0nkCZHesHcGpTXvC4bAK4bRfNJC275kLI4Z4NIzjamVd7Oy
	BhEg+yv86anwsljOskxSzty6elNY7Ik1nEdx0NPtC3v7L/xoa0/WYwabd7TcONbshUdZd3g==
X-Google-Smtp-Source: AGHT+IGf7z32DL2yDGcqvsmiE5xqAs7tlYdtwGe0SR5ZFDEoNImxi7NJNP6k9amo0/HQU06aHxLepw==
X-Received: by 2002:a17:902:e74b:b0:273:240a:9b6f with SMTP id d9443c01a7336-28e9a61a8damr203146785ad.39.1759819845150;
        Mon, 06 Oct 2025 23:50:45 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d111905sm153287745ad.24.2025.10.06.23.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 23:50:44 -0700 (PDT)
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
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v7 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Tue,  7 Oct 2025 12:20:17 +0530
Message-Id: <20251007065020.495008-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251007065020.495008-1-pavitrakumarm@vayavyalabs.com>
References: <20251007065020.495008-1-pavitrakumarm@vayavyalabs.com>
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
index 000000000000..857e5c6d97fc
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

