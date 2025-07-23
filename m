Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2066.outbound.protection.outlook.com [40.107.101.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4F3225779;
	Wed, 23 Jul 2025 18:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753294952; cv=fail; b=UX0HAKxSVMx/XQURT+aWy4uy5523qxSl+CxLiRCgfm3AEJKrMp9tPAOp6I2yQFTx2YMciKDri7wKLkHLTToyPn8QZC9PzshjrPXShDRTCcnGXoUi+ipQWWwvEOBvxlialEdT4tfs2RE1AQpPqvD3fntZOtlvVIBzUb4iGUk+gDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753294952; c=relaxed/simple;
	bh=rBwVNU3R0WXSHQEXdgHp7Tcerevpb1r0weREnTMZLnM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmjblkW+tTkbCcNA3dML3TGBJ7/2Z9IUEDuz6+itQoo6si4diQxnyTuuUGo/qBEhLZmmhxUoHcqxQJTcAiMB5uTHAUIoZy6ZdFCNHxNdMzhMNpxZveJKZOkidT+nFZurvA80bRxDSpj0eDn5VB/wmEXrHQ0ikh2swL1wpMuwx9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4xUpb/yL; arc=fail smtp.client-ip=40.107.101.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4xUpb/yL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qPeRPAoUSjp6FzjSrOg9v+m5/L/oSzTjkrfBKAz1iWeWzLfPW2mb4hOE8gySB3sfLuMEhau/kGeHpo1rXkpMejnqyt7qwmdyOVtKmirhPP7RG/9A8YZqj46l42ouFL9OuDhkAdz5+AoAGLWnnGUxkrl5Lh1oxAOrpMgmqkOUzdEPu7X0dXqHtCVCRGBq0XDVEOj7u4eIagW/X27H5GlyH3/L6FZEUoz0iIgAh/KFIIucsu5dELLjt5zqP3abpGqaM31Qs+jFpbHqy7F1+G7O7SQfBGiLShzFXKWG4BL2pVBSZEIGGQPdTuErKctDkx4c93UestYz1KZi7uDWeAXGEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LltGmjjDi3bXdRHi3sQP2hEtpeXrfGmphPlPClujVGQ=;
 b=RZSja4b2n94Y9TewrYfgf4LFH5F7SOXKsJe6EOr9l44lhQlvS/Emp4CRVJ2YOTh7oMMuywGzU9UeMkWLb3Ay1fWsZJ+4K2m2bKSva6SDIoCbxzv36oY/Fo9SUBBOCE81G9mNpi7AXQfahmHigbLa0VIDnmrJ5riBOvVQeuWVWqophj4l9ukKQFPa3MCN7nYCA2FrFP8XcSYTMopkqzwIRUbbRP0Ohtw9/8e/WoiFXFHz3S03KydX9jTkAEuCHmbRiymriUZ1+AJ1SvyDR7uUmpjbg940xJQH8tqBY58p1t+9bEUUOTwKjkzozzoyKLsc3dUjayifMc36HVxmiluIFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LltGmjjDi3bXdRHi3sQP2hEtpeXrfGmphPlPClujVGQ=;
 b=4xUpb/yLxGEK9JhKldCDTahDSucr/9ws3ZoxO3IGxxmtSiE+gIRse1EgJMVsiMChmjl0ppFxUi8Eh5WOpjML49nraDMp9175XSvUd12eLEFIwwcDrhy6WlyU2aqn1Hv4mH8M66LSCqAdZNxcb5BlfyWlay9B9AIrpNTpjqp9T2w=
Received: from DS7PR05CA0048.namprd05.prod.outlook.com (2603:10b6:8:2f::19) by
 CH3PR12MB8934.namprd12.prod.outlook.com (2603:10b6:610:17a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 18:22:27 +0000
Received: from DS2PEPF00003441.namprd04.prod.outlook.com
 (2603:10b6:8:2f:cafe::f6) by DS7PR05CA0048.outlook.office365.com
 (2603:10b6:8:2f::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.4 via Frontend Transport; Wed,
 23 Jul 2025 18:22:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003441.mail.protection.outlook.com (10.167.17.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Wed, 23 Jul 2025 18:22:26 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 23 Jul
 2025 13:22:25 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 23 Jul 2025 13:22:22 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>, <smueller@chronox.de>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>
CC: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Harsh Jain
	<h.jain@amd.com>
Subject: [PATCH v4 1/3] dt-bindings: crypto: Add node for True Random Number Generator
Date: Wed, 23 Jul 2025 23:51:08 +0530
Message-ID: <20250723182110.249547-2-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250723182110.249547-1-h.jain@amd.com>
References: <20250723182110.249547-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003441:EE_|CH3PR12MB8934:EE_
X-MS-Office365-Filtering-Correlation-Id: d9e17994-305a-492f-5ec0-08ddca15e095
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YNkuwLLMEDe9jLqB7WQ5h3OyNC37yg/VUoV2qNj0lDZ8654nghkFBPFr4fgs?=
 =?us-ascii?Q?jEQ3v6QmYFGNrDJE1ewLhESz7ZSGgN0je4bYk2P/xkAyZBzhUqlOhustTtqN?=
 =?us-ascii?Q?vxcSpLv8OOmQ5uY8W2RmSR7CZc8b41AG81OnEHfNDvzsm/3e78fytDztCb6l?=
 =?us-ascii?Q?hoAwCJgYxKGUmpKgINyLj6Ff2BTa2uHMYdgm10ocaqI1Kmu2Qpy2bls+iXtp?=
 =?us-ascii?Q?ES4CItv/2AevRMp9GcuP80d6bQ449yyaKMqHkyYm3B/wcfdR8VqVXiP4E9+/?=
 =?us-ascii?Q?/IsHyMDjNvSJ0/pSLz97c1Tu05t3rU2GxqH7QN/zc6ap96efDJlmh5gAAfoD?=
 =?us-ascii?Q?kJrRz/XTcq1GsS0oXf0Y4BbQBcVA6N1cfVbZtON9cMWfZ47XsPCbUhJgwGlz?=
 =?us-ascii?Q?kdY+eraKpqAPrZE1Gvy13PcXRIxs0dHG0kCLkInUGCRabuz/lVfhJ+LDzz3I?=
 =?us-ascii?Q?ZtNbzW3pyRrSzoGeInP0M/KooKJ/na0YrBSnAgM28ZvkwE2BORXloXun1sFm?=
 =?us-ascii?Q?YzV04qiIczrrgUUrWUMYqJAAlkj0DRN+RSwjqJikTu7ysRjIix/xyoo1qOzK?=
 =?us-ascii?Q?hYt2+bWWcKcIz/byKTcMeO6l5sCnfFnoupEFeOfVZw2gIu6+jEEbqk6eOXA0?=
 =?us-ascii?Q?Dah1217f+onPgyns6S6opYY0jTUxB0KJKskiZxGLSpRsH6Yvx+Pp9RGn3Z/9?=
 =?us-ascii?Q?8oKM+XGNR5uEU0kTcIOmlROIBDWCh1ROtvTsvX2FdCPOrM+Ua0+WndbOSrC9?=
 =?us-ascii?Q?uf6Pp5Kfu7qmowrcqRfP8Lo+w56VS39UzQkZAfPE+X9yKndN2bSDm0h5DSNT?=
 =?us-ascii?Q?ORLMQ2eWHEe2rmbSNJU015Vmb2UnYiIXTpcQb4oK/NGS4a1trssKiPVDxGIF?=
 =?us-ascii?Q?HlHvhAxYPTahI4Htdb53yLyM9LtPz0eskq5v1R3STunJED0B5Ay2pAdsogZv?=
 =?us-ascii?Q?jH0MWIgFufyrvesxgfdU0NYIufUSqJVn3Dpm3z3u/xwxf5MD2dz6+xdzkL1z?=
 =?us-ascii?Q?vBEagRRnVzD1aO9l0I5M3865Tav2nX4P2GY1yK8gPqZzSdANtyVp/yrunNqX?=
 =?us-ascii?Q?XVKgMZafZuiBTZ2gUwHJDtELt7HIRflvM9rKWm2D6OgFBUWlvKdRl+6d6XfR?=
 =?us-ascii?Q?RfD0vARBHo/fni/d9qVzweEGh7/odbubU2Y/OHzGE/80rhJyb+WGSTXRqTsk?=
 =?us-ascii?Q?mpyhL0bzQtEg7oORj7htDb3CAZziGgRMxBngK/g9AHFJ5fMqZSAHYAISWbPy?=
 =?us-ascii?Q?umW51VkOj079OnWgR7/3b7jVsmpxXf6KLo0d6skDXAKGZ5TopFbgy39Ua7+M?=
 =?us-ascii?Q?rdJJsnNJX8yt2GDYAwf7B9lvRQfmGnz8RdgHH7GMn4bvbVP1zuIOEmobviJt?=
 =?us-ascii?Q?Deia8lXRXrwLIEFIa2OmD3Wcwbx2Ber6bvtiWa8CxfCgiKmHO/jpJwQPgd2l?=
 =?us-ascii?Q?ilmWsBwS+Ga0qEC+1u4GQOdRPfmoDcLCXqRiXa2gNEoDJVeJObhpEljpBUiB?=
 =?us-ascii?Q?jfgMTcDdjp3r3Wo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 18:22:26.6685
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e17994-305a-492f-5ec0-08ddca15e095
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003441.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8934

From: Mounika Botcha <mounika.botcha@amd.com>

Add TRNG node compatible string and reg properities.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
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

