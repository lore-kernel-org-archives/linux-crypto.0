Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFE538F920;
	Fri, 27 Mar 2026 20:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774642228; cv=none; b=PJVjeHGqaKj0CLcs7A2KRdABgIqdnUBIyIWTnPb6P6ul58tiBhDMIGDy2NZMZ/DuCb8HXA9f7AF/okxRzROr/cXToJGLyJ5Hws2Lxr7rgO+QH72mMdugzqVQETrZvv1oCHFEBWxVXnYjJxGbRgR08xeNvs382rHYO0nzYT/sLIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774642228; c=relaxed/simple;
	bh=53ISBKabvLXIGpST9KmWh9Un7jYPoZOrSqGNFBlPPog=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=raPvwwwDKmHjod9YFMo4qL0JmFllemhi4Hh3rgeLYUvpocibixaJXfLpXgWyLGKwenoyhuXW+EQ3B1mWNXBeZLP4Ue/A9BEfvx0X5sNU+JZfGYk0Q/3YrGOVsHgiZ7SXBopvzWEAmn8waHVkbIDpjno4oxZo+iUTGJdyKVM772k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=s8LU75QG; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="s8LU75QG"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id C8C3F4E4282D;
	Fri, 27 Mar 2026 20:10:25 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 8FC7D60268;
	Fri, 27 Mar 2026 20:10:25 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id F1B5310451AD3;
	Fri, 27 Mar 2026 21:10:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1774642223; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=lE3QKXVXrOESVFGZ+EtmwjmJziMWMpwyr3ofoukXeI4=;
	b=s8LU75QGO5PxR0VmI003T4y+A+OZdpHPLs8YNMTPr1r0366jG4m8cvSZaol9G77Dav1vIt
	EeX6Sz5X5P59OZk7XXsQz8lWrnWBNkw+syOb3nRghVMJhWLWAf42gUAp6wCpU5jZRuUjKk
	0+7T7lRjEMagnD1gccSqfuyZ5vMpzo2nK8zs9LEAQP63NKAm7wdcwAAGcJNwXLe3TVR0Z8
	PW98+Pzbu2psIZgoBEZLT0+FFfB9WDEIJ0UBa58emzZ+bIkMrdHF1IO+LVggV2QkbpF5wg
	YmN8uAnuNdjUqTfPdDfBebnxF2mf+tVrYiXOlBN6W55Z41bj7rkTqZJeMYzaGA==
From: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Date: Fri, 27 Mar 2026 21:09:23 +0100
Subject: [PATCH 01/16] dt-bindings: clock: Introduce nexus nodes
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260327-schneider-v7-0-rc1-crypto-v1-1-5e6ff7853994@bootlin.com>
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

Hardware containers can just decouple external resources like clock
without any more control. Nexus nodes already exist for PWM and GPIOs,
add a binding to allow them for clocks as well.

No examples are given, the file is litteraly a copy-paste from Hervé
Codina's work on PWM Nexus nodes, hence we just point to the examples
there which already illustrate very clearly the concept of the various
properties.

Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.com>
---
 .../bindings/clock/clock-nexus-node.yaml           | 39 ++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/devicetree/bindings/clock/clock-nexus-node.yaml b/Documentation/devicetree/bindings/clock/clock-nexus-node.yaml
new file mode 100644
index 000000000000..f07e2972e8aa
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/clock-nexus-node.yaml
@@ -0,0 +1,39 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/clock/clock-nexus-node.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Clock Nexus
+
+description: >
+  A nexus node allows to remap a phandle list in a consumer node through a
+  container or a connector node in a generic way. With this remapping,
+  the consumer node needs to know only about the nexus node. Resources
+  behind the nexus node are decoupled by the nexus node itself.
+
+maintainers:
+  - Miquel Raynal <miquel.raynal@bootlin.com>
+
+select: true
+
+properties:
+  '#clock-cells': true
+
+  clock-map:
+    $ref: /schemas/types.yaml#/definitions/uint32-matrix
+
+  clock-map-mask:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+
+  clock-map-pass-thru:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+
+dependentRequired:
+  clock-map: ['#clock-cells']
+  clock-map-mask: [ clock-map ]
+  clock-map-pass-thru: [ clock-map ]
+
+additionalProperties: true
+
+# See the original pwm-nexus-node.yaml description for examples

-- 
2.51.1

