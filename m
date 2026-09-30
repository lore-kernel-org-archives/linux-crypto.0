Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8764CCDC4;
	Wed, 30 Sep 2026 11:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767606; cv=fail; b=vGiLnIQZIZZetPwfnmuXayOBdZOXIsmk1eRAxZWHlatDVSlY8B91rF0E8Z+eFxaW/l4RDuWvJpjDDDEGJOto0ltuGhfNlpD1O24A6VUKGfcukN4T2ixPyUA6BJ2BBxewkFMCpHRslRb3fa1CbGJFVYUIVj6s4itNtoa3vb9mvL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767606; c=relaxed/simple;
	bh=oQcv2pfVE0dbAsyh89q3x8jqUOr6UhAZWgfc3GjJRdM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nhl18vrb2QjwQpKci5m1PsQbhmxtV10EI3IodwblAjk+G5gIFk1LqWr2ADJNAo7n+MR5Famp7+XN1iWVYug/jkM3rWEzeBoxTUpei2Bvvo5bU+WriSR6PUy/s9rDtfYvktlkABRYvqBCxF9glayaQkZfIL15C+RbFxX/rBoS90Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=eejMri+Z; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=oWF4Nk87; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="eejMri+Z";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="oWF4Nk87"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB69Zt2715438;
	Wed, 30 Sep 2026 06:26:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLi
	nQ=; b=eejMri+Z6+HKRzgYsouFb1NGh8hItRKn1pqMkk4eGt/pWgzT/AaTUqrZJ
	QzHdQmN+32UxWusjqe/6052xnwO4ZoEuJLI1+vubwbZg2M/d2vzFUK2LkEQ0TxRU
	hUSLXxJK7ehSUPGCQpMcTrQ0ptGk9WGXQSSGTbT05EpVoVOUvXhBIGrezTmWw4Fg
	RD8f5WGs7TXw6R8HhJRzMek71ZI6bOm8Xih6Ixxh41Io/A28485d4jSxSLqa5Uv+
	nQLjZytinPgJ2abKIb4papMpSLWfuMkP0MEix126wpWGQrk6VQ1jzp/NP8RwkJtc
	rlsCkP4aMkHwNnf+D9MJaQtsrx7BA==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010031.outbound.protection.outlook.com [52.101.201.31])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0m9fcuqs-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:38 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8nZWbKFIo4ZHyS217/z3ZgPIFF6KWyqMAF3qX0D0ENvUfEi93FGy6kZ8Dx116i2+Y96TI9fv/zIaPdOjJ3EgvaULSn63LgJnk1x1NqAD6t0CruFDdyfcXFZq2kbhiihXRAJiQFAJcB10ouwKUJHn64sqPuGC1Olil/1X7rYSpwGc6FLB8C7d2hqbSDdhk/c3GdUWa5HTeTf17LNBapxs5vbQD9NLZLlFtAzyJmyOaYQXEPUMAGFH91sxIyNoZces2CEQxni2KzYROdg/9vtY/od9kDVB4pJjBj6KBMienobJ0lpxDOhRI/ri8PwkGEStcnZj3f4rarzpUkq5cuCCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLinQ=;
 b=RR3PPmzk6F2m4B+SoBZvyR1v2frXDdA70gY2JANGePynR25RDP88kMsll0Gr3Hop1wnsmTnykQ+vPcvrgxS8ZxTdoGGlfAiJZerlfHdRArVkDDqUt3anfVPO66QQJmKzoSKjUnfeEjNdjCaOmr0im6LlgXAmPy8/wi4s62L41hMOETQf/nFoFnDdqLmkMztH+5Fd0E6jDegpMLh71HiiapZDZ04pwqF+iDJatukM0J6K/223RRN48ZrYyH5bmVqEBYwZQl87Wod7KKgFPgWqMrLYQbk2u3QvrE2wZnKOfpmsa6XZ4OfrImez73osZm+u7JS22uvMEkfVUeTAGQN9BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLinQ=;
 b=oWF4Nk87sHpHHGPITLoUf5XGzHUmLtG65LN3jD+TBeSLjyeww67Bw0HZISONeb3ub9Vv4xzDjtUg8AhYJHXH4vcd3W0JYZ0LjkVUjwW7UMi+nCxqp+/cdQzkfoOdWUhZOdpfoqnoI2ulv525DNa/5xE6d1Z/S8/gUNx7uedyR4A=
Received: from CH5P221CA0019.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::26)
 by SA1PR10MB6319.namprd10.prod.outlook.com (2603:10b6:806:252::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Wed, 30 Sep
 2026 11:26:29 +0000
Received: from LV8PEPF0000005B.namprd02.prod.outlook.com
 (2603:10b6:610:1f2:cafe::99) by CH5P221CA0019.outlook.office365.com
 (2603:10b6:610:1f2::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 11:26:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF0000005B.mail.protection.outlook.com (10.167.245.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:28 +0000
Received: from DLEE201.ent.ti.com (157.170.170.76) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:19 -0500
Received: from DLEE204.ent.ti.com (157.170.170.84) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:19 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:26:19 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBQHcS3025637;
	Wed, 30 Sep 2026 06:26:18 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 14/15] crypto: ti - Change lengths in AES to u64 to avoid potential overflows
Date: Wed, 30 Sep 2026 16:55:32 +0530
Message-ID: <20260930112533.1593952-15-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930112533.1593952-1-t-pratham@ti.com>
References: <20260930112533.1593952-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF0000005B:EE_|SA1PR10MB6319:EE_
X-MS-Office365-Filtering-Correlation-Id: 299ca104-5889-49df-b7e2-08df1ee5ab6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|376014|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qqT4B9exWYckRu4fSANAJ3TgUEjx49nuNPAk5hl0M0vLkx8zIbXnZ4ko0T/VAf4A1xx8fJXbSubFs/DGWwSq8eYFL5iwn9svokfpNMPIbXG+Pid7FA2O+E4j/tZFxr2447bfnOyX8iY5fIDt6L1dNUThxFTFVLsEGukfb+iX5VUMcqvCxeEA8kWKHzC7wnBG8VW23bh9JZDrW0FU1SKYIpe2gnp/S01WDCdcKy/irwA42bWwvjFJsCyR2A+Zmgz1gwNJ02IGYKL2tGvSs+VAXT9BdF8LfJrnpPeBRp6g/aNalWVNfTwcDBiq9//bfdu9E9OjtKcBdwfxqiw3TEPXLAEWTjPuCu5V0q9g8X7+yEGdYV+Idl8atZbyFNV6I0Xmnd2FGF1/3HSDVDU8Xl28qiwgS8+m1rcE1OEe2VKGL2n+nRbWgw07HhbgnZElLgSr8hlmGCne6OPz6efUEBxwTuKv11MmKNuU4vTQZM//H0xKxuZb7FNAj0PU7wp+fXZqP431fGn0gp5iNM0VmjOqyH5xu2/mAiuf+tCfsZTGyIOOqzOsqISU2FWwtww240+AZRCPl2GMXb403VdZFtK5aig1OkxERfI18of9Ko0/kqRArg3NoxJbBBCm7aSfGvYT4KI7XM79PdMZ4gfK7jMntkc802QREPKDQuyyEWy3dWIuBHKGt4rqx+HR4vccvT2t91ZGAx7PW6xhHeU4sBhGUQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(376014)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	By1AqW/b26H+01SDtK7xWqLVq6dnWFXnAWmYh27FdGyDS18+wijw4D7Odpiyup6dZ+IEDhQJWB16SeOQCmsMy+nKfjc54IrigT4gwbznQlA3PaBbv6SwDdqN2kg+1oJhKMhrRS3MoIvF5PLq70p0yxIo1NzT14XAcbct33lMhhfIQ0rh1PkHXgLQre0CWj7cDlf0QCZNRQW538eZe1lIKdpgwJRhpVJlKl5R8Lsn7jPWoP3cv2K4oVtArZKhsro2vmIVtAFQQuHG+wa+5wsuVK9yIlULQkB1JXurT8Ed8ehzL2oy6C4W7eNWjMLvxAUFqcwdqnSuPVhzOxoUsTH802JqnYBheputxC/E+oQOn39HW19usqG8aoN3lQHW8wzg5tdW9HO5TAonseo5Qvz69YyYhz6y/z9y1/nhGjC3PNm/g47wlVGvrQ1N1H+v3/ih
X-Exchange-RoutingPolicyChecked:
	JiuOE8NGbHab4W9MnqGxBIL0ID4F1p59PCWztEU3SbHMj5RJCWpxey6dto0cCVTQWtJZ2ESlgs3NxRhSa5qnFTehREejb8dEum0iPcaXhHHBspFvKIBofqk/QWKqFgwVgbTlBc4JnwC3pXWYFYV8X48q6zASdY3LpI5faq1EYdIedHWBhM6lkBv/tvigpOIxVwNtgUy/K1TUhP5PxV4mngauuz1DdPLAuAdZKjwaHJ3OlBxNPPGhu+G2s4zR24Q+1wH4Ph3GvNahcVKjTZnGtOk/bwpyY3+2+ZO4mwzKuiShFYfIqDNEN//AJ7FB+21wJ6XskYWiXQM48LAFEw6STQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:28.1250
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 299ca104-5889-49df-b7e2-08df1ee5ab6f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000005B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6319
X-Authority-Analysis: v=2.4 cv=VfRir1p9 c=1 sm=1 tr=0 ts=6abcf1ee cx=c_pps
 a=FTqHLmxhk7TnHmysD/QBZQ==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=sQKIhDeqCqRtbGPzpkwA:9
 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: g0Zbb0LZ9XdYauTwCvwNYKo7LZq9Vqbv
X-Proofpoint-ORIG-GUID: g0Zbb0LZ9XdYauTwCvwNYKo7LZq9Vqbv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX468mitpJ22X9
 PFQdpSVXE5uMIkQiNysPn4qtzVihS3Ms55TIdWBszrmA0yew0A8qaBrbe1ddBbfa+6qBYpRog6f
 13Fb1vSlEL6Jc2BlEVMPToLA8AEcfl4U1kRol5MIq8hmPHuaolBybgGPW17lsWGUxXnRM/Q2Rnq
 H+evroNsFbDvXahUothqUutoPhp3CQ770rGo2dRj/W8tnmMXRje+eXXoPnzlrEug+9vvyeIAT+u
 3LkqqnCwi/9uoIndIElpDcMOP0Q2MQ+rPo8NDxtZ3aezAZ1tXZp4B3iZMxOGMUpyAf9t3o1YBnM
 07CF5kJyLA6DA7ZnIRMRUP7EpVaaZZHRzjM1ls20FwWecggerIuhHocXx9FT7g8eHwsIgQcAiYy
 ETYhZbmL8W3vAhLYaCaryv/SyCcVjyWqG1CRCUf5vyevcRcVwZJdRWStWiJQunxLKd6aYcuhOl6
 VZzcodSqLaTGcQ4+9vw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX2U2D1brixm/6
 75tcMnd0fsyjU2klXU62GjTq7M8B23symp1+Ps1Anlfci6m8oBgRlSVS4mPKRQLkRSAk5G72tiW
 x6PJJb1H/YK5yOLUPVIaJoTU/8wNmbw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

Change cryptlen from unsigned int to u64 to avoid overflow when added in
padding length calculation.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 657653d6c62f8..e141ab8980000 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -326,8 +326,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
-	unsigned int len = req->cryptlen;
-	unsigned int pad_len = 0;
+	u64 len = req->cryptlen;
+	u64 pad_len = 0;
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
 	struct scatterlist *sg;
-- 
2.34.1

