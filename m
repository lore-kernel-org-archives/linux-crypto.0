Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF30415B66;
	Wed, 30 Sep 2026 13:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773229; cv=fail; b=L+WHdUA5LgQ9VDBzdx24k72WdioMEIv+sGT/TloVtSIdu5GgJC+pWGOmGzBvuQFS37ZBYQw6YhNtQWUREjRgDJzvk6r+kGq8DGBpFoIFtHpA2EwBMIrbQ0wfbdhe7HfaA+wrsS9rkAaC0gyuLkn6Lgy3XUdKerWkGLMhEVvSXQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773229; c=relaxed/simple;
	bh=oQcv2pfVE0dbAsyh89q3x8jqUOr6UhAZWgfc3GjJRdM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hnE0kZFUoFdh9TyVKrsXxRLOYXfGlB2Z3yeeVrmK6ucL9GNCqC5UYq+8ZnpsSn5Mmp+A46f+cxI+ALypDirKAOdx2ivsjMUdQJpK5IqlgRSAIkNyhFSG3uIYmPPf4D/pMj+gHIPlb7xZQgBHZnuFemIPBlgpJYgrVX3H4DiHSy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=KhXhtC1g; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=q3Ie2+AK; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="KhXhtC1g";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="q3Ie2+AK"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB6THC2715612;
	Wed, 30 Sep 2026 08:00:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLi
	nQ=; b=KhXhtC1g2jknX94LhfgQwkBMdTT5KbUMh8QIdw3fI6TlUN6CDY/YeLJbg
	aPKF/LTIodRg/+/k5TZHs+Bp0Af/107YsLt+J3ABo5SITjZiO3el0YvV6kMEDp4G
	zvbaRqPWvYZ09L3HhnLyjYDtrvcYOdl+4vp6Fim9SU30VrZUWsclZbT12K08YD+1
	gwI31U+npwg3zrocDVOCKcWqdugWu0MhzZS80QppbgKw3U/RcYCUP8lU4GgaNkcY
	dqQ0CL8VibQeYMSg8rLeRoD2jCpDJdp3xTHRlgmI6UM6qgWZ03dUswJ6G6+8KDAm
	eh1PuaiYjQe/CakpGw9awyME2j57g==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013038.outbound.protection.outlook.com [40.107.201.38])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0m9fdb1g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 08:00:06 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D/8w95si46th9v2ux1qdaeZ499/8vb66fLdg2ylkKg2p5GcD8ljaM2l5XpHLBLQ/l/b7ocrxPDzcsTWELLwExFuKzQta5NX4AlvxVoXay1auRY4YHsCP9eM5vlHQ9Tj4GTcwYQSy8a+HRZZlp/TftglY8tM44SFuRBH4hSEETAUG5kOn61BC98Hm8+zo+Zot6YRAPCu9IBmJwbf3wZfTNv/2X/nI3vkxZHt9j3eC97JCngxeL86pkK1Xd9f1PDMPdo78MMIXRSNNFjBcblxGZ8oHGv4996/ex3DPEWnbmeQBHxWlbl0DMIJtMIBMrN8xeJnuX4O6khOXIHTTzJdYLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLinQ=;
 b=rS7OiWSuC1ShcMAb/Jmk/MEKlIr11d7MWWEO8mT5EvIQrJQ8SZrhnn4Vyok788ClpjFT3OWzSYnl57dDKc4kUygKGM8r5W8QkgS3p8iWzHBXUmhgJeboBjBtmZqy+Y2MR1vxX0lzs9+dCvzehlErFOC10t4CVx3UXwUAOqt12Fms6cEXZ1d8d4jkwhxBTflRcK/cMSWxzwJvEevVMPcKxJpgROOpQEk/r4TI4mF7TGeloYk+nwjQt9XJf4MqPUN3PC+m+WRG5JB+Y7zpUWxBbKhdjnhWAAz4cOZUtPpJsr5Fe9KdUl9mDHm7W4DHfp+Q5JK6Z09puNasf5Q1l0Q5LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLinQ=;
 b=q3Ie2+AKEXhR1M2JARLyTKVuy9xDWvneLoKj3yVA/hYSEepz3AK50m9KOmFTg4e1Pz82Pwx768eQWiO4j4mNUI8r8Tsh5y0RhkHBGf9q01RnymurWE1XGzaON+J3pyvBPowomJcdlTjsXP623agmNzF9vgkFswsXV763JnI5eSo=
Received: from BN9PR03CA0176.namprd03.prod.outlook.com (2603:10b6:408:f4::31)
 by MN2PR10MB4239.namprd10.prod.outlook.com (2603:10b6:208:1d5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Wed, 30 Sep
 2026 13:00:02 +0000
Received: from BN7PEPF000000A5.namprd05.prod.outlook.com
 (2603:10b6:408:f4:cafe::4b) by BN9PR03CA0176.outlook.office365.com
 (2603:10b6:408:f4::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Wed,
 30 Sep 2026 13:00:02 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN7PEPF000000A5.mail.protection.outlook.com (10.167.245.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 13:00:02 +0000
Received: from DLEE211.ent.ti.com (157.170.170.113) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:43 -0500
Received: from DLEE212.ent.ti.com (157.170.170.114) by DLEE211.ent.ti.com
 (157.170.170.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:43 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:43 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCxfkI4098486;
	Wed, 30 Sep 2026 07:59:42 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 14/15] crypto: ti - Change lengths in AES to u64 to avoid potential overflows
Date: Wed, 30 Sep 2026 18:28:58 +0530
Message-ID: <20260930125859.1749849-15-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000A5:EE_|MN2PR10MB4239:EE_
X-MS-Office365-Filtering-Correlation-Id: 58c260e4-9b34-480c-58df-08df1ef2bd93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|1800799024|82310400026|18002099003|22082099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	SGePkCOFf5yno6bbiMDwu9oVe5acJG1D/vLqIiEelR/xR07M9Isdh8fpC4v2BIpHqBJy7tg4HNTE8wgJjaezd4L5VcjSvrDu7zQUOoSil+oCBZVMtT1CXOQCodc/MBpqLt+iT22J1FDxBQqQ16o8hx0QACle5AyIMGy6zZaqiV0dUci+6MBLdxJFfAj6uPK9WlkQz20KfrNzyFX7yp+8dZe+aOjSPT6tHSZ98kAV5/hzIbYvLdBIBKbY0PdJ2gxPtbrbAKkDSHI2TM6sLqHN17p7vhWgQTs+fSyNrZpjyTw29XP12BwfurAliC4bt/jEIfUhY6zGmyCNcuiPLs2gH1KV+3YJCMabyOg7P8oQq7KgyjqVO5rgtybM62lCppQeLdxa1U0EE21a1nhYQJPDk5cbaBh/+u44HqygWbf9kMP5ptB0qyKOpfGqwe3VRamIzylxTHPvYaMX8hmto8PeFAvP1FxMto5d8OUOIe4Ze6+9UbZlm8Tfvfvirb5xLgwSEmCERSOqJOsnpAj2DcjFd8P+MYH+KMNgjU1zgaB2IDFuJveNYxVY0JlZqHcffYFDxd2v5fpo3rPcpTrxBPxt7c86XJNCYwanLlo49yxd1anqTHwttPLtXqBqa9gpHAEDdmwUhqFDTGCxojvhmJVLWRg2oRgejPIb4h0M2q0mLVo8WaiB6s6FoW6ZqI6VCKcVil0USObdWLe7934+NZh8cA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(1800799024)(82310400026)(18002099003)(22082099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	J8ps30sYH/bzOFU3Fp1cH5MpherrwELbtbBr7uMjUY0h+GK5H6YVwybgcidzF3L5q2m3CgNcttvDgJ5WGTzbpCngfAt3i/14ad7e1ddcWq7IYgzvD/CZRKSnmyhHheZwHdnrGd3MOHAMVLbyDJPcShj/jlenPlYl7gBWtFepUgemdc6980XKz10k4b34Hhmg3iiKGk9UBG8LLj1hlGLF3be4xchKeEYamTNHLZclg9+3ig7vLXIhdRPHCQd85PrFWb/dbFFeLhzk7LDO3c2evJGMC17rdgVXTfUW1GKrac2qnkunopgPC5TXyEWQMGotx9DyL+uqT9CWRwugywAap6kujvwF3cALPKnVs8HN3IcdZMjk3pssHsU5rq5eg5HsTeawGbyxjvoU3R2gnu+mJI/KYpN8d6t7rl6837sEMbxxXkOKa31T8coJAQLAiLDH
X-Exchange-RoutingPolicyChecked:
	Anx6TAYdz5zIPiTjjZE27CmlgbKOJ8z+WuXRsho+IVAAQ6S+wKw7Nrd/7+nqJgIRqcbdFm2OM3agw9cVJ2WDP3Alj5jS9FdoPYGGIJuXx4HhOYDyxtG2WFpbtcrmAxM32Li6821asXhC59EJVYvKeuRPlXqINDpHsz2CzcATd+CvJaO4xGrsujq/vJXEfT3k96uSCuk3Uf+GSg1S1stdvH79MGDizuIHO/OFltRwWw6MBrFtG0dhnIo9fui5yHRlL/rDXOSlx3ToEmHXDPSOD5OnngA4YT/EgWChO0Vn3FBw7O+uIAIIIcWb82iVC7B8MOMc6T316sn3jJ0e1ldZiA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 13:00:02.0139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c260e4-9b34-480c-58df-08df1ef2bd93
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000A5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4239
X-Authority-Analysis: v=2.4 cv=VfRir1p9 c=1 sm=1 tr=0 ts=6abd07d6 cx=c_pps
 a=ZmKEHIpmlwdLtedhitE7eQ==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=sQKIhDeqCqRtbGPzpkwA:9
 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: mjoB3Yo2CYhWHNe8ZMRsG-RWzpp9L2bU
X-Proofpoint-ORIG-GUID: mjoB3Yo2CYhWHNe8ZMRsG-RWzpp9L2bU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfXxZYddoqx7I8q
 snaI2yaSgmNZl/AqzO7KtIG/XGIDVNLJLYNU0ZhgujiCA47/hRxrhx7QKQcyoW2lWscG3i7kyvh
 SMjc8V17wdmgxjv2/dXj2UvnVg8WWOdqMEpFItNn8G3/l+V+rP5AIDyZKJgyvDKRm5AktUI41PQ
 Y3zcLVHjbtTmGO/9mB5nE9vjYOXs3wW4p7zCcMEb5wteAgRE2aXzMWL+v64G+pJaQlKzX7YfsFo
 kaPHtSmoduXSLZIimwfzlhALM+D6Kz5W+mTEB3/DOtLapygkNlAeC9rwE7+FLYWfFJbqL41U7Qa
 E5DuHU2ThayI1uBFRsC2yzVrJFu1nuz37eq+EWKerWqKHGsiSREmPBGXDVxFG2sIVVvpHU1bsfh
 /0p1NHFI1WIpMs+GiU+cKbr63gRfN4sJU7jBkaMdLKhVh7JWHylzQPHEdyOOeHTYso2Nu3gfTGI
 7mWKyuihH56ZhiogNfQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfXyTFqUc9aaAaT
 YBf6NKtiqYf4JQT9ieujwsY77SDt5NaxFAcVPcjXD8RZpkT3D8l8m6Fkt/KDBu1QMloqenlg2CG
 uY/UJtkikkUOKBdOtmhQ6u+U7vA9ftU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

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

