Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517BD2BEC5A;
	Mon, 12 Jan 2026 14:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229765; cv=none; b=WTDN/nUMef0PsX10JJAP3B2WtrQkal/NJpVi+wpTgvxMzDC6EOYoM24vT5BJwLFepS/PS5CZ4tDymnbT3GHl7lCgCKQWk9I/KQGOfjr3EltHMR29X1BxLSCY39w61i294OlPeaVSelFtwvnKLyAnfBjd5aydkvx4r8iv/9cD9Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229765; c=relaxed/simple;
	bh=EJPDZ5Dc0wB9GU9QhHDnXlO4yycbpJpZQSij8Zfro74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhM/3dRvVDUxJTYtv9H9C8Becah+ROkfbjMGhqGWMDGLoHbd/Y2V00h3+UUr7A9hyHa4neOGcQ8WCjErIH/kiMXZgvE/U2zkp+gerfT6U8JvpMfFtVRJOrDU8FzHGFUxFLPsBuKxfH/0yU2NkOwsiiLN+lPQdpz0QDB9efO422s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=PsZEo9vP; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="PsZEo9vP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1768229762;
	bh=EJPDZ5Dc0wB9GU9QhHDnXlO4yycbpJpZQSij8Zfro74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PsZEo9vPLa/baVTfh9rInF23112cXEwreoXivkHsmb26OJiZW7Pqom/9SYyn137Yg
	 A9hcrSG2xrPDtyfo3TQHFyenhujg3/CHHFHjwqoQxmtowLFj1Jy6yWhPWIes1+8Dcp
	 WgJGZ/FLCBQhnJqCZWmmUHR7boW/v000gk88GhE8/F03Tt+YDYR2b6Ut0XB811DuSg
	 LWLC0695WrayevzWrg/F8/Xc35N+pstTD6DQv0ctrLISl0cV5weXccs0hKnXV1+hqB
	 IOHgO9ZGdxuKl2YysfDR2eV98mM3jNVbgiOGFVe2xCNpTFRzqp7NrTh62vHaBoQuBu
	 DbNhxRkLeoMUg==
Received: from IcarusMOD.eternityproject.eu (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 207E117E0B8E;
	Mon, 12 Jan 2026 15:56:02 +0100 (CET)
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
To: krzk+dt@kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	conor+dt@kernel.org,
	andrew@lunn.ch,
	gregory.clement@bootlin.com,
	sebastian.hesselbarth@gmail.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	atenart@kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	kernel@collabora.com
Subject: [PATCH v2 2/4] dt-bindings: crypto: inside-secure,safexcel: Mandate only ring IRQs
Date: Mon, 12 Jan 2026 15:55:56 +0100
Message-ID: <20260112145558.54644-3-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>
References: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not all IP implementations of EIP97 and EIP197 have the EIP and
MEM interrupts hooked up to the SoC, and those are not required
for functionality as status for both can be polled (and anyway
there's even no real need to poll, but that's another story).

As an example of this, the MediaTek MT7986A and MT7986B SoCs do
not have those two interrupts hooked up to their irq controlller.

For this reason, make the EIP and MEM interrupt optional on the
mediatek,mt7986-crypto.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 .../bindings/crypto/inside-secure,safexcel.yaml    | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
index 1c8bfd6c958d..3dc6c5f89d32 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
@@ -34,9 +34,11 @@ properties:
     maxItems: 1
 
   interrupts:
+    minItems: 4
     maxItems: 6
 
   interrupt-names:
+    minItems: 4
     items:
       - const: ring0
       - const: ring1
@@ -73,6 +75,18 @@ allOf:
           minItems: 2
       required:
         - clock-names
+  - if:
+      properties:
+        compatible:
+          not:
+            contains:
+              const: mediatek,mt7986-crypto
+    then:
+      properties:
+        interrupts:
+          minItems: 6
+        interrupt-names:
+          minItems: 6
 
 additionalProperties: false
 
-- 
2.52.0

