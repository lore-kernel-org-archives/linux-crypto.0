Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794329561;
	b=lyB2zaIl/X9nm2WHlK9J0FhzOvz/+2FA06IQb9H6OF8alLw+9+AmvRQEnxZkbzPy4Ksg
	 R7TgJieICC2tzCDfbvIKEiBKoKwIucspSTL6ZUVYNuysAQ3T/y4P2Id9L0e4UHIg94Egv
	 kc7TqX86k0oVajtKnX23v2TMTXeuBTDDnThxonxQo+NdoxfYufY+EeV9npDkR5yFr+xa1
	 SApsm6ddsFxZLCarpWPg+WbS1F9ghr1Gdkfq49hCYf9dn35jnMsNIRAFDZO3wbAAP/fJb
	 g4hn3I3IzpbzPtZVYIvCMFtJ9ZpgFkC7EyBJqtcJFbxcgUYEYF89dvDEGSrvrAJMOjA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329561;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=2rzjfkAxp4nWM+CV0eUCHjMDO4MRyHCnEHq/VA6sTPE=;
	b=pIY4AYxqMHjymVJ23dKShCsqtmp8Tc9sJrSAjTWoAxq++0H41SB69Iqsb14xqz1Jvuvq
	 5crbUck/x0JPfr+0dQfBEBhRDtTRL2MO6hmSOuLsVbWdR3nrzB4EUtF0aDzLUuhvZQM1r
	 TOf627hJQlsaa91u5yqzZpZe0VbGjE9zPJZZcsROsYtji05D1CW5s2LZHgn41kxm1gk2v
	 R3TPNqZZ5i0l6L9xiTsCMjS+8lr8woHCyXmZh/wYDq8yKHVgt07l9e9nfOmhe7BiqseiH
	 rLzrvWbseKHZ+3ZLjtGi8czX+5YM+kLDANDjp2iyaUBu7A7R61nY4sN7NW2mBvVnBkw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dRnBbMkU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F0460A2609;
	Tue, 10 Nov 2026 16:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dRnBbMkU
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794329561;
	b=t7898iaIaWZ8CWa0Q6C1jKECsP+ilE3zgrQYVzfyccHUPMySexvJt28YfBsMGsP3yERh
	 94Jkr6lqB6S23URfybZuOzaYdxN5sd1b/00nSjMbYN6US7jVmPuz7VU4t6nHLe1gDprjT
	 F/bVeGVFD0a7eucMXQ2Y6J4jODf+VRHIattTOSe3CbPZzUl4bfyj2eqK9w6fi2UHmiGgd
	 pOz2LamX1tMZBArrkWvFDWpEXvn0HF/ky42htprmXDvoF182Jdh8w0PrEDlQ8xIxKipRB
	 hlmr5jPhlw6oMmDmtfpgTVJHrslttt7JJPbKGnoBS9svjh6NMJbZOPEebYDtCRdz5xA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794329561;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=2rzjfkAxp4nWM+CV0eUCHjMDO4MRyHCnEHq/VA6sTPE=;
	b=gnIG36dsAZG+cJXH5S3rIeYrwYSakS296HDQYk5XU/JNXSqJTf922CgCPRsPLnbxRSZm
	 ODuczHzuSvaeW8t7ImxI8KLF92uGYowffS+MDcbkMS2zb6YneGh16NxMrwT5HzAuBI0PB
	 U77WjrosEUCh8epnBWKBdKeF+adUQw3P33jOenWwFwT3Q00ZhAmLHR021riFxwLJfGoRA
	 IaM/BZocKVXAJkwtgD4gV2XXKGsGfo23SsCGgSSO68ToX4kU/bbcvU1TSDGUfs+duV+O5
	 FpfpP35UbG9QkP/71QUG5j8sbeEgu8hqdRz2KgfeMyFwo0ERAZ9BJQE01lJced5BU+g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B11B31F008A2;
	Tue, 10 Nov 2026 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329560;
	bh=2rzjfkAxp4nWM+CV0eUCHjMDO4MRyHCnEHq/VA6sTPE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=dRnBbMkUdPd9vR80rquzst6iTBSv5h7j+w/RwNuYv7AV8z5LF0aTCMgK4uGWvIk8n
	 O7/FB0wyfZtdy7p+L387ItnvRF5J2hvnWNAytQQ09CR35pKxDhBuI2Z0/KjZvQRzWS
	 ErBQetrQ2Is5/FC4kSXe3Vmg5PSRJUg6Hj1In+JKK44VM0IlrceamfIJBpcZ1owEbW
	 1BfCj5aZ13WnuauQRbWSyfedbaIcFeFpxhfPpdXGTbPzfcokKZ8Lu10DuBQOMU0Cfu
	 zckHVPY6cYr25ryMR1Gn/oqmHySgZHgwv88NRp9sWY9s+EH/Yoa0Bw+0vqfWvTlulk
	 LAFabVY8wmgcQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3A23148C04;
	Tue, 10 Nov 2026 16:52:38 +0000 (UTC)
From: Alex Ousherovitch via B4 Relay <devnull+aousherovitch.rambus.com@kernel.org>
Date: Tue, 10 Nov 2026 08:52:27 -0800
Subject: [PATCH v8 1/5] dt-bindings: crypto: add Rambus CryptoManager Hub
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
Message-Id: <20261110-cmh-b4-a-v8-v8-1-4cea8ebc1d40@rambus.com>
References: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
In-Reply-To: <20261110-cmh-b4-a-v8-v8-0-4cea8ebc1d40@rambus.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794329557; l=7393;
 i=aousherovitch@rambus.com; s=20261026; h=from:subject:message-id;
 bh=GZqVAWebmgss8+gw8k3vCH3UdrGSwgvS1FtLn9Ky7Zw=;
 b=S6J25R7zxk+xl8R1ue6YSlJBzcC9fgv2M41Whi/3Q1w+II+2iN1eTkw1ggL6I4HdEoDNM9lSX
 dmmrVo7glXwAq6gXMflVIo2OGh910S+ZjD6yV1aOYmxNqrtOj8H61DH
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


