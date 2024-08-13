Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB4058ABF
	for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2024 07:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534655; cv=none; b=kgW8JSWLyio4ehnlyw6rTc8YUrRYqXcjvpcLR9B+sw14L603VYx7BMU7IZudG5SCG+yAkcQbmiq4qFsH7rI5X/xuDdjfTS1HmcDeSDV/89kxtiAatUcJi4XjznLSz3E6k9QZW3CGU6AloYiA8cqidNmV9m63ukH+XBOThKIjgFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534655; c=relaxed/simple;
	bh=OKwrEhIHcQKo/OEVdH3+CLXLWsNdNWer4SmlHgk5448=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=d71NzSSwS80VgjFpPOgD5CfNFAeh4qUGJxf1Rt0pztvSTBvRaZ0Yejqug+6JP1lEz014XD+18NcoF1P58XKG7ZHFudv6SDSA+4fzWIvR5TkuHPaOTAfuJvIjH5jXcNj1p3sbBHm91kRvqX5e2xwcgeY+Y2QVwG2/hMKXXeTTGG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DWpDz0jx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DWpDz0jx"
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47D7UZXf005874;
	Tue, 13 Aug 2024 07:37:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	mime-version:date:from:to:cc:subject:reply-to:in-reply-to
	:references:message-id:content-type:content-transfer-encoding;
	 s=pp1; bh=uXoKB42SNjU3zHe2zQgS8ERrfNG4Q/oZNGHo6kuyKDI=; b=DWpDz
	0jxL7mqH5YkYU3+P5o1nxFQw4uE6ZWqk3+R196HUl+00qfDBWd2hCVbHS98TmlAP
	MUzUeV/nnbmFVUoR83qwKLUlOEXBk/ADhgnrQZz/TeC2HarfvUfgpK9tFnW1gzjL
	qnnuc18EtXpMxJsg2IVvUUMBwBqY1lG8KVjCM5mgytLDg+aOXEh4elRX4vTM+PYp
	QFl2CDn3NXG5U6BOmJ6eJgddNCAub5QqEijVpOcgNDk8CmkY9WR1RUlCQ7Q80F9E
	hKdcdPuGeBxygMrtCjY5vnF07WAqHo1qXKbtffmOSa1E9mPHe0TgBPfdC3VASVbS
	JtUgjSbLO2jQoou7w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40wwm7q0pf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Aug 2024 07:37:28 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 47D63Yjr020933;
	Tue, 13 Aug 2024 07:37:28 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 40xn8321dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Aug 2024 07:37:28 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 47D7bPdx31457928
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 07:37:27 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A0CA58076;
	Tue, 13 Aug 2024 07:37:25 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0FE5258073;
	Tue, 13 Aug 2024 07:37:25 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 13 Aug 2024 07:37:24 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 13 Aug 2024 09:37:24 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Holger Dengler <dengler@linux.ibm.com>
Subject: RFC: s390/crypto: Add hardware acceleration for HMAC modes
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20240807160629.2486-3-dengler@linux.ibm.com>
References: <20240807160629.2486-1-dengler@linux.ibm.com>
 <20240807160629.2486-3-dengler@linux.ibm.com>
Message-ID: <8511b5079e158b79232f7be9d03fbba5@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TzhECXEUa0eE_3LItDADg6T9BPibj54V
X-Proofpoint-ORIG-GUID: TzhECXEUa0eE_3LItDADg6T9BPibj54V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-13_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 clxscore=1011 adultscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408130053

Hello Herbert, hi linux kernel crypto list

With the next s390 machine generation there comes hmac(sha2) support in 
hardware.
So here is a patch which exploits this hardware.
However, before pushing this into linux-next it would be nice to get 
some
feedback and a review of someone really familiar with all the odds and 
ends
of the in-kernel crypto implementations.

The implementation here is a shash implementation providing 
hmac(sha224),
hmac(sha256), hmac(sha384) and hmac(sha512) support. This is file
arch/s390/crypto/hmac_s390.c. It would be nice to get some feedback if 
we
did this the correct way. The rest of the patch is s390 specific - 
ignore it.

Thanks for spending some time on this.
Harald Freudenberger

-------- Original Message --------
Subject: [PATCH v3 2/2] s390/crypto: Add hardware acceleration for HMAC 
modes
Date: 2024-08-07 18:06
 From: Holger Dengler <dengler@linux.ibm.com>
To: freude@linux.ibm.com
Cc: dengler@linux.ibm.com, linux390-list@tuxmaker.boeblingen.de.ibm.com, 
Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
Alexander Gordeev <agordeev@linux.ibm.com>

Add new shash exploiting the HMAC hardware accelerations for SHA224,
SHA256, SHA384 and SHA512 introduced with message-security assist
extension 11.

Reference-ID: SEC2304
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
---
  arch/s390/configs/debug_defconfig |   1 +
  arch/s390/configs/defconfig       |   1 +
  arch/s390/crypto/Kconfig          |  10 +
  arch/s390/crypto/Makefile         |   1 +
  arch/s390/crypto/hmac_s390.c      | 334 ++++++++++++++++++++++++++++++
  arch/s390/include/asm/cpacf.h     |  37 +++-
  6 files changed, 376 insertions(+), 8 deletions(-)
  create mode 100644 arch/s390/crypto/hmac_s390.c

diff --git a/arch/s390/configs/debug_defconfig 
b/arch/s390/configs/debug_defconfig
index ea63a7342f5f..6c57f024acae 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -794,6 +794,7 @@ CONFIG_CRYPTO_GHASH_S390=m
  CONFIG_CRYPTO_AES_S390=m
  CONFIG_CRYPTO_DES_S390=m
  CONFIG_CRYPTO_CHACHA_S390=m
+CONFIG_CRYPTO_HMAC_S390=m
  CONFIG_ZCRYPT=m
  CONFIG_PKEY=m
  CONFIG_CRYPTO_PAES_S390=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index d8b28ff8ff45..c75e375570fa 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -781,6 +781,7 @@ CONFIG_CRYPTO_GHASH_S390=m
  CONFIG_CRYPTO_AES_S390=m
  CONFIG_CRYPTO_DES_S390=m
  CONFIG_CRYPTO_CHACHA_S390=m
+CONFIG_CRYPTO_HMAC_S390=m
  CONFIG_ZCRYPT=m
  CONFIG_PKEY=m
  CONFIG_CRYPTO_PAES_S390=m
diff --git a/arch/s390/crypto/Kconfig b/arch/s390/crypto/Kconfig
index 06ee706b0d78..d3eb3a233693 100644
--- a/arch/s390/crypto/Kconfig
+++ b/arch/s390/crypto/Kconfig
@@ -132,4 +132,14 @@ config CRYPTO_CHACHA_S390

  	  It is available as of z13.

+config CRYPTO_HMAC_S390
+	tristate "Keyed-hash message authentication code: HMAC"
+	depends on S390
+	select CRYPTO_HASH
+	help
+	  s390 specific HMAC hardware support for SHA224, SHA256, SHA384 and
+	  SHA512.
+
+	  Architecture: s390
+
  endmenu
diff --git a/arch/s390/crypto/Makefile b/arch/s390/crypto/Makefile
index 1b1cc478fa94..a0cb96937c3d 100644
--- a/arch/s390/crypto/Makefile
+++ b/arch/s390/crypto/Makefile
@@ -15,6 +15,7 @@ obj-$(CONFIG_CRYPTO_CHACHA_S390) += chacha_s390.o
  obj-$(CONFIG_S390_PRNG) += prng.o
  obj-$(CONFIG_CRYPTO_GHASH_S390) += ghash_s390.o
  obj-$(CONFIG_CRYPTO_CRC32_S390) += crc32-vx_s390.o
+obj-$(CONFIG_CRYPTO_HMAC_S390) += hmac_s390.o
  obj-y += arch_random.o

  crc32-vx_s390-y := crc32-vx.o crc32le-vx.o crc32be-vx.o
diff --git a/arch/s390/crypto/hmac_s390.c b/arch/s390/crypto/hmac_s390.c
new file mode 100644
index 000000000000..71b15021d4c5
--- /dev/null
+++ b/arch/s390/crypto/hmac_s390.c
@@ -0,0 +1,334 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright IBM Corp. 2024
+ *
+ * s390 specific HMAC support.
+ */
+
+#define KMSG_COMPONENT	"hmac_s390"
+#define pr_fmt(fmt)	KMSG_COMPONENT ": " fmt
+
+#include <asm/cpacf.h>
+#include <crypto/sha2.h>
+#include <crypto/internal/hash.h>
+#include <linux/cpufeature.h>
+#include <linux/module.h>
+
+/*
+ * KMAC param block layout for sha2 function codes:
+ * The layout of the param block for the KMAC instruction depends on 
the
+ * blocksize of the used hashing sha2-algorithm function codes. The 
param block
+ * contains the hash chaining value (cv), the input message bit-length 
(imbl)
+ * and the hmac-secret (key). To prevent code duplication, the sizes of 
all
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
+ * key  | 224/256 | blocksize   |   64 |  u8[64]
+ *      | 384/512 |             |  128 | u8[128]
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
+struct s390_hmac_ctx {
+	u8 key[MAX_BLOCK_SIZE];
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
+	u8 param[MAX_DIGEST_SIZE + MAX_IMBL_SIZE + MAX_BLOCK_SIZE];
+	union s390_kmac_gr0 gr0;
+	u8 buf[MAX_BLOCK_SIZE];
+	unsigned int buflen;
+};
+
+/*
+ * kmac_sha2_set_imbl - sets the input message bit-length based on the 
blocksize
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
+static int hash(const u8 *in, unsigned int inlen,
+		u8 *digest, unsigned int digestsize)
+{
+	struct crypto_shash *htfm;
+	const char *alg_name;
+	int ret;
+
+	switch (digestsize) {
+	case SHA224_DIGEST_SIZE:
+		alg_name = "sha224";
+		break;
+	case SHA256_DIGEST_SIZE:
+		alg_name = "sha256";
+		break;
+	case SHA384_DIGEST_SIZE:
+		alg_name = "sha384";
+		break;
+	case SHA512_DIGEST_SIZE:
+		alg_name = "sha512";
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	htfm = crypto_alloc_shash(alg_name, 0, CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(htfm))
+		return PTR_ERR(htfm);
+
+	ret = crypto_shash_tfm_digest(htfm, in, inlen, digest);
+	if (ret)
+		pr_err("shash digest error: %d\n", ret);
+
+	crypto_free_shash(htfm);
+	return ret;
+}
+
+static int s390_hmac_sha2_setkey(struct crypto_shash *tfm,
+				 const u8 *key, unsigned int keylen)
+{
+	struct s390_hmac_ctx *tfm_ctx = crypto_shash_ctx(tfm);
+	unsigned int ds = crypto_shash_digestsize(tfm);
+	unsigned int bs = crypto_shash_blocksize(tfm);
+
+	memset(tfm_ctx, 0, sizeof(*tfm_ctx));
+
+	if (keylen > bs)
+		return hash(key, keylen, tfm_ctx->key, ds);
+
+	memcpy(tfm_ctx->key, key, keylen);
+	return 0;
+}
+
+static int s390_hmac_sha2_init(struct shash_desc *desc)
+{
+	struct s390_hmac_ctx *tfm_ctx = crypto_shash_ctx(desc->tfm);
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int bs = crypto_shash_blocksize(desc->tfm);
+
+	memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
+	       tfm_ctx->key, bs);
+
+	ctx->buflen = 0;
+	ctx->gr0.reg = 0;
+	switch (crypto_shash_digestsize(desc->tfm)) {
+	case SHA224_DIGEST_SIZE:
+		ctx->gr0.fc = CPACF_KMAC_HMAC_SHA_224;
+		break;
+	case SHA256_DIGEST_SIZE:
+		ctx->gr0.fc = CPACF_KMAC_HMAC_SHA_256;
+		break;
+	case SHA384_DIGEST_SIZE:
+		ctx->gr0.fc = CPACF_KMAC_HMAC_SHA_384;
+		break;
+	case SHA512_DIGEST_SIZE:
+		ctx->gr0.fc = CPACF_KMAC_HMAC_SHA_512;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int s390_hmac_sha2_update(struct shash_desc *desc,
+				 const u8 *data, unsigned int len)
+{
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int bs = crypto_shash_blocksize(desc->tfm);
+	unsigned int offset, n;
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
+		_cpacf_kmac(&ctx->gr0.reg, ctx->param, ctx->buf, bs);
+		data += n;
+		len -= n;
+		offset = 0;
+	}
+	/* process as many blocks as possible */
+	if (len >= bs) {
+		n = (len / bs) * bs;
+		ctx->gr0.iimp = 1;
+		_cpacf_kmac(&ctx->gr0.reg, ctx->param, data, n);
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
+static int s390_hmac_sha2_final(struct shash_desc *desc, u8 *out)
+{
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int bs = crypto_shash_blocksize(desc->tfm);
+
+	ctx->gr0.iimp = 0;
+	kmac_sha2_set_imbl(ctx->param, ctx->buflen, bs);
+	_cpacf_kmac(&ctx->gr0.reg, ctx->param, ctx->buf, ctx->buflen % bs);
+	memcpy(out, ctx->param, crypto_shash_digestsize(desc->tfm));
+
+	return 0;
+}
+
+static int s390_hmac_sha2_digest(struct shash_desc *desc,
+				 const u8 *data, unsigned int len, u8 *out)
+{
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int ds = crypto_shash_digestsize(desc->tfm);
+	int rc;
+
+	rc = s390_hmac_sha2_init(desc);
+	if (rc)
+		return rc;
+
+	ctx->gr0.iimp = 0;
+	kmac_sha2_set_imbl(ctx->param, len,
+			   crypto_shash_blocksize(desc->tfm));
+	_cpacf_kmac(&ctx->gr0.reg, ctx->param, data, len);
+	memcpy(out, ctx->param, ds);
+
+	return 0;
+}
+
+#define S390_HMAC_SHA2_ALG(x) {						\
+	.fc = CPACF_KMAC_HMAC_SHA_##x,					\
+	.alg = {							\
+		.init = s390_hmac_sha2_init,				\
+		.update = s390_hmac_sha2_update,			\
+		.final = s390_hmac_sha2_final,				\
+		.digest = s390_hmac_sha2_digest,			\
+		.setkey = s390_hmac_sha2_setkey,			\
+		.descsize = sizeof(struct s390_kmac_sha2_ctx),		\
+		.halg = {						\
+			.digestsize = SHA##x##_DIGEST_SIZE,		\
+			.base = {					\
+				.cra_name = "hmac(sha" #x ")",		\
+				.cra_driver_name = "hmac_s390_sha" #x,	\
+				.cra_blocksize = SHA##x##_BLOCK_SIZE,	\
+				.cra_priority = 400,			\
+				.cra_ctxsize = sizeof(struct s390_hmac_ctx), \
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
+static int __init hmac_s390_init(void)
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
+static void __exit hmac_s390_exit(void)
+{
+	_s390_hmac_algs_unregister();
+}
+
+module_cpu_feature_match(S390_CPU_FEATURE_MSA, hmac_s390_init);
+module_exit(hmac_s390_exit);
+
+MODULE_DESCRIPTION("S390 HMAC driver");
+MODULE_LICENSE("GPL");
diff --git a/arch/s390/include/asm/cpacf.h 
b/arch/s390/include/asm/cpacf.h
index b2f355751bf6..2dbe2e2088bb 100644
--- a/arch/s390/include/asm/cpacf.h
+++ b/arch/s390/include/asm/cpacf.h
@@ -123,6 +123,10 @@
  #define CPACF_KMAC_DEA		0x01
  #define CPACF_KMAC_TDEA_128	0x02
  #define CPACF_KMAC_TDEA_192	0x03
+#define CPACF_KMAC_HMAC_SHA_224	0x70
+#define CPACF_KMAC_HMAC_SHA_256	0x71
+#define CPACF_KMAC_HMAC_SHA_384	0x72
+#define CPACF_KMAC_HMAC_SHA_512	0x73

  /*
   * Function codes for the PCKMO (PERFORM CRYPTOGRAPHIC KEY MANAGEMENT)
@@ -427,35 +431,52 @@ static inline void cpacf_klmd(unsigned long func, 
void *param,
  }

  /**
- * cpacf_kmac() - executes the KMAC (COMPUTE MESSAGE AUTHENTICATION 
CODE)
- *		  instruction
- * @func: the function code passed to KM; see CPACF_KMAC_xxx defines
+ * _cpacf_kmac() - executes the KMAC (COMPUTE MESSAGE AUTHENTICATION 
CODE)
+ * instruction and updates flags in gr0
+ * @gr0: pointer to gr0 (fc and flags) passed to KMAC; see 
CPACF_KMAC_xxx defines
   * @param: address of parameter block; see POP for details on each func
   * @src: address of source memory area
   * @src_len: length of src operand in bytes
   *
   * Returns 0 for the query func, number of processed bytes for digest 
funcs
   */
-static inline int cpacf_kmac(unsigned long func, void *param,
-			     const u8 *src, long src_len)
+static inline int _cpacf_kmac(unsigned long *gr0, void *param,
+			      const u8 *src, long src_len)
  {
  	union register_pair s;

  	s.even = (unsigned long)src;
  	s.odd  = (unsigned long)src_len;
  	asm volatile(
-		"	lgr	0,%[fc]\n"
+		"	lgr	0,%[r0]\n"
  		"	lgr	1,%[pba]\n"
  		"0:	.insn	rre,%[opc] << 16,0,%[src]\n"
  		"	brc	1,0b\n" /* handle partial completion */
-		: [src] "+&d" (s.pair)
-		: [fc] "d" (func), [pba] "d" ((unsigned long)param),
+		"	lgr	%[r0],0\n"
+		: [r0] "+d" (*gr0), [src] "+&d" (s.pair)
+		: [pba] "d" ((unsigned long)param),
  		  [opc] "i" (CPACF_KMAC)
  		: "cc", "memory", "0", "1");

  	return src_len - s.odd;
  }

+/**
+ * cpacf_kmac() - executes the KMAC (COMPUTE MESSAGE AUTHENTICATION 
CODE)
+ * instruction
+ * @func: function code passed to KMAC; see CPACF_KMAC_xxx defines
+ * @param: address of parameter block; see POP for details on each func
+ * @src: address of source memory area
+ * @src_len: length of src operand in bytes
+ *
+ * Returns 0 for the query func, number of processed bytes for digest 
funcs
+ */
+static inline int cpacf_kmac(unsigned long func, void *param,
+			     const u8 *src, long src_len)
+{
+	return _cpacf_kmac(&func, param, src, src_len);
+}
+
  /**
   * cpacf_kmctr() - executes the KMCTR (CIPHER MESSAGE WITH COUNTER) 
instruction
   * @func: the function code passed to KMCTR; see CPACF_KMCTR_xxx 
defines
