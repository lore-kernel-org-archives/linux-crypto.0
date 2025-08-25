Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACE9199E94;
	Mon, 25 Aug 2025 07:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756106236; cv=fail; b=Kgb1e/ldJ6AfAp1ekbkNDS2Ce2xyKjkTmVSQqr/RmoqBUZ6UkGPZH2hJv8jIPWcygV+9B9rYuX0edMnZpknOmZtZp9zKEaBmPRmEu+DSll0LBsKwyqhWl766b7w/0oU+qbDvlt3/Vz/Qw0UOnlXltEEzdCUHfN3z0O6tdLewi/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756106236; c=relaxed/simple;
	bh=z1rQa1KExjGTvkpkBikpDQOZtaSlvN4IZXq6kxSffp0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pPkKRyOBCNI594DB2FUWaoGn7cETUS4oRF65KWyMmaGkDZpgzZniz9o+eKb2wdt1s+3c8meJEcKIeYQBegpZwoqxlxlcU/xnEU6hp8NQDGBB0kXpXpdHOx4/HCvxMTBVtUwqpg5S5ryhzgYg7n+uIuoMcwuZ3AF4mdjrDrOeDU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jE1gYqt0; arc=fail smtp.client-ip=40.107.236.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jE1gYqt0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yJV8jS7C7YbVn7bIbFoTH/1w7wcJkVK7DoSqMPXo+J3w/KKih9fc7w5EZPo3pEk/iXI/iCbkW04UhyuOFurk78+MQRZfc8oq2m6YtBAnE7XgnmL9aRQjWLff8SnjImR+i3Zma4sZXzl+EgP3gPl40GKLxMOi/uspuB4weczSi9r5tbtGQ8RuiIxAHrS4HwW0ZCy6Zs4I/MdvRH2VhF/rs237rsd76yf8u9zPgHejvxdEiPpVHO2HXBAF8AM1Dgi9tTux4DzhjUjT12QyY1qcxZAjEDc40DshE3EzcAzkTnrdhW/0inndnPCaqvGExUATR8g56bq+LGu/OvtRFEsDdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvm71UBt8kaXxh25zzJ0w8itodZOCLAKFR3pPpUuD/o=;
 b=o9iyk+mJF8SA3o3rdGxYZJsybNj/tavK0F1JeT3sscjfaaPe01gxwczytfOH1UJyEIkCJtPz8R8FIQVP9k9nxHK0Po4ktx9lzUz7cwm4C/IYB7jIPfJHWZvFWgflAHRieyaeNHQ7Pw92DskIYcjf8PTzF+08hxjfngKzt3baeLs6FKI55MH0YLy7k1oDpd9NhtnJDj/TkI8Mhu8s5HUpneHz7ivpDScHbacYP2jP+xBiQIKqE3HWnDTEipl9A3cMvpNtvq7BWLPrC/8k0fBfYLX2EGM/daqV9L3GOOqRHRNo+A4iFH//SdVYXkjit4y792BKW8tS1YXGseTY5OSfsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvm71UBt8kaXxh25zzJ0w8itodZOCLAKFR3pPpUuD/o=;
 b=jE1gYqt0cWTZUKNLyI0tYU7AY5Rut4CcWRUAkDJ+RknhnaGJORj/p8MVVR94GEOQMOuuj2ZSjxDC+nwwHN4Sq+a8k6JluooLnxAuHezxhFqwVW6vtM3+BTebKWIUE9pCrYYHQNOs9DA6OxTt5MxeTqn/tdruAPL46bgeL4ohJpE=
Received: from MW4PR04CA0183.namprd04.prod.outlook.com (2603:10b6:303:86::8)
 by SA0PR12MB4365.namprd12.prod.outlook.com (2603:10b6:806:96::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Mon, 25 Aug
 2025 07:17:11 +0000
Received: from SJ5PEPF000001CF.namprd05.prod.outlook.com
 (2603:10b6:303:86:cafe::35) by MW4PR04CA0183.outlook.office365.com
 (2603:10b6:303:86::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Mon,
 25 Aug 2025 07:17:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 SJ5PEPF000001CF.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Mon, 25 Aug 2025 07:17:10 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 02:17:09 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Mon, 25 Aug
 2025 00:17:09 -0700
Received: from xhdharshj40x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Mon, 25 Aug 2025 02:17:06 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>, <smueller@chronox.de>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: Harsh Jain <h.jain@amd.com>, Krzysztof Kozlowski
	<krzysztof.kozlowski@linaro.org>
Subject: [PATCH V6 1/3] dt-bindings: crypto: Add node for True Random Number Generator
Date: Mon, 25 Aug 2025 12:46:58 +0530
Message-ID: <20250825071700.819759-2-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250825071700.819759-1-h.jain@amd.com>
References: <20250825071700.819759-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CF:EE_|SA0PR12MB4365:EE_
X-MS-Office365-Filtering-Correlation-Id: f6733439-7f32-45bc-0197-08dde3a7682e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u5mt0zR65mbOLpDUhAeQBVHdsAGBhDscTC5x9BQQi5hQuVujGurnBDK2DgsD?=
 =?us-ascii?Q?L9/b5EadY0jKdlF8CwWpxdYBmi++AfRyK8L0wea15yjgB0WG66gJKVuAHSW0?=
 =?us-ascii?Q?NayDrImG+3mBAc/l0SW6DCEvELekdoV7rKv0ebt26HpCh/Ng5y7ESedD4qZ+?=
 =?us-ascii?Q?oNuW/FGcm5WFzOJga32b6ZgAWMoeI8eTgrVTkTqJF9hcKrKthfF6sS4JXsdR?=
 =?us-ascii?Q?XQud/157JEfX6tvbcs85mAm6mE/QGJQkHKImswwWalG5/Q41YLkwPX97A2ii?=
 =?us-ascii?Q?cxFvUuJSq39odCJSrmYzIdapdT+qwrAzDnZf6RtkQc/6BSVI+NHsS/CTEV4I?=
 =?us-ascii?Q?io0OZZK1e3FjnYL4LIsnFhJqn6k/vBpyZ1ZUPVCgtlKHR9C6I+c0x1citUPd?=
 =?us-ascii?Q?G7rE8HhBaoUF7faRqWDA31vcErdkKPapUzDVXODSF16+qMFFsW/pJpjkqfgv?=
 =?us-ascii?Q?NXq9rD0mcdxgfNMybxpOkoZlFy+0TR5AEfJfAgLSeEQlVoR8n1Y7j/C/J0ow?=
 =?us-ascii?Q?1g+bA+3px76A+JJONBv8h0UGU8OSI75jXV3CvNdjUby9yADVzAqIHlcjwQGW?=
 =?us-ascii?Q?5cFgCgMHDTQ+J+Fqismzmz4OzyA8SZWj/GBHddlEbt45KAzblYtxQakcUvUg?=
 =?us-ascii?Q?EgFc1LQ7nGN2UkLDijIU9H9cXqdXei1ZCGOVIPoEIpNl3qc8ilWyfy2b/V9M?=
 =?us-ascii?Q?WAn2E1Nfp1b7LM4ktIyppGLPCexpzWGpfGmi8+1MEezzxKwNiJkTYAx6q15f?=
 =?us-ascii?Q?us4tiuyvMQCrB6G0+ULPRopvwnQJdUQf6icd7+vCEhQsUYPdWIp+Wx5V5B6V?=
 =?us-ascii?Q?emspguhz7fyhAPSbkMewDJkv7mftdGmzVK6eyTss6hmf2uPV00QUEKkeyPaf?=
 =?us-ascii?Q?D92Oi0RQxkrc0gS5bK82l5TwCwYR/UhHyhQlUaVyBZaovPUw5TOJXIxtFQcL?=
 =?us-ascii?Q?3t4SzAcJUM/q5WKj0vUot60XhZhpJxNPI1y4vE2LY+TQ74yOLwaTfwg8z2Pe?=
 =?us-ascii?Q?gHwLZ33SHjLDZd6XcR87lt8bXSwGvhPPZfvCp3/GB2+WOa1tWtTfp8WtR4+T?=
 =?us-ascii?Q?GsEi4ESUnXTCoIzvijUf7ab6zMD85/KaeDBopIbpz6HXGFJJKe5V8yMLpf0b?=
 =?us-ascii?Q?8ycyprbbIJ/OTbN/yaiFH2SKwdU3oHO8H7iJ1Q/HbVnCTbdqFegR+OvWO6c1?=
 =?us-ascii?Q?kbDed2K2LnP3SGTXR2wmflTcLhgeoVsjwIiq48Rbjh6qTzdHDHAnCJqvKVAd?=
 =?us-ascii?Q?wEcd6QW5ra8tmWwb3td0Yp5FTLPUYhNi+WtrhuExzgdaBr0Yk8r0g2ykHEJQ?=
 =?us-ascii?Q?GduIpDeyYfHoFBWHBTX2Wb4WeKtg9K1dWZuZ4QF3JlwltFlojqmItpvb+al7?=
 =?us-ascii?Q?NAQxeNjKlIHXfKgMJyNIkzBDgzi/eUQ3BYAPakHhb6L5TH8Hf3Gj4+7Cbwcg?=
 =?us-ascii?Q?qg+CfldAp8D+0nPrB/OcAtg1phw7D/2e4xHIXk88hLRbBjvkfOA6KMKfvIiS?=
 =?us-ascii?Q?k2TlKLQhqnfU968=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 07:17:10.2022
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6733439-7f32-45bc-0197-08dde3a7682e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4365

From: Mounika Botcha <mounika.botcha@amd.com>

Add TRNG node compatible string and reg properities.

Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../bindings/crypto/xlnx,versal-trng.yaml     | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml

diff --git a/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml b/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
new file mode 100644
index 000000000000..180adb96e5e7
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
@@ -0,0 +1,36 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/xlnx,versal-trng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Xilinx Versal True Random Number Generator Hardware Accelerator
+
+maintainers:
+  - Harsh Jain <h.jain@amd.com>
+  - Mounika Botcha <mounika.botcha@amd.com>
+
+description:
+  The Versal True Random Number Generator consists of Ring Oscillators as
+  entropy source and a deterministic CTR_DRBG random bit generator (DRBG).
+
+properties:
+  compatible:
+    const: xlnx,versal-trng
+
+  reg:
+    maxItems: 1
+
+required:
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    rng@f1230000 {
+        compatible = "xlnx,versal-trng";
+        reg = <0xf1230000 0x1000>;
+    };
+...
+
-- 
2.34.1

