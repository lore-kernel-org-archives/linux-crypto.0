Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010024.outbound.protection.outlook.com [52.101.61.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89D5313295;
	Thu, 26 Feb 2026 13:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772111494; cv=fail; b=OdUiOinIyeok+hz/zwzZtVn74NEIlhULtMaS4cgBtNRmJkICV2x1+HJk3rcRAPe0EJVi3feeXup2wYcFpdwW6XrZj8VemGq+utL0+qANA9wAa7rR9jdpOwOAGIP5g9dRBgS2dSLQafP79q0IxC0lzS7kW/W7i4igNrxW5HB/v4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772111494; c=relaxed/simple;
	bh=TK/L2+bDrx0JMf7dSfSf1+k9seDMI3ySjs9j87ykM1w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dqamitUV+Cv1asvWKHybazkuzxCktTn7Uxh1yVsQwCkm9MgW35+gkgw/UgVCFl4DBQUxsIm2A2ytvGCZeDZzESiXTG94lCK/ODx18rx+SaFd+riSHeSg80k80JEarHenbzSwmF4viAbG3EG6UT+tZKBVdGpk72MGzKFY3OpxKLE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=GU4zwZfG; arc=fail smtp.client-ip=52.101.61.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="GU4zwZfG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SIw/OwVHSv6osdcVToQIiQ/UPbdxqZm3ENstEN2x38chURhdtNSNbOjFNss1cD3PPHvcIH3RSMLfB0N+DmVCeiTzTrlD+vasFnM5/KFlUf0wtU04P2wdWgCkVSdf7jgiHlTIFV91hU35mlmVhUFUFxUut76uqfTI9udDlvPhv2DFYcdjtZMqxB1QMh+hOAb8OUj5aN2MM+Ctcdb6zUQ0o4amOG+BRkvzNZh4mJR7EZsJSvTPpLNLNqm+aKcwEaHUch4p7yCebECby/B9v8+WYCKgBh0RJH2w6LTyKuFTJb5Y57RcM20tMJV0LyOUIn83r7Y7g6KuIUZJwI/UN5klUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JydfP+65lQwME1TsTWqVpuhV0WQU6RP2+nMT5s5Cwzc=;
 b=XhwDpvGT55f2IyhD9kELBOYoIWCaMctVIJwu1x51OifM+zJ15L76YaJh8b9l9N9wPJpHbJKlmF38gKQLczGYxMfCd+Vw2wYw7QErSwdUSQBY1QU0qyXZGqG2x3agxM9KDWJCdQDxBp/pnHqaKw/u9ADpq8ew/AxNhcq8dfn6MgJulci00F7P3zUZ88RNXLS3xEYajelL2JBo/0ir9MMKy1kBowiFx9hVVtD0jD2nb4cLkXvJQsXzQmomZTA2MJUN3WSaDukRW1ACfZ/y6SH73XpYNFuAsxJlOkLP78ZgSCmcI+bBqyuPWE2Dlad5LmYdjyf2OaQ1Bg43W7CpFYviOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JydfP+65lQwME1TsTWqVpuhV0WQU6RP2+nMT5s5Cwzc=;
 b=GU4zwZfGNt3fkLrEJ3rp0Wv/gb+yCWnZ8dpfefhw5LxpWC5/ikkR/xKmJ5SHgsqkYw313bIVPFghVvpoXH40akFfSVVtJsphyDzTCXEmqnJBoIFmZ5nCzfwLOVza6Ef4YTZg+kGAaPj3h/hj6Dz2X1tv1WAGv2kA9gyBM/SG7ts=
Received: from SJ0PR13CA0191.namprd13.prod.outlook.com (2603:10b6:a03:2c3::16)
 by PH7PR10MB6651.namprd10.prod.outlook.com (2603:10b6:510:20a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Thu, 26 Feb
 2026 13:11:28 +0000
Received: from SJ5PEPF000001CE.namprd05.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::41) by SJ0PR13CA0191.outlook.office365.com
 (2603:10b6:a03:2c3::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.14 via Frontend Transport; Thu,
 26 Feb 2026 13:11:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 SJ5PEPF000001CE.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 26 Feb 2026 13:11:28 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 07:11:27 -0600
Received: from DLEE204.ent.ti.com (157.170.170.84) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 07:11:27 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 26 Feb 2026 07:11:27 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 61QDBQor2405115;
	Thu, 26 Feb 2026 07:11:26 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/3] crypto: ti - Add support for HMAC in DTHEv2 Hashing Engine driver
Date: Thu, 26 Feb 2026 18:41:03 +0530
Message-ID: <20260226131103.3560884-4-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260226131103.3560884-1-t-pratham@ti.com>
References: <20260226131103.3560884-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CE:EE_|PH7PR10MB6651:EE_
X-MS-Office365-Filtering-Correlation-Id: 0791f44e-9425-411a-1f12-08de75388d60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|34020700016|36860700013|82310400026|1800799024|7142099003;
X-Microsoft-Antispam-Message-Info:
	fHSL4BP/lFHsqPGbVVhZtDKn73q3n305vuFJnYXYo3kFZv41X20vG2R1rUx1gnRMjJSlq5Ji/Oj1lu9pff8G4hyEmns7zfSqFNJ97u3V59mPwT4m+8rFyKHavislVIUl7dYSsRs8nJZnjMWDs16BiyuYOuQzcw35sYQtpQqXAOLqsBamHx34efK51XOjJ+LkW3hDzs0FBbIPsSOC+PRZ9wvpkASrSmgyG9zyJn0FYwhOnL9jH9LSXsG8BEnfcA+IspFjyzcz0CKDYlR6MworzCddSf2EJv00089npstGs85WR2M5Mul1vzGWk61DQdItU8UU3Lldgpfx6lCbfgkF80g5WuLgDWvZYVRzGUyT7YEpSDVCImCjXIsvpL+mv0SXUHJT2MxPz2L4ro40ukU0qx1ld7ZTvJAzpM1GkNmmW+WPCGafqQiC3QUDmEcQj85839/x3T/xiW8TflKDuJq94XScYIY1eR8grFJUiKWzLQJPv8PkfjF9LARZ+TbjOpjtY8qjujebZffBn8nAfFDdaOelq/nTwpY8wO4ClbUREW0x3Lxe5+8qo6vlPN9sLMrWQVmGoyMMHTIOjjxglOVFvtOFWITqChke+rE0rFBzxq63xyn2IYr37SFHs1HBuHtpi7yCvSEmEzaBEoXS004Hc5lKRr6VK6ftPbTuvMmWxovgfsNGSsVVc1hW5d+YwULxfrAN/oqYoPsMdXH3zR+xxRSpu6oBv9j4+9Ft2GY765J79r6Haj5nfSNql4cy3ZLAsemtr4pFJzjksXKGHhiCMWEXxYM174TDO3g7I30fncrzEQHrfzJSoJZcho7i1IcKBFL0oraYgEm2XWnDWNfXeg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(34020700016)(36860700013)(82310400026)(1800799024)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lUPLHSuncu1ry7WIOpsYe74A7dPO5pC3CJG8ADhkdTBK50Wo5PBhvCg7g//AIg8jWnY/ziLwJh2j8vSwafwxfvf55EcKBKoSGNXWzuqh/hBHLgNeAQCwNAx948tXlNR/e4MSIvnNB/DVJisaeIN6I6xXs/dmrvGuTNNm2H4tSRF7SttXL1phvefZEfvj9d2J1qN66s9NcEzt+CRvKHfuvQapxn+fIWzp237ZDvZ5EDJeQDY4C6RpbXztY0aG7SvLNLCKtJ5q/tCmfWuNZsR65X4EnO8jap8nRqffLj2DInaAoz9eU8dtmZFWUkdE1X2ET6GfODi884dH+ZOPSzF2jg0JQy3FquB1O/V2PCdrFex25RVy1BbF5S3wWRSjY5OD9oL8zY2YHF6fyfIg4z2RbOFHvwVqbD1hL3veglrND7mEThN2TVCYQRWgbjNiWZP0
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 13:11:28.2371
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0791f44e-9425-411a-1f12-08de75388d60
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6651

Add support for HMAC-SHA512/384/256/224 and HMAC-MD5 algorithms in the
hashing engine of the DTHEv2 hardware cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-common.h |  10 +-
 drivers/crypto/ti/dthev2-hash.c   | 290 +++++++++++++++++++++++++++++-
 3 files changed, 296 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index 9c2aa50cfbfbe..68dccf92f5382 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -13,6 +13,7 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	select CRYPTO_MD5
+	select CRYPTO_HMAC
 	select SG_SPLIT
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 24799007ea81f..847804ed74736 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -31,9 +31,9 @@
 #define DTHE_DMA_TIMEOUT_MS	2000
 /*
  * Size of largest possible key (of all algorithms) to be stored in dthe_tfm_ctx
- * This is currently the keysize of XTS-AES-256 which is 512 bits (64 bytes)
+ * This is currently the keysize of HMAC-SHA512 which is 1024 bits (128 bytes)
  */
-#define DTHE_MAX_KEYSIZE	(AES_MAX_KEY_SIZE * 2)
+#define DTHE_MAX_KEYSIZE	(SHA512_BLOCK_SIZE)
 
 enum dthe_hash_alg_sel {
 	DTHE_HASH_MD5		= 0,
@@ -93,9 +93,9 @@ struct dthe_list {
 /**
  * struct dthe_tfm_ctx - Transform ctx struct containing ctx for all sub-components of DTHE V2
  * @dev_data: Device data struct pointer
- * @keylen: AES key length
+ * @keylen: Key length for algorithms that use a key
  * @authsize: Authentication size for modes with authentication
- * @key: AES key
+ * @key: Buffer storing the key
  * @aes_mode: AES mode
  * @hash_mode: Hashing Engine mode
  * @phash_size: partial hash size of the hash algorithm selected
@@ -135,6 +135,7 @@ struct dthe_aes_req_ctx {
  * @phash: buffer to store a partial hash from a previous operation
  * @digestcnt: stores the digest count from a previous operation; currently hardware only provides
  *             a single 32-bit value even for SHA384/512
+ * @odigest: buffer to store the outer digest from a previous operation
  * @phash_available: flag indicating if a partial hash from a previous operation is available
  * @flags: flags for internal use
  * @padding: padding buffer for handling unaligned data
@@ -143,6 +144,7 @@ struct dthe_aes_req_ctx {
 struct dthe_hash_req_ctx {
 	u32 phash[SHA512_DIGEST_SIZE / sizeof(u32)];
 	u64 digestcnt[2];
+	u32 odigest[SHA512_DIGEST_SIZE / sizeof(u32)];
 	u8 phash_available;
 	u8 flags;
 	u8 padding[SHA512_BLOCK_SIZE];
diff --git a/drivers/crypto/ti/dthev2-hash.c b/drivers/crypto/ti/dthev2-hash.c
index e4efcad375bf9..ca4a0a724b4d9 100644
--- a/drivers/crypto/ti/dthev2-hash.c
+++ b/drivers/crypto/ti/dthev2-hash.c
@@ -23,6 +23,7 @@
 /* Registers */
 
 #define DTHE_P_HASH_BASE		0x5000
+#define DTHE_P_HASH512_ODIGEST_A	0x0200
 #define DTHE_P_HASH512_IDIGEST_A	0x0240
 #define DTHE_P_HASH512_DIGEST_COUNT	0x0280
 #define DTHE_P_HASH512_MODE		0x0284
@@ -45,6 +46,13 @@
 
 #define DTHE_HASH_MODE_USE_ALG_CONST		BIT(3)
 #define DTHE_HASH_MODE_CLOSE_HASH		BIT(4)
+#define DTHE_HASH_MODE_HMAC_KEY_PROCESSING	BIT(5)
+#define DTHE_HASH_MODE_HMAC_OUTER_HASH		BIT(7)
+
+/* Misc */
+#define DTHE_HMAC_SHA512_MAX_KEYSIZE		(SHA512_BLOCK_SIZE)
+#define DTHE_HMAC_SHA256_MAX_KEYSIZE		(SHA256_BLOCK_SIZE)
+#define DTHE_HMAC_MD5_MAX_KEYSIZE		(MD5_BLOCK_SIZE)
 
 enum dthe_hash_op {
 	DTHE_HASH_OP_UPDATE = 0,
@@ -74,6 +82,19 @@ static void dthe_hash_write_zero_message(enum dthe_hash_alg_sel mode, void *dst)
 	}
 }
 
+static int dthe_hmac_write_zero_message(struct ahash_request *req)
+{
+	HASH_FBREQ_ON_STACK(fbreq, req);
+	int ret;
+
+	ahash_request_set_crypt(fbreq, req->src, req->result,
+				req->nbytes);
+
+	ret = crypto_ahash_digest(fbreq);
+	HASH_REQUEST_ZERO(fbreq);
+	return ret;
+}
+
 static enum dthe_hash_alg_sel dthe_hash_get_hash_mode(struct crypto_ahash *tfm)
 {
 	unsigned int ds = crypto_ahash_digestsize(tfm);
@@ -184,6 +205,7 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 	enum dma_data_direction src_dir = DMA_TO_DEVICE;
 	u32 hash_mode;
 	int ds = crypto_ahash_digestsize(tfm);
+	bool is_hmac = (ctx->keylen > 0);
 	int ret = 0;
 	u32 *dst;
 	u32 dst_len;
@@ -229,8 +251,11 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 
 	hash_mode = ctx->hash_mode;
 
-	if (rctx->flags == DTHE_HASH_OP_FINUP)
+	if (rctx->flags == DTHE_HASH_OP_FINUP) {
 		hash_mode |= DTHE_HASH_MODE_CLOSE_HASH;
+		if (is_hmac)
+			hash_mode |= DTHE_HASH_MODE_HMAC_OUTER_HASH;
+	}
 
 	if (rctx->phash_available) {
 		for (int i = 0; i < ctx->phash_size / sizeof(u32); ++i)
@@ -238,9 +263,28 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 				       sha_base_reg +
 				       DTHE_P_HASH512_IDIGEST_A +
 				       (DTHE_REG_SIZE * i));
+		if (is_hmac) {
+			for (int i = 0; i < ctx->phash_size / sizeof(u32); ++i)
+				writel_relaxed(rctx->odigest[i],
+					       sha_base_reg +
+					       DTHE_P_HASH512_ODIGEST_A +
+					       (DTHE_REG_SIZE * i));
+		}
 
 		writel_relaxed(rctx->digestcnt[0],
 			       sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
+	} else if (is_hmac) {
+		hash_mode |= DTHE_HASH_MODE_HMAC_KEY_PROCESSING;
+
+		for (int i = 0; i < (ctx->keylen / 2) / sizeof(u32); ++i)
+			writel_relaxed(ctx->key[i], sha_base_reg +
+				       DTHE_P_HASH512_ODIGEST_A +
+				       (DTHE_REG_SIZE * i));
+		for (int i = 0; i < (ctx->keylen / 2) / sizeof(u32); ++i)
+			writel_relaxed(ctx->key[i + (ctx->keylen / 2) / sizeof(u32)],
+				       sha_base_reg +
+				       DTHE_P_HASH512_IDIGEST_A +
+				       (DTHE_REG_SIZE * i));
 	} else {
 		hash_mode |= DTHE_HASH_MODE_USE_ALG_CONST;
 	}
@@ -275,6 +319,12 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 		dst[i] = readl_relaxed(sha_base_reg +
 				       DTHE_P_HASH512_IDIGEST_A +
 				       (DTHE_REG_SIZE * i));
+	if (is_hmac) {
+		for (int i = 0; i < dst_len; ++i)
+			rctx->odigest[i] = readl_relaxed(sha_base_reg +
+							 DTHE_P_HASH512_ODIGEST_A +
+							 (DTHE_REG_SIZE * i));
+	}
 
 	rctx->digestcnt[0] = readl_relaxed(sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
 	rctx->phash_available = 1;
@@ -399,6 +449,10 @@ static int dthe_hash_final(struct ahash_request *req)
 		return crypto_transfer_hash_request_to_engine(engine, req);
 	}
 
+	if (ctx->keylen > 0)
+		/* HMAC with zero-length message */
+		return dthe_hmac_write_zero_message(req);
+
 	dthe_hash_write_zero_message(ctx->hash_mode, req->result);
 
 	return 0;
@@ -432,6 +486,11 @@ static int dthe_hash_export(struct ahash_request *req, void *out)
 	if (ctx->phash_size >= SHA512_DIGEST_SIZE)
 		put_unaligned(rctx->digestcnt[1], p.u64++);
 
+	if (ctx->keylen > 0) {
+		memcpy(p.u8, rctx->odigest, ctx->phash_size);
+		p.u8 += ctx->phash_size;
+	}
+
 	return 0;
 }
 
@@ -452,9 +511,68 @@ static int dthe_hash_import(struct ahash_request *req, const void *in)
 		rctx->digestcnt[1] = get_unaligned(p.u64++);
 	rctx->phash_available = ((rctx->digestcnt[0]) ? 1 : 0);
 
+	if (ctx->keylen > 0) {
+		memcpy(rctx->odigest, p.u8, ctx->phash_size);
+		p.u8 += ctx->phash_size;
+	}
+
 	return 0;
 }
 
+static int dthe_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct crypto_ahash *fb = crypto_ahash_fb(tfm);
+	unsigned int max_keysize;
+	const char *hash_alg_name;
+
+	memzero_explicit(ctx->key, sizeof(ctx->key));
+
+	switch (ctx->hash_mode) {
+	case DTHE_HASH_SHA512:
+		hash_alg_name = "sha512";
+		max_keysize = DTHE_HMAC_SHA512_MAX_KEYSIZE;
+		break;
+	case DTHE_HASH_SHA384:
+		hash_alg_name = "sha384";
+		max_keysize = DTHE_HMAC_SHA512_MAX_KEYSIZE;
+		break;
+	case DTHE_HASH_SHA256:
+		hash_alg_name = "sha256";
+		max_keysize = DTHE_HMAC_SHA256_MAX_KEYSIZE;
+		break;
+	case DTHE_HASH_SHA224:
+		hash_alg_name = "sha224";
+		max_keysize = DTHE_HMAC_SHA256_MAX_KEYSIZE;
+		break;
+	case DTHE_HASH_MD5:
+		hash_alg_name = "md5";
+		max_keysize = DTHE_HMAC_MD5_MAX_KEYSIZE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (keylen > max_keysize) {
+		struct crypto_shash *ktfm = crypto_alloc_shash(hash_alg_name, 0, 0);
+		SHASH_DESC_ON_STACK(desc, ktfm);
+		int err;
+
+		desc->tfm = ktfm;
+		err = crypto_shash_digest(desc, key, keylen, (u8 *)ctx->key);
+		crypto_free_shash(ktfm);
+		if (err)
+			return err;
+	} else {
+		memcpy(ctx->key, key, keylen);
+	}
+
+	ctx->keylen = max_keysize;
+
+	return crypto_ahash_setkey(fb, key, keylen);
+}
+
 static struct ahash_engine_alg hash_algs[] = {
 	{
 		.base.init_tfm	= dthe_hash_init_tfm,
@@ -621,6 +739,176 @@ static struct ahash_engine_alg hash_algs[] = {
 		},
 		.op.do_one_request = dthe_hash_run,
 	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = SHA512_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(sha512)",
+				.cra_driver_name = "hmac-sha512-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_FINAL_NONZERO |
+						   CRYPTO_AHASH_ALG_FINUP_MAX |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA512_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = SHA384_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(sha384)",
+				.cra_driver_name = "hmac-sha384-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_FINAL_NONZERO |
+						   CRYPTO_AHASH_ALG_FINUP_MAX |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA384_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = SHA256_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(sha256)",
+				.cra_driver_name = "hmac-sha256-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_FINAL_NONZERO |
+						   CRYPTO_AHASH_ALG_FINUP_MAX |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA256_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = SHA224_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(sha224)",
+				.cra_driver_name = "hmac-sha224-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_FINAL_NONZERO |
+						   CRYPTO_AHASH_ALG_FINUP_MAX |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA224_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = MD5_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(md5)",
+				.cra_driver_name = "hmac-md5-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_FINAL_NONZERO |
+						   CRYPTO_AHASH_ALG_FINUP_MAX |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = MD5_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
 };
 
 int dthe_register_hash_algs(void)
-- 
2.34.1

