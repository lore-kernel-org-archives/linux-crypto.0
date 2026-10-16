Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BE2372B3C;
	Fri, 16 Oct 2026 11:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151365; cv=fail; b=sEQaWqN8VF652TK5lQcJLmtY0cacV+QzpN9yEkwNbHvqoX9JyKVyWlgk6OLwk3c7XARUyk9vb++LWtaRNKV/mmkBvZMC8i1A1Y7eQ+wzGH2KeGre1kJOrmwLNsj48xrSyV0vNvfL5SKyX6tzKoGtQRf1kYR+bIP1NLdiWt5W70g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151365; c=relaxed/simple;
	bh=oQcv2pfVE0dbAsyh89q3x8jqUOr6UhAZWgfc3GjJRdM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pZ/V2AR+wxawUKxsCvYaCXUi/Lr9YKHXF9304rahofGbrvbEc3Hu2En3YCJWdC1sCXoZxtKmqaTSon72cC8TAXt/911MPvjP6rVbThSI+nL1vrd1/tEKULux1fYU0hRykTwPT0Tc9S7DxEgvwtDlJFhO+0WTJL/lvhCX6KN4Alc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Ax6IFXy/; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=N+cZv30R; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Ax6IFXy/";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="N+cZv30R"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69GBVfuL3845472;
	Fri, 16 Oct 2026 06:49:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLi
	nQ=; b=Ax6IFXy/WbY9QCj6TDFzTdo8NIRONSFSrUFFk8bZrxaFihVwDNipP2ft5
	NY5DWKduvTMy+xbODINy431LANm/k6RTvNWJiwUDQSKWvPNlvBg0/gGkqbav2ost
	ols/OGx2BRm6XD1Dq5/pZ2LninMcOX+lVQA0bnlgeS1eMwZqrb1hBJncMGz81Jcm
	hRc3IktcatemnIU6PsNcqB1uGZr5XikW3C1kG6kqNOMSmiAgjsM84nsrEHtSGwqL
	kPviOe0WXI7nuYxF7R5dRlcQA7xRQHCx7xzy+LhEpRCGhYSBQbDZTxQVwo6mBFtL
	aT4C4gv7Y+fKxqmXPOcbRQSH6TRfg==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011018.outbound.protection.outlook.com [40.107.208.18])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hbhbg8jev-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:49:21 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zLBiii/xJvhXGxBrNSFLVIDD5R7ZahAQ7MiOcsns2tM+07C7R4otbD5NB57ISbO1PiEkyBbjum7J9TJTUjzV8aSlPIt2hypKpWwbYz59WY+TrwhXe1Q9fyzMKMmELYckpXiykEBCXQXsNdECnFW/rXecu9NN5MBQ21CCqKZMhSfAWaTUyj64pRhbhbAulyGm7HZmJM5nzBojArm/ZoYYo1cAxM2fVWE5AWHCkZFTDJ3xQsTdIcgvwGK4hE6LR+Mb4At2+rbSGdzGh/4qG94Dctj08zpQ5F62mV2dz5mrQ6M07UXinyZk575bx0uv/g6TVcCcuX1ZHlo3ajRhAqVuLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLinQ=;
 b=SuPJal+Hz12kK69U9BZdPRcUHnS/MF9vJiYbmwoDBDCSqok61RM6KT41VDix+3Qw3tcFQn49clSxzp5tSR5QZ4Xn+EsbT4PTOFkst34QPEP8u0GfQvAonJkCCeOnxTLTNbAnt82bdgTm8/60OUQefcaL0zSZt2iUMsfSmSjG3Z2eF5YTYyPLHylB7Zya41qitUIlMJYjfGUGvtxdm3sYWV6gJJn7QvP91lqDumQhAes3wy/FAkHFV02Lj0SzL6Ea1Q/ZcIVpauzHeebpNaK8H/5l0bUheuXeSGYEyGVTQJ7pZL32Cf4g6ZAqr8j3zZdkJQt4UKtNusKWBHvTz+D71w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLinQ=;
 b=N+cZv30RmgnkB7qZucTd/lj8cjnvxBteMMpvbdZ7suLh4fEQZqTtnNLDekgEUo0ZjDYeRss/qToCzVtG0klH7k8yuSrR4xm7HL28e2GrtUvtl/ve7reWu0DSlVhXOea2h+n9QHeo5TxvNFTVGcVRRhU9WOK+R32pL2m5lZF6B0I=
Received: from CH0PR13CA0055.namprd13.prod.outlook.com (2603:10b6:610:b2::30)
 by BN0PR10MB4904.namprd10.prod.outlook.com (2603:10b6:408:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Fri, 16 Oct
 2026 11:49:19 +0000
Received: from CH2PEPF000166C5.namprd04.prod.outlook.com
 (2603:10b6:610:b2:cafe::8) by CH0PR13CA0055.outlook.office365.com
 (2603:10b6:610:b2::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 11:49:19 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CH2PEPF000166C5.mail.protection.outlook.com (10.167.244.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:49:18 +0000
Received: from DLEE203.ent.ti.com (157.170.170.78) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:58 -0500
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:58 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:58 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmuc32451798;
	Fri, 16 Oct 2026 06:48:57 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 14/15] crypto: ti - Change lengths in AES to u64 to avoid potential overflows
Date: Fri, 16 Oct 2026 17:18:05 +0530
Message-ID: <20261016114806.1749515-15-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016114806.1749515-1-t-pratham@ti.com>
References: <20261016114806.1749515-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C5:EE_|BN0PR10MB4904:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d7b9353-4e2d-4840-09d9-08df2b7b82e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700016|23010399003|18002099003|22082099003|10067099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Xw3THvD3mOM2V16FdcG91lBpH4sscfFMaBVfkf7CgDhB5WI4XtIyExdV8MS7I2YWIiNNAqIBfpomiHh4oc/Jh1z90AoZ8bFin4TEmnV4qjDUMvVWM4PiUfixjXBglwX9m/kejEpZ9Ti0WeD7x+HMo+A3AY0nh1mSm9GVWtuUR6kPSgZUezX8hsRmcWlfSuGtYnc3mkAp7q2CFbYXs/Y7Lk1C19M+y0XW0rUvL3bD3JmpcB/5Va1lbLMb1++LyY1Ht75ufIIf/UEU8/h9kEWWei+3zWRAr1GDCUloGZphwao9SDxhr1qSp/PZtbMsFXhk0zSL2KL+5dzveO9jUp8M12cJUENOcPjJSm+w8w84tS2lZ9p0gWAfQ65ycpSVz1U1fybiVJzRlUPBvFCMtc3M/eLizMy2NkqRInkbuoApDDgiolGCJlwMRjFh6myZ2KpcY6XHmG44Whcn32rxdIlEx6d5T5q2VdLptfrPRDeKKL0h7Wz21ZVwKgau4jOUCph5jYtMAZ7H/ZpiVqfjgBhdHrBtuKVU847solNRc7Tnr0ujlpfiKfdJC6EhoOC5h4+0C3V1t9JCcBinl/cVWLbU69dRccDjIbtSJAQu7mSSiDndgU/VVq7Cj+eKGe3NnNcKlIuLwwmOeEDQy3sdsltRHvmlLpkxMUfIj9fKasay4BBhcEXyP9whOI3DKfzpTlhnw7Ax4BoLsBgHTkG2vkQpAg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700016)(23010399003)(18002099003)(22082099003)(10067099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	whTsrLRdVFNKkxuVoTOeZNjstex7f5Bj/f2X2TNvSJQpy+gW7NXDFM4ROcQxkqmPWIYYCro2kAwwjVPBIA6mmYy8JHpIbhyQ+tk7B1zeqDIW1spBXW0jsVEU3NRm/uJGGp6usoiZFfiIka7Msn+FmKLidhG+ThYDnzhKHRQwL46upd0pzjmAMFtCMrVt9eJlRu2strN8oufkRrtOAts1II3dFtvRSuyBKHHhlNyBsk82mrpoNkRA67AbAVKm3Gb6ry+WUnraGxSUgKhSYgxP/huuQliCXpx5ztktEM78ZWYYfuHnci23GKsZDqAEicTLoXwTJ7/EmIAnRTLuh63d/GxNpbbtMYyxgv7fxgANdLSHuc+Kn2nAogT5sY9nP8bOthRqeBlesX0HdTMwNM11E+agmsnXm8obtcxzMAZWHaEv//ajknjA3A789gEE/1bp
X-Exchange-RoutingPolicyChecked:
	nUvtnbwFjj+/1ioM1nstzhmpJs4ZFXoQq1Znd2Ao6E4oqF1MghLhLhuZKAsN6c6JG6Iy58NLMRIft0uqEdYE+3apBxXl2rtCazKTWFe4Erpaj12UYo+uEmqapn271iS9e0/+g5vGKzjHa0IqSMrD+Iklqqrv0p1jFa434itRYm3KtljCadYJfsc9lgxf8mIk4wQ+yALD1cdkN6t+3DreqnMM5VH/U85JxHWIC/kjjinbgFyLN2gGX/Oa4DLC1Lw0nyxH84z2S0QGI5roUv8zUcLL87b0DTDvKsGJkAKx98irl6HV6UQBcBPyEGmmk/Z2Mh5PciiQSmsDZGSIHDMEew==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:49:18.5790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7b9353-4e2d-4840-09d9-08df2b7b82e2
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4904
X-Proofpoint-GUID: ua9EvSYSXATk5GncoCxgVqJ2RUhQR_6o
X-Authority-Analysis: v=2.4 cv=BuoIUoX5 c=1 sm=1 tr=0 ts=6ad20f41 cx=c_pps
 a=6KAf8mVNDH8Ped3ZwZ6wqA==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=sQKIhDeqCqRtbGPzpkwA:9
 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfXwf5TJyZHJvV6
 6E4WcBqRj4+Y64KYU+tedTFLYfWPHrpkdtT2L+e71/hBiA7GKTJylyCbTzwo/yT0o8E681e2bv4
 OgcYoCoZvZ7igCEscgRzTM7cfjXRTkdoO8CnlsjBWbLAWd3Ja/4+f8fc0+LUzudHo3/zYwtrf5v
 sam3CrVoSxX2e8JAC/iQ5uqVbI803/jFTdn+nIpI/8fEioxFu2mtdqvt19+f9JEWd65JIgDRr6I
 Z8iR5Ra1WHJrDhguPR1xz/mCdpTQZi7pwYFBdnnB77mch3xtZwFx79ww8y2r4BG3CuoE+GCCUEq
 ujUpbJJEoUO/KwpJNP2NuYT9gPlZ+sdB8ImhRjEMyAUpodNHidStuO0xfSU19IBhNBMi4MVtJ/Z
 mPCa6iXrPT1uoVGX9+qM+n//DjuK4g+lV3E1lS4cosYFd7x/ST/wy0juXWJt9prnOFpf9nppZJQ
 gbKPtL7SggVAknf9n/A==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX2N7lRL8My9j/
 WzwN2umvwMX7Ir/b1qid4McGaBTbci7RQ1OLMGOFczomhgcKnWaofo68FmF5JpIeIqa3MU6+zGr
 G9g3jEHLFM+LfqM7DXH/fiICl0xpjec=
X-Proofpoint-ORIG-GUID: ua9EvSYSXATk5GncoCxgVqJ2RUhQR_6o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160046

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

