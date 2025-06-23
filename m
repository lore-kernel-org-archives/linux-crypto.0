Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134AC25394A;
	Mon, 23 Jun 2025 13:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684731; cv=none; b=L0kGGp1reKG4lJU1KLEDSSUv4CwHfaX61auXxSTd16IzXItRgqTsoOWwqNDl++h3m6bKxIRv10jt9fDFCLRs/HoUB+jWHQUNHoC9hmn1HYngHLq+LfAFHwRzAEVd2wvGfKZvmIOhJrQeUuBB3cV2qvoDP9kKL3zWwtFdU52zT3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684731; c=relaxed/simple;
	bh=ka7DOlStzpdl6AaErLxV2dkMbfEyCE7Z+4tBWDf+LTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ear215rgXGpSFNuNqBPx1gj1zbUPqU4vr563sIvwvxX+nwQigW40l5nYCT52cZ0UX4+1dBJaHkOHR2Z3jiHXlQNHgztrodJE8Sa+2nM3ZDnnb7hxIQJgok1py+TwcdEIkHEqsK6WEjwmKGJt+amCGt1PBPIOqFir55UhQdXf4AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MvG2wGML; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MvG2wGML"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55N9b28J019048;
	Mon, 23 Jun 2025 13:18:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=oowJ2zZXHBno6Zkk9
	BIfEe5BYDUDl+9umhi0sKVyiDU=; b=MvG2wGML7TVDt4c5DzpAL6KCc9R1Guidm
	+E9WRsarTLcoDWC8p/yz5UnPGSowsFh6S7NiXgP1lEWPH/STHUENZ9PGGj3OfiZb
	MQJFr0uT+kibf4zdv1nyO0tl7lHuOgkCEm9DR1gpR4c81lvGISy30f6pP2sb7EaS
	KBzK2T7vpDzu9RuWCJ1S24LsGIzBSVQLZNxa64ZiR+WXBENX6B4qIsJIPDGu7k1v
	N3kBz2oNo0VKnvOwaLAl9gJtquTZKEqBztDyzp/DloztG+P4BcafepXexzj52pVW
	Lxw7E+KqB7JSWF1f1XoL2F7CMlB7QOUYFzFC09QDcl9lh4wUYlhAg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47dmfe2568-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Jun 2025 13:18:43 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55NB1xou030552;
	Mon, 23 Jun 2025 13:18:42 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 47e7eypx70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Jun 2025 13:18:42 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55NDIaOw24511182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Jun 2025 13:18:37 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CAEBE58055;
	Mon, 23 Jun 2025 13:18:41 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 563D558043;
	Mon, 23 Jun 2025 13:18:41 +0000 (GMT)
Received: from sbct-3.pok.ibm.com (unknown [9.47.158.153])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 23 Jun 2025 13:18:41 +0000 (GMT)
From: Stefan Berger <stefanb@linux.ibm.com>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
        dhowells@redhat.com, simo@redhat.com,
        Stefan Berger <stefanb@linux.ibm.com>
Subject: [RFC PATCH 2/4] crypto: Add shake128/256 to generic sha3 module
Date: Mon, 23 Jun 2025 09:18:28 -0400
Message-ID: <20250623131830.2194643-3-stefanb@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623131830.2194643-1-stefanb@linux.ibm.com>
References: <20250623131830.2194643-1-stefanb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6-Ivb8M0WJMwJ9k8TeSmKnS0_sK2jo0d
X-Proofpoint-GUID: 6-Ivb8M0WJMwJ9k8TeSmKnS0_sK2jo0d
X-Authority-Analysis: v=2.4 cv=BpqdwZX5 c=1 sm=1 tr=0 ts=68595433 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=7PqV0hYhwxvHinq54jsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIzMDA4MCBTYWx0ZWRfXx/BMbpXcXIaX GUAwemxa2TYqkZNA9RPGw0nt/2VtmydJohPYx24oDTq5JEwxhO/WvDcKgYQ4TA7y+yew5XCQKSl xjllX6ewNWtY+fytUH8FnFJIymDxaLTUCBLikiF4QmpWO1Fytr+SqdUTVHKILSPTzpDKrg1KfPE
 M8Zmv8szc272QzhsxrM7DIdf642/L5ERPCCUPnpZSKunAz4CWxgXD1kDEOca8Ud+WqGNMEbMXhy 5ZA3rNmRlYtkI9SAg91o/pjEbjcj411ZZbjCLegpYGkJOxgaLflrhyNMncWTh89suo8a1txqixC jCm148ouHW2WHkg0+fChobqZZwcTDisGr1EwouLd/QDtncd7IS2nOCpIePdBikhJE6ToeHcHs2G
 u89fyLa42jDas5Bd8uB4bt6K4GKc1ZXd8q/PkewXTDQRFubfJpJAjENIxmK0pKMWCoqJWuzV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-23_03,2025-06-23_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506230080

Extend the sha3 module with shake128 & shake256. For this, implement
functions to get (squeeze) a number of bytes or blocks from the keccak
sponge. A block here corresponds to the number of bytes available in a
buffer following a keccak permutation. On top of this functionality,
implement the general squeeze function that returns a requested number of
bytes to the user. Implement the 'final' function on top of the squeeze
function. The 'final' function will always request a fixed number of bytes
from the squeeze function and set the 'final' parameter to true, clearing
the state of the hash as usual.

Adjust the maximum hash description and block sizes due to shake128.

Extend the arrays for supported hashes with entries for shake128 and
shake256.

Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
---
 crypto/hash_info.c             |   4 +
 crypto/sha3_generic.c          | 211 +++++++++++++++++++++++++++++++++
 include/crypto/algapi.h        |   2 +-
 include/crypto/hash.h          |   5 +-
 include/crypto/sha3.h          |  19 +++
 include/uapi/linux/hash_info.h |   2 +
 6 files changed, 239 insertions(+), 4 deletions(-)

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
index b103642b56ea..4782303527fe 100644
--- a/crypto/sha3_generic.c
+++ b/crypto/sha3_generic.c
@@ -29,6 +29,8 @@
 #define SHA3_INLINE	noinline
 #endif
 
+#define DOMAIN_SEPARATOR_SHAKE	0x1F
+
 #define KECCAK_ROUNDS 24
 
 static const u64 keccakf_rndc[24] = {
@@ -237,6 +239,189 @@ int crypto_sha3_final(struct shash_desc *desc, u8 *out)
 }
 EXPORT_SYMBOL(crypto_sha3_final);
 
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
+
+	memset(sctx->st, 0, sizeof(sctx->st));
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
+static void crypto_shake_squeeze_bytes(struct shake_state *sctx,
+				       u8 **out, size_t n)
+{
+	size_t i, to_copy, loops;
+	__le64 *digest;
+	u8 *_out = *out;
+
+	if (n == 0)
+		return;
+
+	BUG_ON(sctx->ridx + n > sctx->rsiz);
+
+	if (sctx->permute) {
+		keccakf(sctx->st);
+		sctx->permute = false;
+	}
+
+	while (n) {
+		to_copy = (n < 8) ? n : 8 - (sctx->ridx & 7);
+		if (to_copy < 8) {
+			for (i = sctx->ridx; i < sctx->ridx + to_copy; i++)
+				*_out++ = sctx->st[i / 8] >> 8 * (i & 7);
+
+			sctx->ridx += to_copy;
+			n -= to_copy;
+			if (n == 0)
+				break;
+		}
+
+		BUG_ON((sctx->ridx & 7) != 0);
+		digest = (__le64 *)_out;
+		loops = n / 8;
+		for (i = sctx->ridx / 8; i < (sctx->ridx / 8) + loops; i++)
+			put_unaligned_le64(sctx->st[i], digest++);
+
+		sctx->ridx += 8 * loops;
+		n -= 8 * loops;
+		_out = (u8 *)digest;
+	}
+
+	if (sctx->ridx == sctx->rsiz) {
+		sctx->ridx = 0;
+		sctx->permute = true;
+	}
+	*out = _out;
+}
+
+static void crypto_shake_squeeze_blocks(struct shake_state *sctx,
+					u8 **out, size_t nblocks)
+{
+	__le64 *digest = (__le64 *)*out;
+	size_t i, j;
+
+	BUG_ON(sctx->ridx != 0);
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
+	size_t nblocks, to_copy;
+
+	if (!sctx->finalized)
+		crypto_shake_finalize(sctx, DOMAIN_SEPARATOR_SHAKE);
+
+	if (sctx->ridx > 0) {
+		to_copy = min(outlen, sctx->rsiz - sctx->ridx);
+
+		crypto_shake_squeeze_bytes(sctx, &out, to_copy);
+		outlen -= to_copy;
+		if (outlen == 0)
+			goto done;
+	}
+
+	nblocks = outlen / sctx->rsiz;
+	if (nblocks) {
+		crypto_shake_squeeze_blocks(sctx, &out, nblocks);
+		outlen -= nblocks * sctx->rsiz;
+	}
+
+	crypto_shake_squeeze_bytes(sctx, &out, outlen);
+
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
+	crypto_shake_squeeze(desc, out, digest_size, true);
+
+	return 0;
+}
+
+
 static struct shash_alg algs[] = { {
 	.digestsize		= SHA3_224_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
@@ -277,6 +462,28 @@ static struct shash_alg algs[] = { {
 	.base.cra_driver_name	= "sha3-512-generic",
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
@@ -303,3 +510,7 @@ MODULE_ALIAS_CRYPTO("sha3-384");
 MODULE_ALIAS_CRYPTO("sha3-384-generic");
 MODULE_ALIAS_CRYPTO("sha3-512");
 MODULE_ALIAS_CRYPTO("sha3-512-generic");
+MODULE_ALIAS_CRYPTO("shake128");
+MODULE_ALIAS_CRYPTO("shake128-generic");
+MODULE_ALIAS_CRYPTO("shake256");
+MODULE_ALIAS_CRYPTO("shake256-generic");
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 6e07bbc04089..be30f895fe7b 100644
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
index 9072652e8e60..5d69c2d69b96 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -166,10 +166,9 @@ struct shash_desc {
 #define HASH_MAX_DIGESTSIZE	 64
 
 /*
- * Worst case is hmac(sha3-224-generic).  Its context is a nested 'shash_desc'
- * containing a 'struct sha3_state'.
+ * Worst case is shake128
  */
-#define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 360)
+#define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 384)
 
 #define SHASH_DESC_ON_STACK(shash, ctx)					     \
 	char __##shash##_desc[sizeof(struct shash_desc) + HASH_MAX_DESCSIZE] \
diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
index 080f60c2e6b1..d99d2bfbd27f 100644
--- a/include/crypto/sha3.h
+++ b/include/crypto/sha3.h
@@ -31,4 +31,23 @@ int crypto_sha3_update(struct shash_desc *desc, const u8 *data,
 		       unsigned int len);
 int crypto_sha3_final(struct shash_desc *desc, u8 *out);
 
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

