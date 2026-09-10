Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57254583ACB;
	Thu, 10 Sep 2026 17:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063077; cv=fail; b=p5zAShqBgpvPD5l6QXpdjx40XPLEJJgF10mpurQ1Qg0gV/ZUfBr8J56ucHoNjNScZ0oHAr1tEvzUsbtpnOBB5y9udwigBgK3zSjnJVWcXqBAHc461fRtvLak77qXj9ipaa7AL3rHM9i2Kf99BG4Bgque2QMYjLjm8tNZenqxCUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063077; c=relaxed/simple;
	bh=L6sJTGbxYKzCcew0gputMowl1JIkjqKkuQGwSODlbjs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mNzQBAf6wIdQPHgTS2qAnZKXY+s3ThEdWuc/VbQ4PDgXbvf4AV9bDxNBSQG4+Lls5Lp0p2PalN9AVKK9nM/PebvaeG/4H5Ri3HTZ8au/OqO/009i9PgAyNSp/hDDjwNyXeb0MCW3TI7AquZJE4S2BfdHkuHMVbqwgBzsOmccjFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=PA4tQsJ0; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=LwSgGz51; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="PA4tQsJ0";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="LwSgGz51"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AGGFgA3546631;
	Thu, 10 Sep 2026 12:57:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=1XOuYy4Cz02k59FK1p12uZ+MgDqx6sx09AI8IDLaQ
	7A=; b=PA4tQsJ0HJx+k0pRbQ5TYAlWh9cwZj3TWcg23pEywF4RQvVG+fgd6Eauq
	AycaiWZBlYJcpo3CKImEZxP5KRMonRVvgJAFg+BRq9Ltg5bXBVIPqTIGfnlUFFRO
	HFuZUuqCw51IVygPAmFcHiSu5I6G3h9e2V4ssTCwavtcgeW6sDLb7d5JOsmwZqGJ
	LORaI+npOf9ovX1crKShNSGFwo6kCJ8typxBUoHgopy+zMcVJRO2zw9JuPFV7Yqf
	ko9390FLCIkWjNnRlHUPM7Q9A8sHEm/mVaQyhF/fQKO01LSIcRnXWfqeIz4tUvmt
	bKq2wHpw5XYCMAuftPRpotCvHGM5w==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012052.outbound.protection.outlook.com [40.107.209.52])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkyx20n92-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:57:50 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kle9zCByb4sGJKKFyx6pDqwYjpDQA9OMcDjVwuFV6+0OnBhPVuaZWTxZzpf1c1MW2cE8qE3gWiKS0mU/R7uwgyASJGi5iQbldR7plEGfC2nhFF2yZbssJfYPLZGWbXGulGRq1VmtC7S7VnGmcebX90f+e7xFZZC8hK2qg3j+pVNXTbNsG+BCOICKeFcu/rTPPDt8Lu/wdHMC9Xf/P6fLYyVUULM3TqsSl6CRntmPR4D34nbwqESb/3N5YuzZruXlUj1qgQ76szEFv3ct6nDUsEpbbO4Cu56Bhxr/z3OJAFyvBcsaJilNz8vrVCGMFBCbehR04iWKuRIgel+nu2ilBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1XOuYy4Cz02k59FK1p12uZ+MgDqx6sx09AI8IDLaQ7A=;
 b=CFV/uLJESNlaIh7wCpBN9ULjUGsf34JwjJ0N5YvKbmLB4mgsGf37uiXeNGIc91fHm25w6/Brer4n6Lc4bopwbHnvNojjhc4AGzr4H86TJEm8g/QydR3HhD6y+V1VcqzhDQE56vYZjVXQicpRMF23njUgLMkIoAfK2xofw0txpufRNxkb3A7IonLlzqOB3hPohmYnmW6VkwFl8PrQrPJ8s89psG4pD2pl4xA+6SaFHl2pdksmtUdiHjzmdvXc2RZwyU59U+aByY6AuA1xhCGdB59s2neJiz9q4RGmZHnMreKjes0oRt+Jb8/mnlQHA9kPQWx0PiANrUwPWmGN8Y0V9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XOuYy4Cz02k59FK1p12uZ+MgDqx6sx09AI8IDLaQ7A=;
 b=LwSgGz51Yy889i13z9+587rT91Z41m5MJGAJ+D1tleTljrJN1Jgho/yTCLbNTkEK5PsY4xkd+JLhTS1KvgfeKmZvHHaZtEdxo6nH6oiD2ITb/6Hv8hW1tpTahKrH3X9b2dAZxwYcy7BuZWI/al0JinUOh+ccCDeuxPHRIa9Ali8=
Received: from MW4P222CA0029.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::34)
 by DS4PPF6ABE13187.namprd10.prod.outlook.com (2603:10b6:f:fc00::d24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 17:57:30 +0000
Received: from SJ1PEPF000037B4.namprd05.prod.outlook.com
 (2603:10b6:303:114:cafe::6e) by MW4P222CA0029.outlook.office365.com
 (2603:10b6:303:114::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:57:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 SJ1PEPF000037B4.mail.protection.outlook.com (10.167.244.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:57:25 +0000
Received: from DLEE212.ent.ti.com (157.170.170.114) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:52 -0500
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:52 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:56:52 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHup5O3763752;
	Thu, 10 Sep 2026 12:56:51 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 07/15] crypto: ti - Separate padding buffer for src and dst
Date: Thu, 10 Sep 2026 23:26:11 +0530
Message-ID: <20260910175619.2122149-8-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910175619.2122149-1-t-pratham@ti.com>
References: <20260910175619.2122149-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037B4:EE_|DS4PPF6ABE13187:EE_
X-MS-Office365-Filtering-Correlation-Id: acd156a0-6005-4983-dd04-08df0f64f907
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|23010399003|376014|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	htwnRXFk83czxo/7VLYt7BTVzUC8ibyPkK/02iE6xI2Yysox9SXqssQdf6bd+nI3vZwW92ynVlZXtKXcXS8PDKLcIzAP+peVN4Mzk2IYtdsq+S90axHezFz2YI6wnGKFxwy0KX1bqnmLp4X26A78ZBdrXxts08CvN5BPego6cCrNeG1fdPo6fjRODwlKwdQ7GZX92EJMD7PbZoCZHEC6OTdTMLDCzx1jmrcyfXZXwgJs7B7/UnVYLq3L7XHDGnRjdupjVQLgxS0Q6NQMqe4BLXhVkuGO9TVUC1/Ba/QWtmc0zOq9EnQNfJ62D19BsID5QLP0T7csT49Kutd7bTdNfksw2w5fdwEBU1Ezg+JdNoOAlaACRXWC1hwLLCWOnrNW3NMyoi40NuEaxb45XGh+bnTFFVHym0PSx70wY/ptJejQqY06nzyTMCJwptKZN+t4SLA1BKSXxoXvqPHFWtIZ1cIqakc+afr6p0GBxMT8hl6IuuO3GhksiQCTwndlMP17GddOwpP8HW52VRfocqxyrlehXe0jzbnn9xkNeCIoTxZ5/WnWngnrrz98ykuC4xsNkhk0ptS1g0O24D9iBxv2FacHdtYOsyosn9Gv6O9F7hgcqOdyMvQwokYOgFr5EQbgnp41dfI37aZWJhjKA0WIknboSGfK5Dx/Nkf79qEBugdJuy3hZ1qvBbIt0Ep/bLc6Y3DrUIqHn3h9LtqMhDIwbQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(23010399003)(376014)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	D7HjEJWDBTPaG8K7Y3hvav500SG7immj8gy5AtgqW6czsljWhxv5hpYPcQcPOyEiVB1QvQTH+xq3wKp3W5ZQ6NRm2x4OXndFNvlAIGvg+Mi9o80/L0p6+T1iobLoZjXooGymk0hWoAViQPqljn5KBEGL2xOnIcWCGksZPbgXBt/ImzEw9YoZFY3B/U8wwxR/pB1yygZRzsm6oD6QYZ7naOYLoqebPSsZcx/uFn0V3s5OVgO8lMLf8KPBBKryWTtBv9l81L0IV2/G/h8dRg0N9ySUo6MVdvnGndVGFLKhr9h8cvmhuIdTJzvlb0DAUJdNQV7RSvQwfOUEVHxoHOcfAaPft9X5LSElBOjclzMWBF3KOJkFK9jIeuEr045wj0TVNFAhilWDLlD+yrj/YCj9tiguCxHfXuUx8joL+R1+3kcJM9YpRgrAM5WkrdcrxRAK
X-Exchange-RoutingPolicyChecked:
	3B44FzNVMIFO87Lmw7h1N5aZXhZR+b9qNP7z3LuJKc2ur+LF2DxUxg1BbLOqyVP6hLC7B/76ZNN2VrtBrUGXjVf1CJ0zorLKFOXN4WSuqyecnd70AZUzQeOFsffaJiS4//xD+4RZWIVfWD/obbpOHpFKcTGteA1B2wcFLE15R84h23okI9+60whu5pnMxt+ZNzg2bxZFI0oiZ0NKZlZ6oiyhwS3oicadHjmh1AKw33aycs2XzXTrCU7w1rLp1mHU03XimCVcxfYq/dW3IsmdEEZ6Lfik6x4od+QAIHeI7GXCc5v1AFHLQrQGZMrRXUfWOOiURf0aT5baF/MSExalqg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:57:25.7710
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acd156a0-6005-4983-dd04-08df0f64f907
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037B4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF6ABE13187
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX3eVdbA3r/rId
 uK/Hd4SOAwIYoPTnm/Srz3DWdzjXbAMXnmtnZ/TCeWNKrfn/vACmwtoTGB4AZ3LqGhmIvvaoaqm
 4wPKYfrMEMPNaaK+v97rwEYVnsq+buc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX9KdSbF50awA1
 BoEJ3vegw2jFUGDqLVyHpwxZ7J6IBXgoveOyfBVdTU5NFI3y4ibi7t4dK5bbNNQhi4y/ByvGohu
 /xh+eEfj5Dcy4dm4nEdLIcWWg+fs1fDW8moZ6UBlRqeWB8coQE5SBVd2m+5/vJPOQqkBv0WQgR/
 PB9Tr1V4so/OmeZBgxMSgYfe3gFZJLcWTV2QqJ7gGwtLY/EMhCwF0o5vAheKKsVUz1F7YSCzHXK
 nT8DklKBlVaNa5QqIkaAZWFmA79gIY3340GVgVQLclAVpWDPZDNu3YQCzAkdhHfwNp+6zS9UDWJ
 UvNV55pFNwybv1qOYlANb4XD8bVQiHJGaPCY2trt3dnCFtvzb/9IZrirHCJHjan0sroAFRHRzuI
 UY1qcm/M9jrwA6vLBZapSWxBbkqBtvmSUkAqZFHqpKyEbi5pHwvbSiEUpWKyfsCBw7BjYfwsnUV
 vyhJQVo7A57rfACMVuw==
X-Proofpoint-ORIG-GUID: iJMDC7Sx7s3PaipZ--K7t3kjgjJkhkMJ
X-Proofpoint-GUID: iJMDC7Sx7s3PaipZ--K7t3kjgjJkhkMJ
X-Authority-Analysis: v=2.4 cv=UJ5Ijyfy c=1 sm=1 tr=0 ts=6aa2ef9e cx=c_pps
 a=GeWWyO5P+zJVL7v3m8oIig==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=pcghVQDwmu1mgjzKNFMA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100220

Separate the padding buffer, which is allocated in the req ctx, for src
and dst scatterlist to avoid any DMA mapping issues when not doing
inline operations. In such cases, the current code was mapping the same
padding buffer twice which might cause issues.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 19 ++++++++++++-------
 drivers/crypto/ti/dthev2-common.h |  2 +-
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index be7ec62ab2513..aeccc235cb667 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -338,6 +338,9 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents;
 	int dst_mapped_nents;
 
+	u8 *src_padding = rctx->padding;
+	u8 *dst_padding = rctx->padding + AES_BLOCK_SIZE;
+
 	bool diff_dst;
 	enum dma_data_direction src_dir, dst_dir;
 
@@ -388,8 +391,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	sg_init_table(src, src_nents);
 	sg = dthe_copy_sg(src, req->src, req->cryptlen);
 	if (pad_len > 0) {
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
-		sg_set_buf(sg, rctx->padding, pad_len);
+		memzero_explicit(src_padding, AES_BLOCK_SIZE);
+		sg_set_buf(sg, src_padding, pad_len);
 	}
 
 	if (diff_dst) {
@@ -401,8 +404,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 
 		sg_init_table(dst, dst_nents);
 		sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
-		if (pad_len > 0)
-			sg_set_buf(sg, rctx->padding, pad_len);
+		if (pad_len > 0) {
+			memzero_explicit(dst_padding, AES_BLOCK_SIZE);
+			sg_set_buf(sg, dst_padding, pad_len);
+		}
 	} else {
 		dst = src;
 	}
@@ -492,7 +497,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 
 aes_map_src_err:
 	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+		memzero_explicit(rctx->padding, 2 * AES_BLOCK_SIZE);
 	if (diff_dst)
 		kfree(dst);
 
@@ -882,7 +887,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 
 	u8 *src_assoc_padbuf = rctx->padding;
 	u8 *src_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
-	u8 *dst_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
+	u8 *dst_crypt_padbuf = rctx->padding + 2 * AES_BLOCK_SIZE;
 
 	bool diff_dst;
 	enum dma_data_direction aad_dir, src_dir, dst_dir;
@@ -1125,7 +1130,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		kfree(aad_sg);
 
 aead_prep_aad_err:
-	memzero_explicit(rctx->padding, 2 * AES_BLOCK_SIZE);
+	memzero_explicit(rctx->padding, 3 * AES_BLOCK_SIZE);
 
 	if (ret)
 		ret = dthe_aead_do_fallback(req);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index cfb50255a5dce..f78420ba871e2 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -115,7 +115,7 @@ struct dthe_tfm_ctx {
 struct dthe_aes_req_ctx {
 	int enc;
 	__dma_from_device_group_begin();
-	u8 padding[2 * AES_BLOCK_SIZE];
+	u8 padding[3 * AES_BLOCK_SIZE];
 	__dma_from_device_group_end();
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
-- 
2.34.1

