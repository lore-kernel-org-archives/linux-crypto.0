Received: from mout-y-111.mailbox.org (mout-y-111.mailbox.org [91.198.250.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1EF1F91F6;
	Sun, 21 Sep 2025 16:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.198.250.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758471121; cv=none; b=BggxXyXW1qMHYigwqkmJ8GwtuLSVyhHWLBDK4s4dRU4b+c0+V9gRcGHh0j6q1NCac64vV+cRPX/lQtLP1OB6o6e4INFLgC2MmRf7HE3XE+xGPC0nVIH5gZRhoRDrRCCahfR+UW9m0P5+pLCRb59wzenbLTObsyuwZW20+xCTuqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758471121; c=relaxed/simple;
	bh=IVrEBq93I57sHkKBpKzLJwIv8WpcngwvrIe6Ij19Yw0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pvnxHsoBNb/yEo4NU0HKlB07A4EntUZH9hjiVxPRVyHIbBGTNbk3X7mibcjcGzW0/dfcSVYCOYd/78/yTQz2ajeNT2Ag3Cd7jTwHjCiXPvEXHoAuW5W2bg8wnY2wV31HrZpRF7zL0kHG5osV4UD/iyWI+Qfpu7IYOHPNKPZLHig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io; spf=pass smtp.mailfrom=kael-k.io; dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b=J/Gsn4i9; arc=none smtp.client-ip=91.198.250.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kael-k.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b="J/Gsn4i9"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-y-111.mailbox.org (Postfix) with ESMTPS id 4cVB8360TKz9y0k;
	Sun, 21 Sep 2025 18:11:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kael-k.io; s=MBO0001;
	t=1758471107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=e32bgj/ZkouP/y1c9EuzQEy6snPVu+L7GnJFnUo6h6M=;
	b=J/Gsn4i9EMikkA05Zg9B9/f/8G8vBgiNgKQikWmuqA06PXvbVMEA/CBFm3jJbbB9sr0mSU
	g4MXgskV/WHiD0zKWJYKuCfHXOLPidPBRyie5JCRn1SH4Mh2DWnoWU7Olvvw27l0aC9n0E
	WGN9D2anilpplvVbGb2wOibrpoQ3raLSiNE0ZCDVw2ie4FaHM06VnmljEvv3rV9mztHp0C
	x5X5pvvwliE8QiKKP6BaQPZ28IpPf4mIxWpMYIlB6WXa2eXrq4lJaal0Q/W/V621rmOWBL
	R7KcqyenGuwg+J6iu3Y4hXn/i5XIUGBMiPT7TX/qZKBhbZX1NhkkfmkXDZQU2g==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of dev@kael-k.io designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=dev@kael-k.io
From: Kael D'Alcamo <dev@kael-k.io>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: rng: hisi-rng: convert to DT schema
Date: Sun, 21 Sep 2025 18:11:34 +0200
Message-ID: <20250921161139.99047-1-dev@kael-k.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4cVB8360TKz9y0k

Convert the Devicetree binding documentation for hisilicon,hip04-rng
and hisilicon,hip05-rng from plain text to YAML.

Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
---
 .../devicetree/bindings/rng/hisi-rng.txt      | 12 -------
 .../devicetree/bindings/rng/hisi-rng.yaml     | 32 +++++++++++++++++++
 2 files changed, 32 insertions(+), 12 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/hisi-rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/hisi-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/hisi-rng.txt b/Documentation/devicetree/bindings/rng/hisi-rng.txt
deleted file mode 100644
index d04d55a6c2f5..000000000000
--- a/Documentation/devicetree/bindings/rng/hisi-rng.txt
+++ /dev/null
@@ -1,12 +0,0 @@
-Hisilicon Random Number Generator
-
-Required properties:
-- compatible : Should be "hisilicon,hip04-rng" or "hisilicon,hip05-rng"
-- reg : Offset and length of the register set of this block
-
-Example:
-
-rng@d1010000 {
-	compatible = "hisilicon,hip05-rng";
-	reg = <0xd1010000 0x100>;
-};
diff --git a/Documentation/devicetree/bindings/rng/hisi-rng.yaml b/Documentation/devicetree/bindings/rng/hisi-rng.yaml
new file mode 100644
index 000000000000..5406b2596f42
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/hisi-rng.yaml
@@ -0,0 +1,32 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/hisi-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Hisilicon Random Number Generator
+
+maintainers:
+  - Kefeng Wang <wangkefeng.wang@huawei>
+
+properties:
+  compatible:
+    enum:
+      - hisilicon,hip04-rng
+      - hisilicon,hip05-rng
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    rng@d1010000 {
+      compatible = "hisilicon,hip05-rng";
+      reg = <0xd1010000 0x100>;
+    };
-- 
2.51.0

