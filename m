Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF76D1A9B52;
	Thu, 12 Jun 2025 05:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706060; cv=fail; b=IbZOwtn5zNlkivLrmgqqS/hvYgq4M++0YqcooXfSaTHoU+qEperiE/SLCs1h1X8z/ucT3GhfzG6aG8/7Zl9TIxn/BkTizNCqzaR5RfJUKMNL0U1ywlz1GWjJpCDxjDv96czbtJLhThr6Ma9a7L/u/U4BkrYV89VFcy8Lj81um0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706060; c=relaxed/simple;
	bh=QeBXmod2ztXE68ZvqeRpH/PUCKy/W38m7ifxjsfHFBc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iMMhxSdbbz4b9GK6bwAjLDakQ1ZiRzyLdGHhy9T2RbVxvLd8Q/kfjAvGQe1VnOi62b4vfZl7t/AlCUDMsPnQC/5pM8cjWDn+TUhDUMagsI8mIvvAHxAnw7hD4xLrs44H83jaxTjRCy1G7j0Mb/mtsjU5H+KHA4gSwkp6QAc/+ic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YPhMdJNy; arc=fail smtp.client-ip=40.107.220.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YPhMdJNy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eb8PX/oTfq9fiDUAF36eVs2PPSMP4pUXqiK5u8jXZGmIAyHtKud3XHBplF5iHh3v0RaToUL2pk4XC7vCoFwuFllrXIiTuQH7ewJhfsPImMEOodU1RUGy6oEbOUGx7OxQhT4NdNyHvuoBgbgtb/TLRc32gTiwEbPoC0vHa7yDMn/7QQoeoKmgfYShbxbcHR2K1wW68JL2nA9sdpMdWm6sCn/8Td4kobmqtZuAgFgnLPiQpYxaBMNUVu0IfRYWuvuFaO3Ex7SQyIY2qMb+XMpPntaZxYeT2PoBQ9wkbInbC4AYFjJ9g4+FcO9yjXNxKjiHQnC0C7cpkYUYR6BwJGGMjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNbWjWw5UqLfjatXVYDO3nYBzdml2ijGOIN3uBkXc9I=;
 b=nHVFS5Pie3SXa+qst5+RDv7MixdBhGp0/O9x8skQ1yJFNudqiOz08YkQqLanha4AjfNTAjnw3V40xs85bGfIw6Zhw+NCF/FWreZ6utwJErbd1MvV/K13ZuRFOAOvaDvJNyH6i9GO09crIaGHrym5bhww+69V4GxWiZ0fJhqKvkP0Q/YC9qNPSNCzoXMNgUI8VQGfN9i2VG3qTTb1eBG2NR9Eqw9Wr9ptEvPN25UApt5M6nK04uiFiA9FTG//jAsJf/8TW8GvBXsiGh3ElsTEZgAdxRDW1ySfaUulk0+GMSKkgmHHSsjGsVnhYtOb+Fh/IfkP4ZrTZEpyCUZ02vhsEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNbWjWw5UqLfjatXVYDO3nYBzdml2ijGOIN3uBkXc9I=;
 b=YPhMdJNyTXwi/V/z6fEWmy/ShcFj1w29/ms82Dh7OqIHZUHwucbWuRT1reNvid+KsNkDw0we5eAFF4thYlFJ5djOKpyeyUuy+UBYxJcYs14QIJLTABgXwX49vzrI1+tXwB4hlMK9nZlVFVcnY6P/mEt5lPJSdMO4pmMrSZmgr0U=
Received: from SJ0PR03CA0095.namprd03.prod.outlook.com (2603:10b6:a03:333::10)
 by IA1PR12MB9523.namprd12.prod.outlook.com (2603:10b6:208:595::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Thu, 12 Jun
 2025 05:27:35 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:a03:333:cafe::3d) by SJ0PR03CA0095.outlook.office365.com
 (2603:10b6:a03:333::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Thu,
 12 Jun 2025 05:27:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Thu, 12 Jun 2025 05:27:34 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Jun
 2025 00:27:33 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Thu, 12 Jun 2025 00:27:31 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v3 1/3] dt-bindings: crypto: Add node for True Random Number Generator
Date: Thu, 12 Jun 2025 10:55:40 +0530
Message-ID: <20250612052542.2591773-2-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250612052542.2591773-1-h.jain@amd.com>
References: <20250612052542.2591773-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB04.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|IA1PR12MB9523:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d4a9866-66e0-4857-fc98-08dda971d668
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2RbGlfBh18vTcuJ5jZ0NlQVtbt+MCqrPjyPjf52U16EXTVH7EgPx3JTZDJKK?=
 =?us-ascii?Q?t60WNY2SlNCPdHvzZ8c4lZAb9aCRO+KHLwkSlLIejM2oYdbobXg2e7MJ7TR4?=
 =?us-ascii?Q?WgGKMaPhtvsofEWq3vFslqdKVl+96khoeDTuFN9Hqwhd7IKlP5mXldKQGHVc?=
 =?us-ascii?Q?zD4QihOIQxOGikg+LtfcagvQP6ANCkhFxhUpYPfqKlrJ21DOQhmLS5oCKveM?=
 =?us-ascii?Q?r/JtZVMus7Mi/ejdr5pjIuV3yxCUjLzHX22MGwSrYE2NNlevPu1XktQH5HK0?=
 =?us-ascii?Q?+CCjbrPkqDXc1mIb2LNTHNq/XTxCsYLd+rJGlRY8FWZWolLZn94qaASAT2+H?=
 =?us-ascii?Q?yAJ9q7ChyNqnoBBvGOiMio4rvj4pXlXhHrwr1s51xqasgX6ywNNdgeJ4B8j4?=
 =?us-ascii?Q?xjNu0rYg6HVdRMX2fSxjdLD3k/MN3Q7Xj94PMU98Sj20IWW8ER0WR8zaKNiB?=
 =?us-ascii?Q?pX7+wecAD3ptrZd/Pkl8UwO7p2AMdpQgZ7x1aaUkJeyWMMxRoJnyVqgI1yRe?=
 =?us-ascii?Q?C4X/UulMG274LawpnM3ZBnp+PwprSv1A02CJ+RlB9KZmGUFG8eDj5SP9XpCh?=
 =?us-ascii?Q?Q8Hbx6a6uIUIGqGwiUG56EXRmY/xWTaZ7sEZ5uSWOvuW9vOvi50+gzhrivPO?=
 =?us-ascii?Q?meb1cTlkCDQKCZVwGqAOAWswZkePrqX9Dz9TRpuLUlNdogsn2hYe21dHxN6D?=
 =?us-ascii?Q?ucJG4d7sk+gQmvGmorWPLTSukScxvER/jo/n/WUMKoTZE+7iGw7Ar8uYafda?=
 =?us-ascii?Q?D9HotffuHBATNgmjjgYG2urTT1owRqMmUfH4xlhX4zKGreOClF+fbKvROBtl?=
 =?us-ascii?Q?8UHZMjGL2pwzth6+Btc+GEchkCRP/Zvggi8zJ3hEhSkmqyhcp2ijGikvWyHo?=
 =?us-ascii?Q?BJISceTrtZvziQ5jmBpV91U5V9m4QGwNt5FTjMJul7tQTE6bU8Eh8WN7/fhe?=
 =?us-ascii?Q?K+IKNCYLbs/BbuZlvLIEEr21nA3V1Cunu3K+Zk3pJYLSBaVhstxwJFeTiB/a?=
 =?us-ascii?Q?g4QCvocnivQpPpeuFd5HiczfDmSrSBsn8Y+e0fMOKf+/ILsTnR+TJ/yOie26?=
 =?us-ascii?Q?8FDMRZKRZ4bOjonlwIm+FYOb/KKeUDxxwHZy95nBKXfxKvqre2p7knZiyEcq?=
 =?us-ascii?Q?jf+Bavxu2/uHGs9lUmbUaGor9mQfUuFrv09p8RZIH+V7kJvemwqV/YTbt0LU?=
 =?us-ascii?Q?I/NL8+dmTT7sZeTRStyB0u0ocGl7zd98PCgyC0MvGvygwkqx8P0YFZJwTxpY?=
 =?us-ascii?Q?sAX5Pga+62t9eK8e18JKx/dCk3upKj3EceDhiMW6XYz/VD48L6WPJaaaveTi?=
 =?us-ascii?Q?e3wbtL8BVxFq4mZefsrySRzkTsQPy8e8AbiQsYlETfmEgmscnAwdxOTo0DXz?=
 =?us-ascii?Q?O3y7qcJC4WnOvvT+EuVUaGCCze4OPD4juz9nflyQCKBHDRL/Sj33WqffZAW4?=
 =?us-ascii?Q?/7UDiWGhbF1oyXk7C37oblcySufPgteMTrw/gG7RCIlp80nWdvLSBg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 05:27:34.8480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d4a9866-66e0-4857-fc98-08dda971d668
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9523

From: Mounika Botcha <mounika.botcha@amd.com>

Add TRNG node compatible string and reg properities.

Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
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

