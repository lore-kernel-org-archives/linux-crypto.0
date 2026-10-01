Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30A24C10C6;
	Thu,  1 Oct 2026 08:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844822; cv=fail; b=p2/tIEV0DiHe5r/0PHo5gghEL3BkgpmeqD2QZu1BAdKTsepHzKjEBNbQwKKjQSFL39h0v1KsjIWWINiWEUx1GVhXOk/F1dsx8mMpEP0tl37cB0I2LY2AZBSsU3YXc5+B0mOtiDJlg0mWvT0TdlYWq1zQtE5VI31VYinrUQTIxPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844822; c=relaxed/simple;
	bh=id1XHPnmhNbRL2J3dY73MCP04kxkLhJ6NwjPKg2WrXs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FMrBTJXnp+/IxwYrxI2/bL90E11+UO6fQvdDYq3V/0mmV/GHDf1RzHayvhYUepUkNssfnQmLrhyUEUyLcASa/2IqNVEvi/kRuOVM1GaXZLhjs6GVtQV6ertdr1tKSTV+59pdLTfqRKtmr+lXSs9lc9RCEALXXskw72vFBUXrRlI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=pysUNrbL; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=sEwtKr1D; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="pysUNrbL";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="sEwtKr1D"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691710Ir1294534;
	Thu, 1 Oct 2026 03:53:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=vCHq+InZ8p6bDRhkvfnvEAa4i7X2vAXzwTY6dx/KN
	lA=; b=pysUNrbL0D/pVqF3Dsemm95x2kkHGu37+ZpRkjHHXmrq3Wetf3k4pGrhs
	1WM5sCs74YSVUc0fYHZ+HCMkS1zfuycos437yJxIl9/56l/XhuIzuXa9HriSPkli
	xcEIMFf3XOgEKG4bfmE0/cjbvTk5yjM8Ih2KoGfqkwZOVKY68QiGIsd2j4MZ5Qb7
	5kpy4HS83n0QZTi1d2+Lvd3rxGsU9Zdq7VWlz3etfE1A6d+WdwG/anerW1DufiQZ
	FBVNxzizRgv4a2zI3uTCEih7sq4wYmdTqcNbsCNRmQyDYe5LZ+qi06Cdt9myYBHK
	68dKAUnbb6sp66rFhP8z+Kmt0gxSw==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010018.outbound.protection.outlook.com [40.93.198.18])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h1eur9t32-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:53:37 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pq+cquJ7oR4eh7zpN/Q3EnOuEb/v2+kHVdXPUCt1CprD4Fq5pHVZyRNsTNn1QIle7JmAKaC04z4Dm+tXAsiQGzPajKGLvLn5oxJnyC4R4Jp6SYHItHE/uHZrsR9uLX/ID1pjVR8+Fd2qej06IJOefxPn3MSdjMtWDZ9ILvm/uIaDYOQf+PicljAGmhqCBvejXjlkliFyUgzRglzdQENLPPP56r7Df+bMKaaV+EFKPKmovnlgBPa9phXIpkhbs8jhXyQ06ttrgXtqSTCJtiW5laTBwGETkhul45TWaajQh6545CPHZop7Pgy++7p30X2LHtB6hKfRu6LhVeT9465WTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCHq+InZ8p6bDRhkvfnvEAa4i7X2vAXzwTY6dx/KNlA=;
 b=bOXPmKN588/IWiFpyhaZDXyzOnxZsDgC5b4tBgPjGOo8KGyrLtYmFtm+RhCbPqj5vZfFRdBrShG4S/Esh0EqZjGpicjhw2rBto8TrackjjbRAQ5sDeOXCg0+C91gTkPXxobtOIFmzG91PDkvQ2aFkXaaEqMyffc6g57kgajUol63ehRjxircIZfPpLajaRe/ULp2kK4u5YXkLuy3fhebIIcluNMdoQhefUX0A4r8jkb+xPwHQ3O96RT4EVSNWjSb2Atwwb82EQaQgtEuDmDPi2cFFcvX1tGoN/gVEmdSjXgX6hj0W8ld9EKPNmws2KIUxaT8DD9tgB/VlwekM6xQGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCHq+InZ8p6bDRhkvfnvEAa4i7X2vAXzwTY6dx/KNlA=;
 b=sEwtKr1Drj4vgu27HJInCJRnrrJP1PO3mOMuS/MZh37uFdt5dXQUdev2Xqr0rzmvheLjSX4iLij/f1k5n5l5VLeZRwZ0fuNoe2+eh6EZTz8KASzCZ5ibHqnbSfItQhoiayNTeC7GE/J92nLQVYRQx5FCXSWm61RDyOC3VQPY9lM=
Received: from CH5P223CA0014.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::16)
 by PH0PR10MB4789.namprd10.prod.outlook.com (2603:10b6:510:3c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Thu, 1 Oct 2026
 08:53:34 +0000
Received: from BN2PEPF000044A2.namprd02.prod.outlook.com
 (2603:10b6:610:1f3:cafe::22) by CH5P223CA0014.outlook.office365.com
 (2603:10b6:610:1f3::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.17 via Frontend Transport; Thu, 1
 Oct 2026 08:53:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BN2PEPF000044A2.mail.protection.outlook.com (10.167.243.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:53:32 +0000
Received: from DFLE207.ent.ti.com (10.64.6.65) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:52:54 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:52:54 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:52:54 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918qrYs1594745;
	Thu, 1 Oct 2026 03:52:54 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 02/15] crypto: ti - Fix spinlock inconsistency in DTHEv2
Date: Thu, 1 Oct 2026 14:22:32 +0530
Message-ID: <20261001085245.2922974-3-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A2:EE_|PH0PR10MB4789:EE_
X-MS-Office365-Filtering-Correlation-Id: 066fc2f8-3a48-499a-4a07-08df1f9978ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|376014|1800799024|82310400026|10067099003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qMGMwVWw2n2ZWIAovgBRuP/7dAsE98zICQdBnL3g/A5G+brR4+wq4j/OJShMFB0uRO6NzfF0ZZUozgkjox8nEslPqOYo83ECzcDMim/T/F5ZO8FdkE5zv1SerCoucWD5zcOFs/pTfkWfqvUssy1zRmAr/Di/Tn/yheoBKprjkO+LeGf//0mvqlh2pOPiTBmS4HDdcFJf8OyOex28wRQ9YLOPX98MCb9Zj4DC1DsmqYpja+cJ0k2cBIjLp8MpXmaHGA/NSvigmOlzLIMQi9H+YtsvUiHASxuJqQQxXyiKiII7IejYenxCJiI4f00BIR7DILrLF2XwXPIe9A3EWXceck9QV+RdUd/EGPL4hNQnIWYI4+AuiLbDoekGOHa0lZpDRRhJM6AA0pyc3rlAEsRki+xmi90cRXjz2d8iZ8obC6USDe/IdNPKqKmwoVMJpnwLMUqfPnKoZL6EfRHqbxqNMZwyJUsNbpicIosV7ndEfAg0aJGhBQMmMp5EPYHRfePN53LUDf1P8Vpu6FB8OceNlDbq5DiUGiKzGpKtNi9UCtglVtA6VBWdtPGGmnPVElV2Q/pod7DGYCKxf1++G9koko90ceUdqA7+14IzXFlTSDAmhz/f49E70uthCuXlBbWMegS6DQ/tUnqncVrHouoF4+wpJE7hnzhIx1OsAIeGY1kVEAR2HkCTcEZz/MDQdKZwjI6Lwzu71ZtCb1mXeMqiPQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(376014)(1800799024)(82310400026)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Dt1JBMaBlo2gE5qpijAgyHSKT2lGW5TuFIm/QXLIY1+NHWBnYWV6E6IsM4N6B/pppPwzwpxIs6AhIO+Z5mCFhrGk5CwbGVGl2szA78h0/Lyym4pZPpMHuJ6deVJGnM3Q9vG+E9ud3LVbV4i0Xo8k+5LO7pus0xUQ0juct3OxdMOyoNvkdgF4ypp0hSFtW6giBXRy8zs8cy5SXOQFIV4igcM1AT00Zwwr+Yta5wTdTOQzfVWRVz033XhIPf7Hm9KR/1EBE1YaqHpgTUvvdBOTnVZYRSHd59QzkfI5GowAPnZ1mUWGSC4l3UaDNobiMUFcpjQXKAchnzmqJ5iLIy/DO+pel2oBrhbUuDWoJu4vQGzi+E++bn6iX6WwrJMGFKnCuIBHRAOgqbzS49nq6+fCNgWIJXoiN6sKUNgbWVbbxpR6rnGvd0o5Jbk3lQ++4six
X-Exchange-RoutingPolicyChecked:
	1vVXS0vsR1jLP/8NtgdVXdo7liqYH7VbcxZ1Qb6V1FNG6oxEM8yfFOlK/AczMYy/gDIjBJxd6aJuj6PdQJ2sCfzmpByWsRPCzgI/+eorg8wmKqiVXyzh244yxwYCgzSNNJWSLlmMYy3vZVRRTmyMljv8tn1VkUs2m3QWVS1dISLyddE+EJHTc+hJT/v3XO+sXeilktsmrgK8yXgKsIcBh1s4qp4oFzkRqVvcKgVpJi5QHfmv3zodNKrjWTImTsayvu51mSbA/M4xEu6fNYXY/ja5SR9ctXVo4A2wv7xyfGYQnxuWNVwvTxOZnTSP0ni/Kg33Km4NbgqRAYZj6JVUgQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:53:32.3665
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 066fc2f8-3a48-499a-4a07-08df1f9978ac
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-Proofpoint-GUID: eCPqj10OuLmV3VK_22DBRX0gRqpaRFba
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX6v857jsKf4Jd
 w+GJbG+pN/3sTmczVihK/aTKg38kWDxheM7ROBboSaN2d3zv1IOAhz+DqsUTSBEAdBBLmvfSgci
 qshEFiQB+b9opZr7fCutSTI3qfXO+foD2NLaJFpAfTH2ImuIZULe980dZAk7uJb2an5xMMHLX1T
 EQulPSRbQKBNjKGnIERTh6PPtMkMYYU4BhDIWCS8SNUgKc5PRHEWsx2tjkjFG1lnVNLlpPNPMME
 KP+71rnBB/A8L3L4fFGuhXQbEuS39soSSNBbzWkAhJWPus/2EzUvj3e8Mf/Tw23nDm3HHQDeihL
 iBqqr+G664XkC542Btk+Na/nevD1reGH2P1xq0lRsqwzO5IHl/9ATemvvNxOT+zW8bjceQbw9Mk
 5FdUiaUI2MmYKWXnrFzZRm+37++Ok7xFE4DLYpN6gn2AvClLpoEO5aYt9TKOpYFSUSWvd7xM6KK
 1re4qQdRkUjmEkIm0/Q==
X-Authority-Analysis: v=2.4 cv=KvzYSmWN c=1 sm=1 tr=0 ts=6abe1f91 cx=c_pps
 a=TKURuYQIacZDyiG+Utq8vw==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=HiAi_RwYt-Wiez6k4EgA:9
X-Proofpoint-ORIG-GUID: eCPqj10OuLmV3VK_22DBRX0gRqpaRFba
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfXzTuhDitSQSjK
 QRHhq8eKDzIp0dP5cC///ZJoT6A1rXnLWQvHOU8Ag70I0L2vkdxGBmxyQJKWdH0G+Uk5ybxhREK
 ZIhQrlQWSgPWpLX/wt4pilgT3avBbpo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010035

Probe and remove functions use spin_(un)lock for acquiring the
dthe_dev_list.lock. But dthe_get_dev uses the bh variant. Change
spin_(un)lock to spin_(un)lock_bh to avoid potential deadlock when a
softIRQ process tries to acquire the already held lock.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index cb4b8b38a5ec8..8f8c4a93af616 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -154,9 +154,9 @@ static int dthe_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dev_data);
 
-	spin_lock(&dthe_dev_list.lock);
+	spin_lock_bh(&dthe_dev_list.lock);
 	list_add(&dev_data->list, &dthe_dev_list.dev_list);
-	spin_unlock(&dthe_dev_list.lock);
+	spin_unlock_bh(&dthe_dev_list.lock);
 
 	ret = dthe_dma_init(dev_data);
 	if (ret)
@@ -189,9 +189,9 @@ static int dthe_probe(struct platform_device *pdev)
 	dma_release_channel(dev_data->dma_aes_tx);
 	dma_release_channel(dev_data->dma_sha_tx);
 probe_dma_err:
-	spin_lock(&dthe_dev_list.lock);
+	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
-	spin_unlock(&dthe_dev_list.lock);
+	spin_unlock_bh(&dthe_dev_list.lock);
 
 	return ret;
 }
@@ -200,9 +200,9 @@ static void dthe_remove(struct platform_device *pdev)
 {
 	struct dthe_data *dev_data = platform_get_drvdata(pdev);
 
-	spin_lock(&dthe_dev_list.lock);
+	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
-	spin_unlock(&dthe_dev_list.lock);
+	spin_unlock_bh(&dthe_dev_list.lock);
 
 	dthe_unregister_algs();
 
-- 
2.34.1

