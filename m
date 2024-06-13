Received: from CHN02-SH0-obe.outbound.protection.partner.outlook.cn (mail-sh0chn02on2093.outbound.protection.partner.outlook.cn [139.219.146.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBCA13DB99;
	Thu, 13 Jun 2024 10:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=139.219.146.93
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718275559; cv=fail; b=nkOi+VABN5WMPtCIwnW2N4i8D5bINJjG0W8FtE3yqHOlsOZ7ZYjexinYWirJTQBS1c0BHJA7XLJqktrz0rDQSqWP/9GZbcfgyjXOKdU02Zyh+2BsqpV94L1dtAEpCRy7R4Ra1sYfSouSzkj9nAwnRl9R/7I9L5fhjTO0Knh4g4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718275559; c=relaxed/simple;
	bh=lmpeF614nhHInyvE4yYzdmxpD8+din7ye6uSPah03QA=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NS+YWbyiu4M8F1LuVLKBC+h7seCO689TSsS7v9FNebbYOJQnPGaI1ZlrKwf84jPLyE85OLHnupJ01SXvkunBnip3pDoOCKxX0hrWDw/jPu1BFE0LSycYvS6gCqexeo+UZzzM2Q9I4uSLPUi0Jjc0cvfFxg3qP9N7+wUeQM6hfvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com; spf=pass smtp.mailfrom=starfivetech.com; arc=fail smtp.client-ip=139.219.146.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=starfivetech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=starfivetech.com
Received: from NT0PR01MB1263.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:11::14) by ZQ0PR01MB1255.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c550:19::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.39; Thu, 13 Jun
 2024 09:12:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqxQok2iin5yakxCe5WGlyim79dixVRBvD0LXBLkvbriQ4ZTxYwHQJ8iO6/i7L8TDbwumgcuuVEB0W0HhhZ1ni8ghvhLujD0k0v5WhbhXY9AcDBlUylaRZsU/raTTVH9/t9oVkWC4F41JE2Qb9ge7zH+V2IqYDPEm2zxKLHrwdG3dvIbw+vEHFIhGp4oIdt+MffHkWJDby/i6XxZoWVQN7nQ25acP5lsGeCCFzJ3X5qxtDn+0slc9rteSyZEoUyokAzerkTn9YQ1/o+urxtCyxIfvE0ZkCIe3h4Im6PCnmAEUOpyoGZgK55+7v9v+OMU5n8ynhkjy+KKElr/vGX9wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cNBqp2dMM+1apCiiqib3PkJLJY6HaIewlw4wPbfiKXg=;
 b=KqX7dgbTA3cc4k80ZtGKOVjHFm26QRk4DzY/SVBTDRmYUtjm7VKIi7CnGW8B7znD9KheTW8cYxBVPfvfkZWVIeEczoC+Yi8apiXBxAbGPI/qVUDpz+wXVDyNtGFoj0FfO1ngxL1iBPHMtCW0W1MHg6GhGLJIwajOMdNUDttbvzMkheEmOrv9PzrUVJsvtoJ5k921G8MhdPEUsmD3IJXLSuLGgF3cfmNJkdEwlEC1OlGqUkp3anPu4CikZvseUZr5/hbrvGpXKTJlFq8VManLcqv58XFPynoXDNtE9huPk4BpMVmvLxpTliLQrRx2+7cxz4Db5Ec+JKUkuySPi3WaCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=starfivetech.com; dmarc=pass action=none
 header.from=starfivetech.com; dkim=pass header.d=starfivetech.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=starfivetech.com;
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::10) by NT0PR01MB1263.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:11::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.39; Thu, 13 Jun
 2024 08:39:51 +0000
Received: from NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce]) by NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 ([fe80::e3b:43f8:2e6d:ecce%7]) with mapi id 15.20.7611.039; Thu, 13 Jun 2024
 08:39:51 +0000
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: starfive - Align rsa input data to 32-bit
Date: Thu, 13 Jun 2024 16:39:42 +0800
Message-ID: <20240613083942.760182-1-jiajie.ho@starfivetech.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SHXPR01CA0014.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c311:1b::23) To NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
 (2406:e500:c510:10::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	NT0PR01MB1182:EE_|NT0PR01MB1263:EE_|ZQ0PR01MB1255:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e9bbd63-d1c3-444c-25bc-08dc8b846404
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam:
 BCL:0;ARA:13230034|1800799018|41320700007|366010|52116008|38350700008;
X-Microsoft-Antispam-Message-Info:
 HcAXKOIpoJ56OW6jtPkgnQXZFeYNQ6nN9Y2JRlANhRnEeykT6WfYLy7kdwHTyu1xqS+modGc85hkZJMvkkZadqC/yZqRa/qmate19oj/2srrd9JWdyWPksR80MlpgEmPHDxgzUycHfo5Uavh6n1mBX95DmE3xxl7TYnHKhdi1LYxEoM034cQ5fmdQZl0pPvqe0R9wDQtSfZuYT0QhAqyhg3Gs7mVCZU4fZWCmP4F9AIbmGxGfdHkD2O02WrxIX1KlxnLo5mKlAAYXsWqIIMPKhCcR+WFgV1PBY60N7y4dd+3c1n+zbUg699Rdj0xr3st2ovQYmkaXn4lwVqcie202Bi/+p61TkWWm9/SRnvkyVjf/zEf4gdoQZ3XPWCSKYRkRMExeC99LlR+uhFOGYxvPZGTsxlOCLDgRSz+Elbbkgrrwt3dQnENDhJoFg5y7kbRi8S6N9fpOINMBXWgRfWROrq+Y8S0c5ul8JBvwX+q8i7BxKLXdB7Dek6fmrqcCzi//q5gki6AomuOi0rkQ91KjHiO/Grgps1vCzxFkPd/CV/8Yt58tHn+xmlvyl0FjfOLvlPZeCESHKaHGgjDWOdObXGi3cHShHfgRkRyVVLHlnMZxuAmVLDWTXeguk+DzFEz
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:NONE;SFS:(13230034)(1800799018)(41320700007)(366010)(52116008)(38350700008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?DxzsMKNIYoR5q26BAaJXKXjQq5P/sVVomjSTEmWXDJJ3dnl1QrO1UuSQns9S?=
 =?us-ascii?Q?ltjGJ2kYLwROzrEPU44SXVxboCl81Qy3qR7YBfmLQCNYL3XPsNvT7hTq1kXY?=
 =?us-ascii?Q?Q5PIq+MQ7NU32P1k7EDBzvz2WekLnN/pnNLH/aCU7PnCbJECMA/kgWa0EsXW?=
 =?us-ascii?Q?I3zWSkIbLPxOvKEIi+4iFtrhhNV0bElLxKHQYXxRFDbDHdIEK5irSiapBrta?=
 =?us-ascii?Q?sRsh28YpVtczors7mov0PQATJR3ivqcgzBF5MR1TaNeNDpd7Hp7UpI/E+3Ae?=
 =?us-ascii?Q?ucP/TYKReFuu6jWxwaeMg6L/fk1NyNxsbLm7WI220zW3OUG7dU4Jd1ujJnMJ?=
 =?us-ascii?Q?HlY8jpnSyBHabbWRAcwpzBXP5g/gRIwoi9eL8i74qG0K6JulAPiUlpp4QfLD?=
 =?us-ascii?Q?B9pgleqS7Enq7aGY81wuF+2kXSQ+21fO2wi+EZXvFghplcMWcZWnWRP/Yuzm?=
 =?us-ascii?Q?orul7Ok5J1tIDQLg1AvjViC5oKWCifCZTQjcSXK234YOK2cn0M80vWy8QKxk?=
 =?us-ascii?Q?riqDUgaCiAWEE717My4SCULcrLskEHIZ3rJFLzNoauSiB8Jy6QCGVQkF5Qnj?=
 =?us-ascii?Q?sra3o6Wmdd1DqIIgKq8rKzMFyDXtPuSZLHULNbE+jNRUBhmMssHtQGrHcl2j?=
 =?us-ascii?Q?vH1JKn1x9iNkY3xH2JMMUTnbn82RnRdCrsI2iLEzu0WzaXqceYwz79yANgND?=
 =?us-ascii?Q?k6c1b5CYTfbnXiukou/MSRYibHhynW9V3Pf7iXbPOJd/In4kTqF7i3qG4sUO?=
 =?us-ascii?Q?OlePtpF8+bdvAuObuKTMNKbh8hOngdnWGHmzEPX+U8kewpvsrT/K3LH+plun?=
 =?us-ascii?Q?b8IVUX6zW76798YnZNFBONLBK46esI0grZ+lgma2BOyqZXlMLkasIeU4qYKZ?=
 =?us-ascii?Q?MM13W+AgHroNRyOb3Nj/2vjh+Nh9eFa6weTuyMH6JZd5kGcGh1oV3dD+l5qj?=
 =?us-ascii?Q?FxZTDzazMsgnMLt7bABHf0c3D6eTPLhaEA607GFarw+74wkD5x7FwuW+vzUe?=
 =?us-ascii?Q?SN6zQQG7yGsB6/eOi9NOlcWB/QyGhcD+YgvUxhW/sTUvDGMm44LS14n9oV1G?=
 =?us-ascii?Q?O3VQN09m9K23lHeqaAjp5Gb19kN7uqbU2I9p5jlRnvpbvyPYyIPX+1NtL5nF?=
 =?us-ascii?Q?LVYW4J3ECMQp0eFZc1UaPT7UNA8yJsTJkrNcl6UINuN84vpq7MauJM3UeZdF?=
 =?us-ascii?Q?wFW54SrUHlrMqpJO/2WFGoWaX2WU8985p690goVuW+YdjtY9DbM7fNFWQU2m?=
 =?us-ascii?Q?cmqzC9CgOjiNuA/wBVD7kVINIXyaE7MeH1MVZKABTi3txFEmFLckVYW5Zuyn?=
 =?us-ascii?Q?nsAu43YqE8IHBDGFk0f9tqh+02ZtNzHoBOvko/59m6UbeeQ4pCGXl1eP4/ZR?=
 =?us-ascii?Q?JhL8z7kGGLPZYL/ditopuIRJC+TjReGaK8GY/y9/rLOtW5F9LgPYA4tVutWN?=
 =?us-ascii?Q?bRXZpBbAgKQTBisndZRbZI4Tun7TRJCPZi5Vxmc7s7p380vqye9XORTs8xNJ?=
 =?us-ascii?Q?D2g9tkgeKqAi1TdYNmWH/esbg/NiX1fpBtcmG1edE3Oh2+Sm8rU4gqWraGhn?=
 =?us-ascii?Q?l2GlFU/4W04PqDOnHpivafdwPZ80UGuP0fa9KfvAAaIigHRSm7ygIKOMUAdh?=
 =?us-ascii?Q?fA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e9bbd63-d1c3-444c-25bc-08dc8b846404
X-MS-Exchange-CrossTenant-AuthSource: NT0PR01MB1182.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2024 08:39:51.1510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 06fe3fa3-1221-43d3-861b-5a4ee687a85c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kfCvbasEaIpSTGGDudvVXXP/He26JDUjxK+sqeQ6KP/zrhU7gYWVr3HtWolQPcQXPK61sDrrzKb2Nmv9XfV2Ps61GJLLeZobhBnKMq6+aR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: NT0PR01MB1263
X-OriginatorOrg: starfivetech.com

Hardware expects RSA input plain/ciphertext to be 32-bit aligned.
Set fixed length for preallocated buffer to the maximum supported
keysize of the hardware and shift input text accordingly.

v1->v2: Build the extra space required for shifting into reqsize.

Signed-off-by: Jia Jie Ho <jiajie.ho@starfivetech.com>
---
 drivers/crypto/starfive/jh7110-cryp.h |  4 ++--
 drivers/crypto/starfive/jh7110-rsa.c  | 17 +++++++++--------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.h b/drivers/crypto/starfive/jh7110-cryp.h
index 494a74f52706..ad0bc8878522 100644
--- a/drivers/crypto/starfive/jh7110-cryp.h
+++ b/drivers/crypto/starfive/jh7110-cryp.h
@@ -30,6 +30,7 @@
 #define MAX_KEY_SIZE				SHA512_BLOCK_SIZE
 #define STARFIVE_AES_IV_LEN			AES_BLOCK_SIZE
 #define STARFIVE_AES_CTR_LEN			AES_BLOCK_SIZE
+#define STARFIVE_RSA_MAX_KEYSZ			256
 
 union starfive_aes_csr {
 	u32 v;
@@ -217,12 +218,11 @@ struct starfive_cryp_request_ctx {
 	struct scatterlist			*out_sg;
 	struct ahash_request			ahash_fbk_req;
 	size_t					total;
-	size_t					nents;
 	unsigned int				blksize;
 	unsigned int				digsize;
 	unsigned long				in_sg_len;
 	unsigned char				*adata;
-	u8 rsa_data[] __aligned(sizeof(u32));
+	u8 rsa_data[STARFIVE_RSA_MAX_KEYSZ];
 };
 
 struct starfive_cryp_dev *starfive_cryp_find_dev(struct starfive_cryp_ctx *ctx);
diff --git a/drivers/crypto/starfive/jh7110-rsa.c b/drivers/crypto/starfive/jh7110-rsa.c
index 33093ba4b13a..f8a1bc5dcf0f 100644
--- a/drivers/crypto/starfive/jh7110-rsa.c
+++ b/drivers/crypto/starfive/jh7110-rsa.c
@@ -31,7 +31,6 @@
 /* A * A * R mod N ==> A */
 #define CRYPTO_CMD_AARN			0x7
 
-#define STARFIVE_RSA_MAX_KEYSZ		256
 #define STARFIVE_RSA_RESET		0x2
 
 static inline int starfive_pka_wait_done(struct starfive_cryp_ctx *ctx)
@@ -74,14 +73,13 @@ static int starfive_rsa_montgomery_form(struct starfive_cryp_ctx *ctx,
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
@@ -117,7 +115,6 @@ static int starfive_rsa_montgomery_form(struct starfive_cryp_ctx *ctx,
 		rctx->csr.pka.cmd = CRYPTO_CMD_AERN;
 		rctx->csr.pka.start = 1;
 		rctx->csr.pka.ie = 1;
-
 		writel(rctx->csr.pka.v, cryp->base + STARFIVE_PKA_CACR_OFFSET);
 
 		if (starfive_pka_wait_done(ctx))
@@ -251,12 +248,17 @@ static int starfive_rsa_enc_core(struct starfive_cryp_ctx *ctx, int enc)
 	struct starfive_cryp_dev *cryp = ctx->cryp;
 	struct starfive_cryp_request_ctx *rctx = ctx->rctx;
 	struct starfive_rsa_key *key = &ctx->rsa_key;
-	int ret = 0;
+	int ret = 0, shift = 0;
 
 	writel(STARFIVE_RSA_RESET, cryp->base + STARFIVE_PKA_CACR_OFFSET);
 
-	rctx->total = sg_copy_to_buffer(rctx->in_sg, rctx->nents,
-					rctx->rsa_data, rctx->total);
+	if (!IS_ALIGNED(rctx->total, sizeof(u32))) {
+		shift = sizeof(u32) - (rctx->total & 0x3);
+		memset(rctx->rsa_data, 0, shift);
+	}
+
+	rctx->total = sg_copy_to_buffer(rctx->in_sg, sg_nents(rctx->in_sg),
+					rctx->rsa_data + shift, rctx->total);
 
 	if (enc) {
 		key->bitlen = key->e_bitlen;
@@ -305,7 +307,6 @@ static int starfive_rsa_enc(struct akcipher_request *req)
 	rctx->in_sg = req->src;
 	rctx->out_sg = req->dst;
 	rctx->total = req->src_len;
-	rctx->nents = sg_nents(rctx->in_sg);
 	ctx->rctx = rctx;
 
 	return starfive_rsa_enc_core(ctx, 1);
-- 
2.43.0

