Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9534A22ACEB;
	Tue, 23 Sep 2025 09:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758620033; cv=none; b=CDCkoANowH9OX2shb9CE/3Ex4KKFNJ8/R0gTUeHOKaT2dDBOlv5J8vFPMpuKWEl4AIEXcadHFo9L15WXPJsHyWL5ae2MIPOvdYMwCYbeXOK1NB3yqJxRuxavfa6K8880weK5P85n3rzChzejA6Kec09Wbpt49vCrYhW0YeH8HFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758620033; c=relaxed/simple;
	bh=g2kCGs5z5fe1jujETB3Uw0ReJOfiA+V+lExAXNJv+zk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y8wKL4enUwES6nz1tbJEViDcH2dWKQjzJ1uSRlBZFzJjCFwnHu2YwaJEFTTABYRgjIW0uTkRfP4A8yw66+wo9gG9ViXIXkI6+2lzuhA4p6Hav6lzNYv6nWA36S6g1ckITGQmMfld4lrcXRRVoUPNgqNuu+5r1hzkgk7e/2sErNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io; spf=pass smtp.mailfrom=kael-k.io; dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b=dBBGN+/D; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kael-k.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b="dBBGN+/D"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4cWFCt4VFJz9smD;
	Tue, 23 Sep 2025 11:33:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kael-k.io; s=MBO0001;
	t=1758620026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hmaRte8V3efKjGqqS0Lljd5y+34LblGLSHL+bkfyYKE=;
	b=dBBGN+/D/Rk3FpO8GiH5prRlDYkS6NIY7cJ3T/XgI5onskBm0957KSXDHC6G2OTagA8hfY
	Dog2w1BJ50qtJvxLW3QQAI+j2v+ThI5765OjnwL8j42MWZQtFlgogsWQ2DfoXwH3/n0UKD
	JMDGUvyhBdLXHUGZkj4d2cvg2qjkZryNUn2VdpRe8Fd6ykZ2OT5C8+PXTntOldZmBZQLwG
	zfCxJLHwcMX+A3IvaVGEnb7Cqzu1jGILr6ADNF4jzZFSskVCcHojgiTZ1mE9EIw0LHWQBg
	aO93KehA1o4Z9WdB34HXbDxmDR9GoFvjEkVe94OtBqpJtc5yP8U98847m2Ldag==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of dev@kael-k.io designates 2001:67c:2050:b231:465::202 as permitted sender) smtp.mailfrom=dev@kael-k.io
From: Kael D'Alcamo <dev@kael-k.io>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: rng: microchip,pic32-rng: convert to DT schema
Date: Tue, 23 Sep 2025 11:32:34 +0200
Message-ID: <20250923093330.31649-1-dev@kael-k.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4cWFCt4VFJz9smD

Convert the Devicetree binding documentation for microchip,pic32mzda-rng
from plain text to YAML.

Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
---
 .../bindings/rng/microchip,pic32-rng.txt      | 17 --------
 .../bindings/rng/microchip,pic32-rng.yaml     | 40 +++++++++++++++++++
 2 files changed, 40 insertions(+), 17 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/microchip,pic32-rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/microchip,pic32-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/microchip,pic32-rng.txt b/Documentation/devicetree/bindings/rng/microchip,pic32-rng.txt
deleted file mode 100644
index c6d1003befb7..000000000000
--- a/Documentation/devicetree/bindings/rng/microchip,pic32-rng.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-* Microchip PIC32 Random Number Generator
-
-The PIC32 RNG provides a pseudo random number generator which can be seeded by
-another true random number generator.
-
-Required properties:
-- compatible : should be "microchip,pic32mzda-rng"
-- reg : Specifies base physical address and size of the registers.
-- clocks: clock phandle.
-
-Example:
-
-	rng: rng@1f8e6000 {
-		compatible = "microchip,pic32mzda-rng";
-		reg = <0x1f8e6000 0x1000>;
-		clocks = <&PBCLK5>;
-	};
diff --git a/Documentation/devicetree/bindings/rng/microchip,pic32-rng.yaml b/Documentation/devicetree/bindings/rng/microchip,pic32-rng.yaml
new file mode 100644
index 000000000000..1f6f6fb81ddc
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/microchip,pic32-rng.yaml
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/microchip,pic32-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Microchip PIC32 Random Number Generator
+
+description: |
+  The PIC32 RNG provides a pseudo random number generator which can be seeded
+  by another true random number generator.
+
+maintainers:
+  - Joshua Henderson <joshua.henderson@microchip.com>
+
+properties:
+  compatible:
+    enum:
+      - microchip,pic32mzda-rng
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+
+additionalProperties: false
+
+examples:
+  - |
+    rng: rng@1f8e6000 {
+      compatible = "microchip,pic32mzda-rng";
+      reg = <0x1f8e6000 0x1000>;
+      clocks = <&PBCLK5>;
+    };
-- 
2.51.0

