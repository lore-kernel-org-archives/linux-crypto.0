Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4603D9537;
	Fri, 18 Sep 2026 10:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727037; cv=fail; b=lNbvQfZ372n+4aJG4Fghwp8+xrfIeJZWzW8NRmfckW9mT7r0x/KKFDTSeXY2fPqOgDdYYrWTPl4STpbF1q6zEk6elB4ncAuoHHXHzuHfYrpC+Xc7psbKnmg34p//AuxdXWGwtyqL3nQAZMC3h2BD4VCcXk+YFu97LMoIyIAkKLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727037; c=relaxed/simple;
	bh=6RV17K+dOkVeshFmshHqF6sMCwCc25grQ5kOysr9CGI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aQq7NWft4qRWvyZuXb+WN7+rvdMFL3DhnmU3IaFhRblNTk7cBHm1Qt6ii47kAwK0NB1yyGbtdQ6ziiHMDtp1amg9if+5JPSdniuX5wqvjVBhnrMWmbLItTl7uiHlunI6E+BrDbk24kgLRM4rpU/nI0wDmC1j7NMeyRcBe9SxZX8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=k6v34Nhv; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=TLsrG7SH; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="k6v34Nhv";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="TLsrG7SH"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I9eGvL3768282;
	Fri, 18 Sep 2026 05:23:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=3Hbdg4pI7uZrAjMnu5fvtSkbjxE49GEKGFuOUs0rp
	ss=; b=k6v34Nhv8kFP+neEKo+4/OyHH+sS4UMYwWhgqwpa7GBxashklGYnCNpG4
	fi0cJEFupQ/gNNss2fvHJZb3/JVMGEiMZIdeEOvyBgSuH4GPITRcHHNJwWvZxtQl
	sRgXaNP/jO+WKxaA4WUgpRUgmAgAfKw+QRC5kb8UQT0vrLfVCMd4LyTiJzycbOn6
	WW+PDIEDd8W9UIOIgmZUJ0v8979LVAEhXGc/VQ3IPQXKq2DHKl54uVgtbDJtRYcA
	5OhYzyKNVey4L2qX/DIa/5J8uWs4sRDVEpUjcBF9l4LHKsSO7qt9UirDWHGp2ymG
	qnwVcmBmwMJe7wu20zPWqO5mNpEsQ==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012005.outbound.protection.outlook.com [52.101.48.5])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gs16cgsnf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:23:52 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tdWcyfmVNFRcG1P68kwex/WvPM/bkVku8UWOFJguAPAruB2aM+9ju8fcC0mf1tAfaahDim/HmBNX60Nf2fMam5LtGx+9DVYOTc9/bGz1hQAIFKWxv3Xh4QkbtiT2NNYengDGyKKAwq9ZRzatgssIJCy7wQ/+A9BH/0cMlh+I/3AXI+WwXcicDeyBxH0LIXSal/7T4q/OzMVNx5Co1oi0Poko/0RFa708Q03AC3zRMQ14Su9uib13kVGR0Uf5IN0mMEZdKDP4j/uHBd5Z5jxy7LhXdknt6+fmCD9R+eV023sa8gSrL0bcteibe49c4Cbg2ryAnZ5uX+A/5fjEDvlcIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Hbdg4pI7uZrAjMnu5fvtSkbjxE49GEKGFuOUs0rpss=;
 b=zCPOKHGPHRuSmAwQndU7FpM7lz3h1uItupyTgRxv3Iwuz+y5qSbXVTf/eQxMx+R01kHytFof9gPhGZV6yelqJK7caDlX27MuSlGKw06SVOgiotESENyoQLZyPeY75yXwROm6hil3dhPcOgrtgpjV6EYP/0D1FAOEJmCbwd+uodI06DkrFVBZvsl8y74jMKXsifjXj0wr6Qm5jlkR6+nI+sKhIDqQwRu/eCKFU43GUToB5TQ2llGhBdq93nGficlTsG2JW4xbHbVSwYjZryqEaR2JaihC05z867bKQcqZDioaXbVH5zgRCzJLXmVh9KxpWgdtGJSWXZH7YDMNM+LPmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Hbdg4pI7uZrAjMnu5fvtSkbjxE49GEKGFuOUs0rpss=;
 b=TLsrG7SHIJkz7XVBO78Tnn7v4mn56ADA9S1QvpxioXpsJTgiiQNWpRuMP475fHrO3l7xmIpjHtt4YFBJVoe3O694C8lGlNJEkfJNuwF+j5+ynK73vQG0Mqt7Fr+cl5ovIAoemnHsr2KAP80lrs5Exk5UiG63u1N8n/B1nehnQgE=
Received: from BN0PR04CA0068.namprd04.prod.outlook.com (2603:10b6:408:ea::13)
 by CH3PR10MB6884.namprd10.prod.outlook.com (2603:10b6:610:145::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 10:23:41 +0000
Received: from BL6PEPF0002256E.namprd02.prod.outlook.com
 (2603:10b6:408:ea:cafe::1c) by BN0PR04CA0068.outlook.office365.com
 (2603:10b6:408:ea::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Fri,
 18 Sep 2026 10:23:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BL6PEPF0002256E.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:23:41 +0000
Received: from DLEE211.ent.ti.com (157.170.170.113) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:21 -0500
Received: from DLEE202.ent.ti.com (157.170.170.77) by DLEE211.ent.ti.com
 (157.170.170.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:21 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:21 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IANKMH1534705;
	Fri, 18 Sep 2026 05:23:21 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 10/15] crypto: ti - Terminate DMA on all error paths in AES to clear descriptors
Date: Fri, 18 Sep 2026 15:52:40 +0530
Message-ID: <20260918102245.2784000-11-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918102245.2784000-1-t-pratham@ti.com>
References: <20260918102245.2784000-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256E:EE_|CH3PR10MB6884:EE_
X-MS-Office365-Filtering-Correlation-Id: 343bf0a5-b50d-426d-098a-08df156ee98e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|23010399003|36860700016|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	F2Y9x9B/K0zDY5MfvcbZWVM56/900VOtCfzsaWpOGLULo0fy3p54hQ6rnzff31qezAEKkgSmb4aQpNKM6b5YH5WWdreVT/JZ9QIp+r2zcK8P7kbKMjOkk3JlyU0ug49GGbHd4MnsWwEp33VGVvvOnXP19Y43RGz1YSrC6BPaShrZZ8ocw2zyBmQ+6ioQaB9mJ9588+2e0IKXGGd+fRxAEc2DSf6Gi67Yh8IiztmJhk99rN4B6rEIjI9bPFFW9/wcze4KEf96g/5qWXVnatEaksLLEdYtvnXSeY8+15GyXeAskp7BU2Z65oGhE+HYQ/+aZbcLG8LINfTaBGvOp8Zv4lwRyjsFZRUKd2jP/UydYRHqeUPFryqzP09964q0EpC6s6xV5s+bVSMlYG3eV0xAykXoKRbbhvRc0VoDKMZCrh2SSoV0xW3XEKThm56wA2JosUCZ6UsCKoJ9iX/xEH+578QXITzCJuxLNxAUpIBjjd4DGwz49iWDuSvQMSjyDx5iJnI6W5v7bcSdxu3lRBo8/SbarJwEQmI8z2RFyXRfQHuKUz6A10V0QO8x+RD6GQyVJSJB0efpEYkeTM0DIiDEjDSrMWo7kg4eDtDrFpOm/Iy6AKnzZCW64yHVTtZEzPgvde0h8zxRWdL6rXgdQXrcVWjaCFOyLx7OeYuQxdUE7h1zuy4u9atLQifz9yWojVAFE9md+WJoktfhomvcqrtv5g==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PxBbCEyFl0jHfF9jdiWkKjGhUiOPzl7PeXx43z7grxBl907MKY6GeHMangTlxF18B7J0vapWqIDyca3P2Lrt+mfPexEkBwE4JeuYIwhuoQOTm4lF4bZ6yLcilILPfenSqKF8q8pLBZJB6i8s2omH7JCRveKR90YJ+JInwFJnyHKGEVobvi2limAHKzc5VQSugnIFkAjTPy8JNtGgLmy0xRM49HuAwUIEFxhp/9qLalpuKUXQ3/tXURgjh8qYe6CAl7hHzi64nufCVk4MrmjkQMh2/FBDp+Qn/TjTcFivpOmLioJSBcpvBPViFrghYRKPw8reeM7qiOR6qINSoRYg57nJOGjO1f4cVNtRy3ltmhMQXlFnNeJ6H6VrpU0cAMuD5pYNsYLigZigStWUmMwvWyx2OeDbjcIo7Wy3aJOMHS6Ut0TxQSmRNYzhyme29eXW
X-Exchange-RoutingPolicyChecked:
	2e83j+k5urEQT3I2XI2WZWUT1pSCTX0RFACKYID6LmVXmyQniFKhVuXcDhaeqFdJp5XZkvzYU7hOaKweQLrgu9MBVjiQGB33NuItzSXEu/LAdeHZ652h4LYAL8wEfptnK5idsmuShxOwR4t2dzodJRA0BvL7ulq4/1ZwUvCoamoezn7ilXlaDWtLHAcx3/ULgbrTFXAxHoDQLflIHxnZzZpdDso1cPuLzFYbc2y+xAbi5XiBc/WH4xmdg8+wNz3aDcdMnp2a+WxqHs6Lf4mic7c8fFV200Cd07oHdd3b0h4fQJZQpDc9w2Fr+8nOujBqRmhVz/UGUKMePFxJkKaRkA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:41.7627
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 343bf0a5-b50d-426d-098a-08df156ee98e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6884
X-Proofpoint-GUID: AFeEUbZ17xZ_h1dKoMmiLBzfR1b1bWzy
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX1f0rJ+7dmxNN
 sgrIxq9Fh0I/P3U9KxSM6SKg/6alKVKYt17/Tw715kTQXHsNOyPJ/jn6jlPYpy7bQMCE48Dh6k3
 u3++lJTHekX3zMhe/KUU/Unge9EfGX0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX46MIAz6reu3h
 lUd+GwjmB3TPKRVXGGlGa0vawC3R0KSmghaRnfrY8PUsjlPNJY9yinwIf6ICeujhgiC4H0aQERC
 Yc6L74lF5SZ4ybvGzAL3rvdP+agiJDJfaInMOu0GJVPS/g71BAUJ8TwepRMxCmg8cgx2tQe2ZKx
 yFaQZtvSW25V6p36IUHJDFdVafNtXnQN/S2tlesdJvmSuVQUdD0sWbWI4ufDDqvMLik7KNe5xXk
 909N+MF2VE14rBzyLBstbOZ6hiy5fXujgikRwDA+3a0VCiwwi6msrNq+RgSxoRocQxIxGhVj4WI
 m4zoBPx332jDFtDrx54lJCmsau3ofk7g6Q/LdSNpxWwVrOppWsV/57rsV9/I5oYovE5wzFF0Jgr
 JUE/uQywRg+vwzmUCqDl7H7Krw9fXckIByVfYYmeXFphkrMiOZqZtqSyHwUINL0l3rA5caZDNQC
 x/9KTQqpt5gLwxd8Gog==
X-Authority-Analysis: v=2.4 cv=cKh1IVeN c=1 sm=1 tr=0 ts=6aad1138 cx=c_pps
 a=nMxr8a0Y/G08GAkVjTcMpQ==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=T1XiGUNGXxSxoSVzcpQA:9
X-Proofpoint-ORIG-GUID: AFeEUbZ17xZ_h1dKoMmiLBzfR1b1bWzy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

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
index 65a53fcf80467..10073bbeca113 100644
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

