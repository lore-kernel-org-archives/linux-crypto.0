Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FB233F6;
	Mon,  9 Jun 2025 04:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749444691; cv=fail; b=TDKVxiNL9r0ijLgTtsiIj/c+UqZVtL6j5SVOAASDvW7U3nLeQdGZ4sR+nY8L5JGCQ07pgo7awormtoP2Wu9ZrKtBgFcqKvxBCiSkMrOswKzmGjdovClW7JjMCXvLbby8pCoaqJZuG/momCVcnPA28FLABhImUAHB7zocPCgKU5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749444691; c=relaxed/simple;
	bh=VCmremSkXGpkjNW2aqEzA2RVXDlaPSHAmX2Hp6XxM9k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mlmz+iNqiPWnu6SLUxT1MG+oC+PbOWMLMdi2zfa/9d1lCewJ4LFQjjVUaXXn+wL9E0+ZaYlYRzpprnvnEsCIV7/DBZksiOyczN/UxQ1mjaY+aL3oL/0OUg2ghZrv2oN27caZOV1UpYUJjtEfO0rGFhzW2ydZCWZdm5ur1dGsHpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IkF4wfAw; arc=fail smtp.client-ip=40.107.244.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IkF4wfAw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o2c5a7bz62wXJSf3rQTljMRcBEzx9c8SBqHHGXn1Hm5bf6LtWEzTkelDjKdNJxO7X+CLFhum1bDfp3WYAni62BxFcAZhxI75MnN/1naO5lOJmih4ojyE9xxKpUvrhDQXgBO0EXwK22aIrsgXFtHeiqqIMdhwtQJMDfgOVpb8I6bga3/k7fENAPkf6ueBeAKQ9wbDl1VLhg3g17oDYvrqo8G7DcQrMCwLK7ImSDMSLcz8geBlxRdJ6uNPeLNuwm3pdq3eaXimQObv+1RF+FAbF5LinEa+n1myv59bsJfLD54Z6Dgkjs58xlRYTUy6f4EbRzZVN2mBvggnINkCbDBFNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8TrLNjKUwJ16l+dLZ6vklzONEhQg8xBijbjVQBMcGCk=;
 b=rUtJraKBQqyEjli5S8LaiJUWtO4acBvRlXHX5p5RB5bBvCcMvsZcUAeNmDL1ItTzXXOjFtVUXVielTj/pKOPg28Q2gcaAiMR/gnCuh5l/+Uofl777//qO2NPEQ+r+NXpMniZri8hewaQGI5NUhlkn0PxzF/gmCfUd+DIBwJ+gq2JInq+iqaoQpH23V8lzhF4/RnnYvzWYf9H2Axl3xz0ScIDMoZ24qkx803/dZ2dI9E+U1bDSbrxJ7D0CxePgG2919/lATGMMHxdLohYPhzkngy9REocGGiw9kwDYlwg5MI+WTkMzCN1Lm0o4SQPFBo/Hs1YAwsHWy3jRkilgOvdrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TrLNjKUwJ16l+dLZ6vklzONEhQg8xBijbjVQBMcGCk=;
 b=IkF4wfAw1cnSJW55+cpzdQBFa95AZ3bWfv/jSAI4VqpUvJwaeT+r1/JfS35hRAJihanDZFoeVsGhODnNXFc3uMuDOLJ2nLAeHrbmSSBHh2lN5oqJBY7t8xOxCLWRkm7ybnOq2+Ihug9fmMEPysxuY8Ji64IVHeBl9E1eDm1dI84=
Received: from BLAPR03CA0048.namprd03.prod.outlook.com (2603:10b6:208:32d::23)
 by CH2PR12MB4199.namprd12.prod.outlook.com (2603:10b6:610:a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.40; Mon, 9 Jun
 2025 04:51:26 +0000
Received: from BL02EPF00029927.namprd02.prod.outlook.com
 (2603:10b6:208:32d:cafe::be) by BLAPR03CA0048.outlook.office365.com
 (2603:10b6:208:32d::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.34 via Frontend Transport; Mon,
 9 Jun 2025 04:51:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00029927.mail.protection.outlook.com (10.167.249.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 04:51:25 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Jun
 2025 23:51:25 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Jun
 2025 23:51:24 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Sun, 8 Jun 2025 23:51:22 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 1/6] dt-bindings: crypto: Add node for True Random Number Generator
Date: Mon, 9 Jun 2025 10:21:05 +0530
Message-ID: <20250609045110.1786634-2-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250609045110.1786634-1-h.jain@amd.com>
References: <20250609045110.1786634-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00029927:EE_|CH2PR12MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 985aac66-6dca-44e9-f026-08dda7114a2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nv6L/7K8jMR1w0quZPGXFpQnHHb9Jhzj9QTDGMz+TMtD+y2sf7J/ezqOvniq?=
 =?us-ascii?Q?/EV5Y+yI45D/yVGZXDUTa4jnxg4orp2BA9Nt7yuNfTUpHG4/lF9Dv5BfWqNA?=
 =?us-ascii?Q?W+MqkuLQoICbM5II2oVhKarjKiquhX6Q7i3jaGuTZa50QqDgG8qZrRModE27?=
 =?us-ascii?Q?CtvYTjevP7Aq3HC83lN7HBQfw44saJ/5CeioS85PwRq/sG+aVd9Gl1Jnk8ZV?=
 =?us-ascii?Q?s+fkZBXjYCDwp2iyNMUbNLxUZ3gskbqvMIun28Ala3rsTb1I4mSkokBGT3/I?=
 =?us-ascii?Q?+kLN1bTWT6D3c51UOXssOhvSz/MMPIut1zUa7dnwZfNCwF4P8Pu82M3dmjeQ?=
 =?us-ascii?Q?f5WwCgo63OXy+KFCUHXpIZm12B40mqfcg+aDd5sJ1wfDTv0TyOXTFp8/nY8z?=
 =?us-ascii?Q?fwXXq6U0eF5XOAEdNkkEL73lgaoduGXfhn0FOp8U/9XvGETdAOeQz7pzbTnx?=
 =?us-ascii?Q?p8y7O5tbgS/M46t1O956ERApd45QVR5Zj+u9NvhS0fIjwtritBHDefCFiVnT?=
 =?us-ascii?Q?2EkkbQCNyIwm8HYd5JMy4Jp0gs7wU54iNrtjsRbjLA6b0LpjLa1iDu4n2mdn?=
 =?us-ascii?Q?sRL+JdpM19NYy5zaksRKADKtp2vh8bYxy0SgsvjkTDmh8uR3ENvcPyOa5kMu?=
 =?us-ascii?Q?ZB9DRFSvseRBuLRLO/3zY6xGsqWQWQHWq7Nwk9LiiHrec1G4vJBK9TW6FiJW?=
 =?us-ascii?Q?cGJFjpOvUKQ1kls7waXlhEu4iby+N0R7WUsL+UITW6N98xJYLiwURGElBwXV?=
 =?us-ascii?Q?hqY4UPFgioYPxN4W4iGGfnOYXLwPzh8uXvWop+t30OQe3WhSNm3zcFVahat3?=
 =?us-ascii?Q?F5D0GRRr4Xt3OdX+q4DwunSIAoVDt2xjn45HsH6oKYFJXPH7OKNEbcc95JYW?=
 =?us-ascii?Q?ykv5KtElyYGmgiJ07KZuKVD91T7nLK09/54tqf78JYR1/IDXB8/rBHMy4aQx?=
 =?us-ascii?Q?4Oq647xTIf11AvXi7UvQ8/P/uqTanOc77DMCvKFauDowXQ3ajwqm0urOpv79?=
 =?us-ascii?Q?WSlhAG0V2nVG0tgg6z8nEcyOWVK2rFb/DCY4GSQ/+05zlxZMZv3bJ75wzSfe?=
 =?us-ascii?Q?ypCDycBQeVWIuVMCMyHkhqK95vYckVYSqlMy2O5vt2mgffQjUd6oZmFAEYTc?=
 =?us-ascii?Q?glO2SmKQRe5c9vDn9RWQjbq+qQNXxxJMyxqtOaBgqn5Yn7qapCRkyosJiZSS?=
 =?us-ascii?Q?S87ipGEd5A7BhYfZyNeZ+NNk/U8wHntCDOsHQYkOOe47akSTbV9wVrVJcZ1W?=
 =?us-ascii?Q?rCiKEVzEJjVeZcpQg6XLR2/EENaHD5ZWdEMmEv2nJ2zAGq5vrroNRgkWfqU7?=
 =?us-ascii?Q?kTAFJVucDG1/Em4mW1Vs+p6op6VN6fB+1hW9aE5w0laWOxzgIl5kIvZSClAY?=
 =?us-ascii?Q?XRDmathLKRurZdxW4XKfftRb8wW4+IycXlILGuSZM53mmFSNhJ3jFctW9ln2?=
 =?us-ascii?Q?uOJxnALdRVLUG3wYObdEchRlyVcn685H/KtLqNgZHEOPuFd8Sa0+Hw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 04:51:25.6904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 985aac66-6dca-44e9-f026-08dda7114a2e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029927.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4199

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
index 000000000000..b6424eeb5966
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
@@ -0,0 +1,36 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/xlnx,versal-rng.yaml#
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
+    const: xlnx,versal-rng
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
+        compatible = "xlnx,versal-rng";
+        reg = <0xf1230000 0x1000>;
+    };
+...
+
-- 
2.34.1

