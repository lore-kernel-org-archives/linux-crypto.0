Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354BA4E532A;
	Fri, 18 Sep 2026 10:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727042; cv=fail; b=mB30w6iGYG/mtP5JXf32pAUQvd9EGQWwMoF9cjSZKT+chl91aGkXeMRqWVh+v68DaEC6UcbMQyhnGF5b2GUUiySXs7aT5/B63Zln5/SaiUqkYt27R8/4EdCiSpxLHHnaUYB/8NQARi1WLBG2rWsC0/MsmHIO+hWf4Xxfbksmfwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727042; c=relaxed/simple;
	bh=L6sJTGbxYKzCcew0gputMowl1JIkjqKkuQGwSODlbjs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l3IqGavDcigAhq2DgBPlU6Tc5w8viYHJNxM0lmPR0rymbUR7ORUlrZ/5SKhzFFbBHKfTOW7YW6gKTq3tDuGAQleIsKcuIeHglh6/N/SanwXlb4caaHtDxNgmXWPFYGMWZFf3JhfEyOpy2f2G8qAWo8HpcMR4GEmSfGCrZPsUlzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=JpQVrEI2; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ebctatI2; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="JpQVrEI2";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ebctatI2"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I9eKiL3768408;
	Fri, 18 Sep 2026 05:23:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=1XOuYy4Cz02k59FK1p12uZ+MgDqx6sx09AI8IDLaQ
	7A=; b=JpQVrEI2uw4szCGuuQ3oxAkxE3gQwLHGOdtAzgJCzSj+DPyIAIdT4XjnD
	82K0xn6EAbGPV/8Kk7dqG9BJUQYMfq9Yik6QRe+IXcjifforVPPyY0J00iFyIl95
	chq5z/vb9NbaEDQTjCu/Gg0OWE4dLa0IFPHaYI3OkkMSXD1OF1oZQLRosjWIvyCU
	9ZGOs9VkVspUlLMfJuFz6gjsCZ9K9djx3Ozo9d845whxVroShFiqbXgUzXeGzwrU
	6iKvZ5UmL8BjMQTq20cu7RI/ROsIiGj052yhmMLlQEZEAQMyaqekRscYXRaykDYT
	u/ihjdfud6aCpC3uMDvBzdrCJSW2Q==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013065.outbound.protection.outlook.com [40.107.201.65])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gs16cgsny-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:23:57 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dYjeosKYb5SW+MvOW3kQjuXpQP60GuEFhTSbBPPuqcdLbjQwaf6+kZJH8KiUIu24xBrqKZbrXQN8zf0NfzqOlJ6BzpAkUziR4PKiv5Fv9dCBMQWeufmKCcWS/j3MRy8rIY4HBpECJDksMnbMqlx8jYwjsqf9LJXz+Xi+7dCY6p0KsYGJasvCX2IsLDovcL0tvETd+G/G50b4JoCzITYCaxsR8cT2QUXFhF26Fkrj4BMcO3Qy2Z9dtfNTzvWXNHJQFyTce40hOi33BntcOnK5xIK+2cmu0gwpZDe97L9qF8nRyQcdjzLn6s+DSYEmr5lpb0FFezuCQqjUIye6ZBdIQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1XOuYy4Cz02k59FK1p12uZ+MgDqx6sx09AI8IDLaQ7A=;
 b=TTjSIZm1FWjnf2xcmORxJP74Wfotiy7tkXgJWxcS+wxeHp0vKVrTcuuMGUX2//x6LCcbMOzxs6054cISCPEARfXfqGN5Rg+6T2MYM7rnXg74WUNE5WVJRphfMhiYuP4KdfpdYMOe1CuygzNLbi8ax8IBu3VR8sdOlBj8Z2VtXOCNRqlTW2S7EcZmQjYHoOHhFMl0R10YSfERA1tqA8P/KvXZBlSbe4/9M6Pgqzq3UWHJoMDiG6I1qaX2TMr588slavO809t68DXTlJp7LU8jduI200Yd4GT2ZoUNMlXWNiNjNa6NXgWjaksb2NpPChT2EDVzQ7ptP1vnsUyLwUSx+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1XOuYy4Cz02k59FK1p12uZ+MgDqx6sx09AI8IDLaQ7A=;
 b=ebctatI2OwybagQeFogwpKFVqkV0wQtfNlxBeOMcwE2yMqu29Pw94Jg4wOR7eRHgAD0I1gJypWDuINQtRLbUWP0XvWSmTzFL3J6i42iFyuKoDpWZVPf0N+E4u5BqLwu6aqKhnnW0FDEzPLam++oeIj91plC1/SdkKjbCOW7IDrc=
Received: from SA0PR11CA0003.namprd11.prod.outlook.com (2603:10b6:806:d3::8)
 by DS0PR10MB6917.namprd10.prod.outlook.com (2603:10b6:8:134::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Fri, 18 Sep
 2026 10:23:55 +0000
Received: from SA2PEPF00003F67.namprd04.prod.outlook.com
 (2603:10b6:806:d3:cafe::50) by SA0PR11CA0003.outlook.office365.com
 (2603:10b6:806:d3::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Fri,
 18 Sep 2026 10:23:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 SA2PEPF00003F67.mail.protection.outlook.com (10.167.248.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:23:53 +0000
Received: from DFLE205.ent.ti.com (10.64.6.63) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:14 -0500
Received: from DFLE213.ent.ti.com (10.64.6.71) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:23:14 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:23:14 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IANCZ91534551;
	Fri, 18 Sep 2026 05:23:13 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 07/15] crypto: ti - Separate padding buffer for src and dst
Date: Fri, 18 Sep 2026 15:52:37 +0530
Message-ID: <20260918102245.2784000-8-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F67:EE_|DS0PR10MB6917:EE_
X-MS-Office365-Filtering-Correlation-Id: f3d823b1-8727-458c-15c4-08df156ef067
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|376014|18002099003|10067099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	XBrboBZWPA7kiyiD6YkmSxNTHtd9VICl+49oVkIUS68xO5O/+8/RYLSNM3VSWk16vv91JBAdC5ygSit60OZdhVYgXxYyADVms0d66oL4ULpSRmpagJFy3zpv2C2jPHNY9e7pEjutZwlO2e91rQinrgB+ttkFirZWA4m9ssJw+zVUwFoOEOoRdLQUZMM8+YoAWk9fghmtlnFbwCDnJZzrXnzzkkpaNIy9WAxDcJelOVpAmM7a36wZXnzC5M6nW5E0JBxagFZon/n6m/cJh9+axuxxwYSRvdOxr5/bziG/vo7+XHm+jqzYWJp/Qr9XeRSvTScrGIjzTra5m6UjArzS/3hGXT14s++HuDtheCNGt5Ako/HsEUgFcKn1aN+5f7MUxZX62bfsMNH+YXylmY5hrKVyeF+nWsDxd/wl+H/SEfsV4407lQxMG8j6WaWhlCoWdXq+lFY4DJEkqdDeQQqcenhOj6pCFTDZ0Jv/uaGffAn03Juzw426N/xSJZZOzw8cXO7KhLxa2gY6LRL0BZ1c9FZTDjV2f1PdUy2Rmxd9aX3ic9+FLxjDs5NKelf1sjLX59v7D5FUrytgJJW077Z4zS1ts2T9nGsaty3AvFLmtg7fwSeJ90lJmXWsxRqiuWbQuBmRY6/L99fAzHvmPgzu7eu0gcy/Rkj/gssHaUFOMQm9Ud1x3SbkRC6kD7W418hJUA/Cv2QTtiCTHj1vKDIVaw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(376014)(18002099003)(10067099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tM770uGD3LSE3qS0rwhu4n2nt2Z48A1V3lDFLKyWCcgzNgw9F2zF/yl36oIq5RBnrBMd/Nk/1hKGbT9EvtON61nhZ/pRb61f1cJd+sks9rVbPKI+O65qwSUs0IzVTYqSWIeMXVPmlJx4KhQGzRSlkDzr+teIP8BpLTlrJBea0iw7q9Mbs4r3cjESpiwV0QQ1jQkYnFzIrgUuvLYB20CXWh9VJBLhXxV1miA2J1w+naRfWUTyVPdUDVFQ9EkvJq1j5vnPeIIZ6nx5lCSsSKkWJlWidNccirKC9uPnUFP8S1w+ToAJlrogNLnjxXa4rGKEH2zbWCL/8GD599kXBYsEDapdl4Wa5kzqqHYpJHSHrKFhfCR3KQN98lLU7+/pKAxa//lyGpgZLlah4FSxbZfrxUQobqjLBoOfHmON6eu3POU4HQgBjSGx1M77k3x6FzqE
X-Exchange-RoutingPolicyChecked:
	25BlGp2SgAOSdzhY0g0EqZWW1LDATEV5ev/7p4De6ODUa44m91RxPRcmZnAYZQrUGdOv4ns99uu36x5H68tpUiDZWCuG2yt5p9sQD/tZCrqhjU95uKVJMz9oPeL0gCUWf4IVDrRkWjwZiIjaXoPzv6aWFVt3eR0QICXmCWec7fJeBy3giFJ4GQ0IhQiZlTODA4vWgW7cImDwsBABqpi5pGX30k6xiGwLDqg1AEkbDnIV/o3l3IAU1KAcwis72qLzgs8Om8qMG0XCOBAR+Vc+3JZSeYluSb0FI5PAjXpSwFsxj7fjwbJsl6ra76OkSDr5Fcp0l08S4O7za4W34S+qGA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:53.3077
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d823b1-8727-458c-15c4-08df156ef067
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F67.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6917
X-Proofpoint-GUID: _Bo_69j-A-qWOhn5rbf7MOIXG039Mu-1
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfXzWxhTla3dsoz
 00medh8k/vrSuFPH5wIt0MrMMVIKC2hM9/oGEBl3E5AO9cAiWnvbgX0PCexZhF9yLmmEpwDlEnd
 aDwLsDO2w4hLXfQQmlVvJGzGOdt8Rqg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX14O/D/wsWDmg
 DPGNGlRaZl6kZZ9hZZkryOEKSdizfTczAVLp95t7CP3pXM1aPvzlFBqzrgDNAI/bYvFA+QFdEBb
 NBPv30CV1sNUb0adIgwsMl4nCOVDIQB9Wl3QN72aDdc4tgmVyS/wdip/ysDSdnVrKPlPFmoCcgO
 cAbLvVfnw2qmnspvILAl7l3WPXRGpKyjUiLhIO7ijfddPaYo/RK6GqOT+VW6DsbZLskvqL7wV0M
 kHVcp6KXe1KUCmcbiS9a1n3cm+PXP3VaCwOk3wCqdQ2f5T6067wjoRbFJ27Mo/OoSSTRzQxfrgn
 FEv4mIhbmGvKK7jOuF5CmpMtGnRdHW93tqylk3dGN+Cj3PCLP4ylLEewFVi3bfEdTQAJ+sgEB9W
 4Y6ik2mLAxfnAxWaEt+UP3hsfONTmDQlZly3lEm/jMYD0wG9tB/9QiGWkcRmmXFdpw3tGwN60z5
 q4VatrJWvjfw1zb553A==
X-Authority-Analysis: v=2.4 cv=cKh1IVeN c=1 sm=1 tr=0 ts=6aad113d cx=c_pps
 a=GhmtI3pHzNGJg3++3mR9yA==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=sozttTNsAAAA:8 a=pcghVQDwmu1mgjzKNFMA:9
X-Proofpoint-ORIG-GUID: _Bo_69j-A-qWOhn5rbf7MOIXG039Mu-1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

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

