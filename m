Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793043905;
	b=rrpAEoKiaCtTB90DKM+I941EXu9UD//Cp9LqLsX4SvQE2IvY7S5ioQtaERlpBsmxUnSB
	 7SsX4E1B0r+6P61fOWRPpEaz5ELOwEE9Tf/2tSVaoVF6/UtFPeEfm0IxNM44egnziBZcH
	 I9OEDm0M30kjU6rLjpgKxQPP6BHtgYw02VksZJZ2NuejyeUjnX0Ym9cDUsO1tbFh/R9/e
	 t5bKKFuDSm9Cd2JcSOAmgcm6xmOVdUAd37SpNnS1HFvtQ4kcJ0iEumrd3+6L36Bqq+xUH
	 xIQyf94Ohfyq4FGQbFbYPfc9+H8/huEBBDcLhQfzUovsMd8z6BRi6SbjQBq0Ky2tQrA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793043905;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=D1JauJUP8/rGfrnELkLrT5ktva3BK+5HaY1Rg+7/l9Q=;
	b=YLuMNm517qirR19/6eik1nRF8hUZggbAjV+gKUcyNQn1qZNPktBAmX8tKUJNXWGQL6XV
	 0CpjbBXwa3EX1jyDUqTbhP7wSqx25cwufi5GC5MEfWzviemliT1Cftq8yL01MWcSECrTc
	 NuHUkZzd6V1unaUjtZsulEmRDp2VY8L10oEZdrdXvZzXq6WaMPbpzgPvTg7L7APh9pidn
	 ptic5EJ4pF+B/QeSNqEPS+ehyQk8mEmlEgrqiSY1NC6V74ZwTP8SUgYeF0SBxVuwTK7HS
	 ew2u1DVwBtyZ2NgdzSAKrP2atIwrJMR3jXu+YnP+JoVCFRiijvO0VkdfmZF061m5VMA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U7iHrF9K;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED9F606A31A;
	Mon, 26 Oct 2026 19:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U7iHrF9K
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793043904;
	b=wvLS4TaWUOdpTB2Ekq6j4nHCARQopRrbsirac4CK8i1vna4mKS61ga2bKEOU5zwZGj3P
	 yJXbB/ppcLKW3WZq9KVXjcIFxf4Dos2LIfVKntpSBIB8MA6aK6O3viNof7VIPnD6F6r1a
	 yHKoLmr/h+kMz5tmo54MLh44P7LAxofJRJ5CsvWEPDOpZfGoVL84BC8uZp+FkRwJAGde7
	 sBUvrvTqv76ez32vBh5u2JEUKAe6ItKVw3gIkWL+J0Kbw36CcBCewEyQmTJKRWd0hJofT
	 HA/obd0E+IenBVgu43ToQE3duv1VGCyfLrMJxrLvpOrRQ7Cfwm3jAjP1mlf8EI5Jekg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793043904;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=D1JauJUP8/rGfrnELkLrT5ktva3BK+5HaY1Rg+7/l9Q=;
	b=xdIPSiJhrd2awRKXHQmsmQ5vV6rqhJW2JQhsozB64hwfuzrB1+RMxn/7cQ7RKni8O6Bs
	 ArCyAvj9EtH94vOKNSG6o5H6zoQEh2vUMtalK9nHozv6/Umo0vGn49mueSQHVrtx30p19
	 I/VkVFRaVzWC0Q+VDe160UpN/aFco80oSndg3rxoXp0W2Opn2TcD7EQeUr3LIzqSAfNJn
	 oZGRbCsipidt1vlVj4HZAxLOeKVGQ3b/+gJXh3wyjULUA0rleJPlCvXlx4MMzatRF6U8r
	 WJD7X7e1voJLVlSYIY2gz54yO5BqDwo21ybS008dtopJrx0lPUFNiAnPVetNCLbtWSg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8D02E1F01829;
	Mon, 26 Oct 2026 19:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793043904;
	bh=D1JauJUP8/rGfrnELkLrT5ktva3BK+5HaY1Rg+7/l9Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=U7iHrF9K98083UHtLSqtgHuYdQqA3XLbKVcit2wS+xDCx7uSC0Up7YlLtXdoN1kAp
	 xTFicUYfHl+sz81F1eSrMlAnYQoAsNKT+43ZBhjrlQYLlutAoluMgg7C7h6r0/HSpN
	 OWMp2wWZMcTWBL1jwWqSQ2e+2Jwvlmt2HBIuvKX13b6tkcCpwmZitkkn1+jOR6d+8E
	 /8N+y2SXs1D0gD1rYpWErAC5eMzOyxpI2SrY/ma+P6U6YVx4LF9Xz0qs7EMbhKJtOZ
	 mXnB8gizvyOn/QSQqafp9lsxq3ryaJgIQ7LxzpzfcSQBpu3YRI0J3YomVzu/rLKS4U
	 3dfzigNi0mlgA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id F29EC44E6C;
	Mon, 26 Oct 2026 19:45:02 +0000 (UTC)
From: Alex Ousherovitch via B4 Relay <devnull+aousherovitch.rambus.com@kernel.org>
Date: Mon, 26 Oct 2026 12:44:57 -0700
Subject: [PATCH v7 1/5] dt-bindings: crypto: add Rambus CryptoManager Hub
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
Message-Id: <20261026-cmh-b4-a-v7-v7-1-500a83faf500@rambus.com>
References: <20261026-cmh-b4-a-v7-v7-0-500a83faf500@rambus.com>
In-Reply-To: <20261026-cmh-b4-a-v7-v7-0-500a83faf500@rambus.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793043901; l=7311;
 i=aousherovitch@rambus.com; s=20261026; h=from:subject:message-id;
 bh=rN/ukTSSPcBrmcYvmdPUbkgy7OdEc5yQ6Ze+1/v3EQs=;
 b=GXmPK0EwXFLB3fNS+AYNQaGjX6Dc4KZS17upGs4wfzbsARvdLMHjO7rjVKTBBXnGvN0OqXLYx
 z/UVb0nk7wuA+zn93K3aVbN99y1DaKQxxNy2qNiWHNHK51NE1y6Gt76
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
---
 .../bindings/crypto/rambus,cmh-v1030.yaml          | 144 +++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml       |   2 +
 2 files changed, 146 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
new file mode 100644
index 000000000000..fb05cc636df6
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml
@@ -0,0 +1,144 @@
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
+        enum: [128, 256, 512, 1024]
+        default: 512
+        description:
+          Stride in bytes between consecutive VCQ ring slots for this
+          mailbox's command queue.  Like rambus,num-slots this is a
+          per-board host-memory ring geometry, not derived from the
+          compatible.
+
+      rambus,cores:
+        $ref: /schemas/types.yaml#/definitions/string-array
+        items:
+          enum: [hc, aes, sm4, sm3, hcq, qse, pke, ccp]
+        description: |
+          Core-affinity list: the crypto cores whose work is dispatched to
+          this mailbox.  A core may appear on at most one mailbox.  Cores
+          not listed on any mailbox are load-balanced across all mailboxes.
+          Optional (default: none -- the mailbox only serves the
+          load-balanced pool).
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
index ba2002969373..364e53c31045 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1397,6 +1397,8 @@ patternProperties:
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


