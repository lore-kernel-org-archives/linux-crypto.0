Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24E6390CAE;
	Fri, 27 Mar 2026 20:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774642239; cv=none; b=pPjB9prffk80Yq0jTLb4jLoXnE3naxz7vU01EX+3UKK/2m9xKEAbiD/V497zMAWePg5F09Jl+63gIlR071ggP2A9cNoUot2ReVcH4JQrT2zcvsWmUYXtga9FIrkwszVRqfvC5+vUoGQxamS1501wNoLHBL6h3dqCQKATgtnBZ7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774642239; c=relaxed/simple;
	bh=hsP7fHqPt9mP87f1VpCI1fLI42QC74jqzhrlvlxm5us=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=d13aWhiZJYm3QsF6UKBDDMagHzcWhnYPDcUitF35JoK3ynkX/yXZ8I3TBInkX7yQp4FGVuJB1eSg/Tj1NcoT6nRbjFd6cR4Entm6sAFhBMWF3lsGDqOTH6GmdrsljPdw4AMkkzb/nJFI2/uWijBSZPof4UOQGLdpTUjeNctIrwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=iW2Xhm0W; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="iW2Xhm0W"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 821184E42829;
	Fri, 27 Mar 2026 20:10:36 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 5618060268;
	Fri, 27 Mar 2026 20:10:36 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0D89F10451AFF;
	Fri, 27 Mar 2026 21:10:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1774642235; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=Bv5k4m7ct4CZYhqzZBg0LTSqAE21eXTy+4/0cBCVguk=;
	b=iW2Xhm0WEU7YSS3l6jm/y3D79IbblvrQT76gkk4GswHH1AGqkmLkFcQ7yVEZL4rFKBn67e
	AMmX+xIEQVIs5YOzaDAaMVVq+gKaeYDmF6mQa4o1JelpN8EcyFhNgUM82Wtgyujb5doFeS
	WD3cHETp6pjqNpplGnAy8UCJUg5eoWqaTrPT5CP+0zvJfgKnnk1umGFd8zXlLD1T2559+U
	Ezm/zg8pnlia+jNmOaH8ot28qNaFHE67kbawBCUgdztQKCOfj26WQbJW9U40069UAZ53so
	dRfZLKH0ELZ6Yuy+wW6nYFi+D6dPpEMWoo3lrIxpdRCQNj63NKXgR5gD7PtQzQ==
From: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Date: Fri, 27 Mar 2026 21:09:26 +0100
Subject: [PATCH 04/16] dt-bindings: crypto: eip28: Describe EIP-28 PKA
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260327-schneider-v7-0-rc1-crypto-v1-4-5e6ff7853994@bootlin.com>
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

Describe the Public Key Accelerator named EIP-28 from Inside-Secure,
part of the SafeXcel family, it is typically included in a bigger
hardware container named EIP-150.

Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
---
 .../crypto/inside-secure,safexcel-eip28.yaml       | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip28.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip28.yaml
new file mode 100644
index 000000000000..96acb257450a
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip28.yaml
@@ -0,0 +1,31 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/inside-secure,safexcel-eip28.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Inside-Secure SafeXcel EIP-28 Public Key Accelerator
+
+maintainers:
+  - Miquel Raynal <miquel.raynal@bootlin.com>
+
+properties:
+  compatible:
+    const: inside-secure,safexcel-eip28
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 3
+
+  clocks:
+    minItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+
+additionalProperties: false

-- 
2.51.1

