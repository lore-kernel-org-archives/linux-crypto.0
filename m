Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012040.outbound.protection.outlook.com [40.107.209.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD772F5A27;
	Wed, 29 Oct 2025 10:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733366; cv=fail; b=oFiWPqOM402SIGgNc02Fe/sxbPfQrjw8uD2meJyCLtyrPNAlriVJxmpXSOhpcLXtPxgnHtqMKoq5R1jciazdL5lEgmqKDR9izWcdF5DR+P4yEol0+qEhBgVSlW/oZaGkT/SiCeSK1aDQL1CYdNDC5DA6t2TIF1pPqucznl+UhdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733366; c=relaxed/simple;
	bh=/5FjL52AJ3YInMk+Xzh45diLoaEdm38FWOH9NKBkCBA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XVM/Q/jpN6UwCO2meVj9tgE7J5gyCWiUBosech/0t204PH/ADHMfiqmrpAAUY2mP/pQ9tt72VV6kamd2nK1fTx6XZ9dBoEE7AwHd4f7B8Rce8AyCS/QRJY5SDZ4kPHcoztRBCQfo+rfZkrLLTV7vY5woxWOUCmcGZILQWZeyeSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jfiOzw5C; arc=fail smtp.client-ip=40.107.209.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jfiOzw5C"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KUBQ2lWknkoVaQSy846Wsu5q8pA6or0RUUC6IFk90SYCe6E219EUzWBge4xLlwIS2jUPgvbTYjNItishU56R+/Fajp8TUGH57sY7Svs8OLQLh9Co7xtYZ3ImfibyKsotT9Hg647E7Gh1/t/73R5NjXlpJAlaxyzn3z8c2X4IIrsrNV1zXI9nX4Jw6D4AyhRcOIKnHv2PobbSGD+AomjJ9ZwSHak9kRd3oXpcduYx5RBJ+xMXtVz42eGrOnPp7TEdWcH5NFinxrbbGXmuj1tgXcpiFb8wD9iaZHBCtDM7XIqVsMqt2VUQIRexbEfEH3A+c+uC+mVRwjYbQWi08/+UKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9sUc+af5H9xheAR6Z7uO3UBnXn/ILbRkI2VZBFOZw+Q=;
 b=Y2ITkIIDOkt3HSkwOsFtjL213sXRzFdeed3yH1BpZPR9rO4BALY4PBuZPOEOfmGIK+nXSDe1JClxfgP5YXPtl0RwfB5t4K2DCaVzdo0V8AnXXY9F4NO7oh5iTR+o8ZRQ55VFbWvfSbKxKoEwEeD6Yyi1/+z5lHFO+lq7FaXjCZpjqDZE4JvWGFEMF/ZfAkUJSR4gr1Abx34lD6Nmx66J0iqWSuS6ubh3ShIAU0vFsFiQih+YbpxXA6w1jPgRtZ3I/jFnL19g2jT9gmqpWw3gqhSlrYESKWPcuHuOWt625PXKwlEUjLn9CLv8pHMcr2tPW5jVcz366cz/VoKDxUX2ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9sUc+af5H9xheAR6Z7uO3UBnXn/ILbRkI2VZBFOZw+Q=;
 b=jfiOzw5CrOxGdmhIKwRHzfwynv1oCWidswotptOazSpifKh2+Lfy/vsZ0bhkMeMx1FvkHBPuIXrak2gBv63FZQo3sPErOZKmRtj5slXEKSkg23UQ9rzrg86RwmpiwPZa7PlibPgrpg/lBSlzw3v1S4gK7ma7e8nwzUZIuImn2Bw=
Received: from SN6PR04CA0108.namprd04.prod.outlook.com (2603:10b6:805:f2::49)
 by CH3PR12MB9080.namprd12.prod.outlook.com (2603:10b6:610:1a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Wed, 29 Oct
 2025 10:22:42 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:805:f2:cafe::f4) by SN6PR04CA0108.outlook.office365.com
 (2603:10b6:805:f2::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.13 via Frontend Transport; Wed,
 29 Oct 2025 10:22:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 10:22:41 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:27 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 29 Oct
 2025 05:22:27 -0500
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Oct 2025 03:22:24 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 04/15] dt-bindings: crypto: Mark zynqmp-aes as Deprecated
Date: Wed, 29 Oct 2025 15:51:47 +0530
Message-ID: <20251029102158.3190743-5-h.jain@amd.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251029102158.3190743-1-h.jain@amd.com>
References: <20251029102158.3190743-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB05.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|CH3PR12MB9080:EE_
X-MS-Office365-Filtering-Correlation-Id: 824cdfee-439a-4234-e7a9-08de16d5178e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ntNg60kIZBSwpC/bcvMq0Q7KVbiqfzikoziISZtWDbs12DdFMylYg4MXFDqP?=
 =?us-ascii?Q?knhlj0TzZHqR9VzRvn+Kyni815y7aGPPdVsxnRYK9BJFduridlWigaCP7W1e?=
 =?us-ascii?Q?havsinCe79w2fm+kAJYRoWBSE7s4C7LjMyU4aoWBHqFejZoFWCcQiuBSwueE?=
 =?us-ascii?Q?p3Zl0w0ST5DDAor+5KN/0Z/3ENokXnCCnOZtO8J1Nr/1zH3vzTNdkDMp7Q5l?=
 =?us-ascii?Q?LqolLE7bKtenpVXphHSXToy9w8zEWwbFVd2yCnGq0+4uIg5avQf9hk/FJb/b?=
 =?us-ascii?Q?67+eR17ZRT6d7QTCg/5DxftygaS0ITeq8ERgz8fvK4LAzjfwgyxqa351HSGN?=
 =?us-ascii?Q?DIQyPM/Pq15kJnCA12YL7hDYfMg/Ea0/YbXHBAcBoQMbKNjn6c1g21K8Zjv7?=
 =?us-ascii?Q?yE/7xymTe1xhFK6ndi/1gshDBedf420XLwgHU08m/31cXjAFQlQBCRFToK5W?=
 =?us-ascii?Q?UTDrXgtjHpmkCwv5cpK2Ujz61Gjdn+7Ac6xDAljsL2Tk4IkpZ9Zkb08gZBa9?=
 =?us-ascii?Q?wvLqfGMDNkBWPKJUW2Co4PoMcqH1O0scZCL0oI4K8hK36wml2zkHxp8XYxwL?=
 =?us-ascii?Q?ioMGXcEPQVNa1xLmnMXfF5AiSPTOKqdwp402Nk8pxw3ua/ibX9AUJDfwt1HC?=
 =?us-ascii?Q?si//H9W2M8Gh3SbQTqaFkM9ynQ9pNHZTQnGMRjaNmVHjMTrUmx2TnVKb2I6J?=
 =?us-ascii?Q?f9CNvlmMjN2HryH0uYQaBtIWTGbq13RVGm2Z/OM1HsJ7yakcidVZZe09wSCB?=
 =?us-ascii?Q?Hyktc+f/4msHBHGU2oD2qYxrNMDa0C8F9P3IuvBLl3XAKT53F1ojWtMQhK2m?=
 =?us-ascii?Q?Pkcef3XJ1kubhqhLrCr8eSriPGJwCiCaJ06F20Ay83YL0P+2LADr/adjRFZK?=
 =?us-ascii?Q?YMBsIGB1Iu92KyvEBMbauvBAYLaYxr0BSIB1Cjd+pKcFKs8IkhorIg/RP9BC?=
 =?us-ascii?Q?9cSJZ+8fsjgf+1CDVqk4C4eXYgdiaNpeZqxI3e+DwkrWoJV6q3Koef9/U41/?=
 =?us-ascii?Q?m3FSf3n9g0ip+W/jDv/VquMu1ziqH/wDJvynE1QDQPZGfhYRanzpjMcjCC92?=
 =?us-ascii?Q?R6tR5SBdMIyLpm/SR/WX2rD0J29k8BVFYZpHiqX0/xYFKkX92jEAS+SclHJN?=
 =?us-ascii?Q?h2IxZmAfAv70cnjdlfJT7MPbcz05RZ7N01QTc+VjIamOWWY2jU+uogA3xOpk?=
 =?us-ascii?Q?E89xjdj0gBpSylpj9oHR4++yl+rh7gql7K85QSTVK1wgXaVy70tePhPhe/oB?=
 =?us-ascii?Q?n5eaHav5yu8smy4GuDovn5eqT5JRFY/JxeU+a8c3SQRdxtakN8ONaCWl2XZp?=
 =?us-ascii?Q?93zIi5xcdR0qAC3lsjiH91V3aQ008ah6KBHnDBHcx0xwHpT9bTDImvUK80Tx?=
 =?us-ascii?Q?ypHMBpID562Wqtwa1F86V16WJ1ElzwTVUAsmUebT0NEf/x2nK/PjFthdOQIY?=
 =?us-ascii?Q?IdL5QC1Mid8upy539ha18xxEILUGC0rj/uE900gfzmYR1Fg9Ci8/bp8ZDS3n?=
 =?us-ascii?Q?o9LJp84n6W099HufwgH9Pi5kxYcfHPo/xEbD2r2WGl3J2sFM3aH/lFndo4FM?=
 =?us-ascii?Q?sQb3T1rwaNnhkNtofVdQqBv+RDtqbzo6zPFZjPmH?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 10:22:41.0760
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 824cdfee-439a-4234-e7a9-08de16d5178e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9080

zynqmp-aes-gcm updated to self discover, corresponding dt binding
can be mark deprecated.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml   | 2 ++
 .../bindings/firmware/xilinx/xlnx,zynqmp-firmware.yaml          | 1 +
 2 files changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
index 8aead97a585b..20134d1d0f49 100644
--- a/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
+++ b/Documentation/devicetree/bindings/crypto/xlnx,zynqmp-aes.yaml
@@ -14,6 +14,8 @@ description: |
   The ZynqMP AES-GCM hardened cryptographic accelerator is used to
   encrypt or decrypt the data with provided key and initialization vector.
 
+deprecated: true
+
 properties:
   compatible:
     const: xlnx,zynqmp-aes
diff --git a/Documentation/devicetree/bindings/firmware/xilinx/xlnx,zynqmp-firmware.yaml b/Documentation/devicetree/bindings/firmware/xilinx/xlnx,zynqmp-firmware.yaml
index ab8f32c440df..9b6066c7ffe4 100644
--- a/Documentation/devicetree/bindings/firmware/xilinx/xlnx,zynqmp-firmware.yaml
+++ b/Documentation/devicetree/bindings/firmware/xilinx/xlnx,zynqmp-firmware.yaml
@@ -104,6 +104,7 @@ properties:
       used to encrypt or decrypt the data with provided key and initialization
       vector.
     type: object
+    deprecated: true
 
 required:
   - compatible
-- 
2.49.1

