Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1758566C7B;
	Thu, 10 Sep 2026 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063069; cv=fail; b=HH6Uh7FytXFBmYofOQv8JSWRS6Ji4bW8kGZiJiyHpNwAnAzqCDMg12/hZOyzuiJ5xghes3uf40KOHsVrWPERb9N4wX8+NaKpOYhTmxjHghZpEitMLj0chrRzFaEvm+NfQ1HhXv8eh7mKhCVzqPpC6dO4duQfaavjngLwXflqDeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063069; c=relaxed/simple;
	bh=rMIHH7q1HiGvJljbcET80ADog5KoEWbz8PeiVhRv+ks=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vBqOWQwaPSiA8CGPb0zzxPb48+9Cfie7VXGUSUZ2xrHa1vLeaWSwKfWsy/7pUJFF8DtCTFDtsqfGwO5CNt7YqnC9L2BWhElIBnnlxYxqoHbHFbEwSHnooxLarBfRD9J/FCLUgCNZYFXbLSkurkDGC/5RakIxyIBCMn2YDFm65Ns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=SA++p9kJ; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=aVBuLdxc; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="SA++p9kJ";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="aVBuLdxc"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68AF62ka1430994;
	Thu, 10 Sep 2026 12:57:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=6E/G/PUZN0NxwZbEDin4ADqQv2DLFI8Xgpfze4sUr
	Gk=; b=SA++p9kJ1vmoVLTtrHVayKV03fqhU20sTckfm5QbMVeOXsmccIcyrekw+
	FYxWbht9jCwbjijoSfMknjH38GRMZLwHmxvM2Y9v7W2ASSCcZ2LQkn9aE+2K/M/m
	DzrDY1otV3tyrQMwRFBjbcPorpOzS8DtmxD8UTQ84FJUrAsBA9kFmrYzM/Z7aWmT
	/0ZWVfD/iSXOX7A1wLuYjXbFM2Yv+/Di6UBVpolr3vr/4T+skuI307JIMK1B/luc
	MfYSh0iDks7GUAsyDvQsEg4aWYnJXyY17pLmlBexw4W4Q0dfd82jqHmgGuaciJtq
	B22Bbp0/8vIdmJPU0wy0r6AjLqjOA==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010025.outbound.protection.outlook.com [52.101.61.25])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gkcxgfbj6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:57:41 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oUd7AzVzeb3dmJjOgxeRayYuea1fGg2SXQv10kuFwZIKfma/9ygngRD6dmibQ7ehvcWWJLiXMRMo3wTtILmRJDG36TfFumg0YdIep4HcTRarlcGC0025rcwSpfR3o4EQDk+XiOIwVyHF38vCjR/TGeFBGi5PJKhwuly4ZrUoo5we7oa81aQIGIJtICkWKnxxBCrxRGZuFUh4VPIAXxxVStLjQwt5sbEmdgXcYGtZSbG4IAk8rJdXP5vEPI57yQfByF7eUC6Dqo0UwnUvDhnqOkhKpvBCM0U1xqUFNcMIsNbGktMHdjI3b1SXmd84BuzvT2c5kklsjLr+rSTw/HNNPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6E/G/PUZN0NxwZbEDin4ADqQv2DLFI8Xgpfze4sUrGk=;
 b=xtqEj3xqwMjF4nEDM2BecyQbvPUTyzHXLvS1YvCXvIUHxKe2UYHcSKfWtxM05iB0t5+V0xwfnljZIfwwNBYvm0E60Q+/9AUU2bplMlV3cXogW4CTlAmPZM5G1yqpaxaFLMeNXMcT+AAeuyiB84q+R03Lpue9CrpD67C2TyQyZKY8hEMNMMnJgBcmhg3XrknIBAGwqOByGC/MK1PeDd4K6fPBTx48jXuLzUBnfAX9ngnIE+zojCCbY6CxOXMxUqk1+3C35J3hoeR/EgFNTRAOw0eaBjnTPSP4oNuR8pA4vNQqhT6pEnE5Qq+bkIf4gqXH6/cnaCqHL1mL5gMpyrLMyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6E/G/PUZN0NxwZbEDin4ADqQv2DLFI8Xgpfze4sUrGk=;
 b=aVBuLdxcwj+esPIta9LPdsvhrVmRUsDBjXDyM6Vwp07ROmOGiKZTnSrXu0guytHRefZdCnDb5NPbSVc3MZxu/dQ2y3pLsXYIJ/iWY6STzrMd7KSbBso3/6x2rGYp1E7uXanqKSzaoAhS2e7wELiOUKwJCey+8Mo3h0qLJ52KxFk=
Received: from MW4P222CA0011.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::16)
 by IA1PR10MB6052.namprd10.prod.outlook.com (2603:10b6:208:3af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.5; Thu, 10 Sep
 2026 17:57:38 +0000
Received: from SJ1PEPF000037B4.namprd05.prod.outlook.com
 (2603:10b6:303:114:cafe::50) by MW4P222CA0011.outlook.office365.com
 (2603:10b6:303:114::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:57:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 SJ1PEPF000037B4.mail.protection.outlook.com (10.167.244.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:57:35 +0000
Received: from DLEE205.ent.ti.com (157.170.170.85) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:57:04 -0500
Received: from DLEE207.ent.ti.com (157.170.170.95) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:57:04 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:57:04 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHv3UI3763975;
	Thu, 10 Sep 2026 12:57:03 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 12/15] crypto: ti - Do AEAD software fallback on only ENOMEM
Date: Thu, 10 Sep 2026 23:26:16 +0530
Message-ID: <20260910175619.2122149-13-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037B4:EE_|IA1PR10MB6052:EE_
X-MS-Office365-Filtering-Correlation-Id: f9103171-4380-434c-8267-08df0f64fe8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|376014|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	TZEs01aH5SI891U/t7mN5+gNaOdlUfk40EsJsF0l/gKMUx6h79sO8mMqhfD6oE5uJY3WGVSeFYsDGzkSK1Ser5Hs0j2kb90NFscSPRwS49XaP/PGCjFZHAcImNRzIPkK9q78Rzw3kWE86whT12XUqE4hnmFBRL5qCyp7NHLkb3HbZfYboYZa7rII+56n8FJZ2a1fZJBdKfMSZdQXcojhAsTNyuSTN81K/D7P7w+kt9efLCTMtIX+lmJW+OvSmpUnVKQqOzPb6jQHrQlzuOoh/pd//0woxsc0ClEOGEq7qPdavMF1a66f0NzDpSRNgolQ7ajKSKXILh/jtPpNbH5I4Ox1lC5RmZrIYGFZ7/HEVXdJPmlxcWucKWcLMvTF4px/69BJnmjUdY68ZzI5YU1z49O9D3h7DpsYrIMHaljp6RuiHw5R/zwZZRS9eYh9gfHmgjWXcQlYBF2a4N9LH/LGrqkCV/9OoHTWYmqoMJP/TRwFkt8bn+keNU8txLBLPPBXTtYNcE3ORaRmaZB6pmIp5HHLZ5ULb3oj/xWyCTuWwnv27Yuq4LkHwRXtjvqubw9yYP+owfHTef7x3bzutSHdtqh6t1gzy1Ri7ogNqtiw2Kzo7MnQp70YwEETyb52Hkvza4knmEOTlhl53t6R365hUkfaH/H+xcGgENTPSzAoe4WSDyM3sAWh2nDNM5niaqJq8azrXs/qfJOyW59jMPtJLg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(376014)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2aUol5hSRJ8R/hSGfu1X2SPFcPaveIkgrug7UndPvYGnpFV4sGklHy3IRvwNDs+Gsmug2+N829oCcUZATZ4MvOdKpuFvpELZ64T5EO5Vr+xNSJP9fbsWXc4bXj2JdllbThahLnd2awk/pWRjACksixPEDSdTm/O/75i7XO4fFnp9xXCYxsF7BFwWgF9D73U0KDe1x6ZqhC7SXgdopTNCKVwEn4TtmXFMPo4zp+ST1JcELDrI5Yay29ekxvQvVRsKfTXWkWFzyA6xYTEx+iRoDwyy+YfitNI5/JYb8In81dK2uUq3QvSjFb671QyyP0kBCFJ3h4RUcb8+sUHP4NlOazGZyEbsmqgHKZtz+j3QZadIlVE+Db+n6NDPN3ekJPTrCKK+VwjcqDrg2KYXvIN8jraPjYk9ICowEwnZwZAspfDLIvw99cHhvwUz+L/n/xWb
X-Exchange-RoutingPolicyChecked:
	2FV2sBAVi8iSOYXWXrRhNHHWduXS1zEb6RU9g4DgDTb2Xsl7IH/D9lSWxSAO4OqtG6icZfuXUgM59dOIQFznyWY7nk8QTxchSCoFbmE/xeOSlBCbGHyQ56mOaOtUPJjeJohsHtyslJswVeCUGeLbFywoT3XEnqFFLLSpRorCzTbaNAdIAQFlbPzOJh8ukSYLC66Z7pc61vSs6xiaizPzXpT+tt8Ddr+VADlXPUdguiEnxR2OQ5eRqF84FTmHtIdlQfFXYT2wWf9+3C3xWBmmJYQOImxd4EKBAlppjLZ+OvDbL4e1bSceKdhmoQUB2AXYUcOgCibL53Sw8gV5sXMu1w==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:57:35.0313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9103171-4380-434c-8267-08df0f64fe8c
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037B4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6052
X-Proofpoint-ORIG-GUID: ZbaQYmSTJKNUpaY9feLqFHN1JbY8mqR9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX4jdyj50aRfGa
 Sc7lwz0HoVCH3rWAGw7DTnlvq1oc8BnA0P0t3wyzW8Q5QhbefNuE2fGlwlHMND76xHH3cGxYUZt
 xeVXSZMCd+9qVInHh35eALZk0CfvH/g=
X-Proofpoint-GUID: ZbaQYmSTJKNUpaY9feLqFHN1JbY8mqR9
X-Authority-Analysis: v=2.4 cv=MqbHeGae c=1 sm=1 tr=0 ts=6aa2ef95 cx=c_pps
 a=vcXwJhCbSog8BousImPcCw==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=4oUWx8CZaJwu3DmIChQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX5SN/9AUCAdHE
 2yY7dCI2d6cFmAeui/pvrOxP6RRunR3AQ8vFbtvCVeoAKe1MQZnUGL4F7e18vmSfLlzylSUP3NX
 2pQIVxsZ48Aw6SfnfIX3kFlGVhVUMNJCW0MPNhua6+JSUFMj8fB2UGiMx3mGHlH5xnmxQDrwMJS
 heHseyk0xEP86AvXa/XbP218q2cnzS87u57iVV0aOBNFaHRHD8iriQSZUtMkZAH21xWqKXG9cyD
 tPaPDFrmtfGAbXSvD9kdVf3vyxsNjawMa7lxaa0xDWSV/VrBRMpNs72kirtgDAkBfMVNyE1Vmba
 aBmBHVvr2jJBBAWsErKaMBvw05bfNleMHz++5mHR7ybIujnfBI62VpOjtE0WSC9BEwxAUdR/JAE
 2LM67Ql/2LN8OheJRbhvdbATEzy9CWd3lm04LzyrBcrzxVhLoju4ybbW6YXyp8DkbM1NEE5i+8n
 gkNb3k5/6yO6b7FE7Ww==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100220

Similarly in how AES part of this driver, we are falling back to
software when memory allocation fails (we get -ENOMEM), fix the AEAD
part also to only do fallback when we fail only due to -ENOMEM. This is
because we are doing memory allocations with GFP_ATOMIC in the beginning
which might fail. Any other failure paths might have modified the data
or buffers already. Doing a software fallback on them might give
incorrect or corrupt results.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index a034c1c8f20ed..150ce65f613fa 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -1173,7 +1173,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 aead_prep_aad_err:
 	memzero_explicit(rctx->padding, 3 * AES_BLOCK_SIZE);
 
-	if (ret)
+	if (ret == -ENOMEM)
 		ret = dthe_aead_do_fallback(req);
 
 	local_bh_disable();
-- 
2.34.1

