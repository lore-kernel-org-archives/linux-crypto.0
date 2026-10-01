Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A4B4AA3E2;
	Thu,  1 Oct 2026 08:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844847; cv=fail; b=fUXkeZeRlVNnTTh/Fscr3FebCyXULRbjhBIhUQ6SmYFDD0CxuzpXmHabQfMDtQM7DqJQYeyTQ0oqYQBfXf4UvPrNgaHfVwDMeVPi8m0Vd8URNeuxcJ9OZa1CZWMDJOAumIjGSZ3z92GBEqqmrfyYXTgHLCxO1UVrtqwwnml8Mxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844847; c=relaxed/simple;
	bh=oQcv2pfVE0dbAsyh89q3x8jqUOr6UhAZWgfc3GjJRdM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Htsgqbz4HUYfwcOy2MkAAEAAJz6x6FggPsWDFx4Ai40In6FIFRKBZ3cItabRRhydvgqNG1JOrf/Q7nAActxYqFuFY1QofOc32n258OhGGaIHW6iisKizpgMUIzL4mGeMQTmUKgjzKjHumEkL9EcfRUPqFTSizHDpBVIio7obQUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=V20345Z9; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=lrXH/JdR; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="V20345Z9";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="lrXH/JdR"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691710RZ1294545;
	Thu, 1 Oct 2026 03:54:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLi
	nQ=; b=V20345Z9QYrEsi1Jvj/nVrhh4+0kcN8Dx2zcgifZCzFHRNTJf9WyiFxII
	z216R0haYhpzR8PbQXVoe1REOcKCFbXIDnuVFZN282Sj+DNGeMQ1NRq2ZhyYcfRg
	hFKRzvyWkx+DklOnJiV2m2dKMs9q9hxCoEE9pbfeGOdHQFqqDDsfSG/idEzh7krr
	jZXkXdJxlYLRaDbgA+0iKQxQaL4l6NpPYGceCK5XqxNBWHevyYtPU4PJR4wAA4kS
	GE+8Nd29IOe5Al4H96TYlDOXzk4q/IUdgMUBrOogVJIyeSqM7rE1vp9A7yf7X5L8
	3f5h/u7LDjn5OJn+m1OAOoFokXFIw==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011032.outbound.protection.outlook.com [52.101.57.32])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h1eur9t4x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:54:02 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iGBtqCYJsI3+cTo5sLiixYGRtjQhbh5DKO6sXOza3EaNEQJQ7Oy9DO6Fjg65ljfWMvIfOfTjQJiStpntcI1NoqK2gQMDVQkjWoPjzlbOUepp82pWnW6l3PCH8R+TWHGdyLwGooT1c0f9aYSM7F1H5OkZC43HukeeWTK1dN9AGZaOqpf1QgCAgU4JExb4UQVYnph7jou6ILXIucsfBjY9bfVNyProU54DmUMV10TBLOl85tyElz34k3E24+as2UYUeIj8SfjYALbKPjHYSlUz+vCR4hrYGCUi/XbRyB0Pq5SA4YqVqOhJaUaCJ1yByBkzHOPrUq2EcCA1D3RPQVJErg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLinQ=;
 b=SK4tQSNlKlHZ7KGWUHP5JE/2qzpO/BBn+GpLYq7QgHfEyQ7wDD8aUHuLDk2yrNzTmMWrmWcWvTmLf0cl4wJvZ8awjBuQBqrGnur+1SBFejhxwGMFBm3wguXI30lkWngZlanJB/rKsUQeIfmaAuwyeb8vH+i+U8wLvk3s0t77hS7tsP0le7E5xKg9eG88CVxRNHFiR3eGQh8O5ws0qEVcn+tyU7yilbMTuc8k46ep61UWrTbSWgXxgCRGg96yayXOWgR+LkuQ38lUSdMqkpKzl3w8R3+6N/Ttm7ajK2G+kLr7IeS/tFX0EFAzntM+SLymuW0dYqFOdNq54CNqqvTBQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRfNcH2IjS8ohvsO/rD1rf34o07lrWPZYQy29HgLinQ=;
 b=lrXH/JdR0vyMmQ0UP/aXcJQzHyoaM2PdyXXZnZ8AoovdFySLe+Ltl7wLy6L+8zY7120vKsPrycTeNTn3BhijF7i8BXnmBWV+XIs/wqIFy3nX5d3G71xZaLYlBDqUQqWOk8kSIEE82ykPrc0Rt9clSL5N30PmFb/pjpsoADQOj5I=
Received: from SJ0PR13CA0209.namprd13.prod.outlook.com (2603:10b6:a03:2c3::34)
 by CH4PR10MB8196.namprd10.prod.outlook.com (2603:10b6:610:246::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 1 Oct
 2026 08:53:59 +0000
Received: from CO1PEPF00012E80.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::69) by SJ0PR13CA0209.outlook.office365.com
 (2603:10b6:a03:2c3::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Thu, 1
 Oct 2026 08:53:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CO1PEPF00012E80.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:53:55 +0000
Received: from DFLE215.ent.ti.com (10.64.6.73) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:24 -0500
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:24 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:53:24 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918rNZv648849;
	Thu, 1 Oct 2026 03:53:23 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 14/15] crypto: ti - Change lengths in AES to u64 to avoid potential overflows
Date: Thu, 1 Oct 2026 14:22:44 +0530
Message-ID: <20261001085245.2922974-15-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E80:EE_|CH4PR10MB8196:EE_
X-MS-Office365-Filtering-Correlation-Id: 39f6624a-1170-43fd-6a08-08df1f998691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|376014|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qr7lAa4uLkvQ3GMwexBoEKURlUSY7uRmKczmcQBH0Td3GVYZVs7ZOY33LrHAu1hQuM1Hz5fTrObw1eCrqT+nksDsDN/ZCjyoFeoFRG86ImwFSUzvSAsE4pSxjkpF20jFX6TxO7r46mApIDUXUGlS17KB829iv0SvkFeBxKkmCQYu2sJADEi+V2yl+J7fL3/lqeXuVwTKJNVKRHQkiYpXJft+L6O4z3CpvkQTeUyNMM0fmEz2Lmjk59LUXqQLNeT3/wtIarurZnkSatOYtLSDzVRnOXqO8+/YZubFI2zx71wxywIww9sdQCoxtv5COYvJwg+ihSf/Y9g7Z92Sw7pb3fURUZeC2IcmeQGScm0RdBqZJWZBQ1d7itjz+TtAGugJpVGNJbDi/eMVzdnuxmX7/fYeMtYziyxe7FRfviyDzmPrIfl8OI5mY5Q44BDqPSBEnYgrcaUqLVPC67mB3NBBXn8THsBchaVhczDw/9eWL57h0W82GFAjQLPOhUEWYOzjDBVDquHdQdpxJlVXE40O6OZtXWPZSeNopsZEyFZdodKSlxm/VBiqsf0SUJx6ba78lhZoRbwYWtOF41v79nc4ra7tpMpJMX6X4JyVYOYfUPof3JLFbe6/ZAJY87scSmZK/+Pfu/JwNfswEMkjw8gCMB4npMt21EX7xouoTLdqr/tAbyJgi2iUi0dh+GMGykIJieb5cjN1eIWl0q3/WiPEoQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(376014)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	N/CV13w0vZB+zH8Hks8IbrrtVQpQNqCsC1HUQI1dbg4XY744wUN1so8JRmD1hzr7KbQ/nAL8xEB8TtS6bvdlUKmQCg458cz/3q+bONy6GAiz75fRDx6ORp413T8WC66y8LrzUFk+Cu0BdbQCFyqlnDFWpgkPl6xx8Uzn2TK1q5eJc0f4kt3xbMT/T6cF/Dak5uy2nG9/sBLADQZl7NxGbp8Bn3faRbKunn0ioJbKiz1pF5whqrS2g84xSQiEkuUKR7jdHXcChAQtgyP+MTkE9rjwfbxlvoRSR+YHKxRPugvUOsp9F/xsCz0QJSRjiP4lkbFtlZnFSkhJdZYB2p9aBKPZ3o4ouZoBQhzArVwYQd+ZweGM0wpvUyl04PIVSADY1lagnkb0hlb/1tRhmmwnhol3PHA2p6pQl0PTF7QVvBZSGAG9PYIgeEFR3aEdoz0u
X-Exchange-RoutingPolicyChecked:
	gky3ClH5L2frSkURk/GqogVwWBfQ+f/FS9NM57jRzSWf2CVs+35oFBjd55cHy5uSqVU2hi9PEkg50c4HeIhOCgv2OjKM/c4Fyi1FB65Gt5raRHOiGDUMoRJNDyPcZe037mEDRvKQHFxe+KjwAmylMvN04p1IX8Q5k8EaouxjlsRO81cv/XlCo8k6YgNmtqGOVWi0oh9IDLZ0301jvZ944CfV7giPpMd1xvPWFE1DPnDG87nmXM7dn57tItewvNlAgwaIoIZQ53f9chqY7tyFTpfQ+SqFZD1Iuth5Rdjd83Kr/ycAqwHcqjox/JSUj9nPv8aP3M3rRtpz/htpLs2DbQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:53:55.6747
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39f6624a-1170-43fd-6a08-08df1f998691
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E80.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8196
X-Proofpoint-GUID: u9xDnSOKfI1hECPjmtJ7VFS2pJPuWZqJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX7FYEtTy2j/d1
 7PJNtsqzmpbDJUjNvlyZDfcDxkvE96xQTwU9EfE1b6hVysSn6doCi7cTyfGjP71iBQf6OoKABF7
 V3Th1AOOkCPQp86zdztKU2ajighJNa58p+X/WDp8ekPtFwGrf8V6Gi/AY/0KyzLHPl+7KhrbkFT
 IJiFqciDj9IRfrA7pH527K13bNEPKXO9Xx8g2x9lpRGahZqlrMlvIW91RlDArUMiSjzsYbKu152
 BIO/PXiFKzawi9dsUc1aMSrALv+JRcCbdB/UoV/jQc2kJWSPDHdwuEgfIVHcGtdwdMRjgblaQXn
 Ib7CJSYHjlkgVmEc9kVccGsOVr1qcsgZjGfyFdHwwG57p4n12RHLBB7TPDB7G4nP7SHhZgvQm1B
 yuLADxQHID9CylMVSh1Fegj/8NrZO1qPzNco1HpLLnW7tAH+9RbKVqqBO8uY9g9GU4M3FIjiQpL
 zxdI7ZV1444C22gZA0Q==
X-Authority-Analysis: v=2.4 cv=KvzYSmWN c=1 sm=1 tr=0 ts=6abe1faa cx=c_pps
 a=1IFhCmM5qJmvuqsNitNxVA==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=sQKIhDeqCqRtbGPzpkwA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: u9xDnSOKfI1hECPjmtJ7VFS2pJPuWZqJ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX56FAhdR77lF5
 d5lNwiFYg7BYrZIg9jbofifdTUHUPnQB6KbPHFXhrTQ0o03wXnO1TnEphJIcaF6kGn7mKgyXL5T
 TufgOWV6oX5tqKcN4Unr3QI9ESHtEWA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010035

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

