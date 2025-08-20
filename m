Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012020.outbound.protection.outlook.com [52.101.126.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014CB31B106;
	Wed, 20 Aug 2025 12:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755693438; cv=fail; b=Ow6RXFKpp4k56j8tKLKFsgb5XwWX8WSZvUB/okt5SfHAi6f5+P8SHXBTkiPkekaIfJh+HdttWYqpmw1X8+fSikR3Ai3dDtqJoiDO/puR+P7TzTdSx1yWAw0Hc4NXE494eH2IOtXbJmK1HooG4DH0zSZTHaiadLVw1fcJCu+YjTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755693438; c=relaxed/simple;
	bh=NId/81iGuSdbty8VgQ0V5ZTqSPcmMKCO8MH8or6KYBw=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=tx07bQvw0fQCBkawJy+ejGQv+G37eROyoYcQzOTmBTrT2XZ/vq7ivJX4YmAJd+TYDzUr3dyLcaUCprWov+q4sqNtIgFX2XNWzFbwHbh0DWbOx5A3N245E37edhjPnhItEdzysb+RtAzSgFz2fZFt7Co0syn1C4mhXLu8du2Dpmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=EiZXOgBu; arc=fail smtp.client-ip=52.101.126.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="EiZXOgBu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H4ms0Z/jgAbM7s7GbyNlSngJQ4z015yMhjXTZ82sHD/gImvYrHMzYjbMGuTH7KszXgsGYHO4G8/6gMPtR4sWoRIy2Bn4gMnrtRetnmBpCR9J/Nf9fK9ZIg0Dl1A73zXt2UoSZ+yl93SD6i75j/BVkeaMmvWR8bD81Iaa8nSoDAMwfcJFTLSIB2NQNaxfFIv1P64CRwupJYQAC5az0WBwMBdWF8+GRxv0oxX8Evb/JsJgxaIS5UAzb0qY+G4Lo1aEfofsCuGDtYW6mtrlR8lz+Zmjcpv2IdbKyD1GypkvdSJ8dJMyUt7DG+f7Y2e6Z/wh3W2Skkge4aXBFb4XG8M23A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XUetLnnsO34iHlSD00UU8kom63GKb5LZTTxcw1Wgaoo=;
 b=b1lXlCnVZHTuxK1XPmFKsaGnw/YZjQ7TbFh4jDNCcTk/c7qs0+AAyC0lA6gmiA19J3Mmq2Z2EA9NhT284lwjiPRIuZm+wu6uISbl8L/jp5XODSMm5IK562nWZ4+2xGbzLaXiXAS1lX3irx1qVf4dhYM1tx3pt6Vr5wYrckpr4dsziepWVPcpI4x7LgZ2H5BwduWbqPNy6hdmw+wcVXoltJSaaGyIHH8evymMO2bC8WPB3s2czf4Vi3XGONLGe0P8QuzjGWjekKUWVGw+W+R1CD4MsOWTMJ8MRHzXYbcMG2vdTnPLkfDYUpnmSgK1auW6hdjUOcG/FiJNv8ms8UTvxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUetLnnsO34iHlSD00UU8kom63GKb5LZTTxcw1Wgaoo=;
 b=EiZXOgBuQgLO9UAk+GLIwZT/CRSqT521InXYID+oOUZ+FE8FqMsU/jWoKyPBZMDlqpNqWjiHo/+Sv4ljiHkIHJaFRCUS/hwth7+n0kEXKBvAUzArukdLVsy0BPoztAeBjTcddm/89clfKx8haLLtC95LVdbm6aDQsMMLa+RkcJEdtjgI53dqaI695mX9sSnzh0kvA8yxYNXHbvv8X1vaf33eyobpsu1jhUPydwqtc2NzK3KgvaXInwXFhjpkGtNOXL4osWURwrgJmEZIyZQzG1GZEXFx5W9Qd66y824Wwniqsw1Hu93PxrnhcgybknVaPHSZWPhT/OOmMley11FGMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by KL1PR06MB6448.apcprd06.prod.outlook.com (2603:1096:820:f2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 12:37:14 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::5c0a:2748:6a72:99b6%7]) with mapi id 15.20.9052.013; Wed, 20 Aug 2025
 12:37:14 +0000
From: Liao Yuanhong <liaoyuanhong@vivo.com>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH] crypto: jh7110 - Remove the use of dev_err_probe()
Date: Wed, 20 Aug 2025 20:37:02 +0800
Message-Id: <20250820123703.473004-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096::11) To
 SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|KL1PR06MB6448:EE_
X-MS-Office365-Filtering-Correlation-Id: 560855cf-f868-43b6-1613-08dddfe64a4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zBuNKUjzdRxbNS4jkhHPrsNPGBgMjeEbnnyymTD+u/Dwa7xL/cFKlnOXfGKV?=
 =?us-ascii?Q?+sacg42JyZfasHDzEvV41QI8DfdZZ6ORi6r5n5ZPuUaFbdp0GWC3CIBE77HH?=
 =?us-ascii?Q?rcConWXYr/lssniZvUInN4446JqV8432Kfrqysxn3L/pOtNfK4u1JcWaCkgd?=
 =?us-ascii?Q?CjKBqk0juQ+r/NUwwgCrLWHREEasD1K0BvPsONeeXwcnX3iELPIq3VeQw87e?=
 =?us-ascii?Q?MRLk4mCYN8q7GqONoeC2zQLU4mTBI22Vl+6RUYCcvy8cGzGtfc0bqqMCgxyp?=
 =?us-ascii?Q?6VosYoqaPsGvDrqo6rvWijeuM9Yjfz7vaSWex8LWpPPUQKUozeqiTTz5yogG?=
 =?us-ascii?Q?KF3lSDjxnukLAq+7KTQnc9wvP4FDdkQ+L7chuHzIN+0yiE7cQQy3O1AdBVjG?=
 =?us-ascii?Q?Mx5JpjoRH/bh1i/CQBHkKesO2tr/VMaxsSevI7kcxeRmnUYEdE+vqh6AT9uX?=
 =?us-ascii?Q?M0oRM/KO4SXKmqY5yPyQKIOyoIJbnhldkvnHl18geZ1jdl//4Nlvqah1Jk4D?=
 =?us-ascii?Q?3bul1ijqg5OXBGbNizIDoeUtPfZqS+UkFZDleZDkQlegwLFCIBlFDR0TQ0Jc?=
 =?us-ascii?Q?y53hSpNHCVNVoKI1mjWAZxCG0nCoZ1LcH9aZzFk5c4TQ3oQXC3KaE+dvfChP?=
 =?us-ascii?Q?+xp16Feq5i3cvJYdI+LtXWFcwlSvFmfXhnwUu6YvrMOJ6TTZiqqsJ1u2+aIQ?=
 =?us-ascii?Q?B+r0tizLt03ijXED8Sg+eUbQWn3byOdqjSpJmTXskB9Ik6lXAuSWEk/t2tim?=
 =?us-ascii?Q?0SqoxH7fEIYezv2EZAFxI1Jjp6CwtHyOwa7nqqF9aAt2vFrHUznEgfs5vL4B?=
 =?us-ascii?Q?iVTzwLy6z8hy0CxcZd+nuK/m8DjoaDm0TW3as2+oRgTRllFYz1yZ5QquZ/nC?=
 =?us-ascii?Q?rP11sVYmVrjwzQl8xF5npu98jzcEXEAnj1s3RU0treti2DX0XPBgaduoeHJ7?=
 =?us-ascii?Q?5Fqr+HntD2DxKIVu4smfoQRv0N3KEhSI24Az8noF6DHoTbYIgk8r8Y+enB0y?=
 =?us-ascii?Q?swXGTQnvBxRNEjt1MlhDdJD7y3Zh5snIwNzYv9WOD4FKYN6bMiclMMmCpQbM?=
 =?us-ascii?Q?m1xDhn9oy4+HuLu8BCR5+cSyk/5iDFpqMtPWrE+7eZo8UuYjQXEXoZsvGvbO?=
 =?us-ascii?Q?11r2Yp7hMUm6iJ7tjgg68E2Y6OgVhDe0I+0BJJSzYn3jT6M8rVJCO51c+koP?=
 =?us-ascii?Q?yeldW90aCFGicZ5wW3dYxNC/wsRCaHYBt/8Lia6XOTGMKOGr1IHbXJuylXzt?=
 =?us-ascii?Q?xT+ftmBQaj8LNAdbxYNQstlv4H5RYbJiLPbRGW/VOyMVE0uKU65EtXE7R+ZB?=
 =?us-ascii?Q?fzzmmS43/hQg/4nPGxg6xKzoxZZAzPmAUbVQOfE1OHfjb9pLrSzXxBS2pe7x?=
 =?us-ascii?Q?oJe54iBUfxH9KeZFu2tTWyjKWGHc83PGwe6v6qgyxEYfvwrwSHlBJ0Y5VaT6?=
 =?us-ascii?Q?8N2mU2NE4MHXykhIJSj+/5boGj9Pd0UPgOR2SMzfyOeYvjtsPvJkxFgIJmLn?=
 =?us-ascii?Q?N+C2f/GEr8Sz55E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tfFKmCZfITU4yYtJr4FClv5tHfJX/p0v6DV2NFPJt6oA4bumoME6tAnlGlag?=
 =?us-ascii?Q?yMDAlEgxPBOk7d0VQ/8Wkl1sscMS3LGtkR87ShSM7HtASQWYtcQFuuQzg9qs?=
 =?us-ascii?Q?4dr2UqQMuC9f8DoIl9bXYF5rflYRqgJyyTr8nAhjYEb2kMwTKerJisvVir2f?=
 =?us-ascii?Q?SXCKpQTLJh2x6+NEwqpd4/QAOM0P+fHJh221Bxb3UpC2Pb7383L4Q3csQCBd?=
 =?us-ascii?Q?uz3F3vsiLXPG0ExjFmj3XOSNa91MPUBErBWXDfGO6jQPZ1xHafGdauwv/eC8?=
 =?us-ascii?Q?4ksWx5XF9+e9bFbOfTz/X71D0IVha6oJld7EIKrAqGEJIZac8JMk/c7vGsWZ?=
 =?us-ascii?Q?plOgag0QAFs2byN9wYU0ALUO5wKnk3gxybDGORJwJhMdgduFXSc/V2V4dCR5?=
 =?us-ascii?Q?JNXRA9OGie8S+Ppclj35CQDfYj6BoMqYjtOovGV7ftbUJfAzWkpGVhuGC2oc?=
 =?us-ascii?Q?7BYQyO8kvgLL73dfYW3keHpMldlWfuwDtEpSlMCcJ6IlvPh6/9XEVBsg1R2v?=
 =?us-ascii?Q?qRdewomCje6ebXwkG6EXXJq/HZfMd96Ce8B/bo/4Ai9HJA9tevogv4dRiaM3?=
 =?us-ascii?Q?cI6a8jxhvuX+uX8QzwIn9bY0z6ypkr/rAb3niuuecxcbU8JEvkcs0r25ZQFJ?=
 =?us-ascii?Q?axNtWcakNeFr9QZ59OT8Ag/ZlxASs8LWljFZ7C2KeSWQZvAjVeaQOHcRxOkG?=
 =?us-ascii?Q?R1CIJGxywXeLgwjKWPJnFXlFkwgIP//iTyrIkiHpc6Raf9f1Qp24IA124adH?=
 =?us-ascii?Q?dozw36ZUNsZ5I1yDXhbiciQ79qsQtwaJkZzpkZrVsTHBPZKcbnJjvDGRGGN7?=
 =?us-ascii?Q?Zq4M4ePH7UCgDYs6q8Pd2BPpM8UNPG7wJPj+dS9RxgU1CHTTDbeH3+PXXHeP?=
 =?us-ascii?Q?9oxpO01SnjA5taTVjLfvaFXQvO0KnnNG7rU7EbzO0X3FtjFIzIRDL+p7X3hh?=
 =?us-ascii?Q?seG7X6keZ/iRXOCRD9DBw4/xk9nYJqLdjpIDBrejhPJyewABrMTdnWyHjnon?=
 =?us-ascii?Q?Qk2plyLh3r9PhjwLc2u2JaW08jWKYdqar0TrM/IBCZTMm9ySNfz9xxHuEe4k?=
 =?us-ascii?Q?boD27s6Ht/2oUW3+vL/bpV/KjwN4gq6hX9pK9MB/FMq6MLHxiNH7E0wruLva?=
 =?us-ascii?Q?0Mugz2u0lAjeozfhOOkMUw3hTtDfknBij8uCTZ5Of9qA9k15dCCTDtnNlWXF?=
 =?us-ascii?Q?ZdcbA4/Zl1IcnmOzqFPURSRxvoME5z75cUfsq3idbd3xY3WFowJSEXGgmiKo?=
 =?us-ascii?Q?OJ2VJ9y552/gDSthO8h+W7auvumjB9SYEJbqw8TdhTyst7OyjYrDFAz/eRkS?=
 =?us-ascii?Q?0B+kgpCtmH/7ri7skSAICi3P8bDftz2/htVZ10DC2DQX/9DE6hwFTJwKEmle?=
 =?us-ascii?Q?2RdrZuUqt/+jmbY1llLYVvMlRrVsTvV6tJ9G7DRw1WTf3kwGGaGoGxDjlYUL?=
 =?us-ascii?Q?WzYttWdtbC/7awpCKslH3ZO1ZZapbNeP5o8k/1EWd7EcZPkL2HnKZ+dD/rYp?=
 =?us-ascii?Q?SZb/8X2hmxtdF3FtS1pt4LH2wEfMlG55XQmIe79MKMPGN3sb2XdaP2GTO4V2?=
 =?us-ascii?Q?q+TXgIpTjRNpg1naJmoTx/iQ7gjiHhvV1CvUgKed?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560855cf-f868-43b6-1613-08dddfe64a4f
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 12:37:14.0808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 39fZv5yS0hTVufZ9nARHD65atyu0SykX500Mo6SxYICOlKdXkQk72Q0K23oHOl0g9kbvE/h7usdHkKj+umtf3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6448

Logging messages that show some type of "out of memory" error are generally
unnecessary as there is a generic message and a stack dump done by the
memory subsystem. These messages generally increase kernel size without
much added value[1].

The dev_err_probe() doesn't do anything when error is '-ENOMEM'. Therefore,
remove the useless call to dev_err_probe(), and just return the value
instead.

[1]: https://lore.kernel.org/lkml/1402419340.30479.18.camel@joe-AO725/

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>
---
 drivers/crypto/starfive/jh7110-aes.c  | 12 ++++--------
 drivers/crypto/starfive/jh7110-hash.c |  3 +--
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfive/jh7110-aes.c
index 86a1a1fa9f8f..426b24889af8 100644
--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -511,8 +511,7 @@ static int starfive_aes_map_sg(struct starfive_cryp_dev *cryp,
 		     stsg = sg_next(stsg), dtsg = sg_next(dtsg)) {
 			src_nents = dma_map_sg(cryp->dev, stsg, 1, DMA_BIDIRECTIONAL);
 			if (src_nents == 0)
-				return dev_err_probe(cryp->dev, -ENOMEM,
-						     "dma_map_sg error\n");
+				return -ENOMEM;
 
 			dst_nents = src_nents;
 			len = min(sg_dma_len(stsg), remain);
@@ -528,13 +527,11 @@ static int starfive_aes_map_sg(struct starfive_cryp_dev *cryp,
 		for (stsg = src, dtsg = dst;;) {
 			src_nents = dma_map_sg(cryp->dev, stsg, 1, DMA_TO_DEVICE);
 			if (src_nents == 0)
-				return dev_err_probe(cryp->dev, -ENOMEM,
-						     "dma_map_sg src error\n");
+				return -ENOMEM;
 
 			dst_nents = dma_map_sg(cryp->dev, dtsg, 1, DMA_FROM_DEVICE);
 			if (dst_nents == 0)
-				return dev_err_probe(cryp->dev, -ENOMEM,
-						     "dma_map_sg dst error\n");
+				return -ENOMEM;
 
 			len = min(sg_dma_len(stsg), sg_dma_len(dtsg));
 			len = min(len, remain);
@@ -669,8 +666,7 @@ static int starfive_aes_aead_do_one_req(struct crypto_engine *engine, void *areq
 	if (cryp->assoclen) {
 		rctx->adata = kzalloc(cryp->assoclen + AES_BLOCK_SIZE, GFP_KERNEL);
 		if (!rctx->adata)
-			return dev_err_probe(cryp->dev, -ENOMEM,
-					     "Failed to alloc memory for adata");
+			return -ENOMEM;
 
 		if (sg_copy_to_buffer(req->src, sg_nents_for_len(req->src, cryp->assoclen),
 				      rctx->adata, cryp->assoclen) != cryp->assoclen)
diff --git a/drivers/crypto/starfive/jh7110-hash.c b/drivers/crypto/starfive/jh7110-hash.c
index 6cfe0238f615..e6839c7bfb73 100644
--- a/drivers/crypto/starfive/jh7110-hash.c
+++ b/drivers/crypto/starfive/jh7110-hash.c
@@ -229,8 +229,7 @@ static int starfive_hash_one_request(struct crypto_engine *engine, void *areq)
 	for_each_sg(rctx->in_sg, tsg, rctx->in_sg_len, i) {
 		src_nents = dma_map_sg(cryp->dev, tsg, 1, DMA_TO_DEVICE);
 		if (src_nents == 0)
-			return dev_err_probe(cryp->dev, -ENOMEM,
-					     "dma_map_sg error\n");
+			return -ENOMEM;
 
 		ret = starfive_hash_dma_xfer(cryp, tsg);
 		dma_unmap_sg(cryp->dev, tsg, 1, DMA_TO_DEVICE);
-- 
2.34.1

