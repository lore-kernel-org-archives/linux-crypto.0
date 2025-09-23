Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07AA224F6;
	Tue, 23 Sep 2025 10:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758623963; cv=none; b=pzvaGM9i4Ku+cvL1HLdC72Z4rVRL0aRiOfN6Yim6POZxPQmxqq6Fz34VYzfJXop9LrWu879V6LQdpjyCUGhjGQPnQvjeouWrdz0dWCWTo8hlOucZoIUt3t1/fnjYuRH+1zwb83MZypy6dJmXOzfOGb+gPdasYRdGOLf61vX5lPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758623963; c=relaxed/simple;
	bh=WIQ2syAd5sHKPevRR5Dcm64QJukAgwdcMdoewqU0A/U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U/I3WYGEf85HyNP9tHsiBpKdhg3pQ3rauncBbEIECSSxYb8wJmEikkSI3p+ZTXSj/aHUBcDigiqG8Jur9nf3+3dztHz0akjgBVmNlzMk674ROBxPUSzs7oOffZkKZZzkiIWSD5MaSEA3EDetFmEbzn59yHd4/1BMH7IG9063iGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io; spf=pass smtp.mailfrom=kael-k.io; dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b=x1ZP3QAC; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kael-k.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b="x1ZP3QAC"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4cWGgL4V5Yz9tJ1;
	Tue, 23 Sep 2025 12:39:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kael-k.io; s=MBO0001;
	t=1758623950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ox8Mmwu/ehvmiRuJmtbvI2ttQH7ZUjO4FEYhPqIjfbk=;
	b=x1ZP3QACkCwYIR/qc2c5Vju8DeS5/iby1c1Krq38IdYfN6jFkKPM+efs89YwrbI8KlGrIE
	cw+tLOu9RzK4piJv5EB2kOxVt5zpnoDrs0qinkVaGD04co7TEBRIiPmHjQBYzUOpaDv77q
	slzImdt1w7fp30nAUkxAYE81DHdegB/FcW5GItzzkOITO8XlbQgGWmS72JXgy5ppsdNJJm
	zZ7k9ZMasAK5EJj7cFUXOLiPYCYQwiEYhXCuYqZdaf+Yj0nfWsI64j6h/Ry2m95VCAlgbN
	WujZUTdMvF7mmRtSOkgZVNon8aBKjXurAXPCcFAf0k58LFqoYmgIxYhhCFnJBg==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of dev@kael-k.io designates 2001:67c:2050:b231:465::2 as permitted sender) smtp.mailfrom=dev@kael-k.io
From: Kael D'Alcamo <dev@kael-k.io>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: rng: sparc_sun_oracle_rng: convert to DT schema
Date: Tue, 23 Sep 2025 12:38:22 +0200
Message-ID: <20250923103900.136621-1-dev@kael-k.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4cWGgL4V5Yz9tJ1

Convert the Devicetree binding documentation for:
* SUNW,n2-rng
* SUNW,vf-rng
* SUNW,kt-rng
* ORCL,m4-rng
* ORCL,m7-rng
from plain text to YAML.

Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
---
 .../bindings/rng/sparc_sun_oracle_rng.txt     | 30 ---------
 .../bindings/rng/sparc_sun_oracle_rng.yaml    | 61 +++++++++++++++++++
 2 files changed, 61 insertions(+), 30 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt b/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt
deleted file mode 100644
index b0b211194c71..000000000000
--- a/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt
+++ /dev/null
@@ -1,30 +0,0 @@
-HWRNG support for the n2_rng driver
-
-Required properties:
-- reg		: base address to sample from
-- compatible	: should contain one of the following
-	RNG versions:
-	- 'SUNW,n2-rng' for Niagara 2 Platform (SUN UltraSPARC T2 CPU)
-	- 'SUNW,vf-rng' for Victoria Falls Platform (SUN UltraSPARC T2 Plus CPU)
-	- 'SUNW,kt-rng' for Rainbow/Yosemite Falls Platform (SUN SPARC T3/T4), (UltraSPARC KT/Niagara 3 - development names)
-	more recent systems (after Oracle acquisition of SUN)
-	- 'ORCL,m4-rng' for SPARC T5/M5
-	- 'ORCL,m7-rng' for SPARC T7/M7
-
-Examples:
-/* linux LDOM on SPARC T5-2 */
-Node 0xf029a4f4
-	.node:  f029a4f4
-	rng-#units:  00000002
-	compatible: 'ORCL,m4-rng'
-	reg:  0000000e
-	name: 'random-number-generator'
-
-/* solaris on SPARC M7-8 */
-Node 0xf028c08c
-	rng-#units:  00000003
-	compatible: 'ORCL,m7-rng'
-	reg:  0000000e
-	name:  'random-number-generator'
-
-PS: see as well prtconfs.git by DaveM
diff --git a/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.yaml b/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.yaml
new file mode 100644
index 000000000000..fea6be544784
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.yaml
@@ -0,0 +1,61 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/sparc_sun_oracle_rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: HWRNG support for the n2_rng driver
+
+maintainers:
+  - David S. Miller <davem@davemloft.net>
+
+properties:
+  compatible:
+    enum:
+      - SUNW,n2-rng  # for Niagara 2 Platform (SUN UltraSPARC T2 CPU)
+      - SUNW,vf-rng  # for Victoria Falls Platform (SUN UltraSPARC T2 Plus CPU)
+      # for Rainbow/Yosemite Falls Platform (SUN SPARC T3/T4),
+      #  (UltraSPARC KT/Niagara 3 - development names)
+      #  more recent systems (after Oracle acquisition of SUN)
+      - SUNW,kt-rng
+      - ORCL,m4-rng  # for SPARC T5/M5
+      - ORCL,m7-rng  # for SPARC T7/M7
+
+  reg:
+    maxItems: 1
+
+  "rng-#units":
+    description: Number of RNG units
+    $ref: /schemas/types.yaml#/definitions/uint32
+    minimum: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+# PS: see as well prtconfs.git by DaveM
+examples:
+  - |
+    bus {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        rng@e {
+            compatible = "ORCL,m4-rng";
+            reg = <0xe>;
+            rng-#units = <2>;
+        };
+    };
+  - |
+    bus {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        rng@e {
+            compatible = "ORCL,m7-rng";
+            reg = <0xe>;
+            rng-#units = <3>;
+        };
+    };
-- 
2.51.0

