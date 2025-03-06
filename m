Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B938F25B670;
	Thu,  6 Mar 2025 17:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741281134; cv=none; b=RS4/YqmrUXdU85sCR9W5uXX32Tk7XNhF/wE+K5t66zQNEsE+fujJHsSDR0HHVz0v2md/XdSNFsJFC3m9GQaxwfhY5pvOkI5TA/uTx3xT8dDUTUhKcSKu2quWKDSXlBeVWTxhk7zlxc3/DCjZysOpTlEZxm2U4aKWnReaJn0yfik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741281134; c=relaxed/simple;
	bh=rCJDjYp4sYheNxSKEu9uVMOi3eHYAgM+M4BDTe55v1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWZGezDiK3HseP9AmW59IoZjz4YKtPn1B51Znfhw4gprDY/bnhGBjHZYWDkQ4ezqiEsJwmghc8lZL3bS5jJsUvSaPi+mAX0gNpwXFKH4ejbc5mKYyGeDWKPLkm8iWreLqFe0cj5jGeNC58UnghQ/laknvrwZ1JDADEwFCU6pKRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gnxrAfPl; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gnxrAfPl"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 526E3TSX019731;
	Thu, 6 Mar 2025 17:12:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=77NmcF3d1eid7WKPn
	Rst8Qa1xnNW7qvXrQwru4iOOzM=; b=gnxrAfPl9usVaBzE7qcuLKHO2tipjFcXE
	MnuE89Zl6VRDWWDxLPtsV1dLSt3yIMu6Km822fMMszQ9zqZBilcWLElnu3d9DgJ3
	4o/DO5O+IUTZgxxxy+YdorXa8oKfReYMM7H4RL3zqpz1zi+f2UcgjBFXyrzTzeNu
	v6fMFH9hlMnVeoUS28LJjRr+bo8IJsfoSUwxaPR8a+pSLYkKRIlCNfkt8KpRldC0
	43lsvU7HiQUQBO0vKF4dFkaehbYe7qr2uSsV5HcXAgbK2qFdSPrLxTJA70vt3vJW
	0xmVoaGsZZcRd09e1oSqRU3L8LGfXxfyVtDWgHyV7+R056bLxSnzw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 457d4p11um-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Mar 2025 17:12:07 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 526GhoNO020788;
	Thu, 6 Mar 2025 17:12:06 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 454esk9m5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Mar 2025 17:12:06 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 526HC2CL57344318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Mar 2025 17:12:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6AA042004F;
	Thu,  6 Mar 2025 17:12:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D14E2004B;
	Thu,  6 Mar 2025 17:12:02 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.179.2.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Mar 2025 17:12:01 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com,
        fcallies@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 1/1] s390/crypto: Rework protected key AES for true asynch support
Date: Thu,  6 Mar 2025 18:12:01 +0100
Message-ID: <20250306171201.17961-2-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250306171201.17961-1-freude@linux.ibm.com>
References: <20250306171201.17961-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P7hhqnvGUlB6GQHYmXKkKzVhefksbWjr
X-Proofpoint-ORIG-GUID: P7hhqnvGUlB6GQHYmXKkKzVhefksbWjr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-06_05,2025-03-06_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 phishscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503060129

This is a complete rework of the protected key AES (PAES) implementation.
The goal of this rework is to implement the 4 modes (ecb, cbc, ctr, xts)
in a real asynchronous fashion:
- init() and exit() both are synchronous, don't allocate any memory and
  do not sleep.
- the setkey() function initiates an asynch work to convert the key
  material via pkey interface into a protected key. setkey() does
  not allocate any memory and does not sleep. The asynch work is
  done in an own workqueue (so not congesting any system work queues).
  For the pkey API see more below.
- the encrypt/decrypt functions first try to do the job in a synchronous
  manner. If this fails, for example the protected key got invalid caused
  by for example a guest suspend/resume or guest migration action, the
  encrypt/decrypt is pushed into the workqueue for asynchronous processing.
  These asynch triggered workqueue functions of course may run again into
  a still not converted key or the key is getting invalid. If the key is
  still not converted, the job pushes itself into the workqueue for later
  processing. If the key needs re-convert, the conversion is invoked
  via pkey API. The asynch workqueue functions do not allocate any memory.

The pkey API used here - the function pkey_key2protkey() - uses
a new version of this in-kernel-API. A new flag PKEY_XFLAG_NOMEMALLOC
tells the PKEY layer (and subsidiary layers) that it must not allocate
any memory causing IO operations. Note that the patches for this
pkey/zcrypt/AP extensions are currently under review and yet not
upstream available. SO THIS PATCH DOES NOT COMPILE YET.

This patch together with the pkey/zcrypt/AP extensions should
toughen the paes crypto algorithms to truly meet the requirements
for in-kernel skcipher implementations and the usage patterns for
the dm-crypt and dm-integrity layers.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 arch/s390/crypto/paes_s390.c | 1482 +++++++++++++++++++++++-----------
 1 file changed, 1015 insertions(+), 467 deletions(-)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 646cbbf0678d..19215519db34 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -5,7 +5,7 @@
  * s390 implementation of the AES Cipher Algorithm with protected keys.
  *
  * s390 Version:
- *   Copyright IBM Corp. 2017, 2023
+ *   Copyright IBM Corp. 2017, 2025
  *   Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
  *		Harald Freudenberger <freude@de.ibm.com>
  */
@@ -25,6 +25,7 @@
 #include <linux/delay.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/xts.h>
+#include <linux/fips.h>
 #include <asm/cpacf.h>
 #include <asm/pkey.h>
 
@@ -44,23 +45,68 @@ static DEFINE_MUTEX(ctrblk_lock);
 
 static cpacf_mask_t km_functions, kmc_functions, kmctr_functions;
 
+/* A workqueue for all the paes asynch work */
+static struct workqueue_struct *paes_wq;
+
+/* Delay in jiffies when a requests needs to be re-scheduled */
+#define PAES_RESCHEDULE_DELAY 10
+
+/*
+ * protected key specific stuff
+ */
+
 struct paes_protkey {
 	u32 type;
 	u32 len;
 	u8 protkey[PXTS_256_PROTKEY_SIZE];
 };
 
-struct key_blob {
-	/*
-	 * Small keys will be stored in the keybuf. Larger keys are
-	 * stored in extra allocated memory. In both cases does
-	 * key point to the memory where the key is stored.
-	 * The code distinguishes by checking keylen against
-	 * sizeof(keybuf). See the two following helper functions.
-	 */
-	u8 *key;
-	u8 keybuf[128];
+#define PK_STATE_NO_KEY		     0
+#define PK_STATE_CONVERT_IN_PROGRESS 2
+#define PK_STATE_VALID		     3
+
+struct s390_paes_ctx {
+	/* source key material used to derive a protected key from */
+	u8 keybuf[PAES_MAX_KEYSIZE];
+	unsigned int keylen;
+
+	/* work struct for asynch setkey with key convert */
+	struct work_struct work;
+
+	/* spinlock to atomic read/update all the following fields */
+	spinlock_t pk_lock;
+	/* see PK_STATE* defines above, < 0 holds convert failure rc  */
+	int pk_state;
+	/* if state is valid, pk holds the protected key */
+	struct paes_protkey pk;
+
+	/* cpacf function code to use with this protected key type */
+	long fc;
+};
+
+struct s390_pxts_ctx {
+	/* source key material used to derive a protected key from */
+	u8 keybuf[2 * PAES_MAX_KEYSIZE];
 	unsigned int keylen;
+
+	/* work struct for asynch setkey with key convert */
+	struct work_struct work;
+
+	/* spinlock to atomic read/update all the following fields */
+	spinlock_t pk_lock;
+	/* see PK_STATE* defines above, < 0 holds convert failure rc  */
+	int pk_state;
+	/* if state is valid, pk holds the protected key */
+	struct paes_protkey pk[2];
+
+	/* cpacf function code to use with this protected key type */
+	long fc;
+};
+
+struct s390_paes_req_ctx {
+	struct delayed_work work;
+	struct skcipher_request *req;
+	unsigned long modifier;
 };
 
 /*
@@ -78,7 +124,7 @@ static inline u32 make_clrkey_token(const u8 *ck, size_t cklen, u8 *dest)
 		u32 keytype;
 		u32 len;
 		u8 key[];
-	} __packed *token = (struct clrkey_token *)dest;
+	} __packed * token = (struct clrkey_token *)dest;
 
 	token->type = 0x00;
 	token->version = 0x02;
@@ -89,214 +135,371 @@ static inline u32 make_clrkey_token(const u8 *ck, size_t cklen, u8 *dest)
 	return sizeof(*token) + cklen;
 }
 
-static inline int _key_to_kb(struct key_blob *kb,
-			     const u8 *key,
-			     unsigned int keylen)
+/*
+ * key_to_ctx() - Set key value into context, maybe construct
+ * a clear key token digestable by pkey from a clear key value.
+ */
+static inline int key_to_ctx(struct s390_paes_ctx *ctx,
+			     const u8 *key, unsigned int keylen)
 {
+	if (keylen > sizeof(ctx->keybuf))
+		return -EINVAL;
+
 	switch (keylen) {
 	case 16:
 	case 24:
 	case 32:
 		/* clear key value, prepare pkey clear key token in keybuf */
-		memset(kb->keybuf, 0, sizeof(kb->keybuf));
-		kb->keylen = make_clrkey_token(key, keylen, kb->keybuf);
-		kb->key = kb->keybuf;
+		memset(ctx->keybuf, 0, sizeof(ctx->keybuf));
+		ctx->keylen = make_clrkey_token(key, keylen, ctx->keybuf);
 		break;
 	default:
 		/* other key material, let pkey handle this */
-		if (keylen <= sizeof(kb->keybuf))
-			kb->key = kb->keybuf;
-		else {
-			kb->key = kmalloc(keylen, GFP_KERNEL);
-			if (!kb->key)
-				return -ENOMEM;
-		}
-		memcpy(kb->key, key, keylen);
-		kb->keylen = keylen;
+		memcpy(ctx->keybuf, key, keylen);
+		ctx->keylen = keylen;
 		break;
 	}
 
 	return 0;
 }
 
-static inline int _xts_key_to_kb(struct key_blob *kb,
-				 const u8 *key,
-				 unsigned int keylen)
+/*
+ * xts_key_to_ctx() - Set key value into context, maybe construct
+ * a clear key token digestable by pkey from a clear key value.
+ */
+static inline int xts_key_to_ctx(struct s390_pxts_ctx *ctx,
+				 const u8 *key, unsigned int keylen)
 {
 	size_t cklen = keylen / 2;
 
-	memset(kb->keybuf, 0, sizeof(kb->keybuf));
+	if (keylen > sizeof(ctx->keybuf))
+		return -EINVAL;
 
 	switch (keylen) {
 	case 32:
 	case 64:
 		/* clear key value, prepare pkey clear key tokens in keybuf */
-		kb->key = kb->keybuf;
-		kb->keylen  = make_clrkey_token(key, cklen, kb->key);
-		kb->keylen += make_clrkey_token(key + cklen, cklen,
-						kb->key + kb->keylen);
+		memset(ctx->keybuf, 0, sizeof(ctx->keybuf));
+		ctx->keylen = make_clrkey_token(key, cklen, ctx->keybuf);
+		ctx->keylen += make_clrkey_token(key + cklen, cklen,
+						 ctx->keybuf + ctx->keylen);
 		break;
 	default:
 		/* other key material, let pkey handle this */
-		if (keylen <= sizeof(kb->keybuf)) {
-			kb->key = kb->keybuf;
-		} else {
-			kb->key = kmalloc(keylen, GFP_KERNEL);
-			if (!kb->key)
-				return -ENOMEM;
-		}
-		memcpy(kb->key, key, keylen);
-		kb->keylen = keylen;
+		memcpy(ctx->keybuf, key, keylen);
+		ctx->keylen = keylen;
 		break;
 	}
 
 	return 0;
 }
 
-static inline void _free_kb_keybuf(struct key_blob *kb)
+/*
+ * Convert the raw key material into a protected key via PKEY api.
+ * This function may sleep - don't call in non-sleeping context.
+ */
+static inline int convert_key(const u8 *key, unsigned int keylen,
+			      struct paes_protkey *pk)
 {
-	if (kb->key && kb->key != kb->keybuf
-	    && kb->keylen > sizeof(kb->keybuf)) {
-		kfree_sensitive(kb->key);
-		kb->key = NULL;
-	}
-	memzero_explicit(kb->keybuf, sizeof(kb->keybuf));
-}
-
-struct s390_paes_ctx {
-	struct key_blob kb;
-	struct paes_protkey pk;
-	spinlock_t pk_lock;
-	unsigned long fc;
-};
-
-struct s390_pxts_ctx {
-	struct key_blob kb;
-	struct paes_protkey pk[2];
-	spinlock_t pk_lock;
-	unsigned long fc;
-};
+	int rc, i;
 
-static inline int __paes_keyblob2pkey(const u8 *key, unsigned int keylen,
-				      struct paes_protkey *pk)
-{
-	int i, rc = -EIO;
+	pk->len = sizeof(pk->protkey);
 
 	/* try three times in case of busy card */
-	for (i = 0; rc && i < 3; i++) {
-		if (rc == -EBUSY && in_task()) {
-			if (msleep_interruptible(1000))
-				return -EINTR;
+	for (rc = -EIO, i = 0; rc && i < 3; i++) {
+		if (rc == -EBUSY && msleep_interruptible((1 << i) * 100)) {
+			rc = -EINTR;
+			goto out;
 		}
-		rc = pkey_key2protkey(key, keylen, pk->protkey, &pk->len,
-				      &pk->type, PKEY_XFLAG_NOMEMALLOC);
+		rc = pkey_key2protkey(key, keylen,
+				      pk->protkey, &pk->len, &pk->type,
+				      PKEY_XFLAG_NOMEMALLOC);
 	}
 
+out:
+	pr_debug("rc=%d\n", rc);
 	return rc;
 }
 
-static inline int __paes_convert_key(struct s390_paes_ctx *ctx)
+/*
+ * (Re-)Convert the raw key material from the ctx into a
+ * protected key via convert_key() function. Update the
+ * pk_state, pk_type, pk_len and the protected key in
+ * the param block.
+ */
+static int paes_convert_key(struct s390_paes_ctx *ctx)
 {
 	struct paes_protkey pk;
 	int rc;
 
-	pk.len = sizeof(pk.protkey);
-	rc = __paes_keyblob2pkey(ctx->kb.key, ctx->kb.keylen, &pk);
-	if (rc)
-		return rc;
+	spin_lock_bh(&ctx->pk_lock);
+	ctx->pk_state = PK_STATE_CONVERT_IN_PROGRESS;
+	spin_unlock_bh(&ctx->pk_lock);
+
+	rc = convert_key(ctx->keybuf, ctx->keylen, &pk);
 
+	/* update context */
 	spin_lock_bh(&ctx->pk_lock);
-	memcpy(&ctx->pk, &pk, sizeof(pk));
+	if (rc) {
+		ctx->pk_state = rc;
+	} else {
+		ctx->pk_state = PK_STATE_VALID;
+		ctx->pk = pk;
+	}
 	spin_unlock_bh(&ctx->pk_lock);
 
-	return 0;
+	memzero_explicit(&pk, sizeof(pk));
+	pr_debug("rc=%d\n", rc);
+	return rc;
 }
 
-static int ecb_paes_init(struct crypto_skcipher *tfm)
+/*
+ * (Re-)Convert the raw xts key material from the ctx into
+ * a protected key via convert_key() function. Update the
+ * pk_state, pk_type, pk_len and the protected key in
+ * the param block.
+ */
+static int pxts_convert_key(struct s390_pxts_ctx *ctx)
 {
-	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct paes_protkey pk0, pk1;
+	size_t split_keylen;
+	int rc;
 
-	ctx->kb.key = NULL;
-	spin_lock_init(&ctx->pk_lock);
+	spin_lock_bh(&ctx->pk_lock);
+	ctx->pk_state = PK_STATE_CONVERT_IN_PROGRESS;
+	spin_unlock_bh(&ctx->pk_lock);
 
-	return 0;
-}
+	rc = convert_key(ctx->keybuf, ctx->keylen, &pk0);
+	if (rc)
+		goto out;
 
-static void ecb_paes_exit(struct crypto_skcipher *tfm)
-{
-	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	switch (pk0.type) {
+	case PKEY_KEYTYPE_AES_128:
+	case PKEY_KEYTYPE_AES_256:
+		/* second keytoken required */
+		if (ctx->keylen % 2) {
+			rc = -EINVAL;
+			goto out;
+		}
+		split_keylen = ctx->keylen / 2;
+		rc = convert_key(ctx->keybuf + split_keylen,
+				 split_keylen, &pk1);
+		if (rc)
+			goto out;
+		if (pk0.type != pk1.type) {
+			rc = -EINVAL;
+			goto out;
+		}
+		break;
+	case PKEY_KEYTYPE_AES_XTS_128:
+	case PKEY_KEYTYPE_AES_XTS_256:
+		/* single key */
+		pk1.type = 0;
+		break;
+	default:
+		/* unsupported protected keytype */
+		rc = -EINVAL;
+		goto out;
+	}
+
+out:
+	/* update context */
+	spin_lock_bh(&ctx->pk_lock);
+	if (rc) {
+		ctx->pk_state = rc;
+	} else {
+		ctx->pk_state = PK_STATE_VALID;
+		ctx->pk[0] = pk0;
+		ctx->pk[1] = pk1;
+	}
+	spin_unlock_bh(&ctx->pk_lock);
 
-	_free_kb_keybuf(&ctx->kb);
+	memzero_explicit(&pk0, sizeof(pk0));
+	memzero_explicit(&pk1, sizeof(pk1));
+	pr_debug("rc=%d\n", rc);
+	return rc;
 }
 
-static inline int __ecb_paes_set_key(struct s390_paes_ctx *ctx)
+/*
+ * PAES ECB implementation
+ */
+
+static void ecb_paes_wq_setkey_fn(struct work_struct *work)
 {
+	struct s390_paes_ctx *ctx = container_of(work, struct s390_paes_ctx, work);
 	unsigned long fc;
 	int rc;
 
-	rc = __paes_convert_key(ctx);
+	/* convert key into protected key */
+	rc = paes_convert_key(ctx);
 	if (rc)
-		return rc;
+		return;
 
 	/* Pick the correct function code based on the protected key type */
 	fc = (ctx->pk.type == PKEY_KEYTYPE_AES_128) ? CPACF_KM_PAES_128 :
 		(ctx->pk.type == PKEY_KEYTYPE_AES_192) ? CPACF_KM_PAES_192 :
 		(ctx->pk.type == PKEY_KEYTYPE_AES_256) ? CPACF_KM_PAES_256 : 0;
+	fc = (fc && cpacf_test_func(&km_functions, fc)) ? fc : 0;
 
-	/* Check if the function code is available */
-	ctx->fc = (fc && cpacf_test_func(&km_functions, fc)) ? fc : 0;
-
-	return ctx->fc ? 0 : -EINVAL;
+	/* Update context's function code */
+	ctx->fc = fc ? fc : -EINVAL;
 }
 
-static int ecb_paes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
-			    unsigned int key_len)
+static int ecb_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
+			   unsigned int key_len)
 {
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int rc;
 
-	_free_kb_keybuf(&ctx->kb);
-	rc = _key_to_kb(&ctx->kb, in_key, key_len);
+	rc = key_to_ctx(ctx, in_key, key_len);
 	if (rc)
 		return rc;
 
-	return __ecb_paes_set_key(ctx);
+	/* Always trigger an asynch key convert */
+	spin_lock_bh(&ctx->pk_lock);
+	ctx->pk_state = PK_STATE_CONVERT_IN_PROGRESS;
+	spin_unlock_bh(&ctx->pk_lock);
+	queue_work(paes_wq, &ctx->work);
+
+	return 0;
 }
 
-static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
+static int ecb_paes_do_crypt(struct s390_paes_ctx *ctx,
+			     struct skcipher_walk *walk,
+			     unsigned long modifier, bool maysleep)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct {
+	struct ecb_param {
 		u8 key[PAES_256_PROTKEY_SIZE];
-	} param;
-	struct skcipher_walk walk;
+	} __packed param;
 	unsigned int nbytes, n, k;
-	int rc;
-
-	rc = skcipher_walk_virt(&walk, req, false);
-	if (rc)
-		return rc;
+	int pk_state, rc;
 
+	/* fetch and check protected key state */
 	spin_lock_bh(&ctx->pk_lock);
+	pk_state = ctx->pk_state;
 	memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
 	spin_unlock_bh(&ctx->pk_lock);
+	switch (pk_state) {
+	case PK_STATE_NO_KEY:
+		rc = -ENOKEY;
+		goto out;
+	case PK_STATE_CONVERT_IN_PROGRESS:
+		rc = -EKEYEXPIRED;
+		goto out;
+	case PK_STATE_VALID:
+		break;
+	default:
+		rc = pk_state < 0 ? pk_state : -EIO;
+		goto out;
+	}
+
+	/* setkey() should have updated the function code */
+	if (!ctx->fc) {
+		/* setkey is still in progress */
+		rc = -EINPROGRESS;
+		goto out;
+	} else if (ctx->fc < 0) {
+		/* setkey was unable to identify the fc from prot key type */
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = 0;
 
-	while ((nbytes = walk.nbytes) != 0) {
+	/* always walk on the ... */
+	while ((nbytes = walk->nbytes) != 0) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		k = cpacf_km(ctx->fc | modifier, &param,
-			     walk.dst.virt.addr, walk.src.virt.addr, n);
+			     walk->dst.virt.addr, walk->src.virt.addr, n);
 		if (k)
-			rc = skcipher_walk_done(&walk, nbytes - k);
+			rc = skcipher_walk_done(walk, nbytes - k);
 		if (k < n) {
-			if (__paes_convert_key(ctx))
-				return skcipher_walk_done(&walk, -EIO);
+			if (!maysleep) {
+				rc = skcipher_walk_done(walk, -EKEYEXPIRED);
+				goto out;
+			}
+			rc = paes_convert_key(ctx);
+			if (rc) {
+				skcipher_walk_done(walk, rc);
+				goto out;
+			}
 			spin_lock_bh(&ctx->pk_lock);
 			memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
 			spin_unlock_bh(&ctx->pk_lock);
 		}
 	}
+
+out:
+	memzero_explicit(param.key, sizeof(param.key));
+	pr_debug("rc=%d\n", rc);
+	return rc;
+}
+
+static void ecb_paes_wq_crypt_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct s390_paes_req_ctx *req_ctx =
+		container_of(dwork, struct s390_paes_req_ctx, work);
+	struct skcipher_request *req = req_ctx->req;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	int rc;
+
+	rc = skcipher_walk_virt(&walk, req, false);
+	if (rc)
+		goto complete;
+
+	rc = ecb_paes_do_crypt(ctx, &walk, req_ctx->modifier, true);
+	if (rc != -EKEYEXPIRED && rc != -EINPROGRESS)
+		goto complete;
+
+	/*
+	 * Protected key expired, conversion is in process.
+	 * Re-schedule this request with a short delay.
+	 */
+	pr_debug("rescheduling request\n");
+	INIT_DELAYED_WORK(&req_ctx->work, ecb_paes_wq_crypt_fn);
+	queue_delayed_work(paes_wq, &req_ctx->work, PAES_RESCHEDULE_DELAY);
+	return;
+
+complete:
+	pr_debug("request complete with rc=%d\n", rc);
+	local_bh_disable();
+	skcipher_request_complete(req, rc);
+	local_bh_enable();
+}
+
+static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
+{
+	struct s390_paes_req_ctx *req_ctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	int rc;
+
+	/*
+	 * First try synchronous. If this fails for any reason
+	 * schedule this request asynchronous via workqueue.
+	 */
+
+	rc = skcipher_walk_virt(&walk, req, false);
+	if (rc)
+		goto out;
+
+	rc = ecb_paes_do_crypt(ctx, &walk, modifier, false);
+	if (rc != -EKEYEXPIRED && rc != -EINPROGRESS)
+		goto out;
+
+	req_ctx->req = req;
+	req_ctx->modifier = modifier;
+	INIT_DELAYED_WORK(&req_ctx->work, ecb_paes_wq_crypt_fn);
+	queue_delayed_work(paes_wq, &req_ctx->work, 0);
+	rc = -EINPROGRESS;
+
+out:
+	pr_debug("rc=%d\n", rc);
 	return rc;
 }
 
@@ -310,6 +513,29 @@ static int ecb_paes_decrypt(struct skcipher_request *req)
 	return ecb_paes_crypt(req, CPACF_DECRYPT);
 }
 
+static int ecb_paes_init(struct crypto_skcipher *tfm)
+{
+	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	spin_lock_init(&ctx->pk_lock);
+
+	INIT_WORK(&ctx->work, ecb_paes_wq_setkey_fn);
+
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct s390_paes_req_ctx));
+
+	return 0;
+}
+
+static void ecb_paes_exit(struct crypto_skcipher *tfm)
+{
+	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	flush_work(&ctx->work);
+
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
 static struct skcipher_alg ecb_paes_alg = {
 	.base.cra_name		=	"ecb(paes)",
 	.base.cra_driver_name	=	"ecb-paes-s390",
@@ -322,100 +548,195 @@ static struct skcipher_alg ecb_paes_alg = {
 	.exit			=	ecb_paes_exit,
 	.min_keysize		=	PAES_MIN_KEYSIZE,
 	.max_keysize		=	PAES_MAX_KEYSIZE,
-	.setkey			=	ecb_paes_set_key,
+	.setkey			=	ecb_paes_setkey,
 	.encrypt		=	ecb_paes_encrypt,
 	.decrypt		=	ecb_paes_decrypt,
 };
 
-static int cbc_paes_init(struct crypto_skcipher *tfm)
-{
-	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	ctx->kb.key = NULL;
-	spin_lock_init(&ctx->pk_lock);
-
-	return 0;
-}
-
-static void cbc_paes_exit(struct crypto_skcipher *tfm)
-{
-	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	_free_kb_keybuf(&ctx->kb);
-}
+/*
+ * PAES CBC implementation
+ */
 
-static inline int __cbc_paes_set_key(struct s390_paes_ctx *ctx)
+static void cbc_paes_wq_setkey_fn(struct work_struct *work)
 {
+	struct s390_paes_ctx *ctx = container_of(work, struct s390_paes_ctx, work);
 	unsigned long fc;
 	int rc;
 
-	rc = __paes_convert_key(ctx);
+	/* convert key into protected key */
+	rc = paes_convert_key(ctx);
 	if (rc)
-		return rc;
+		return;
 
 	/* Pick the correct function code based on the protected key type */
 	fc = (ctx->pk.type == PKEY_KEYTYPE_AES_128) ? CPACF_KMC_PAES_128 :
 		(ctx->pk.type == PKEY_KEYTYPE_AES_192) ? CPACF_KMC_PAES_192 :
 		(ctx->pk.type == PKEY_KEYTYPE_AES_256) ? CPACF_KMC_PAES_256 : 0;
+	fc = (fc && cpacf_test_func(&kmc_functions, fc)) ? fc : 0;
 
-	/* Check if the function code is available */
-	ctx->fc = (fc && cpacf_test_func(&kmc_functions, fc)) ? fc : 0;
-
-	return ctx->fc ? 0 : -EINVAL;
+	/* Update context's function code */
+	ctx->fc = fc ? fc : -EINVAL;
 }
 
-static int cbc_paes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
-			    unsigned int key_len)
+static int cbc_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
+			   unsigned int key_len)
 {
 	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int rc;
 
-	_free_kb_keybuf(&ctx->kb);
-	rc = _key_to_kb(&ctx->kb, in_key, key_len);
+	rc = key_to_ctx(ctx, in_key, key_len);
 	if (rc)
 		return rc;
 
-	return __cbc_paes_set_key(ctx);
+	/* Always trigger an asynch key convert */
+	spin_lock_bh(&ctx->pk_lock);
+	ctx->pk_state = PK_STATE_CONVERT_IN_PROGRESS;
+	spin_unlock_bh(&ctx->pk_lock);
+	queue_work(paes_wq, &ctx->work);
+
+	return 0;
 }
 
-static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
+static int cbc_paes_do_crypt(struct s390_paes_ctx *ctx,
+			     struct skcipher_walk *walk,
+			     unsigned long modifier, bool maysleep)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct {
+	struct cbc_param {
 		u8 iv[AES_BLOCK_SIZE];
 		u8 key[PAES_256_PROTKEY_SIZE];
-	} param;
-	struct skcipher_walk walk;
+	} __packed param;
 	unsigned int nbytes, n, k;
-	int rc;
-
-	rc = skcipher_walk_virt(&walk, req, false);
-	if (rc)
-		return rc;
+	int pk_state, rc;
 
-	memcpy(param.iv, walk.iv, AES_BLOCK_SIZE);
+	/* fetch and check protected key state */
 	spin_lock_bh(&ctx->pk_lock);
+	pk_state = ctx->pk_state;
 	memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
 	spin_unlock_bh(&ctx->pk_lock);
+	switch (pk_state) {
+	case PK_STATE_NO_KEY:
+		rc = -ENOKEY;
+		goto out;
+	case PK_STATE_CONVERT_IN_PROGRESS:
+		rc = -EKEYEXPIRED;
+		goto out;
+	case PK_STATE_VALID:
+		break;
+	default:
+		rc = pk_state < 0 ? pk_state : -EIO;
+		goto out;
+	}
+
+	/* setkey() should have updated the function code */
+	if (!ctx->fc) {
+		/* setkey is still in progress */
+		rc = -EINPROGRESS;
+		goto out;
+	} else if (ctx->fc < 0) {
+		/* setkey was unable to identify the fc from prot key type */
+		rc = -EINVAL;
+		goto out;
+	}
+
+	memcpy(param.iv, walk->iv, AES_BLOCK_SIZE);
+	rc = 0;
 
-	while ((nbytes = walk.nbytes) != 0) {
+	/* always walk on the ... */
+	while ((nbytes = walk->nbytes) != 0) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
 		k = cpacf_kmc(ctx->fc | modifier, &param,
-			      walk.dst.virt.addr, walk.src.virt.addr, n);
+			      walk->dst.virt.addr, walk->src.virt.addr, n);
 		if (k) {
-			memcpy(walk.iv, param.iv, AES_BLOCK_SIZE);
-			rc = skcipher_walk_done(&walk, nbytes - k);
+			memcpy(walk->iv, param.iv, AES_BLOCK_SIZE);
+			rc = skcipher_walk_done(walk, nbytes - k);
 		}
 		if (k < n) {
-			if (__paes_convert_key(ctx))
-				return skcipher_walk_done(&walk, -EIO);
+			if (!maysleep) {
+				rc = skcipher_walk_done(walk, -EKEYEXPIRED);
+				goto out;
+			}
+			rc = paes_convert_key(ctx);
+			if (rc) {
+				skcipher_walk_done(walk, rc);
+				goto out;
+			}
 			spin_lock_bh(&ctx->pk_lock);
 			memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
 			spin_unlock_bh(&ctx->pk_lock);
 		}
 	}
+
+out:
+	memzero_explicit(param.key, sizeof(param.key));
+	pr_debug("rc=%d\n", rc);
+	return rc;
+}
+
+static void cbc_paes_wq_crypt_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct s390_paes_req_ctx *req_ctx =
+		container_of(dwork, struct s390_paes_req_ctx, work);
+	struct skcipher_request *req = req_ctx->req;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	int rc;
+
+	rc = skcipher_walk_virt(&walk, req, false);
+	if (rc)
+		goto complete;
+
+	rc = cbc_paes_do_crypt(ctx, &walk, req_ctx->modifier, true);
+	if (rc != -EKEYEXPIRED && rc != -EINPROGRESS)
+		goto complete;
+
+	/*
+	 * Protected key expired, conversion is in process.
+	 * Re-schedule this request with a short delay.
+	 */
+	pr_debug("rescheduling request\n");
+	INIT_DELAYED_WORK(&req_ctx->work, cbc_paes_wq_crypt_fn);
+	queue_delayed_work(paes_wq, &req_ctx->work, PAES_RESCHEDULE_DELAY);
+	return;
+
+complete:
+	pr_debug("request complete with rc=%d\n", rc);
+	local_bh_disable();
+	skcipher_request_complete(req, rc);
+	local_bh_enable();
+}
+
+static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
+{
+	struct s390_paes_req_ctx *req_ctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	int rc;
+
+	/*
+	 * First try synchronous. If this fails for any reason
+	 * schedule this request asynchronous via workqueue.
+	 */
+
+	rc = skcipher_walk_virt(&walk, req, false);
+	if (rc)
+		goto out;
+
+	rc = cbc_paes_do_crypt(ctx, &walk, modifier, false);
+	if (rc != -EKEYEXPIRED && rc != -EINPROGRESS)
+		goto out;
+
+	req_ctx->req = req;
+	req_ctx->modifier = modifier;
+	INIT_DELAYED_WORK(&req_ctx->work, cbc_paes_wq_crypt_fn);
+	queue_delayed_work(paes_wq, &req_ctx->work, 0);
+	rc = -EINPROGRESS;
+
+out:
+	pr_debug("rc=%d\n", rc);
 	return rc;
 }
 
@@ -429,96 +750,343 @@ static int cbc_paes_decrypt(struct skcipher_request *req)
 	return cbc_paes_crypt(req, CPACF_DECRYPT);
 }
 
-static struct skcipher_alg cbc_paes_alg = {
-	.base.cra_name		=	"cbc(paes)",
-	.base.cra_driver_name	=	"cbc-paes-s390",
-	.base.cra_priority	=	402,	/* ecb-paes-s390 + 1 */
-	.base.cra_blocksize	=	AES_BLOCK_SIZE,
-	.base.cra_ctxsize	=	sizeof(struct s390_paes_ctx),
-	.base.cra_module	=	THIS_MODULE,
-	.base.cra_list		=	LIST_HEAD_INIT(cbc_paes_alg.base.cra_list),
-	.init			=	cbc_paes_init,
+static int cbc_paes_init(struct crypto_skcipher *tfm)
+{
+	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	spin_lock_init(&ctx->pk_lock);
+
+	INIT_WORK(&ctx->work, cbc_paes_wq_setkey_fn);
+
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct s390_paes_req_ctx));
+
+	return 0;
+}
+
+static void cbc_paes_exit(struct crypto_skcipher *tfm)
+{
+	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	flush_work(&ctx->work);
+
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
+static struct skcipher_alg cbc_paes_alg = {
+	.base.cra_name		=	"cbc(paes)",
+	.base.cra_driver_name	=	"cbc-paes-s390",
+	.base.cra_priority	=	402,	/* cbc-paes-s390 + 1 */
+	.base.cra_blocksize	=	AES_BLOCK_SIZE,
+	.base.cra_ctxsize	=	sizeof(struct s390_paes_ctx),
+	.base.cra_module	=	THIS_MODULE,
+	.base.cra_list		=	LIST_HEAD_INIT(cbc_paes_alg.base.cra_list),
+	.init			=	cbc_paes_init,
 	.exit			=	cbc_paes_exit,
 	.min_keysize		=	PAES_MIN_KEYSIZE,
 	.max_keysize		=	PAES_MAX_KEYSIZE,
 	.ivsize			=	AES_BLOCK_SIZE,
-	.setkey			=	cbc_paes_set_key,
+	.setkey			=	cbc_paes_setkey,
 	.encrypt		=	cbc_paes_encrypt,
 	.decrypt		=	cbc_paes_decrypt,
 };
 
-static int xts_paes_init(struct crypto_skcipher *tfm)
+/*
+ * PAES CTR implementation
+ */
+
+static void ctr_paes_wq_setkey_fn(struct work_struct *work)
 {
-	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct s390_paes_ctx *ctx = container_of(work, struct s390_paes_ctx, work);
+	unsigned long fc;
+	int rc;
 
-	ctx->kb.key = NULL;
-	spin_lock_init(&ctx->pk_lock);
+	/* convert key into protected key */
+	rc = paes_convert_key(ctx);
+	if (rc)
+		return;
+
+	/* Pick the correct function code based on the protected key type */
+	fc = (ctx->pk.type == PKEY_KEYTYPE_AES_128) ? CPACF_KMCTR_PAES_128 :
+		(ctx->pk.type == PKEY_KEYTYPE_AES_192) ? CPACF_KMCTR_PAES_192 :
+		(ctx->pk.type == PKEY_KEYTYPE_AES_256) ? CPACF_KMCTR_PAES_256 : 0;
+	fc = (fc && cpacf_test_func(&kmctr_functions, fc)) ? fc : 0;
+
+	/* Update context's function code */
+	ctx->fc = fc ? fc : -EINVAL;
+}
+
+static int ctr_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
+			   unsigned int key_len)
+{
+	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int rc;
+
+	rc = key_to_ctx(ctx, in_key, key_len);
+	if (rc)
+		return rc;
+
+	/* Always trigger an asynch key convert */
+	spin_lock_bh(&ctx->pk_lock);
+	ctx->pk_state = PK_STATE_CONVERT_IN_PROGRESS;
+	spin_unlock_bh(&ctx->pk_lock);
+	queue_work(paes_wq, &ctx->work);
 
 	return 0;
 }
 
-static void xts_paes_exit(struct crypto_skcipher *tfm)
+static inline unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes)
 {
-	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	unsigned int i, n;
 
-	_free_kb_keybuf(&ctx->kb);
+	/* only use complete blocks, max. PAGE_SIZE */
+	memcpy(ctrptr, iv, AES_BLOCK_SIZE);
+	n = (nbytes > PAGE_SIZE) ? PAGE_SIZE : nbytes & ~(AES_BLOCK_SIZE - 1);
+	for (i = (n / AES_BLOCK_SIZE) - 1; i > 0; i--) {
+		memcpy(ctrptr + AES_BLOCK_SIZE, ctrptr, AES_BLOCK_SIZE);
+		crypto_inc(ctrptr + AES_BLOCK_SIZE, AES_BLOCK_SIZE);
+		ctrptr += AES_BLOCK_SIZE;
+	}
+	return n;
 }
 
-static inline int __xts_paes_convert_key(struct s390_pxts_ctx *ctx)
+static int ctr_paes_do_crypt(struct s390_paes_ctx *ctx,
+			     struct skcipher_walk *walk,
+			     bool maysleep)
 {
-	struct paes_protkey pk0, pk1;
-	size_t split_keylen;
+	struct ctr_param {
+		u8 key[PAES_256_PROTKEY_SIZE];
+	} __packed param;
+	u8 buf[AES_BLOCK_SIZE], *ctrptr;
+	unsigned int nbytes, n, k;
+	int pk_state, locked, rc;
+
+	/* fetch and check protected key state */
+	spin_lock_bh(&ctx->pk_lock);
+	pk_state = ctx->pk_state;
+	memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
+	spin_unlock_bh(&ctx->pk_lock);
+	switch (pk_state) {
+	case PK_STATE_NO_KEY:
+		rc = -ENOKEY;
+		goto out;
+	case PK_STATE_CONVERT_IN_PROGRESS:
+		rc = -EKEYEXPIRED;
+		goto out;
+	case PK_STATE_VALID:
+		break;
+	default:
+		rc = pk_state < 0 ? pk_state : -EIO;
+		goto out;
+	}
+
+	/* setkey() should have updated the function code */
+	if (!ctx->fc) {
+		/* setkey is still in progress */
+		rc = -EINPROGRESS;
+		goto out;
+	} else if (ctx->fc < 0) {
+		/* setkey was unable to identify the fc from prot key type */
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = 0;
+	locked = mutex_trylock(&ctrblk_lock);
+
+	/* always walk on the ... */
+	while ((nbytes = walk->nbytes) >= AES_BLOCK_SIZE) {
+		n = AES_BLOCK_SIZE;
+		if (nbytes >= 2 * AES_BLOCK_SIZE && locked)
+			n = __ctrblk_init(ctrblk, walk->iv, nbytes);
+		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk->iv;
+		k = cpacf_kmctr(ctx->fc, &param, walk->dst.virt.addr,
+				walk->src.virt.addr, n, ctrptr);
+		if (k) {
+			if (ctrptr == ctrblk)
+				memcpy(walk->iv, ctrptr + k - AES_BLOCK_SIZE,
+				       AES_BLOCK_SIZE);
+			crypto_inc(walk->iv, AES_BLOCK_SIZE);
+			rc = skcipher_walk_done(walk, nbytes - k);
+		}
+		if (k < n) {
+			if (!maysleep) {
+				if (locked)
+					mutex_unlock(&ctrblk_lock);
+				rc = skcipher_walk_done(walk, -EKEYEXPIRED);
+				goto out;
+			}
+			rc = paes_convert_key(ctx);
+			if (rc) {
+				if (locked)
+					mutex_unlock(&ctrblk_lock);
+				skcipher_walk_done(walk, rc);
+				goto out;
+			}
+			spin_lock_bh(&ctx->pk_lock);
+			memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
+			spin_unlock_bh(&ctx->pk_lock);
+		}
+	}
+	if (locked)
+		mutex_unlock(&ctrblk_lock);
+
+	/* final block may be < AES_BLOCK_SIZE, copy only nbytes */
+	if (nbytes) {
+		memset(buf, 0, AES_BLOCK_SIZE);
+		memcpy(buf, walk->src.virt.addr, nbytes);
+		while (1) {
+			if (cpacf_kmctr(ctx->fc, &param, buf,
+					buf, AES_BLOCK_SIZE,
+					walk->iv) == AES_BLOCK_SIZE)
+				break;
+			if (!maysleep) {
+				rc = skcipher_walk_done(walk, -EKEYEXPIRED);
+				goto out;
+			}
+			rc = paes_convert_key(ctx);
+			if (rc) {
+				skcipher_walk_done(walk, rc);
+				goto out;
+			}
+			spin_lock_bh(&ctx->pk_lock);
+			memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
+			spin_unlock_bh(&ctx->pk_lock);
+		}
+		memcpy(walk->dst.virt.addr, buf, nbytes);
+		crypto_inc(walk->iv, AES_BLOCK_SIZE);
+		rc = skcipher_walk_done(walk, nbytes);
+	}
+
+out:
+	memzero_explicit(param.key, sizeof(param.key));
+	pr_debug("rc=%d\n", rc);
+	return rc;
+}
+
+static void ctr_paes_wq_crypt_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct s390_paes_req_ctx *req_ctx =
+		container_of(dwork, struct s390_paes_req_ctx, work);
+	struct skcipher_request *req = req_ctx->req;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
 	int rc;
 
-	pk0.len = sizeof(pk0.protkey);
-	pk1.len = sizeof(pk1.protkey);
+	rc = skcipher_walk_virt(&walk, req, false);
+	if (rc)
+		goto complete;
+
+	rc = ctr_paes_do_crypt(ctx, &walk, true);
+	if (rc != -EKEYEXPIRED && rc != -EINPROGRESS)
+		goto complete;
 
-	rc = __paes_keyblob2pkey(ctx->kb.key, ctx->kb.keylen, &pk0);
+	/*
+	 * Protected key expired, conversion is in process.
+	 * Re-schedule this request with a short delay.
+	 */
+	pr_debug("rescheduling request\n");
+	INIT_DELAYED_WORK(&req_ctx->work, ctr_paes_wq_crypt_fn);
+	queue_delayed_work(paes_wq, &req_ctx->work, PAES_RESCHEDULE_DELAY);
+	return;
+
+complete:
+	pr_debug("request complete with rc=%d\n", rc);
+	local_bh_disable();
+	skcipher_request_complete(req, rc);
+	local_bh_enable();
+}
+
+static int ctr_paes_crypt(struct skcipher_request *req)
+{
+	struct s390_paes_req_ctx *req_ctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	int rc;
+
+	/*
+	 * First try synchronous. If this fails for any reason
+	 * schedule this request asynchronous via workqueue.
+	 */
+
+	rc = skcipher_walk_virt(&walk, req, false);
 	if (rc)
-		return rc;
+		goto out;
 
-	switch (pk0.type) {
-	case PKEY_KEYTYPE_AES_128:
-	case PKEY_KEYTYPE_AES_256:
-		/* second keytoken required */
-		if (ctx->kb.keylen % 2)
-			return -EINVAL;
-		split_keylen = ctx->kb.keylen / 2;
+	rc = ctr_paes_do_crypt(ctx, &walk, false);
+	if (rc != -EKEYEXPIRED && rc != -EINPROGRESS)
+		goto out;
 
-		rc = __paes_keyblob2pkey(ctx->kb.key + split_keylen,
-					 split_keylen, &pk1);
-		if (rc)
-			return rc;
+	req_ctx->req = req;
+	INIT_DELAYED_WORK(&req_ctx->work, ctr_paes_wq_crypt_fn);
+	queue_delayed_work(paes_wq, &req_ctx->work, 0);
+	rc = -EINPROGRESS;
 
-		if (pk0.type != pk1.type)
-			return -EINVAL;
-		break;
-	case PKEY_KEYTYPE_AES_XTS_128:
-	case PKEY_KEYTYPE_AES_XTS_256:
-		/* single key */
-		pk1.type = 0;
-		break;
-	default:
-		/* unsupported protected keytype */
-		return -EINVAL;
-	}
+out:
+	pr_debug("rc=%d\n", rc);
+	return rc;
+}
 
-	spin_lock_bh(&ctx->pk_lock);
-	ctx->pk[0] = pk0;
-	ctx->pk[1] = pk1;
-	spin_unlock_bh(&ctx->pk_lock);
+static int ctr_paes_init(struct crypto_skcipher *tfm)
+{
+	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	memset(ctx, 0, sizeof(*ctx));
+	spin_lock_init(&ctx->pk_lock);
+
+	INIT_WORK(&ctx->work, ctr_paes_wq_setkey_fn);
+
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct s390_paes_req_ctx));
 
 	return 0;
 }
 
-static inline int __xts_paes_set_key(struct s390_pxts_ctx *ctx)
+static void ctr_paes_exit(struct crypto_skcipher *tfm)
+{
+	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	flush_work(&ctx->work);
+
+	memzero_explicit(ctx, sizeof(*ctx));
+}
+
+static struct skcipher_alg ctr_paes_alg = {
+	.base.cra_name		=	"ctr(paes)",
+	.base.cra_driver_name	=	"ctr-paes-s390",
+	.base.cra_priority	=	402,	/* ecb-paes-s390 + 1 */
+	.base.cra_blocksize	=	1,
+	.base.cra_ctxsize	=	sizeof(struct s390_paes_ctx),
+	.base.cra_module	=	THIS_MODULE,
+	.base.cra_list		=	LIST_HEAD_INIT(ctr_paes_alg.base.cra_list),
+	.init			=	ctr_paes_init,
+	.exit			=	ctr_paes_exit,
+	.min_keysize		=	PAES_MIN_KEYSIZE,
+	.max_keysize		=	PAES_MAX_KEYSIZE,
+	.ivsize			=	AES_BLOCK_SIZE,
+	.setkey			=	ctr_paes_setkey,
+	.encrypt		=	ctr_paes_crypt,
+	.decrypt		=	ctr_paes_crypt,
+	.chunksize		=	AES_BLOCK_SIZE,
+};
+
+/*
+ * PAES XTS implementation
+ */
+
+static void xts_paes_wq_setkey_fn(struct work_struct *work)
 {
+	struct s390_pxts_ctx *ctx = container_of(work, struct s390_pxts_ctx, work);
+	unsigned int pklen;
 	unsigned long fc;
 	int rc;
 
-	rc = __xts_paes_convert_key(ctx);
+	/* convert key into protected key */
+	rc = pxts_convert_key(ctx);
 	if (rc)
-		return rc;
+		return;
 
 	/* Pick the correct function code based on the protected key type */
 	switch (ctx->pk[0].type) {
@@ -538,367 +1106,340 @@ static inline int __xts_paes_set_key(struct s390_pxts_ctx *ctx)
 		fc = 0;
 		break;
 	}
+	fc = (fc && cpacf_test_func(&km_functions, fc)) ? fc : 0;
 
-	/* Check if the function code is available */
-	ctx->fc = (fc && cpacf_test_func(&km_functions, fc)) ? fc : 0;
+	/*
+	 * try to do some checks on the key. For the full xts keys
+	 * there is no chance to check for k1 and k2 are the same.
+	 * We can't use xts_verify_key because there is no tfm here.
+	 * But we can still check that the two keys are not the
+	 * same - this works even on the encrypted protected keys.
+	 * In non-fips mode some selftests have same key for k1 and k2.
+	 */
+	if (fips_enabled &&
+	    (ctx->pk[0].type == PKEY_KEYTYPE_AES_128 ||
+	     ctx->pk[0].type == PKEY_KEYTYPE_AES_256)) {
+		pklen = (ctx->pk[0].type == PKEY_KEYTYPE_AES_128) ?
+			AES_KEYSIZE_128 : AES_KEYSIZE_256;
+		if (!crypto_memneq(ctx->pk[0].protkey,
+				   ctx->pk[1].protkey, pklen))
+			fc = 0;
+	}
 
-	return ctx->fc ? 0 : -EINVAL;
+	/* Update context's function code */
+	ctx->fc = fc ? fc : -EINVAL;
 }
 
-static int xts_paes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
-			    unsigned int in_keylen)
+static int xts_paes_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
+			   unsigned int key_len)
 {
 	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
-	u8 ckey[2 * AES_MAX_KEY_SIZE];
-	unsigned int ckey_len;
 	int rc;
 
-	if ((in_keylen == 32 || in_keylen == 64) &&
-	    xts_verify_key(tfm, in_key, in_keylen))
+	if ((key_len == 32 || key_len == 64) &&
+	    xts_verify_key(tfm, in_key, key_len))
 		return -EINVAL;
 
-	_free_kb_keybuf(&ctx->kb);
-	rc = _xts_key_to_kb(&ctx->kb, in_key, in_keylen);
+	rc = xts_key_to_ctx(ctx, in_key, key_len);
 	if (rc)
 		return rc;
 
-	rc = __xts_paes_set_key(ctx);
-	if (rc)
-		return rc;
+	/* Always trigger an asynch key convert */
+	spin_lock_bh(&ctx->pk_lock);
+	ctx->pk_state = PK_STATE_CONVERT_IN_PROGRESS;
+	spin_unlock_bh(&ctx->pk_lock);
+	queue_work(paes_wq, &ctx->work);
 
-	/*
-	 * It is not possible on a single protected key (e.g. full AES-XTS) to
-	 * check, if k1 and k2 are the same.
-	 */
-	if (ctx->pk[0].type == PKEY_KEYTYPE_AES_XTS_128 ||
-	    ctx->pk[0].type == PKEY_KEYTYPE_AES_XTS_256)
-		return 0;
-	/*
-	 * xts_verify_key verifies the key length is not odd and makes
-	 * sure that the two keys are not the same. This can be done
-	 * on the two protected keys as well
-	 */
-	ckey_len = (ctx->pk[0].type == PKEY_KEYTYPE_AES_128) ?
-		AES_KEYSIZE_128 : AES_KEYSIZE_256;
-	memcpy(ckey, ctx->pk[0].protkey, ckey_len);
-	memcpy(ckey + ckey_len, ctx->pk[1].protkey, ckey_len);
-	return xts_verify_key(tfm, ckey, 2*ckey_len);
+	return 0;
 }
 
-static int paes_xts_crypt_full(struct skcipher_request *req,
-			       unsigned long modifier)
+static int xts_paes_do_crypt_fullkey(struct s390_pxts_ctx *ctx,
+				     struct skcipher_walk *walk,
+				     unsigned long modifier, bool maysleep)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	unsigned int keylen, offset, nbytes, n, k;
-	struct {
+	struct xts_fullkey_param {
 		u8 key[64];
 		u8 tweak[16];
 		u8 nap[16];
 		u8 wkvp[32];
-	} fxts_param = {
-		.nap = {0},
-	};
-	struct skcipher_walk walk;
-	int rc;
-
-	rc = skcipher_walk_virt(&walk, req, false);
-	if (rc)
-		return rc;
+	} __packed param = { .nap = {0}, };
+	int rc = 0;
 
 	keylen = (ctx->pk[0].type == PKEY_KEYTYPE_AES_XTS_128) ? 32 : 64;
 	offset = (ctx->pk[0].type == PKEY_KEYTYPE_AES_XTS_128) ? 32 : 0;
 
 	spin_lock_bh(&ctx->pk_lock);
-	memcpy(fxts_param.key + offset, ctx->pk[0].protkey, keylen);
-	memcpy(fxts_param.wkvp, ctx->pk[0].protkey + keylen,
-	       sizeof(fxts_param.wkvp));
+	memcpy(param.key + offset, ctx->pk[0].protkey, keylen);
+	memcpy(param.wkvp, ctx->pk[0].protkey + keylen, sizeof(param.wkvp));
 	spin_unlock_bh(&ctx->pk_lock);
-	memcpy(fxts_param.tweak, walk.iv, sizeof(fxts_param.tweak));
-	fxts_param.nap[0] = 0x01; /* initial alpha power (1, little-endian) */
+	memcpy(param.tweak, walk->iv, sizeof(param.tweak));
+	param.nap[0] = 0x01; /* initial alpha power (1, little-endian) */
 
-	while ((nbytes = walk.nbytes) != 0) {
+	/* always walk on the ... */
+	while ((nbytes = walk->nbytes) != 0) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
-		k = cpacf_km(ctx->fc | modifier, fxts_param.key + offset,
-			     walk.dst.virt.addr, walk.src.virt.addr, n);
+		k = cpacf_km(ctx->fc | modifier, param.key + offset,
+			     walk->dst.virt.addr, walk->src.virt.addr, n);
 		if (k)
-			rc = skcipher_walk_done(&walk, nbytes - k);
+			rc = skcipher_walk_done(walk, nbytes - k);
 		if (k < n) {
-			if (__xts_paes_convert_key(ctx))
-				return skcipher_walk_done(&walk, -EIO);
+			if (!maysleep) {
+				rc = skcipher_walk_done(walk, -EKEYEXPIRED);
+				goto out;
+			}
+			rc = pxts_convert_key(ctx);
+			if (rc) {
+				skcipher_walk_done(walk, rc);
+				goto out;
+			}
 			spin_lock_bh(&ctx->pk_lock);
-			memcpy(fxts_param.key + offset, ctx->pk[0].protkey,
-			       keylen);
-			memcpy(fxts_param.wkvp, ctx->pk[0].protkey + keylen,
-			       sizeof(fxts_param.wkvp));
+			memcpy(param.key + offset, ctx->pk[0].protkey, keylen);
+			memcpy(param.wkvp, ctx->pk[0].protkey + keylen, sizeof(param.wkvp));
 			spin_unlock_bh(&ctx->pk_lock);
 		}
 	}
 
+out:
+	memzero_explicit(param.key, sizeof(param.key));
+	pr_debug("rc=%d\n", rc);
 	return rc;
 }
 
-static int paes_xts_crypt(struct skcipher_request *req, unsigned long modifier)
+static int xts_paes_do_crypt_2keys(struct s390_pxts_ctx *ctx,
+				   struct skcipher_walk *walk,
+				   unsigned long modifier, bool maysleep)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
 	unsigned int keylen, offset, nbytes, n, k;
-	struct {
+	struct xts_2keys_pcc_param {
 		u8 key[PAES_256_PROTKEY_SIZE];
 		u8 tweak[16];
 		u8 block[16];
 		u8 bit[16];
 		u8 xts[16];
-	} pcc_param;
-	struct {
+	} __packed pcc_param;
+	struct xts_2keys_km_param {
 		u8 key[PAES_256_PROTKEY_SIZE];
 		u8 init[16];
-	} xts_param;
-	struct skcipher_walk walk;
-	int rc;
-
-	rc = skcipher_walk_virt(&walk, req, false);
-	if (rc)
-		return rc;
+	} __packed km_param;
+	int rc = 0;
 
 	keylen = (ctx->pk[0].type == PKEY_KEYTYPE_AES_128) ? 48 : 64;
 	offset = (ctx->pk[0].type == PKEY_KEYTYPE_AES_128) ? 16 : 0;
 
 	memset(&pcc_param, 0, sizeof(pcc_param));
-	memcpy(pcc_param.tweak, walk.iv, sizeof(pcc_param.tweak));
+	memcpy(pcc_param.tweak, walk->iv, sizeof(pcc_param.tweak));
 	spin_lock_bh(&ctx->pk_lock);
 	memcpy(pcc_param.key + offset, ctx->pk[1].protkey, keylen);
-	memcpy(xts_param.key + offset, ctx->pk[0].protkey, keylen);
+	memcpy(km_param.key + offset, ctx->pk[0].protkey, keylen);
 	spin_unlock_bh(&ctx->pk_lock);
 	cpacf_pcc(ctx->fc, pcc_param.key + offset);
-	memcpy(xts_param.init, pcc_param.xts, 16);
+	memcpy(km_param.init, pcc_param.xts, 16);
 
-	while ((nbytes = walk.nbytes) != 0) {
+	/* always walk on the ... */
+	while ((nbytes = walk->nbytes) != 0) {
 		/* only use complete blocks */
 		n = nbytes & ~(AES_BLOCK_SIZE - 1);
-		k = cpacf_km(ctx->fc | modifier, xts_param.key + offset,
-			     walk.dst.virt.addr, walk.src.virt.addr, n);
+		k = cpacf_km(ctx->fc | modifier, km_param.key + offset,
+			     walk->dst.virt.addr, walk->src.virt.addr, n);
 		if (k)
-			rc = skcipher_walk_done(&walk, nbytes - k);
+			rc = skcipher_walk_done(walk, nbytes - k);
 		if (k < n) {
-			if (__xts_paes_convert_key(ctx))
-				return skcipher_walk_done(&walk, -EIO);
+			if (!maysleep) {
+				rc = skcipher_walk_done(walk, -EKEYEXPIRED);
+				goto out;
+			}
+			rc = pxts_convert_key(ctx);
+			if (rc) {
+				skcipher_walk_done(walk, rc);
+				goto out;
+			}
 			spin_lock_bh(&ctx->pk_lock);
-			memcpy(xts_param.key + offset,
-			       ctx->pk[0].protkey, keylen);
+			memcpy(km_param.key + offset, ctx->pk[0].protkey, keylen);
 			spin_unlock_bh(&ctx->pk_lock);
 		}
 	}
 
+out:
+	memzero_explicit(pcc_param.key, sizeof(pcc_param.key));
+	memzero_explicit(km_param.key, sizeof(km_param.key));
+	pr_debug("rc=%d\n", rc);
 	return rc;
 }
 
-static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long modifier)
+static int xts_paes_do_crypt(struct s390_pxts_ctx *ctx,
+			     struct skcipher_walk *walk,
+			     unsigned long modifier, bool maysleep)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int pk_state, rc;
 
+	/* fetch and check protected key state */
+	spin_lock_bh(&ctx->pk_lock);
+	pk_state = ctx->pk_state;
+	spin_unlock_bh(&ctx->pk_lock);
+	switch (pk_state) {
+	case PK_STATE_NO_KEY:
+		rc = -ENOKEY;
+		goto out;
+	case PK_STATE_CONVERT_IN_PROGRESS:
+		rc = -EKEYEXPIRED;
+		goto out;
+	case PK_STATE_VALID:
+		break;
+	default:
+		rc = pk_state < 0 ? pk_state : -EIO;
+		goto out;
+	}
+
+	/*
+	 * setkey() should have updated the function code. So call
+	 * the 'real' crypt function based on the xts prot key type.
+	 */
 	switch (ctx->fc) {
 	case CPACF_KM_PXTS_128:
 	case CPACF_KM_PXTS_256:
-		return paes_xts_crypt(req, modifier);
+		rc = xts_paes_do_crypt_2keys(ctx, walk, modifier, maysleep);
+		break;
 	case CPACF_KM_PXTS_128_FULL:
 	case CPACF_KM_PXTS_256_FULL:
-		return paes_xts_crypt_full(req, modifier);
+		rc = xts_paes_do_crypt_fullkey(ctx, walk, modifier, maysleep);
+		break;
+	case 0:
+		/* setkey is still in progress */
+		rc = -EINPROGRESS;
+		break;
 	default:
-		return -EINVAL;
+		rc = -EINVAL;
 	}
-}
 
-static int xts_paes_encrypt(struct skcipher_request *req)
-{
-	return xts_paes_crypt(req, 0);
+out:
+	pr_debug("rc=%d\n", rc);
+	return rc;
 }
 
-static int xts_paes_decrypt(struct skcipher_request *req)
+static void xts_paes_wq_crypt_fn(struct work_struct *work)
 {
-	return xts_paes_crypt(req, CPACF_DECRYPT);
-}
-
-static struct skcipher_alg xts_paes_alg = {
-	.base.cra_name		=	"xts(paes)",
-	.base.cra_driver_name	=	"xts-paes-s390",
-	.base.cra_priority	=	402,	/* ecb-paes-s390 + 1 */
-	.base.cra_blocksize	=	AES_BLOCK_SIZE,
-	.base.cra_ctxsize	=	sizeof(struct s390_pxts_ctx),
-	.base.cra_module	=	THIS_MODULE,
-	.base.cra_list		=	LIST_HEAD_INIT(xts_paes_alg.base.cra_list),
-	.init			=	xts_paes_init,
-	.exit			=	xts_paes_exit,
-	.min_keysize		=	2 * PAES_MIN_KEYSIZE,
-	.max_keysize		=	2 * PAES_MAX_KEYSIZE,
-	.ivsize			=	AES_BLOCK_SIZE,
-	.setkey			=	xts_paes_set_key,
-	.encrypt		=	xts_paes_encrypt,
-	.decrypt		=	xts_paes_decrypt,
-};
-
-static int ctr_paes_init(struct crypto_skcipher *tfm)
-{
-	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	ctx->kb.key = NULL;
-	spin_lock_init(&ctx->pk_lock);
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct s390_paes_req_ctx *req_ctx =
+		container_of(dwork, struct s390_paes_req_ctx, work);
+	struct skcipher_request *req = req_ctx->req;
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	int rc;
 
-	return 0;
-}
+	rc = skcipher_walk_virt(&walk, req, false);
+	if (rc)
+		goto complete;
 
-static void ctr_paes_exit(struct crypto_skcipher *tfm)
-{
-	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
+	rc = xts_paes_do_crypt(ctx, &walk, req_ctx->modifier, true);
+	if (rc != -EKEYEXPIRED && rc != -EINPROGRESS)
+		goto complete;
 
-	_free_kb_keybuf(&ctx->kb);
+	/*
+	 * Protected key expired, conversion is in process.
+	 * Re-schedule this request with a short delay.
+	 */
+	pr_debug("rescheduling request\n");
+	INIT_DELAYED_WORK(&req_ctx->work, xts_paes_wq_crypt_fn);
+	queue_delayed_work(paes_wq, &req_ctx->work, PAES_RESCHEDULE_DELAY);
+	return;
+
+complete:
+	pr_debug("request complete with rc=%d\n", rc);
+	local_bh_disable();
+	skcipher_request_complete(req, rc);
+	local_bh_enable();
 }
 
-static inline int __ctr_paes_set_key(struct s390_paes_ctx *ctx)
+static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 {
-	unsigned long fc;
+	struct s390_paes_req_ctx *req_ctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
 	int rc;
 
-	rc = __paes_convert_key(ctx);
+	/*
+	 * First try synchronous. If this fails for any reason
+	 * schedule this request asynchronous via workqueue.
+	 */
+
+	rc = skcipher_walk_virt(&walk, req, false);
 	if (rc)
-		return rc;
+		goto out;
 
-	/* Pick the correct function code based on the protected key type */
-	fc = (ctx->pk.type == PKEY_KEYTYPE_AES_128) ? CPACF_KMCTR_PAES_128 :
-		(ctx->pk.type == PKEY_KEYTYPE_AES_192) ? CPACF_KMCTR_PAES_192 :
-		(ctx->pk.type == PKEY_KEYTYPE_AES_256) ?
-		CPACF_KMCTR_PAES_256 : 0;
+	rc = xts_paes_do_crypt(ctx, &walk, modifier, false);
+	if (rc != -EKEYEXPIRED && rc != -EINPROGRESS)
+		goto out;
 
-	/* Check if the function code is available */
-	ctx->fc = (fc && cpacf_test_func(&kmctr_functions, fc)) ? fc : 0;
+	req_ctx->req = req;
+	req_ctx->modifier = modifier;
+	INIT_DELAYED_WORK(&req_ctx->work, xts_paes_wq_crypt_fn);
+	queue_delayed_work(paes_wq, &req_ctx->work, 0);
+	rc = -EINPROGRESS;
 
-	return ctx->fc ? 0 : -EINVAL;
+out:
+	pr_debug("rc=%d\n", rc);
+	return rc;
 }
 
-static int ctr_paes_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
-			    unsigned int key_len)
+static int xts_paes_encrypt(struct skcipher_request *req)
 {
-	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int rc;
-
-	_free_kb_keybuf(&ctx->kb);
-	rc = _key_to_kb(&ctx->kb, in_key, key_len);
-	if (rc)
-		return rc;
-
-	return __ctr_paes_set_key(ctx);
+	return xts_paes_crypt(req, 0);
 }
 
-static unsigned int __ctrblk_init(u8 *ctrptr, u8 *iv, unsigned int nbytes)
+static int xts_paes_decrypt(struct skcipher_request *req)
 {
-	unsigned int i, n;
-
-	/* only use complete blocks, max. PAGE_SIZE */
-	memcpy(ctrptr, iv, AES_BLOCK_SIZE);
-	n = (nbytes > PAGE_SIZE) ? PAGE_SIZE : nbytes & ~(AES_BLOCK_SIZE - 1);
-	for (i = (n / AES_BLOCK_SIZE) - 1; i > 0; i--) {
-		memcpy(ctrptr + AES_BLOCK_SIZE, ctrptr, AES_BLOCK_SIZE);
-		crypto_inc(ctrptr + AES_BLOCK_SIZE, AES_BLOCK_SIZE);
-		ctrptr += AES_BLOCK_SIZE;
-	}
-	return n;
+	return xts_paes_crypt(req, CPACF_DECRYPT);
 }
 
-static int ctr_paes_crypt(struct skcipher_request *req)
+static int xts_paes_init(struct crypto_skcipher *tfm)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
-	u8 buf[AES_BLOCK_SIZE], *ctrptr;
-	struct {
-		u8 key[PAES_256_PROTKEY_SIZE];
-	} param;
-	struct skcipher_walk walk;
-	unsigned int nbytes, n, k;
-	int rc, locked;
+	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	rc = skcipher_walk_virt(&walk, req, false);
-	if (rc)
-		return rc;
+	memset(ctx, 0, sizeof(*ctx));
+	spin_lock_init(&ctx->pk_lock);
 
-	spin_lock_bh(&ctx->pk_lock);
-	memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
-	spin_unlock_bh(&ctx->pk_lock);
+	INIT_WORK(&ctx->work, xts_paes_wq_setkey_fn);
 
-	locked = mutex_trylock(&ctrblk_lock);
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct s390_paes_req_ctx));
 
-	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
-		n = AES_BLOCK_SIZE;
-		if (nbytes >= 2*AES_BLOCK_SIZE && locked)
-			n = __ctrblk_init(ctrblk, walk.iv, nbytes);
-		ctrptr = (n > AES_BLOCK_SIZE) ? ctrblk : walk.iv;
-		k = cpacf_kmctr(ctx->fc, &param, walk.dst.virt.addr,
-				walk.src.virt.addr, n, ctrptr);
-		if (k) {
-			if (ctrptr == ctrblk)
-				memcpy(walk.iv, ctrptr + k - AES_BLOCK_SIZE,
-				       AES_BLOCK_SIZE);
-			crypto_inc(walk.iv, AES_BLOCK_SIZE);
-			rc = skcipher_walk_done(&walk, nbytes - k);
-		}
-		if (k < n) {
-			if (__paes_convert_key(ctx)) {
-				if (locked)
-					mutex_unlock(&ctrblk_lock);
-				return skcipher_walk_done(&walk, -EIO);
-			}
-			spin_lock_bh(&ctx->pk_lock);
-			memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
-			spin_unlock_bh(&ctx->pk_lock);
-		}
-	}
-	if (locked)
-		mutex_unlock(&ctrblk_lock);
-	/*
-	 * final block may be < AES_BLOCK_SIZE, copy only nbytes
-	 */
-	if (nbytes) {
-		memset(buf, 0, AES_BLOCK_SIZE);
-		memcpy(buf, walk.src.virt.addr, nbytes);
-		while (1) {
-			if (cpacf_kmctr(ctx->fc, &param, buf,
-					buf, AES_BLOCK_SIZE,
-					walk.iv) == AES_BLOCK_SIZE)
-				break;
-			if (__paes_convert_key(ctx))
-				return skcipher_walk_done(&walk, -EIO);
-			spin_lock_bh(&ctx->pk_lock);
-			memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
-			spin_unlock_bh(&ctx->pk_lock);
-		}
-		memcpy(walk.dst.virt.addr, buf, nbytes);
-		crypto_inc(walk.iv, AES_BLOCK_SIZE);
-		rc = skcipher_walk_done(&walk, nbytes);
-	}
+	return 0;
+}
 
-	return rc;
+static void xts_paes_exit(struct crypto_skcipher *tfm)
+{
+	struct s390_pxts_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	flush_work(&ctx->work);
+
+	memzero_explicit(ctx, sizeof(*ctx));
 }
 
-static struct skcipher_alg ctr_paes_alg = {
-	.base.cra_name		=	"ctr(paes)",
-	.base.cra_driver_name	=	"ctr-paes-s390",
+static struct skcipher_alg xts_paes_alg = {
+	.base.cra_name		=	"xts(paes)",
+	.base.cra_driver_name	=	"xts-paes-s390",
 	.base.cra_priority	=	402,	/* ecb-paes-s390 + 1 */
-	.base.cra_blocksize	=	1,
-	.base.cra_ctxsize	=	sizeof(struct s390_paes_ctx),
+	.base.cra_blocksize	=	AES_BLOCK_SIZE,
+	.base.cra_ctxsize	=	sizeof(struct s390_pxts_ctx),
 	.base.cra_module	=	THIS_MODULE,
-	.base.cra_list		=	LIST_HEAD_INIT(ctr_paes_alg.base.cra_list),
-	.init			=	ctr_paes_init,
-	.exit			=	ctr_paes_exit,
-	.min_keysize		=	PAES_MIN_KEYSIZE,
-	.max_keysize		=	PAES_MAX_KEYSIZE,
+	.base.cra_list		=	LIST_HEAD_INIT(xts_paes_alg.base.cra_list),
+	.init			=	xts_paes_init,
+	.exit			=	xts_paes_exit,
+	.min_keysize		=	2 * PAES_MIN_KEYSIZE,
+	.max_keysize		=	2 * PAES_MAX_KEYSIZE,
 	.ivsize			=	AES_BLOCK_SIZE,
-	.setkey			=	ctr_paes_set_key,
-	.encrypt		=	ctr_paes_crypt,
-	.decrypt		=	ctr_paes_crypt,
-	.chunksize		=	AES_BLOCK_SIZE,
+	.setkey			=	xts_paes_setkey,
+	.encrypt		=	xts_paes_encrypt,
+	.decrypt		=	xts_paes_decrypt,
 };
 
+/*
+ * alg register, unregister, module init, exit
+ */
+
 static inline void __crypto_unregister_skcipher(struct skcipher_alg *alg)
 {
 	if (!list_empty(&alg->base.cra_list))
@@ -912,13 +1453,20 @@ static void paes_s390_fini(void)
 	__crypto_unregister_skcipher(&cbc_paes_alg);
 	__crypto_unregister_skcipher(&ecb_paes_alg);
 	if (ctrblk)
-		free_page((unsigned long) ctrblk);
+		free_page((unsigned long)ctrblk);
+	if (paes_wq)
+		destroy_workqueue(paes_wq);
 }
 
 static int __init paes_s390_init(void)
 {
 	int rc;
 
+	/* create our own paes workqueue */
+	paes_wq = alloc_workqueue("paes", WQ_MEM_RECLAIM, 1);
+	if (!paes_wq)
+		return -ENOMEM;
+
 	/* Query available functions for KM, KMC and KMCTR */
 	cpacf_query(CPACF_KM, &km_functions);
 	cpacf_query(CPACF_KMC, &kmc_functions);
@@ -950,7 +1498,7 @@ static int __init paes_s390_init(void)
 	if (cpacf_test_func(&kmctr_functions, CPACF_KMCTR_PAES_128) ||
 	    cpacf_test_func(&kmctr_functions, CPACF_KMCTR_PAES_192) ||
 	    cpacf_test_func(&kmctr_functions, CPACF_KMCTR_PAES_256)) {
-		ctrblk = (u8 *) __get_free_page(GFP_KERNEL);
+		ctrblk = (u8 *)__get_free_page(GFP_KERNEL);
 		if (!ctrblk) {
 			rc = -ENOMEM;
 			goto out_err;
-- 
2.43.0

