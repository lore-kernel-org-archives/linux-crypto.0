Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C752480348;
	Fri, 16 Oct 2026 11:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151373; cv=fail; b=KGQGOQ5iR9RQU/ziiYEpKaSYlR0yAzYskae8WDHnQHFW+uOo3A8T6x2f5RuihRQyVydQtGyi3C0gxHG8qAI4QvM56G0bte9LRPsapCiRfPyraD1I9QBjdDVJgKK97xMvdkV6iKxhP8BFLzPjkZiDw0GMtemhiusuRSJPg31/Ji0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151373; c=relaxed/simple;
	bh=E5ui66nFN2Sr0ub9ZpazLzs4UnrJ/zMMHuFp0BvzIlw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YCHEg02yxsriXpEgWEiBDZqEry1wWrvamwxd1zLg0L03fY7Sx3+VOKbc6nrKsLrMk1eDgmrphTL+DjIkgcBDH7e79+KKO7y+jSFjY0Y73v4K5Sf11OrTtB6HkzshUPAibP2U4M1bP8FEvCLdd5H8t0AQOhCNaQVoEqcCRN8sfT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=aHY1wIH1; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=VK9hySWZ; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="aHY1wIH1";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="VK9hySWZ"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69GACgvr3703743;
	Fri, 16 Oct 2026 06:49:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=SlhDa3fyQ7A8/OZxniic/0HDueJPFWpgVWgWymuD9
	Y4=; b=aHY1wIH14KBnn+2sSniUM+kK9SDoQhF3Bmg4zNyR1REJss+93ReU6Yuws
	BINhOabvRVbdQ0LKMfotFnl8IUCtLutc2WVuSIAHYsBtfQDQ3uTaoPOjv0GHcIT3
	5+mwoJ3FG09wXWYJ0jTX7t5R9EPKcTRjrUbB16a7Yx4pr+ql+01Q7/Ap/kKArVoW
	lOgeasv1MR7Ty4111ZGDtGAwz6QhGampYuxy4ABuPl8ivKihR6vOdBjJdUGOFvCA
	nEkaFEADTj0/CLIcO3nf8fjQgnQpQNEq/hy5yWU3eGCA9FtOjeqoQUAmPTkyd8WM
	MtIO/RQDJnNx6YjN58KcQ4cCS4Z3g==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011008.outbound.protection.outlook.com [52.101.62.8])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hbhbg8jff-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:49:29 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o85EZyAnZF0lgxlLXrIdFL4gS31F7WG0bcen5tNHyYX/rzKShyu4X4S9H5oZ6N7XBz024R3GQHVguVgKTfi11CHDjks9pAKvJLW2428XXVTtNJRWPgAHXzPrT0ouY1bsCd1b5nuxx0jCxQCxiUrMk9OT+lm6ORQc5tWdImYBXmDlaexTDFd39a+cPFOwIPb3o3szp3dXKlMpOWWMb4pk82XIoW3rraVNOSf51i45Imsbl7+PzbPUnFVElsNPildVYr2MZbb46kqggfcMuXT1LQewpQzMdF0QoL7YxfRznFlMdWMqMWhvNk9zswQ21wCZXOl1abyyUdIZ1lEHGXbtIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlhDa3fyQ7A8/OZxniic/0HDueJPFWpgVWgWymuD9Y4=;
 b=qipzmgF1H+am7+sizGo14IyB1AfER2oyyupZCAXR6yFO5ybVpsKqf+i68Loug++B6GIwwT5i/PjtWcOvS0JCq8041nlb1SMLDZkpQjbssJyoLJALxB1FP8Su64YO3qA4FRZzR3UfUKCUP6XukncxYI8zqfIAe3XLRYQ9MTnIqZQKoD0BCsm0F+sDf+3fgSrnYiX+S0NzXGAaXBOsy+MnKhNLpuphcs3oZ/o1hO0MieFAGq4z6L0I/1PyIYzfp00Sja7r/Nig21ckRDHL4KVRfESFAulSs36hvWPH2pfzn7lXhLCRcu3PfsyysoYvWx2ETbPcujMxOCRdQQwYN8uQag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlhDa3fyQ7A8/OZxniic/0HDueJPFWpgVWgWymuD9Y4=;
 b=VK9hySWZnSHlXHxm0KYgrraoQGInj6w8mKcr3pi775CwZ3S+OkBJkecCadkbqLe3vcaNayOKXQb1ut9vkqr2ix5MEVtt5sDTACJX/ptxhqA68zpkHHQ9wXPjKzca/F0WcV7ysBDUZkxsdfnMY9tiK+8GJb1jYIqa+6/cMbaRUl4=
Received: from BN0PR03CA0012.namprd03.prod.outlook.com (2603:10b6:408:e6::17)
 by LV3PR10MB7939.namprd10.prod.outlook.com (2603:10b6:408:219::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.8; Fri, 16 Oct
 2026 11:48:49 +0000
Received: from BN1PEPF00018074.namprd04.prod.outlook.com
 (2603:10b6:408:e6:cafe::ae) by BN0PR03CA0012.outlook.office365.com
 (2603:10b6:408:e6::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 11:48:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN1PEPF00018074.mail.protection.outlook.com (10.167.245.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:48:48 +0000
Received: from DLEE209.ent.ti.com (157.170.170.98) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:39 -0500
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:39 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:39 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmcw02451529;
	Fri, 16 Oct 2026 06:48:38 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 06/15] crypto: ti - Align buffers to cacheline for DMA
Date: Fri, 16 Oct 2026 17:17:57 +0530
Message-ID: <20261016114806.1749515-7-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018074:EE_|LV3PR10MB7939:EE_
X-MS-Office365-Filtering-Correlation-Id: da465862-c674-48c8-e135-08df2b7b713e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|23010399003|36860700016|1800799024|22082099003|10067099003|18002099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	6GfG/UNX4ATgoI3YyiQJ5z57Duaaf48wq8LPxaoDeLnpq9c/+WcQh8WqWQo2zLJMMPXeYLGFjFUx1HuoTvdMpbBloTctXJQXogk1IQPbr/3bJGKLmDpTOgBcRcJLL7Ro0aTAH5n/6X2bGQILRrPS5oBBJCA1lVbD1ie8zj5PTNrgMl8U7F9zyRzFHG2mAVSTQOFbnXk+d7o+sqyTwHHdxnui4ZE4Ee9E11gkKW74kXcB8AIROIP108RFS0E0pgAiRf6rvLdyqQ/9jeIx0EmfdBPbPs6hzQUIKCdhgzLdUK6vYeHxRPSeam4S6/W2ggleg9cQgScVFHBb6J3c5OjszslGmusZa5c3H27V9cEAzVJyuVvS0ifTuGBFBI5ZyPF1k5JE5oCGZY2XXPZGJ8W8+IUYvy87ALhJa5fk0XdLHWbEZ+8d1WYqGlFfNW1h18wOpCssQHZprj6oK/wxT2nP321xhi3/kEOwA9wz/Huf8P8MCrLgBvslYEbskxhUuHPVpgiEbp4E3/4UO1tJ/xp/grCW76v8QmU7IwsRR5WkiDsGaW6U28QJTvwfKuzQ3Vgct8NnjbvD9IniMOBlUWrDuDyZklstHmCc2gAwJCuCnBVGhOMuZD3SaGdzZvO5+Q5dylUW+EIltVpgUwh21LKbvgY6DA4mSoi/KZj9BhhZ9Q9e+zGdEBS68sSHee9Lj6bODsA/DO2BIe3SuMrHrutsLg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(23010399003)(36860700016)(1800799024)(22082099003)(10067099003)(18002099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TUa4Gmh83fz/I+QiV+ei8rL/+dwXi+joxil4D4DqHWT3Pi+jDjSgVZqsWQeebblYD4njlPPisOeZutRft1GYA9iCTKN+NWVZSAXT4xmVpRBzL+dJdH62rLw3dbDCl4wRZNWRUvvGNm8b+6mGE7oTPZ8G3KBzQOwqoejm2MH2/gnQNphRgjaGCz7XrPuwDwmTt+GlQt+1XAzT8DlsGuyB9pz10VFl0mdrHh5zclesHpmVDFr5NYPGYWrTmO9Jp90yiFhyDO5OPO5HoJ9CHMphgdbSwaAS+UipyDBfOpQ7S97IyIzfuTsYqkeEcvQ3otZrX4+0u1AYTvNxEg1O9AblsGMBRHo8cj4GaImq1otxN+2A5mT3dzyo/WGd1vD53CdkE18Z4eaaBRSf9HTSsX9IkIvVn1RSOLj3GKFUcx4pMMw4b6llNuKHwhJ2dseYuay9
X-Exchange-RoutingPolicyChecked:
	piw9859m3WTUvZ9FSVoUnSFLjsF+Gq0HYnAH6g7oqyd5cFKrT+CS+S9UlD2I5aFXIPHfz3591JgejP5h9YJe+HQpZXSNPKWRtL0fa/Ju0pdPyxZImZ028fssqJ8XdYzndH7SG5TYRluhyY6NZboGNzLRGs4g6naO4IwMhnxkdA+Y2oAkJG1O1YGsizWSV4cFdw9RTXXXYHNjg5wzszfsOWRrTZS0TBKlGGo4Q/ZoojjqYWh13BnWM65fZXYB/zfoOAbu9prH26HYXEmCGVmlw3uhKTrEuky0rQwk+r4w1yjhQAsqZ51MVYK8TvzyV62c292kunaJH4gY+VMdakpiSQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:48:48.9591
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da465862-c674-48c8-e135-08df2b7b713e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7939
X-Proofpoint-GUID: h_XeSEqGmwKuwmE8_FlDA5fGX61waA5_
X-Authority-Analysis: v=2.4 cv=BuoIUoX5 c=1 sm=1 tr=0 ts=6ad20f49 cx=c_pps
 a=fYaSdR3m0whpxnlOBVIaHQ==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=dBz7rOeTUn-ILHDwuGIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX0dHFHxUdPT1T
 PbdWGCuhifUeWEJKu15HoYuaf6mQaMW70z/pVX6MoOWmd88rACgWGHHd1pLsMfqSrJdEBf2HOTr
 evTuoWQ0sCCYSezhXEYM+kDP5aniRsXLBzAlxT1PtRPgls3M0Ws1oJjkGjuUGIcfY0dU+FDwuL7
 9fQFsksKv9jwnWw5+n+JICK+sMTUjTp7/70RBDaE4AKbQ6nmgVZ6BOfxZ6ucgAxte46bB5qPTRb
 iz8FpN7UflVpxUQFxU0u/zoX26lIymtH5ehPUPj0xt1/QP273eA3q5qg/OF073nReBgpgWmepK+
 Wbsfw5QA+P/a1SP5XgK/i0Kq7TytO/FDozrHdKzhXxjxtRkiRAysX0ojfVF9ZvbJD+RRBB4GQWA
 1RaVQmuhjBPyK4976bk8UINfZoi76vu7S3+7FduPRIgC6WmTJaoGPWdMqfrbUrzztW85zueI/Qa
 FPK/lA7giNUOP5Xv5gQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX9+TovRjI+LGD
 0Baf4wQc+aepvnVcHD/H5/h+w9YS5TLmhqVUJz5wE5WhCVp6xVNEDPIJmEaFAJ3ZjoxpDGr119Q
 0iqGl5HH7sfthkqzYLn+fyJ1m8Bcr3Q=
X-Proofpoint-ORIG-GUID: h_XeSEqGmwKuwmE8_FlDA5fGX61waA5_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160046

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
index 03a0b426041ac..cc20538ad6f36 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -114,7 +114,9 @@ struct dthe_tfm_ctx {
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

