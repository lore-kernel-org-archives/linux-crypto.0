Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448AB4D0CFD;
	Wed, 30 Sep 2026 11:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767622; cv=fail; b=BxTuqyTAGa6LsngXB1XzXFYmbzxPUkxXsN8EE2spqRw18G+YQxPXjumV8xRghxuS8JxLIcS2KomOJZ2YUNUAY/kn59MI16MpW5tYpbRWbDWjpHRmnNVDDkq69UgDSic4H6MLepyEVVs+P+3D90mfZ23ow41zOyH94RGxRNSPI10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767622; c=relaxed/simple;
	bh=lCNQzFK9UJ37Sea3gL7rPWFDv6GNWE/ObV3aC8JhLeI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g2Z3YUoMQ5djfz+taK2hrz+0JlrnRRmovsvfUWer/eex6jvlEcT8RmmEvHoFhMUVhgthBVMQCmTw+DF/+MIkf1WBUAYuJJZdiMyLTC6DIfAFlInEoEbR21nHTgp1GhJiFGT7/GtXVfIm//hmt92RPrvSaCRGCumYpeUeMogoPvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=HJYQ3Kfm; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=I6+xsVor; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="HJYQ3Kfm";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="I6+xsVor"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB61ZC3214139;
	Wed, 30 Sep 2026 06:26:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJP
	dw=; b=HJYQ3KfmyZVjKpP30Quh0pH8aYjNvkQ0q5UcpzRKxUccp6Ld3goR69Sox
	LToXaBrZsGB0WCUTRuh50qqzv8HpU429I4zH2/+H2uw/9cytrydBYV7RflOoArfI
	nImCgpUa6Uuozx3HYgXFJaJ3IbQ0FgDW4Yj8p848PzaA8pzsjR9NO40NKYnpAvKi
	WboR9P+lFFpqES8uuKeOlLqfE5PEdZXwb/ndNDBuCSoupTzm6xTLF8XGvhAwvfPx
	oo2dAjrJdvuWZDt8TcobwckmEAiVaPl3Y4vu5SYLz8Dw17Y2VtGRXsOv0EqjhMl3
	vzzAVobiDGqn8y/IaK/1gLSS1bdKA==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012015.outbound.protection.outlook.com [40.107.200.15])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0ydv8q60-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:55 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=reI1ANa4/8V+ufFBKgrVM6l3KGmqW6wxLzPa2cdnBv2CHR4iU28BZgG2YFAhaTT084B33yq2irQm2811RDUfKgCYaJjKgggumjThlqkt3PVAuSsuO9zaR0tfrW3cABiiU2QYMCS+SgDghlyz8gYVhkOcAIfFCYeQLaeKvIw28RQy0FHJI0qjygYvfyoOCSEie3+A3IbYBPawKUK09b4XxqsFsP62N66zHR2jUxH84WgGJItDfEqbi22Byd+S67ek4ARSOsUWddRBNWraXL+aB4CMW/6koBaZOXMpzhA4wkiFwpKRRd/yePQJ03ykfGuK4QFZp7mfxSyXvX46Z9Z4fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJPdw=;
 b=PW6fWb0Cbao4/l9EGmD8IrF4VD8plaQjNmW+DIMYi/yrwRLHC9hIKG+vP3jphoiGopFRW7oDTyGwenxCALWeoaIvZGtF1Q/JiSonWY+gyeoTRwW/3gFdlaL6pk1c+gtctwWc9jSL18cFdhcrFnClUl+ROay0TKASpDV/kM8GpmbWbm2920yL4uDz/kgRIbbd9bdfHU+PIwUvnddZ9wZ66jGjftCHTd6cxV6anosECjSy8LWfEoZqaB+xtMOwIb5IgiTZRqeK/PBqn9ShWaNKcb7E/gxeov6Cl/B8FYRpHpcTuk3VdV4h1wSsGBiPkWzWjdlWpbQXCnc2SQN4kIxotg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJPdw=;
 b=I6+xsVorRoW6zNylIdtlcCwFqH9F1QmpUN7zVuzvvQC+SLHPlvSjrGwnbFM2V2mAmJ9s2OgHLjbmkNbnpdcIrshWXz9bq9gg6QMSK3XVjm71bw85hk+3wziSdpQAvdHMQE8dH5UMdzjBkFI87H+XJvGQFGfCASQuwxf22Pfb3oM=
Received: from BN0PR02CA0018.namprd02.prod.outlook.com (2603:10b6:408:e4::23)
 by LV0PR10MB997638.namprd10.prod.outlook.com (2603:10b6:408:346::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Wed, 30 Sep
 2026 11:26:53 +0000
Received: from LV8PEPF0000006B.namprd03.prod.outlook.com
 (2603:10b6:408:e4:cafe::78) by BN0PR02CA0018.outlook.office365.com
 (2603:10b6:408:e4::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 11:26:53 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 LV8PEPF0000006B.mail.protection.outlook.com (10.167.248.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:52 +0000
Received: from DFLE208.ent.ti.com (10.64.6.66) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:14 -0500
Received: from DFLE206.ent.ti.com (10.64.6.64) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:14 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:26:14 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBQDOU3970015;
	Wed, 30 Sep 2026 06:26:13 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 12/15] crypto: ti - Do AEAD software fallback on only ENOMEM
Date: Wed, 30 Sep 2026 16:55:30 +0530
Message-ID: <20260930112533.1593952-13-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930112533.1593952-1-t-pratham@ti.com>
References: <20260930112533.1593952-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF0000006B:EE_|LV0PR10MB997638:EE_
X-MS-Office365-Filtering-Correlation-Id: 57e838f4-c2c0-41df-c39f-08df1ee5b9bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|1800799024|376014|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ALL/Af2mkAbGDb/eWcQmRTECqxjc0bAV7U3fjusdKQ7p2c4QZHr0uvrJUX/RBhOypvZO7AclCP5wA8DJ1awEF7lECpS4Gs1zFoAG6o2UrlQkbj81HzIJdjoSSRuluHM3PxVaXKfzI61GnZJpoJyz8sKs2db+C654umopPwEUCNe/kVdnRMvbqVn51bsZ1kCRgRE/rOlfu4osAvWdf2u98kFs7Q8Aq8jNeFYRRRAnPIDs5ni4xpf+oRn4O7LB5gobEyRYFkVO7M7XGk/ItnG+8Oh2vY9jFQ/qmE6qADXIna9f/H1MMX7AEYJcCVKLAjkN4q52zoB3bTcCITyyTRiGhJMqa+0PpgZSD3PLohcH1i21AFJ1xKqyqJcm8rjlehaH5vkzkz7TWnhpj//5916rhbJZWboHfz55TRbVm91jXP3wA7oFj88LV1W1kReXG9UEIKMeMkDopTXYuKnyHsI7qWbrKxXB9mbnK+lK7+xxEn3uDDdDM58DlkeapUbXSPoBgKkbM2in7Wjhyej4PYN0Gv+IX5cC/52ZHMPgT7HcXDwTEf6hiZL88zYH+gIQRTxAhzFONWhHIZ41NdgcJXGmWA89vVhly9elbuFJ09QBIOaFs6VixQHc0pWF/aurzCawMzV8Eoi7eoDi3kFb6lx47P8zwsWPFvSnCsbQOtFzSrEZ0TD2BVSWfaQGGO/Zyur/CxSsgSYKygpdoFCHWq577g==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(1800799024)(376014)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rQn9cweEXFQl/QX028T2ZEBuecc7QAFRzWc8SUwnQaIu0bm26a58sphTv9Oft97EYWFvbcd/Ms2mLpb3lTFxksLhxS8jxPqDPdYBAnlzSLzv+FAr6dpTeuCnhpUpXEBqNE+nSVwXvyDiHDlFy2Nw0MvvmV+RPPfxfEexEWPpt9TCjElSDPIvGrcTN27cHUPEsEOO4XySBSTVDjMXo+tnZhdtLiP+mwxcuVaKRtsO1SvH9EBaSe2+JsNtGmQwuTa8kcUT3a4DU39daOCkET8vy9W+KpriOR2hNsdFBHcNB9FziYzVm8kV7Wghz39HqJmfF0h/0E8NSt3bqLJ7iK/jVXX+PnFe7a0EEvLHva/Tr8Hur1j8iYgxYB0W50JHO+uAG19ET2NfZE9dJdE//8K4tgZxZCglhjcF1+hNe+avBMqtxKxNDOAL3mr62cY0/Xq0
X-Exchange-RoutingPolicyChecked:
	sMBxpM2pmXCMbyFRgYNNgqt64yfqYqZteFkxFszXt1KwzfIl1hsyRw0qPHTqWXxKaotQNbEtpIs0KJXbl2Uk7VplYBEu72WQMsrvxZB2asyFobZ9d38I5P4Ez3rE1i5g9/ZaKcQs9bG8iNzL2aGNVBS9RWFd21RlaFr6LekAjt7J9HlC1clSMIO/P7JoGD34ZAA52WwWdjLZLsgdyHwHSiz9/pGIQEpnoxQBoBE05DE2qEn3+u/4Cp8xBuU0VDjb7LUN9aLtxpdVl1zjpWoQmymXotMLWG7Lnev6K/uO/DHdbTlX10CsCnN8RMXq0yWPavPrOWrVAlEybElJsGUA4Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:52.1281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57e838f4-c2c0-41df-c39f-08df1ee5b9bc
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000006B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB997638
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfXxP0e6mxkBbUS
 p59DyTnsZwXDB0J8aiT6BKsrH0vwBcfz2xnY0Id5GWzTadqUOGF3WFQPeRFk/7CjO0HCjdzduvn
 X+6Hyuhfn+4GrBGPbmbtj861mMOZ8Hg=
X-Proofpoint-GUID: ao2tts-Mbf-C8wx5k25eJTGs_AiOctG9
X-Authority-Analysis: v=2.4 cv=TegDJhQh c=1 sm=1 tr=0 ts=6abcf1ff cx=c_pps
 a=CD2IJdD5qp8L8UJuiUkm2w==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=4oUWx8CZaJwu3DmIChQA:9
X-Proofpoint-ORIG-GUID: ao2tts-Mbf-C8wx5k25eJTGs_AiOctG9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX7TnRgNO0M6wB
 6J0xGTv5tnGecHFaGN9gyxoTuvBqClrHcuCA0KVGAq/SXwhQoCKQJeiPXY5oyrSIye0RLrf/tlD
 sLRBQukAUmFpUsxT8Es5yfgSzB2P8Yh0/5qj5Q9AqMWVsmyD4jsS9OkWJMeSlp5EVourt2t9kI3
 Mc7XVwiqgc9eAHEyv+fO87AOgOpGsudisX2Gjsdejy9eodiSFwI+dLaK6GfEgkuTPDvua7brBmu
 9QVg3N+CLY+gIf0FIjV07Cti9O2Xfr1Ru06edY/2esCq2m1xGzrPITaSjDFCZR4E8XKJZ1wQfpG
 pVRfi6qfEDoI2uCN++K09F5BfnLNXHN7qFbIsceRB0Ru92ZF7FZP638YiRO1cXJEzflM0SAEkwx
 ddfbrZY4orDw/2oNXQr6DUz+BvhpdECZu3rY+Sf3ZeEpKPj6I6sZKKRieeHTf3QCXo1Dm22RG0w
 NeuKgY4oRmQjW8yNfvA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

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
index ea6e3b246ed1b..bd26c3f438e34 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -1177,7 +1177,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
 	memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
 
-	if (ret)
+	if (ret == -ENOMEM)
 		ret = dthe_aead_do_fallback(req);
 
 	local_bh_disable();
-- 
2.34.1

