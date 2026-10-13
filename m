Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11021110.outbound.protection.outlook.com [52.101.52.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C05052CCC5;
	Tue, 13 Oct 2026 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.110
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791913767; cv=fail; b=JUHPJyU2DH0LuV9sKfQnhn5tnXOrbDdf8mxr/opqrnGDEfh6bt4eIRHm0RoyZ5t3bKXHWCexEBKtYudzAlJAz8RZuK2Lb8RfPJNKjsGKKJooQ8Zdm1IoLLASLozDDJDLqerYKK5voP9kYXRxn5Q2a5kXflhaib4dxD4HuPfm42k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791913767; c=relaxed/simple;
	bh=HlF2St6LO9lI9qHyHxJJTk7I15tcjxGiV6l8ilYDsb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RB76K/e2vt98Wg3b8/gKjX5zq6P47s72N8f3RnHeiLoxqV5uGPpEySoUcDyhUBChY1W+ItRaJm9yAEQI3WQOJduoOPu7JG/gTiu39UhLWyol6H4WgH4ylE9YCKpA2goIb2CXgfn+kr/zdijAAGZQiDxv/fn5mOCNeNN8jDcpEJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com; spf=fail smtp.mailfrom=rambus.com; dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b=O2lZoZqi; arc=fail smtp.client-ip=52.101.52.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rambus.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=rambus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rambus.com header.i=@rambus.com header.b="O2lZoZqi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YeogGA307ROGGxh2KGfMhBzRfbtzPML1cQpoYwLfHPxrj3ojqFgSkrukYSAKOAAXZXTwwIO9j4BrCQ54NY4x3fuRvpzj1GvnbQQ57DQtkzKp8pQa38vCgNJs5RlJBXUhieVR3o3hDhcI/I+2EQQB66pUtyxPK8n1AwznyNBOc/Nd18xfyRfazBDRmL5i4G2QVb0I9nSv90KPycmR08ZYE985ZnTMU9JsEtZchotmhOZ28u0vg7m58oPRtnCAnvlldWYl/wdEZB7rIv2JTM9pU6q2l5QMihLS2fwXja5x5DobRTGxMCFYZ+0STgqZFTvvC7uJUq29tjhvM5VWk7Qzkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Un6m9BzqdbJzDANlwRuCf0804P5mKDbS5sncC7N902k=;
 b=qSN88BCajF/bYtGdPxJS1/4wd+Ozgi6hEwBDi0Us3ADMX7aEjX7kK8p1W6k5WZRqF3b6MKtAufJ09S9ObGKoZajFTTkwnCpAaMiHcs8Iw4H28FiA3RiYogubCe7y1vKuUnAHdbm+LSjAkIaMPHGv1jfmvL4UhWma78PY6b3Vd4Y/65bP9qLFjixE5KdzAMPqTE6AyzuMh9x1zXfHXCX0YFu7uJrw0+2KUcm8WucZFGvdNHvItIfEtXGok1qVHYAKHA37HuJ5kv0Ir7uhP8KpWQlS6bbvLm9+Ny4IdhK5XM6y60kAbiMH0NKixluhaFNkeW8OCX6s/I4a7nV906zGrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 192.86.86.210) smtp.rcpttodomain=cryptography.com smtp.mailfrom=rambus.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=rambus.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rambus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Un6m9BzqdbJzDANlwRuCf0804P5mKDbS5sncC7N902k=;
 b=O2lZoZqi3k2w0jgTNFQNcT8XD4FSn7pZT8HST9nC2nWtfViHD4dkW/HJmTzpgrJZd8/KovBsg+fizUJZZol3zOQJcC/tatxSvEW2Xrjn4RAguLo/SqussmXtfKQ/k6TvbOd1QAopuOpUo39mtqB0fQ5qG7CWbCH5xygw9wShfdxTiU25eqoBfA4LBmAivyIWc6lskvlrSb4+1Lkqv3jM3NLTCaBDnbLU8GBpelQRJ2iO6rfEUFzbMI76PhyFnRWv50WCuWDWJ0I1JZPa17A/hC2qtNQK7nAlLXZeXUnnphQcwCCc2lXrMrgyc/c4uWexAtcgQEDgWgZBsDaCTBWFoQ==
Received: from SJ0PR03CA0378.namprd03.prod.outlook.com (2603:10b6:a03:3a1::23)
 by SN7PR04MB8530.namprd04.prod.outlook.com (2603:10b6:806:322::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 17:49:15 +0000
Received: from SJ1PEPF000037A5.namprd04.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::5a) by SJ0PR03CA0378.outlook.office365.com
 (2603:10b6:a03:3a1::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Tue, 13
 Oct 2026 17:49:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 192.86.86.210) smtp.mailfrom=rambus.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=rambus.com;
Received-SPF: Pass (protection.outlook.com: domain of rambus.com designates
 192.86.86.210 as permitted sender) receiver=protection.outlook.com;
 client-ip=192.86.86.210; helo=hqxsv-psmtppxy02.rambus.com; pr=C
Received: from hqxsv-psmtppxy02.rambus.com (192.86.86.210) by
 SJ1PEPF000037A5.mail.protection.outlook.com (10.167.244.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.6
 via Frontend Transport; Tue, 13 Oct 2026 17:49:14 +0000
Received: from hqxsv-cmdev3-aousherovitch.rambus.com (hqn-lb-int-float.rambus.com [10.12.20.20])
	by hqxsv-psmtppxy02.rambus.com (Postfix) with ESMTP id 6C4611801748;
	Tue, 13 Oct 2026 17:49:14 +0000 (UTC)
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
Subject: [PATCH 1/5] dt-bindings: crypto: add Rambus CryptoManager Hub
Date: Tue, 13 Oct 2026 10:48:43 -0700
Message-ID: <20261013174847.2192609-2-aousherovitch@rambus.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261013174847.2192609-1-aousherovitch@rambus.com>
References: <20261013174847.2192609-1-aousherovitch@rambus.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037A5:EE_|SN7PR04MB8530:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: a627a5d7-65cc-47af-fbfb-08df29524bcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700016|1800799024|23010399003|11063799006|18002099003|22082099003|56012099006|6133799003|260925021911599003|260925021311599003|260925022911599003|3023799007|261009221227099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	N4aLUGD2IgOwzYuaCu0iG3Rs6Qm7s/zfU0CRjkcQAOQLpz5K2uGDzmT8iMlPUfzwS+UWhc+ySAmfW3/g5pHf88gTR9RRn1wSAlJzEvNN2tSwgryibSW9h7xM3MZwlUAUtNejp383JUvRNNNCs0Pm4+WXr+hKQUsJvA5WxCzm33lTfcLauZYCsuMKEb+9Q6la14IxGaXPMTs/Tk90k7c/795Mp6JfLBAmYydip/hso2yokz8Qa68ZnnfDHnG1F+OFdcaPvEWqi6V7zJoyU95KGMQWyFlyKgs7GWjzNlJIbjJYV8l1rpIfZ1B0y/rPUStqn01h2oCFITL43c8UTHPI7cy0tCyPQ5j0Z6IbpCeauFkd6ds20TXndFoMWs1HjoDoIKC0PSONCK0HR27XLl8T1YPpaEy73U95kvMTZpFdlL5R/u3c8iEyvTRNPuXz34zR4WtD03D+ghiA6B+NyLxGySXgaz2Om396tQdlA6DBXc/HLYHlp0cMpYgYkT+lPxB9B9WEg/GzK0XnqS//pfQNS3npcQnuZeUCNOhRLnRp76GgsAMrCxTqruTG45Jtr7MSmPRpj77ihMo9T8h61amW867OvcF/3Q0HlO0iF0TzdfjWSpX220igDKWnqxCy4DrF6aRS24bNa0Yr4vbIIhtCwQ==
X-Forefront-Antispam-Report:
	CIP:192.86.86.210;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hqxsv-psmtppxy02.rambus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700016)(1800799024)(23010399003)(11063799006)(18002099003)(22082099003)(56012099006)(6133799003)(260925021911599003)(260925021311599003)(260925022911599003)(3023799007)(261009221227099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7qNiL4Kq9odDzwMwFAOTQxHN6tevYwT/YwouUuDe63UcdMZEA7J81svofyFehSflu25pK0QX0TkZ1nk7DMld4hP5K2MtU59iKhks4zfBOZPPlKc0PTmFvBOOZ8492bVR6HnZW2vo00cpZS5a8tTSVEJBLi8740AKvNY1k7+A5DBn2EY5OOZmSY/Y6TjMKfgMyJHkJreKtkN+MBc50UN93CpPM/QKFPi0urz9ZsTlYXN1d/+r/MLNKXqdSAvNBylXQ/rU47Vd0NQoj57PUH5eNGbfnlMeTJ0s4/gUiRRsnOlMFxswi5eGh86jaytRedzjq+OnEVnLMS4KhOkfkAquMTNZOunwr5hBy6b1/HKayz3bszMdb+ALvNAANVFBEu8toJhT57Xdkk6SGOl9Ya6+fwHcH2Be74RXo68sEaqOHJYlF/FN8gJEgejEtmUDU+PF
X-OriginatorOrg: rambus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 17:49:14.5152
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a627a5d7-65cc-47af-fbfb-08df29524bcb
X-MS-Exchange-CrossTenant-Id: bd0ba799-c2b9-413c-9c56-5d1731c4827c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bd0ba799-c2b9-413c-9c56-5d1731c4827c;Ip=[192.86.86.210];Helo=[hqxsv-psmtppxy02.rambus.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037A5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8530

Add device tree binding schema for the Rambus CryptoManager Hub (CMH)
hardware crypto accelerator.  The binding describes the parent
SoC-level node with its SIC register region and one queue@N child
node per mailbox the host owns, each carrying a reg (mailbox instance
index), an optional interrupt, VCQ ring geometry (rambus,num-slots /
rambus,slot-stride-bytes) and a rambus,cores affinity list.  Which
crypto cores are present is discovered from the SIC CORE_ENABLE
register at probe, not described in the device tree.

Register the 'rambus' vendor prefix for Rambus Inc.

Signed-off-by: Alex Ousherovitch <aousherovitch@rambus.com>
Co-developed-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Signed-off-by: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
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

