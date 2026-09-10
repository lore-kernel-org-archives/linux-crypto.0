Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6483F45D1BA;
	Thu, 10 Sep 2026 10:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036994; cv=fail; b=SsWt8UqLdA9cm3ZadweXLBHiRdpDsyKJGKgltvziLVVbS258AfDdFDyoGuBoKXncwd1jMHWfGpvJvgDofSm6+qZcIVHP5h6xiX4uq1bNQQZB5lQZKcGyNdF5J1zTzODiBao1GgPBykQg7YfGmHq/cAbb9D04mAiPxC/7kj35FSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036994; c=relaxed/simple;
	bh=Ge9j09OItfl39sMD0+R3OKL8fXxzjj6qvomlEshNfas=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bn5jR4H4DV0HCehTErFhuVP7ikO1I0164Jfn3vz7Nrjh+XFHEth6wGpYZUM5p5k7T4m+WALHFnaqyQF/RXIHxhk4HPPMMOp47W1/RqipDGW9LC3W9sI2TqfGF1pUtbEKZzYmhfh6iR0yVkrxzAUjpEyzepBVgSPXKDT1Zo0az5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Rz4u3QpC; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=SF90WBAJ; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Rz4u3QpC";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="SF90WBAJ"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A8oYLn2934232;
	Thu, 10 Sep 2026 05:43:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=30Ztst7SGgSl2Rl1/eIFquFLmUY0KxcuyVzjHqWNX
	uQ=; b=Rz4u3QpCuJiPHym0s/FdgkBM/ufq/gS4ZBTStrPy1TZvcD1A5XjtfG74U
	zKxvNhYI7NveC85RWmvNKx2flIH03GqzbtNW1N4RjLRdHq94FfxlMcgNjdsLsxzC
	G3K1uHK0FO+k2IfqGocSfSjH+b9MhNRpmTtqBDo8X8lLY/sbYCN0shm9zf2V1flj
	j7+Lzj+2rlrsu+7xX5mskRSM1DvxB8Z73KLoAuUQkb8gtdyH1PNTp8YzSP5EGNBg
	LpQNGk606enYOv3mqcDI9yeBlt7eOg3Fbps7abd2GTBRtRBx+UMhM3p9dLzw/whM
	4jbHBHHEzxWCU8wnagl2sL+fzTfNQ==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011063.outbound.protection.outlook.com [52.101.52.63])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkcxg4xjk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:43:08 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HWBWLb49i1osEKjS9RFmxdGuR1GKb8r1/io1idnYFOygtiqt/qAIaTrslju1bFS7CfX7ZOmDFRE4lbb8geqmEycYfNrCQ5EAyQDw6XV9x9Y4Flq7Te26cnF3ArVSOlOSZkgTOOicgD05UMYzV6zjyNSMs3jO9TlofJXruJdzpWsDgLnMMf2H3ZjKF1E/uWEjAVrk91zU5NCmKP5X/VymSvwhgOh4Qxwy3sclWrTnb3Tl1HeHgOVIz8CKsx1iRttQcuwYtJf/+UJoCddl1zXh+xrohrH2TNqR60VasyrnIMiccX6o2dOoZLLWRo1MPHIQd+Ea7zj0lDkUf/0S89mjiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30Ztst7SGgSl2Rl1/eIFquFLmUY0KxcuyVzjHqWNXuQ=;
 b=gohGpAHUJAoDSyrmQ8NVBMnXxmkJNS9gP/sTsMMXKIZCBRoBqkPlIFBWl6y3XdGfxoHsM6YihCsNTEraplBP/sbjNEVMecOmsFSScvQT7CJ16OTZcZs1b+E6J0Vis0brLbKVBVRP6s2gun11lwCoYmqT2/LwH5mxAIXEUJrLGVngt/YdevqQwnRVjh+mVih6fu2x6f+NAsCjmbvZ+lGrtQyvtEk1O5reT0RT5CJY8FxOS7ZLp3sZNTaX38s0YBh9PYzfCrmfAwsdc1A/lJWnFJPV3H83ss2QrDOak8tCiDup8tQbSBaazo0VRgzdUrbBoKlkpRXQLWCdu1t8UNSXbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30Ztst7SGgSl2Rl1/eIFquFLmUY0KxcuyVzjHqWNXuQ=;
 b=SF90WBAJckoRYjhQxXB7LSvA57FsPHNeHCAadBtZOkQRfKlw47ryiU/yWFK8qnSzLs25ayPfku1cWyGV1CghG0cpQ9pLjqWQ8odgeb8iV8n2fC9sg6QvXlIvdyDAudVQfQbX07Y3EI1fhVnRin5TBtp3MbTvlYFChP/2UMAoKq8=
Received: from BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27)
 by PH0PR10MB4631.namprd10.prod.outlook.com (2603:10b6:510:41::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 10:43:06 +0000
Received: from BY1PEPF000264B0.namprd02.prod.outlook.com
 (2603:10b6:a03:254:cafe::1a) by BY3PR05CA0022.outlook.office365.com
 (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.6 via Frontend Transport; Thu, 10
 Sep 2026 10:43:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BY1PEPF000264B0.mail.protection.outlook.com (10.167.242.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:43:05 +0000
Received: from DLEE209.ent.ti.com (157.170.170.98) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:53 -0500
Received: from DLEE215.ent.ti.com (157.170.170.118) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:53 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:42:53 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAgqVM3150465;
	Thu, 10 Sep 2026 05:42:52 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 08/12] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
Date: Thu, 10 Sep 2026 16:11:58 +0530
Message-ID: <20260910104202.1537226-9-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910104202.1537226-1-t-pratham@ti.com>
References: <20260910104202.1537226-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF000264B0:EE_|PH0PR10MB4631:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ed940e3-ce05-4ea4-6c6b-08df0f284bc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|376014|1800799024|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	jElhkQgh61001YFh1AoM/Waxmouzkmpc+9kkxtmwwYWVs5nSFQBBT65rfT6gxZ7rE+aYc3YntzZdXTHT7Mr3HX1rX4sqm9DNFRGlLwUetumboBCfeoYOCKyyWKvN59dfneuwVc2ConqbBrAQmwC18KZy23Yj22I0PvvhBcCjthhcUB14pRQvd8CdowbE/QbPQ8umnI7YVwVpCAU723YZpYJxcE7CtphbNz0WKTDT4HP+HMXuS4efHrvc+3wdk7HwadJaexWMlDu9/Y6r+YcXjK2VOM1hx79T54ia4SorGHtREPIKCvfdF0Ecn/g3Q/2katJt87ZSI/ec3Y0uM0a+X3edSsX47RpeICscvSoLiqe/sKIWE4LSG7F34R5VEv3/pG2OY5I7CoyVpiGPjg3zvlk/T7gkcbecnd/4q16XpAgGMCeBf3z+YtsouduztWG4HL7PApGlbpOP9Q1cw6nFzpvVCDQNX2oXsdDr6S+5skdYca1zi4NZvOd9v5/qBqiabr8pA/4BnXXAgQo3MpoKD69Cno7UQf+LJr3wnLeU0RTrhGS4aLiqSQVi8dGVKWkIpNMW9lFRDTmHbyVof7gw5xoQ7S8P1cnFKr63Bwahch9k7V7x/r/qgRfYZipAFjPDrc0ahQ21Cyva4rkNSuY34hGitz7u6gj+ymUt3vgKVlfi5XUiphgfKQlcz+QYkLWKpgL8sSmXIXXNeaT07ODprA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(376014)(1800799024)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kv3QrH3oXPLvX5JWj6Yr9VdOLUjEqgsNdGANcqeMfZ1Nw2z3f3OS964dHsUp1rZAQalR3lBfll2Tz59m4fskmiXw8a8ud1atf6b89k/DJdX2vLDF0xgXxwh/WmY9Q06hvoGtkp9xztUGXivIHkikQogmpAxVXxb6pa40m8RFwgOKoDNNqrPdnhKPhEp/jPRmkwLpU/jUfttgxUnO06hub1H5aD2vw3YiPe2QyzyrmnCcuxaUh3jz4aohEOejhdrX313XdtDR4lJl5/zqyFLJ0CDqAUIWnLMu1WtjyLs8ttKGe1l1W8z5c8Z3RhR9CzeujvW8qzPCm8gYn9Y5eTQD/wvoK3Dd7HYcXxv4blCesvQc0gHNKWJwDoW939KRxovzH4gUvhSpXHZgylKXHVudJoWMJcI+jHf4dVG8FkH8dx3FDmu3oeec1dh6RkXflyIU
X-Exchange-RoutingPolicyChecked:
	NVZ/bfVfFveRr3cG3Rfe6+oCIGNL24YA7umwhZL8TD4qyODOVVd2w+oZeooKmQjl2hpJsDxMBH6I0fLvR1I6BXoJai844Ipf4jnHjLtETTpFuMnny2KZ5qew5fOVq/vRUt8j9fLhMvp1o00foifFy3bMIt6aV0VoPE/B4/y3TZkCo/Wcsr9hXSqMwC2tA5AHqxvpdOFaYmJMhQqstsV4Z2a+NR3Z30hEIVxtd8CJZRE4klC2K87+K/jW4SjaavbZSQ5mM543VS41njxnY38c4AfMyKszY092uejTlsYdc1O3awFspHvopFjsoHe9Why1DiRKpmFN957a/uoWLkXWXQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:43:05.2616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed940e3-ce05-4ea4-6c6b-08df0f284bc0
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF000264B0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4631
X-Authority-Analysis: v=2.4 cv=MpPHeGae c=1 sm=1 tr=0 ts=6aa289bc cx=c_pps
 a=/mfax+0MUk3zis5Hx41TAA==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=wrH6CD59uMa574BPOq8A:9
X-Proofpoint-ORIG-GUID: fpYfyP6CrbfbMGXLwQ2B2j_PywxFbBM2
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfXybT2xAfN0/Ir
 JC2NkmvWQU/IuHAK8Up9D/zsf5mGTaLVMJLcnkLX+b13hwnajT188cNUZx1XWEbOW2HrLfl6NnD
 FKiCBZleiMTt5W+NRuvyMC8L/sOPkX8=
X-Proofpoint-GUID: fpYfyP6CrbfbMGXLwQ2B2j_PywxFbBM2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfX54lV84jSYbYG
 ZYXjihWuZI242PhLdW3v4afrI+TpKtMPEcv5rXLsRdp51WnhNNxfE/BG7za8JAsp40jaBJLzZzu
 9i5eVsUXNfguL2W0IFXaap6hWRiz2peQppA6Wjq0/CL2FYQHsR0HaRWFDQUcQx08VC3laz2EBEk
 moy//dIQpaVa4cfVXWJGaKxq22RIzmJFZWw3ewIjBpl4lkwZTLUZ86FVz/JMQV+lVKFskhZFG4a
 /SMEsvqXhFgl7o1J+P5sHSht+FXilzMHthi/GhMp9qlpt+900/rPZBxxLDrFB2BkuZN6QYMEY0P
 tkrfw5C7DUggTBwnXqotNEEPmvTjoXGTZcUuJcM/usK4FqHv6se5p9GTrr0Qr89Hl6v13Ef0IO/
 aP9qnpHC7Lj7sq4ArjUwWc2FmGLesAUgzp9aYyiIHqSFTkEvOI2/BnPrfwDk1JOp5Vgixbx8dtZ
 20aNnrvDFZSG1dczADQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 phishscore=0 clxscore=1015 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100124

sg_nents_for_len() returns -EINVAL if the supplied scatterlist is
shorter than the requested length.

Add explicit checks after each sg_nents_for_len() call in DTHEv2 AES
driver.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index aeccc235cb667..bc3591ec58a1c 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -354,6 +354,11 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
 	u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
+	if (src_nents < 0 || dst_nents < 0) {
+		ret = -EINVAL;
+		goto aes_inval_nent_err;
+	}
+
 	aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
 	writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
 
@@ -510,6 +515,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (ret == -ENOMEM)
 		ret = dthe_aes_do_fallback(req);
 
+aes_inval_nent_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
-- 
2.34.1

