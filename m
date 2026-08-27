Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F46E43BDA0;
	Thu, 27 Aug 2026 10:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787828341; cv=fail; b=ulmLmn+3PKQ7YNizmHI7juOPlGyGymjMgS12NZNDMiT3DieHNetmGKoXmyJjGOXnO/4O/kFkx97fcncsR/Ux4xy6VFsNievB913sFpklrkXP6J4Hxgawf9ERvuzhm6lWjCaAHZFmz9zU0JJiMYfxFXfRxgYGld4IYinG2ZArb1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787828341; c=relaxed/simple;
	bh=zsXxnyFtUFm+ltsR0elmkXSnlJzLQBqFYrZ/YLzZCSM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HcjaA8O/x2PsNO0nI+xlvndsPveZn5MgKH33p4h7ijbJcfZZezUQ9bLP4LximloC7rezRUNBa0JeKt3kP3NKSIMJrkfUAtn5jxc3RM0fJw/HGp90enBYU3cHnJM7lVGfDR5iY1gVHRtVODYV4rqVoE1BvTFIS9G0IlvwUD1YL34=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=ZeHD7v4c; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=YU5+QbUe; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="ZeHD7v4c";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="YU5+QbUe"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 67R9Gvuf1734792;
	Thu, 27 Aug 2026 05:58:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=TWCCGasCg9LijBnwau2Mn443Y9RHfyLftPFqNAVUD
	nI=; b=ZeHD7v4cDRnnFeLNVAL9zJbA7f7GMDQ7SuoQsSJ5I9VM5JDnb2NyYTawN
	N2md4OtvUn2zwoKolSkpmldnccTlTl6ykRncozcP7wu7maaLImofLIQRo8MwULsd
	yA4UG+TXvH2nhgvPM4eYA2EUEAUM6XMaO4j6nWTrzohKSuJmKQhNoXWa946vHIJt
	fhXg9m5n78JRBIcSQT4+1suojYY7GP52Twf4qpe6oCEFJySlYbJtY5x4J4ZBFr+B
	P4ckceulN1ct1KGmjHrQOPO7uYu/dwbZnXBbA8RhXyyqcncR5nwqR07C6A8CBNfp
	yODy2HqkQTv/jqdlhEJ1mxy0Rns8Q==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011006.outbound.protection.outlook.com [52.101.62.6])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gad8sa1gw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 05:58:54 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tRYuqn/7Ib743CyqA0voeCT4GsB9NFOK0/G0ku5FIg2KjeeGo7wX953sydgPzPQBC0ahmEAK3cyw8cT+pZlbRmeodDCdAcZmvTQeT2SbexPxz7WILXiuwcVK1JzkJE9OZCkckIIPR/6eLWt4JicHb/zlMGr2B0Fy9M3hnkQ4NguOyZdpiwpuH4/ymt+K3pYwYC4ckedQbAvo3QHx+HvcfpNHb4dJ4mNzHEqehSBe9Nxj6zeq1YcyrHnb57fJfyMcC8EnhZ3nb2oma0CKjYpLBgxtcRDWIo/b1vDUh0insYzHuenSQ3MIP6JTZrWzmDsOfuz52MeTZnU9NOYJHdABMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWCCGasCg9LijBnwau2Mn443Y9RHfyLftPFqNAVUDnI=;
 b=UFw8wQEw/erPsw/fZZ206a6mB5sxcNXm5eIDPQlaY8nNER/S7MIaI0E9sakWZ8AqQMoUv1P2kLOtNqVbkwUSB8ShRFHjH8Np35w2fX9VIXxBv/W8eGr2EXThssC0uKgIciBfWHdHK7KEZqrdoTNyXS9HYYBD7jqHG/JL5omuMOyTYTpURAoz5WG3xnqsPuN5q/lOlRaxk+ph17aYWFSToS4PWFnhoJ2M68yAuJojeLJZZ/a+qrU0loShwx2D4l3bG1ucEGekmvtxSwDHzel09l9ApDpG2L1EXcF4RxPtDmJsrxqyYtaudarOYc1OYemxV2O1aHB6ja2moZL3XO8lmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWCCGasCg9LijBnwau2Mn443Y9RHfyLftPFqNAVUDnI=;
 b=YU5+QbUeNsw2h73/Bw0KOEIHS5+3qd/sXN9DHau1ov34wPn+pAY1JgOHNCOfYnrU+lLPLb96tY7YTfvLLAhwPULCq0Ak/CfMOTfNfrpxwFSEkTNg/bM4voQSaT9YTi//IL1AawIJtIwkxHKS9iZpXvFXqgnTZqpc4FsY63H4xEA=
Received: from CH2PR14CA0027.namprd14.prod.outlook.com (2603:10b6:610:60::37)
 by SJ0PR10MB4589.namprd10.prod.outlook.com (2603:10b6:a03:2d0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.8; Thu, 27 Aug
 2026 10:58:52 +0000
Received: from CH1PEPF0000A346.namprd04.prod.outlook.com
 (2603:10b6:610:60:cafe::5c) by CH2PR14CA0027.outlook.office365.com
 (2603:10b6:610:60::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 10:58:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH1PEPF0000A346.mail.protection.outlook.com (10.167.244.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 27 Aug 2026 10:58:50 +0000
Received: from DFLE203.ent.ti.com (10.64.6.61) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 05:58:26 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 05:58:25 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 05:58:25 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RAwOoF694530;
	Thu, 27 Aug 2026 05:58:25 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Mert Seftali <mertsftl@gmail.com>, Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, kernel test robot <lkp@intel.com>,
        "Dan
 Carpenter" <error27@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
Date: Thu, 27 Aug 2026 16:27:07 +0530
Message-ID: <20260827105711.527182-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827105711.527182-1-t-pratham@ti.com>
References: <20260827105711.527182-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A346:EE_|SJ0PR10MB4589:EE_
X-MS-Office365-Filtering-Correlation-Id: fe74402a-d976-4242-9b14-08df042a2d52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|10067099003|18002099003|22082099003|56012099006|13003099007;
X-Microsoft-Antispam-Message-Info:
	9BpNISv4lWhLe0WBDRLhK81oRSxKYr/4VLaNvX6JUIY0wSe2sIu7ofgyFn5RH5VbX0JNQEfPKrD4IzpDxbBxA0IsuYTrUBZiLC1UniupyU3dAvozH5RZfPVoG3BR1XwSmKJexnTfn4m49i5xjQPmrwOMB8lf83Hdz2qFZpnoLu7WsOiIGLTfjX/DDTde59Bo6+hvxZTKqgEpQ/5X1J7/xe2oIriJ96x759wDf556seQooQIcJlLHet295jRDnL9NpZrszvAk7cw0qgvAuOSZxzusiCBaGIzfLWe+/p8QAPPtkRSmv0c3ZXW48WY1lemsQO6bPf5xaOBSKBZH2mQdHrnehAOvY3r04k0bYtHwHA+6HTtnokaUruiPP70aNdTiz12QsDn9zYYMeB4WV9hN03ceIWUo/hZ/ydY2Nc6gv+osmJJ17rlbfhJYGILKOgHC0Pdy11/owxkrT2yZiwifqpLtg93eSkIRxO3QdXvBsIdeHyA1MkUUOHfUyVaRoiAg9YNMLbxp8QpTb31JdDze2VUIW0t3URcBU4WuInHKUNuEh9E6Z+MSg6z8YI/JsxAsHprvZjTz0csAPEW8HUku60QA28sZj+zTC6ZgpQBtLL/zmjigtMcNQ5dhga5K+VbtTr0kzz872NoD5YaqwuvhVg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	42KwpKHZSofnlnxmUt9agbzho2DzNoZm3XdlhpJLctRiZy+opOk24CATUXQ0nwGpWpdD7y8BoADc/6GDN8cPytUCrKFUHigsW9PVnyUUv351E9aifYe0cEAzOWSX+6iWGljOZfQGiM8ZomdAvFyd6lqPjSbEzyJ461UL6tm1Ry/R6We4z7y0F3+cFWiG2vdDTMsNTFwvTxDcV1H3sGx8PUoMAWJMmhLEcRcVWDAspVxlqfGSEuGXZ6M8O0fy9PODSGyULlAvcdGNvD4gWh2ihTY07K7X0/uz5vlWDZmfnEXHQlVGo+YsUfaBshp5NWqxPuZg3ZwUtiKcrp1WLg7/qUxwV7Lm4qiM2+Rp/QejPMIeYstQPZ0QzYwrrCJ6JXTvdczgzUHC8UTiRtX8dCJP3W+w5Ps9hgWTT+4VQEd/nFjgE0A5pZtmI1xhvjqdh0N7
X-Exchange-RoutingPolicyChecked:
	mkyqGEJ3Y8AR43B9oJLTv8gFzNfQWqSFfPLl4UgQXXvHPbQAg6eqbPP7F1e75joF48c6W2y6QSFqd5BNYW9KyABWYopZreUlvR6+TfGKcscLkUzaJ54fFR/bEaxDLgOWelNL3GjLnlQNq+hDdcm487tCou/xoOiGrmeWJaUcOLwE6eeqQGRot0jho7lvEafLjZJGlET+AZwc4sXQPLWhhGo1F7fC4ttVRhPYFtAW1Il5Fm5VmrNNXmwvTznUjNQjAFqxLbgcFSF5s/KvlnqBBkDIQpYmAkat2m2+1+nA9zWZvdXOaf+LAfpbT6kKD0H8uJYfdx1NO4bJG4FdYoGDgg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 10:58:50.4519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe74402a-d976-4242-9b14-08df042a2d52
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A346.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4589
X-Proofpoint-ORIG-GUID: PH8CDQnA7biZSa-N_Z-3oF5rrQ7Oywzt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA5MCBTYWx0ZWRfX9lnBjKoq8URz
 W0TSWLpixzrUah4w6dDpOCKMbZHYoqbHmi0eQ6S6T2AC4e936W6eDk/0TnV77b1SCZly1e5lzSG
 n3kAy73Skrsf5w90q6l5jEx0sB7TPRePBJjaYwJQE8qF0wnCJuUJa+K7HMJxYOKf1uOVj+Ap8RS
 Qw/uASuLcf5vMDTzOt+jAJH1Q2CaKoeQqe/Ex8Cud8snFjYR80SZU3zpnulGV6Op1YHJmfrx0Y5
 qt7/7Y/uObzsznu/knCxfn+tA08pB7o50tCh9BiSzNXklziB5Si5Y4+Eyxm0OWtOtlyL9NXr7nM
 mX08JJejr0SkOu2q2ILXM6DkaF2o2XR19OveazDQrvwlEHRknV7ZeBh6aedjeSI/UC2k1VebY/y
 qoOHmWbLy2qNuFEDM4GvI+rf8Xxp+E8SkkoUVn+SuHPNI/tSLML2/OTwbqilkQO06lUR+wssEuS
 W8YqpOpDfweTn2dgGFA==
X-Authority-Analysis: v=2.4 cv=TJ11jVla c=1 sm=1 tr=0 ts=6a90186e cx=c_pps
 a=OmH7RzXgq2BZ7BLjxN5ZDg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=sozttTNsAAAA:8
 a=wJbimtiaZSj2K1SRI8oA:9
X-Proofpoint-GUID: PH8CDQnA7biZSa-N_Z-3oF5rrQ7Oywzt
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA5MCBTYWx0ZWRfX7iGl5cO8apWY
 LRwEn+w/KmCaIsV9NL7uqM3TNRSFL7Au1jx9owfpdIIpjrPD3Ndb5ieZuyNJPADGC/TFpkxap3g
 PwHFUvjBdP0LxdAvW1NhVrUEtiofaKc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_04,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270090

From: Mert Seftali <mertsftl@gmail.com>

dthe_get_dev() fetches a device from the global device list with
list_first_entry() and then checks the result for NULL. However,
list_first_entry() never returns NULL: on an empty list it returns a
bogus pointer computed from the list head. The NULL check is therefore
dead code, and an empty list would be treated as a valid entry and
moved around as if it were a real device.

Use list_first_entry_or_null() so the existing NULL check works as
intended and an empty list is handled gracefully.

[pratham:]
Add null checks on dev_data in callers of dthe_get_dev().

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202606111933.69GGTKxr-lkp@intel.com/
Signed-off-by: Mert Seftali <mertsftl@gmail.com>
Co-developed-by: T Pratham <t-pratham@ti.com>
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 9 +++++++++
 drivers/crypto/ti/dthev2-common.c | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index eb5cd902dfb59..c025b08c49930 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -112,6 +112,9 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -124,6 +127,9 @@ static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -572,6 +578,9 @@ static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 
 	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index a2ad79bec105a..cc02449382673 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -40,7 +40,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 		return ctx->dev_data;
 
 	spin_lock_bh(&dthe_dev_list.lock);
-	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
+	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
 	spin_unlock_bh(&dthe_dev_list.lock);
-- 
2.34.1

