From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH] crypto: s390 - Fix aes-xts parameter corruption
Date: Tue, 19 Nov 2013 17:12:47 +0100
Message-ID: <1384877567-23593-1-git-send-email-gerald.schaefer@de.ibm.com>
Cc: linux-crypto@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Tuchscherer <ingo.tuchscherer@linux.vnet.ibm.com>,
	Harald Freudenberger <freude@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:57995 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3KSQM7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Nov 2013 11:12:59 -0500
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <gerald.schaefer@de.ibm.com>;
	Tue, 19 Nov 2013 16:12:58 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7B6362190068
	for <linux-crypto@vger.kernel.org>; Tue, 19 Nov 2013 16:12:56 +0000 (GMT)
Received: from d06av08.portsmouth.uk.ibm.com (d06av08.portsmouth.uk.ibm.com [9.149.37.249])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rAJGCiQW38797358
	for <linux-crypto@vger.kernel.org>; Tue, 19 Nov 2013 16:12:44 GMT
Received: from d06av08.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av08.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rAJGCtdJ012875
	for <linux-crypto@vger.kernel.org>; Tue, 19 Nov 2013 09:12:56 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some s390 crypto algorithms incorrectly use the crypto_tfm structure to
store private data. As the tfm can be shared among multiple threads, this
can result in data corruption.

This patch fixes aes-xts by moving the xts and pcc parameter blocks from
the tfm onto the stack (48 + 96 bytes).

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 arch/s390/crypto/aes_s390.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 4363528..b3feabd 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -55,8 +55,7 @@ struct pcc_param {
 
 struct s390_xts_ctx {
 	u8 key[32];
-	u8 xts_param[16];
-	struct pcc_param pcc;
+	u8 pcc_key[32];
 	long enc;
 	long dec;
 	int key_len;
@@ -591,7 +590,7 @@ static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		xts_ctx->enc = KM_XTS_128_ENCRYPT;
 		xts_ctx->dec = KM_XTS_128_DECRYPT;
 		memcpy(xts_ctx->key + 16, in_key, 16);
-		memcpy(xts_ctx->pcc.key + 16, in_key + 16, 16);
+		memcpy(xts_ctx->pcc_key + 16, in_key + 16, 16);
 		break;
 	case 48:
 		xts_ctx->enc = 0;
@@ -602,7 +601,7 @@ static int xts_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		xts_ctx->enc = KM_XTS_256_ENCRYPT;
 		xts_ctx->dec = KM_XTS_256_DECRYPT;
 		memcpy(xts_ctx->key, in_key, 32);
-		memcpy(xts_ctx->pcc.key, in_key + 32, 32);
+		memcpy(xts_ctx->pcc_key, in_key + 32, 32);
 		break;
 	default:
 		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
@@ -621,29 +620,33 @@ static int xts_aes_crypt(struct blkcipher_desc *desc, long func,
 	unsigned int nbytes = walk->nbytes;
 	unsigned int n;
 	u8 *in, *out;
-	void *param;
+	struct pcc_param pcc_param;
+	struct {
+		u8 key[32];
+		u8 init[16];
+	} xts_param;
 
 	if (!nbytes)
 		goto out;
 
-	memset(xts_ctx->pcc.block, 0, sizeof(xts_ctx->pcc.block));
-	memset(xts_ctx->pcc.bit, 0, sizeof(xts_ctx->pcc.bit));
-	memset(xts_ctx->pcc.xts, 0, sizeof(xts_ctx->pcc.xts));
-	memcpy(xts_ctx->pcc.tweak, walk->iv, sizeof(xts_ctx->pcc.tweak));
-	param = xts_ctx->pcc.key + offset;
-	ret = crypt_s390_pcc(func, param);
+	memset(pcc_param.block, 0, sizeof(pcc_param.block));
+	memset(pcc_param.bit, 0, sizeof(pcc_param.bit));
+	memset(pcc_param.xts, 0, sizeof(pcc_param.xts));
+	memcpy(pcc_param.tweak, walk->iv, sizeof(pcc_param.tweak));
+	memcpy(pcc_param.key, xts_ctx->pcc_key, 32);
+	ret = crypt_s390_pcc(func, &pcc_param.key[offset]);
 	if (ret < 0)
 		return -EIO;
 
-	memcpy(xts_ctx->xts_param, xts_ctx->pcc.xts, 16);
-	param = xts_ctx->key + offset;
+	memcpy(xts_param.key, xts_ctx->key, 32);
+	memcpy(xts_param.init, pcc_param.xts, 16);
 	do {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		out = walk->dst.virt.addr;
 		in = walk->src.virt.addr;
 
-		ret = crypt_s390_km(func, param, out, in, n);
+		ret = crypt_s390_km(func, &xts_param.key[offset], out, in, n);
 		if (ret < 0 || ret != n)
 			return -EIO;
 
-- 
1.8.3.4
