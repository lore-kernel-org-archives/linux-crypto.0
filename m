Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C081E21638D;
	Thu, 29 May 2025 11:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518299; cv=fail; b=T2LzUzgkbfBeT6QElPQt3O5FRVNEvJsApqpngr9qZJOMeh2WEz5agpXNp5fNSU0yNrbPNDBM5GrXdgrRFxW/Io/JS7vu4++aqqGM3ZuAyX6FUbJXWAqtQ6nUfnYfij2CWBXjrNBW0CWzKDJgLwNrqpvvvTzD/aCbgDPbA53Wu1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518299; c=relaxed/simple;
	bh=idyjc2zmxGXtw9oNxkMzOEzL5KgKpmQ8a0JMChdr1j0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=age7uGiXLyZdQW/qvLvj0Y0q07j2VPiUrL9jMhzAf9pLGw4KIDN21p2ND35cKCkXltYutrrQB5CM+E7wSGVfGWAxqF+BdWw4AjH1stHq23TUmEos5E9tl6090olAFu5QSUmG0yBC2DT71a53cf9rOIWUZEd3UrhXo4Phb0OXG7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IojIOrDa; arc=fail smtp.client-ip=40.107.93.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IojIOrDa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lLaYKuOpFVJaaaII3YWVrBzzYxlUM8RYSSTq+YZ+Ze1Ov1uiXJ3OCY4HFKuboc9/MwKqv91moBHnQJ2Ar/xsGQllZ3IGN6ala9u6HkaWLQPFOum+snfmW8f/7nRvcDHLrR8+9rYFJm03vCMCSbXMFzb6bqdOq/7xvPebWf1ZKUng1WPacFKdyYvbPiziAlKXu+ukTLvNaTzEMIF7Pgjl/kDgeEwyg+/S17E1SX8+2XYRALdUCojaXnDyeWQ1d+gNIx4Yjc/RFvzfQocn1p9R/BmPKrWQGmeyL63yRwyH2poKbdGJDs367S+dG+s4uazV6F97U2ak0PiQ+1OYXqandw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ow+fR0mFP+OA2jrvII9Tff4xiO9wLV2edS65+sZ8t4=;
 b=ElsHpjMieux+bNRS15fB25sj8YlvJ25JWvTabAYI3ldr6vZ65F4CvUMggCKmrj/+TvV6TF8yPH2kj6OMQTjyst2pCFIlEM4jQi1juPu16rvEbUX0tpAsMdo/VaKapaDbYgzGCKH4BkVltBrhmMfX3IOQN+3WEQIg1LHiOjXCtlvuRPkPcuxOwnWnA65ruEViZB9BBGqC8rI2rYkpqucf8Xge7Xlvv6Nxv1P9QUV9FLmLEEOjJ4cO1jN3nPGyZFWUdubbRkZP6FFWcOUretR2ciJXbWVDRPQxLn5rV6bo48D1q6jU405gAl974xpokQXvDgDX8YyDI0xz2j09tBGxdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ow+fR0mFP+OA2jrvII9Tff4xiO9wLV2edS65+sZ8t4=;
 b=IojIOrDaK4Fal684KNUX0l6XMT0YtSgsZljgS9jn1Z8QNDRJyc92SwAGDim1UCdDFYXVdexQG1Tl/CK/+l9HxtceDm5oiz4WDGd3rgsHIawsyz85KXgHrHKqd2/dHIbchmePPpq5Xt62XLXGW/0SEarG6QE8TYAETA4zmku5Xrk=
Received: from BN9PR03CA0063.namprd03.prod.outlook.com (2603:10b6:408:fc::8)
 by LV2PR12MB5918.namprd12.prod.outlook.com (2603:10b6:408:174::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.25; Thu, 29 May
 2025 11:31:34 +0000
Received: from BL02EPF0001A0FF.namprd03.prod.outlook.com
 (2603:10b6:408:fc:cafe::e5) by BN9PR03CA0063.outlook.office365.com
 (2603:10b6:408:fc::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Thu,
 29 May 2025 11:31:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF0001A0FF.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Thu, 29 May 2025 11:31:33 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 May
 2025 06:31:33 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Thu, 29 May 2025 06:31:30 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 1/3] dt-bindings: crypto: Add node for True Random Number Generator
Date: Thu, 29 May 2025 17:01:14 +0530
Message-ID: <20250529113116.669667-2-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250529113116.669667-1-h.jain@amd.com>
References: <20250529113116.669667-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB03.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FF:EE_|LV2PR12MB5918:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c0d0998-7a87-4795-4415-08dd9ea45d7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uX22uHNBS4feux9XuTICJiVJy9DK45RM6w2qibs4d9iOblnqgW143/+WDQRj?=
 =?us-ascii?Q?ZM+0Da42VgmHgwTr5SdyfRzlRDeDxPFT2fV030q+3A9nfyliXbi5I7e4zHF8?=
 =?us-ascii?Q?H0ohzkxotRCYgBiI3rRBPdLOr0iYzSGwZ9m3g5MshjG8NgL8s2kuu0dDPsNz?=
 =?us-ascii?Q?bwnUqVROXkZhsMaKdLdXFXjqPHrFuE9bwNBu3B6NVHRu7HMgDR51GdqNNHwl?=
 =?us-ascii?Q?5PWINWSmVTjFd9Fhg+SyCViiWO4rdk8HgNz5B15BHwFvwP7jc4t4x/SAYYwl?=
 =?us-ascii?Q?+dTdB2SElxA1862T5/YzXqcJYARWRSNhkcgozgfvLWkQ19VH9S9Itn6iz5oW?=
 =?us-ascii?Q?dsuFCr2J8aW6txeHS5sC2EBLvzcP72MKZqeT5A7YKa0eVH4vjd3wI49wTeBl?=
 =?us-ascii?Q?sNpurcCcM7dQ/LWKpYaLuYOWAKI0MUeN9MIMwsSJPDnWSqEm3W38EYf7YnFB?=
 =?us-ascii?Q?xbFVyyttd4rPjhHk6COsqYDHNoyU5wjc6GFtuFc4xhSSaTXiV+Y1vsF9+4Il?=
 =?us-ascii?Q?Yqu3k3mjjqdvL453PCcUdoiy26x87BPwjVlXXDn/W47x4vBzp8BGQOdgWrQb?=
 =?us-ascii?Q?KcXFWKRIVXRv9JQopD0TfqbuxEnTTf2YY2xyRkwsZodHA1piAgsPvA5IlnrZ?=
 =?us-ascii?Q?smi7WZyrzsWKJRWggYdMAzTT7WROlOhMGevxanOGqzr6UzKTNpsyPrNvpprB?=
 =?us-ascii?Q?ffL1nZiVd1hyfTXCJdUZTyp6FjLnm2Qy83MBs+fvGDxtvQTLivk5k0Hu3olU?=
 =?us-ascii?Q?zhhbsCdDYM+D5j/ALDWuKgyx8igvZoaOOoqFgRj1ZrMeSN41l//UEUTt+2AP?=
 =?us-ascii?Q?XYQA8SPYmjDWvfXxAMVbIoOFeokF0ElvUMvHI9Kt6rWyxkxvPnSMln0GrvEW?=
 =?us-ascii?Q?5kuCjWlfizLQB1KU81T7v0Bow+pEAvgrQAUGltlJB0iZHBMO05kGD3Ffpgek?=
 =?us-ascii?Q?c+Q61ZP6Bo+LU/h2lq8UC0+v7Q65y+c5MVwe9Lj0BsbIjTU0p71XH+c8dIrc?=
 =?us-ascii?Q?1V8EteUesuFT5TZ37HVrDtr4654o/aD/UFOJq4SQ0njj+3ifnfKjMI6PzeKA?=
 =?us-ascii?Q?pZr0HLNVKgJvo4AOXXetJJqV89p5mga3mSS9R9uL2Bsc6aW3SeOfW1ZVwnDN?=
 =?us-ascii?Q?UGhsZrtxu/47u/PSUSuKG8T+3dTdRGlQGv6w++6Ok5vC0ukDY4oIipNcJ/k1?=
 =?us-ascii?Q?MuHayWEdGhyOk5dZitwuDgE604eyHowQxj/iCBFnQd7TGxgLNMnKpUnsO0vE?=
 =?us-ascii?Q?3Ol1Dw+3xIwA8f9+6OBefGrFq+IZgdbpyzMuzQdqDUJBjtTnB2JYfLEsNZpb?=
 =?us-ascii?Q?xhB6jVDnuTnbI0QZ9swdTu82gkNhcq0Dwlx7rKK+wGGXiYtFSrqHpYExWPPd?=
 =?us-ascii?Q?w3nGnv+T+fIeFX16br/FBI24j5UgdxtUz/XheRCTIZh0REKWE1eMfOdO3IbE?=
 =?us-ascii?Q?ka9abmQ/EC8d5UBsQVwqf2JIXL3BkamvSqgL8C+dksaIvHMAWMyCKQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2025 11:31:33.6163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c0d0998-7a87-4795-4415-08dd9ea45d7a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5918

Add TRNG node compatible string and reg properities.

Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 .../bindings/crypto/xlnx,versal-trng.yaml     | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml

diff --git a/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml b/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
new file mode 100644
index 000000000000..547ed91aa873
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
+  The Versal True Random Number Generator cryptographic accelerator
+  is used to generate the random number.
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
+    trng@f1230000 {
+        compatible = "xlnx,versal-trng";
+        reg = <0xf1230000 0x1000>;
+    };
+...
+
-- 
2.34.1

