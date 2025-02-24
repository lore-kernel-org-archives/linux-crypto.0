Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFAF24E4B1;
	Mon, 24 Feb 2025 09:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740388756; cv=fail; b=XIujAsd5Z/SND7PPdz8b1jc4dopqfJDkkoeyAL92hJLCQc8hrgvCEB9BzozH08KC9i7G2n5n5u3R4dHmXKzjLse5Nj+/zymK4XbOki7Hpjl0H9BHGSTbleQAPgtSIM9ZTnGky8RFqH7J3jqJqriaNqVVhr3axXZqFSYx47nweUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740388756; c=relaxed/simple;
	bh=DXnbemFyt9qt3YlRoNBsOzv2w7pxqZzhPYc9i0pFW1M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tMCsIl65kZamVT+dvnCr4zdNRj9MjuwwqNG56CYYKvxYAm+br4kxjc01t8BpQro4+X06AMIHhhDAKN6GHQB8j72YhLOw0RgEsuaQ4sAKr6Qe6nsCESDSJbtyzJX5odUHDcIsK6GXQmtPWNRg5IViI2C6oWVMuke62yX/5PP82wA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vsh5ZIUh; arc=fail smtp.client-ip=40.107.237.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vsh5ZIUh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eR0OMDsEYMFD2rQVVRdZILxbxtRfFMg9S0r7wDzYUh3nhS6t3GTJTqCtKHOVByyzEunMhTY3zH1lpLjytQ9cSBuv/Mu2MhyyQaGazJ28ckHqiLxQ1f3VXH5kVN0qEUF3KpDFz5w4kbsnNeWVEQF0RIOM4rEQsDlU1zRqGvNC03MLSCf/TMvXT4I5KpjtKNEdROXAAn3+js0el5Sn1m8aM+htCnRsR97GPLZCncZJh4T+sJcSHuUj3TKDg9GDQBH5Sug9gi9QDROsnlK94kAjs08teLXw4a1VnzGYT8KFzpzHECgsg0ibSTXa5Gpat972rt4+RmJaAiAZYqTqamIjag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7HjBIs4EYfXrEG+cfqbwR0ZQ85mn2pMs2yqjTqoyAik=;
 b=WrVFLuNZ2Me49SReBu2p5xg8Phw49sMrl1tPtFkAy5xIHDIFdXPzM8rpOzAk0J2rNt3TBy17Q2NuCZ0Edo6tEox17vbTyZ/3nbZmHgpdIws+k80DWaeNrQ6cw0JvnUyFwAqcbUUSrI6vZV+DRr0SNjScDNiDd3Ls+ToTUdNR8+JkmfLqwHofSCu4k2zfw4GvuyipyU+I6sMCgMYT7Ekb41Pq72rkKgyRuLSyNQOGx9pPb2vYi+M0EsUilpaFDb5Cf4Hx4NeJxrOXdBCqJWTa/9p4+EhMl4Iyx+3xb/wD/+AeIbe9PJFQXuO0rERrGWIZGhrHnDJA908vagpyM5alTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HjBIs4EYfXrEG+cfqbwR0ZQ85mn2pMs2yqjTqoyAik=;
 b=Vsh5ZIUhpjuZAhFpXaDJsFv+9hSC9cLTQbp6nKlv6bFTwXAfP74HbQvQ6ouaPvPtDhK8eQFtjV1eCXMpWPHe9Qo3mTpthMNYIeSQt6YMrsqFSaJpJ9Z9zUT+92Eecrsk53LE6ha+30LGhw3/ekkmUJPl28diTbJH4XHbf4G9wpYNMrIk5sdPpn8pnY57rEQK+B9XsHO66SFaKzMn6Io32xRIfDgSG8CM2WV/PNeWG4cz/NJ+oXir7+mXeZMVvqVlUxCXCbcIVA8TNEu44x72keXrphPpYYntYCiwhkfWbmeNU0dbPQRX4tR+MSJnGCwTVSk2z0hr1fgoGOwMWVxBKA==
Received: from BL1P222CA0001.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::6)
 by DS7PR12MB6262.namprd12.prod.outlook.com (2603:10b6:8:96::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.20; Mon, 24 Feb 2025 09:19:03 +0000
Received: from BL6PEPF0001AB52.namprd02.prod.outlook.com
 (2603:10b6:208:2c7:cafe::b7) by BL1P222CA0001.outlook.office365.com
 (2603:10b6:208:2c7::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Mon,
 24 Feb 2025 09:19:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB52.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.11 via Frontend Transport; Mon, 24 Feb 2025 09:19:02 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 01:18:51 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 01:18:50 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 01:18:48 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v3 09/10] crypto: tegra: Reserve keyslots to allocate dynamically
Date: Mon, 24 Feb 2025 14:46:09 +0530
Message-ID: <20250224091610.49683-10-akhilrajeev@nvidia.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250224091610.49683-1-akhilrajeev@nvidia.com>
References: <20250224091610.49683-1-akhilrajeev@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB52:EE_|DS7PR12MB6262:EE_
X-MS-Office365-Filtering-Correlation-Id: b1145488-2344-4a17-4e3d-08dd54b4474c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uuHVnajUWRkwRRMGBxij3cZEv0CvE8adV5wcytCNdQjwQmL2Q6PukyJ9Iw0G?=
 =?us-ascii?Q?leVdRUMAS8UQc5k8AVxk3jGLPppQgMWSnJkB0nYRwm4Y4KMAfPEyuZnZrNcH?=
 =?us-ascii?Q?hWjqESGqwb5+mj89k4Flt8VqO5c51ywFfFaM02+qaZ8qIiQhJlaZhXDl3za+?=
 =?us-ascii?Q?D3l1HjVPmJAjv+L6uG2YfM4KQXfoF8R/UaDlcP7Th0mlNrCqRIq9fAqA+xWj?=
 =?us-ascii?Q?HFWu6zbyYf5uUJAncE+mUAo1UqL/Py0RV6nwHR2/fRSSfcV6CLKp3GYXi1Cg?=
 =?us-ascii?Q?LStm+0r/mqUu3gq0FxaMMKZI8L+mxy8qWX5xp6w7WGEiQ4JEjUSaTJCnGbgp?=
 =?us-ascii?Q?NX3T3SvINIlY85Kh50QCAnXicS5Ec3YVggLkHWyjEyOoWJuyiRpOD+88896A?=
 =?us-ascii?Q?jpQ3IgJfaUPXCxRKY2Xw5//G7VxTTkcX++tNzozwR75bx7iKdA2x323yM2Ik?=
 =?us-ascii?Q?6Oh0ztL+setUJanq4CYMj+7q4b3LES9Z1KtUyLA2DnjHk4FoCV0yQAw6Tu9G?=
 =?us-ascii?Q?kIU7L81euQ5JDYObzihg82xZnKXLrksq9zZ34p+0q8DQRTJrN1TGn5N/0jNN?=
 =?us-ascii?Q?3lxUUri2Au6ZlEfNWHWv0F6J5Zs9lTWyXXjQsqNaC4DEIONK9xMg+f7ESxAS?=
 =?us-ascii?Q?orqVzSPqBss/3Q5jV8wazM5Z9NifGutLKAboXVTOx3oMTbDjsXzPxBUCSWjj?=
 =?us-ascii?Q?aFkGWbVHgfcw5tlfys5HxLYwoHdrjPVexD6QaoQlE5FT2U8PhGZL3h66UGeo?=
 =?us-ascii?Q?GDzdZsmS38AJVp0GDXjCkTzPOqPLykvaCiakzA3hkPHyMBdqY3f9epD7ZsUG?=
 =?us-ascii?Q?O0s6OqUup5fskJ2uoxe25bWbRyUin3yjz6ukNsiWSvlZcj4YzJbqVU/0lqL3?=
 =?us-ascii?Q?SK/29n7mQVVBrUbWvnCZvIPApwoG/UGswZ2zQ70Xrz6d25XwSm+vY5ZufTbw?=
 =?us-ascii?Q?1oSPDwO2FdWChMIJyXf9ci/i2F1uRSzL/qUv1e3dhqemdDMmMSiruP3qrFWU?=
 =?us-ascii?Q?opxefPWEseSRKiYabZMcZc3Pcfh7foLAGlBFwi0budANpb3eS8wTjb/Kq8nT?=
 =?us-ascii?Q?fUWr/vk5tPGYL/sPla/rb0TrVVbE58B/NM5XPRdepudRk075EtK2H0wU9EsN?=
 =?us-ascii?Q?yVcmYiRJJfvXw4J8wLsmwMrlnko9DrldusbKMfuQqYS0G47J/xWKGz75nBIk?=
 =?us-ascii?Q?nD05dw4CaWFIVQ/xukbIa4ycNzYAwEw7ryAv6d5GJ0mG/Zwzy4bpvXPXEORG?=
 =?us-ascii?Q?MYe6CPuJTcRAor8S8mRc6OitB6bP7CFe7bqTR/7lLw7LVoOxcBLexb/G3TGz?=
 =?us-ascii?Q?2Au2s3aAIb/NP1IoaoOt6HbwJcOsjUSvkwKyrxreEj0DOyDwF4I+wEHJMLOG?=
 =?us-ascii?Q?MLGhnIzpzmybS5XLycwgTy6ATFIVryu9QgkscR1LN1MJaxuA6WWqaOi/oBsT?=
 =?us-ascii?Q?+i7+xgp3aWTfcAXBUbOvaFwmN5SdYOJwTrWM7iepOD52DUvzzlaAIR5gIZ9A?=
 =?us-ascii?Q?zCKR4BI7j0wk/f8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 09:19:02.1633
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1145488-2344-4a17-4e3d-08dd54b4474c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB52.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6262

The HW supports only storing 15 keys at a time. This limits the number
of tfms that can work without failutes. Reserve keyslots to solve this
and use the reserved ones during the encryption/decryption operation.
This allow users to have the capability of hardware protected keys
and faster operations if there are limited number of tfms while not
halting the operation if there are more tfms.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
---
 drivers/crypto/tegra/tegra-se-aes.c | 139 +++++++++++++++++++++++-----
 drivers/crypto/tegra/tegra-se-key.c |  17 ++++
 drivers/crypto/tegra/tegra-se.h     |  28 ++++++
 3 files changed, 163 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index a1b469c3a55b..ca9d0cca1f74 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -28,6 +28,9 @@ struct tegra_aes_ctx {
 	u32 ivsize;
 	u32 key1_id;
 	u32 key2_id;
+	u32 keylen;
+	u8 key1[AES_MAX_KEY_SIZE];
+	u8 key2[AES_MAX_KEY_SIZE];
 };
 
 struct tegra_aes_reqctx {
@@ -43,8 +46,9 @@ struct tegra_aead_ctx {
 	struct tegra_se *se;
 	unsigned int authsize;
 	u32 alg;
-	u32 keylen;
 	u32 key_id;
+	u32 keylen;
+	u8 key[AES_MAX_KEY_SIZE];
 };
 
 struct tegra_aead_reqctx {
@@ -56,8 +60,8 @@ struct tegra_aead_reqctx {
 	unsigned int cryptlen;
 	unsigned int authsize;
 	bool encrypt;
-	u32 config;
 	u32 crypto_config;
+	u32 config;
 	u32 key_id;
 	u32 iv[4];
 	u8 authdata[16];
@@ -67,6 +71,8 @@ struct tegra_cmac_ctx {
 	struct tegra_se *se;
 	unsigned int alg;
 	u32 key_id;
+	u32 keylen;
+	u8 key[AES_MAX_KEY_SIZE];
 	struct crypto_shash *fallback_tfm;
 };
 
@@ -260,11 +266,13 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	struct tegra_aes_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
 	struct tegra_aes_reqctx *rctx = skcipher_request_ctx(req);
 	struct tegra_se *se = ctx->se;
-	unsigned int cmdlen;
+	unsigned int cmdlen, key1_id, key2_id;
 	int ret;
 
 	rctx->iv = (u32 *)req->iv;
 	rctx->len = req->cryptlen;
+	key1_id = ctx->key1_id;
+	key2_id = ctx->key2_id;
 
 	/* Pad input to AES Block size */
 	if (ctx->alg != SE_ALG_XTS) {
@@ -282,6 +290,29 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 
 	scatterwalk_map_and_copy(rctx->datbuf.buf, req->src, 0, req->cryptlen, 0);
 
+	rctx->config = tegra234_aes_cfg(ctx->alg, rctx->encrypt);
+	rctx->crypto_config = tegra234_aes_crypto_cfg(ctx->alg, rctx->encrypt);
+
+	if (!key1_id) {
+		ret = tegra_key_submit_reserved_aes(ctx->se, ctx->key1,
+						    ctx->keylen, ctx->alg, &key1_id);
+		if (ret)
+			goto out;
+	}
+
+	rctx->crypto_config |= SE_AES_KEY_INDEX(key1_id);
+
+	if (ctx->alg == SE_ALG_XTS) {
+		if (!key2_id) {
+			ret = tegra_key_submit_reserved_xts(ctx->se, ctx->key2,
+							    ctx->keylen, ctx->alg, &key2_id);
+			if (ret)
+				goto out;
+		}
+
+		rctx->crypto_config |= SE_AES_KEY2_INDEX(key2_id);
+	}
+
 	/* Prepare the command and submit for execution */
 	cmdlen = tegra_aes_prep_cmd(ctx, rctx);
 	ret = tegra_se_host1x_submit(se, se->cmdbuf, cmdlen);
@@ -290,10 +321,17 @@ static int tegra_aes_do_one_req(struct crypto_engine *engine, void *areq)
 	tegra_aes_update_iv(req, ctx);
 	scatterwalk_map_and_copy(rctx->datbuf.buf, req->dst, 0, req->cryptlen, 1);
 
+out:
 	/* Free the buffer */
 	dma_free_coherent(ctx->se->dev, rctx->datbuf.size,
 			  rctx->datbuf.buf, rctx->datbuf.addr);
 
+	if (tegra_key_is_reserved(key1_id))
+		tegra_key_invalidate_reserved(ctx->se, key1_id, ctx->alg);
+
+	if (tegra_key_is_reserved(key2_id))
+		tegra_key_invalidate_reserved(ctx->se, key2_id, ctx->alg);
+
 out_finalize:
 	crypto_finalize_skcipher_request(se->engine, req, ret);
 
@@ -316,6 +354,7 @@ static int tegra_aes_cra_init(struct crypto_skcipher *tfm)
 	ctx->se = se_alg->se_dev;
 	ctx->key1_id = 0;
 	ctx->key2_id = 0;
+	ctx->keylen = 0;
 
 	algname = crypto_tfm_alg_name(&tfm->base);
 	ret = se_algname_to_algid(algname);
@@ -344,13 +383,20 @@ static int tegra_aes_setkey(struct crypto_skcipher *tfm,
 			    const u8 *key, u32 keylen)
 {
 	struct tegra_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int ret;
 
 	if (aes_check_keylen(keylen)) {
 		dev_dbg(ctx->se->dev, "invalid key length (%d)\n", keylen);
 		return -EINVAL;
 	}
 
-	return tegra_key_submit(ctx->se, key, keylen, ctx->alg, &ctx->key1_id);
+	ret = tegra_key_submit(ctx->se, key, keylen, ctx->alg, &ctx->key1_id);
+	if (ret) {
+		ctx->keylen = keylen;
+		memcpy(ctx->key1, key, keylen);
+	}
+
+	return 0;
 }
 
 static int tegra_xts_setkey(struct crypto_skcipher *tfm,
@@ -368,11 +414,17 @@ static int tegra_xts_setkey(struct crypto_skcipher *tfm,
 
 	ret = tegra_key_submit(ctx->se, key, len,
 			       ctx->alg, &ctx->key1_id);
-	if (ret)
-		return ret;
+	if (ret) {
+		ctx->keylen = len;
+		memcpy(ctx->key1, key, len);
+	}
 
-	return tegra_key_submit(ctx->se, key + len, len,
+	ret = tegra_key_submit(ctx->se, key + len, len,
 			       ctx->alg, &ctx->key2_id);
+	if (ret) {
+		ctx->keylen = len;
+		memcpy(ctx->key2, key + len, len);
+	}
 
 	return 0;
 }
@@ -450,12 +502,6 @@ static int tegra_aes_crypt(struct skcipher_request *req, bool encrypt)
 		req->iv = NULL;
 
 	rctx->encrypt = encrypt;
-	rctx->config = tegra234_aes_cfg(ctx->alg, encrypt);
-	rctx->crypto_config = tegra234_aes_crypto_cfg(ctx->alg, encrypt);
-	rctx->crypto_config |= SE_AES_KEY_INDEX(ctx->key1_id);
-
-	if (ctx->key2_id)
-		rctx->crypto_config |= SE_AES_KEY2_INDEX(ctx->key2_id);
 
 	return crypto_transfer_skcipher_request_to_engine(ctx->se->engine, req);
 }
@@ -721,7 +767,7 @@ static int tegra_gcm_do_gmac(struct tegra_aead_ctx *ctx, struct tegra_aead_reqct
 
 	rctx->config = tegra234_aes_cfg(SE_ALG_GMAC, rctx->encrypt);
 	rctx->crypto_config = tegra234_aes_crypto_cfg(SE_ALG_GMAC, rctx->encrypt) |
-			      SE_AES_KEY_INDEX(ctx->key_id);
+			      SE_AES_KEY_INDEX(rctx->key_id);
 
 	cmdlen = tegra_gmac_prep_cmd(ctx, rctx);
 
@@ -738,7 +784,7 @@ static int tegra_gcm_do_crypt(struct tegra_aead_ctx *ctx, struct tegra_aead_reqc
 
 	rctx->config = tegra234_aes_cfg(SE_ALG_GCM, rctx->encrypt);
 	rctx->crypto_config = tegra234_aes_crypto_cfg(SE_ALG_GCM, rctx->encrypt) |
-			      SE_AES_KEY_INDEX(ctx->key_id);
+			      SE_AES_KEY_INDEX(rctx->key_id);
 
 	/* Prepare command and submit */
 	cmdlen = tegra_gcm_crypt_prep_cmd(ctx, rctx);
@@ -761,7 +807,7 @@ static int tegra_gcm_do_final(struct tegra_aead_ctx *ctx, struct tegra_aead_reqc
 
 	rctx->config = tegra234_aes_cfg(SE_ALG_GCM_FINAL, rctx->encrypt);
 	rctx->crypto_config = tegra234_aes_crypto_cfg(SE_ALG_GCM_FINAL, rctx->encrypt) |
-			      SE_AES_KEY_INDEX(ctx->key_id);
+			      SE_AES_KEY_INDEX(rctx->key_id);
 
 	/* Prepare command and submit */
 	cmdlen = tegra_gcm_prep_final_cmd(se, cpuvaddr, rctx);
@@ -892,7 +938,7 @@ static int tegra_ccm_do_cbcmac(struct tegra_aead_ctx *ctx, struct tegra_aead_req
 	rctx->config = tegra234_aes_cfg(SE_ALG_CBC_MAC, rctx->encrypt);
 	rctx->crypto_config = tegra234_aes_crypto_cfg(SE_ALG_CBC_MAC,
 						      rctx->encrypt) |
-						      SE_AES_KEY_INDEX(ctx->key_id);
+						      SE_AES_KEY_INDEX(rctx->key_id);
 
 	/* Prepare command and submit */
 	cmdlen = tegra_cbcmac_prep_cmd(ctx, rctx);
@@ -1079,7 +1125,7 @@ static int tegra_ccm_do_ctr(struct tegra_aead_ctx *ctx, struct tegra_aead_reqctx
 
 	rctx->config = tegra234_aes_cfg(SE_ALG_CTR, rctx->encrypt);
 	rctx->crypto_config = tegra234_aes_crypto_cfg(SE_ALG_CTR, rctx->encrypt) |
-			      SE_AES_KEY_INDEX(ctx->key_id);
+			      SE_AES_KEY_INDEX(rctx->key_id);
 
 	/* Copy authdata in the top of buffer for encryption/decryption */
 	if (rctx->encrypt)
@@ -1160,6 +1206,8 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	if (ret)
 		goto out_finalize;
 
+	rctx->key_id = ctx->key_id;
+
 	/* Allocate buffers required */
 	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen + 100;
 	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
@@ -1175,6 +1223,13 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 		goto out_free_inbuf;
 	}
 
+	if (!ctx->key_id) {
+		ret = tegra_key_submit_reserved_aes(ctx->se, ctx->key,
+						    ctx->keylen, ctx->alg, &rctx->key_id);
+		if (ret)
+			goto out;
+	}
+
 	if (rctx->encrypt) {
 		/* CBC MAC Operation */
 		ret = tegra_ccm_compute_auth(ctx, rctx);
@@ -1205,6 +1260,9 @@ static int tegra_ccm_do_one_req(struct crypto_engine *engine, void *areq)
 	dma_free_coherent(ctx->se->dev, rctx->outbuf.size,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
+	if (tegra_key_is_reserved(rctx->key_id))
+		tegra_key_invalidate_reserved(ctx->se, rctx->key_id, ctx->alg);
+
 out_finalize:
 	crypto_finalize_aead_request(ctx->se->engine, req, ret);
 
@@ -1232,6 +1290,8 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	memcpy(rctx->iv, req->iv, GCM_AES_IV_SIZE);
 	rctx->iv[3] = (1 << 24);
 
+	rctx->key_id = ctx->key_id;
+
 	/* Allocate buffers required */
 	rctx->inbuf.size = rctx->assoclen + rctx->authsize + rctx->cryptlen;
 	rctx->inbuf.buf = dma_alloc_coherent(ctx->se->dev, rctx->inbuf.size,
@@ -1249,6 +1309,13 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 		goto out_free_inbuf;
 	}
 
+	if (!ctx->key_id) {
+		ret = tegra_key_submit_reserved_aes(ctx->se, ctx->key,
+						    ctx->keylen, ctx->alg, &rctx->key_id);
+		if (ret)
+			goto out;
+	}
+
 	/* If there is associated data perform GMAC operation */
 	if (rctx->assoclen) {
 		ret = tegra_gcm_do_gmac(ctx, rctx);
@@ -1279,6 +1346,9 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	dma_free_coherent(ctx->se->dev, rctx->inbuf.size,
 			  rctx->inbuf.buf, rctx->inbuf.addr);
 
+	if (tegra_key_is_reserved(rctx->key_id))
+		tegra_key_invalidate_reserved(ctx->se, rctx->key_id, ctx->alg);
+
 out_finalize:
 	crypto_finalize_aead_request(ctx->se->engine, req, ret);
 
@@ -1301,6 +1371,7 @@ static int tegra_aead_cra_init(struct crypto_aead *tfm)
 
 	ctx->se = se_alg->se_dev;
 	ctx->key_id = 0;
+	ctx->keylen = 0;
 
 	ret = se_algname_to_algid(algname);
 	if (ret < 0) {
@@ -1382,13 +1453,20 @@ static int tegra_aead_setkey(struct crypto_aead *tfm,
 			     const u8 *key, u32 keylen)
 {
 	struct tegra_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	int ret;
 
 	if (aes_check_keylen(keylen)) {
 		dev_dbg(ctx->se->dev, "invalid key length (%d)\n", keylen);
 		return -EINVAL;
 	}
 
-	return tegra_key_submit(ctx->se, key, keylen, ctx->alg, &ctx->key_id);
+	ret = tegra_key_submit(ctx->se, key, keylen, ctx->alg, &ctx->key_id);
+	if (ret) {
+		ctx->keylen = keylen;
+		memcpy(ctx->key, key, keylen);
+	}
+
+	return 0;
 }
 
 static unsigned int tegra_cmac_prep_cmd(struct tegra_cmac_ctx *ctx,
@@ -1473,6 +1551,7 @@ static int tegra_cmac_do_init(struct ahash_request *req)
 	rctx->total_len = 0;
 	rctx->datbuf.size = 0;
 	rctx->residue.size = 0;
+	rctx->key_id = ctx->key_id;
 	rctx->task |= SHA_FIRST;
 	rctx->blk_size = crypto_ahash_blocksize(tfm);
 
@@ -1517,7 +1596,7 @@ static int tegra_cmac_do_update(struct ahash_request *req)
 	rctx->datbuf.size = (req->nbytes + rctx->residue.size) - nresidue;
 	rctx->total_len += rctx->datbuf.size;
 	rctx->config = tegra234_aes_cfg(SE_ALG_CMAC, 0);
-	rctx->crypto_config = SE_AES_KEY_INDEX(ctx->key_id);
+	rctx->crypto_config = SE_AES_KEY_INDEX(rctx->key_id);
 
 	/*
 	 * Keep one block and residue bytes in residue and
@@ -1643,6 +1722,13 @@ static int tegra_cmac_do_one_req(struct crypto_engine *engine, void *areq)
 		rctx->task &= ~SHA_INIT;
 	}
 
+	if (!ctx->key_id) {
+		ret = tegra_key_submit_reserved_aes(ctx->se, ctx->key,
+						    ctx->keylen, ctx->alg, &rctx->key_id);
+		if (ret)
+			goto out;
+	}
+
 	if (rctx->task & SHA_UPDATE) {
 		ret = tegra_cmac_do_update(req);
 		if (ret)
@@ -1659,6 +1745,9 @@ static int tegra_cmac_do_one_req(struct crypto_engine *engine, void *areq)
 		rctx->task &= ~SHA_FINAL;
 	}
 out:
+	if (tegra_key_is_reserved(rctx->key_id))
+		tegra_key_invalidate_reserved(ctx->se, rctx->key_id, ctx->alg);
+
 	crypto_finalize_hash_request(se->engine, req, ret);
 
 	return 0;
@@ -1699,6 +1788,7 @@ static int tegra_cmac_cra_init(struct crypto_tfm *tfm)
 
 	ctx->se = se_alg->se_dev;
 	ctx->key_id = 0;
+	ctx->keylen = 0;
 
 	ret = se_algname_to_algid(algname);
 	if (ret < 0) {
@@ -1727,6 +1817,7 @@ static int tegra_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 			     unsigned int keylen)
 {
 	struct tegra_cmac_ctx *ctx = crypto_ahash_ctx(tfm);
+	int ret;
 
 	if (aes_check_keylen(keylen)) {
 		dev_dbg(ctx->se->dev, "invalid key length (%d)\n", keylen);
@@ -1736,7 +1827,13 @@ static int tegra_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
 	if (ctx->fallback_tfm)
 		crypto_shash_setkey(ctx->fallback_tfm, key, keylen);
 
-	return tegra_key_submit(ctx->se, key, keylen, ctx->alg, &ctx->key_id);
+	ret = tegra_key_submit(ctx->se, key, keylen, ctx->alg, &ctx->key_id);
+	if (ret) {
+		ctx->keylen = keylen;
+		memcpy(ctx->key, key, keylen);
+	}
+
+	return 0;
 }
 
 static int tegra_cmac_init(struct ahash_request *req)
diff --git a/drivers/crypto/tegra/tegra-se-key.c b/drivers/crypto/tegra/tegra-se-key.c
index 276b261fb6df..bf265514b04c 100644
--- a/drivers/crypto/tegra/tegra-se-key.c
+++ b/drivers/crypto/tegra/tegra-se-key.c
@@ -141,6 +141,23 @@ void tegra_key_invalidate(struct tegra_se *se, u32 keyid, u32 alg)
 	tegra_keyslot_free(keyid);
 }
 
+void tegra_key_invalidate_reserved(struct tegra_se *se, u32 keyid, u32 alg)
+{
+	u8 zkey[AES_MAX_KEY_SIZE] = {0};
+
+	if (!keyid)
+		return;
+
+	/* Overwrite the key with 0s */
+	tegra_key_insert(se, zkey, AES_MAX_KEY_SIZE, keyid, alg);
+}
+
+inline int tegra_key_submit_reserved(struct tegra_se *se, const u8 *key,
+				     u32 keylen, u32 alg, u32 *keyid)
+{
+	return tegra_key_insert(se, key, keylen, *keyid, alg);
+}
+
 int tegra_key_submit(struct tegra_se *se, const u8 *key, u32 keylen, u32 alg, u32 *keyid)
 {
 	int ret;
diff --git a/drivers/crypto/tegra/tegra-se.h b/drivers/crypto/tegra/tegra-se.h
index 0f5bcf27358b..0629c9a8f837 100644
--- a/drivers/crypto/tegra/tegra-se.h
+++ b/drivers/crypto/tegra/tegra-se.h
@@ -342,6 +342,9 @@
 #define SE_MAX_KEYSLOT				15
 #define SE_MAX_MEM_ALLOC			SZ_4M
 
+#define TEGRA_AES_RESERVED_KSLT			14
+#define TEGRA_XTS_RESERVED_KSLT			15
+
 #define SHA_FIRST	BIT(0)
 #define SHA_INIT	BIT(1)
 #define SHA_UPDATE	BIT(2)
@@ -502,9 +505,34 @@ void tegra_deinit_aes(struct tegra_se *se);
 void tegra_deinit_hash(struct tegra_se *se);
 int tegra_key_submit(struct tegra_se *se, const u8 *key,
 		     u32 keylen, u32 alg, u32 *keyid);
+
+int tegra_key_submit_reserved(struct tegra_se *se, const u8 *key,
+			      u32 keylen, u32 alg, u32 *keyid);
+
 void tegra_key_invalidate(struct tegra_se *se, u32 keyid, u32 alg);
+void tegra_key_invalidate_reserved(struct tegra_se *se, u32 keyid, u32 alg);
 int tegra_se_host1x_submit(struct tegra_se *se, struct tegra_se_cmdbuf *cmdbuf, u32 size);
 
+static inline int tegra_key_submit_reserved_aes(struct tegra_se *se, const u8 *key,
+						u32 keylen, u32 alg, u32 *keyid)
+{
+	*keyid = TEGRA_AES_RESERVED_KSLT;
+	return tegra_key_submit_reserved(se, key, keylen, alg, keyid);
+}
+
+static inline int tegra_key_submit_reserved_xts(struct tegra_se *se, const u8 *key,
+						u32 keylen, u32 alg, u32 *keyid)
+{
+	*keyid = TEGRA_XTS_RESERVED_KSLT;
+	return tegra_key_submit_reserved(se, key, keylen, alg, keyid);
+}
+
+static inline bool tegra_key_is_reserved(u32 keyid)
+{
+	return ((keyid == TEGRA_AES_RESERVED_KSLT) ||
+		(keyid == TEGRA_XTS_RESERVED_KSLT));
+}
+
 /* HOST1x OPCODES */
 static inline u32 host1x_opcode_setpayload(unsigned int payload)
 {
-- 
2.43.2

