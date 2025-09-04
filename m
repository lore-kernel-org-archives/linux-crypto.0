Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CCE28152D;
	Thu,  4 Sep 2025 15:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001517; cv=none; b=oWl5Db+L/VGVaimeDIo975yRzIClyk4064WumtYpVpgrpFtX16An3QdoPXRgAUzlXTJVg/I07wcMeq233RtcFP4uhZT3yUdbLUtszXzV4UerRQsFXIgc6NDibUJL/jkdvHvcOmN9hMEh3ibfYy2sLdeUv8lDc0c+kDs+MTqwhm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001517; c=relaxed/simple;
	bh=dxM6aXaYuKnCprj+qNWT3hAMpBUVEAnDHlo9ZuoDm2E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PCBkf6qVEwv+8Q/rLgMDtYFVSBgYD0xpWKg+owU8owTVqmGpikAnl7rESJXPQm4kbG1WmuqAsB+kAbMepKtJh5ndN/JgR3vgq9A7J3scKlt0kRAbeoPM0bPUrvnnIBJFy93qOEZbFvCTDZsxyJcMQBVfMzpnYeQj6lARZAcVwc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eZZBtejF; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eZZBtejF"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtiGZ026687;
	Thu, 4 Sep 2025 15:58:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=LJG2M
	PFjWU1S7gGXYk2ybmGCpR2i6txPIV7a9Is105I=; b=eZZBtejFJETNL5NmehVBg
	P/0UdSNQMaXJVfBhiBcx3RLzJX6XIzqVNcTCLHqT81A9tyQN4zE7pq5jt8gv5ZWH
	L6+S4+/2P2F0wZH3RhhL/SkzpMvbx4TRRPuGL+FwkPTlJQtDm14qocWHrHQL/0Db
	h45LKK5axucvX4RG7NvETMZBrVUzS5imKCK4XENayoB8o851snsPewjyjNUNXCR/
	/Rgb7XRsZTA/SE2BDDrW+vU8UGxfvpx0r8tTgl5rZt6NC0aMo+cgltTHXpQjzNev
	vPozK677m3EDQGRRnruFJ/WcKHj7EEK53I4rkq2d1kczGLvYTdbRXLF3wU5xTJ/M
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yd10050q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FjIVR040126;
	Thu, 4 Sep 2025 15:58:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtpp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:58:20 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx6O000707;
	Thu, 4 Sep 2025 15:58:19 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-49;
	Thu, 04 Sep 2025 15:58:19 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH RFC 048/104] crypto: fips140: convert crypto/ecc.c to using crypto API wrappers
Date: Thu,  4 Sep 2025 17:51:20 +0200
Message-Id: <20250904155216.460962-49-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040157
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE0OCBTYWx0ZWRfX5KVVUTKt5tBc
 xzt09kq0FFczsHoNqupZOSYGhOkkhQErskopupnzRNx9JyqunrR2on/qwHz/KI8bO6Eb9SQXTQS
 db+OMIoJk8CpwcEtdONboezJDtnhjFjNBBH30cgOskY8E9mVDZ9Vw82g5OnNnWZFCfWCMb1bjlw
 RGMRoSgMuowOqPe/ALDSm42dt31q4GgUPWFHjsdT7UqbO2qXrK9jRd5rQIxyRjiCTS01XAgNFFK
 yYmszByFe7nS3o7KxuxgIi76Xz+PKN+kbuGsO9qgKWmQuZqQ6ODKnDt4YwqetWT06LWV/Bk/ipu
 2NxkrMiOoNkL01tpYsXHpf6oEAPCpVlaVJ1vqzGjdRDFUTdo8ZTRUVcYKKtz2Ou/DwX2PjLzMKK
 g18ATHSVXxZHmtccZq9hq75k4K3e4A==
X-Authority-Analysis: v=2.4 cv=CbkI5Krl c=1 sm=1 tr=0 ts=68b9b71d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=VvWRDUFFAAAA:8 a=tVQzEk6zC8MWz7QylOEA:9
 a=SwlHTeVR8cTTWBXPrjoE:22 cc=ntf awl=host:12068
X-Proofpoint-ORIG-GUID: D91cnhZNARwYLoEq46CthEqCt3Urun36
X-Proofpoint-GUID: D91cnhZNARwYLoEq46CthEqCt3Urun36

Use CRYPTO_API() etc. from include/crypto/api.h in preparation for
compilation as part of support for FIPS 140 standalone modules.

Generated using:

  ./fipsify.py --config CONFIG_CRYPTO_ECC --source crypto/ecc.c --header include/crypto/ecc_curve.h include/crypto/internal/ecc.h

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/ecc.c                  | 84 ++++++++++++++++----------------
 crypto/fips140-api.c          | 34 +++++++++++++
 include/crypto/ecc_curve.h    |  9 +++-
 include/crypto/internal/ecc.h | 91 ++++++++++++++++++++++-------------
 4 files changed, 141 insertions(+), 77 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index c9f82626177b..b28832e1aaea 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -44,13 +44,13 @@ typedef struct {
 } uint128_t;
 
 /* Returns curv25519 curve param */
-const struct ecc_curve *ecc_get_curve25519(void)
+const struct ecc_curve *CRYPTO_API(ecc_get_curve25519)(void)
 {
 	return &ecc_25519;
 }
-EXPORT_SYMBOL(ecc_get_curve25519);
+DEFINE_CRYPTO_API(ecc_get_curve25519);
 
-const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
+const struct ecc_curve *CRYPTO_API(ecc_get_curve)(unsigned int curve_id)
 {
 	switch (curve_id) {
 	/* In FIPS mode only allow P256 and higher */
@@ -66,9 +66,9 @@ const struct ecc_curve *ecc_get_curve(unsigned int curve_id)
 		return NULL;
 	}
 }
-EXPORT_SYMBOL(ecc_get_curve);
+DEFINE_CRYPTO_API(ecc_get_curve);
 
-void ecc_digits_from_bytes(const u8 *in, unsigned int nbytes,
+void CRYPTO_API(ecc_digits_from_bytes)(const u8 *in, unsigned int nbytes,
 			   u64 *out, unsigned int ndigits)
 {
 	int diff = ndigits - DIV_ROUND_UP_POW2(nbytes, sizeof(u64));
@@ -88,7 +88,7 @@ void ecc_digits_from_bytes(const u8 *in, unsigned int nbytes,
 	}
 	ecc_swap_digits(in, out, ndigits);
 }
-EXPORT_SYMBOL(ecc_digits_from_bytes);
+DEFINE_CRYPTO_API(ecc_digits_from_bytes);
 
 static u64 *ecc_alloc_digits_space(unsigned int ndigits)
 {
@@ -105,7 +105,7 @@ static void ecc_free_digits_space(u64 *space)
 	kfree_sensitive(space);
 }
 
-struct ecc_point *ecc_alloc_point(unsigned int ndigits)
+struct ecc_point *CRYPTO_API(ecc_alloc_point)(unsigned int ndigits)
 {
 	struct ecc_point *p = kmalloc(sizeof(*p), GFP_KERNEL);
 
@@ -130,9 +130,9 @@ struct ecc_point *ecc_alloc_point(unsigned int ndigits)
 	kfree(p);
 	return NULL;
 }
-EXPORT_SYMBOL(ecc_alloc_point);
+DEFINE_CRYPTO_API(ecc_alloc_point);
 
-void ecc_free_point(struct ecc_point *p)
+void CRYPTO_API(ecc_free_point)(struct ecc_point *p)
 {
 	if (!p)
 		return;
@@ -141,7 +141,7 @@ void ecc_free_point(struct ecc_point *p)
 	kfree_sensitive(p->y);
 	kfree_sensitive(p);
 }
-EXPORT_SYMBOL(ecc_free_point);
+DEFINE_CRYPTO_API(ecc_free_point);
 
 static void vli_clear(u64 *vli, unsigned int ndigits)
 {
@@ -152,7 +152,7 @@ static void vli_clear(u64 *vli, unsigned int ndigits)
 }
 
 /* Returns true if vli == 0, false otherwise. */
-bool vli_is_zero(const u64 *vli, unsigned int ndigits)
+bool CRYPTO_API(vli_is_zero)(const u64 *vli, unsigned int ndigits)
 {
 	int i;
 
@@ -163,7 +163,7 @@ bool vli_is_zero(const u64 *vli, unsigned int ndigits)
 
 	return true;
 }
-EXPORT_SYMBOL(vli_is_zero);
+DEFINE_CRYPTO_API(vli_is_zero);
 
 /* Returns nonzero if bit of vli is set. */
 static u64 vli_test_bit(const u64 *vli, unsigned int bit)
@@ -191,7 +191,7 @@ static unsigned int vli_num_digits(const u64 *vli, unsigned int ndigits)
 }
 
 /* Counts the number of bits required for vli. */
-unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits)
+unsigned int CRYPTO_API(vli_num_bits)(const u64 *vli, unsigned int ndigits)
 {
 	unsigned int i, num_digits;
 	u64 digit;
@@ -206,10 +206,10 @@ unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits)
 
 	return ((num_digits - 1) * 64 + i);
 }
-EXPORT_SYMBOL(vli_num_bits);
+DEFINE_CRYPTO_API(vli_num_bits);
 
 /* Set dest from unaligned bit string src. */
-void vli_from_be64(u64 *dest, const void *src, unsigned int ndigits)
+void CRYPTO_API(vli_from_be64)(u64 *dest, const void *src, unsigned int ndigits)
 {
 	int i;
 	const u64 *from = src;
@@ -217,9 +217,9 @@ void vli_from_be64(u64 *dest, const void *src, unsigned int ndigits)
 	for (i = 0; i < ndigits; i++)
 		dest[i] = get_unaligned_be64(&from[ndigits - 1 - i]);
 }
-EXPORT_SYMBOL(vli_from_be64);
+DEFINE_CRYPTO_API(vli_from_be64);
 
-void vli_from_le64(u64 *dest, const void *src, unsigned int ndigits)
+void CRYPTO_API(vli_from_le64)(u64 *dest, const void *src, unsigned int ndigits)
 {
 	int i;
 	const u64 *from = src;
@@ -227,7 +227,7 @@ void vli_from_le64(u64 *dest, const void *src, unsigned int ndigits)
 	for (i = 0; i < ndigits; i++)
 		dest[i] = get_unaligned_le64(&from[i]);
 }
-EXPORT_SYMBOL(vli_from_le64);
+DEFINE_CRYPTO_API(vli_from_le64);
 
 /* Sets dest = src. */
 static void vli_set(u64 *dest, const u64 *src, unsigned int ndigits)
@@ -239,7 +239,7 @@ static void vli_set(u64 *dest, const u64 *src, unsigned int ndigits)
 }
 
 /* Returns sign of left - right. */
-int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits)
+int CRYPTO_API(vli_cmp)(const u64 *left, const u64 *right, unsigned int ndigits)
 {
 	int i;
 
@@ -252,7 +252,7 @@ int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits)
 
 	return 0;
 }
-EXPORT_SYMBOL(vli_cmp);
+DEFINE_CRYPTO_API(vli_cmp);
 
 /* Computes result = in << c, returning carry. Can modify in place
  * (if result == in). 0 < shift < 64.
@@ -331,7 +331,7 @@ static u64 vli_uadd(u64 *result, const u64 *left, u64 right,
 }
 
 /* Computes result = left - right, returning borrow. Can modify in place. */
-u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
+u64 CRYPTO_API(vli_sub)(u64 *result, const u64 *left, const u64 *right,
 		   unsigned int ndigits)
 {
 	u64 borrow = 0;
@@ -349,7 +349,7 @@ u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
 
 	return borrow;
 }
-EXPORT_SYMBOL(vli_sub);
+DEFINE_CRYPTO_API(vli_sub);
 
 /* Computes result = left - right, returning borrow. Can modify in place. */
 static u64 vli_usub(u64 *result, const u64 *left, u64 right,
@@ -1001,7 +1001,7 @@ static bool vli_mmod_fast(u64 *result, u64 *product,
 /* Computes result = (left * right) % mod.
  * Assumes that mod is big enough curve order.
  */
-void vli_mod_mult_slow(u64 *result, const u64 *left, const u64 *right,
+void CRYPTO_API(vli_mod_mult_slow)(u64 *result, const u64 *left, const u64 *right,
 		       const u64 *mod, unsigned int ndigits)
 {
 	u64 product[ECC_MAX_DIGITS * 2];
@@ -1009,7 +1009,7 @@ void vli_mod_mult_slow(u64 *result, const u64 *left, const u64 *right,
 	vli_mult(product, left, right, ndigits);
 	vli_mmod_slow(result, product, mod, ndigits);
 }
-EXPORT_SYMBOL(vli_mod_mult_slow);
+DEFINE_CRYPTO_API(vli_mod_mult_slow);
 
 /* Computes result = (left * right) % curve_prime. */
 static void vli_mod_mult_fast(u64 *result, const u64 *left, const u64 *right,
@@ -1036,7 +1036,7 @@ static void vli_mod_square_fast(u64 *result, const u64 *left,
  * See "From Euclid's GCD to Montgomery Multiplication to the Great Divide"
  * https://labs.oracle.com/techrep/2001/smli_tr-2001-95.pdf
  */
-void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
+void CRYPTO_API(vli_mod_inv)(u64 *result, const u64 *input, const u64 *mod,
 			unsigned int ndigits)
 {
 	u64 a[ECC_MAX_DIGITS], b[ECC_MAX_DIGITS];
@@ -1109,17 +1109,17 @@ void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
 
 	vli_set(result, u, ndigits);
 }
-EXPORT_SYMBOL(vli_mod_inv);
+DEFINE_CRYPTO_API(vli_mod_inv);
 
 /* ------ Point operations ------ */
 
 /* Returns true if p_point is the point at infinity, false otherwise. */
-bool ecc_point_is_zero(const struct ecc_point *point)
+bool CRYPTO_API(ecc_point_is_zero)(const struct ecc_point *point)
 {
 	return (vli_is_zero(point->x, point->ndigits) &&
 		vli_is_zero(point->y, point->ndigits));
 }
-EXPORT_SYMBOL(ecc_point_is_zero);
+DEFINE_CRYPTO_API(ecc_point_is_zero);
 
 /* Point multiplication algorithm using Montgomery's ladder with co-Z
  * coordinates. From https://eprint.iacr.org/2011/338.pdf
@@ -1411,7 +1411,7 @@ static void ecc_point_add(const struct ecc_point *result,
 /* Computes R = u1P + u2Q mod p using Shamir's trick.
  * Based on: Kenneth MacKay's micro-ecc (2014).
  */
-void ecc_point_mult_shamir(const struct ecc_point *result,
+void CRYPTO_API(ecc_point_mult_shamir)(const struct ecc_point *result,
 			   const u64 *u1, const struct ecc_point *p,
 			   const u64 *u2, const struct ecc_point *q,
 			   const struct ecc_curve *curve)
@@ -1466,7 +1466,7 @@ void ecc_point_mult_shamir(const struct ecc_point *result,
 	vli_mod_inv(z, z, curve->p, ndigits);
 	apply_z(rx, ry, z, curve);
 }
-EXPORT_SYMBOL(ecc_point_mult_shamir);
+DEFINE_CRYPTO_API(ecc_point_mult_shamir);
 
 /*
  * This function performs checks equivalent to Appendix A.4.2 of FIPS 186-5.
@@ -1497,7 +1497,7 @@ static int __ecc_is_key_valid(const struct ecc_curve *curve,
 	return 0;
 }
 
-int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
+int CRYPTO_API(ecc_is_key_valid)(unsigned int curve_id, unsigned int ndigits,
 		     const u64 *private_key, unsigned int private_key_len)
 {
 	int nbytes;
@@ -1510,7 +1510,7 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 
 	return __ecc_is_key_valid(curve, private_key, ndigits);
 }
-EXPORT_SYMBOL(ecc_is_key_valid);
+DEFINE_CRYPTO_API(ecc_is_key_valid);
 
 /*
  * ECC private keys are generated using the method of rejection sampling,
@@ -1519,7 +1519,7 @@ EXPORT_SYMBOL(ecc_is_key_valid);
  * This method generates a private key uniformly distributed in the range
  * [2, n-3].
  */
-int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits,
+int CRYPTO_API(ecc_gen_privkey)(unsigned int curve_id, unsigned int ndigits,
 		    u64 *private_key)
 {
 	const struct ecc_curve *curve = ecc_get_curve(curve_id);
@@ -1561,9 +1561,9 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits,
 
 	return 0;
 }
-EXPORT_SYMBOL(ecc_gen_privkey);
+DEFINE_CRYPTO_API(ecc_gen_privkey);
 
-int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
+int CRYPTO_API(ecc_make_pub_key)(unsigned int curve_id, unsigned int ndigits,
 		     const u64 *private_key, u64 *public_key)
 {
 	int ret = 0;
@@ -1597,10 +1597,10 @@ int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 out:
 	return ret;
 }
-EXPORT_SYMBOL(ecc_make_pub_key);
+DEFINE_CRYPTO_API(ecc_make_pub_key);
 
 /* SP800-56A section 5.6.2.3.4 partial verification: ephemeral keys only */
-int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
+int CRYPTO_API(ecc_is_pubkey_valid_partial)(const struct ecc_curve *curve,
 				struct ecc_point *pk)
 {
 	u64 yy[ECC_MAX_DIGITS], xxx[ECC_MAX_DIGITS], w[ECC_MAX_DIGITS];
@@ -1630,10 +1630,10 @@ int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
 
 	return 0;
 }
-EXPORT_SYMBOL(ecc_is_pubkey_valid_partial);
+DEFINE_CRYPTO_API(ecc_is_pubkey_valid_partial);
 
 /* SP800-56A section 5.6.2.3.3 full verification */
-int ecc_is_pubkey_valid_full(const struct ecc_curve *curve,
+int CRYPTO_API(ecc_is_pubkey_valid_full)(const struct ecc_curve *curve,
 			     struct ecc_point *pk)
 {
 	struct ecc_point *nQ;
@@ -1657,9 +1657,9 @@ int ecc_is_pubkey_valid_full(const struct ecc_curve *curve,
 
 	return ret;
 }
-EXPORT_SYMBOL(ecc_is_pubkey_valid_full);
+DEFINE_CRYPTO_API(ecc_is_pubkey_valid_full);
 
-int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
+int CRYPTO_API(crypto_ecdh_shared_secret)(unsigned int curve_id, unsigned int ndigits,
 			      const u64 *private_key, const u64 *public_key,
 			      u64 *secret)
 {
@@ -1713,7 +1713,7 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 out:
 	return ret;
 }
-EXPORT_SYMBOL(crypto_ecdh_shared_secret);
+DEFINE_CRYPTO_API(crypto_ecdh_shared_secret);
 
 MODULE_DESCRIPTION("core elliptic curve module");
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/crypto/fips140-api.c b/crypto/fips140-api.c
index 600c759cbc5e..f236b302c2a7 100644
--- a/crypto/fips140-api.c
+++ b/crypto/fips140-api.c
@@ -363,3 +363,37 @@ DEFINE_CRYPTO_API_STUB(crypto_dh_decode_key);
 
 #endif
 
+/*
+ * crypto/ecc.c
+ */
+#if !IS_BUILTIN(CONFIG_CRYPTO_ECC)
+
+#include <crypto/ecc_curve.h>
+
+DEFINE_CRYPTO_API_STUB(ecc_get_curve);
+DEFINE_CRYPTO_API_STUB(ecc_get_curve25519);
+
+#include <crypto/internal/ecc.h>
+
+DEFINE_CRYPTO_API_STUB(ecc_digits_from_bytes);
+DEFINE_CRYPTO_API_STUB(ecc_is_key_valid);
+DEFINE_CRYPTO_API_STUB(ecc_gen_privkey);
+DEFINE_CRYPTO_API_STUB(ecc_make_pub_key);
+DEFINE_CRYPTO_API_STUB(crypto_ecdh_shared_secret);
+DEFINE_CRYPTO_API_STUB(ecc_is_pubkey_valid_partial);
+DEFINE_CRYPTO_API_STUB(ecc_is_pubkey_valid_full);
+DEFINE_CRYPTO_API_STUB(vli_is_zero);
+DEFINE_CRYPTO_API_STUB(vli_cmp);
+DEFINE_CRYPTO_API_STUB(vli_sub);
+DEFINE_CRYPTO_API_STUB(vli_from_be64);
+DEFINE_CRYPTO_API_STUB(vli_from_le64);
+DEFINE_CRYPTO_API_STUB(vli_mod_inv);
+DEFINE_CRYPTO_API_STUB(vli_mod_mult_slow);
+DEFINE_CRYPTO_API_STUB(vli_num_bits);
+DEFINE_CRYPTO_API_STUB(ecc_alloc_point);
+DEFINE_CRYPTO_API_STUB(ecc_free_point);
+DEFINE_CRYPTO_API_STUB(ecc_point_is_zero);
+DEFINE_CRYPTO_API_STUB(ecc_point_mult_shamir);
+
+#endif
+
diff --git a/include/crypto/ecc_curve.h b/include/crypto/ecc_curve.h
index 7d90c5e82266..547cb82517bf 100644
--- a/include/crypto/ecc_curve.h
+++ b/include/crypto/ecc_curve.h
@@ -4,6 +4,7 @@
 #ifndef _CRYTO_ECC_CURVE_H
 #define _CRYTO_ECC_CURVE_H
 
+#include <crypto/api.h>
 #include <linux/types.h>
 
 /**
@@ -50,13 +51,17 @@ struct ecc_curve {
  *
  * Returns curve if get curve succssful, NULL otherwise
  */
-const struct ecc_curve *ecc_get_curve(unsigned int curve_id);
+DECLARE_CRYPTO_API(ecc_get_curve, const struct ecc_curve *,
+	(unsigned int curve_id),
+	(curve_id));
 
 /**
  * ecc_get_curve25519() - get curve25519 curve;
  *
  * Returns curve25519
  */
-const struct ecc_curve *ecc_get_curve25519(void);
+DECLARE_CRYPTO_API(ecc_get_curve25519, const struct ecc_curve *,
+	(void),
+	());
 
 #endif
diff --git a/include/crypto/internal/ecc.h b/include/crypto/internal/ecc.h
index 57cd75242141..906d1443de96 100644
--- a/include/crypto/internal/ecc.h
+++ b/include/crypto/internal/ecc.h
@@ -26,6 +26,7 @@
 #ifndef _CRYPTO_ECC_H
 #define _CRYPTO_ECC_H
 
+#include <crypto/api.h>
 #include <crypto/ecc_curve.h>
 #include <linux/unaligned.h>
 
@@ -79,8 +80,9 @@ static inline void ecc_swap_digits(const void *in, u64 *out, unsigned int ndigit
  * The first byte in the input byte array is expected to hold the most
  * significant bits of the large integer.
  */
-void ecc_digits_from_bytes(const u8 *in, unsigned int nbytes,
-			   u64 *out, unsigned int ndigits);
+DECLARE_CRYPTO_API(ecc_digits_from_bytes, void,
+	(const u8 *in, unsigned int nbytes, u64 *out, unsigned int ndigits),
+	(in, nbytes, out, ndigits));
 
 /**
  * ecc_is_key_valid() - Validate a given ECDH private key
@@ -92,8 +94,9 @@ void ecc_digits_from_bytes(const u8 *in, unsigned int nbytes,
  *
  * Returns 0 if the key is acceptable, a negative value otherwise
  */
-int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
-		     const u64 *private_key, unsigned int private_key_len);
+DECLARE_CRYPTO_API(ecc_is_key_valid, int,
+	(unsigned int curve_id, unsigned int ndigits, const u64 *private_key, unsigned int private_key_len),
+	(curve_id, ndigits, private_key, private_key_len));
 
 /**
  * ecc_gen_privkey() -  Generates an ECC private key.
@@ -107,8 +110,9 @@ int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
  * Returns 0 if the private key was generated successfully, a negative value
  * if an error occurred.
  */
-int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits,
-		    u64 *private_key);
+DECLARE_CRYPTO_API(ecc_gen_privkey, int,
+	(unsigned int curve_id, unsigned int ndigits, u64 *private_key),
+	(curve_id, ndigits, private_key));
 
 /**
  * ecc_make_pub_key() - Compute an ECC public key
@@ -121,8 +125,9 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits,
  * Returns 0 if the public key was generated successfully, a negative value
  * if an error occurred.
  */
-int ecc_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
-		     const u64 *private_key, u64 *public_key);
+DECLARE_CRYPTO_API(ecc_make_pub_key, int,
+	(const unsigned int curve_id, unsigned int ndigits, const u64 *private_key, u64 *public_key),
+	(curve_id, ndigits, private_key, public_key));
 
 /**
  * crypto_ecdh_shared_secret() - Compute a shared secret
@@ -139,9 +144,9 @@ int ecc_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
  * Returns 0 if the shared secret was generated successfully, a negative value
  * if an error occurred.
  */
-int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
-			      const u64 *private_key, const u64 *public_key,
-			      u64 *secret);
+DECLARE_CRYPTO_API(crypto_ecdh_shared_secret, int,
+	(unsigned int curve_id, unsigned int ndigits, const u64 *private_key, const u64 *public_key, u64 *secret),
+	(curve_id, ndigits, private_key, public_key, secret));
 
 /**
  * ecc_is_pubkey_valid_partial() - Partial public key validation
@@ -157,8 +162,9 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
  *
  * Return: 0 if validation is successful, -EINVAL if validation is failed.
  */
-int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
-				struct ecc_point *pk);
+DECLARE_CRYPTO_API(ecc_is_pubkey_valid_partial, int,
+	(const struct ecc_curve *curve, struct ecc_point *pk),
+	(curve, pk));
 
 /**
  * ecc_is_pubkey_valid_full() - Full public key validation
@@ -171,8 +177,9 @@ int ecc_is_pubkey_valid_partial(const struct ecc_curve *curve,
  *
  * Return: 0 if validation is successful, -EINVAL if validation is failed.
  */
-int ecc_is_pubkey_valid_full(const struct ecc_curve *curve,
-			     struct ecc_point *pk);
+DECLARE_CRYPTO_API(ecc_is_pubkey_valid_full, int,
+	(const struct ecc_curve *curve, struct ecc_point *pk),
+	(curve, pk));
 
 /**
  * vli_is_zero() - Determine is vli is zero
@@ -180,7 +187,9 @@ int ecc_is_pubkey_valid_full(const struct ecc_curve *curve,
  * @vli:		vli to check.
  * @ndigits:		length of the @vli
  */
-bool vli_is_zero(const u64 *vli, unsigned int ndigits);
+DECLARE_CRYPTO_API(vli_is_zero, bool,
+	(const u64 *vli, unsigned int ndigits),
+	(vli, ndigits));
 
 /**
  * vli_cmp() - compare left and right vlis
@@ -192,7 +201,9 @@ bool vli_is_zero(const u64 *vli, unsigned int ndigits);
  * Returns sign of @left - @right, i.e. -1 if @left < @right,
  * 0 if @left == @right, 1 if @left > @right.
  */
-int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits);
+DECLARE_CRYPTO_API(vli_cmp, int,
+	(const u64 *left, const u64 *right, unsigned int ndigits),
+	(left, right, ndigits));
 
 /**
  * vli_sub() - Subtracts right from left
@@ -206,8 +217,9 @@ int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits);
  *
  * Return: carry bit.
  */
-u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
-	    unsigned int ndigits);
+DECLARE_CRYPTO_API(vli_sub, u64,
+	(u64 *result, const u64 *left, const u64 *right, unsigned int ndigits),
+	(result, left, right, ndigits));
 
 /**
  * vli_from_be64() - Load vli from big-endian u64 array
@@ -216,7 +228,9 @@ u64 vli_sub(u64 *result, const u64 *left, const u64 *right,
  * @src:		source array of u64 BE values
  * @ndigits:		length of both vli and array
  */
-void vli_from_be64(u64 *dest, const void *src, unsigned int ndigits);
+DECLARE_CRYPTO_API(vli_from_be64, void,
+	(u64 *dest, const void *src, unsigned int ndigits),
+	(dest, src, ndigits));
 
 /**
  * vli_from_le64() - Load vli from little-endian u64 array
@@ -225,7 +239,9 @@ void vli_from_be64(u64 *dest, const void *src, unsigned int ndigits);
  * @src:		source array of u64 LE values
  * @ndigits:		length of both vli and array
  */
-void vli_from_le64(u64 *dest, const void *src, unsigned int ndigits);
+DECLARE_CRYPTO_API(vli_from_le64, void,
+	(u64 *dest, const void *src, unsigned int ndigits),
+	(dest, src, ndigits));
 
 /**
  * vli_mod_inv() - Modular inversion
@@ -235,8 +251,9 @@ void vli_from_le64(u64 *dest, const void *src, unsigned int ndigits);
  * @mod:		modulus
  * @ndigits:		length of all vlis
  */
-void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
-		 unsigned int ndigits);
+DECLARE_CRYPTO_API(vli_mod_inv, void,
+	(u64 *result, const u64 *input, const u64 *mod, unsigned int ndigits),
+	(result, input, mod, ndigits));
 
 /**
  * vli_mod_mult_slow() - Modular multiplication
@@ -249,8 +266,9 @@ void vli_mod_inv(u64 *result, const u64 *input, const u64 *mod,
  *
  * Note: Assumes that mod is big enough curve order.
  */
-void vli_mod_mult_slow(u64 *result, const u64 *left, const u64 *right,
-		       const u64 *mod, unsigned int ndigits);
+DECLARE_CRYPTO_API(vli_mod_mult_slow, void,
+	(u64 *result, const u64 *left, const u64 *right, const u64 *mod, unsigned int ndigits),
+	(result, left, right, mod, ndigits));
 
 /**
  * vli_num_bits() - Counts the number of bits required for vli.
@@ -260,7 +278,9 @@ void vli_mod_mult_slow(u64 *result, const u64 *left, const u64 *right,
  *
  * Return: The number of bits required to represent @vli.
  */
-unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits);
+DECLARE_CRYPTO_API(vli_num_bits, unsigned int,
+	(const u64 *vli, unsigned int ndigits),
+	(vli, ndigits));
 
 /**
  * ecc_aloc_point() - Allocate ECC point.
@@ -269,14 +289,18 @@ unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits);
  *
  * Return: Pointer to the allocated point or NULL if allocation failed.
  */
-struct ecc_point *ecc_alloc_point(unsigned int ndigits);
+DECLARE_CRYPTO_API(ecc_alloc_point, struct ecc_point *,
+	(unsigned int ndigits),
+	(ndigits));
 
 /**
  * ecc_free_point() - Free ECC point.
  *
  * @p:			The point to free.
  */
-void ecc_free_point(struct ecc_point *p);
+DECLARE_CRYPTO_API(ecc_free_point, void,
+	(struct ecc_point *p),
+	(p));
 
 /**
  * ecc_point_is_zero() - Check if point is zero.
@@ -285,7 +309,9 @@ void ecc_free_point(struct ecc_point *p);
  *
  * Return: true if point is the point at infinity, false otherwise.
  */
-bool ecc_point_is_zero(const struct ecc_point *point);
+DECLARE_CRYPTO_API(ecc_point_is_zero, bool,
+	(const struct ecc_point *point),
+	(point));
 
 /**
  * ecc_point_mult_shamir() - Add two points multiplied by scalars
@@ -300,10 +326,9 @@ bool ecc_point_is_zero(const struct ecc_point *point);
  * Returns result = x * p + x * q over the curve.
  * This works faster than two multiplications and addition.
  */
-void ecc_point_mult_shamir(const struct ecc_point *result,
-			   const u64 *x, const struct ecc_point *p,
-			   const u64 *y, const struct ecc_point *q,
-			   const struct ecc_curve *curve);
+DECLARE_CRYPTO_API(ecc_point_mult_shamir, void,
+	(const struct ecc_point *result, const u64 *x, const struct ecc_point *p, const u64 *y, const struct ecc_point *q, const struct ecc_curve *curve),
+	(result, x, p, y, q, curve));
 
 extern struct crypto_template ecdsa_x962_tmpl;
 extern struct crypto_template ecdsa_p1363_tmpl;
-- 
2.39.3

