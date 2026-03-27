Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43532390C95;
	Fri, 27 Mar 2026 20:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774642231; cv=none; b=k/ddSeG3zIuFCLM3LO/D74zK0TuevlmdL+d8EmfoAZ6B8N1HIGUM64D1vcQeLWzGAv+9W+kNav3Yto1xPOiAltN5N49GyAXCKuB5kDKxBrpZeo7VFB+fvEZ2t6UyXMd0QNjYYIF81PEvxixJwYplK8JjLNKkGO5Besuz2tAMCRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774642231; c=relaxed/simple;
	bh=sVqPuDmF9xHaBRF6OFpbGvH89BwIdivjgPf1rMw5go4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cnqwON4QlwdwRtyn7UIPy0+PRA/wPZBnO7tRaH/t93xphH2AAUQcTrUZFSMDCanaMsmEVK4oBjD4iiJVXSyKg0Lxk4sJJkM3MYwHJK9FQjhUVmZ8T5DV2+izGpKX8W5CojvxFljjprZoVdRZvM++xDtuKE2yLfpJmY+HbTK0Ozo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=TazAGxoC; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="TazAGxoC"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 0A19B1A302C;
	Fri, 27 Mar 2026 20:10:29 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id CD46860268;
	Fri, 27 Mar 2026 20:10:28 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 9F7F810451AF7;
	Fri, 27 Mar 2026 21:10:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1774642227; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=F7KByxnZKYpIC4KwssijV6OI8JnCVJ1fz1NVPkaqHkg=;
	b=TazAGxoCfrmXyOrbi+2KpJ0PifSweozMCGHe+9LvEboTSY0XgEw+gcSOZE02YRHON2lflA
	ewciCTp71XVuJ7axUJ8OGI5j3xk/da3bEa4D+kDjS+cs9n8JlzL2SAwEGmaZliUg4CA+kk
	T3snOgCPIXRbk1SCu4rgeDmm1lwzK5+cya7furyT5B5nDWtguPGGiUO56IPDFJhmyF8qRh
	+GSzAqghDDtxf8pDAOr+fOqYcJvAfo5A6QbFO6YJ+yL4BkafGlzKPhplRmBniD/pgeHmoo
	hDMia6pncXaLolqSVBQaT9rGSqEyPxCZRXEzsfR7aPWoOO2QLQMtHr3sTNhDQg==
From: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Date: Fri, 27 Mar 2026 21:09:24 +0100
Subject: [PATCH 02/16] dt-bindings: interrupt-controller: Describe EIP-201
 AIC
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260327-schneider-v7-0-rc1-crypto-v1-2-5e6ff7853994@bootlin.com>
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
In-Reply-To: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
To: Michael Turquette <mturquette@baylibre.com>, 
 Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Jayesh Choudhary <j-choudhary@ti.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Christian Marangi <ansuelsmth@gmail.com>, 
 Antoine Tenart <atenart@kernel.org>, 
 Geert Uytterhoeven <geert+renesas@glider.be>, 
 Magnus Damm <magnus.damm@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Pascal EBERHARD <pascal.eberhard@se.com>, 
 Wolfram Sang <wsa+renesas@sang-engineering.com>, linux-clk@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
 "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
X-Mailer: b4 0.14.3
X-Last-TLS-Session-Version: TLSv1.3

The EIP-201 Advanced Interrupt Controller is part of a bigger container
block from Inside Secure nicely named EIP-150. It typically takes one
clock from the EIP-150 and offers basic controls through a few simple
registers.

Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
---
 .../inside-secure,safexcel-eip201.yaml             | 41 ++++++++++++++++++++++
 .../inside-secure,safexcel-eip201.h                | 14 ++++++++
 2 files changed, 55 insertions(+)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/inside-secure,safexcel-eip201.yaml b/Documentation/devicetree/bindings/interrupt-controller/inside-secure,safexcel-eip201.yaml
new file mode 100644
index 000000000000..ddad8e5eab96
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/inside-secure,safexcel-eip201.yaml
@@ -0,0 +1,41 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/interrupt-controller/inside-secure,safexcel-eip201.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Inside-Secure SafeXcel EIP-201 Advanced Interrupt Controller
+
+maintainers:
+  - Miquel Raynal <miquel.raynal@bootlin.com>
+
+allOf:
+  - $ref: /schemas/interrupt-controller.yaml#
+
+properties:
+  compatible:
+    const: inside-secure,safexcel-eip201
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    minItems: 1
+
+  interrupt-controller: true
+
+  "#interrupt-cells":
+    const: 2
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - interrupt-controller
+  - "#interrupt-cells"
+
+unevaluatedProperties: false
diff --git a/include/dt-bindings/interrupt-controller/inside-secure,safexcel-eip201.h b/include/dt-bindings/interrupt-controller/inside-secure,safexcel-eip201.h
new file mode 100644
index 000000000000..ead73bd96296
--- /dev/null
+++ b/include/dt-bindings/interrupt-controller/inside-secure,safexcel-eip201.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR MIT) */
+
+#ifndef _DT_BINDINGS_IRQ_SAFEXCEL_EIP201_AIC_H
+#define _DT_BINDINGS_IRQ_SAFEXCEL_EIP201_AIC_H
+
+#define AIC_PKA_INT0 0
+#define AIC_PKA_INT1 1
+#define AIC_PKA_INT2 2
+#define AIC_TRNG_INT 3
+#define AIC_RESERVED 4
+#define AIC_SL_ERR_INT  5
+#define AIC_PROTECTION_INT 6
+
+#endif

-- 
2.51.1

