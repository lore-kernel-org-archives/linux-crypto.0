Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F5E50EC0B
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 15:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788796790; cv=none; b=V+ECA/QUhU8amEpzPUsfvSR0MpFXcmQZF8gW7Vp0ZrhEQ0NzJAatMK5PTWnJv6mC4rrfRijlixR8JBxoD1GdTSLPSkDjE2DNxj2u0RkK/+oabuqQu107DGGDU2J7BhXZpckupCi2i/jfwQSjaLH7wDY4fUIX/WuBl781vRinOUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788796790; c=relaxed/simple;
	bh=HugAla5NxeGvUAW6ybPWIq/99Qvbl3GRpGgOPmECK8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gLLj8uaiBd/Fp9OIHxtAAy6lBEtL7qfNOkU0WME0Of/LmooQwDAhrXkBQeglrHT0QaPsHL3/ffyBW2D2EB6ln8yuPUTe3Xl7mhgVUOv+d9HVV6Mkjk9NSr3c8IZKf6eeoQOp4vXnRPdCeGfOuzQeztATj17DBCM3qZzddEp6oNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=fUxyUEc0; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="fUxyUEc0"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc2276e6daeso2548801a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 08:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1788796787; x=1789401587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=fUxyUEc01BXFtmTy/ckGKDEEOi/5XZp+l3Qn0T9V/f4bMOEwuVHk1y2izjuNlTmwHi
         nmXq8sjtFYVugcJrQrDzjysRVuJdjUlp/BZ3faf9/C5M2vQKw11YM82enROjCiGABOhN
         9q3SW7KTKz2E+uFCm0XMCA53euMAuKJ+RzDxQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788796787; x=1789401587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=PRx1Cihr2b5x89x05CP7lNMHJ1iR8UmY3Hz1RF/1cQNdKr7v7XH+GX1dBg+pk52Mdz
         NXGXM+AomSz8uXa+2HjN1Thre+NtEhZAl5PYnxBtJEkxiWKg75ao3HzKfjIzHZcNGl/u
         tgz5LWNgCPqlnifNf3p21E08O06y6NtWG329vJ+h3VrVu0VtqePWHdtrw7daGQ2eJ5RP
         1xS2T6m1Lw7BLj6w5/+XwJBZ/jGxyr6BITedD6Vhck1AGFBhZ5l8wx284KB6HC3xm2Hj
         4hWU41GaCOwKQvIn+Qb8EJtxwKovt8P7lWeVEdnkt0Fk+dWr/GZIQzgv95xxRiFcHoar
         6yOA==
X-Gm-Message-State: AFuF++kOWLoHvkrbAbHWD5Hd/BX/y6bfaoWlW2xWn7z6e1MXIvSIGzrv
	WShsMPq9TXdKlOtFzXUcDnvq0HAZkWs/OJ2wNeV5ltKoIOiyC1LU15jg33uPcOKKqZTsedMEHzq
	NoDi+
X-Gm-Gg: AYBFou35A3AXOK7ruae2su7HaQyevlEE/rnai5YWJCtBxsOXAibcY94ClsQKWHfzadt
	C6bAeJRgha2x3b/K00EQRwexlOz+Iu50OkogO5pfDralyeiwNNZL4UhaSJeIdaz6bt/X8ejsvMR
	2LDWU/+zqD69w+GUz7XEbZFhUlVXIlKa+iiZVh8n9QsxfwGIN+C7hiR3f4SjkV579ro3MRohu1I
	eBKJ0tt2ljMlIQUMRVNuggH2+evQ6ab9sp0pv+dzwhH5a/vpxwIouKewqZ27n98C8nLOCmChQEE
	7EtkvihXRqXktaSL76qLTOBlqM5XlFnK8m0CwpM4+BXuDThuttXlrGb9YULrm/eywOG0KHDJFpO
	sjoAHl8Z6h4WKAixY8hEmJd7PbXJjIlK9+23oC86Wl6Azm/zSPo+dV3zz20XnrNLDu6Pi9YmgKw
	QUUNteWGhhW5dRwTvSXUWRYKslBjWiKl7dilxoHJ3ya9iqqUctGuqOJBmIQv+T4OIsrEFakyxKa
	g6y0WH45TtQ++BexD6eWUyBe1XSv0UHFlLK+3gGnw8DdHbyQo21hwNtXnLZxQ3kLcCDPsES6fJh
	GEEqy5Qd27/vnzOZspxAO1fZismO
X-Received: by 2002:a17:90a:d010:b0:38e:bbf1:de3f with SMTP id 98e67ed59e1d1-39b26272ef9mr38980585a91.12.1788796786651;
        Mon, 07 Sep 2026 08:59:46 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm46065613eec.16.2026.09.07.08.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 08:59:46 -0700 (PDT)
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
Subject: [PATCH v25 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Mon,  7 Sep 2026 21:29:13 +0530
Message-Id: <20260907155916.999153-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907155916.999153-1-pavitrakumarm@vayavyalabs.com>
References: <20260907155916.999153-1-pavitrakumarm@vayavyalabs.com>
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

