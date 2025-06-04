Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011029.outbound.protection.outlook.com [52.101.65.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E697028CF62;
	Wed,  4 Jun 2025 10:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032107; cv=fail; b=LdHKsefcxV5vR0GlARVDzTRuJSG8dyV3lBxzhLhKrOjDoieL++pDjCU4aOSz99FzfqfjKqZ8vqxrC+nO/rmXgnYlrzNjSrggCHbtVoMugP64UOMHtbxg6ea+9U+w9N7RfYXG+PKPSTooKJf52WTLmkBlTPNSlTv1ZcNasZoAb0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032107; c=relaxed/simple;
	bh=TIDKYIwjXZPR4/wk7cF96zCWEVh23z2ICIhT59AcxNI=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=cERW+ORZjunUlV+BzV/9lCw+/V4x1tXVEMW2pboxBQ7eAmbITZbYb9odn36GMNVHABfQIQWDX5QsUU4WR7b7oJzse7w/lvnu7TxQ8UZTA+nGIVORYxQsA7O+OijzDXoASjcckuV7RdR/t3Ck6WJKN70tmG8Pr3/awdqaQ1YbtbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=gA+9l/Vy; arc=fail smtp.client-ip=52.101.65.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="gA+9l/Vy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C/mNJ68bnz9sXAz1M9s/YSYmzc6GYeLX8da5LoDcfS5AvDUmwnxFM55e2b7V/O9SE0rXAF88A9bO+YobH5VQ2mW1WcxzqFPqkEQ27yjHtPFcYkTuaEU3ZIcEv2cg+U4dZvtdSOFxCY0x3CSOX5knaRW5e3Pkmqy//FNIyWpwGvFdCNlthgIxaUqhtPiZDps+63q5A6vmBXEPlotCJJEgcwl9latWYOBQT0JunJE4S9lujvrPG5wmYruDxj9RHtQzQ7B783T22r7kIZ/TolelNU6983MyP1aSVGfwPDVFxMD1WUZ782PV5NQ8MJ70hCXRsdnM82F5fKQgKM5S8/TgAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0o1I8ADJGekovFD80vpZgXZqg1XoYvgjChCpexc4QiQ=;
 b=wtU8ZAvfbgu6+3UV61c/4kJkTPeVPojAoid7pHNAHFxBYG17XyIdGGelUEik2gueFrbvmk5TivcUNCtS3Onzx18NuQ8QDrS8JjrOA7z1g+HjVC7Mtm2qVQtDyizYCqhOyIYgH5TVPEjYwdI49RAKNsEGDQLHR/p/uLdKHZKCBK23SYXMZznmX1urEdDwJn2oFlL3mvbCNqLtL2XZL8CK0XkpY3sIXeXOzWDk6EyGi9m9zRd6JzEE9LLBaq7P2lWltYHGT/6w0aytblYPNG8Sc1s1+PPicxOkq7hUBjb9vhhaAfyiL5zwXpbZNdr2aE5eeoKKKB4yV4bqm+fsEhExfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0o1I8ADJGekovFD80vpZgXZqg1XoYvgjChCpexc4QiQ=;
 b=gA+9l/Vy2/QS8PEjmBLgGaB48Nghc5ZNSPF5eHwJWT1RnPIZMAxPFS3dZz4aRw/WQWeyU5ynN/mg24vKOXYADb97geBer3bY1iXUD9rw+xYxBVgGzZUhcWi7srYVPOTfWCVEH0nieplZdh3YkflhHDH+jTkhmbbcccc54YaYlPm0m8KKvq5sPbznkPQywzI6AEuKRQWMeq7d/ghPnHMhUIAe2VrFi7YsjzuTp6tnVzs6X3nvEfBtHL+Vz7iqFgi1/g6vbHuMoZPL/yU3bExuFKTU7IcTb4HudIMSQHU2yp+uG08laS0T2XEC01dXJM+b/mipa8s8C52fhJ7TMzJsTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com (2603:10a6:102:1c5::16)
 by DB9PR04MB8480.eurprd04.prod.outlook.com (2603:10a6:10:2c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Wed, 4 Jun
 2025 10:15:02 +0000
Received: from PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833]) by PAXPR04MB8301.eurprd04.prod.outlook.com
 ([fe80::85de:cf79:69cf:4833%3]) with mapi id 15.20.8813.018; Wed, 4 Jun 2025
 10:15:02 +0000
From: meenakshi.aggarwal@nxp.com
To: gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
Subject: [PATCH] crypto: caam - Set DMA alignment explicitly
Date: Wed,  4 Jun 2025 12:14:46 +0200
Message-Id: <20250604101446.3993932-1-meenakshi.aggarwal@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0048.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:657::17) To PAXPR04MB8301.eurprd04.prod.outlook.com
 (2603:10a6:102:1c5::16)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB8301:EE_|DB9PR04MB8480:EE_
X-MS-Office365-Filtering-Correlation-Id: a8743088-ee0f-4eee-9b73-08dda350ab24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v+dgs0xTuNWB1rLEiCwF8fvuiPoOjwHU4IqVIFJKVCkmp4knl5zFKcM4e8nQ?=
 =?us-ascii?Q?31plErsMt2LfYP6RFHsHz5kBJjtLAZdRZogsYHbXxprvz3QyUFsxV4KEYYVT?=
 =?us-ascii?Q?aGGhNZP9WBnxZmFGf2vwA7aTdzCQhcyVYITUZ3rvJcaq7dpxLF8oJ3HSBtDj?=
 =?us-ascii?Q?qNS1zuhYZDByYy9GOMmnSehMZLnLc8sTIxYEFiL+FqFFgTi3sxJ87RwE5vvk?=
 =?us-ascii?Q?hsDtERA/krQWOG/CaBTf+UtcK9NO/KMcyr2uybXjkxtTeHtByH4/04sbqsXZ?=
 =?us-ascii?Q?ZkGRY+39Dfk5/DvPX8pXJ6tYS9M/9NYr41nnD7lDBnU0HN0fGYYzfWfN2fy0?=
 =?us-ascii?Q?hLJpWeYMsLbT1oscynO1jrvVMytJkX4P4B8DQOIx1SIr+i2En+LRzHcinIrD?=
 =?us-ascii?Q?ZCQYw9CxF8AhRs+GZQhTiUGDH66Nz7tivoYPD4556SLwWd4Au9pgfuHAizmH?=
 =?us-ascii?Q?LIzxbvgcD4mF2+13xViSysvhBS44/JidnVih5BxBz+sa2rGnWpMfvI3gaoq0?=
 =?us-ascii?Q?yQELh0Lbcps1YBWZF00JVplTN8w8cVGAiIbWZfZvBVKw93/OtA8ce4BxsFSP?=
 =?us-ascii?Q?b1SOzcAkxOa6qxAOefXWlNd1jvQpCPxalHqZiooUNeFWt5BvZ4pnZf6TknBe?=
 =?us-ascii?Q?/1J65j64Ot1ELRU+iLrQ02rEM4vkLZnLG33/4MQ1OBy6Tu6KdxSCJ5rb+lkC?=
 =?us-ascii?Q?QLtjBJXEY/qLBcIzsM3ROFe0+wObWesgzb6uNsrOY0AkXlte8BtnT9Zmxb7q?=
 =?us-ascii?Q?D9hQo4J6VEDoihN91HRQw2gZNj1MCii9nd4/KxAzwIoNCFu59VG1bHvb5d9G?=
 =?us-ascii?Q?8iyNadISLxKBpppZ+twngp5hlmG6ARpEi7bSRkfv7Wt0Oo3wROCRa07Cq7sb?=
 =?us-ascii?Q?CDY5MlX12YwkLp110aocDCal/bbvQvjnaefkoeW426yaj4dVWXC746WsWB6A?=
 =?us-ascii?Q?hZnpXm4ajOK5ZfAz1W/lzt244gAR3xBcQnSoNrl6eQjXLoOX0McLUT2qo9zq?=
 =?us-ascii?Q?FeLjRw43NXY9DQ+MpZuiKUMp7jetwZmxtJQNiS9SZz6MhnCm/hT7ovZ5csvz?=
 =?us-ascii?Q?12yA6wrRBSieP9SyxG8cLATCipgzRb/tzETkm63DmyjAtvVLFi0zRYU6+4Jb?=
 =?us-ascii?Q?6DlwT7ZF0iUw3XRuyRVjqiH229XZSG7+5Y9WYx2UooKYm2zI8k7+YbGUT3RH?=
 =?us-ascii?Q?Wf/b8Hg0FJwNMUi44HjhIlI1blrkS5zjYnSXSpcEg9x7pMJw/YwCdIbIY1Rh?=
 =?us-ascii?Q?rlJCGqMJ18eNxcXRdpGoeOxz3XSLyYPMraljHsw+uadgcW64WgSnzsIzVV78?=
 =?us-ascii?Q?BiSQFccvaOymqvCuww9De12a+i/S8LOKQZzq13aCCxi7hmUT3i6ixdSm2aDm?=
 =?us-ascii?Q?pUNX/teKmwqjK9yO16XgateGNGmHdccUo7qgUW+t+NGIyOmdJVDY4vKiQRwX?=
 =?us-ascii?Q?PBvi1sA0omntUDVIoBnQP3aNEl7Aei+T/zJJISESJGg2Bh03tpd0mPrEhoqF?=
 =?us-ascii?Q?fX/FYkJ7JaseBhQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8301.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xSCiLd2Iaalpu/qNP+hviV8X2q/oclgvMAjhi4mBtxIi1MXHJV4OoeBTnAQI?=
 =?us-ascii?Q?jG03r5i5tzZbpLpwx6X0Akw43k+ldsOxoTG2LwA1qbOBPJKD8e28VZG0g7/j?=
 =?us-ascii?Q?XSZRs10s0Wx638gOhNvqv0zfv+23GIUWP810kiu4AhemFZEYwub3lNPsGijC?=
 =?us-ascii?Q?pytvfLqlsyZhk+Bnq0X5Gd2iyd2JJrOIyfJixBA+BY8zYfHtTzF7DPY/ipXT?=
 =?us-ascii?Q?/eIGpxxXxNGtVDYKZuFP8TOfqbGGuX34vGzDgLBOEY6bLZ2BH0zm2CNkjxWj?=
 =?us-ascii?Q?9FDGfIyVXJsIZkgXEBjJz6DhJZezhsLf5hSS8uqJTub36vygdOBQXkcgJu/q?=
 =?us-ascii?Q?HY1BnT0EOMKEYMG9uhaXEij7ZFF2OHCYSfnboFdI28OVKCnGqvgs0U/Rcwdm?=
 =?us-ascii?Q?DzMKA58T1h/FtWc3X1C2oxT0qeq6hZTmfVLLgBMsXRQqEvqGHwFmxWpHnhEI?=
 =?us-ascii?Q?4p6W23Tv4YcKme/HdBNbz2cSznUJUF8spAefYhe+QM3AKVKaYnqJBVe9l5S9?=
 =?us-ascii?Q?wbEWJBsWQoIiL9LpBCo1BCnMSiPvPf5vB8rsNBoVCERTiEBp8uN28HWFeCo7?=
 =?us-ascii?Q?kgU2Fas76HDbWCoGdbKfK6sRj6qHKFVxPI5+DW6zCB2muv/sskUA80VUFcR5?=
 =?us-ascii?Q?jjhK81klqimpNJxpSMSOknxdlyvO98tE7l5askkIjFDYRa9m4O9GFXrW+ZI/?=
 =?us-ascii?Q?SFPK9iAl11Lvt+xhtlDUhLyylb2/4H+0dswrAFZEkkwUsTgTkjrCSaR/Or+2?=
 =?us-ascii?Q?QOCmVuLtfn3LCfry9Vnd/Vx4oYD3t9KyC8x5kVBZliV7DSHwBEtkORuoIsl/?=
 =?us-ascii?Q?5cAjN89W1QTY6J4Fyw8PJE5bOyVm2/4pFgI3ES8cYd/GhqmnJNJizmr2/z7C?=
 =?us-ascii?Q?TqcKEaI8Z8sYr5hhhTkI4i8DOEXnd+RNsBEc9OfYjp+rq9q8ZUzdkggnEh2/?=
 =?us-ascii?Q?ZFs7sossmwl/M8xdrsB/iLC489bqUw3DYNRaIDGIeRpkZ5E7izRv/ax2QPVc?=
 =?us-ascii?Q?fNGpjrfKgSzFnWmyIut9bUhbq2PWAahl+vycCADg1w/8vwPIuSfssz8Yq5xu?=
 =?us-ascii?Q?bEaboKgVbUkKXXA0675n0Ahswe4KB6/nzSatYVc46vOdGRfpheTXtJVTza5v?=
 =?us-ascii?Q?Oy6a4fKqgx4tI5erFyV3QWkjPrYRBWaCkZMAsO83rf+KOOuwLYKBl8ik8N1l?=
 =?us-ascii?Q?QJTjt5qkWul/oeN5UBcACO3gcr/R1KcleWxIwbjDOwDA9VCONvKOunw3movc?=
 =?us-ascii?Q?v2FvW/So7Ckptk3CMYgGG3jbL6+e123G/t99tko9tp62B70/ONaQ2nMsCGhv?=
 =?us-ascii?Q?+fiGMDWa1jdYni5mQuhiF333MA4gzwwolSilTgNLk9RI1HcyjH9XM0TfFi/y?=
 =?us-ascii?Q?HLzx/lLhd8vvesyGKe/RI9KzgTf+EyZmIURPt1Pbbz7Uit7Y0vBmM8BMTM3p?=
 =?us-ascii?Q?/+UN7/paXCVDeZWZqXSpeuTnavE4lMr3zUZCL2UZpGjChYknKglxd40Tc4Xn?=
 =?us-ascii?Q?2QPZ8TbsZprLLKxVMQKH3GaF6fN/NV+EuG+aPHoor3H6CSRASVfgH6CXnHmk?=
 =?us-ascii?Q?mP0Og/Y9wfFHHCvbiS0BHxD99M2HrazaOnQwA7MoGj4TlXCqh4eql+SpMibF?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8743088-ee0f-4eee-9b73-08dda350ab24
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8301.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 10:15:02.2349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YlmE5hLNSkcFCDAd6fIcL8bMKQIWImNLiVUcrAFso9U8KWvwclGx+V71yhVQ0zfrYtQxIUVxZbqT713bh2kqvtv/PsBI83WZV3OBQ5OYMrc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8480

From: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>

Few DMA alignment were missed in the original patch.

Fixes: 4cb4f7c11dee ("crypto: caam - Set DMA alignment explicitly")

Signed-off-by: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>
---
 drivers/crypto/caam/caamalg.c    | 22 +++++++++++-----------
 drivers/crypto/caam/caamalg_qi.c |  4 ++--
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 2cfb1b8d8c7c..81dfbe436c20 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -980,7 +980,7 @@ static void aead_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 			    void *context)
 {
 	struct aead_request *req = context;
-	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
+	struct caam_aead_req_ctx *rctx = aead_request_ctx_dma(req);
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(jrdev);
 	struct aead_edesc *edesc;
 	int ecode = 0;
@@ -1020,7 +1020,7 @@ static void skcipher_crypt_done(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct skcipher_request *req = context;
 	struct skcipher_edesc *edesc;
-	struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
+	struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_drv_private_jr *jrp = dev_get_drvdata(jrdev);
 	int ivsize = crypto_skcipher_ivsize(skcipher);
@@ -1309,7 +1309,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx_dma(aead);
 	struct device *jrdev = ctx->jrdev;
-	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
+	struct caam_aead_req_ctx *rctx = aead_request_ctx_dma(req);
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
@@ -1445,7 +1445,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 static int aead_enqueue_req(struct device *jrdev, struct aead_request *req)
 {
 	struct caam_drv_private_jr *jrpriv = dev_get_drvdata(jrdev);
-	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
+	struct caam_aead_req_ctx *rctx = aead_request_ctx_dma(req);
 	struct aead_edesc *edesc = rctx->edesc;
 	u32 *desc = edesc->hw_desc;
 	int ret;
@@ -1541,7 +1541,7 @@ static int aead_do_one_req(struct crypto_engine *engine, void *areq)
 {
 	struct aead_request *req = aead_request_cast(areq);
 	struct caam_ctx *ctx = crypto_aead_ctx_dma(crypto_aead_reqtfm(req));
-	struct caam_aead_req_ctx *rctx = aead_request_ctx(req);
+	struct caam_aead_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 *desc = rctx->edesc->hw_desc;
 	int ret;
 
@@ -1614,7 +1614,7 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 {
 	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_skcipher_ctx_dma(skcipher);
-	struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
+	struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
@@ -1778,7 +1778,7 @@ static int skcipher_do_one_req(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = skcipher_request_cast(areq);
 	struct caam_ctx *ctx = crypto_skcipher_ctx_dma(crypto_skcipher_reqtfm(req));
-	struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
+	struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	u32 *desc = rctx->edesc->hw_desc;
 	int ret;
 
@@ -1828,7 +1828,7 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 
 	if (ctx->fallback && ((ctrlpriv->era <= 8 && xts_skcipher_ivsize(req)) ||
 			      ctx->xts_key_fallback)) {
-		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
+		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&rctx->fallback_req,
@@ -3639,10 +3639,10 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 		}
 
 		ctx->fallback = fallback;
-		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx) +
+		crypto_skcipher_set_reqsize_dma(tfm, sizeof(struct caam_skcipher_req_ctx) +
 					    crypto_skcipher_reqsize(fallback));
 	} else {
-		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx));
+		crypto_skcipher_set_reqsize_dma(tfm, sizeof(struct caam_skcipher_req_ctx));
 	}
 
 	ret = caam_init_common(ctx, &caam_alg->caam, false);
@@ -3659,7 +3659,7 @@ static int caam_aead_init(struct crypto_aead *tfm)
 		 container_of(alg, struct caam_aead_alg, aead.base);
 	struct caam_ctx *ctx = crypto_aead_ctx_dma(tfm);
 
-	crypto_aead_set_reqsize(tfm, sizeof(struct caam_aead_req_ctx));
+	crypto_aead_set_reqsize_dma(tfm, sizeof(struct caam_aead_req_ctx));
 
 	return caam_init_common(ctx, &caam_alg->caam, !caam_alg->caam.nodkp);
 }
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 65f6adb6c673..9aa2d6d97f22 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -1435,7 +1435,7 @@ static inline int skcipher_crypt(struct skcipher_request *req, bool encrypt)
 
 	if (ctx->fallback && ((ctrlpriv->era <= 8 && xts_skcipher_ivsize(req)) ||
 			      ctx->xts_key_fallback)) {
-		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx(req);
+		struct caam_skcipher_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&rctx->fallback_req,
@@ -2524,7 +2524,7 @@ static int caam_cra_init(struct crypto_skcipher *tfm)
 		}
 
 		ctx->fallback = fallback;
-		crypto_skcipher_set_reqsize(tfm, sizeof(struct caam_skcipher_req_ctx) +
+		crypto_skcipher_set_reqsize_dma(tfm, sizeof(struct caam_skcipher_req_ctx) +
 					    crypto_skcipher_reqsize(fallback));
 	}
 
-- 
2.25.1

