Return-Path: <SRS0=YLdW=YV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDF4CA9EA0
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 06:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5CCC20862
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 06:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730425AbfJ1Ghs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Oct 2019 02:37:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22000 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729298AbfJ1Ghs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Oct 2019 02:37:48 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9S6aq3Q164977
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2019 02:37:46 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vvhsspg20-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2019 02:37:45 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <freude@linux.ibm.com>;
        Mon, 28 Oct 2019 06:37:42 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 28 Oct 2019 06:37:39 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9S6b4IM32047566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Oct 2019 06:37:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 031D742045;
        Mon, 28 Oct 2019 06:37:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33BA142042;
        Mon, 28 Oct 2019 06:37:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.187.76])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Oct 2019 06:37:37 +0000 (GMT)
From:   Harald Freudenberger <freude@linux.ibm.com>
To:     linux390-list@tuxmaker.boeblingen.de.ibm.com,
        linux-crypto@vger.kernel.org
Cc:     ifranzki@linux.ibm.com, ebiggers@kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>
Subject: [PATCH] s390/crypto: Rework on paes implementation
Date:   Mon, 28 Oct 2019 08:37:31 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19102806-4275-0000-0000-000003785135
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102806-4276-0000-0000-0000388B825F
Message-Id: <20191028073731.11778-1-freude@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-28_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910280065
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There have been some findings during Eric Biggers rework of the
paes implementation which this patch tries to address:

A very minor finding within paes ctr where when the cpacf instruction
returns with only partially data en/decrytped the walk_done() was
mistakenly done with the all data counter.  Please note this can only
happen when the kmctr returns because the protected key became invalid
in the middle of the operation. And this is only with suspend and
resume on a system with different effective wrapping key.

Eric Biggers mentioned that the context struct within the tfm struct
may be shared among multiple kernel threads. So here now a rework
which uses a spinlock per context to protect the read and write of the
protected key blob value. The en/decrypt functions copy the protected
key(s) at the beginning into a param struct and do not work with the
protected key within the context any more. If the protected key in the
param struct becomes invalid, the key material is again converted to
protected key(s) and the context gets this update protected by the
spinlock. Race conditions are still possible and may result in writing
the very same protected key value more than once. So the spinlock
needs to make sure the protected key(s) within the context are
consistent updated.

The ctr page is now locked by a mutex instead of a spinlock. A similar
patch went into the aes_s390 code as a result of a complain "sleeping
function called from invalid context at ...algapi.h". See
commit 1c2c7029c008 ("s390/crypto: fix possible sleep during spinlock
aquired")' for more.

Tested and verified with additional testcases via AF_ALG interface and
additional selftests within the kernel (which currently only exist as
a patch set on my harddisk but will get upstream soon).

Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 arch/s390/crypto/paes_s390.c | 144 ++++++++++++++++++++++++++---------
 1 file changed, 108 insertions(+), 36 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index c7119c617b6e..37ac289414e2 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/cpufeature.h>
 #include <linux/init.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/xts.h>
@@ -36,7 +37,7 @@
 #define PAES_MAX_KEYSIZE 256
 
 static u8 *ctrblk;
-static DEFINE_SPINLOCK(ctrblk_lock);
+static DEFINE_MUTEX(ctrblk_lock);
 
 static cpacf_mask_t km_functions, kmc_functions, kmctr_functions;
 
@@ -82,17 +83,19 @@ static inline void _free_kb_keybuf(struct key_blob *kb)
 struct s390_paes_ctx {
 	struct key_blob kb;
 	struct pkey_protkey pk;
+	spinlock_t pk_lock;
 	unsigned long fc;
 };
 
 struct s390_pxts_ctx {
 	struct key_blob kb[2];
 	struct pkey_protkey pk[2];
+	spinlock_t pk_lock;
 	unsigned long fc;
 };
 
-static inline int __paes_convert_key(struct key_blob *kb,
-				     struct pkey_protkey *pk)
+static inline int __paes_keyblob2pkey(struct key_blob *kb,
+				      struct pkey_protkey *pk)
 {
 	int i, ret;
 
@@ -106,22 +109,18 @@ static inline int __paes_convert_key(struct key_blob *kb,
 	return ret;
 }
 
-static int __paes_set_key(struct s390_paes_ctx *ctx)
+static inline int __paes_convert_key(struct s390_paes_ctx *ctx)
 {
-	unsigned long fc;
+	struct pkey_protkey pkey;
 
-	if (__paes_convert_key(&ctx->kb, &ctx->pk))
+	if (__paes_keyblob2pkey(&ctx->kb, &pkey))
 		return -EINVAL;
 
-	/* Pick the correct function code based on the protected key type */
-	fc = (ctx->pk.type == PKEY_KEYTYPE_AES_128) ? CPACF_KM_PAES_128 :
-		(ctx->pk.type == PKEY_KEYTYPE_AES_192) ? CPACF_KM_PAES_192 :
-		(ctx->pk.type == PKEY_KEYTYPE_AES_256) ? CPACF_KM_PAES_256 : 0;
-
-	/* Check if the function code is available */
-	ctx->fc = (fc && cpacf_test_func(&km_functions, fc)) ? fc : 0;
+	spin_lock(&ctx->pk_lock);
+	memcpy(&ctx->pk, &pkey, sizeof(pkey));
+	spin_unlock(&ctx->pk_lock);
 
-	return ctx->fc ? 0 : -EINVAL;
+	return 0;
 }
 
 static int ecb_paes_init(struct crypto_skcipher *tfm)
@@ -129,6 +128,7 @@ static int ecb_paes_init(struct crypto_skcipher *tfm)
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	ctx->kb.key = NULL;
+	spin_lock_init(&ctx->pk_lock);
 
 	return 0;
 }
@@ -140,6 +140,24 @@ static void ecb_paes_exit(struct crypto_skcipher *tfm)
 	_free_kb_keybuf(&ctx->kb);
 }
 
+static inline int __ecb_paes_set_key(struct s390_paes_ctx *ctx)
+{
+	unsigned long fc;
+
+	if (__paes_convert_key(ctx))
+		return -EINVAL;
+
+	/* Pick the correct function code based on the protected key type */
+	fc = (ctx->pk.type == PKEY_KEYTYPE_AES_128) ? CPACF_KM_PAES_128 :
+		(ctx->pk.type == PKEY_KEYTYPE_AES_192) ? CPACF_KM_PAES_192 :
+		(ctx->pk.type == PKEY_KEYTYPE_AES_256) ? CPACF_KM_PAES_256 : 0;
+
+	/* Check if the function code is available */
+	ctx->fc = (fc && cpacf_test_func(&km_functions, fc)) ? fc : 0;
+
+	return ctx->fc ? 0 : -EINVAL;
+}
+
 static int ecb_paes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 			    unsigned int key_len)
 {
@@ -151,7 +169,7 @@ static int ecb_paes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
 	if (rc)
 		return rc;
 
-	if (__paes_set_key(ctx)) {
+	if (__ecb_paes_set_key(ctx)) {
 		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return -EINVAL;
 	}
@@ -165,18 +183,31 @@ static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	struct skcipher_walk walk;
 	unsigned int nbytes, n, k;
 	int ret;
+	struct {
+		u8 key[MAXPROTKEYSIZE];
+	} param;
 
 	ret = skcipher_walk_virt(&walk, req, false);
+	if (ret)
+		return ret;
+
+	spin_lock(&ctx->pk_lock);
+	memcpy(param.key, ctx->pk.protkey, MAXPROTKEYSIZE);
+	spin_unlock(&ctx->pk_lock);
+
 	while ((nbytes = walk.nbytes) != 0) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
-		k = cpacf_km(ctx->fc | modifier, ctx->pk.protkey,
+		k = cpacf_km(ctx->fc | modifier, &param,
 			     walk.dst.virt.addr, walk.src.virt.addr, n);
 		if (k)
 			ret = skcipher_walk_done(&walk, nbytes - k);
 		if (k < n) {
-			if (__paes_set_key(ctx) != 0)
+			if (__paes_convert_key(ctx))
 				return skcipher_walk_done(&walk, -EIO);
+			spin_lock(&ctx->pk_lock);
+			memcpy(param.key, ctx->pk.protkey, MAXPROTKEYSIZE);
+			spin_unlock(&ctx->pk_lock);
 		}
 	}
 	return ret;
@@ -214,6 +245,7 @@ static int cbc_paes_init(struct crypto_skcipher *tfm)
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	ctx->kb.key = NULL;
+	spin_lock_init(&ctx->pk_lock);
 
 	return 0;
 }
@@ -225,11 +257,11 @@ static void cbc_paes_exit(struct crypto_skcipher *tfm)
 	_free_kb_keybuf(&ctx->kb);
 }
 
-static int __cbc_paes_set_key(struct s390_paes_ctx *ctx)
+static inline int __cbc_paes_set_key(struct s390_paes_ctx *ctx)
 {
 	unsigned long fc;
 
-	if (__paes_convert_key(&ctx->kb, &ctx->pk))
+	if (__paes_convert_key(ctx))
 		return -EINVAL;
 
 	/* Pick the correct function code based on the protected key type */
@@ -276,8 +308,12 @@ static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	ret = skcipher_walk_virt(&walk, req, false);
 	if (ret)
 		return ret;
+
 	memcpy(param.iv, walk.iv, AES_BLOCK_SIZE);
+	spin_lock(&ctx->pk_lock);
 	memcpy(param.key, ctx->pk.protkey, MAXPROTKEYSIZE);
+	spin_unlock(&ctx->pk_lock);
+
 	while ((nbytes = walk.nbytes) != 0) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
@@ -288,9 +324,11 @@ static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 			ret = skcipher_walk_done(&walk, nbytes - k);
 		}
 		if (k < n) {
-			if (__cbc_paes_set_key(ctx) != 0)
+			if (__paes_convert_key(ctx))
 				return skcipher_walk_done(&walk, -EIO);
+			spin_lock(&ctx->pk_lock);
 			memcpy(param.key, ctx->pk.protkey, MAXPROTKEYSIZE);
+			spin_unlock(&ctx->pk_lock);
 		}
 	}
 	return ret;
@@ -330,6 +368,7 @@ static int xts_paes_init(struct crypto_skcipher *tfm)
 
 	ctx->kb[0].key = NULL;
 	ctx->kb[1].key = NULL;
+	spin_lock_init(&ctx->pk_lock);
 
 	return 0;
 }
@@ -342,12 +381,27 @@ static void xts_paes_exit(struct crypto_skcipher *tfm)
 	_free_kb_keybuf(&ctx->kb[1]);
 }
 
-static int __xts_paes_set_key(struct s390_pxts_ctx *ctx)
+static inline int __xts_paes_convert_key(struct s390_pxts_ctx *ctx)
+{
+	struct pkey_protkey pkey0, pkey1;
+
+	if (__paes_keyblob2pkey(&ctx->kb[0], &pkey0) ||
+	    __paes_keyblob2pkey(&ctx->kb[1], &pkey1))
+		return -EINVAL;
+
+	spin_lock(&ctx->pk_lock);
+	memcpy(&ctx->pk[0], &pkey0, sizeof(pkey0));
+	memcpy(&ctx->pk[1], &pkey1, sizeof(pkey1));
+	spin_unlock(&ctx->pk_lock);
+
+	return 0;
+}
+
+static inline int __xts_paes_set_key(struct s390_pxts_ctx *ctx)
 {
 	unsigned long fc;
 
-	if (__paes_convert_key(&ctx->kb[0], &ctx->pk[0]) ||
-	    __paes_convert_key(&ctx->kb[1], &ctx->pk[1]))
+	if (__xts_paes_convert_key(ctx))
 		return -EINVAL;
 
 	if (ctx->pk[0].type != ctx->pk[1].type)
@@ -430,10 +484,11 @@ static int xts_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 retry:
 	memset(&pcc_param, 0, sizeof(pcc_param));
 	memcpy(pcc_param.tweak, walk.iv, sizeof(pcc_param.tweak));
+	spin_lock(&ctx->pk_lock);
 	memcpy(pcc_param.key + offset, ctx->pk[1].protkey, keylen);
 	cpacf_pcc(ctx->fc, pcc_param.key + offset);
-
 	memcpy(xts_param.key + offset, ctx->pk[0].protkey, keylen);
+	spin_unlock(&ctx->pk_lock);
 	memcpy(xts_param.init, pcc_param.xts, 16);
 
 	while ((nbytes = walk.nbytes) != 0) {
@@ -444,7 +499,7 @@ static int xts_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 		if (k)
 			ret = skcipher_walk_done(&walk, nbytes - k);
 		if (k < n) {
-			if (__xts_paes_set_key(ctx) != 0)
+			if (__xts_paes_convert_key(ctx))
 				return skcipher_walk_done(&walk, -EIO);
 			goto retry;
 		}
@@ -485,6 +540,7 @@ static int ctr_paes_init(struct crypto_skcipher *tfm)
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	ctx->kb.key = NULL;
+	spin_lock_init(&ctx->pk_lock);
 
 	return 0;
 }
@@ -496,11 +552,11 @@ static void ctr_paes_exit(struct crypto_skcipher *tfm)
 	_free_kb_keybuf(&ctx->kb);
 }
 
-static int __ctr_paes_set_key(struct s390_paes_ctx *ctx)
+static inline int __ctr_paes_set_key(struct s390_paes_ctx *ctx)
 {
 	unsigned long fc;
 
-	if (__paes_convert_key(&ctx->kb, &ctx->pk))
+	if (__paes_convert_key(ctx))
 		return -EINVAL;
 
 	/* Pick the correct function code based on the protected key type */
@@ -556,45 +612,61 @@ static int ctr_paes_crypt(struct skcipher_request *req)
 	struct skcipher_walk walk;
 	unsigned int nbytes, n, k;
 	int ret, locked;
-
-	locked = spin_trylock(&ctrblk_lock);
+	struct {
+		u8 key[MAXPROTKEYSIZE];
+	} param;
 
 	ret = skcipher_walk_virt(&walk, req, false);
+	if (ret)
+		return ret;
+
+	spin_lock(&ctx->pk_lock);
+	memcpy(param.key, ctx->pk.protkey, MAXPROTKEYSIZE);
+	spin_unlock(&ctx->pk_lock);
+
+	locked = mutex_trylock(&ctrblk_lock);
+
 	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
 		n = AES_BLOCK_SIZE;
 		if (nbytes >= 2*AES_BLOCK_SIZE && locked)
 			n = __ctrblk_init(ctrblk, walk.iv, nbytes);
 		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk.iv;
-		k = cpacf_kmctr(ctx->fc, ctx->pk.protkey, walk.dst.virt.addr,
+		k = cpacf_kmctr(ctx->fc, &param, walk.dst.virt.addr,
 				walk.src.virt.addr, n, ctrptr);
 		if (k) {
 			if (ctrptr == ctrblk)
 				memcpy(walk.iv, ctrptr + k - AES_BLOCK_SIZE,
 				       AES_BLOCK_SIZE);
 			crypto_inc(walk.iv, AES_BLOCK_SIZE);
-			ret = skcipher_walk_done(&walk, nbytes - n);
+			ret = skcipher_walk_done(&walk, nbytes - k);
 		}
 		if (k < n) {
-			if (__ctr_paes_set_key(ctx) != 0) {
+			if (__paes_convert_key(ctx)) {
 				if (locked)
-					spin_unlock(&ctrblk_lock);
+					mutex_unlock(&ctrblk_lock);
 				return skcipher_walk_done(&walk, -EIO);
 			}
+			spin_lock(&ctx->pk_lock);
+			memcpy(param.key, ctx->pk.protkey, MAXPROTKEYSIZE);
+			spin_unlock(&ctx->pk_lock);
 		}
 	}
 	if (locked)
-		spin_unlock(&ctrblk_lock);
+		mutex_unlock(&ctrblk_lock);
 	/*
 	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
 	 */
 	if (nbytes) {
 		while (1) {
-			if (cpacf_kmctr(ctx->fc, ctx->pk.protkey, buf,
+			if (cpacf_kmctr(ctx->fc, &param, buf,
 					walk.src.virt.addr, AES_BLOCK_SIZE,
 					walk.iv) == AES_BLOCK_SIZE)
 				break;
-			if (__ctr_paes_set_key(ctx) != 0)
+			if (__paes_convert_key(ctx))
 				return skcipher_walk_done(&walk, -EIO);
+			spin_lock(&ctx->pk_lock);
+			memcpy(param.key, ctx->pk.protkey, MAXPROTKEYSIZE);
+			spin_unlock(&ctx->pk_lock);
 		}
 		memcpy(walk.dst.virt.addr, buf, nbytes);
 		crypto_inc(walk.iv, AES_BLOCK_SIZE);
-- 
2.17.1

