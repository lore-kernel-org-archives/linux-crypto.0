Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.77
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792777388;
	b=HRffP9C3TFuv9n6pYeLR7EDaq1GR5qQZx+OuIxOOqTbPvYQ4Qfu6vm73gLbudO/TYVF6
	 VjeFgl4S+25T2uK04NZsKv4g8ze2vtXAVhD4ucsYjvr+DsCAUPBTRCKfhw1SYwTFtbrWr
	 JZkXoyArJAVMufJQZKE1vd+yPC0YV/ALa6/QfgLcoQNglEl+Z6nrIZHD4IPHXMgQx3hua
	 JNeROggGG/j2TMzm94uM3JOTC+ynbC98CyZsF8EFq2Dude7hAUgf9ZggA3NUAMCKo3ccg
	 KG2qn2m540LWa/BzloU8QlEHBM4lXeCgENcuRg1Hdhk3RXiz/APoysYnt7Tpf1KFpcw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792777388;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:Content-Type:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=YpSWxGqlaON6SsxX50rA1fE6BWx2GlQI3J8EzelVy0M=;
	b=4oHirJCl5NQKajpDn7+iXYd1q61ykbfgN0sNFLwvL4wmVzPfS3lfxZPo7yJCNODFuUni
	 oU1WJY1lW6N4q63G2gyPeMe+BiIJTvmWqeEqLyYza23Owk07jgC/WKJxfv4PpbpNFbFmH
	 zkxXgMG41/C8FxZlq+9IOXh4drDZ+N1ZNkp8aolYCU8x9qQAQS243sGaqOv9YH4Z6MsoY
	 ODDiv2t820ApTcaVcdTOQCNrrQ7ZLdK1SMWovpkFayRY8sVYzECW8FBOiChnKtcKAswaW
	 bgsLksRIYB5fe9rlUfetojUrbIGeM0S20yVy0MhudI6N/CGOC1IyKz9VYigiaQrXQ6A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rambus.com;
	spf=fail smtp.mailfrom=rambus.com;
	dkim=pass header.d=rambus.com header.i=@rambus.com header.a=rsa-sha256 header.s=selector1 header.b=STmuhjBP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.77
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021077.outbound.protection.outlook.com [52.101.62.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED248606A31D;
	Fri, 23 Oct 2026 17:43:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED248606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rambus.com header.i=@rambus.com header.a=rsa-sha256 header.s=selector1 header.b=STmuhjBP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wPDQD8wua5IXogbf2E7M5IUPgdHrioGYZ5CljDlQsibJuexCAHTeiQSezIUQfHS6gqN/en+tHafnBZnYQOxPUi47Wn0fIkYSOGCOWjUou71L1e+xE3U/rTIKdXtWxEG4L+CZZ2S2ZrxlO1YBhuVnMQFAGBO7iHyR9EhikGcL9ofOm8DtewJz5+I0j9xEcuUm6RkPtJN895ORcCp3dAvU0zVi545HtA3FzcwBU66Ug++0K9YS8suUz0fAe2EJy5ty8LpELH6Xzvynhl2n6epi/RV7MJVCo0Nce556a5m3gcvEqg0RZpw5svFelo53Oo1kFSriLS00zhxI130OF/2yfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YpSWxGqlaON6SsxX50rA1fE6BWx2GlQI3J8EzelVy0M=;
 b=qo7wv5Pk/0oyL7jiEb8GrWTDmo7tauEpZyYYpM+HUJ52vsHrJCKSQnFI8Th4M99/Ftw+M2fnejL6O6nGSQbXbXt6DenK2FX9x73dYwxi4vNr6N/ka1JAK8681Q6FMvlDvQrMgTe2Okp45nJXOru9FawCUpCzwAEKx3JEfkQCBSeQ6Xq4VbpYHWE4idCLhOmNDAzM0UtOHiAm7nZO0Vbp83Zly6VqpsNC4ga8ieXkVhqw353525j9ISjxXYsPicDV3veqJtN2cnY01QgBWf3qzLhZBWh18H20el7X2lSTx0WmiudQdTHdmbPFM37liImh1q1HOEa1MapZiE//yKd0NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpSWxGqlaON6SsxX50rA1fE6BWx2GlQI3J8EzelVy0M=;
 b=STmuhjBPao3rTueK2+ZP6JQqp63FfUETMhvM0J/aa3OM7OJCmLpA2AZNkTgee5ak6xOnPUYBeZFCORbYus0V7lmYRPe/a9YOkEdi755G7qsdOTj9EYePc4E2O7wc9d5H58vM47mJEus1mTyZr7+lDB9yFymXCrsdsvGtiEPAQiQkQIyHaf8v2hSdckngIp/B0uJB6NMF3OlZA5XhaubItGXjDt2mDDi8ZCr80AFivRZHnW2oHBCqGzKfvKuOSXEIuSmLdunYLX7Ql1EJTASIKtaaKay004Cl5c0PnuMx/5AYgEuJpRyoGQNmpzPOzMvYgexw5ZxhREbWW2TMVwEuag==
Received: from MW4PR03CA0135.namprd03.prod.outlook.com (2603:10b6:303:8c::20)
 by DS3PR04MB993994.namprd04.prod.outlook.com (2603:10b6:8:603::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Fri, 23 Oct
 2026 17:42:39 +0000
Received: from CO1PEPF00018868.namprd03.prod.outlook.com
 (2603:10b6:303:8c:cafe::44) by MW4PR03CA0135.outlook.office365.com
 (2603:10b6:303:8c::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.19 via Frontend Transport; Fri,
 23 Oct 2026 17:42:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 192.86.86.210) smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 CO1PEPF00018868.mail.protection.outlook.com (10.167.249.153) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.4
 via Frontend Transport; Fri, 23 Oct 2026 17:42:38 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTP id 82F62180174C;
	Fri, 23 Oct 2026 17:42:38 +0000 (UTC)
From: Alex Ousherovitch <aousherovitch@rambus.com>
To: Alex Ousherovitch <aousherovitch@rambus.com>,
	Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Cc: devicetree@vger.kernel.org,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thi Nguyen <thin@rambus.com>
Subject: [PATCH v7 1/5] dt-bindings: crypto: add Rambus CryptoManager Hub
Date: Fri, 23 Oct 2026 10:42:31 -0700
Message-ID: <20261023174235.3366294-2-aousherovitch@rambus.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261023174235.3366294-1-aousherovitch@rambus.com>
References: <20261023174235.3366294-1-aousherovitch@rambus.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00018868:EE_|DS3PR04MB993994:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 4fcb5789-8010-410c-0aaf-08df312d0830
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|82310400026|376014|36860700016|261022105027099003|261022075727099003|56012099006|260925022911599003|11063799006|260925021911599003|260925021311599003|261009221227099003|261009223027099003|10067099003|22082099003|18002099003|6133799003|261021121427099003|261021135927099003|13003099007|3023799007;
X-Microsoft-Antispam-Message-Info:
	qo40YF7PEbtFxvL3R5NkQwmCgErEpkJr7o0DtC7LsNHupgd9A80x3gph74pj4iUrKSeswQrnR+gVS3rLqSWr8kNOxAZ/liD8HUZmwR1kFOXnMMrL9XZnnnQpmJGwN4R7JDILEEgnZqiDfUpbDBb5uQhaW/PkEpBC6lLm92FjvalII4ngchGkTgIJaXR8wN6E8Xw0w4J/4t6ZOPK8hWjEdKxKmR3PiMf53M943s/8Rx/rtDsXcXn4vm1MYqtQ857aZCHaGXxcOqZfmdk/cJqXBpPb/OavswpfSGkO8HSwg4Z2+phZqSVmdIy6f7AKUi2izDqv07jZWcgSx70Bqx6RPiNn9jxNI5eH1bYEv8dhzGQakFotlh+cnSnRmLzRrwZG/RhgOVuDeLDPH7HVFOXlej95n3EgNChUNDxDX1ByZn9//SMuGftku/DcMgMAqc91EBZ4xwHMoTfwC5AG6QLFznfheXQvCxEWy5WBprT3cg+CaLqswxVVHaJHURggXwIBOqaRN8P5olpLsAcaih2YIP4Qg9wPciuDVYjnm6ZHiOaDRsQz4suy6ycDVL41xZ0tD7mWHzWJBSi1FpKPxHM1nYxcLDQBj1TkRK+GU0F6gGYmwCFxX2B88JVBj/aLTwYsrtBP+tzRoWuI+F2TDXxvdw==
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(82310400026)(376014)(36860700016)(261022105027099003)(261022075727099003)(56012099006)(260925022911599003)(11063799006)(260925021911599003)(260925021311599003)(261009221227099003)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003)(261021121427099003)(261021135927099003)(13003099007)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5GZNBHTcN6o8xklvQqIPeIF+fo+2pX+HdQ0WjCGe108NgfQ2CCrNRU9SZQwohmjsaDBOMiggZxEquNSAWR4bDTrjNJPOpzM/yEDYXpAVSYzFjWJSsMUgr7MboB5EMzT6bHAkTyW23wVKbKzN1mUffdPRt4xWbsV/VQMwYqFLZ9iyiwoxY0wL2PsExT/9vOUEx6bp6Han53IlqhJDpRBSNaGANS9mKx24G1SwWL90TA2zs7IXZBQedK6XdmkgKafUghNeXA/XT9kZh25dD8Ad+EWlhaEEhjawk8MUd1Yppm0GIok38bDAAyJ3UGqWLUehxUbakOYbqyW3CvMDmoP6YsNUB/iD3EKi++64JtRuuuoeQhZEM2cvCCKRhuUSve4tbn9c24mdjUD+l1sszxGb4XQpc0XC27442LQFpBstda320QMUhiBp45C++GrkIRBg
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 17:42:38.9659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fcb5789-8010-410c-0aaf-08df312d0830
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00018868.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR04MB993994

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
 .../bindings/crypto/rambus,cmh-v1030.yaml     | 144 ++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
 2 files changed, 146 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/rambus,cmh-v1030.yaml

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

