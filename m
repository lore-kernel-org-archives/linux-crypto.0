Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25461CEE83;
	Fri, 15 Nov 2024 14:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731682058; cv=none; b=L+ClnGbALu+pGJDg/AyuaTdZTTHN7GepPUKhQMhRSERc3auVJOb+nz1APh30TuRgCX9cbL4QBEuF0pWC7lFFDpDih2RPtcxWgmGirCxSRntr6p/SpOMCaLJ1hLsqpP8Mz3C/xjn7twkVwuduK+XR3QHPXF7/Wg84Cw3fJ8yT2A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731682058; c=relaxed/simple;
	bh=lSJLs1PSY86qsxSb1QU7X5tJO8pF7NPmIS/ZaodA3EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkmbCpgHM1MHYuOp3I0JtMC/KXHEVgsgUqXbt39ZJUvD/0fnp/VlIRQX7GuVn0cS7GJLIVSXbiF6ttEkNAvd9gGy9bHeXshsJ7E+BYT8R9ZU7ymUsM1RwedSyMo/zXmg06OR+ingyzeXoPGIgsKNt5DqCpmVhWwK23JhQyWoz/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oGoCkAOK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oGoCkAOK"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFAYjVD021042;
	Fri, 15 Nov 2024 14:47:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fYT6hT9dFiJqS/Rtr
	J/jl/NYafB3kgn7W4EItXPLt8E=; b=oGoCkAOKWDizmUtUIkRAvPSqQr7WCDT4T
	dXILlbCC+i926Z6cxcDecQfr9+fV1L1ojdHVZTVp4l+EYhw/D75q6MzU9YNFXyZL
	yUzlirJGRe9EWxgEgWuNpjFDUYxdMV65qJgpS9djiHQwna3E7IEaed6cdfKBoCHN
	aOzp2NWoNadQQSx8vWAzQOx6+1zoI06kW/hv2bqBnbUKOjpscTI1pGeGr/byHCvZ
	mXCTsHf4sqTjD5IVNT1ASfwCyhLrg0KpzFEQnRWAeU63HgOQMqmqCSmBGNOM0TsZ
	t3nVdN9g2/LqCuMH8PoEPCS20W9L0hwiE2P49zoD6h7c5NpQTU8Sw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42wrvkv9ks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 14:47:31 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF9Rx7J006674;
	Fri, 15 Nov 2024 14:47:30 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42tm9jjdja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 14:47:30 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AFElR7648496994
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Nov 2024 14:47:27 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAD1C2004D;
	Fri, 15 Nov 2024 14:47:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68BAB20043;
	Fri, 15 Nov 2024 14:47:26 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.73.203])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 15 Nov 2024 14:47:26 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v4 3/3] s390/crypto: New s390 specific shash phmac
Date: Fri, 15 Nov 2024 15:47:24 +0100
Message-ID: <20241115144724.12146-4-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241115144724.12146-1-freude@linux.ibm.com>
References: <20241115144724.12146-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2EmpLvjRNWRQ-JMT2ASsR9NjXCy6vBLX
X-Proofpoint-GUID: 2EmpLvjRNWRQ-JMT2ASsR9NjXCy6vBLX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411150124

From: Holger Dengler <dengler@linux.ibm.com>

Add support for protected key hmac ("phmac") for s390 arch.

With the latest machine generation there is now support for
protected key (that is a key wrapped by a master key stored
in firmware) hmac for sha2 (sha224, sha256, sha384 and sha512)
for the s390 specific CPACF instruction kmac.

This patch adds support via 4 new shashes registered as
phmac(sha224), phmac(sha256), phmac(sha384) and phmac(sha512).

Please note that as of now, there is no selftest enabled for
these shashes, but the implementation has been tested with
testcases via AF_ALG interface.

Please note also that this implementation actively checks for
non-sleeping context before attempting to derive a protected
key from the given raw key material. This is due to the fact
that it may be (in the future) that this process has to interact
with crypto cards and thus requires IO traffic - which requires
sleeping allowed context. So there is a check for in_task()
and if this fails, -EOPNOTSUPP is returned to the caller.

Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 arch/s390/configs/debug_defconfig |   1 +
 arch/s390/configs/defconfig       |   1 +
 arch/s390/crypto/Makefile         |   1 +
 arch/s390/crypto/phmac_s390.c     | 481 ++++++++++++++++++++++++++++++
 drivers/crypto/Kconfig            |  12 +
 5 files changed, 496 insertions(+)
 create mode 100644 arch/s390/crypto/phmac_s390.c

diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index 6b602d972e91..a8ba72e7162d 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -804,6 +804,7 @@ CONFIG_PKEY_EP11=m
 CONFIG_PKEY_PCKMO=m
 CONFIG_PKEY_UV=m
 CONFIG_CRYPTO_PAES_S390=m
+CONFIG_CRYPTO_PHMAC_S390=m
 CONFIG_CRYPTO_DEV_VIRTIO=m
 CONFIG_SYSTEM_BLACKLIST_KEYRING=y
 CONFIG_CORDIC=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index 7844b9f5851b..cd2e9c94b736 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -790,6 +790,7 @@ CONFIG_PKEY_EP11=m
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
index 000000000000..c6a757c5ecfc
--- /dev/null
+++ b/arch/s390/crypto/phmac_s390.c
@@ -0,0 +1,481 @@
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
+#include <crypto/sha2.h>
+#include <crypto/internal/hash.h>
+#include <linux/cpufeature.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
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
+ * cv	| 224/256 | blocksize/2 |   32 |  u64[8]
+ *	| 384/512 |		|   64 | u128[8]
+ * imbl | 224/256 | blocksize/8 |    8 |     u64
+ *	| 384/512 |		|   16 |    u128
+ * key	| 224/256 | blocksize	|   96 |  u8[96]
+ *	| 384/512 |		|  160 | u8[160]
+ *
+ * The setkey() function and also update(), final() and digest() functions
+ * for this protected key hmac implementation are not allowed to be called
+ * in non-sleeping context. On attempt the underlying key conversion function
+ * will return with -EOPNOTSUPP.
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
+struct s390_phmac_ctx {
+	u8 *key;
+	unsigned int keylen;
+
+	struct phmac_protkey pk;
+	/* spinlock to atomic update pk */
+	spinlock_t pk_lock;
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
+static inline int phmac_keyblob2pkey(const u8 *key, unsigned int keylen,
+				     struct phmac_protkey *pk)
+{
+	int i, rc = -EIO;
+
+	/*
+	 * Dependent on the key type, the PKEY module may contact
+	 * a crypto card which is an IO operation and thus implies
+	 * a non-atomic context. So refuse to contact PKEY at all
+	 * if this is really a non-sleeping context.
+	 */
+	if (!in_task())
+		return -EOPNOTSUPP;
+
+	/* try three times in case of busy card */
+	for (i = 0; rc && i < 3; i++) {
+		if (rc == -EBUSY && msleep_interruptible(1000))
+			return -EINTR;
+		rc = pkey_key2protkey(key, keylen,
+				      pk->protkey, &pk->len, &pk->type);
+	}
+
+	return rc;
+}
+
+static inline int phmac_convert_key(struct s390_phmac_ctx *tfm_ctx)
+{
+	struct phmac_protkey pk;
+	int rc;
+
+	pk.len = sizeof(pk.protkey);
+	rc = phmac_keyblob2pkey(tfm_ctx->key, tfm_ctx->keylen, &pk);
+	if (rc)
+		return rc;
+
+	spin_lock_bh(&tfm_ctx->pk_lock);
+	tfm_ctx->pk = pk;
+	spin_unlock_bh(&tfm_ctx->pk_lock);
+
+	return 0;
+}
+
+static inline int s390_phmac_sha2_setkey(struct crypto_shash *tfm,
+					 const u8 *key, unsigned int keylen)
+{
+	struct s390_phmac_ctx *tfm_ctx = crypto_shash_ctx(tfm);
+	int rc = -ENOMEM;
+
+	if (tfm_ctx->keylen) {
+		kfree_sensitive(tfm_ctx->key);
+		tfm_ctx->key = NULL;
+		tfm_ctx->keylen = 0;
+	}
+
+	tfm_ctx->key = kmemdup(key, keylen, GFP_ATOMIC);
+	if (!tfm_ctx->key)
+		goto out;
+	tfm_ctx->keylen = keylen;
+
+	rc = phmac_convert_key(tfm_ctx);
+	if (rc)
+		goto out;
+
+	rc = -EINVAL;
+	switch (crypto_shash_digestsize(tfm)) {
+	case SHA224_DIGEST_SIZE:
+	case SHA256_DIGEST_SIZE:
+		if (tfm_ctx->pk.type != PKEY_KEYTYPE_HMAC_512)
+			goto out;
+		break;
+	case SHA384_DIGEST_SIZE:
+	case SHA512_DIGEST_SIZE:
+		if (tfm_ctx->pk.type != PKEY_KEYTYPE_HMAC_1024)
+			goto out;
+		break;
+	default:
+		goto out;
+	}
+	rc = 0;
+
+out:
+	pr_debug("rc=%d\n", rc);
+	return rc;
+}
+
+static int s390_phmac_sha2_init(struct shash_desc *desc)
+{
+	struct s390_phmac_ctx *tfm_ctx = crypto_shash_ctx(desc->tfm);
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int bs = crypto_shash_blocksize(desc->tfm);
+
+	spin_lock_bh(&tfm_ctx->pk_lock);
+	memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
+	       tfm_ctx->pk.protkey, tfm_ctx->pk.len);
+	spin_unlock_bh(&tfm_ctx->pk_lock);
+
+	ctx->buflen = 0;
+	ctx->gr0.reg = 0;
+
+	switch (crypto_shash_digestsize(desc->tfm)) {
+	case SHA224_DIGEST_SIZE:
+		ctx->gr0.fc = CPACF_KMAC_PHMAC_SHA_224;
+		break;
+	case SHA256_DIGEST_SIZE:
+		ctx->gr0.fc = CPACF_KMAC_PHMAC_SHA_256;
+		break;
+	case SHA384_DIGEST_SIZE:
+		ctx->gr0.fc = CPACF_KMAC_PHMAC_SHA_384;
+		break;
+	case SHA512_DIGEST_SIZE:
+		ctx->gr0.fc = CPACF_KMAC_PHMAC_SHA_512;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int s390_phmac_sha2_update(struct shash_desc *desc,
+				  const u8 *data, unsigned int len)
+{
+	struct s390_phmac_ctx *tfm_ctx = crypto_shash_ctx(desc->tfm);
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int bs = crypto_shash_blocksize(desc->tfm);
+	unsigned int offset, n, k;
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
+			if (!k)
+				break;
+			if (phmac_convert_key(tfm_ctx))
+				return -EIO;
+			spin_lock_bh(&tfm_ctx->pk_lock);
+			memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
+			       tfm_ctx->pk.protkey, tfm_ctx->pk.len);
+			spin_unlock_bh(&tfm_ctx->pk_lock);
+		}
+		data += n;
+		len -= n;
+		offset = 0;
+	}
+	/* process as many blocks as possible */
+	if (len >= bs) {
+		n = (len / bs) * bs;
+		ctx->gr0.iimp = 1;
+		for (k = n;;) {
+			k -= _cpacf_kmac(&ctx->gr0.reg, ctx->param,
+					 data + n - k, k);
+			if (!k)
+				break;
+			if (phmac_convert_key(tfm_ctx))
+				return -EIO;
+			spin_lock_bh(&tfm_ctx->pk_lock);
+			memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
+			       tfm_ctx->pk.protkey, tfm_ctx->pk.len);
+			spin_unlock_bh(&tfm_ctx->pk_lock);
+		}
+		data += n;
+		len -= n;
+	}
+store:
+	/* store incomplete block in buffer */
+	if (len)
+		memcpy(ctx->buf + offset, data, len);
+
+	return 0;
+}
+
+static int s390_phmac_sha2_final(struct shash_desc *desc, u8 *out)
+{
+	struct s390_phmac_ctx *tfm_ctx = crypto_shash_ctx(desc->tfm);
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int bs = crypto_shash_blocksize(desc->tfm);
+	unsigned int n, k;
+
+	n = ctx->buflen % bs;
+	ctx->gr0.iimp = 0;
+	kmac_sha2_set_imbl(ctx->param, ctx->buflen, bs);
+	for (k = n;;) {
+		k -= _cpacf_kmac(&ctx->gr0.reg, ctx->param,
+				 ctx->buf + n - k, k);
+		if (!k)
+			break;
+		if (phmac_convert_key(tfm_ctx))
+			return -EIO;
+		spin_lock_bh(&tfm_ctx->pk_lock);
+		memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
+		       tfm_ctx->pk.protkey, tfm_ctx->pk.len);
+		spin_unlock_bh(&tfm_ctx->pk_lock);
+	}
+	memcpy(out, ctx->param, crypto_shash_digestsize(desc->tfm));
+
+	return 0;
+}
+
+static int s390_phmac_sha2_digest(struct shash_desc *desc,
+				  const u8 *data, unsigned int len, u8 *out)
+{
+	struct s390_phmac_ctx *tfm_ctx = crypto_shash_ctx(desc->tfm);
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int ds = crypto_shash_digestsize(desc->tfm);
+	unsigned int bs = crypto_shash_blocksize(desc->tfm);
+	unsigned int k;
+	int rc;
+
+	rc = s390_phmac_sha2_init(desc);
+	if (rc)
+		return rc;
+
+	ctx->gr0.iimp = 0;
+	kmac_sha2_set_imbl(ctx->param, len, bs);
+	for (k = len;;) {
+		k -= _cpacf_kmac(&ctx->gr0.reg, ctx->param,
+				 data + len - k, k);
+		if (!k)
+			break;
+		if (phmac_convert_key(tfm_ctx))
+			return -EIO;
+		spin_lock_bh(&tfm_ctx->pk_lock);
+		memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
+		       tfm_ctx->pk.protkey, tfm_ctx->pk.len);
+		spin_unlock_bh(&tfm_ctx->pk_lock);
+	}
+	memcpy(out, ctx->param, ds);
+
+	return 0;
+}
+
+static int s390_phmac_sha2_init_tfm(struct crypto_shash *tfm)
+{
+	struct s390_phmac_ctx *tfm_ctx = crypto_shash_ctx(tfm);
+
+	tfm_ctx->key = NULL;
+	tfm_ctx->keylen = 0;
+	spin_lock_init(&tfm_ctx->pk_lock);
+
+	return 0;
+}
+
+static void s390_phmac_sha2_exit_tfm(struct crypto_shash *tfm)
+{
+	struct s390_phmac_ctx *tfm_ctx = crypto_shash_ctx(tfm);
+
+	memzero_explicit(&tfm_ctx->pk, sizeof(tfm_ctx->pk));
+	kfree_sensitive(tfm_ctx->key);
+}
+
+static int s390_phmac_sha2_clone_tfm(struct crypto_shash *dst,
+				     struct crypto_shash *src)
+{
+	struct s390_phmac_ctx *src_ctx = crypto_shash_ctx(src);
+	int rc;
+
+	rc = s390_phmac_sha2_init_tfm(dst);
+	if (rc)
+		return rc;
+
+	if (src_ctx->key && src_ctx->keylen)
+		rc = s390_phmac_sha2_setkey(dst, src_ctx->key, src_ctx->keylen);
+
+	return rc;
+}
+
+#define S390_HMAC_SHA2_ALG(x) {						\
+	.fc = CPACF_KMAC_PHMAC_SHA_##x,					\
+	.alg = {							\
+		.init = s390_phmac_sha2_init,				\
+		.update = s390_phmac_sha2_update,			\
+		.final = s390_phmac_sha2_final,				\
+		.digest = s390_phmac_sha2_digest,			\
+		.setkey = s390_phmac_sha2_setkey,			\
+		.init_tfm = s390_phmac_sha2_init_tfm,			\
+		.exit_tfm = s390_phmac_sha2_exit_tfm,			\
+		.clone_tfm = s390_phmac_sha2_clone_tfm,			\
+		.descsize = sizeof(struct s390_kmac_sha2_ctx),		\
+		.halg = {						\
+			.digestsize = SHA##x##_DIGEST_SIZE,		\
+			.base = {					\
+				.cra_name = "phmac(sha" #x ")",		\
+				.cra_driver_name = "phmac_s390_sha" #x,	\
+				.cra_blocksize = SHA##x##_BLOCK_SIZE,	\
+				.cra_priority = 400,			\
+				.cra_ctxsize = sizeof(struct s390_phmac_ctx), \
+				.cra_module = THIS_MODULE,		\
+			},						\
+		},							\
+	},								\
+}
+
+static struct s390_hmac_alg {
+	bool registered;
+	unsigned int fc;
+	struct shash_alg alg;
+} s390_hmac_algs[] = {
+	S390_HMAC_SHA2_ALG(224),
+	S390_HMAC_SHA2_ALG(256),
+	S390_HMAC_SHA2_ALG(384),
+	S390_HMAC_SHA2_ALG(512),
+};
+
+static __always_inline void _s390_hmac_algs_unregister(void)
+{
+	struct s390_hmac_alg *hmac;
+	int i;
+
+	for (i = ARRAY_SIZE(s390_hmac_algs) - 1; i >= 0; i--) {
+		hmac = &s390_hmac_algs[i];
+		if (!hmac->registered)
+			continue;
+		crypto_unregister_shash(&hmac->alg);
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
+
+		rc = crypto_register_shash(&hmac->alg);
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

