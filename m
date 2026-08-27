Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C9247426F;
	Thu, 27 Aug 2026 13:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787837081; cv=fail; b=pjJJn/OdIv4HGHo8q90AoyI4Z+NHhuik3tzqNXGO7SOXKbfmtQtJ+vcv1fGdM8a+QWfzgHaF0C9Bd8kgI6yh4FCRvF/uBD2pHs+p+0EpZEo28iN1cSGTaVQho0Ipqbf1IGPdpe0M3SL3wEA68E297UEMpHTzV3GBDIRV2hIu4gQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787837081; c=relaxed/simple;
	bh=SytUeFdB/MKaYKaubrhZRnRz1jmrcwLjp0R6X9UVqZU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M1OyAL81pUeCE7BVsCEmmrmXAfSsUSDcH4Iepk3YEj4OIfkCSHd5O/JJOH56kxaHkGjpAmRWE7n4oGQjyLzYCiu1RXGAXp0/urPt/8UmOXVFct1H9MdYdt/ccRkCcufwXoi8SS7d8jv4yb25yX/2bVs9ElSPryAcCR7dOCRBweM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=J0I0Toi2; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=HID59Hzf; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="J0I0Toi2";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="HID59Hzf"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 67RCA78f2915280;
	Thu, 27 Aug 2026 08:24:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=ys2sjHHwD+AiPU99+X4BPnXwi+/C0iIWiOc5Chq+H
	GE=; b=J0I0Toi2/4hN5fiF84KD6GaMYot/axjGMC96xYAul3R5ekSW7nKHfmt+X
	EA0Hwsor2wTu9t7LuAVIeu1yWPMT4DrgofXSezV4gyrgAJhRaJ8ZGQFdT3FtVq4Z
	w8+eVEROcOdhzZLqlRwxv6ijs4SRqiB++tuWz4BQ6o2jD6IC/Q5selmgFZyMTjZ0
	Ha6D+tPyJ32pKdF1Z2agU4vTR2QwUsWc6jf3uH1aoVqsyWRWNKAB8IAPOdlLmT2g
	VyAHQQBHS0kek1OJhSUDE1fI+829Pkt+UnIpyXmXHEN6+O8Xz7BaH9zHT+mCV4bB
	79KKJ8HXAnfXU9WZfRm4wOatsOdEA==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013061.outbound.protection.outlook.com [40.93.196.61])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gahg39dcw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 08:24:27 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g8dp5Ec7FkzFY63HMShrjbY1QP6bsl9MixIMmFa0+sEncEw9HVHzo0CbjMM73pCjHHwhz1LPqbpFZFH4IgvzDAzTAtTMLu5YXarBBIXyAZyCEJmS0Aqwgn8vSp77e+OAaou7LMFuH59N//bbEXOfE4luvHv6XGBlF6D5TUDFa3Crz/1tYJfYZtYugAnd2d2Tyy0qJdlczyrF3lZemgVSCM8+XDp3DnZqlry9sSsEHBCo1mZBTqm3uK9PQs3rWFTBsr3BeCIcUFjBat8SITseadJFDQugF5IenTb5O7SjZJgP47TBwV5RRGISdQDmKOnEmd23c80vK8XkyWHv0nAmig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ys2sjHHwD+AiPU99+X4BPnXwi+/C0iIWiOc5Chq+HGE=;
 b=u8hnwBVQ6ktgeQ7vvYm1X6ZSOgjA3MQG6pnb47oS6sl1fnygGMe3RXIkNMMhqwhHUcvJb/RfPKBMn1hy5YzWRrDils24V1Do9PZ6uHKsA9L7mhHhjY34dtzK7TI3vOEq25xmQhob5A/FA5g9fWpjDWKxms+tBlr4Pa8oxn4a+EzcSNQA7IeR0AMxfnnUao2c2LwNBQeCtnbb3AjfFjEdiK1cmRXkzqeEPluWDd1iIFhxMh5eDlAfssvKKWC0OG5EOdbWKeSzAhG6QYlpWntBCtLqlVFp3HrJSWeNqZAe3N6rkvgQzzuJwGrMJ1w+lcr5eM1YFRQ+Mjqs/QOOs/Zamw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ys2sjHHwD+AiPU99+X4BPnXwi+/C0iIWiOc5Chq+HGE=;
 b=HID59HzfTHcR6o+PcWjBozJwJUAFcDqJH6cCD9VEMNntnlH/kKSSqKn8ea8cEN+IPZHu7Ja31ZEYNkfPFrHvHXjbyTMqFsQQAIfI3QzSDNmw13r+Q8PmU43m+CXjvDaPiyFkYkTM3H2jOTPSCRAwXMoESvAa4e5XPt2yfvENUWc=
Received: from CH2PR07CA0044.namprd07.prod.outlook.com (2603:10b6:610:5b::18)
 by MW4PR10MB5839.namprd10.prod.outlook.com (2603:10b6:303:18f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Thu, 27 Aug
 2026 13:24:20 +0000
Received: from CH1PEPF0000AD7F.namprd04.prod.outlook.com
 (2603:10b6:610:5b:cafe::5) by CH2PR07CA0044.outlook.office365.com
 (2603:10b6:610:5b::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 13:24:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH1PEPF0000AD7F.mail.protection.outlook.com (10.167.244.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 27 Aug 2026 13:24:19 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:38 -0500
Received: from DFLE201.ent.ti.com (10.64.6.59) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:38 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 08:23:38 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RDNbHl894112;
	Thu, 27 Aug 2026 08:23:38 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/7] crypto: ti - Fix potential memory corruption on highmem pages
Date: Thu, 27 Aug 2026 18:53:14 +0530
Message-ID: <20260827132318.613876-4-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827132318.613876-1-t-pratham@ti.com>
References: <20260827132318.613876-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7F:EE_|MW4PR10MB5839:EE_
X-MS-Office365-Filtering-Correlation-Id: 60b3df83-f248-43a5-e8bb-08df043e8006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|82310400026|23010399003|10067099003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/1+XSWDnLm1WY6TXhRpVXoBPrIk0SUxTeAEjqAldoirVVoFp61deQoB0qhHuLDtwVQuGJVHJbCRwPb+Fiom7LY+mJEO4m9yTNeRNLOb/f40XBxsHFq8A8IGfZ/FVC69CEu9k76XMjr1IZTGSLj9O92awrE6vnqvvgdcFc6XeteV4F9/ZlIDYS4F7haQ0VxkuFrYyIZ4DZ/yVyFNPeEGp5Milr3Vqa9/FdeWx8JQzMJX4YSFCQHaajdrJ5/HGUIn4HOXlD1RIgIw6GKzwIPmSdN7n/4jf3hETEVZ+hb2oTqrNUi1oarEp/caFi+pksR0yS+RgBkXM6hwbh6AQg2Z065GKDifC7sDOu48gU/4y0QGX812lfVYZcH+nvfdo8gqxBmxb9+qvar86CHVxvVgCxgn3Oj5+/bEoybG9Pb+7NSEY1hwnZkMoSCJR575mjUEhKF3+wZ4reKz4jw/X+OXCoaTNkV0fjZulfVHENNBGC2HJmK2Dwt56cNUQrLBF1qcZkC7IA+KyFlMRsa/yho0sYEhmeHgIMaJClXgMYEUCwFxPp0S2+Pa56C0SnR5wIsD7HMyNraGS8ERyml245F011RcSkqfhSwZzxtLSFwS4MzFLNQZEKl8EUoKTYaF+SC6XGrgw9J4cvVsmpuMoaUlJD0REBqsABkiUFLFiCCAvnwOVpvWm7R4l2oeEtn0+rUw7go4GXloyn7TjlsgTWhN46A==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(82310400026)(23010399003)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UCVj/OmHubqLVNJLZ8pYhkx9R2Ek2Y7UmWa+6/4awdbJB12H/5tmp+YCoaDzkyY61gZ5/t20+EEDoR5e0IZy3etL2B17kNqeLRs2l6gKJDHWw5/L1UmDm/JGQdyCdOO8t1UMHK41hKZsYpVixuo5xR+GV3A7cLS6kV3/2tCdXAoxL/XO9pDLYXGhts30TjbefL0VbqQ/GNvhNJeYrJ7r7dHyeJXY7FrgP6U+APjFGvs14NrWoQQmEY3yIXlEmMn1eh09sKsKhuTEMzcMzu7Gw7ZC4GEz1a8Xjm6RhyvJi2fe+fH6CZ2zZ74fo9yrhsTyvXpens1KCUJwmZvoouhi/vNrEKD1P9h+Ou1riJDe0GBYS3N1bJfKd3h7NDvwjubTgJkKCcC8YefdbCg++7rYrHxt7ORrpuxLi3H5kgZIBxTbIg2nkE+hz7S161jTVWiw
X-Exchange-RoutingPolicyChecked:
	ue1MrgJwcf2mEfh0JkMtqEMiSGnlatWKhF8wUyC1a0+UAq+u1V3T59jLkmf25n4uQ6mBlHq4OcxGOLzZr8SioSIzpKJlHvyQU6uzTl4Z91tMmMaa0mj1+sgyCjvtuNklv3D0oJ+Qjto+0Tj1IiLfYH+zoWgSjUnZLuHSug8TNfb0gd40MW5QpSZCCHj91Qzc4gMGhP05Tl0gSMcov32769DWm14aLummcWGBbc3ab/PpnSEwzCXoBwuTFChL/V+mr5URb71FuswFkSflsFTjJpDD7T6JNpQr/HDTGpghTQD7gjVGfcwWwoPSTkzD/KOMJL47H2LdAVkVnflrsJ3w6g==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 13:24:19.1352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60b3df83-f248-43a5-e8bb-08df043e8006
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5839
X-Proofpoint-GUID: cnFE1HMTwP9Ortl8Ns95PjRUnJY_EXh1
X-Authority-Analysis: v=2.4 cv=M4597Sws c=1 sm=1 tr=0 ts=6a903a8b cx=c_pps
 a=DPCWJwWgIuHEo730oqIOaQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=IXP722aH8NCvtdUuCEcA:9
X-Proofpoint-ORIG-GUID: cnFE1HMTwP9Ortl8Ns95PjRUnJY_EXh1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfXzTOQCxLSvy2Z
 WVmuJCkUzUqoRFptft1csYvZHxq8pRg60m3f/J/Dj52rZmyntKAxAvx3leMhBFtAFMhJzB6hKGc
 H3xqylBJXj859emCu5OceRV2AcQ3sR84aC8lVtCxhTSy9FP+RqTGIH953RMzojKw7W9es7BBAT1
 Fkrhl1N4ojtCeFD9cuy55I8h7OLyPxA8gv4xXPYXE/YpcUmiwL+sQHTPRJcrP0wuv4WM0T7jCdJ
 cfG7VoQavYRAJ7LH8VebIbhG9tN/V5xiYdAtSWS5omlLsaSVwBe/reUPB77LZDYe9s8+2ZtIxup
 gWDm/763+2PGtXM9RzHZsu8xLBkRL4ZeTK1hc2ETeTasE3LU6BhC2Dc8igZ3hdYdqH8LTRVblVo
 nIPuDKRpcEwDiuOaVfb/ItyzeVAaKmQbVoX/J8FLA2o8JTQplUvzDzLOY4KOKoN7No6Z+7J5hhT
 8ZPoFq8dzKrDT+Yls3A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfXxNMKO8oCu+if
 Ex9IJTR8anKhc+UzozzMmTCMapblWsjwnFrHEjp/qJuxapl4Z9UK3OwZDY3iYV9KOXb9aWycuEa
 nqZnbN1pIt3iSA0OGguFcn4nFHWyJ9Q=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_05,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270112

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

