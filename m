Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795024323;
	b=40SZ04K9LPMYbtGzE11Tw+AX7Rg0m/3dVD7iNmI2rLU9PmzqOjtUPzOdFj92VaDwv5iX
	 kdbpX64cm7zbb+vPLpLmzLGbzLGwNu9UlZdbSJzjGHRO5213q0eXN9/QQsfFobhAVMnPG
	 dg4FVr8nDa1oppjFi8xYOYN9wNekuaOev8XuYeHBNXdrQPgtqUwCDNTvud2zYKn6RJ/2A
	 GzR1PryILT5l8CgeN+zvdb1tZIHKwDmTfcNd/GUBD0wcPst/XBDznAOHCywmr5KiivByF
	 IZYZwAlK69CNn9Cx3cub5KJ5/xUZuBICQOjl0ax6l3f+fUirhpJuazZQc/UXmWM2M4Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024323;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=qK+Ek9AkOSYvJ6aZwpqXO1SfrR+8IC10f7yTJkf7Xs0=;
	b=lpIJxjmOtTZcMPh+rQUAt0X/0L3JR20/f5CXJfoSLhmy26Nxmz9o7u9yjD1h5xPgC98Z
	 uSB9QydKD7PIyiBuu6gzcbU2GLF4QGfWE8yLd4pk6RMsg7a5bGg7Qccz2tZX8Uq/uKnGD
	 E1/O9mntDEx2GK21sWcuAUOyJnpKe3NDtNxljUIaO5nUFnE8XvqphmV0IqZeo9ovIvmMC
	 NPJOjzcszL4y3k6sykolbP1ARETzD1EA30thiJsooqjSHHo5fWOIvZLm6JvUeu4QNshZH
	 O4/f6ffRRJ7o6KkjfVVIWbtlmORUKC6Rq8cTdLpReP3fM5irmUSGVxLsM2YifVdEIPw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="CqYpjXe/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A09606A335;
	Wed, 18 Nov 2026 17:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CqYpjXe/
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795024323;
	b=APUEygMK4icpVHn5eL/zXaS0QH0/Vh+QCE26SKqJZDW1ChzlZ1wwfsGd7G0tm7Gv3C15
	 5j9EiZDCxCfh2hOnrWralZXG/6EVlfTbnKjigocfN9Uh3jyMItyVh8W7d4FEgNrHu/JP0
	 uTSkiXlxoro0oktWR7WdKqYbs7RkQk8HjprrnZoKpFh+/ybnfqH7DHhi5qeHxq9UxI+pi
	 a7S9XN80yJI5m9yjVjuPJI1wbXIQgj/RH08c35irxCKJEyoj0V3VitC//PYhueHlPqUpm
	 SytHeFlSQ9/gY+qYDwJKoPF61s5yO/qWWtnNSimAtnAUL4Itu68Na0FamOpcR/ofBxg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795024323;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=qK+Ek9AkOSYvJ6aZwpqXO1SfrR+8IC10f7yTJkf7Xs0=;
	b=jmSda/tRKL9mvtPuOBXQqIm6tQgGSX2mLuY3ZJB/Cqfs+niFQ4HbtwX0H6Rz3gmffSwL
	 +e1l4vQgsAZ3YI8vlDK42zwM0qM2TEDcc1S8ebTY3TzGAX3zwxEYZ4+gUcpLQERInsCRt
	 oKANbpsExMSuoLbxqDtYQ1WDhopObiMZW+ad8VpwtlVUD94LkPwGlkpka85zqZ+ioGDkA
	 6/hqGzYplyS2pXWjEEdN0B4IO+Klj1qDX0jE9FGQVSouK8Ro8ghr2nXbNIYFUQcbXjsWA
	 /+GOCyO784kRAFPNQ4IA577J1KWrFQOmyr6S6Kt1gKBD1UrHCAug6B1IqVNlTb97+Eg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 34E491F000C7;
	Wed, 18 Nov 2026 17:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795024323;
	bh=qK+Ek9AkOSYvJ6aZwpqXO1SfrR+8IC10f7yTJkf7Xs0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=CqYpjXe/mGimCtwdqiHi8Qp+glhN1Muw38ow75pQjkMZHL8Mpwv+Fw9vbr8EysgPX
	 sk7i0ODUp6SFW/aAce1/jdnS1R35Z6h6OI5Xq0QZVGq4BmQazx+BhQQdQH/zh3lBXn
	 gF4eAoakUyxIV816D/S64ngGDdj6U00qg8tay7gOwMkT7BFDrE9QIPoJwF1L+rykpj
	 /6pJsRuKRfblpYd/UV6eUwYPmMW2j6esgcioi6ELg24ZhwS6SyHt0pusbCtYGI7b9N
	 4PSs0hfmFgcVMZbus5Q1iTy5jdiyf86I3ah8FMO+I5F7GxOCrdlNFE02HOJxi90ECd
	 uIcN7ILxvcGQw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A530A4AF0D;
	Wed, 18 Nov 2026 17:52:01 +0000 (UTC)
From: Alex Ousherovitch via B4 Relay <devnull+aousherovitch.rambus.com@kernel.org>
Date: Wed, 18 Nov 2026 09:51:45 -0800
Subject: [PATCH v9 1/5] dt-bindings: crypto: add Rambus CryptoManager Hub
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261118-cmh-b4-a-v9-v9-1-70385613fd50@rambus.com>
References: <20261118-cmh-b4-a-v9-v9-0-70385613fd50@rambus.com>
In-Reply-To: <20261118-cmh-b4-a-v9-v9-0-70385613fd50@rambus.com>
To: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>, 
 Joel Wittenauer <Joel.Wittenauer@cryptography.com>, 
 Thi Nguyen <thin@rambus.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 Alex Ousherovitch <aousherovitch@rambus.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795024320; l=7443;
 i=aousherovitch@rambus.com; s=20261026; h=from:subject:message-id;
 bh=7iiMQPyRWynqu4obzn8t+asKj9IqfTP68DrOqnS4y5U=;
 b=MpHh35nUWYJn1Yvb1P3TiKeA4ineY5dhk+pPLhIXDT1cr3Hp8GXlEyIQokzcQPMXI16ZGSTpn
 vis7Wo592WpBqGuEyuRKGTziE3nMLHJVZM51sFB1btEP1XlfEPYTNA+
X-Developer-Key: i=aousherovitch@rambus.com; a=ed25519;
 pk=ECFtTdQUPAolK+qGZ6v7Xm3sRf7rnM7wxpTeFzbqpmA=
X-Endpoint-Received: by B4 Relay for aousherovitch@rambus.com/20261026 with
 auth_id=1330
X-Original-From: Alex Ousherovitch <aousherovitch@rambus.com>
Reply-To: aousherovitch@rambus.com
Content-Transfer-Encoding: 7bit

From: Alex Ousherovitch <aousherovitch@rambus.com>

Add device tree binding schema for the Rambus CryptoManager Hub (CMH)
hardware crypto accelerator.  The binding describes the parent
SoC-level node with its SIC register region and one queue@N child
node per mailbox the host owns, each carrying a reg (mailbox instance
index), an optional interrupt, VCQ ring geometry (rambus,num-slots /
rambus,slot-stride-bytes) and a rambus,cores affinity list.  Which
crypto cores are present is discovered from the SIC CORE_ENABLE
register at probe, not described in the device tree.

Register the 'rambus' vendor prefix for Rambus Inc.

Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/rambus,cmh-v1030.yaml          | 145 +++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml       |   2 +
 2 files changed, 147 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
new file mode 100644
index 000000000000..eef82c2d7179
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
@@ -0,0 +1,145 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/rambus,cmh-v1030.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Rambus CryptoManager Hub (CMH) Hardware Crypto Accelerator
+
+maintainers:
+  - Alex Ousherovitch <aousherovitch@rambus.com>
+  - Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
+  - Joel Wittenauer <Joel.Wittenauer@cryptography.com>
+
+description: |
+  The Rambus CryptoManager Hub (CMH) is a hardware cryptographic accelerator
+  accessed via a mailbox-based VCQ (Virtual Command Queue) interface.  The
+  host writes VCQ command sequences into per-mailbox DMA queue buffers and
+  rings a doorbell; the CMH eSW processes them and signals completion via
+  interrupt.
+
+  The management host statically partitions the hardware mailboxes across
+  the SoC's host interfaces at integration time; the set of mailboxes a
+  given host owns is therefore fixed and not runtime-discoverable (a
+  mailbox locked to a host reads as unavailable in the SIC availability
+  register).  Each owned mailbox is described by a child node.  Which
+  crypto cores are present is a fixed silicon-build property indicated by
+  the SIC CORE_ENABLE register, so cores are not described in the device
+  tree.  Clock and reset are owned by the management host; a node
+  describing a non-management host has no clock or reset provider of its
+  own, so clocks and reset-gpios are optional.
+
+  CMH gates access to a locked mailbox by a hardware HOST ID presented on
+  the bus with every access, permitting only the owning host's ID.  An
+  integration must present a single, stable HOST ID for all accesses to a
+  given mailbox, independent of the issuing CPU (relevant on SMP hosts
+  whose interconnect encodes the issuing CPU in the HOST ID).
+
+properties:
+  compatible:
+    items:
+      - not: {}
+        description: SoC-specific compatible, e.g. vendor,soc-cmh
+      - const: rambus,cmh-v1030
+
+  reg:
+    maxItems: 1
+    description:
+      SIC (System Interface Controller) MMIO region.  The registers of
+      mailbox instance N are at offset N * 0x1000 within this region.
+
+  clocks:
+    minItems: 1
+    maxItems: 3
+    description:
+      The "core" functional clock, and optionally the half-rate "core-div2"
+      clock (present only on configurations with side-channel-protected
+      cores) and/or the "rt" real-time tick clock.  See clock-names for the
+      valid combinations.
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: core
+      - enum: [core-div2, rt]
+      - const: rt
+
+  reset-gpios:
+    maxItems: 1
+    description:
+      Host-controlled reset for the CryptoManager Hub.  The hub has two
+      external, active-low reset inputs -- a power-on reset and a hard
+      reset; where a board routes one of them to a host GPIO, that line is
+      described here.
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+patternProperties:
+  "^queue@[0-9a-f]+$":
+    type: object
+    description:
+      One node per hardware mailbox (VCQ command queue) this host owns.
+      The set of owned mailboxes is fixed by the management host at
+      integration time and enumerated here.
+    properties:
+      reg:
+        items:
+          - maximum: 63
+        description:
+          0-based mailbox instance index (0..63).  The instance's
+          registers are at reg * 0x1000 within the SIC region.
+
+      interrupts:
+        maxItems: 1
+        description: Completion/error interrupt for this mailbox.
+
+      rambus,num-slots:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        enum: [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192,
+               16384, 32768]
+        default: 64
+        description:
+          Number of VCQ ring slots for this mailbox's command queue in
+          host DMA memory.  This is a per-board, per-mailbox host-memory
+          ring geometry -- boards built around the same SoC (hence the
+          same compatible) may use different ring sizes, so it is
+          described per mailbox rather than derived from the compatible.
+
+      rambus,slot-stride-bytes:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        enum: [512, 1024]
+        default: 512
+        description:
+          Stride in bytes between consecutive VCQ ring slots for this
+          mailbox's command queue.  Like rambus,num-slots this is a
+          per-board host-memory ring geometry, not derived from the
+          compatible.  A slot must hold a complete command sequence,
+          which needs at least 512 bytes.
+
+      rambus,cores:
+        $ref: /schemas/types.yaml#/definitions/string-array
+        items:
+          enum: [hc, aes, sm4, sm3, hcq, qse, pke, ccp]
+        description: |
+          Core-affinity list: the crypto cores whose work is dispatched to
+          this mailbox.  A core may appear on at most one mailbox.  Work
+          for cores not listed on any mailbox may be dispatched through
+          any mailbox.  Optional (default: none -- the mailbox only
+          serves unlisted cores).
+
+    required:
+      - reg
+
+    additionalProperties: false
+
+required:
+  - compatible
+  - reg
+  - "#address-cells"
+  - "#size-cells"
+
+additionalProperties: false
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 5471a06f93f1..66537d8f52e6 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1411,6 +1411,8 @@ patternProperties:
     description: RaidSonic Technology GmbH
   "^ralink,.*":
     description: Mediatek/Ralink Technology Corp.
+  "^rambus,.*":
+    description: Rambus Inc.
   "^ramtron,.*":
     description: Ramtron International
   "^raspberrypi,.*":

-- 
2.43.7


