Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FF51A9FB0;
	Sun, 17 Aug 2025 10:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755428053; cv=fail; b=CVjSOtta6EpHhUoCbgzmzeKU7v2/xXd+v1bU69spuoLFnAkRGszYc01IDzqSpv0gwaDEud1rOEzG3J3NwlxxKNmrQrCktWC87TPHyxWdELmVeNOPY0uNUZaI76xFw1y1eDcZv5086jHtEXm6ts5wTyffF57Y5WA5isOvhxUrt64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755428053; c=relaxed/simple;
	bh=z1rQa1KExjGTvkpkBikpDQOZtaSlvN4IZXq6kxSffp0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XUCrWSvQtKCFk72kYADACBt4SueTeyY005AKyXgkQWcvixb7TRb1NA/lgrcqNvlWI1CMsynPBHuGSrl4YwS7OXDqCZz2LfNsHsqXcsyt96qcy36esFNHhnhXWZrciNvLHYkRS8uvab4yxGE7I56AiIsKuMX2jjEffpILPMP0Wuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Gf9N3Se2; arc=fail smtp.client-ip=40.107.244.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Gf9N3Se2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ncXejBoG5riUQN1f7eGbu8qBWQlBjU+olUtAcim8e7XY29gZ3y2V1XC3sh5WNGbSqsoN/SpKLglUv2gUCbjzHjFSdqJHK8y7/X5PT0v839MsXhW/Uyzy0OypRKU1pIRh/ohPlRUP9wMT0ujTbJWt9R6JCKjCLK/uJvN3Ed4622T+T1AiTpeBEN0kDrzM+JPido5U3UBQkpc5iV5+S6WfFvylW2EG4tJR/XdtcFluZliRmpaYZtGREjVkoAdib53PQqA30s7XXe+IFe+obrl+0RlzqnWeQbT6tZZMOyb5muvHgUOomiilNTxKWWNcz/EpIg7ysf9flpjKbnf4J6qoXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvm71UBt8kaXxh25zzJ0w8itodZOCLAKFR3pPpUuD/o=;
 b=mmI5hzCZ2CSSZv9fYZKMsXAjQ2biZbv2F+xOCW2Rab5XF1aWlp8W8LvMWboslJ1zvMdW3DBalRFNDYtRQRCKpJ1Zv4DSspPG7/2+vT0SoGWKed/xXTGnvyg/6yOa4nSCQ2j0uBdOHMdWTQedaYRF9gM1gKaWYtig9uoybyQAYe5Lht+29ESL1VtpL/jLxCE8+3qjpDemgSVcnLCJ2AS3B1zC/+VI21KNADhsCPY8QytjHLoyCO7DKen/qUxGx55rAtQctu8S2QZpNkgB9Vsi89Snnuq6f6QTB0SnO4eGGS1qLUvJgkO6SVgQQqkdGE4/Kr76Nb4dxw46nqpvnfHwhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvm71UBt8kaXxh25zzJ0w8itodZOCLAKFR3pPpUuD/o=;
 b=Gf9N3Se25pkiAG81wE6qBI3dvBmpY+vYtQwzmhrP0WSsvt4HlG8PsxcLE5We1RUwCjw2hn9+szByXfS+t9T93C4avqG3CFjkynGFZJ4MANpEuEIlZlooOrAh9ccKbTIeX4cERer4NuPxsTgXV6A4mdfSReegxSOHoi+av6WCvoE=
Received: from MN0P220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::11)
 by LV2PR12MB5847.namprd12.prod.outlook.com (2603:10b6:408:174::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.21; Sun, 17 Aug
 2025 10:54:08 +0000
Received: from BL02EPF0001A0F9.namprd03.prod.outlook.com
 (2603:10b6:208:52e:cafe::1a) by MN0P220CA0021.outlook.office365.com
 (2603:10b6:208:52e::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.19 via Frontend Transport; Sun,
 17 Aug 2025 10:54:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0F9.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Sun, 17 Aug 2025 10:54:07 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 17 Aug
 2025 05:54:06 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Sun, 17 Aug
 2025 03:54:32 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 17 Aug 2025 05:54:03 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>, <smueller@chronox.de>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: Harsh Jain <h.jain@amd.com>, Krzysztof Kozlowski
	<krzysztof.kozlowski@linaro.org>
Subject: [PATCH V5 1/3] dt-bindings: crypto: Add node for True Random Number Generator
Date: Sun, 17 Aug 2025 16:23:47 +0530
Message-ID: <20250817105349.1113807-2-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250817105349.1113807-1-h.jain@amd.com>
References: <20250817105349.1113807-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0F9:EE_|LV2PR12MB5847:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e386c4d-8a8f-448c-c03a-08dddd7c637e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dHmss7mBys67eSn/nyBSLVWNaMr4lFgqzFhtwOCdb7qCieQM/uQcAOu6i4Ho?=
 =?us-ascii?Q?4EKd5ypCxXmVgxg4E2RBMx0BLKGB3HfOYVMCTSodBV3sXVpwvpilODza4xrC?=
 =?us-ascii?Q?t+bAoT7953FRMOxglXLqfl/vxD4CqpqzDW2gd4lokalun11pNiL8nME3s1Fo?=
 =?us-ascii?Q?QPgV+vjPLwSiYH3Ov1z6O+dwRTI8x/lnr0KZ06w3HlIE4rs8tBahabgZuWH4?=
 =?us-ascii?Q?YqCqzM7nF2fVE2CCogqOZ/7LN/BAdEZzsW2TUpvNcglIV3kgT34gE4gQZeCx?=
 =?us-ascii?Q?FIFNTWRDLwI1AvJoFRY67+NeuXosvmZ/0Sf6NtTJF55nGoQ1jLXFXlFsIqsE?=
 =?us-ascii?Q?wGAABfFdh3VgkmAMNmvrulP1DbVMIxk160oGYy9mZUuIAOFpNISEbXJ0tYE4?=
 =?us-ascii?Q?lbK9tXBZjhgJASx/CLLEB0q/bLK+KO6rTA1Hmatk1mYfhv8GQI4/4Ef2jyWz?=
 =?us-ascii?Q?r+C8VfPdU6vxnlGgCt8ppiFf4s/Qb4y8juU8+ac5SjBVOiSqYMm+gEOO+oJe?=
 =?us-ascii?Q?nCtdQ0IoFNzmA19HDTeKCRCc43cHA/axy0/f1bne2w4IAXgSkjDGPxg4g+09?=
 =?us-ascii?Q?gf9HddUzyOdeEFyk7+Rw4JgU832Ot3NIS8Gyqp1IT8DbztddSPhc40qV5Fw1?=
 =?us-ascii?Q?L510UiD3A44zV6ioJShdDsDPKH9ZAKXLa278xU7edV1qypF+yDXPh9FgPmDA?=
 =?us-ascii?Q?fk6tw+XeW6GXQwHnIgHgQpt7FudbgvxJ+CuF+3gHPSuWEj0qsSgA0zFuk907?=
 =?us-ascii?Q?kuvkcTBFlZq/cPW2fpscuy74v2hp52O6aAC1/rMudckpHkLDHBMpr3VBeSe7?=
 =?us-ascii?Q?yVmImQrAkjRrhcYRVeNiQctPDqlmeYMceXWl+FO+uUSweo4yRdfC3ggE6aeY?=
 =?us-ascii?Q?OowCYaCG6s+CGdVCdZuoxvuPwrFn4E2vyECEMLeugx9/2HO3L8Cm7XDYH0r6?=
 =?us-ascii?Q?4p3y1jYSPTBeJqKlqwaoRunULgNxJ1/KalDDcgijYiNHKQSo6kgVk/OxZteP?=
 =?us-ascii?Q?LBim/ITX2umJa3nbXRVTasyIQjHiarsnH7qViG7myryhkNBOP1xiIpJgKnGL?=
 =?us-ascii?Q?pXnkvhFgNkoUr6PiRPjvmz4JtQNlUwx57JILPOrhkqRBaM0YMlOY6Q5A1I6p?=
 =?us-ascii?Q?JdOd701A9MXJgJEiYsNHJePp+HG0DwvmHEWdxkAY9IYt/JD0cZz0HybvLwGM?=
 =?us-ascii?Q?5I26ErnRZkVMf2oewXGAsIFkTFJlC/4B9WE4Okj/U50QGHBd7+DdE6l8HCxi?=
 =?us-ascii?Q?za4WY7YKdMa5PB2dDSasfDiJCzwBkg2hDbBiNzcnMzxbw+L3Vx2z/19BAmP4?=
 =?us-ascii?Q?Bf7QqO0z1hAccB15UhZbuOG09EZ+hGmI/zbCAyTFFII6haLsuq305tOI1bsL?=
 =?us-ascii?Q?OHqNoNMCvIQGKyI9qJfT/+aYoGHgt0EyDK2pEa4vTxgPplOmeEyrPhhi2Vyk?=
 =?us-ascii?Q?E6E2/0zX1u8zG4oxAuNDQG2/LK2EYO2x7NyLhvuQs+y3zt21NQGEYLMTfvMh?=
 =?us-ascii?Q?SzB7kh37vwncy6A=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2025 10:54:07.0975
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e386c4d-8a8f-448c-c03a-08dddd7c637e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0F9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5847

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

