Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963332135D7;
	Wed, 24 Sep 2025 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758723275; cv=none; b=eEMB/EPRuYwyb6eNWhbCY3j8ULWaTTDMCAogdiSVi8JxSkuDg9YX7BICAqmZwKTPXzX8E5rplQhLBxCPwdalzrrnj14lDl9LmhMUhVADvKqn9A0jTzlBuovo+iuUfZPTti+yCq8BYI2KK2s3z5M9IO8mFqundzlHftcQcASrkco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758723275; c=relaxed/simple;
	bh=M9mtIGEV5fVE5qdkzoug0rSgGpBai5jjEicI0TosQ4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1PYuW0aWRS7QyJWdnB/IliA93OUn4JmMocDmAre2+tNdq5eA4wcw9apaa5cm1+H9l+0bPZ0bdVFylkRq3b7PY4IhmtCOf4nr+It7vFIw5qIVpD97S3YbMSDp6fmYCteCUvyKjv83YcDlxrh9zBcZv9MrMGM4p1cjQwJWVer/4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io; spf=pass smtp.mailfrom=kael-k.io; dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b=GYdBNsJD; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kael-k.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kael-k.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kael-k.io header.i=@kael-k.io header.b="GYdBNsJD"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4cWzPK4ZW6z9tfQ;
	Wed, 24 Sep 2025 16:14:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kael-k.io; s=MBO0001;
	t=1758723269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IGi66BJ0/T6JH0YNvbBm/z4PyrtKkadtvMPQrrFPdf4=;
	b=GYdBNsJD8mh6mU3mGnPfPxFc/fRue8qI/6wEj8UxBc3v0fzkdt9IoxxolzJaiifIBZkEwf
	Xa6WkSyuroVED4zdisqGezuNxdwOlxxaG0eWwT3Urvl4uH8I/2f+Pqb3smSMuRNSjDz/iw
	uyIj9uffaBfp8MUr4VBKNzuWaBotT5glgBsre1wzqcJfHaZKPL8ZTUWv1W+jGLZb4hu/EO
	aUIpfiA9vLnRAvVPeE6TuK/25BCmW3NX+Xqcb4pcYFaNrSh7aR8rzPNHDMemuXvsbArOtK
	DL7l2fu+ojAoiVN/s+7tIYWKa3j+TdyKkGDAgoGZ4D6PzL6SB7RKjjAP3NpeKg==
From: Kael D'Alcamo <dev@kael-k.io>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] dt-bindings: rng: sparc_sun_oracle_rng: convert to DT schema
Date: Wed, 24 Sep 2025 16:09:20 +0200
Message-ID: <20250924141247.69323-4-dev@kael-k.io>
In-Reply-To: <20250924141247.69323-2-dev@kael-k.io>
References: <uprke6fujhmckymlpy6oskecol4awhqyroqlg25tprmhnkeyy6@ztozdrlmeotp>
 <20250924141247.69323-2-dev@kael-k.io>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the Devicetree binding documentation for:
* SUNW,n2-rng
* SUNW,vf-rng
* SUNW,kt-rng
* ORCL,m4-rng
* ORCL,m7-rng
from plain text to YAML.

Signed-off-by: Kael D'Alcamo <dev@kael-k.io>
---
 .../devicetree/bindings/rng/SUNW,n2-rng.yaml  | 50 +++++++++++++++++++
 .../bindings/rng/sparc_sun_oracle_rng.txt     | 30 -----------
 2 files changed, 50 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/SUNW,n2-rng.yaml
 delete mode 100644 Documentation/devicetree/bindings/rng/sparc_sun_oracle_rng.txt

diff --git a/Documentation/devicetree/bindings/rng/SUNW,n2-rng.yaml b/Documentation/devicetree/bindings/rng/SUNW,n2-rng.yaml
new file mode 100644
index 000000000000..6eafc532dc76
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/SUNW,n2-rng.yaml
@@ -0,0 +1,50 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/SUNW,n2-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: SUN UltraSPARC HWRNG
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
-- 
2.51.0

