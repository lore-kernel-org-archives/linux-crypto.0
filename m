Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2093.outbound.protection.partner.outlook.cn [139.219.17.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0318E1C693;
	Wed, 26 Jun 2024 01:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719366069; cv=fail; b=SPUAyY5HPd4cZfesIXmUbThx8fDAos7oUTvlS/xRh/Tb1HumEZGSGhMlxU3kOB77SQ6u9aoCbvaA8K7ID2BZspKKjb/o+28UlrmwaZeF+n8xoItZVCoEaspjmNCihu97KOSDjYzbF/modsbfYYTEG+e1UW7HpeRyFIXE0b+qdpA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719366069; c=relaxed/simple;
	bh=dntwyD3cTMCDz7W3PRKN6Bkiu6DOWvPZ2tlyvObSOeQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DkUDM5oGhhtKnVcnvQp/V0wEp3/RejssnWzZufsG6iNlmllNpgCVCUxudFYMveZ3Lhn4Abb8GortrvoZiuZG8BOdKLhHRyuc3ZUBUC73pdoAQGaUo+MkQYe10XEDtl4vApR2t5fC/Bsv7ZhiO92P7JAkxfLblf1nGXRqOGBoAz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwtKWJJC+3b3qw5Q0kcT3fzt67ZZqxOgBEBLq+B8VNrNkXwVH0zjqp/JqXjQLrPS2zY/7MpjFLbVN4axpl/ODTCFLDppxa7gdhXVxMYiSu7e2YAh+fie379a50XOiVN6YEIiqbUdVkPFZHwdzWBS3mICQvffj3dcHA4Ftzzngo0XWTMnoc9Zi/VFSSrzmz05hm5vOfbWx5zSxuywh0Fb56JG8ha5cwPdJmPXE+JX716cy8qEFw3gLz3wztoa0sz65uf46jXY9S3vCihfuF0B8YFWsGzukOuo+6zlblV1r+T7Knq+ZTBRAvgIHpLJ9jQ1o/Cqp06AScOgw4m1tVAuRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MsEpeG/KmLd8xPV9cv+wwzuZ2oDk2hCWyK+XzgdM1jM=;
 b=kFMwDiknKG9guJ7NftsbsYz5uaeW2J5Hec4jMvgoeWpzIt21KBbycep4/u0j7uUQ0q8Js60txras5hgOgP+q050PONtWWBIwkPJ7xbehaY9h81Cewfv9wOnV6eWcEluiRHyPlDwauaj4Jnfr2TGy8Jpo0twhVKFxI+QnkxY0yhZvzVh2ZjaGZCcfYhmztWT7/jfrokjJoG6Ej+iSHrf1RlytPNcxfh4S6YCVLp0gvYQfEjj3kpvYgVKTuz/1BZ8n4FfuuKTKp2GLMQBadtoAFGucPtsGr+RIHbI3gto22cDDa4SKLfpatfk8TAi0ftOCiYOI9HGtGPP01bNlkv4OKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::10) by NT0PR01MB1150.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Wed, 26 Jun
 2024 01:40:53 +0000
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce]) by NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce%7]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 01:40:53 +0000
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] crypto: starfive - Fix nent assignment in rsa dec
Date: Wed, 26 Jun 2024 09:40:43 +0800
Message-ID: <20240626014043.1194521-3-jiajie.ho@starfivetech.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240626014043.1194521-1-jiajie.ho@starfivetech.com>
References: <20240626014043.1194521-1-jiajie.ho@starfivetech.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SHXPR01CA0022.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:1b::31) To NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: NT0PR01MB1182:EE_|NT0PR01MB1150:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d3e65fb-17be-4297-7186-08dc95810447
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230038|1800799022|41320700011|52116012|366014|38350700012;
X-Microsoft-Antispam-Message-Info:
	icu4fF8XE5UsW4xmBWTkHqVJLuze4EHPfV0fSqVK2f337RKMCG2GdmxtS181tk8O/+4qrOR5YD+1vHJhiayCPipguGxIpzwJNpBrFzzeSYooXcBNBLs1QVOlLw7o+BF2LhB25rE89m6OFtAzQuh9zoDVvntw/Kq6M5GrKKSLJ/ZhHwmb5KaCOmOdq0uPRmOT2I9L5n3HqPnS1lit8Vl8Ik1L5KavPIIZmqND/Lg6Hwjadvj5GTyGhqcHeDPRxgjZTPdiPjQAdLPj0ZBB+94YFur4T02t0CIICj/yd7TmGEwkd08lLbBALo5Klrsony7Hnv1MlztrIcfI26DFW0yiwMNzlDJX74KtPC9r5RADM0b6ia7zPy5cLDpnHWI0cO08liO/9VUYegm/xL4z6gyrUjy7gjDdddH/QMq4eUC5Rj2k2dH3FlOcem8mV8HCGZp8GDJRjkRnOr6qizZ5utBVJLUpdD5Nc6YDFwnuNi5k00vc2A1L9xALywkiBx4rFHcSz6GWRDogQlp47Pde8VNIuV68mfO0TrCuqPbh7pyDWXkA8NJ7DYC27QdvZNQ97+53YYrRqnHs09LKedYWCqVh9GW0ehbQIlCRP8bM00A9GhZSjR6qPw+mUfqyCHf8/sXu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230038)(1800799022)(41320700011)(52116012)(366014)(38350700012);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FCGt8X1g4VjY1dA4P1vcmfIqOI7+kyKz7jsdocpEcDdzsmuZYvkrWs8U9jRa?=
 =?us-ascii?Q?xm2y9Oop/w6tsPjL+1YGXd9fYZeJ9AQPp4J4Jg9cafp9AhakCsIIn/vzSa5m?=
 =?us-ascii?Q?JsdXoh4A+6UFN2HOrKXq5mav0/RyhkbqNfFe/jw8/hopA6NL76LQAl+PkNJq?=
 =?us-ascii?Q?xDmY5tUc9lqyquqtIQPHdgueeuDWWDTTnScxaiO82Trbvu8plWbs5DKMDiPJ?=
 =?us-ascii?Q?utZ1guIOxf/8NOUlQhhxorHe3XIzijY59PlTAReGcf8NGBGQXS8hQWzhlgvF?=
 =?us-ascii?Q?iqBdVOdAPqEX4c0HwlfVhLwgdH2tZP9ZsTFLbQEXuuAYjURA0bK9++i69YNM?=
 =?us-ascii?Q?+vKZc075xH/dxEG7fMXot1TVKXzEhjeA0FHac0dts+6FdM9F9VQlpGs/pcKJ?=
 =?us-ascii?Q?BIjmr0NzFMtFkPa13E7uGt72zP9VE6y3bz0qkpkgpTx1MaEeZ3qE6Z3cx3RI?=
 =?us-ascii?Q?iy+k0zgGLAz12V6A4EZYFlH6utaAIcMP6R/EWy6HtmRxKCqeR9U2EOZJetgg?=
 =?us-ascii?Q?8JqkcJJ8ohauTrmzGZ/kt42qg4vB/nJ1MYJzxHeKcHdFE1yy6TsQo4tW6jZn?=
 =?us-ascii?Q?IyyA680zhXysVDVRJpaxVj0gijiQYI0zC5j9xunJkyr5mkEumDzlQheTK3Ib?=
 =?us-ascii?Q?ypIUwCtezmw4y4orV+i1onoM9VEeCTKV7pES2lke34t9Eb6Upb5nHJBkD9Ef?=
 =?us-ascii?Q?i/F6uO1nCSkGYQKZNVTw3laxY4HDsPcQsgEP0vw5lMqr7NvTUM9gybKshjEh?=
 =?us-ascii?Q?8Xhch7RoSS8yMdEv65AkS0ePW5GCAJmmUzjrqFym6TVYqVkONkruCOfaTwlP?=
 =?us-ascii?Q?UAiBQr/5MAE59ndCJ3R6uYCFp46qJD9wqkBTLbsf4RWDLuZrvZay7/csAyQv?=
 =?us-ascii?Q?89QTU/otkk06vbxD1PUYSUjBDcJNmJgdqZqlEPKOWz/k5QiE13DI2Fk+P0CE?=
 =?us-ascii?Q?3Kk2v83Bl3ZudY3SMloEWi29WM84ZTJ4Q1UFgEZyzgP68KQgzPsJtO6ZVzcR?=
 =?us-ascii?Q?szw+PEDlbnDSHOimPMuqHk3wfIXy4OO9pjw7N4mEPZ0QoQ63vdXQ1avpWJpZ?=
 =?us-ascii?Q?0xWuXVIG2Q3/haTz/L0sjB1SrDEo6CCVrXoBLIHb6uNH6So55rPTDARs4fks?=
 =?us-ascii?Q?AyTRdotCqpfL2n8QI4nmwCRlofyeRXZ6GiS9hGxQRCYNzwnB4ZL9QnYO1IGE?=
 =?us-ascii?Q?ELO5mZLNk4Nxj2kmyUTZqNhyW8YEXGBdxfgqmNLIJfx8sHuv1tilNCA55BLg?=
 =?us-ascii?Q?8GC5KW0TELFHOwepf12kRQcfbOLQBTOejrkEfu+9guaUuo1xykfDIZKPQSGr?=
 =?us-ascii?Q?hjay3XBHPup5dvDBEnux5fIfszFElz0PneBgndnC/p0f448VumHYcE8aF5GD?=
 =?us-ascii?Q?1ofmSoAeLppwf2eXZIW4vncUDAcKUGILoaHimqpDIlm8X14F2VvN/0D/o5lE?=
 =?us-ascii?Q?6n+oN8NYXWeJDf4Jc9R3vmjkqwQKre7sdjC8TRZOcf2NEOTt5me5rf4pR0bY?=
 =?us-ascii?Q?kG7S/MNk1rked+sMLb9UAik7poj8PfKIHhwunkV1wRRPfa0DPbHo+WPTbVMu?=
 =?us-ascii?Q?tGuOlqKUNwQsxcKNsV5dDUN/6Xi2DyazDPP1iC+KmJDNr3cSLvI5FJ7tFyhS?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d3e65fb-17be-4297-7186-08dc95810447
X-MS-Exchange-CrossTenant-AuthSource: NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 01:40:53.6266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OP0+m3TANgzYgisGXvOzHDvT205ZVtrr8PY6TkN6FWavRJ5Nr/y/uLsl1Sgf9ZKSznZCPhVhUNSGiEL0PN3h9DmFPK5eM3ny+ond20EuzjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: NT0PR01MB1150

Missing src scatterlist nent assignment in rsa decrypt function.
Removing all unneeded assignment and use nents value from req->src
instead.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
---
 drivers/crypto/starfive/jh7110-cryp.h | 1 -
 drivers/crypto/starfive/jh7110-rsa.c  | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.h b/drivers/crypto/starfive/jh7110-cryp.h
index 85c65c6c0327..5ed4ba5da7f9 100644
--- a/drivers/crypto/starfive/jh7110-cryp.h
+++ b/drivers/crypto/starfive/jh7110-cryp.h
@@ -218,7 +218,6 @@ struct starfive_cryp_request_ctx {
 	struct scatterlist			*out_sg;
 	struct ahash_request			ahash_fbk_req;
 	size_t					total;
-	size_t					nents;
 	unsigned int				blksize;
 	unsigned int				digsize;
 	unsigned long				in_sg_len;
diff --git a/drivers/crypto/starfive/jh7110-rsa.c b/drivers/crypto/starfive/jh7110-rsa.c
index 59f5979e9360..a778c4846025 100644
--- a/drivers/crypto/starfive/jh7110-rsa.c
+++ b/drivers/crypto/starfive/jh7110-rsa.c
@@ -259,7 +259,7 @@ static int starfive_rsa_enc_core(struct starfive_cryp_ctx *ctx, int enc)
 		memset(rctx->rsa_data, 0, shift);
 	}
 
-	rctx->total = sg_copy_to_buffer(rctx->in_sg, rctx->nents,
+	rctx->total = sg_copy_to_buffer(rctx->in_sg, sg_nents(rctx->in_sg),
 					rctx->rsa_data + shift, rctx->total);
 
 	if (enc) {
@@ -309,7 +309,6 @@ static int starfive_rsa_enc(struct akcipher_request *req)
 	rctx->in_sg = req->src;
 	rctx->out_sg = req->dst;
 	rctx->total = req->src_len;
-	rctx->nents = sg_nents(rctx->in_sg);
 	ctx->rctx = rctx;
 
 	return starfive_rsa_enc_core(ctx, 1);
-- 
2.43.0

