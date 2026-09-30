Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B194FD780;
	Wed, 30 Sep 2026 13:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773231; cv=fail; b=uzw8C0vMqPrlrS19mEl/8lNNQL6m3/yxYTI2fZMaS0/pM/EkAEUS4MAZB65OUqZmVv6XnF68a5ck3w+PUNno1ceiE1h6Rd/azD67Qinp0Ql+aEwn6xB5fg9/4wPr5JiYmwxOdr51Vv/edd9YSmFZQMJ8mFr9uOaN1h2xY2HlpJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773231; c=relaxed/simple;
	bh=oEievuPIK77sfBoMZW0FxLpzHM0QEpV0zn6Xmu5kz+g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jm5L30n+sN/gIYlzDqwqTzROYs+bShhyAFGwv19V4XKW43oc+A6aE5jHPUhd26r5gI1EUdK3+jxfDVy9VusqEX0PmnBhNSFn4Kzgka9Qs7y0D56gkzjSEwsuW0hVLaGSHJObPCICsNYFLgrUrxZDILnnJwgQUyHJWvwZaGwwOBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=O3ZL3Rz+; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=Pl+yz0Dd; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="O3ZL3Rz+";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="Pl+yz0Dd"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB69ge2715437;
	Wed, 30 Sep 2026 08:00:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9i
	nM=; b=O3ZL3Rz+6SwZvUVaJO6FjGPwZRpLMAnBlrlWv0J1GMr3edEVKHXKedF4e
	CQ57mARyF4aPwhXOsGuwN25yjdum7dwNoUUK6UoU7ce6AVClupUoBDvspzlWO8NE
	iep3Rtdk/9a4vh1n3ZbSKKfd2X+go1d1gZJUyjtxE3yODgTZHQ0PlOXqepYpgSpL
	zF1er5pgbOPKW5sMdp0rdt8kbmLssPWh2+tcmTrrNZqrSX+661FPzw4zMN2Y8lNe
	AO9sJ2er8Ny36cf1vlZ1ECNd9lDR96UDsD2gCHeQWX1e01yy5b33VFO5KBnV0OMI
	2YJywd5298dgbOOKHDB1jdBgRfc2w==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011038.outbound.protection.outlook.com [40.107.208.38])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0m9fdb3g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 08:00:15 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d67Jo2gxmxAHNM6jNHCjTkZlh8LFqWE5V96tHILl03b2KuDRIgDOt6u7SQmMo74Fpv0bXAXMiBPAJQh3YluwxHkni54TubXUYObFrQ//dp3d8KgC3AcVwb3f/e3EJou4BG9KFeSnQAGxIhuxvyIS/8eAIc60aZG2PTAufcih62t7vhyq7sy+oKfIQMpsS14nTjZKzuHG3eVNW4ylBEfBMy5RVOI7WAMwomLREqeMKu6GqWfF/sH3c7S/9ngsvYhqKvQsYIWgDbBs+D4YryRx9vWi3gijqAhy4wIWSBBdtywdZCy5nb3qT7/jUhvwcc18yCrbVNqEnVyZ5i0B3flUqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9inM=;
 b=R/oE/Y2SQZxYzkS0gjffV7Nb7EjT/4Y719FhvAsoFwjrgMvGcI6Dzd9pOvA/cyejdNq3Awmk64WMwWhE4P8nCtvOvKcDIewqyNTScNNvYHfwX10W8dJngxjRX2MrBhTvl98DRNHZJHwSg4e+oWCfPwUWwr2lJ7Ggrn9kdBOHP+oPRjpQiEOEzoCqEL38drGgn3cTc/8LJFs3mKzOaShjUKLzzGx25vsFXP+kaPeydQVW8p7BKuSWUhTj/j/MzRjdyjqEVfcZsY2RkB1v3luaacGSBCndz6HXbsL6VeCcBfvTE3pFOIJXHraMFKJWz8B+ISUah6o9t3SHH208m8Gh3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=te8/Mzw9RHyzNtoGLCjV7WKPoR3c0V5g+TIMjgC9inM=;
 b=Pl+yz0DdIwQV/UAUmjtIESwbEOMXtPvNA9Umb3v2XQwKkhfb6LmQRbP18e+jLqKMh5xJ1/RnWRj7G4IaAchy5/Hd0tiCJX2j2XbjUudckwEW/I2A2B1uEqN7HUr2ypn4Fi0xh7RjX21aJTYZVtK3iiXUmGlMnSfK+7zbb2tqu+Y=
Received: from BN0PR04CA0148.namprd04.prod.outlook.com (2603:10b6:408:ed::33)
 by SJ0PR10MB4621.namprd10.prod.outlook.com (2603:10b6:a03:2d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Wed, 30 Sep
 2026 13:00:10 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:408:ed:cafe::12) by BN0PR04CA0148.outlook.office365.com
 (2603:10b6:408:ed::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 13:00:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 13:00:09 +0000
Received: from DFLE202.ent.ti.com (10.64.6.60) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:28 -0500
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:28 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:28 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCxRkD3153948;
	Wed, 30 Sep 2026 07:59:28 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 08/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
Date: Wed, 30 Sep 2026 18:28:52 +0530
Message-ID: <20260930125859.1749849-9-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930125859.1749849-1-t-pratham@ti.com>
References: <20260930125859.1749849-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|SJ0PR10MB4621:EE_
X-MS-Office365-Filtering-Correlation-Id: e4bd8450-9366-4a65-8850-08df1ef2c220
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|1800799024|376014|18002099003|22082099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	wLwqJP/MLJ3aBrl0lY4MNCMF7hnG5q67HAiVce8OO6GItJc5hN9rzf/YSRK8kBLnZgWM6InTpmK0RscXdmXG1qxOowATeKHRRiaJp1fiLqHaekYOjQMIRX24t55UPOZwwt4QMgybV5zOqpJPBp01PrS+PT77g3/y2sqonyTGp4ikZWWYGfeCvoMW/3x/f9ikToirZ1prA/dQ/hRcdCmsorcrwppH2j2ayru3o7beoKfsJRD6YNpyEVOTHjHbtVaG429spqM391iKQnbWnWuxUl/goeC7QfVEOxSptm7hBwXWblh/kCrb0ZxETEFvjRlpYiQ682DL9Y5ju0f97tXasQAgxgB2fMrdphWzBsLTkDR5TnD2NLrrrBYPXC/R0WiYATojtokpLkRNt8JSLNjQuAdrNeGQjR50+uMhYUO9dBtoIe+XFvxSEPwmgR+SpjPKDJGwWBf/RcfyPH4DOt43MOXfYAuUBZZeFV+QiABUlI9aogy8syOUdIYhjXqnWbuKWLbiAym/dys0BS/7T5l9iJuYkCHZjtdCOBgIsiKrQBrgq3lg9aFBd5hfASJhKjO3DbN3p6zLDN4natvIFYJPNsYFzLWHMBpeLIolb4DgRWRBisnKpN6OOc/M2eyamLMBXoBLkN8q/ZWY3++bDdeeEQkkjLakJo8RZnQ1APnfIWYjyYfPyi2xGMm0UtUWn2F9I5vPoCBzBVKzRm8gZ92MWQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(1800799024)(376014)(18002099003)(22082099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jO9X3Sp8DwCY3KulfHNG3XRvpUOHScVi/0j08OaCp/HijICmWm5F8Kkr6aX6SNzfcRiKnqFiAGg53tZ+WbjNo4hph8hostOfSxJcTqG60+GM8+H0i3uOR6bP8PsuaQEVOWgUoS2g14av+udC+qFmcEZhmSDO9eD3jhsIxDp5m+iudn/QMIMB51zmwEN4pWjQ0bbsOcl/e0AXyQstaZRst8PCBqitIUwmv9jCE+tWC4Uz6GZTxx2zZnT3cNdAEmXjMv2xqW+6Ixs9qGMZiW62+8rVK0OHP/5PKXycbdr2hlS2TRXIWaFMraIXkoGavVvDcK97sS5dcVIB/SGCgCnK/wOnz8TtLa/bjosm673v0nzsWKHRNl+VITu1ESycR4ZtnZRiQApiQflKUrFcGpE+Ya2u1x2BG/3u8OOb7UwBIGRAusOtzzNsWbofrrNj5oX/
X-Exchange-RoutingPolicyChecked:
	GwTy+/mW+cYlG9ZMecR/wJ7ltPSqLHJig1xMg/qMQhSKQYkpxrHrFYbZJx38nTED0lTT/ZnHknEU6+xxQnBlfYAqOVzcfR64DX8m4kZb5E1Feie0mDPc6LJBBm1rP3GiLZJl1HtbrrzsG3tv7dNn8U9jri7InEvwJCF4xPT2BFFwfQHSYaIo/+kjGagUFRqB6f30ak0Ugk82NrHC1560uzPDsKI9vIpmkTDPr7UDzZQKBBzzmJuvmxhDqKH0wLsZ1Jl3Bou3y21mgI6pDKELx0OKoLqud9uXTxM570/F5PThBx7uds67iF4eIJCO/P8iIA80qrCfIWL2pvcRtKx69g==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 13:00:09.6525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4bd8450-9366-4a65-8850-08df1ef2c220
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4621
X-Authority-Analysis: v=2.4 cv=VfRir1p9 c=1 sm=1 tr=0 ts=6abd07df cx=c_pps
 a=uRUxjcjQKWf8PwUSRA6o1w==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=sozttTNsAAAA:8 a=wrH6CD59uMa574BPOq8A:9
X-Proofpoint-GUID: 1VtQP7RtwxVMCosk1oqu-sNjPvRCVLV9
X-Proofpoint-ORIG-GUID: 1VtQP7RtwxVMCosk1oqu-sNjPvRCVLV9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfXzWG4jPlV2x4f
 XrIMIBzOJgJudFLecMlfHOzKbbIqd5sKqyPD+rlOYADrRmpI35mzbsI3vhACopc3VHhg0hyjJkS
 El4aEKusR8/EdmCqIN9hCIjEul4jGUeCT5Rr5gnaTVPBp6y31Iei9N5X7iFZO9C/7pTDQavqiRq
 eaTt0UjU6a6wkFUzwbci6FBQ2Erq6bSGpN8IKRK25mbAqK7B0jAgLhaS+hEvr3LQnyVehUtNbg+
 LwockdKMcHgSqj3ZMurPn9EpwNYLS45nMfCehuWcSqkOPb9O0Tzq5Wk922BCO+gHv3QX5so1rIv
 IoZjBGQEUOHE16vRhA8fill+Vgx18G2u+1d4TROcoA7l23iP5ww6a7RXTvey8sjnh0RSKr432Xx
 PKzxCUXGobuPlsKZUGpOGqb+6Zj0x2j+l4pLC2lLeGTlNzPczKGriZz4QenEoHuGPpzIWU557Ea
 1sODTFEXpGIHqLZT59A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX7typp5baVArH
 a5RhmULEliRykKPNGHbbJJ2iuicHt4E4Oxqb+rdaamtgzfPdwNvVq9fVn+5j0PuPMV+F6xYwpCJ
 1NiVHZnWOziuipWgX+4dgHB8rrxZzWk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

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
index 83d964e884086..0447144b77ffe 100644
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
 
@@ -512,6 +517,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (ret == -ENOMEM)
 		ret = dthe_aes_do_fallback(req);
 
+aes_inval_nent_err:
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
-- 
2.34.1

