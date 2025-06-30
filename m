Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD83257AF0;
	Mon, 30 Jun 2025 14:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751294334; cv=none; b=cKTJOdG5w7vHgRl2jS6DKJhATnlu1hljzV3RLqhNaZbEwvbw3ciLkHM0ABwcO3UEeIHrs5IVhLtPBk7duteEW1Un8nbSx4LTi5ToZQCiLWrjYVuagHgpRS3KAg4Lply1zK7SlEy50iz2U3wVm4f8oBA45FPXBh748QQhSXmxNpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751294334; c=relaxed/simple;
	bh=H1eGsfDh2XvEyiDLmFiwfZKwF4b7/9liBP37HpQIPCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o58X5v+QcYIFnI8YDAYUTd4+UQV6go8OrbCRbsiHpNiDCJX3ysMKHGrrVmDNfyZq5rt+61S9vkpjp6RaXB+iD4QSEXQN2OXbkw4+vh7ZaC6bfA3wySmJ/QU6eMn62kqaMCqLIiQPQYKiH7rW9+yXIqTC+3BymJesCPFL3J95k40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=im3lzhqG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="im3lzhqG"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55UBTLdx012368;
	Mon, 30 Jun 2025 14:38:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=c1SmB9aoBUHSFNebQ
	ceGRLZxih19kgNxmRy29E7i8/Q=; b=im3lzhqGMxLzmiBzGlTPn6dywk4PpZ98A
	ycFd5eMsSeU/iWkn171VydXEfa1qark1aSA30xXbG2BVy+sTX+1pktP93du/4Zyt
	41gNoz11ZvH7C5KCpDtMzrcRXo2zWrOn68TYPbapI8t0lPsbjA4p8QwMZqGiIyTH
	g9KrJCcY9cj9yUezNKGdmZrXSZmkQIf8Vh9+eovHOoPJwEI852PQCX348638OizA
	4VlrCrx214fdPUTsK0PYEFwTdQuIzl8V3nxCEYcChELckWKcehyqKMK+8O53F18j
	XcZiS27+nM54/qxNCu4cx1FyiFUYBNEvdEpChGGBN9GIHDyxwfWuw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47j82fhr65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Jun 2025 14:38:46 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55UB733X021371;
	Mon, 30 Jun 2025 14:38:45 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 47jwe35yb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Jun 2025 14:38:45 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55UEcisd43909396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Jun 2025 14:38:44 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7CB0258059;
	Mon, 30 Jun 2025 14:38:44 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9A6158058;
	Mon, 30 Jun 2025 14:38:43 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Jun 2025 14:38:43 +0000 (GMT)
From: Stefan Berger <stefanb@linux.ibm.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        dhowells@redhat.com, simo@redhat.com,
        Stefan Berger <stefanb@linux.ibm.com>
Subject: [PATCH v2 2/4] crypto: Add shake128/256 to generic sha3 module
Date: Mon, 30 Jun 2025 10:38:32 -0400
Message-ID: <20250630143834.2748285-3-stefanb@linux.ibm.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250630143834.2748285-1-stefanb@linux.ibm.com>
References: <20250630143834.2748285-1-stefanb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eo-JcFUep7AhLykOG3knCDNuwIIDxXy7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjMwMDExNyBTYWx0ZWRfXzze742ORF/hP gEq4q+elVWBhC9GAu9buFclzaY5miEG9dKhD/T3WmVWLwR8JV4DBL8wGAJ4JnjM4VHyT147m0qT SV4AQuvG9+WGKie+m4IZ1FizFudrtxRbhLddnoSH5kWgPVddCGNtJBK2B++pCIkjVAuSvDD4UON
 qCRNmsKUL5XDYnhRGvZO5iCHB2anAvlPrLvsL1p7y4cbzuJ0zau5dg+VeFSxOaIU1zZHNKjPmkH kRTo+DLq5QfMxzvXjo3c9jIFqRBEDfJOmvEqGchhSVCfTt3CB+DjGcIapibNX9S+yncHiFxFv+P QP23XzYbjLODiQhgumDpUO4Qoaj/pTX5/5mcfyYkw2zn5Rzi9+VlKHjIA2+GZzr6uTYCJVUEdqK
 vd615lAzTSvE8V78IQ7V8zuN5tEOyRdUlgea10Ed46eVNix55qmyBjI+s1uGVXs/hKBvlsdH
X-Authority-Analysis: v=2.4 cv=LpeSymdc c=1 sm=1 tr=0 ts=6862a176 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=7PqV0hYhwxvHinq54jsA:9
X-Proofpoint-GUID: eo-JcFUep7AhLykOG3knCDNuwIIDxXy7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-30_03,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 impostorscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506300117

Extend the sha3 module with shake128 & shake256. For this, implement
functions to get (squeeze) a number of bytes or blocks from the keccak
sponge. A block here corresponds to the number of bytes available in the
state buffer following a keccak permutation. On top of this functionality
implement the general squeeze function that returns a requested number of
bytes to the caller. Implement the 'final' function on top of the squeeze
function. The 'final' function will always request a fixed number of bytes
from the squeeze function and set the 'final' parameter to true, clearing
the state of the hash as usual.

Adjust the maximum hash description and block sizes due to shake128.

Extend the arrays for supported hashes with entries for shake128 and
shake256.

Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
---
 crypto/hash_info.c             |   4 +
 crypto/sha3_generic.c          | 238 +++++++++++++++++++++++++++++++++
 include/crypto/algapi.h        |   2 +-
 include/crypto/hash.h          |   9 +-
 include/crypto/sha3.h          |  19 +++
 include/uapi/linux/hash_info.h |   2 +
 6 files changed, 268 insertions(+), 6 deletions(-)

diff --git a/crypto/hash_info.c b/crypto/hash_info.c
index 9a467638c971..2e426be89463 100644
--- a/crypto/hash_info.c
+++ b/crypto/hash_info.c
@@ -32,6 +32,8 @@ const char *const hash_algo_name[HASH_ALGO__LAST] = {
 	[HASH_ALGO_SHA3_256]    = "sha3-256",
 	[HASH_ALGO_SHA3_384]    = "sha3-384",
 	[HASH_ALGO_SHA3_512]    = "sha3-512",
+	[HASH_ALGO_SHAKE128]	= "shake128",
+	[HASH_ALGO_SHAKE256]	= "shake256",
 };
 EXPORT_SYMBOL_GPL(hash_algo_name);
 
@@ -59,5 +61,7 @@ const int hash_digest_size[HASH_ALGO__LAST] = {
 	[HASH_ALGO_SHA3_256]    = SHA3_256_DIGEST_SIZE,
 	[HASH_ALGO_SHA3_384]    = SHA3_384_DIGEST_SIZE,
 	[HASH_ALGO_SHA3_512]    = SHA3_512_DIGEST_SIZE,
+	[HASH_ALGO_SHAKE128]	= SHAKE128_DIGEST_SIZE,
+	[HASH_ALGO_SHAKE256]	= SHAKE256_DIGEST_SIZE,
 };
 EXPORT_SYMBOL_GPL(hash_digest_size);
diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
index 41d1e506e6de..f90484464afd 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -29,6 +29,8 @@
 #define SHA3_INLINE	noinline
 #endif
 
+#define DOMAIN_SEPARATOR_SHAKE	0x1F
+
 #define KECCAK_ROUNDS 24
 
 static const u64 keccakf_rndc[24] = {
@@ -218,6 +220,216 @@ static int crypto_sha3_finup(struct shash_desc *desc, const u8 *src,
 	return 0;
 }
 
+static int crypto_shake_init(struct shash_desc *desc)
+{
+	struct shake_state *sctx = shash_desc_ctx(desc);
+	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+
+	sctx->rsiz = 200 - 2 * digest_size;
+	sctx->rsizw = sctx->rsiz / 8;
+	sctx->partial = 0;
+	sctx->ridx = 0;
+	sctx->finalized = false;
+	sctx->permute = false;
+	memset(sctx->st, 0, sizeof(sctx->st));
+
+	return 0;
+}
+
+static int crypto_shake_update(struct shash_desc *desc, const u8 *data,
+			       unsigned int len)
+{
+	struct shake_state *sctx = shash_desc_ctx(desc);
+	unsigned int done;
+	const u8 *src;
+
+	done = 0;
+	src = data;
+
+	if ((sctx->partial + len) > (sctx->rsiz - 1)) {
+		if (sctx->partial) {
+			done = -sctx->partial;
+			memcpy(sctx->buf + sctx->partial, data,
+			       done + sctx->rsiz);
+			src = sctx->buf;
+		}
+
+		do {
+			unsigned int i;
+
+			for (i = 0; i < sctx->rsizw; i++)
+				sctx->st[i] ^= get_unaligned_le64(src + 8 * i);
+			keccakf(sctx->st);
+
+			done += sctx->rsiz;
+			src = data + done;
+		} while (done + (sctx->rsiz - 1) < len);
+
+		sctx->partial = 0;
+	}
+	memcpy(sctx->buf + sctx->partial, src, len - done);
+	sctx->partial += (len - done);
+
+	return 0;
+}
+
+/*
+ * crypto_shake_squeeze_blocks - squeeze whole blocks
+ *
+ * @sctx: shake context
+ * @out: pointer to output buffer pointer
+ * @nblocks: number of whole blocks to return in @out
+ */
+static void crypto_shake_squeeze_blocks(struct shake_state *sctx,
+					u8 **out, size_t nblocks)
+{
+	__le64 *digest = (__le64 *)*out;
+	size_t i, j;
+
+	for (i = 0; i < nblocks; i++) {
+		if (sctx->permute)
+			keccakf(sctx->st);
+		sctx->permute = true;
+
+		for (j = 0; j < sctx->rsiz / 8; j++)
+			put_unaligned_le64(sctx->st[j], digest++);
+	}
+	*out = (u8 *)digest;
+}
+
+/*
+ * crypto_shake_squeeze_bytes - squeeze arbitrary number of bytes
+ *
+ * @sctx: shake context
+ * @out: output buffer
+ * @n: number of bytes to return in @out
+ */
+static void crypto_shake_squeeze_bytes(struct shake_state *sctx,
+				       u8 *out, size_t n)
+{
+	size_t i, j, to_copy, loops, nblocks;
+	__le64 *digest;
+
+	if (sctx->permute) {
+		keccakf(sctx->st);
+		sctx->permute = false;
+	}
+
+	while (n) {
+		to_copy = min(8 - (sctx->ridx & 7), n);
+		while (to_copy < 8) {
+			for (i = sctx->ridx; i < sctx->ridx + to_copy; i++)
+				*out++ = sctx->st[i / 8] >> 8 * (i & 7);
+
+			sctx->ridx += to_copy;
+			n -= to_copy;
+			if (sctx->ridx == sctx->rsiz) {
+				sctx->ridx = 0;
+				if (n == 0) {
+					sctx->permute = true;
+					return;
+				}
+				keccakf(sctx->st);
+			}
+			if (n == 0)
+				return;
+			if (n >= 8)
+				break;
+			to_copy = n;
+		}
+		/* sctx->ridx is 8-byte aligned now */
+
+		if (sctx->ridx == 0 && n >= sctx->rsiz) {
+			/* whole blocks */
+			nblocks = n / sctx->rsiz;
+			crypto_shake_squeeze_blocks(sctx, &out, nblocks);
+			n -= nblocks * sctx->rsiz;
+			if (n == 0)
+				return;
+			keccakf(sctx->st);
+			sctx->permute = false;
+		}
+
+		to_copy = min(n, sctx->rsiz - sctx->ridx);
+		while (to_copy >= 8) {
+			loops = to_copy / 8;
+
+			digest = (__le64 *)out;
+
+			j = sctx->ridx / 8;
+			for (i = j; i < j + loops; i++)
+				put_unaligned_le64(sctx->st[i], digest++);
+
+			sctx->ridx += loops * 8;
+			n -= loops * 8;
+			if (sctx->ridx == sctx->rsiz) {
+				sctx->ridx = 0;
+				if (n == 0) {
+					sctx->permute = true;
+					return;
+				}
+				keccakf(sctx->st);
+			}
+			if (n == 0)
+				return;
+
+			out = (u8 *)digest;
+			if (n >= sctx->rsiz || n < 8)
+				break;
+
+			to_copy = n;
+		}
+	}
+}
+
+static void crypto_shake_finalize(struct shake_state *sctx,
+				  u8 domsep)
+{
+	unsigned int inlen, i;
+
+	if (sctx->finalized)
+		return;
+
+	inlen = sctx->partial;
+	sctx->buf[inlen++] = domsep;
+	memset(sctx->buf + inlen, 0, sctx->rsiz - inlen);
+	sctx->buf[sctx->rsiz - 1] |= 0x80;
+
+	for (i = 0; i < sctx->rsizw; i++)
+		sctx->st[i] ^= get_unaligned_le64(sctx->buf + 8 * i);
+
+	sctx->finalized = true;
+	sctx->permute = true;
+}
+
+static int crypto_shake_squeeze(struct shash_desc *desc,
+				u8 *out, size_t outlen,
+				bool final)
+{
+	struct shake_state *sctx = shash_desc_ctx(desc);
+
+	if (!outlen)
+		goto done;
+
+	if (!sctx->finalized)
+		crypto_shake_finalize(sctx, DOMAIN_SEPARATOR_SHAKE);
+
+	crypto_shake_squeeze_bytes(sctx, out, outlen);
+done:
+	if (final)
+		memset(sctx, 0, sizeof(*sctx));
+
+	return 0;
+}
+
+static int crypto_shake_final(struct shash_desc *desc, u8 *out)
+{
+	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+
+	return crypto_shake_squeeze(desc, out, digest_size, true);
+}
+
+
 static struct shash_alg algs[] = { {
 	.digestsize		= SHA3_224_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
@@ -262,6 +474,28 @@ static struct shash_alg algs[] = { {
 	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_512_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
+}, {
+	.digestsize		= SHAKE128_DIGEST_SIZE,
+	.init			= crypto_shake_init,
+	.update			= crypto_shake_update,
+	.final			= crypto_shake_final,
+	.squeeze		= crypto_shake_squeeze,
+	.descsize		= sizeof(struct shake_state),
+	.base.cra_name		= "shake128",
+	.base.cra_driver_name	= "shake128-generic",
+	.base.cra_blocksize	= SHAKE128_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
+}, {
+	.digestsize		= SHAKE256_DIGEST_SIZE,
+	.init			= crypto_shake_init,
+	.update			= crypto_shake_update,
+	.final			= crypto_shake_final,
+	.squeeze		= crypto_shake_squeeze,
+	.descsize		= sizeof(struct shake_state),
+	.base.cra_name		= "shake256",
+	.base.cra_driver_name	= "shake256-generic",
+	.base.cra_blocksize	= SHAKE256_BLOCK_SIZE,
+	.base.cra_module	= THIS_MODULE,
 } };
 
 static int __init sha3_generic_mod_init(void)
@@ -288,3 +522,7 @@ MODULE_ALIAS_CRYPTO("sha3-384");
 MODULE_ALIAS_CRYPTO("sha3-384-generic");
 MODULE_ALIAS_CRYPTO("sha3-512");
 MODULE_ALIAS_CRYPTO("sha3-512-generic");
+MODULE_ALIAS_CRYPTO("shake128");
+MODULE_ALIAS_CRYPTO("shake128-generic");
+MODULE_ALIAS_CRYPTO("shake256");
+MODULE_ALIAS_CRYPTO("shake256-generic");
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 188eface0a11..72c29dd1de9a 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -20,7 +20,7 @@
  * static buffers that are big enough for any combination of
  * algs and architectures. Ciphers have a lower maximum size.
  */
-#define MAX_ALGAPI_BLOCKSIZE		160
+#define MAX_ALGAPI_BLOCKSIZE		168 /* shake128 */
 #define MAX_ALGAPI_ALIGNMASK		127
 #define MAX_CIPHER_BLOCKSIZE		16
 #define MAX_CIPHER_ALIGNMASK		15
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 36b88d34c0dd..a94763913acf 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -177,14 +177,13 @@ struct shash_desc {
 
 #define HASH_MAX_DIGESTSIZE	 64
 
-/* Worst case is sha3-224. */
-#define HASH_MAX_STATESIZE	 200 + 144 + 1
+/* Worst case is shake128 */
+#define HASH_MAX_STATESIZE	 200 + 168 + 5 * 4 + 4
 
 /*
- * Worst case is hmac(sha3-224-s390).  Its context is a nested 'shash_desc'
- * containing a 'struct s390_sha_ctx'.
+ * Worst case is shake128
  */
-#define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 360)
+#define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 384)
 #define MAX_SYNC_HASH_REQSIZE	(sizeof(struct ahash_request) + \
 				 HASH_MAX_DESCSIZE)
 
diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
index 41e1b83a6d91..cc393d06a8da 100644
--- a/include/crypto/sha3.h
+++ b/include/crypto/sha3.h
@@ -33,4 +33,23 @@ struct sha3_state {
 
 int crypto_sha3_init(struct shash_desc *desc);
 
+
+#define SHAKE128_DIGEST_SIZE	(128 / 8)
+#define SHAKE128_BLOCK_SIZE	(200 - 2 * SHAKE128_DIGEST_SIZE)
+
+#define SHAKE256_DIGEST_SIZE	(256 / 8)
+#define SHAKE256_BLOCK_SIZE	(200 - 2 * SHAKE256_DIGEST_SIZE)
+
+struct shake_state {
+	u64		st[25];
+	unsigned int	rsiz;
+	unsigned int	rsizw;
+
+	unsigned int	partial;
+	u8		buf[SHAKE128_BLOCK_SIZE];
+	bool		finalized;
+	bool		permute;
+	unsigned int	ridx;
+};
+
 #endif
diff --git a/include/uapi/linux/hash_info.h b/include/uapi/linux/hash_info.h
index 0af23ec196d8..97af74326d31 100644
--- a/include/uapi/linux/hash_info.h
+++ b/include/uapi/linux/hash_info.h
@@ -38,6 +38,8 @@ enum hash_algo {
 	HASH_ALGO_SHA3_256,
 	HASH_ALGO_SHA3_384,
 	HASH_ALGO_SHA3_512,
+	HASH_ALGO_SHAKE128,
+	HASH_ALGO_SHAKE256,
 	HASH_ALGO__LAST
 };
 
-- 
2.49.0

