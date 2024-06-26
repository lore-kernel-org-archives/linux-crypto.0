Received: from CHN02-BJS-obe.outbound.protection.partner.outlook.cn (mail-bjschn02on2093.outbound.protection.partner.outlook.cn [139.219.17.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3C012E6A;
	Wed, 26 Jun 2024 01:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.17.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719366066; cv=fail; b=VeHaSk/9Lo23x6YEIESqbm3rt4F7Ly96SKGJBbXiwPGdaveE50HN40zooFdZqF8538dyAHMNleb4MKmSLQvKS4KqOX36OD2wRmfVxE5vEHkAj2nSi3ViDPyvv5vm3ruVUQp6bmzSt79UPEber85vbDmKp1RXnN7Yc38ifEpULgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719366066; c=relaxed/simple;
	bh=evM3USGaiat8KlbVx3WMuQf32F5R4l8hMHKhDijgCOE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cVtkUdwF6mE5M8uRqtwZSxWULIytm7bin9pQKMWJ4cPANTkV2Y0KAFhquQ3rjhf3udHmjp+09AZWWbULPddwFbTDuaYtd5jp8u4Jp7JZtryYOxYmQLVipSxskdFoogRvxEUyii8K+aUa8oYdfOPalBoJ0dnd5PgUD4cXvx2DEzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.17.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vy2TkDu5TtZ6WE2HKrqP44UUf1RBR7N98BHI0g9AX+lbMMnd/DPBYGnya8KApXWTNCUbqEqQvUD0JlFF/EU4RuW+Ie3pVgUsmQFRLnj98MwmXrZSXa6IfwwmbIxjMTD3eyzMQ+WQXiOBUWhNEMkYkIEidkUd6m/7q2IPgDzWKPXJGJjLqpgBrZdBEL2ZGDXufM9Fi1XNtv2ysJbvvTaG8QqRPeCzR9kCTcuSejucESwRriYr8jiz2VBY1NM+JIDatVmA6lCIGnW3AM8sfyNkayqJWwpov9X3Eo5IS6nPTNMMtT6olWK4EonkCKl7oIfis5+Z7rZIgvwKCukBFNjs9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7nlwGyR7Xe/aX6GPnAMm0aFMUpBY3m1wod3XVlgjdlM=;
 b=eWiBy7L+VxNbzEsT2Lqa8uY4vwoyxk9yDidZlspUW+AscO4FYS4zomN3lnuY4/hDxKO1lmByD5pRpxHKGON5wPRWMUHXVxA1Gm/2OxykLxFcrTWdtrL79hrtpKGEgPyhVqWKGEvVDYQ9TzJJp0RcXBrDk4uClz0kCTZoLgfc1bhD+Ah5JugNNOqa+utBvmanscoA28E0q/eSg5kj9Fl3ehlTOFJjioWbPd7UB44o4ajAShBE78Sxu8/dU0mQ9Tz1e+9F8Pn0yOfJ5//21G0BShHoV4nm251V02dRZDnp4dIYt9R86UBVM/aTQteLABTY6NTKWntnO/nd5dSkELJ2NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::10) by NT0PR01MB1150.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Wed, 26 Jun
 2024 01:40:52 +0000
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce]) by NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce%7]) with mapi id 15.20.7698.025; Wed, 26 Jun 2024
 01:40:52 +0000
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] crypto: starfive - Align rsa input data to 32-bit
Date: Wed, 26 Jun 2024 09:40:42 +0800
Message-ID: <20240626014043.1194521-2-jiajie.ho@starfivetech.com>
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
X-MS-Office365-Filtering-Correlation-Id: da5207ab-0e80-4c2c-765f-08dc958103c4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
	BCL:0;ARA:13230038|1800799022|41320700011|52116012|366014|38350700012;
X-Microsoft-Antispam-Message-Info:
	SU/qndHT3AajPedoKbYE05rWb8idO2uye6Z1natLZIouVO7/YKFavQdDcVW4eTtg35R1QWLyoYLvD8DBKtyrDvO91KqOwY2kjwXdmicpX0NtB7it1uTrpmeo9Et+PwaWhunTh67e6ZhIRndedN/AsysbmZLTG+ETN8UknTKG3YrSqokWNgkua7tAhrghq7e9DyUhlTEkR88uqTyXaw1DGEBk/UFPRBvEnDylRPbQVoQgLB8FnnfxcV8pK1YIbTCS1HlCtDd8LwS9xhJnwTnwup9kLSKjcHKV596do1kdNyuyxowhtqdvlNZHo7aRhOdDEY69Rs+hVunb0r5TDmUpMvngfOWy+1fPzLLaKst/Fgg+z2cP4E6rXU40j3vsb1OcHzyrDkaPbHVR8h9wF8lnZDEVlfn5+aAbFuE6RhWHDk6ipwsMpeNRodkuiljui+ntJac327TC+rdTxEwtCdzXJ4cKqk2GK1oqTgydqeROSuKRddsu1biax1PBCw/6kW4fpQIm5c0Ge+enkNfixKMN52glYOxjkaYeVu36hAWAhq+PCtJnR7sxaXoWgXdtrtPO/G+rMhDyeHS+ZbltPFZbyNyrDhW9QxfnnSxpPb1yhW5e4VZh/L6kRPwRu8AuqQsd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230038)(1800799022)(41320700011)(52116012)(366014)(38350700012);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iqDTSeuWwBAGjOAvHKJDm7kdyPHsK93nqefaxsMQux9yaBU/F2P83bYjKZ0C?=
 =?us-ascii?Q?bhVuNarXotDTVY1GJikErEIxMexdeD5gtAPAcFIdKyvsoyo98/MzvGO8QSJk?=
 =?us-ascii?Q?YQcGZ9uhoh6DRfnl2UIADCnyjlmhsl1tMBiXTmFM3vDHdNEukz4L9XUivXVo?=
 =?us-ascii?Q?uqwuNM5ObL6NCeBBmvY8YPXEF4sH/6IBDztst7OjsjWnPrvhkCEfupqvwhOR?=
 =?us-ascii?Q?KCs9WcyzP+mtpgHp3dSbPgiShdQFzkCjH4D22jE56eBQs2FZA87eeAiJ4WGF?=
 =?us-ascii?Q?Jb3/HppRYmHV116rOca0CMVTZA5TBCrI/dO7156S7w+NsGHpDvYsu4rpg+wB?=
 =?us-ascii?Q?cXhSBs296rDMJC1fdPP/cmRUHu1H7aqSlwSJAwdKZ0OwLQivbGdqXh2Zr/GW?=
 =?us-ascii?Q?q11yHyKQmdkSMjLzzQ/nY+/R2kamLy4+zmdBtpLbhkuZ6GsONot46CL3/2uh?=
 =?us-ascii?Q?Eqg7cOW3H6nzbWsn/f+rAr4xhYrWDUWfILy9T9jRwCkBFDGZNBST/eJRjDUA?=
 =?us-ascii?Q?AEg1iYepDIcDVVyBGv/w1zKxh8McYZevIIVlxwwDBCZ5tTof7vmFNUGad3YR?=
 =?us-ascii?Q?NLwGiaBkyXcAFxFuoyfKAe/8xUoq7vBHJn3HWX8E9bmi0T1WUNCl5XQIUXof?=
 =?us-ascii?Q?BH4dQODSVdf0n7px/HOTgeQaVa5Av0p+i2j1zDA6HF7bHYsbMnOqEAHmPtV0?=
 =?us-ascii?Q?/lFgd3csCi3Z09P5IuOrxJr7QzukT5TxhnOTOguvEu06H/i75BP9CfhG352z?=
 =?us-ascii?Q?Ug6UJCpPVe2guSnpb4lc4JwfQGT1sWVlrqxvquxeG/qlb6GWqobGGweqX3SJ?=
 =?us-ascii?Q?V/VhTyHabzTuqStKI4eHe0qebf1C9WDsKdeJN5BLDhX8KfP652RKnFDDhGLK?=
 =?us-ascii?Q?5uq72JRImN8pFv92DlJFWWksRiJD1wd+yaqOWmi/LGWmoIkYGG4Ldhi6gQ/m?=
 =?us-ascii?Q?7LY2Oj859SerGeQHnPEB+7E5tCiH+TFqFLgwpXREc7F+AzV6AYvpYD0M9Rf4?=
 =?us-ascii?Q?aMcMJDip0KAJboG+7KFgnV3sABKforjWLMGA9iTSxgWloPDWCgmqdvxHfB/+?=
 =?us-ascii?Q?er35EwrbS1qdmIbw/+EVAyi6b4bau8YXR/bvmLZsNLpy42r8G4Ht5wzO3FBM?=
 =?us-ascii?Q?QnSvys+fn4mPGqVcp/4INwkSrEGNIhBNoodb0TiQqMtAvfmNLd/iRWmcHFeN?=
 =?us-ascii?Q?x/fUBIzCwCj4pZ1wXPlKN0AHOP7M4V4rGauqAzl1C5/g/jHN3394UyR6XdnW?=
 =?us-ascii?Q?zAR+tcGsMHijfMmRxhoIesc7NJbSMOuXMIFHmC72FMe3m6X3X8W9KAK6OYVe?=
 =?us-ascii?Q?RdxgV1QZ5Za5KBWdPAUHxQQFm16zD41FNXfJH3SjnygkVev2NuV8qPNcCXg0?=
 =?us-ascii?Q?p6dFabaZFg7T/eyIkWy1KfwhWm3eFGxgUwiN4rvED9qGgAOItXQVv8IGPBAP?=
 =?us-ascii?Q?UHgRv7pHNB+ODqUx9GoTzwAIeWjNT/K+E1/0PBsKLVseMG1hngH4+aMdvERw?=
 =?us-ascii?Q?KztD+8gZzj+gsGnx3gPsgYEDqMU5QcdPKxhGIYiBeFwVf4LyKxxDMskXM844?=
 =?us-ascii?Q?YtpnE3NqUQYxUoLWMG+MdrW/HZFOxiqsHStHTrNYubvHuIcb/5QCMUKCQ0Rs?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: starfivetech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da5207ab-0e80-4c2c-765f-08dc958103c4
X-MS-Exchange-CrossTenant-AuthSource: NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 01:40:52.7893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hA9oodCLX9P2MogEUb90k8BiTSP6uS3O3NMsy1jPklIIvm/O0yO+jdBXHP/zHKtnRTi6eupusdAskRVSfV5nbgZyfkEkKqjnP3PNzjHOMrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: NT0PR01MB1150

Hardware expects RSA input plain/ciphertext to be 32-bit aligned.
Set fixed length for preallocated buffer to the maximum supported
keysize of the hardware and shift input text accordingly.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
---
 drivers/crypto/starfive/jh7110-cryp.h |  3 ++-
 drivers/crypto/starfive/jh7110-rsa.c  | 12 ++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.h b/drivers/crypto/starfive/jh7110-cryp.h
index 494a74f52706..85c65c6c0327 100644
--- a/drivers/crypto/starfive/jh7110-cryp.h
+++ b/drivers/crypto/starfive/jh7110-cryp.h
@@ -30,6 +30,7 @@
 #define MAX_KEY_SIZE				SHA512_BLOCK_SIZE
 #define STARFIVE_AES_IV_LEN			AES_BLOCK_SIZE
 #define STARFIVE_AES_CTR_LEN			AES_BLOCK_SIZE
+#define STARFIVE_RSA_MAX_KEYSZ			256
 
 union starfive_aes_csr {
 	u32 v;
@@ -222,7 +223,7 @@ struct starfive_cryp_request_ctx {
 	unsigned int				digsize;
 	unsigned long				in_sg_len;
 	unsigned char				*adata;
-	u8 rsa_data[] __aligned(sizeof(u32));
+	u8 rsa_data[STARFIVE_RSA_MAX_KEYSZ] __aligned(sizeof(u32));
 };
 
 struct starfive_cryp_dev *starfive_cryp_find_dev(struct starfive_cryp_ctx *ctx);
diff --git a/drivers/crypto/starfive/jh7110-rsa.c b/drivers/crypto/starfive/jh7110-rsa.c
index 33093ba4b13a..59f5979e9360 100644
--- a/drivers/crypto/starfive/jh7110-rsa.c
+++ b/drivers/crypto/starfive/jh7110-rsa.c
@@ -31,7 +31,6 @@
 /* A * A * R mod N ==> A */
 #define CRYPTO_CMD_AARN			0x7
 
-#define STARFIVE_RSA_MAX_KEYSZ		256
 #define STARFIVE_RSA_RESET		0x2
 
 static inline int starfive_pka_wait_done(struct starfive_cryp_ctx *ctx)
@@ -74,7 +73,7 @@ static int starfive_rsa_montgomery_form(struct starfive_cryp_ctx *ctx,
 {
 	struct starfive_cryp_dev *cryp = ctx->cryp;
 	struct starfive_cryp_request_ctx *rctx = ctx->rctx;
-	int count = rctx->total / sizeof(u32) - 1;
+	int count = (ALIGN(rctx->total, 4) / 4) - 1;
 	int loop;
 	u32 temp;
 	u8 opsize;
@@ -251,12 +250,17 @@ static int starfive_rsa_enc_core(struct starfive_cryp_ctx *ctx, int enc)
 	struct starfive_cryp_dev *cryp = ctx->cryp;
 	struct starfive_cryp_request_ctx *rctx = ctx->rctx;
 	struct starfive_rsa_key *key = &ctx->rsa_key;
-	int ret = 0;
+	int ret = 0, shift = 0;
 
 	writel(STARFIVE_RSA_RESET, cryp->base + STARFIVE_PKA_CACR_OFFSET);
 
+	if (!IS_ALIGNED(rctx->total, sizeof(u32))) {
+		shift = sizeof(u32) - (rctx->total & 0x3);
+		memset(rctx->rsa_data, 0, shift);
+	}
+
 	rctx->total = sg_copy_to_buffer(rctx->in_sg, rctx->nents,
-					rctx->rsa_data, rctx->total);
+					rctx->rsa_data + shift, rctx->total);
 
 	if (enc) {
 		key->bitlen = key->e_bitlen;
-- 
2.43.0

