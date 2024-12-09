Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC600BA3D;
	Mon,  9 Dec 2024 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733762074; cv=none; b=Rjo1WcVb0xnh4plLHShjkW6eUawFRlYvwqeHbDsIDIwu9x/OzvA/ELnX+bxrIZsypjzEWisSvqMWg4Jd3zksGPSr59jYMWI4WUUE+ddryHxBJICP5b4Iv38yubnWy+AEtnKIsUggUuMvpArzyhE6jDQDx0I/pnI7JwQuR1aiICs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733762074; c=relaxed/simple;
	bh=fXI2LuWC1gNbeVxZxnNM/7x3yRmgNP4NFzeBsFiNM8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vENPjaC/hUad/fpg1KCYzNX5a2dXtVE8iHlxJabglWa1ze7i+OO2/wTJVaAvvp1XUpjSkNLAtSvBockAGNOkYo2ZDY1GoPccN/i5xmF6GHMTOlJ2Wqdp3mfNVFr355psqW3m8Cjh42CgaglbmUzEd8dKYWoze06wZ4h/MFhRm50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f0ZKtZXM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f0ZKtZXM"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B9CAHcU031519;
	Mon, 9 Dec 2024 16:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=KH+2RmNJpM7TdQWtK
	IrY5db7T6xmpgo9w2Om1MWW9cE=; b=f0ZKtZXMOY0gLnoKhTCjXKt666Jkh//u3
	63PipLBUWomso0gxcVfawYV19tQP3VKS2pA9Iz+lsPfb0Htp2uRgqbgRJsN8ecXE
	dNNiwjmRoxrqkoRhyYytVcfz1wH3ALYX0Fo5Ni60GB4emAq9UzmekcBUVq0BzTTr
	/4OA735HRIpMcEM3DdJmfdyS8ZYNPWmUL3cjPmzYKqq4QyJ58GaFVPASjQykzT/Y
	Gf3JeAVKTYc/9HWZbr83dtLmy2mS0MT6ZfemGwIOdZChPrRfTLtA2gP557pg2BTS
	CkS5mqX/DY9P83M9RpIlnAIu2N0Ex35UZ+mJf6mTMqODU8Dq6QF9A==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ce1vje1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 16:29:27 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4B9G16gV023029;
	Mon, 9 Dec 2024 16:29:16 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43d2wjq6bk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Dec 2024 16:29:15 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4B9GTBoP34931112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Dec 2024 16:29:11 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3EAD42004F;
	Mon,  9 Dec 2024 16:29:11 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB4A82005A;
	Mon,  9 Dec 2024 16:29:10 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.179.3.73])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Dec 2024 16:29:10 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net, dengler@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v7 2/2] s390/crypto: New s390 specific protected key hash phmac
Date: Mon,  9 Dec 2024 17:29:09 +0100
Message-ID: <20241209162909.758753-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241209162909.758753-1-freude@linux.ibm.com>
References: <20241209162909.758753-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mgBxNgMsU8EG5VwTet5jup_IGfrWx8xq
X-Proofpoint-ORIG-GUID: mgBxNgMsU8EG5VwTet5jup_IGfrWx8xq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412090128

Add support for protected key hmac ("phmac") for s390 arch.

With the latest machine generation there is now support for
protected key (that is a key wrapped by a master key stored
in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
for the s390 specific CPACF instruction kmac.

This patch adds support via 4 new ahashes registered as
phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).

Please note that as of now, there is no selftest enabled for
these hashes, but the implementation has been tested with
testcases via AF_ALG interface.

Co-developed-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 arch/s390/configs/debug_defconfig |   1 +
 arch/s390/configs/defconfig       |   1 +
 arch/s390/crypto/Makefile         |   1 +
 arch/s390/crypto/phmac_s390.c     | 754 ++++++++++++++++++++++++++++++
 drivers/crypto/Kconfig            |  12 +
 5 files changed, 769 insertions(+)
 create mode 100644 arch/s390/crypto/phmac_s390.c

diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index d8d227ab82de..c857618087fe 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -813,6 +813,7 @@ CONFIG_PKEY_EP11=m
 CONFIG_PKEY_PCKMO=m
 CONFIG_PKEY_UV=m
 CONFIG_CRYPTO_PAES_S390=m
+CONFIG_CRYPTO_PHMAC_S390=m
 CONFIG_CRYPTO_DEV_VIRTIO=m
 CONFIG_SYSTEM_BLACKLIST_KEYRING=y
 CONFIG_CORDIC=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 6c2f2bb4fbf8..94bde39967a5 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -800,6 +800,7 @@ CONFIG_PKEY_EP11=m
 CONFIG_PKEY_PCKMO=m
 CONFIG_PKEY_UV=m
 CONFIG_CRYPTO_PAES_S390=m
+CONFIG_CRYPTO_PHMAC_S390=m
 CONFIG_CRYPTO_DEV_VIRTIO=m
 CONFIG_SYSTEM_BLACKLIST_KEYRING=y
 CONFIG_CORDIC=m
diff --git a/arch/s390/crypto/Makefile b/arch/s390/crypto/Makefile
index a0cb96937c3d..47637140b95c 100644
--- a/arch/s390/crypto/Makefile
+++ b/arch/s390/crypto/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_S390_PRNG) += prng.o
 obj-$(CONFIG_CRYPTO_GHASH_S390) += ghash_s390.o
 obj-$(CONFIG_CRYPTO_CRC32_S390) += crc32-vx_s390.o
 obj-$(CONFIG_CRYPTO_HMAC_S390) += hmac_s390.o
+obj-$(CONFIG_CRYPTO_PHMAC_S390) += phmac_s390.o
 obj-y += arch_random.o
 
 crc32-vx_s390-y := crc32-vx.o crc32le-vx.o crc32be-vx.o
diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
new file mode 100644
index 000000000000..aecc0b609451
--- /dev/null
+++ b/arch/s390/crypto/phmac_s390.c
@@ -0,0 +1,754 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright IBM Corp. 2024
+ *
+ * s390 specific HMAC support for protected keys.
+ */
+
+#define KMSG_COMPONENT	"phmac_s390"
+#define pr_fmt(fmt)	KMSG_COMPONENT ": " fmt
+
+#include <asm/cpacf.h>
+#include <asm/pkey.h>
+#include <crypto/cryptd.h>
+#include <crypto/internal/hash.h>
+#include <crypto/sha2.h>
+#include <linux/cpufeature.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+
+/*
+ * KMAC param block layout for sha2 function codes:
+ * The layout of the param block for the KMAC instruction depends on the
+ * blocksize of the used hashing sha2-algorithm function codes. The param block
+ * contains the hash chaining value (cv), the input message bit-length (imbl)
+ * and the hmac-secret (key). To prevent code duplication, the sizes of all
+ * these are calculated based on the blocksize.
+ *
+ * param-block:
+ * +-------+
+ * | cv    |
+ * +-------+
+ * | imbl  |
+ * +-------+
+ * | key   |
+ * +-------+
+ *
+ * sizes:
+ * part | sh2-alg | calculation | size | type
+ * -----+---------+-------------+------+--------
+ * cv   | 224/256 | blocksize/2 |   32 |  u64[8]
+ *      | 384/512 |             |   64 | u128[8]
+ * imbl | 224/256 | blocksize/8 |    8 |     u64
+ *      | 384/512 |             |   16 |    u128
+ * key  | 224/256 | blocksize   |   96 |  u8[96]
+ *      | 384/512 |             |  160 | u8[160]
+ */
+
+#define MAX_DIGEST_SIZE		SHA512_DIGEST_SIZE
+#define MAX_IMBL_SIZE		sizeof(u128)
+#define MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
+
+#define SHA2_CV_SIZE(bs)	((bs) >> 1)
+#define SHA2_IMBL_SIZE(bs)	((bs) >> 3)
+
+#define SHA2_IMBL_OFFSET(bs)	(SHA2_CV_SIZE(bs))
+#define SHA2_KEY_OFFSET(bs)	(SHA2_CV_SIZE(bs) + SHA2_IMBL_SIZE(bs))
+
+#define PHMAC_SHA256_KEY_SIZE	(SHA256_BLOCK_SIZE + 32)
+#define PHMAC_SHA512_KEY_SIZE	(SHA512_BLOCK_SIZE + 32)
+#define PHMAC_MAX_KEY_SIZE	PHMAC_SHA512_KEY_SIZE
+
+struct phmac_protkey {
+	u32 type;
+	u32 len;
+	u8 protkey[PHMAC_MAX_KEY_SIZE];
+};
+
+#define PK_STATE_NO_KEY		     0
+#define PK_STATE_NEEDS_CONVERT	     1
+#define PK_STATE_CONVERT_IN_PROGRESS 2
+#define PK_STATE_VALID		     3
+
+struct s390_phmac_ctx {
+	u8 *key;
+	unsigned int keylen;
+
+	/* the work struct for asynch key convert */
+	struct delayed_work work;
+
+	/* spinlock to atomic read/update the following fields */
+	spinlock_t pk_lock;
+	/* see PK_STATE* defines above, < 0 holds convert failure rc  */
+	int pk_state;
+	/* if state is valid, pk holds the protected key */
+	struct phmac_protkey pk;
+};
+
+union s390_kmac_gr0 {
+	unsigned long reg;
+	struct {
+		unsigned long		: 48;
+		unsigned long ikp	:  1;
+		unsigned long iimp	:  1;
+		unsigned long ccup	:  1;
+		unsigned long		:  6;
+		unsigned long fc	:  7;
+	};
+};
+
+struct s390_kmac_sha2_ctx {
+	u8 param[MAX_DIGEST_SIZE + MAX_IMBL_SIZE + PHMAC_MAX_KEY_SIZE];
+	union s390_kmac_gr0 gr0;
+	u8 buf[MAX_BLOCK_SIZE];
+	unsigned int buflen;
+};
+
+struct s390_phmac_req_ctx {
+	struct delayed_work work;
+	struct ahash_request *req;
+	struct s390_kmac_sha2_ctx sha2_ctx;
+};
+
+/*
+ * kmac_sha2_set_imbl - sets the input message bit-length based on the blocksize
+ */
+static inline void kmac_sha2_set_imbl(u8 *param, unsigned int buflen,
+				      unsigned int blocksize)
+{
+	u8 *imbl = param + SHA2_IMBL_OFFSET(blocksize);
+
+	switch (blocksize) {
+	case SHA256_BLOCK_SIZE:
+		*(u64 *)imbl = (u64)buflen * BITS_PER_BYTE;
+		break;
+	case SHA512_BLOCK_SIZE:
+		*(u128 *)imbl = (u128)buflen * BITS_PER_BYTE;
+		break;
+	default:
+		break;
+	}
+}
+
+/*
+ * Convert the raw key material into a protected key via PKEY api.
+ * This function may sleep - don't call in non-sleeping context.
+ */
+static int phmac_convert_key(struct s390_phmac_ctx *tfm_ctx)
+{
+	struct phmac_protkey pk;
+	int i, rc = -EIO;
+
+	pk.len = sizeof(pk.protkey);
+
+	/* try three times in case of busy card */
+	for (i = 0; rc && i < 3; i++) {
+		if (rc == -EBUSY && msleep_interruptible((1 << i) * 100)) {
+			rc = -EINTR;
+			goto out;
+		}
+		rc = pkey_key2protkey(tfm_ctx->key, tfm_ctx->keylen,
+				      pk.protkey, &pk.len, &pk.type);
+	}
+	if (rc)
+		goto out;
+
+	spin_lock_bh(&tfm_ctx->pk_lock);
+	tfm_ctx->pk = pk;
+	tfm_ctx->pk_state = PK_STATE_VALID;
+	spin_unlock_bh(&tfm_ctx->pk_lock);
+
+	memzero_explicit(&pk, sizeof(pk));
+
+out:
+	pr_debug("rc=%d\n", rc);
+	return rc;
+}
+
+static void phmac_wq_convert_key_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct s390_phmac_ctx *tfm_ctx =
+		container_of(dwork, struct s390_phmac_ctx, work);
+
+	phmac_convert_key(tfm_ctx);
+}
+
+static int phmac_init(struct crypto_ahash *tfm,
+		      struct s390_kmac_sha2_ctx *ctx,
+		      bool maysleep)
+{
+	struct s390_phmac_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
+	unsigned int ds = crypto_ahash_digestsize(tfm);
+	unsigned int bs = crypto_ahash_blocksize(tfm);
+	int i, rc, pk_state;
+
+	spin_lock_bh(&tfm_ctx->pk_lock);
+	pk_state = tfm_ctx->pk_state;
+	spin_unlock_bh(&tfm_ctx->pk_lock);
+
+	switch (pk_state) {
+	case PK_STATE_NO_KEY:
+		return -ENOKEY;
+	case PK_STATE_NEEDS_CONVERT:
+		if (!maysleep)
+			return -EKEYEXPIRED;
+		rc = phmac_convert_key(tfm_ctx);
+		if (rc)
+			return rc;
+		break;
+	case PK_STATE_CONVERT_IN_PROGRESS:
+		if (!maysleep)
+			return -EKEYEXPIRED;
+		for (i = 0; pk_state != PK_STATE_VALID && i < 3; i++) {
+			if (msleep_interruptible((1 << i) * 100))
+				return -EINTR;
+			spin_lock_bh(&tfm_ctx->pk_lock);
+			pk_state = tfm_ctx->pk_state;
+			spin_unlock_bh(&tfm_ctx->pk_lock);
+		}
+		if (pk_state != PK_STATE_VALID)
+			return -EKEYEXPIRED;
+		break;
+	case PK_STATE_VALID:
+		break;
+	default:
+		return pk_state < 0 ? pk_state : -EIO;
+	}
+
+	/* pk is valid, prepare the sha2 context */
+
+	spin_lock_bh(&tfm_ctx->pk_lock);
+	memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
+	       tfm_ctx->pk.protkey, tfm_ctx->pk.len);
+	spin_unlock_bh(&tfm_ctx->pk_lock);
+
+	ctx->buflen = 0;
+	ctx->gr0.reg = 0;
+
+	/* set function code, check for valid protected key type */
+	rc = 0;
+	switch (ds) {
+	case SHA224_DIGEST_SIZE:
+		ctx->gr0.fc = CPACF_KMAC_PHMAC_SHA_224;
+		if (tfm_ctx->pk.type != PKEY_KEYTYPE_HMAC_512)
+			rc = -EINVAL;
+		break;
+	case SHA256_DIGEST_SIZE:
+		ctx->gr0.fc = CPACF_KMAC_PHMAC_SHA_256;
+		if (tfm_ctx->pk.type != PKEY_KEYTYPE_HMAC_512)
+			rc = -EINVAL;
+		break;
+	case SHA384_DIGEST_SIZE:
+		ctx->gr0.fc = CPACF_KMAC_PHMAC_SHA_384;
+		if (tfm_ctx->pk.type != PKEY_KEYTYPE_HMAC_1024)
+			rc = -EINVAL;
+		break;
+	case SHA512_DIGEST_SIZE:
+		ctx->gr0.fc = CPACF_KMAC_PHMAC_SHA_512;
+		if (tfm_ctx->pk.type != PKEY_KEYTYPE_HMAC_1024)
+			rc = -EINVAL;
+		break;
+	default:
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
+static void phmac_wq_init_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct s390_phmac_req_ctx *req_ctx =
+		container_of(dwork, struct s390_phmac_req_ctx, work);
+	struct ahash_request *req = req_ctx->req;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct s390_kmac_sha2_ctx *ctx = &req_ctx->sha2_ctx;
+	int rc;
+
+	rc = phmac_init(tfm, ctx, true);
+
+	pr_debug("req complete with rc=%d\n", rc);
+	crypto_request_complete(&req->base, rc);
+}
+
+static int s390_phmac_init(struct ahash_request *req)
+{
+	struct s390_phmac_req_ctx *req_ctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct s390_kmac_sha2_ctx *ctx = &req_ctx->sha2_ctx;
+	int rc;
+
+	/*
+	 * First try synchronous. If this fails for any reason
+	 * schedule this request asynchronous via workqueue.
+	 */
+
+	rc = phmac_init(tfm, ctx, false);
+	if (!rc)
+		goto out;
+
+	req_ctx->req = req;
+	INIT_DELAYED_WORK(&req_ctx->work, phmac_wq_init_fn);
+	schedule_delayed_work(&req_ctx->work, 0);
+	rc = -EINPROGRESS;
+
+out:
+	pr_debug("rc=%d\n", rc);
+	return rc;
+}
+
+static int phmac_update(struct crypto_ahash *tfm,
+			struct s390_kmac_sha2_ctx *ctx,
+			const u8 *data, unsigned int len,
+			bool maysleep)
+{
+	struct s390_phmac_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
+	unsigned int bs = crypto_ahash_blocksize(tfm);
+	unsigned int offset, n, k;
+	int rc;
+
+	/* check current buffer */
+	offset = ctx->buflen % bs;
+	ctx->buflen += len;
+	if (offset + len < bs)
+		goto store;
+
+	/* process one stored block */
+	if (offset) {
+		n = bs - offset;
+		memcpy(ctx->buf + offset, data, n);
+		ctx->gr0.iimp = 1;
+		for (k = bs;;) {
+			k -= _cpacf_kmac(&ctx->gr0.reg, ctx->param,
+					 ctx->buf + bs - k, k);
+			if (likely(!k))
+				break;
+			if (!maysleep)
+				return -EKEYEXPIRED;
+			rc = phmac_convert_key(tfm_ctx);
+			if (rc)
+				return rc;
+			spin_lock_bh(&tfm_ctx->pk_lock);
+			memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
+			       tfm_ctx->pk.protkey, tfm_ctx->pk.len);
+			spin_unlock_bh(&tfm_ctx->pk_lock);
+		}
+		data += n;
+		len -= n;
+		offset = 0;
+	}
+
+	/* process as many blocks as possible */
+	if (len >= bs) {
+		n = (len / bs) * bs;
+		ctx->gr0.iimp = 1;
+		for (k = n;;) {
+			k -= _cpacf_kmac(&ctx->gr0.reg, ctx->param,
+					 data + n - k, k);
+			if (likely(!k))
+				break;
+			if (!maysleep)
+				return -EKEYEXPIRED;
+			rc = phmac_convert_key(tfm_ctx);
+			if (rc)
+				return rc;
+			spin_lock_bh(&tfm_ctx->pk_lock);
+			memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
+			       tfm_ctx->pk.protkey, tfm_ctx->pk.len);
+			spin_unlock_bh(&tfm_ctx->pk_lock);
+		}
+		data += n;
+		len -= n;
+	}
+
+store:
+	/* store incomplete block in buffer */
+	if (len)
+		memcpy(ctx->buf + offset, data, len);
+
+	return 0;
+}
+
+static void phmac_wq_update_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct s390_phmac_req_ctx *req_ctx =
+		container_of(dwork, struct s390_phmac_req_ctx, work);
+	struct ahash_request *req = req_ctx->req;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct s390_kmac_sha2_ctx *ctx = &req_ctx->sha2_ctx;
+	struct crypto_hash_walk walk;
+	int nbytes, rc = 0;
+
+	for (nbytes = crypto_hash_walk_first(req, &walk);
+	     !rc && nbytes > 0;
+	     nbytes = crypto_hash_walk_done(&walk, 0)) {
+		rc = phmac_update(tfm, ctx, walk.data, nbytes, true);
+		if (rc)
+			crypto_hash_walk_done(&walk, rc);
+	}
+
+	pr_debug("req complete with rc=%d\n", rc);
+	crypto_request_complete(&req->base, rc);
+}
+
+static int s390_phmac_update(struct ahash_request *req)
+{
+	struct s390_phmac_req_ctx *req_ctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct s390_kmac_sha2_ctx *ctx = &req_ctx->sha2_ctx;
+	struct s390_kmac_sha2_ctx ctx_backup;
+	struct crypto_hash_walk walk;
+	int nbytes, rc = 0;
+
+	/*
+	 * First try synchronous. If this fails for any reason
+	 * schedule this request asynchronous via workqueue.
+	 */
+
+	memcpy(&ctx_backup, ctx, sizeof(*ctx));
+
+	for (nbytes = crypto_hash_walk_first(req, &walk);
+	     !rc && nbytes > 0;
+	     nbytes = crypto_hash_walk_done(&walk, 0)) {
+		rc = phmac_update(tfm, ctx, walk.data, nbytes, false);
+		if (rc)
+			crypto_hash_walk_done(&walk, rc);
+	}
+	if (!rc)
+		goto out;
+
+	memcpy(ctx, &ctx_backup, sizeof(*ctx));
+
+	req_ctx->req = req;
+	INIT_DELAYED_WORK(&req_ctx->work, phmac_wq_update_fn);
+	schedule_delayed_work(&req_ctx->work, 0);
+	rc = -EINPROGRESS;
+
+out:
+	pr_debug("rc=%d\n", rc);
+	return rc;
+}
+
+static int phmac_final(struct crypto_ahash *tfm,
+		       struct s390_kmac_sha2_ctx *ctx,
+		       unsigned char *result,
+		       bool maysleep)
+{
+	struct s390_phmac_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
+	unsigned int ds = crypto_ahash_digestsize(tfm);
+	unsigned int bs = crypto_ahash_blocksize(tfm);
+	unsigned int n, k;
+	int rc;
+
+	n = ctx->buflen % bs;
+	ctx->gr0.iimp = 0;
+	kmac_sha2_set_imbl(ctx->param, ctx->buflen, bs);
+	for (k = n;;) {
+		k -= _cpacf_kmac(&ctx->gr0.reg, ctx->param,
+				 ctx->buf + n - k, k);
+		if (likely(!k))
+			break;
+		if (!maysleep)
+			return -EKEYEXPIRED;
+		rc = phmac_convert_key(tfm_ctx);
+		if (rc)
+			return rc;
+		spin_lock_bh(&tfm_ctx->pk_lock);
+		memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
+		       tfm_ctx->pk.protkey, tfm_ctx->pk.len);
+		spin_unlock_bh(&tfm_ctx->pk_lock);
+	}
+
+	memcpy(result, ctx->param, ds);
+
+	return 0;
+}
+
+static void phmac_wq_final_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct s390_phmac_req_ctx *req_ctx =
+		container_of(dwork, struct s390_phmac_req_ctx, work);
+	struct ahash_request *req = req_ctx->req;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct s390_kmac_sha2_ctx *ctx = &req_ctx->sha2_ctx;
+	int rc;
+
+	rc = phmac_final(tfm, ctx, req->result, true);
+
+	pr_debug("req complete with rc=%d\n", rc);
+	crypto_request_complete(&req->base, rc);
+}
+
+static int s390_phmac_final(struct ahash_request *req)
+{
+	struct s390_phmac_req_ctx *req_ctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct s390_kmac_sha2_ctx *ctx = &req_ctx->sha2_ctx;
+	struct s390_kmac_sha2_ctx ctx_backup;
+	int rc;
+
+	/*
+	 * First try synchronous. If this fails for any reason
+	 * schedule this request asynchronous via workqueue.
+	 */
+
+	memcpy(&ctx_backup, ctx, sizeof(*ctx));
+
+	rc = phmac_final(tfm, ctx, req->result, false);
+	if (!rc)
+		goto out;
+
+	memcpy(ctx, &ctx_backup, sizeof(*ctx));
+
+	req_ctx->req = req;
+	INIT_DELAYED_WORK(&req_ctx->work, phmac_wq_final_fn);
+	schedule_delayed_work(&req_ctx->work, 0);
+	rc = -EINPROGRESS;
+
+out:
+	pr_debug("rc=%d\n", rc);
+	return rc;
+}
+
+static void phmac_wq_digest_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct s390_phmac_req_ctx *req_ctx =
+		container_of(dwork, struct s390_phmac_req_ctx, work);
+	struct ahash_request *req = req_ctx->req;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct s390_kmac_sha2_ctx *ctx = &req_ctx->sha2_ctx;
+	struct crypto_hash_walk walk;
+	int nbytes, rc = 0;
+
+	rc = phmac_init(tfm, ctx, true);
+	if (rc)
+		goto out;
+
+	for (nbytes = crypto_hash_walk_first(req, &walk);
+	     !rc && nbytes > 0;
+	     nbytes = crypto_hash_walk_done(&walk, 0)) {
+		rc = phmac_update(tfm, ctx, walk.data, nbytes, true);
+		if (rc)
+			crypto_hash_walk_done(&walk, rc);
+	}
+	if (rc)
+		goto out;
+
+	rc = phmac_final(tfm, ctx, req->result, true);
+
+out:
+	pr_debug("req complete with rc=%d\n", rc);
+	crypto_request_complete(&req->base, rc);
+}
+
+static int s390_phmac_digest(struct ahash_request *req)
+{
+	struct s390_phmac_req_ctx *req_ctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct s390_kmac_sha2_ctx *ctx = &req_ctx->sha2_ctx;
+	struct crypto_hash_walk walk;
+	int nbytes, rc;
+
+	/*
+	 * First try synchronous. If this fails for any reason
+	 * schedule this request asynchronous via workqueue.
+	 */
+
+	rc = phmac_init(tfm, ctx, false);
+	if (rc)
+		goto via_wq;
+
+	for (nbytes = crypto_hash_walk_first(req, &walk);
+	     !rc && nbytes > 0;
+	     nbytes = crypto_hash_walk_done(&walk, 0)) {
+		rc = phmac_update(tfm, ctx, walk.data, nbytes, false);
+		if (rc)
+			crypto_hash_walk_done(&walk, rc);
+	}
+	if (rc)
+		goto via_wq;
+
+	rc = phmac_final(tfm, ctx, req->result, false);
+	if (!rc)
+		goto out;
+
+via_wq:
+	req_ctx->req = req;
+	INIT_DELAYED_WORK(&req_ctx->work, phmac_wq_digest_fn);
+	schedule_delayed_work(&req_ctx->work, 0);
+	rc = -EINPROGRESS;
+
+out:
+	pr_debug("rc=%d\n", rc);
+	return rc;
+}
+
+static int s390_phmac_setkey(struct crypto_ahash *tfm,
+			     const u8 *key, unsigned int keylen)
+{
+	struct s390_phmac_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
+
+	if (tfm_ctx->keylen) {
+		kfree_sensitive(tfm_ctx->key);
+		tfm_ctx->key = NULL;
+		tfm_ctx->keylen = 0;
+	}
+
+	tfm_ctx->key = kmemdup(key, keylen, GFP_ATOMIC);
+	if (!tfm_ctx->key)
+		return -ENOMEM;
+	tfm_ctx->keylen = keylen;
+
+	/* Always trigger an asynch key convert */
+	spin_lock_bh(&tfm_ctx->pk_lock);
+	tfm_ctx->pk_state = PK_STATE_CONVERT_IN_PROGRESS;
+	spin_unlock_bh(&tfm_ctx->pk_lock);
+	schedule_delayed_work(&tfm_ctx->work, 0);
+
+	pr_debug("rc=0\n");
+	return 0;
+}
+
+static int s390_phmac_import(struct ahash_request *req, const void *in)
+{
+	return -EOPNOTSUPP;
+}
+
+static int s390_phmac_export(struct ahash_request *req, void *out)
+{
+	return -EOPNOTSUPP;
+}
+
+static int s390_phmac_init_tfm(struct crypto_ahash *tfm)
+{
+	struct s390_phmac_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
+
+	tfm_ctx->key = NULL;
+	tfm_ctx->keylen = 0;
+
+	INIT_DELAYED_WORK(&tfm_ctx->work, phmac_wq_convert_key_fn);
+
+	tfm_ctx->pk_state = PK_STATE_NO_KEY;
+	spin_lock_init(&tfm_ctx->pk_lock);
+
+	crypto_ahash_set_reqsize(tfm, sizeof(struct s390_phmac_req_ctx));
+
+	pr_debug("rc=0\n");
+	return 0;
+}
+
+static void s390_phmac_exit_tfm(struct crypto_ahash *tfm)
+{
+	struct s390_phmac_ctx *tfm_ctx = crypto_ahash_ctx(tfm);
+
+	flush_delayed_work(&tfm_ctx->work);
+
+	memzero_explicit(&tfm_ctx->pk, sizeof(tfm_ctx->pk));
+	kfree_sensitive(tfm_ctx->key);
+
+	pr_debug("\n");
+}
+
+#define S390_ASYNC_PHMAC_ALG(x)						\
+{									\
+	.init = s390_phmac_init,					\
+	.update = s390_phmac_update,					\
+	.final = s390_phmac_final,					\
+	.digest = s390_phmac_digest,					\
+	.setkey = s390_phmac_setkey,					\
+	.import = s390_phmac_import,					\
+	.export = s390_phmac_export,					\
+	.init_tfm = s390_phmac_init_tfm,				\
+	.exit_tfm = s390_phmac_exit_tfm,				\
+	.halg = {							\
+		.digestsize = SHA##x##_DIGEST_SIZE,			\
+		.statesize = sizeof(struct s390_kmac_sha2_ctx),		\
+		.base = {						\
+			.cra_name = "phmac(sha" #x ")",			\
+			.cra_driver_name = "phmac_s390_sha" #x,		\
+			.cra_blocksize = SHA##x##_BLOCK_SIZE,		\
+			.cra_priority = 400,				\
+			.cra_flags = CRYPTO_ALG_ASYNC,			\
+			.cra_ctxsize = sizeof(struct s390_phmac_ctx),	\
+			.cra_module = THIS_MODULE,			\
+		},							\
+	},								\
+}
+
+static struct s390_hmac_alg {
+	unsigned int fc;
+	struct ahash_alg alg;
+	bool registered;
+} s390_hmac_algs[] = {
+	{
+		.fc = CPACF_KMAC_PHMAC_SHA_224,
+		.alg = S390_ASYNC_PHMAC_ALG(224),
+	}, {
+		.fc = CPACF_KMAC_PHMAC_SHA_256,
+		.alg = S390_ASYNC_PHMAC_ALG(256),
+	}, {
+		.fc = CPACF_KMAC_PHMAC_SHA_384,
+		.alg = S390_ASYNC_PHMAC_ALG(384),
+	}, {
+		.fc = CPACF_KMAC_PHMAC_SHA_512,
+		.alg = S390_ASYNC_PHMAC_ALG(512),
+	}
+};
+
+static __always_inline void _s390_hmac_algs_unregister(void)
+{
+	struct s390_hmac_alg *hmac;
+	int i;
+
+	for (i = ARRAY_SIZE(s390_hmac_algs) - 1; i >= 0; i--) {
+		hmac = &s390_hmac_algs[i];
+		if (hmac->registered)
+			crypto_unregister_ahash(&hmac->alg);
+	}
+}
+
+static int __init phmac_s390_init(void)
+{
+	struct s390_hmac_alg *hmac;
+	int i, rc = -ENODEV;
+
+	for (i = 0; i < ARRAY_SIZE(s390_hmac_algs); i++) {
+		hmac = &s390_hmac_algs[i];
+		if (!cpacf_query_func(CPACF_KMAC, hmac->fc))
+			continue;
+		rc = crypto_register_ahash(&hmac->alg);
+		if (rc) {
+			pr_err("unable to register %s\n",
+			       hmac->alg.halg.base.cra_name);
+			goto out;
+		}
+		hmac->registered = true;
+		pr_debug("registered %s\n", hmac->alg.halg.base.cra_name);
+	}
+	return rc;
+out:
+	_s390_hmac_algs_unregister();
+	return rc;
+}
+
+static void __exit phmac_s390_exit(void)
+{
+	_s390_hmac_algs_unregister();
+}
+
+module_init(phmac_s390_init);
+module_exit(phmac_s390_exit);
+
+MODULE_ALIAS_CRYPTO("phmac(sha224)");
+MODULE_ALIAS_CRYPTO("phmac(sha256)");
+MODULE_ALIAS_CRYPTO("phmac(sha384)");
+MODULE_ALIAS_CRYPTO("phmac(sha512)");
+
+MODULE_DESCRIPTION("S390 HMAC driver for protected keys");
+MODULE_LICENSE("GPL");
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 0a9cdd31cbd9..519305e04f18 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -187,6 +187,18 @@ config CRYPTO_PAES_S390
 	  Select this option if you want to use the paes cipher
 	  for example to use protected key encrypted devices.
 
+config CRYPTO_PHMAC_S390
+	tristate "PHMAC cipher algorithms"
+	depends on S390
+	depends on PKEY
+	select CRYPTO_HASH
+	help
+	  This is the s390 hardware accelerated implementation of the
+	  protected key HMAC support for SHA224, SHA256, SHA384 and SHA512.
+
+	  Select this option if you want to use the phmac digests
+	  for example to use dm-integrity with secure/protected keys.
+
 config S390_PRNG
 	tristate "Pseudo random number generator device driver"
 	depends on S390
-- 
2.43.0

