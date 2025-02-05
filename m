Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D632D2139A8;
	Wed,  5 Feb 2025 03:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738727795; cv=none; b=DQRBVIthyp1AOl4jEIIHVeRVR8PpNmcQ98OxG7fjkjduiOlkTEp7KiNPyFTKoB83wyxUpcYgubbyglPLMFOtzTiRBH1aEX8isSV91EMq6F0aMuo6MmcBXctQDgehnNfwnfwlLqsAyixLhGhC2/o6q222kx1x/2/5eTjGtq+xVdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738727795; c=relaxed/simple;
	bh=gxDUfiz508lFR9FAOT8zbqE2xLPBv1BoyTBdw43BgtM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JuMZw3ePI85zwSm6cBK7km5NppPr8NGAl4Do2hW1WAy+4Cyyd3XwGPfbFXKvQtPdOITNvpw923SGnGhG8D8J3oBgzCcWwM5RbBgmaiP8szAVb9gxFvdb0h8FYVmzIJoawX3LFqaPlqsaYzbOboLjjo0zLO3p0QgVkkpDqkikrQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YnmXk1B2Gz1l0Rk;
	Wed,  5 Feb 2025 11:52:54 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 9342B1401F2;
	Wed,  5 Feb 2025 11:56:30 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Feb 2025 11:56:29 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 2/3] crypto: hisilicon/sec2 - fix for aead authsize alignment
Date: Wed, 5 Feb 2025 11:56:27 +0800
Message-ID: <20250205035628.845962-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250205035628.845962-1-huangchenghai2@huawei.com>
References: <20250205035628.845962-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd200024.china.huawei.com (7.221.188.85)

From: Wenkai Lin <linwenkai6@hisilicon.com>

The hardware only supports authentication sizes
that are 4-byte aligned. Therefore, the driver
switches to software computation in this case.

Fixes: 2f072d75d1ab ("crypto: hisilicon - Add aead support on SEC2")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 472c5c52b..23e98a21b 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -57,7 +57,6 @@
 #define SEC_TYPE_MASK		0x0F
 #define SEC_DONE_MASK		0x0001
 #define SEC_ICV_MASK		0x000E
-#define SEC_SQE_LEN_RATE_MASK	0x3
 
 #define SEC_TOTAL_IV_SZ(depth)	(SEC_IV_SIZE * (depth))
 #define SEC_SGL_SGE_NR		128
@@ -80,16 +79,16 @@
 #define SEC_TOTAL_PBUF_SZ(depth)	(PAGE_SIZE * SEC_PBUF_PAGE_NUM(depth) +	\
 				SEC_PBUF_LEFT_SZ(depth))
 
-#define SEC_SQE_LEN_RATE	4
 #define SEC_SQE_CFLAG		2
 #define SEC_SQE_AEAD_FLAG	3
 #define SEC_SQE_DONE		0x1
 #define SEC_ICV_ERR		0x2
-#define MIN_MAC_LEN		4
 #define MAC_LEN_MASK		0x1U
 #define MAX_INPUT_DATA_LEN	0xFFFE00
 #define BITS_MASK		0xFF
+#define WORD_MASK		0x3
 #define BYTE_BITS		0x8
+#define BYTES_TO_WORDS(bcount)	((bcount) >> 2)
 #define SEC_XTS_NAME_SZ		0x3
 #define IV_CM_CAL_NUM		2
 #define IV_CL_MASK		0x7
@@ -1171,7 +1170,7 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		goto bad_key;
 	}
 
-	if (ctx->a_ctx.a_key_len & SEC_SQE_LEN_RATE_MASK) {
+	if (ctx->a_ctx.a_key_len & WORD_MASK) {
 		ret = -EINVAL;
 		dev_err(dev, "AUTH key length error!\n");
 		goto bad_key;
@@ -1579,11 +1578,10 @@ static void sec_auth_bd_fill_ex(struct sec_auth_ctx *ctx, int dir,
 
 	sec_sqe->type2.a_key_addr = cpu_to_le64(ctx->a_key_dma);
 
-	sec_sqe->type2.mac_key_alg = cpu_to_le32(authsize / SEC_SQE_LEN_RATE);
+	sec_sqe->type2.mac_key_alg = cpu_to_le32(BYTES_TO_WORDS(authsize));
 
 	sec_sqe->type2.mac_key_alg |=
-			cpu_to_le32((u32)((ctx->a_key_len) /
-			SEC_SQE_LEN_RATE) << SEC_AKEY_OFFSET);
+			cpu_to_le32((u32)BYTES_TO_WORDS(ctx->a_key_len) << SEC_AKEY_OFFSET);
 
 	sec_sqe->type2.mac_key_alg |=
 			cpu_to_le32((u32)(ctx->a_alg) << SEC_AEAD_ALG_OFFSET);
@@ -1635,12 +1633,10 @@ static void sec_auth_bd_fill_ex_v3(struct sec_auth_ctx *ctx, int dir,
 	sqe3->a_key_addr = cpu_to_le64(ctx->a_key_dma);
 
 	sqe3->auth_mac_key |=
-			cpu_to_le32((u32)(authsize /
-			SEC_SQE_LEN_RATE) << SEC_MAC_OFFSET_V3);
+			cpu_to_le32(BYTES_TO_WORDS(authsize) << SEC_MAC_OFFSET_V3);
 
 	sqe3->auth_mac_key |=
-			cpu_to_le32((u32)(ctx->a_key_len /
-			SEC_SQE_LEN_RATE) << SEC_AKEY_OFFSET_V3);
+			cpu_to_le32((u32)BYTES_TO_WORDS(ctx->a_key_len) << SEC_AKEY_OFFSET_V3);
 
 	sqe3->auth_mac_key |=
 			cpu_to_le32((u32)(ctx->a_alg) << SEC_AUTH_ALG_OFFSET_V3);
@@ -2230,8 +2226,8 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	struct device *dev = ctx->dev;
 	int ret;
 
-	/* Hardware does not handle cases where authsize is less than 4 bytes */
-	if (unlikely(sz < MIN_MAC_LEN)) {
+	/* Hardware does not handle cases where authsize is not 4 bytes aligned */
+	if (c_mode == SEC_CMODE_CBC && (sz & WORD_MASK)) {
 		sreq->aead_req.fallback = true;
 		return -EINVAL;
 	}
-- 
2.33.0

