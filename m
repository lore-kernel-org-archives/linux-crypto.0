Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2116.outbound.protection.partner.outlook.cn [139.219.146.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83B115B133;
	Wed, 29 May 2024 03:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.116
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716955162; cv=fail; b=s6IW1SSUOPEbdXEaiqhhElIq3iRQgl+A56w4QvFNerGIhh40uvlWrNeUshXmFDBa+ghfPoQBg4iBn+OA1kaunkmWUzbPW9j39tTutvD6O14Elf0xopc0flUAQU2jwVPcQUtaqtk9zn3mCslbqHtn4qeeoNkvZe2gugiaL56VqOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716955162; c=relaxed/simple;
	bh=7jlFcK6BPF7vLrwtlQdgbJtILn5X4acToIDbWhXaaxI=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BeGm4pxXhQUZStevxoYGOwID9NShI/YXYrEzhCm+/ePgjsABVTakPLD7XNJALH6238G0yeDCTmF2PMSq2THHTjBIVkDcWxQlFaQTYJLyQGbXDJs6Pp/Ewcd7zEjboyivL3UmjggTOPtJklv/J6BAkzUx8mmo0+LuB6dFz8OORq4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REp+ZyO4C/WW3pLI70UAF76XvfVgNGzh6EOw8gfL9BSETKWVAsSyYlJ1jvAU2ZwPhp5Dhiip/JpNNCgATWzeSus7U+vuvDDb561NwNbjmBctPBEWzqusU7Sy5TBLsZZH+FXLiCxL/vhdNv3uJEKFjoKWgufrRiSxI2LhSrXu3Ecd5jv5/7rYpBKvao5jTO7OF7pZQFIzvb9zrKJQqTzDgcwPzQxINhFbwm9BoZGwt6o/HsENW454tdjUZ74bIFG2lwhJFidc0PUfITS6lJlpAh4TRJcEVWszbzOANI+zjKJz7wy/tnzpIC1ucU4eMxtMd9iNK35dS4dWn3sEqUa0EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ahcN+ImA5rIxcKFP95gkBxqtN+aTLSlHcTPRAfc+kGI=;
 b=FKNlU+98yd13EEnAg521ZJ5HLPqOWf67KltesIA7L5DScCSqtZHeAwez9No3umdJOKmFzqBtrSx1EseFQA6TK3DrsWeq/jzmqbZol5pfGcQluT32YUdHSwUnWEWPe/2Mhn7pfyZ2ZjPeBu7TgmtPi1W5hMl4chCWbJ2bc9xL7t/lHLUP7BEeKGJAYr2P5XQc0zLc734jmKSbwn/LnOT2VvYNc6N4zz1qmIVxgJhFvfFHxXs17hTwzce595co4vyWZN2/QmBjyeyK5Sl64plJI5l9mMz/C2BFwMbrIYamyC/Wm0fqwonBZ5+ihU32Tqm09Gm6K2A4P6Fonbw0G9iAeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::10) by NT0PR01MB1264.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:12::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.42; Wed, 29 May
 2024 00:26:03 +0000
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce]) by NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce%7]) with mapi id 15.20.7587.037; Wed, 29 May 2024
 00:26:03 +0000
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: starfive - Align rsa input data to 32-bit
Date: Wed, 29 May 2024 08:25:53 +0800
Message-ID: <20240529002553.1372257-1-jiajie.ho@starfivetech.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZQ0PR01CA0012.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:5::6) To NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: NT0PR01MB1182:EE_|NT0PR01MB1264:EE_
X-MS-Office365-Filtering-Correlation-Id: da16cb55-b462-49d3-5046-08dc7f75ec31
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|41320700004|366007|1800799015|52116005|38350700005;
X-Microsoft-Antispam-Message-Info:
	Vw+DTTJOz8L66DjyJjK4Looj0Xj/DuwZgoPes7NVlWlRq+6LNRCO/rmxsuL/hMxRQtn6h1CuutHNZxy1qzqb6vqJwho0lFNx77QjXvDqFzo5MJ1tdLqDf2myYFoj9Vc/q8f+PhnC3Rfnzeey/NP+MrsvURFHYfUdYKRINP8UPGaFtPDzUIuBYakMHuwzYkmTZlJEb5TpS/oC+Clf5osTMZ9QpzUnU6VEP67RbrcVFBaLJ/3vyLhzh2kguRYfVVJ1cqXYXy3H5QFapHnBxjGB02XHCvVwYf/6YpvyHi8tU9mPmgSvuUHvA3/H3qptEBY+O5xM0rVbm3STMkL7fzKmo80Z6xoD+4sdDMVPeuoGL62vqr099oDzVbscR4UhQjPIgSSjQnkUOXtDUxElRYvDfZA+QBV06ylL4lbDbNhmGtpNEJ5H4bORxTmNOSdVzLAp9MqvCre5QzWW/5DajvCK3HWIqHlz3tb4ZvsLiKBJ33FjPv/hb9SexUI0+SIgfFWE9dJxyHTRWm8kLSXGqFbK+i3Uvb7Td2SEWxzSgUmCO6TZoyHnrW3rXNWiQFJhO9/lM0xKzv7MdCMgTfCS3tHyDIHjdiTeuEeHAviUtnsVJYDn0vJefqYa2Fgd6M/qLoyo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230031)(41320700004)(366007)(1800799015)(52116005)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n9GIN0BiCue4PhRxjogdPpY+hy32NM3Uamk3TS35axmmG1/wTUZxoe/CDvdA?=
 =?us-ascii?Q?tUc6PPYYZ6FOcbgufCtbMmTJHaAp0f6m9f+0f3iR0wqWr3okqy6L+DjbJrmm?=
 =?us-ascii?Q?J+2qMd10oVdQFRbEmVZF6s07nNgDLV+bUbeNFDAk44YAbvbgT3WU7nTdmpAM?=
 =?us-ascii?Q?9krvqqEv7pvH0axdyyexo40YfFUybWq+4u6H5b9QLqX1i8nAabgMtZCL1hm5?=
 =?us-ascii?Q?fgyuFOswlspgkUyass2DJPPxMElriTI1yr5DlTm8cZUPKyCcg+8005XbUSGY?=
 =?us-ascii?Q?4G6+EyNApOYG93rcdcoxoQ+SkWlUJhRTMIbY+DgsvYTy8m4Biar3YewlYfsD?=
 =?us-ascii?Q?UgpNiD84XwngJRtCHB5gZEUrue9lTelAZWg7N/Yqp0ZcxDjCvekadvr4m719?=
 =?us-ascii?Q?vKOuxQRz2S6rBbfRcpEKA7a8rbin5I7IW6IhxPmGEO8hutShFBlpl0IYGqAl?=
 =?us-ascii?Q?StauS5mYlPYSwSjER+CDyWCwQ04F/2CkAWrkDWc+m0MyOjdq9ZnCRg0tgM9W?=
 =?us-ascii?Q?HQsogjmoe6sybh0Lo39A1I1lz3GEFGA3JPWieRi9OYKVWWsHhQcKYfgiSzBY?=
 =?us-ascii?Q?39+L9KU+5PFLjp9QREjyQaHsxTK86aAgDgrBo041ObshL1rW4ZJGg2Hw9f5M?=
 =?us-ascii?Q?WnLvtT8tYpLw+Y1KxoCBMhTDrSFMoIhARynYwMMIPzXy26Ouma9Y15YUzZ2/?=
 =?us-ascii?Q?02/DSxYRTAcx3khRY3NxEComtEP6R/uShbtIZb99nqD0QaCn1YI3VM1nGTPZ?=
 =?us-ascii?Q?dH8qUkLDGpSWpBjKl+E/RPCGvosNN0r8MuUB7T0ystv9kQrZvCxwHkj2PrmW?=
 =?us-ascii?Q?ftGUHLH6S1WuGrStOmYOcdZDTTtt1fEqnL5C+sKqSWV3YpFB36c9oPYL2Ju1?=
 =?us-ascii?Q?Lu7cQxzAHlLcFANbAu7Cf9k2NKMsaGiFsuR3hI0DFhUzRWMUNximx2LTWlhy?=
 =?us-ascii?Q?Q1lwXJ6NsB0SfVNVrjB2JIryVaqhksWqJgeFY50FZSprZ5TrN8xBblFxfZSk?=
 =?us-ascii?Q?oLy5gy9q0psmvI97NhqGlcdaz9x8y5K9Yn2wMP2WFaws7iNAU6hZcPNbp42x?=
 =?us-ascii?Q?wLjJRBaAKupAhXh5/qqaFOUVQrgLkOiqEyK9nsPwNEWPYU0LFLJOUHCQLW7z?=
 =?us-ascii?Q?vteHj4ZCSpPWfuL38psnOL5A9kKx6yOm5DPeP/0NciinEncjp/6igQLUZKMK?=
 =?us-ascii?Q?YDqcRR7LDrkvef6GQ6eTFkhu3GBP/sUFIxj5KGpzJMX72Ry3+WuTL2Po7uwY?=
 =?us-ascii?Q?aJfjRPaiff1mxTFD+rMFQKhDjpBHxa4Fn/7qBkkWj9XxiInJsQWIDxTL2i7d?=
 =?us-ascii?Q?BINC+VhZnL9QtbCFT9wWPzYR47H4PydgpvV6DGE/0yjtM7IbM4n+FaavhTZ+?=
 =?us-ascii?Q?LvUjrTZypwo/Vl8yW9734ytlBelswcElEdQFEAYJ/K3ETKXnc5HVtPbVXNJ0?=
 =?us-ascii?Q?fT2JjjCrnGBudUCDF3kxJAouhm6DHwbYJfp3qC3Y1So9ACiZZCkNGBPJmUxk?=
 =?us-ascii?Q?vsvPfCB7UDnbGfGQAX5tEufBS+4SG/CLFBxMpl2Ep0A/LpQCXKFgrJ5gLgvc?=
 =?us-ascii?Q?b3n/IfBInuTd2MjIvHaX7NcAgU/zdDw81LCuWKAi1fP8WmHsCzAuwnV5xLas?=
 =?us-ascii?Q?DQ=3D=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da16cb55-b462-49d3-5046-08dc7f75ec31
X-MS-Exchange-CrossTenant-AuthSource: NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 00:26:03.2239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /W1mFWd5scbc4k+CCpcLcRoFYrr+oakPNWEiQiP+qCUuCFyePYD1AW4oX6EBlG+u37brvXuRiWmNHrzXmbDfJaw9FPAuY7ZemjUM++HUhOA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: NT0PR01MB1264

Hardware expects RSA input plain/ciphertext to be 32-bit aligned.
Allocate aligned buffer and shift data accordingly.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
---
 drivers/crypto/starfive/jh7110-cryp.h |  3 +--
 drivers/crypto/starfive/jh7110-rsa.c  | 17 ++++++++++-------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.h b/drivers/crypto/starfive/jh7110-cryp.h
index 494a74f52706..eeb4e2b9655f 100644
--- a/drivers/crypto/starfive/jh7110-cryp.h
+++ b/drivers/crypto/starfive/jh7110-cryp.h
@@ -217,12 +217,11 @@ struct starfive_cryp_request_ctx {
 	struct scatterlist			*out_sg;
 	struct ahash_request			ahash_fbk_req;
 	size_t					total;
-	size_t					nents;
 	unsigned int				blksize;
 	unsigned int				digsize;
 	unsigned long				in_sg_len;
 	unsigned char				*adata;
-	u8 rsa_data[] __aligned(sizeof(u32));
+	u8					*rsa_data;
 };
 
 struct starfive_cryp_dev *starfive_cryp_find_dev(struct starfive_cryp_ctx *ctx);
diff --git a/drivers/crypto/starfive/jh7110-rsa.c b/drivers/crypto/starfive/jh7110-rsa.c
index 33093ba4b13a..8e4ea607102a 100644
--- a/drivers/crypto/starfive/jh7110-rsa.c
+++ b/drivers/crypto/starfive/jh7110-rsa.c
@@ -74,14 +74,13 @@ static int starfive_rsa_montgomery_form(struct starfive_cryp_ctx *ctx,
 {
 	struct starfive_cryp_dev *cryp = ctx->cryp;
 	struct starfive_cryp_request_ctx *rctx = ctx->rctx;
-	int count = rctx->total / sizeof(u32) - 1;
+	int count = (ALIGN(rctx->total, sizeof(u32)) >> 2) - 1;
 	int loop;
 	u32 temp;
 	u8 opsize;
 
 	opsize = (bit_len - 1) >> 5;
 	rctx->csr.pka.v = 0;
-
 	writel(rctx->csr.pka.v, cryp->base + STARFIVE_PKA_CACR_OFFSET);
 
 	for (loop = 0; loop <= opsize; loop++)
@@ -117,7 +116,6 @@ static int starfive_rsa_montgomery_form(struct starfive_cryp_ctx *ctx,
 		rctx->csr.pka.cmd = CRYPTO_CMD_AERN;
 		rctx->csr.pka.start = 1;
 		rctx->csr.pka.ie = 1;
-
 		writel(rctx->csr.pka.v, cryp->base + STARFIVE_PKA_CACR_OFFSET);
 
 		if (starfive_pka_wait_done(ctx))
@@ -251,12 +249,17 @@ static int starfive_rsa_enc_core(struct starfive_cryp_ctx *ctx, int enc)
 	struct starfive_cryp_dev *cryp = ctx->cryp;
 	struct starfive_cryp_request_ctx *rctx = ctx->rctx;
 	struct starfive_rsa_key *key = &ctx->rsa_key;
-	int ret = 0;
+	int ret = 0, shift = 0;
 
 	writel(STARFIVE_RSA_RESET, cryp->base + STARFIVE_PKA_CACR_OFFSET);
 
-	rctx->total = sg_copy_to_buffer(rctx->in_sg, rctx->nents,
-					rctx->rsa_data, rctx->total);
+	rctx->rsa_data = kzalloc(key->key_sz, GFP_KERNEL);
+
+	if (!IS_ALIGNED(rctx->total, sizeof(u32)))
+		shift = sizeof(u32) - (rctx->total & 0x3);
+
+	rctx->total = sg_copy_to_buffer(rctx->in_sg, sg_nents(rctx->in_sg),
+					rctx->rsa_data + shift, rctx->total);
 
 	if (enc) {
 		key->bitlen = key->e_bitlen;
@@ -275,6 +278,7 @@ static int starfive_rsa_enc_core(struct starfive_cryp_ctx *ctx, int enc)
 		       rctx->rsa_data, key->key_sz, 0, 0);
 
 err_rsa_crypt:
+	kfree(rctx->rsa_data);
 	writel(STARFIVE_RSA_RESET, cryp->base + STARFIVE_PKA_CACR_OFFSET);
 	return ret;
 }
@@ -305,7 +309,6 @@ static int starfive_rsa_enc(struct akcipher_request *req)
 	rctx->in_sg = req->src;
 	rctx->out_sg = req->dst;
 	rctx->total = req->src_len;
-	rctx->nents = sg_nents(rctx->in_sg);
 	ctx->rctx = rctx;
 
 	return starfive_rsa_enc_core(ctx, 1);
-- 
2.43.0

