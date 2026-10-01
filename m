Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6685C37187B;
	Thu,  1 Oct 2026 08:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844822; cv=fail; b=YjHT/YMXAnJGnZVRleyizYMk4exnxLy5O4N+JXgax3zmfp2hzIeFzNN+0q1k0XKmc6vm+ajToIc+WjmUAI+508lb/uyg0GXBSb6r7F1+QhjsQ9MIURuaBiCylEW3mX6ectM4qvG+bUA9V7CRk8EUx0jUJwa17+asnPCBaKjkChU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844822; c=relaxed/simple;
	bh=YC/A7S75qv+4+3WlQfVYWpfOLT28k6/ecphUxP7SPDk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kbg7xHnzdulBfHs+9+yzBs9gVSuyyl4vrjiq5yYjwwaMieXl8jnpaMn+6QOIDvMfNgflbBM7nawqK8CxRxS156QlFRGtgknAHPxhtuB6DE2zHDmkOxCMhoGi5QKzr+RzaJhYNQIvu4rONvfIIpJjxbBjCvbw0cPQrskKJdSv2Ek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=WEuB508t; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=m0rMdYLg; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="WEuB508t";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="m0rMdYLg"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691710Ma1294551;
	Thu, 1 Oct 2026 03:53:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+
	WQ=; b=WEuB508tINGavGC0Xpp0doFmaGKz6it7IXhj77U4yuRTL8qzxhwFYnBJa
	RU7X6CANrBMAYwOf/TKFlBXxS8RlcbJXry7DERwlNvF7esAolsvyJ7XrRuNoVFqS
	VRiGdH3efF1T0DLunQ1AK0Qe4Ex6wTiKlb8CDKT7eLZQWQCxp7YQBAxqOTqZ5zFv
	oT5wg2kzRGst0qWfEowbvE0mjX/YsKYJdBaGaLjqZfv0n3CQEI51N5N/Bai3Rb8k
	fN0X8PlUC+etabtM25m2WIdkfU48p+0/FBtXkxs+qsjjkZ3IL8DSxi4WvI5TCSHP
	C6dh0Ia/mrOjw5KFZ8aDR4ArvQy7g==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012002.outbound.protection.outlook.com [52.101.53.2])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h1eur9t34-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:53:37 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T0Ltr3f4BSy5e4ZzCn+93T2JIS8keZjrzAtMDpS8VISGpA/VuD4f4wXWyOq9RL1eXnc8IYF0Z1lTn4xLRlCV+8jQHPPoM0nL0UVH6Ybkpw0w9OAJ7ss5xkZ21058Orw33Ly83ZDenVK2LhYIkHi5SLKoeAuRKgh/s4Hqhb7/IEjJ9BHj2GCbjWWq+UiKyQ8NPhOADLCPplrtHYks2YJXKcRMonN822qyrHmAMRNp8BSboIpHRruIpAWV13dItJDN+qwMqncqC1fIXISnGgqY/DN4TP8aGpB8Fjbgv0wGz8nU8RcihWYjg+4hHIP5V6yOE3EI+baKNO5in0FAguQROA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+WQ=;
 b=foX4giP4QHx6dTFGxWuJe0d62LtVYKrTnQQVyeJ7RznJnU9SYul2OhB6d2RHdUQmPPjj7XDeeuJys55JaycWONRBuvBIegHe215BDQAXFlYzRTQWQ02gKgWIWBW4HccVxqpAuVRLX4EDlcJe5XIB7GJ3E6XGZ6GC+wJ4xOSDGVkGE4Azc3LCb/CnHeSpJu+5tzwdWLXONfKwtj46gu8D4FWdpLEsqynTqb3TznK8a8608TnQuJpSwF0glhpEy2QK8DKaI1Vcl6J50jKYPFKqNwDt7rf8H074l2strzlA5smZ9LPPgdBl9dT1zJcVUdgtdphjRKFr1022hezZ4cJyTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+WQ=;
 b=m0rMdYLgxFzfLY1OFjFdUvJSc6qasyIGLWtSWo0RyCdSP5sFtc2woLujNf2AvqCqeR4OIuzEtZjRuNZyR5HNib2L7wP9Edw2CYc2Kq2mQfh+zCcgMCnPQG9PBq1dU4zJGy7UXCJXXz3tVFk3w5hhdcqVrbLfYaBixzu8JNAArmY=
Received: from BN9PR03CA0363.namprd03.prod.outlook.com (2603:10b6:408:f7::8)
 by IA4PR10MB8754.namprd10.prod.outlook.com (2603:10b6:208:568::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.7; Thu, 1 Oct 2026
 08:53:33 +0000
Received: from BN1PEPF00004685.namprd03.prod.outlook.com
 (2603:10b6:408:f7:cafe::8b) by BN9PR03CA0363.outlook.office365.com
 (2603:10b6:408:f7::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.23 via Frontend Transport; Thu, 1
 Oct 2026 08:53:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN1PEPF00004685.mail.protection.outlook.com (10.167.243.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:53:32 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:15 -0500
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:15 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:53:15 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918rEu51595324;
	Thu, 1 Oct 2026 03:53:14 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 10/15] crypto: ti - Terminate DMA on all error paths in AES to clear descriptors
Date: Thu, 1 Oct 2026 14:22:40 +0530
Message-ID: <20261001085245.2922974-11-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001085245.2922974-1-t-pratham@ti.com>
References: <20261001085245.2922974-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004685:EE_|IA4PR10MB8754:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b89eaa3-5a4d-4de1-ad26-08df1f997905
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|36860700016|376014|82310400026|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ymQ1DEy66QxUDVKkVCjflm1Mx0Hhu4e/xq9D4cBvJVu0r4dIqj3x4gZgns+ejgwDylQK4MEAZgK+lr3LbbIQcjxP2o6Szn8z8LSE7FlQAUUAqSf6buI3aCPnXgx90cjAHNg/aPG2tAxETp+zo1B0Ko2USVaWEjkHwAf6fg2m125sY6zDnL23Y+vw0+/XzdwQVvq+WEJazBjAzgDmRJd/IN4/EQ1Wki4jdZtn60UAfdKc/Vno3xN7ZdEHyE3Gqm1nyN7ECQx7fzrGnvLByOQ9kokk5gOjz/622hIEKhhg3XK7S4unku50qiRaKlzmENcvfkkxYgCOPZF+STxtOCAEgdoYe7uQBGc+95d03ESnSSlvkzU/i/O9/a9PASY4270wAv1giJiK4bhC+WT0GQAIaWDtO+YYB681I2j9CYQkJ1+5LLyO4KttA01Xif1bbhrdpn3xrFE7X8y7Okpw9o0UWaLt+Xml65yNpWA1turksGbC2kIFG96yiT9d/08iYTk4FaPGCjL5FEwehrUih5cCqYg99Kn6vg5zaSpgOBLwvIgGgRVC4X+IRTqERQZo7kWJHmO+2V2F/WzyCC5OQIQuU/9QyXZRFJS5SGilpEZhTXL/4II0QbtUAhBqOPXndvhPYkCoKl6wg8r7FPnLgh2y5T3fJE/BU0HLX7LdzNKBPiHBTTmuLHMmY8tu7kasCiz2l+Y6WuzwXRUlEU8C1D32aQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(36860700016)(376014)(82310400026)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VqRHE3EuyhKFfjjOqLj0kctOinUMtXLPtFBIlGHWBvKq4fKPlCFo2mgJhcnztjYADzyAEgCViMmJczjS2tVEP6oDryRG9Gq6Iowu3XaQ9WVPB3CrSNT8z/qDGLCHDkWHS3xSppfg6Hfz/rzG8o7ZJJMYVYXTlYcrfAXso6IL3hy3RsvXcRgwy00ltEhy9x9iEdxKVgKACOdRi9/VO6U1un+5jsiivdbjZILrzRECav2DIzy10dMC6R9cHW8dR8bygUA/hhNZnKioLs/+iDZf6Div1NLpO9NwkWyIFrV8hJlYuCHKTzMNniJ64870AXzz7drmzKJUz3F25gtxSz77nl1v2X7OUO+lkBy0o/T4CR27sbaeikoglozQsGQyvfWM4r+nDgrsxmkN6rWRc1moMI3Rb10UEwpLjhgoLXOyvtfU+6rhOYwaDZ5/zEFYj5Wr
X-Exchange-RoutingPolicyChecked:
	bEPxyYaMXww5dh6fbrlmhb01tMbT287BeLFwjzn6FbvsyZS2RJD68DIojTTEhHtH7QfMbbxhq7r4jD4yzVuh4Bj9M0X/wYtCi41BrtH77otkuSw8WgvLSQuvUZsOt1LjOvpI2TWiRwpEiEn7gyHn09JoAW6PU7NO4ND6mqLqFyf4JDT8UCUh7l4CY7w/Y6K+ZZaDl3ECpYNzrnYPHtGyOuQk6pwFRHbGwuBO1WQu8g6oEnO1oRLpmqpAmjnbMa6i2xgtaUFDgHNIZJiLz0CLs53d658WS7Wc+tWtIOzF2FNO1GsOwmR5GrO4uyrktwkC+rjhJzZI6Lse0ldlvkBKyA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:53:32.9643
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b89eaa3-5a4d-4de1-ad26-08df1f997905
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004685.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8754
X-Proofpoint-GUID: QT4t21ue13E6YkP6PSIwRbpx17AAYSuh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX4ujWV2yAd0n6
 onQmUqIJPSl/rmTZNxY4e2ZfJqRp9i39EddUAqFecSrcarQg3e+A9SeTSBq2Z9ekQ0AtOGnOnyR
 8BRbw2g5sLkCSK/itAKI/ZYvBLnAZVE0ocp9sLwZXdL9agdXvpFJS8Mv6PCil1xjVkqxZy9/MpA
 5M0QvXMDbIdFj2okWsg1TrNWankjSQOQHbNyLJc8vBfYWfIA7YtHSJ5atxlWaKRAuABf9VkC80c
 zvhBIOQEBc8hrdEYjjLZmA5Wotg5RNn4nCtb/nSA8xmCvRtM5UZifIuYscSQmGCcSZ9jSsmn/0H
 vQ/Yxixh84oIf4WtP7Yrs5iMCUzZHAemoNvN1PP10gKaGCTnxRaFmEATnMGdV/RHX8feq38HFsL
 M36wJOZVtZ8BaVW1KxEybcUvbH/XLJTsouV/iVCZS72H1ar4XrQvkxUemCf2D1QYuIm3LoWcvoU
 lf5HLX3ZUSuzK+qbgcg==
X-Authority-Analysis: v=2.4 cv=KvzYSmWN c=1 sm=1 tr=0 ts=6abe1f91 cx=c_pps
 a=boTDQTO5XcRoDQ12XycLVw==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=T1XiGUNGXxSxoSVzcpQA:9
X-Proofpoint-ORIG-GUID: QT4t21ue13E6YkP6PSIwRbpx17AAYSuh
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX3ifX3uM8Zis5
 gKOGEMYkq3XGUd11x+4g2aSvDaxhcXXbjx7eme+eL0GzuqpO86hGDGVOb2z9eL9COYZHpiTY/E+
 BNMHTkPjOUW3bt6jhK333ltjtP2ajds=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010035

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aes_run() to appropriately clean the DMA
descriptors.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index d75b074ca1e39..ccee60800a664 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -449,6 +449,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (!desc_out) {
 		dev_err(dev_data->dev, "OUT prep_slave_sg() failed\n");
 		ret = -EINVAL;
+		/* terminate to free the orphaned desc_in descriptor */
+		dmaengine_terminate_sync(dev_data->dma_aes_rx);
 		goto aes_prep_err;
 	}
 
-- 
2.34.1

