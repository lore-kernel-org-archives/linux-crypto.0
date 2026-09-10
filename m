Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44384568FDF;
	Thu, 10 Sep 2026 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063053; cv=fail; b=q4vMwTqrQs9uQVtIrb2v7NqMzIE9JnzXuKxAI0IMbsk9f2gLaftmen6uNk6nJJaokhOKhRdDfIWMC5q1+3St+ZGgHKzmd2Cl7QksXkCrRRjuJTldgV8H6zkzox7CZZz7qqtIBFIbJsKIlfGAjNsh4n25UTFVBjH7d4LE8p0hdG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063053; c=relaxed/simple;
	bh=SytUeFdB/MKaYKaubrhZRnRz1jmrcwLjp0R6X9UVqZU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0IfuIaVZlKqXIiqO/MGH4qA/lIcwAN9xZWqQj6iTU/wFpPEoI4mpC3JAnTdgaaCD7gDe7UqPVxY6yXqID+52XpYfx2WT0z3LVlNEKLL6AqKpMy/9Jz+rWzIeNL+ucVSOZlSB1FI0zGOtc6wCN4p2BReK/2g750DMNxgwz+kA88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Ral8h80L; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=BILNF5Yr; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Ral8h80L";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="BILNF5Yr"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68AF64aD1431174;
	Thu, 10 Sep 2026 12:57:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=ys2sjHHwD+AiPU99+X4BPnXwi+/C0iIWiOc5Chq+H
	GE=; b=Ral8h80LnDuxGVLzQ1RyVxRCwbuiJkngBO2aUvTR4Gc6qDUGhkHj6W8Ow
	v33s96JGk7wOUbRtkcAG+dmBZTKjR/Y/Lgj8OYUiw5KYRF6e4WUBTWmID3YKTXxr
	pAJ/+TJtQk6sGv3ug9t7IgeYUSa4njXRSnI2DJNEz1lFMj0V7f9CZTUVl9R2PIoW
	soRSfdzT018vTa3jSgzLiRVeFk77z2HAG9vCl79ZsXTgfDnDAZOQSMqkOvclED+o
	00ODulbSbqB5PerYrkgVbC5iEfiRdl0wLMCmJSG4Pu9xHn+QsdqkJYLU3sR9JPL5
	QY3/JjdL3yY5HaQV4c31SeX+PDKzg==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010037.outbound.protection.outlook.com [40.93.198.37])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gkcxgfbga-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:57:17 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pejuFqh/RGeC+RFd4qQtGe2d2gwT5usr17qF+E3HwOOUxKUP0H3HCDsZ7kHUu+PTAL0odSoXHuw5kxEemvhEMEP3BYObBrlm6tWVLZr5/Wtq3UJTX+XeumjJ6LIU+xf2ZyuNC3NMRcIdZqFaEZpiWRpMVPJr/u9Oks03xsMqnCtQIrHHbgHqcP0ANWDFjv/o9N08wKnrBq1llvCwwlBH8kmR6TT/v/v7vvwIFm8hGSGdW99ZLbOT9ubKbbeT6GVuMGLmEMRREcymZSZo143mHLJbaxU6o/lhfEqVoLLk4IHEz/tvZv5bJ0gIz1zYcOFirXGOCiXcoqbaS0MuZVl7Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ys2sjHHwD+AiPU99+X4BPnXwi+/C0iIWiOc5Chq+HGE=;
 b=qlphUboJbDzFYmPSigDvvpOVpam/fCBj6a36zDfeHouWd7yc3rhI9OLwZytj5owpw2W5l8P76jw0SbkNEj25WnWBQ/FiABgpFoMEbyh0omk5KiFp6oT1upcM/AcdDLSscv09WI8WYOIU6tjmhZPKxKyHbkVND7D2bfyLt0cvMiQrBs58y/6ku1Q/JqKe7QbTqF+lQgPji54PfkvOiQity+DnC1oInUAbpsL9BeUfpx7eK+rbtWb7RBqsqO02T4H2KMwgMsGDB0jzJYfoUCzFsaXU39XPz+J2+QjKpf6+5GPSPe/myKY9fvwJTqXmdzSQi2/A2F2z7zKq4CidY9SeDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ys2sjHHwD+AiPU99+X4BPnXwi+/C0iIWiOc5Chq+HGE=;
 b=BILNF5YrA1homUmK7898OX9Tu42NTv16er1smT5C3EykqDSBc9p+FK7EZ/jrQdVEmtUgKn3FXueOShw99TrU4tV0uZ1ewiex9giTynuFPzWG1hJhvl31yydi+MMj4e8Go+RtKkzho/528RRfIakPrAwb9L4Slyi/tNnIBDiiWLM=
Received: from MN2PR03CA0024.namprd03.prod.outlook.com (2603:10b6:208:23a::29)
 by IA0PR10MB7302.namprd10.prod.outlook.com (2603:10b6:208:407::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 17:57:12 +0000
Received: from BN3PEPF00022BCC.namprd03.prod.outlook.com
 (2603:10b6:208:23a:cafe::1f) by MN2PR03CA0024.outlook.office365.com
 (2603:10b6:208:23a::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:57:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN3PEPF00022BCC.mail.protection.outlook.com (10.167.248.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:57:11 +0000
Received: from DLEE212.ent.ti.com (157.170.170.114) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:41 -0500
Received: from DLEE201.ent.ti.com (157.170.170.76) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:41 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:56:41 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHueMX2793621;
	Thu, 10 Sep 2026 12:56:41 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 03/15] crypto: ti - Fix potential memory corruption on highmem pages
Date: Thu, 10 Sep 2026 23:26:07 +0530
Message-ID: <20260910175619.2122149-4-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910175619.2122149-1-t-pratham@ti.com>
References: <20260910175619.2122149-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BCC:EE_|IA0PR10MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: 119761a0-58c7-4470-eea6-08df0f64f086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|23010399003|36860700016|1800799024|6133799003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	jtUrVntdM2I3sBr8wQM7qDoDOJMjBuzllIlWWqZJ8l36qASwTCSDesj6fk2QZQJcJJPwYh5DH3op4Gh0chIchrjm6M/+9yHbV2Pxypfyuz1CmMgDA9kYxKjp79YKVSewdoA61kawMakCgysWtNYbsZ/dbo1jSlBzqSDVRaW4msUTKM3kK1Cd94YUV/lpSB9CSRp6ev0fJ+iTDGd2VsoWirVsv7pfxz4uXFmz1vTSMlE2BJsM62D6oa5DciEX5PCl16yoI6CuQ93xaUcC/7+QVSkjCyuBV/6dblMIRb4JDmFW0f9VWJYxAKwemV67QWVOpXmKM2bm/Dcrck23TClFFkaH3fada783BgqGCJfPTEK4pCMKnSjYJ7MdI/cLJsPAhZ3faP+iq/fLTGG6Mf0bbXBOnWOGsT34SZcmeFA7H3sakntwQZywtMPi9eblFuWC75hJqX/7oPzs0AomQY/StI3mQORIBtp+NjYe3xdRoBqaJEmBe9IuI3p7ZK6Qben+D1o0siWXupqoA1WiBBrNpTjKREp2oT7mX0tByc2lBiTuYsJrCTP2daXYYetlBae1qyAo5zj6AZHy339eik76M2U+KSKGJ/6bB7EgccBjaRttPvC/CzSodPUQbLH6C3N9XnlWlCN5K1cWbmCDTw24JaD03IjNFys88h6qqX1hL1ZqdfqpKxbVhxCbIFNnJ/KeN0xxjR+n8646Atwiq7f2fQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(23010399003)(36860700016)(1800799024)(6133799003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EA30u2w+XwD68EkS6IQ7664LoYkuWrQrpKnfUYREpBGUiUsMT0bfyvwySzhY38/yF29hMgv89w/C2Xq0UvrYqwrOpRbqA0cFY/opaKM3+ckJQoNEJHZmM/69uRiX0dF1UyKPL+BykQq4/sxNyVkh3UGnofBHfgIhtVu8u5pn9N0MazeoGt7lHsL74X7LN+cjtJjwxY38Fy6UboU8n5sO1xWiXgn7Q4id7+CYaW5A0OVq33Ct06cBTY/S2qn5sE8+byQP3Arl7tGbaNCY1ky0tRVZGc7C8tIohM7d6OFfq0F+yFR+sbR8vuz02khcNXizzAoEdQzWFVTX71sXwbOBohpJ1bmXWjb9bd1lApGR5SoHK+WgKKws10kJilioElkHaOGbk15mDHzIq9ZTRSJPzk0C2P+tJT9fJn8f7Bu2bgcISNRuCukQ0vxkkrm++lCU
X-Exchange-RoutingPolicyChecked:
	VzZR3DVyj7MDLupR9FoR2pia+oiAaEpArsLIRMrSahQ5rCSqbOnEnpF9V1ILybGjhfVq8QSkMB5yFRfK2yG0n/bvRffs6EReg0ZpijtwiDrJf6NZdcDwmvu0aQgLamSpFYETwwYHmZ5/ck7ukxAngFpcl30J91Uz2R5P7owlsT4fD2JtTf5TsDvRj2G2DOg4nr0cvmqeTykgccG8nBqJJJehLIlTSKvPUSG3jN+BvPTxIyJZUQfS4T2a+4EcLBKU4XvDndv/rhJbVQCG8dKT6hY8Sa7jUq8XVKzuCCEqr095Lo1Zx9Zgai4wpxOb0uLmE//lLIvBfZ/bgcjGOkPB8Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:57:11.5218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 119761a0-58c7-4470-eea6-08df0f64f086
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BCC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7302
X-Proofpoint-ORIG-GUID: yi2L2PzK5MqF_1nzwU6uMgh667lDl2E3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfXwnVvOBLrmV43
 lSl0HZkw6LzRFXbPT7qolSH5fHuWfaHjgBdt/S2uL+ndpyQW1eMOFHqRZMJzajD+EsAKXpARn43
 3eG2emHAZzkBoe7Gppl0hUapmDf84Bc=
X-Proofpoint-GUID: yi2L2PzK5MqF_1nzwU6uMgh667lDl2E3
X-Authority-Analysis: v=2.4 cv=MqbHeGae c=1 sm=1 tr=0 ts=6aa2ef7d cx=c_pps
 a=HozCXiP24e1PxqS5ATOdRg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=IXP722aH8NCvtdUuCEcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX7biW8eo3vEIy
 KVNnp5BNlQ9xa0LYSyzKz6UkU9iEY3Ee6l1Pq5isxVhs6saO1EkaZ7BcaPhVbBojeVZen9mtxYv
 ab5duaSLHefpGFHkUPWlqZH6lT30MtsYpPCumzEud5GGI9G6qxBb1KZH/GlaUnFOQe8Jh/6JQ/z
 eFa2h/6PafXC1xOBYjUhrQiei4DV5CNDVyZlsgBIqNegamJVm6kFhVFF0WGCPYePnKh0LZYvT46
 CI6g57hpfoW652P5nTOvjgLxsE7KDtWf4BO5oq2ny9FD1P/uyC3BshPOajKHDwfYn1voK79DQrz
 u1J8Sxrb7SULN96M6pQF1JukOLKE4E+WpRM5SYCUsCvWO/0MWoWJY7ilzLHLkzVLFKW/E+mWiAX
 U/0rcfB5LoGjZo5fGqVJ9RDX+U7Y8y1AZxa73LoP0sBWZNrmCyXIpbT5olyVtuzTSOlgRPifEi7
 jc01OMCbUesY2yOBuDA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100220

Change sg_set_buf to sg_set_page in DTHEv2 dthe_copy_sg function to
avoid using sg_virt() on scatterlists. For scatterlists containing a
highmem page, sg_virt() yields invalid or null adrdess, causing
potential memory corruption. While we are here, also change function
signature to change buflen from int to unsigned int.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 4 ++--
 drivers/crypto/ti/dthev2-common.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index 4c6b72ba104ec..8628187a32e18 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -50,7 +50,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
-				 int buflen)
+				 unsigned int buflen)
 {
 	struct scatterlist *from_sg, *to_sg;
 	int sglen;
@@ -59,7 +59,7 @@ struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 		sglen = from_sg->length;
 		if (sglen > buflen)
 			sglen = buflen;
-		sg_set_buf(to_sg, sg_virt(from_sg), sglen);
+		sg_set_page(to_sg, sg_page(from_sg), sglen, from_sg->offset);
 		from_sg = sg_next(from_sg);
 		to_sg = sg_next(to_sg);
 	}
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index d4a3b9c18bbc1..75d9a097650da 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -126,7 +126,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
  **/
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
-				 int buflen);
+				 unsigned int buflen);
 
 int dthe_register_aes_algs(void);
 void dthe_unregister_aes_algs(void);
-- 
2.34.1

