Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D8B4BD34D;
	Fri, 18 Sep 2026 10:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727017; cv=fail; b=QfjYtCIkfj0jEML23kpX4o9w6GsiMhQ79i1aCx+/1VCYoLvr18z3LCvDWY42mEmoPpOxLkBlI6e/lm3CShdYiZCGx5lJ3iohxIctpTWSqtAm2erfsUyANXq6/dyhsJPkNMPsElWAkhPRkITKcqxQUGEnOLpbnTcr/0eCTTZGdCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727017; c=relaxed/simple;
	bh=Z5dcs6emr229Sxd8UusQQWOmWWwMpTcSb1LfuYj4LZA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rSfRiEXi09z7/D6d6+R1qB5dSblDVkG/v7P7cgeGE0LKsyuwN6I5Va9kecRLyLAxpr/cx8K83q2j6LezMmsT/3Yv0DAxvKfzp4PqPUXZqJchfFMXXl1X15kcLOt58bDeYIS9bLntrYEhJEvmK0qCCy8IwgsKTwQ8UlsJ/f26KWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=oG7NCFGL; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=biuYkYVc; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="oG7NCFGL";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="biuYkYVc"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I9dNxR033438;
	Fri, 18 Sep 2026 05:23:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=v/jYL1X03j4q/EZ4dbza9jpmZgK9IlPnHEXGyjoUK
	ww=; b=oG7NCFGLfFaKejNwa3rVPyKlguLOdOD9sNTqNLnvahErMZdrG81rEgWBW
	SDoSGXXJsFkL8+oCzNH5VeVocJ7f9wHJ9srfoPjrsBvgS9RbPkA/axhg4gUejzrp
	NMrHtKoElOCeOy4GolISZEtpz+3c/oTcjNzr6/cAVZPKYAJe7py+2X+hgHngWKe4
	GlETF7Aopz99NvXgqPeGgEanvKOFFRFVh/VXF1gkawXEpvtwYFs3FpdhW3XGFuhq
	mp7FBOcCGPKCJ/8cl2LR4yW+w1bEesPyEwms7IFuhU15AIs84oggCNsA3lIRy2wV
	EQIkKyAscM1Rv2igZKxicmsJOPwPA==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010025.outbound.protection.outlook.com [52.101.56.25])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gs0k39121-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:23:31 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kae8+I6FD+ZKXIiUpLMSgqYGVt/S9dregBtH6ToUocVCFQMj+2oNA+P231az2klBd8lJeTLEGHP8yWBXIAMV/TqRZwmaRVFeYzNEr1J68zQnEuYMW6UqvBRnHE14FNhMpBaiJTO6VSBW3MfV+M3aXtIlfdGBmNS22Ldugt2N0mSVXS2iT4iGDayZqng0w5bXIS2nDGar+LNu/6kd+KOV4zBC6nGPP4vv2/m1zl8OHD/hHNa3yMdlNh7l64LBjE+mjV6MpJ3NGEsTLc9zNlqdSvUcHkubiogIrMQ9gDTcnmPq5MCL3uDEqJWVBTd4nGqNt6oBT9F2dzruYu3kpi3lZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/jYL1X03j4q/EZ4dbza9jpmZgK9IlPnHEXGyjoUKww=;
 b=FAn+NjkPpLxnVeShtroP/vFcgRAC+HBzoZqIi7l0n2qyL6k3tZts6b/pOW7BIxT1bdeuSTc+vY80B0CbPcuic7bmYb8WqcYIeFSZhY0p+ARHU5I9+8j6wnS0w3rHxdpCM34zwJSGcJQ0Vs29m97S+OjVPuZNZSByiWgQRhkcShpPO+Okj8N3BUoGliiW+XT+zCoUuW36nrqOR7dQAcQidqYVwUBgvK6urHI1BbxvSd40od5wzGvlovokN2CPynOf8wBUz3bWRg34ztufz0j09xZBGeEo866ys8GTWuJY4sxZmbGBaog3vkNrQc0mxXajhXMgS02stuBsmE8ejzCfSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/jYL1X03j4q/EZ4dbza9jpmZgK9IlPnHEXGyjoUKww=;
 b=biuYkYVcU4tAogJuXdQsI86IVqzHvHT1S24naOgPIWyaHgbew8HfOxuM8zbbCf743Y/KXB+ljxFbb6xmifABRs5hqGkXlz+uedJqmd+vsmCB1XHH8Z07drJ1zLioDwL4JOGJrjnl8v+Mdrrxe32vuFPQIZki4aCkwJpzu8Nzf4c=
Received: from CH0PR03CA0338.namprd03.prod.outlook.com (2603:10b6:610:11a::10)
 by CHAPR10MB997698.namprd10.prod.outlook.com (2603:10b6:610:2f7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Fri, 18 Sep
 2026 10:23:27 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:610:11a:cafe::1e) by CH0PR03CA0338.outlook.office365.com
 (2603:10b6:610:11a::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Fri,
 18 Sep 2026 10:23:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:23:27 +0000
Received: from DLEE210.ent.ti.com (157.170.170.112) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:03 -0500
Received: from DLEE208.ent.ti.com (157.170.170.97) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:03 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:03 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IAN2aJ600132;
	Fri, 18 Sep 2026 05:23:02 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 03/15] crypto: ti - Fix potential memory corruption on highmem pages
Date: Fri, 18 Sep 2026 15:52:33 +0530
Message-ID: <20260918102245.2784000-4-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|CHAPR10MB997698:EE_
X-MS-Office365-Filtering-Correlation-Id: a2874b46-edbf-490b-0f9c-08df156ee103
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|23010399003|36860700016|1800799024|6133799003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	JasIJumbZD4mkBWMhzd85GOXUV+3lB6L2SHt66UnKKlolc5TxrMk0k3BkeQFfNcPgrxHmNzClE1QZ82tRKul/x47k/oxhAs/x4zFqeKJvMNQrp1lCKTUbZpzhMs2iKmX9LYXQuMPw1o+BVQo+3VZ754yfVfgBiBJ/D5CiIH+TW8Sk3RnFoH208xi9rFeuhB+uUuPPOllpQ+eV5+PCSjuntrFYIjvsT+euvjlruNpZPPiPmWnKXBsi3jcjWbCYIPc4QNTVjFWOP4YwAjuha0dxNovZENMzrY5p44ofPd4xrxIvRk+RyIPGogr8ZGAxAtBlOYD8GFRSuPtrui/9KOBF6P39ZFerEM/KtEXmB05YH5JxDT0knbSZU+Fo7/34rU8VDq93Xd3JIHk9KKSRqOs+DH3tm7WIZz5Da5qDc6omNqJeecmjpnm/H6xWWL5V8xk9cpgVGcRJHJ5Bs7RqyUudeMzz62Dzr55i4b5ULgdQyzwhcIK4pLcnOKZgw2ADtnaaNo9D3b50YIjk3zmHN0fin6wPDXfzFU9oXUxJsFTk6sXNzcUcNJL7eT8ArpQaam4ck1jvR4zp59gGRjUjOFmVQiSBTJnsIfIsChbZFPtMz5+UyJETFBurktbXVcVyOrUNBGVrtZk2fEEIjrkHIH5mb2nLyu6dLaUXnzrYKFjH39Ya1VmFukxUYmvg0cK37LXEZPLym83UgNUasZ9yzdkEQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(23010399003)(36860700016)(1800799024)(6133799003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DW2zYWfWEVGFNHd57g+oycAsAHbl95aj2Z2wKdmPR9k5j2oQpu0reWZi6Dgtul0u+mYB94q0fLLPpA6JOzjMOFU2VMBMzirL9cWuNrXgMc6uauz/lejbQS+Q2DWhoypE6fmhjEByoJ8eIDD7muxASrjZ9eZr4jCB4fqdpsH2C/61mklJok9qaa6SKoWsmTi4+m911xQlRJftlpF+lE0MhAc9Y/ujqz4aO/svtpYe0npfNmJtTDVbCUll7t48c/qHiy4bmM3qbhN7dS4YSfhNjEk2iV2QWKjULtfdLlCbNHaqg1Y2j0S5IIxzkfkzAZK+k8uH3l883Q1P6V9Vj4qH+mfkD6NuUxoLIjy5Gu6HJYn17fN0XO/IEhrJh+LXCgAfeWXxQ2Ro4z3FQj0e0pDyb00htVHT2AH3TQCm/3z9lBCLyHquxOjlw00vQxMr+bfv
X-Exchange-RoutingPolicyChecked:
	NWDIfoZF3+oyZ3AZwUiCjBMKGjg9osCSyrJLDv2t8PxFJ6+w6SiPJaw/5x8GceRThPWPwvZ0YMMiGBueSTkKxieIbGZxwVZy/1YDAV/nDaLnPYjyxjkLUGuXkiOkkjWeOnqFZHRwLX8i0ayAgRj3tv8xQ4iVQKHR0k823NsP+V6YgNEObQf6R2PrjGI1cMbVKhdPCVpzVEbuhOQ2oIA0EfJrA8ATfK5FgUmQ2i0El2Y6c2NLXJftzoVvCbCS8RJleg6Y2I3u42jvxsxqy9vhVKZnBNPipF4o6hQeJaczLCVTfjOXK8WxAANiKgmtaX2veUgg2fRLJSV/mGtkDy0pKw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:27.4328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2874b46-edbf-490b-0f9c-08df156ee103
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR10MB997698
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX/qgD3JNUiElm
 iXgmSGL/9Tf+FHc7TR7ARIw9MGOEKJY1j61U62uQsv3B9cpg6OzjnZkNeRxxsxSvic6tQPHVmhA
 lNRXifkFbbytF2eVKsHkxJSRk6Wa0aw=
X-Authority-Analysis: v=2.4 cv=K6S3jCWI c=1 sm=1 tr=0 ts=6aad1123 cx=c_pps
 a=I+0PaAUBL5uRonxG4DgGUw==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=IXP722aH8NCvtdUuCEcA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX3bKoeCkWXR3h
 ZlEEYIpQjZXS2YiMnUqA+NPB6Zix2F2E2/YoI8zL6NRGvHAdTjr3B5tAHA9FBCXa6b0qmUBjcBM
 6pWE/WIYZ1uOCj2wCBYY5zeq4cOrPO8tUl+WVYXB4kbR95ZjYLdjlPF5iazcvhTsuui6hVr+WL+
 0D6nY30ts6DYuTnAve0/CF0s1CilNVNZ0Mm8r0lGG3MmDXQg9LM4nhnD7pYn2yJG3d3JL/YB6eE
 8qPMNRdp1Kp+0DLDe1oZVn+nCOGDBsY7bL3m1/Cfq3wvpcjvQfM2RCeOL9bz0fhNB34Ala02uCy
 VFDQIIdfh6KSGRlj4vOtJu7a66GeFy8Nr3Q0IG5Tr1230ZA8QwHiTcbbn4M3xrGL6T0ZbKepPB0
 ysI2Q5EH1rfOdEBz58qLmEy4iMeTSGmZa4xsMFlSiKOoDEFfR0cReWzRO3zPigvKQyTUM56qtkL
 lZXdAIZAq+jKlZHgKXw==
X-Proofpoint-GUID: KYlBBiiBQ8QPK31lWSx5mNYhm9Uxunr4
X-Proofpoint-ORIG-GUID: KYlBBiiBQ8QPK31lWSx5mNYhm9Uxunr4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 spamscore=0 impostorscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

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
index f760d0b256728..2a3f5880cebd3 100644
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

