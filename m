Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63BC1AC45F;
	Mon, 14 Oct 2024 18:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728932109; cv=none; b=k1vZEfro2UoYm1x1i28bwLBwyPcuxtmHrOLSbqfzc2Hal5Xx3ClAbuC3ZXb7TXzRoSi0GS4dtbtxFkJ+zFWvb9lGNWa5xmXBoEbkbZG8TrMS6FmFtlL0ftrnoxRZ+NtcHZAVkxAuQI+IWVfY5CciqITZvxyeel50C61p9Cn1Au0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728932109; c=relaxed/simple;
	bh=MEnARyCy8ZhQv5hcAqw282lo3d4lT4pcqhEA+2UdDrg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s/NsncBp8KjDimLn5vRk67Ud09Gvto2BFxdub4WCpvuVP6PRaEcX2dtmjgQDyrY53inH0u+IiubWOpNikWDqFekWXWInj31H+p2a5zFmTTeu6vrSDK09TK+XAFBumgX9j4Wv4vAY7iN6zsZW3uPTulMpLyK7zBJ+ADqlv2L0Qb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V+QYDmC9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V+QYDmC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E58C4CECE;
	Mon, 14 Oct 2024 18:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728932109;
	bh=MEnARyCy8ZhQv5hcAqw282lo3d4lT4pcqhEA+2UdDrg=;
	h=From:To:Cc:Subject:Date:From;
	b=V+QYDmC99fszEIk3HlXB8O6GjJLEOYQ5uaZhSEU1gg2vN9IVRJ3YS1SG+Hg0CsHBX
	 yGChbHNPxdIOXbOq+G2gsqsaI1jOb9lOiyrL9I6bjHcb4lKPw/Y9Ek5RmqwqqBm+GY
	 LLWkucAXtNcopZcFEjY2hQFcSMy6RpGK43Mp8Fyr+my4eWg6ITndqmCPozR0za7Xko
	 PBh2F3/5jZcx9gK91uy3WAUjN1efdpqNXCvyrY9JuqCF6L8+5CR22Q+e5SS9jZxARa
	 x8wPNsUkF2DUeqsIJ3fGF9mDf/KZbmUKUBoA5zsA7cT6h2WRHYtKINpeq04Bs4Z7aL
	 tHfaXlm0J4K7w==
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jayesh Choudhary <j-choudhary@ti.com>
Cc: linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dt-bindings: rng: Add Marvell Armada RNG support
Date: Mon, 14 Oct 2024 13:54:57 -0500
Message-ID: <20241014185457.1827734-1-robh@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Marvell Armada RNG uses the same IP as TI from Inside Secure and is
already using the binding. The only missing part is the
"marvell,armada-8k-rng" compatible string.

Rename the binding to inside-secure,safexcel-eip76.yaml to better
reflect it is multi-vendor, licensed IP and to follow the naming
convention using compatible string.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 ...g.yaml => inside-secure,safexcel-eip76.yaml} | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)
 rename Documentation/devicetree/bindings/rng/{omap_rng.yaml => inside-secure,safexcel-eip76.yaml} (79%)

diff --git a/Documentation/devicetree/bindings/rng/omap_rng.yaml b/Documentation/devicetree/bindings/rng/inside-secure,safexcel-eip76.yaml
similarity index 79%
rename from Documentation/devicetree/bindings/rng/omap_rng.yaml
rename to Documentation/devicetree/bindings/rng/inside-secure,safexcel-eip76.yaml
index c0ac4f68ea54..0877eb44f9ed 100644
--- a/Documentation/devicetree/bindings/rng/omap_rng.yaml
+++ b/Documentation/devicetree/bindings/rng/inside-secure,safexcel-eip76.yaml
@@ -1,20 +1,25 @@
 # SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 %YAML 1.2
 ---
-$id: http://devicetree.org/schemas/rng/omap_rng.yaml#
+$id: http://devicetree.org/schemas/rng/inside-secure,safexcel-eip76.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: OMAP SoC and Inside-Secure HWRNG Module
+title: Inside-Secure HWRNG Module
 
 maintainers:
   - Jayesh Choudhary <j-choudhary@ti.com>
 
 properties:
   compatible:
-    enum:
-      - ti,omap2-rng
-      - ti,omap4-rng
-      - inside-secure,safexcel-eip76
+    oneOf:
+      - enum:
+          - ti,omap2-rng
+          - ti,omap4-rng
+          - inside-secure,safexcel-eip76
+      - items:
+          - enum:
+              - marvell,armada-8k-rng
+          - const: inside-secure,safexcel-eip76
 
   ti,hwmods:
     const: rng
-- 
2.45.2

