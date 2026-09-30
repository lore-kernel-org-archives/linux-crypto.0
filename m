Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1175A46D2B5;
	Wed, 30 Sep 2026 13:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773229; cv=fail; b=u0Dw5o1cTmLnpLp5stsKV7zVQyNkN088Q5eTmZ/zbZsNa745wNIg7VB7sKtVZ1UBCCfMIhkhLGDslBRKImjqzEhgdzSxoYsklZF9H6ZGvio28HL6+qjYQP24R2b00MpbDZELWtBFdKQqX7/GtbpGykPXaUrQxYnf6kJqTXwCJkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773229; c=relaxed/simple;
	bh=8VrYPsT2wAEHmqwJVZKMssc8/7YEcili9xvl2vVGykM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JvTi+ZFZoYAnMY/DtLRCnJLjro2YYYT/S++Kx6y2dMrLhQReHj+bqYpId7QmBybpRElie1hwzSy4NAgEkY6WDGpZnHOrRjcyY1ACFskVJog6BXRJ0maF8fQJXDAlIWzNAQfBYhztpPQp1FWk5f913dGaMRPsiM8sZir8e3uojaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=V6gERv8s; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=e0r+ejq0; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="V6gERv8s";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="e0r+ejq0"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB5w5q3214062;
	Wed, 30 Sep 2026 08:00:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=AtpIUdDZEZD/Bm0pVrz150bjblaqm36uSHPtk1W6s
	64=; b=V6gERv8sdY0NHoP/ip+HRM14xeDEc+CkurJ6S0f8WFaiOxhytOtvQzJ/E
	vqx8c8I9bU76yPHxWe8gTNc4y19f5cWi0ASoOMESaYEZCYi4wpyM3U/+bKJ0NSM7
	mqXFqKexHMmPujShq7SlxcohD4z5U1Ib4xpxaHiukbsyc27d8dMzzjwfTpP8J3Ik
	rAu2ppjbtf+CmlFDvu0qupBIzLzUxMlxSqTuW+xFYdk4SImR79umG7Hux9p9lYVw
	+FqpMJoGTeBvyGxwLPLbfuyPem22DKNyTTeOk0a2XfiEENMDum3xbjWr0TkHxVc+
	EZERut/Skl9LEHPLvGEgV1U3u8mcQ==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010002.outbound.protection.outlook.com [52.101.193.2])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0ydv95u6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 08:00:11 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gHfDtOaCaW0Xb59ULgSkK0+TqvE8hxBJrQCj40XiWnmVsQI6x9BfFj1GpkitxdyftveX2PZemMh5CYbAAOO0KYN4ydLsXX7crXSg4/CvJAPQr5PIYeyqKh0D6saL+UI5t9ADg9K3xzLsCfjhTA+83wCAk0pLYk8Gq9cOMO5WLm0bWs5qbdErrke0OTysPBrycbDbXO90oiqWq/WeqF8IPYp+pOkL966/HKjCu4GPIbgcfPWknYNPcUHy5978X3XOG7UyjUE+0H6CmaySm22sZ918T/pJBhuDnURxxCH0y3pQd8mDExCtU2e5HvOezjAa1Jj4phfmwuJu3wJj4oJIbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtpIUdDZEZD/Bm0pVrz150bjblaqm36uSHPtk1W6s64=;
 b=qpad9ngd7c7oJgnXdZ/f42yNCdSnGwkRuUBGCDybQmHnP6QAT2ojpFR8XNpmV9jAHk++AbgpbqX/1aHOE435WP0EaEtMt25hCvQ24vM9ZgCTW05GYS0dyJAnI9jis95byNQklpOaotxohPTonT8JVAuMlj5+j71YEKAk5N3SdHBAryGMscNGXviBtqvdYlpWS19SLnPuG8U32oqUwIH2+N6sdxPz4AhY3TvLDe+NgFL3JGJX6i1KV7gBufeSD7jzoN2XkRvmWiiXHa4Td+XMSGULPClK55D7BID4F2dNypLwFrnj5DTiZlxP9oxX5RqavZHFA/OCdKV6DEopI3/cxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtpIUdDZEZD/Bm0pVrz150bjblaqm36uSHPtk1W6s64=;
 b=e0r+ejq0NGDZKMdVyS6UqdyHi9Iv9f69KJJRr7MQEIBbzaBQB3hXnJ/7wQpfvGa7cn9/KX2iBOnDfFnDzFjfga3maOr26sThpeKzk7EaCydNtjg8YLxjoK4v77UkXyJJPl69Ul1BBX9gYJ0xq9emuhx+MDGfuHxwCl4vPZF/aKU=
Received: from MN2PR11CA0005.namprd11.prod.outlook.com (2603:10b6:208:23b::10)
 by DSWPR10MB997934.namprd10.prod.outlook.com (2603:10b6:8:3af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Wed, 30 Sep
 2026 13:00:09 +0000
Received: from BN3PEPF0000B078.namprd04.prod.outlook.com
 (2603:10b6:208:23b:cafe::63) by MN2PR11CA0005.outlook.office365.com
 (2603:10b6:208:23b::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Wed,
 30 Sep 2026 13:00:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN3PEPF0000B078.mail.protection.outlook.com (10.167.243.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 13:00:07 +0000
Received: from DFLE200.ent.ti.com (10.64.6.58) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:23 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE200.ent.ti.com
 (10.64.6.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:23 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:23 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCxMeI4098152;
	Wed, 30 Sep 2026 07:59:22 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 06/15] crypto: ti - Align buffers to cacheline for DMA
Date: Wed, 30 Sep 2026 18:28:50 +0530
Message-ID: <20260930125859.1749849-7-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B078:EE_|DSWPR10MB997934:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d79dfd4-f866-4872-4b29-08df1ef2c0d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|82310400026|1800799024|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	y8tJPV0xCpGdHx3byUL5rWomaZ34fcX/RGZvKDVnAkMSXEBtHN7dIaRzUmTUkSzb/z6V5jq6y4hhkpEnOHT2gg1x8upWMsc9bDirBZqnM0fdOTregIH6cg1nCf1ghllnBk6vxxLYbcLnqE6+UzfFAETJreQBPHDjWGyb4s1SZKV2oBqKigPGiPOxIZR2e1oqN3o87nhZrjMoIHpobzZAz6GrFi4wL/SC8V71s5Rr07Y+UMQn1OHR1uSfMNKZEMvxFTZRCZ1ZwxA9eS1cY2Y0E+1Qg6LYvyn7peMQtrdHkKGgokZZ6jv797NloU5nDop2erglXWmKGi+ZEqLYlsfUfZgi9Zw/Gck3Agj2uduG2GtPq38cxLxzLPevcQJ7VVkiN0wV6MUOVjg1p6inMttQquzIHN1pphSz5JMLvA3KxyXWIiDxJuIxAHI5WcrCh7xdGkWq0ERgJIbZ1VdC006rZy3HqfHPOGmbkANoPsSlTamU0IjCWtx1q2c7mFKkExHMXas9I234yIioQJ3phrYKDNyklhWBStUVp5BRO7mehdqYVC/V1MrLEm55GbAnF4KbASP79IL/lahXHfZUOlVYhj/vFLf6h8WrODge97LwF/AmEBL/GXQmtyiyw/6LtmQ+kESVpvUPk3RvHmBh/G+PmTtbdqPWo0ddAnwgJht6WezhIkOWtto7brBvu5bbjSthRliTwONQNvIcogAv2P3vYQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(82310400026)(1800799024)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JgFfs6fXm3EBHrCqnrpBzHQeAxsCg8+VkT2LceOsU3WlQLM+0D6rw4Yn+DqxNHv+oXFcR6UqcdM31bJFHakAdmkqijGU4qLY/++apk19xQOAJx4Ys7Stk4rkaK8zM6E7nO6Hgv3D7+FUcIWtQKpVVpW1igE9AmdKzzTj1ulptITGoyXOBfawImGMFpSbPEs/oqQIYr1MfjR8koxSKUekgv9FKyUsXCqQYltKol7tj5zrzEoNKlpfrTAmQ84WyZc49JqxGhTSGMiwRiM09pHY1WocgK4oixx9UYKELJblLGC7tm5tWQEwHhV/SPI4PuW8z4//oGS7kOUv8nOYTTpnUlKQ5XkBC5s0Ki3NIjPtcOSnR4uQfnPTvzIq/92x2HgnEAmyPisTBU7wpp9mHRndyUmNaLex6Lywgk9257r8etHqs0MOTwtKp03Q7Y1r80gk
X-Exchange-RoutingPolicyChecked:
	Hm582GG2BV+siBPaMJ6usFAJk4DPo/oQ+UK0aokXD9QZy2CGQaYUHJKxjG6aw7HAW0fahFnYI694B7+sEvZ0yWLx0eNsa6s4cZMIwpuLo13vuLHbDqZ+rt+EfKLmB1IDpyXC++rQCO04xrNivJsQU+pR1y9gF5qsx2uiQFDR5Von6N4H5B75A9eKhslEbtSjGjSmInJipcVf9+hDX1YL8EPkEj+zR4UcXhZBE+9DO7OoitCjbd41lHySerMw0Cj27LdEA7oLVxYZBDziqmLjU3TDspHPYz+DypBpZp2LrBMrKyUFBWYN9usQMGL8EtUNlJCigi6wnLGCrMAH0gOClw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 13:00:07.4944
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d79dfd4-f866-4872-4b29-08df1ef2c0d6
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B078.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSWPR10MB997934
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX8NcGX9EKZSfe
 Jm1FNPaDA3+f3q4iC9KNA10Al2dEkHRxvcj/uKtXlhZnJKPy8rkKn5WhF62ycdoDTbVRuwqu+wi
 1frj6H7CxEE8HkiFoZxoluUFyEm30jo=
X-Proofpoint-GUID: QzMD2JpGjTjgSOinppvBoJ2A-O4qKKV9
X-Authority-Analysis: v=2.4 cv=TegDJhQh c=1 sm=1 tr=0 ts=6abd07db cx=c_pps
 a=NtDnjKqRhcbz7rYDj/0C3A==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=dBz7rOeTUn-ILHDwuGIA:9
X-Proofpoint-ORIG-GUID: QzMD2JpGjTjgSOinppvBoJ2A-O4qKKV9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX6MIkFPAo/+/w
 dNavLfzu0R69NZ+T6z2yyJlWcXH7p3B+GdFB+Y11hBW13wxLE6hy9LBhd4OcUkr2YZbV7xzucCo
 /pwiILfn5u8RjlcAdYzyIZilGsu3DLlOwbmo0nd4Uoja61pAuErBMCu8rsHNBgx68COnB4mVwdh
 XK+t3Hd9OFH2wIfeWvrSuzRyenYHT8cCEy21fmvAd2gnrz9DCsFAUMlNQk+laaIeFRYeIe8WUq8
 yh3qf3PFXqPYoDfE2Y69r/GFHSRPGcZtZqbIsF+ZSdt/3Ov8lpQE+yhZIQ2G4CeXvSvsniCInFL
 PbnN65E+6Mb89VRr1vdgxvY7SR+esCIy1IlbkIMl+W3ZeGX/pXZu7MXRVfcwk5YED7579+ZnBiw
 gmHPTf1fzc+KQUgLqwROu35O9dyD38jv/7sq5t+hcWklzsbvGamE/TvCIF/H1iYR2nT12EnUbko
 NPT1wNDDBRpLIb2e6Lw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

Align padding buffer which are DMA mapped to cache line to avoid any
potential cache coherence problem. Add DMA padding to reqctx and use
req_ctx_dma helpers instead of req_ctx.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 46 +++++++++++++++++--------------
 drivers/crypto/ti/dthev2-common.h |  2 ++
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index be7ec62ab2513..5be1bcaeee5ed 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -298,7 +298,7 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 static int dthe_aes_do_fallback(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->skcipher_fb);
 
@@ -314,7 +314,7 @@ static int dthe_aes_do_fallback(struct skcipher_request *req)
 static void dthe_aes_dma_in_callback(void *data)
 {
 	struct skcipher_request *req = (struct skcipher_request *)data;
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	complete(&rctx->aes_compl);
 }
@@ -323,7 +323,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
@@ -515,7 +515,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 static int dthe_aes_crypt(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	int ret;
@@ -560,7 +560,7 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 
 static int dthe_aes_encrypt(struct skcipher_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	rctx->enc = 1;
 	return dthe_aes_crypt(req);
@@ -568,7 +568,7 @@ static int dthe_aes_encrypt(struct skcipher_request *req)
 
 static int dthe_aes_decrypt(struct skcipher_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	rctx->enc = 0;
 	return dthe_aes_crypt(req);
@@ -735,7 +735,7 @@ static int dthe_aead_read_tag(struct dthe_aes_req_ctx *rctx, u32 *tag)
 static int dthe_aead_enc_get_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
@@ -755,7 +755,7 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 static int dthe_aead_dec_verify_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
 	int nents;
@@ -836,7 +836,7 @@ static int dthe_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 static int dthe_aead_do_fallback(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	SYNC_AEAD_REQUEST_ON_STACK(subreq, ctx->aead_fb);
 
@@ -852,7 +852,7 @@ static int dthe_aead_do_fallback(struct aead_request *req)
 static void dthe_aead_dma_in_callback(void *data)
 {
 	struct aead_request *req = (struct aead_request *)data;
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	complete(&rctx->aes_compl);
 }
@@ -861,7 +861,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 {
 	struct aead_request *req = container_of(areq, struct aead_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int cryptlen = req->cryptlen;
@@ -1140,7 +1140,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 static int dthe_aead_crypt(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	unsigned int cryptlen = req->cryptlen;
@@ -1212,7 +1212,7 @@ static int dthe_aead_crypt(struct aead_request *req)
 
 static int dthe_aead_encrypt(struct aead_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	rctx->enc = 1;
 	return dthe_aead_crypt(req);
@@ -1220,7 +1220,7 @@ static int dthe_aead_encrypt(struct aead_request *req)
 
 static int dthe_aead_decrypt(struct aead_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	rctx->enc = 0;
 	return dthe_aead_crypt(req);
@@ -1246,7 +1246,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1271,7 +1272,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1296,7 +1298,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1321,7 +1324,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1349,7 +1353,8 @@ static struct aead_engine_alg aead_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aead_run,
@@ -1374,7 +1379,8 @@ static struct aead_engine_alg aead_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aead_run,
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 0e2f5bc07afe1..e2600447f217a 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -115,7 +115,9 @@ struct dthe_tfm_ctx {
  */
 struct dthe_aes_req_ctx {
 	int enc;
+	__dma_from_device_group_begin();
 	u8 padding[2 * AES_BLOCK_SIZE];
+	__dma_from_device_group_end();
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
 };
-- 
2.34.1

