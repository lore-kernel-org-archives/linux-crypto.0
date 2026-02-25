Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7872C279DB3
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 01:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983932; cv=none; b=Jp+HSASqLBeGgbKZbY7j9d4VOteB9jXzlDQ06+yazTV1TXTkX4czdTtU1pBxvhUg0RdM9ez3LcONKOwPipf0EXvXCRg/+XYtuNvVWhllzi2MN1v/A14envrUqp84aTzye6A+Y7xE6DGoH/uVuu0+E9cdylsCjb00Ah8UmEacgLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983932; c=relaxed/simple;
	bh=3Ooal/AYN+j88ctFv4Ugi/qDy8J7CUNZNd58rQ5oPd0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uRxBetjLWw6GHr2hJxCABtPyqnHJ08DMaNinLs4Qr4gQwrTKNqqT4Uc1K4Nz9OHBSeUmxApFFMeTmGMEIEGrq8XZSJTfHwwHtwk4+HRxsSs64rLkELQ0z4h+B+OMcVi+Je8XAMiJbdpvOr/YCIWt4K0i1EqNjfwTjRZ63epgdqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gOs8BcpL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gOs8BcpL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=SapzJKqRLRQDbtdU+RdSz1osxw2nmg2rPwH62AydNUo=; b=gOs8BcpLT+ejk5+cbt9MNFNYpJ
	zWvOpH3dMUBpcgq1jx39AOACm2b28DfIcgom10Ln5A3YU5ne874U50XtZF3/coPIH+WeC2Knr5uQv
	6OouGYRqfLoMqzq15lsnZU+meyCMQBSk5RN0JixcdhrX3Qhk8uRKWDqzww88DxAK8791ypVLyeNge
	5t5mi0PTZDGJDNnmKF1Y8oFmhMT4cq8r5mpsFtE5nyWpX5jkYaaFXKNo5bbuowO6myTE3a2zr2+VF
	j4/5ecS5mApz6CXxGJp9vqcV7JMt2kyQebA0JiPvEVdXX6t8i3KInsAN2lsIRZfp5hV6+pUJH+E3o
	8crC8qCw==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vv3xx-0000000339W-0KNI;
	Wed, 25 Feb 2026 01:45:29 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-crypto@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: ecc - correct kernel-doc format
Date: Tue, 24 Feb 2026 17:45:28 -0800
Message-ID: <20260225014528.45199-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix all kernel-doc warnings in ecc.h:
- use correct kernel-doc format
- add some Returns: sections
- fix spelling and parameter names

Fixes these warnings:
Warning: include/crypto/internal/ecc.h:82 function parameter 'nbytes' not
 described in 'ecc_digits_from_bytes'
Warning: include/crypto/internal/ecc.h:82 function parameter 'out' not
 described in 'ecc_digits_from_bytes'
Warning: include/crypto/internal/ecc.h:95 No description found for return
 value of 'ecc_is_key_valid'
Warning: include/crypto/internal/ecc.h:110 No description found for return
 value of 'ecc_gen_privkey'
Warning: include/crypto/internal/ecc.h:124 No description found for return
 value of 'ecc_make_pub_key'
Warning: include/crypto/internal/ecc.h:143 No description found for return
 value of 'crypto_ecdh_shared_secret'
Warning: include/crypto/internal/ecc.h:182 No description found for return
 value of 'vli_is_zero'
Warning: include/crypto/internal/ecc.h:194 No description found for return
 value of 'vli_cmp'
Warning: include/crypto/internal/ecc.h:209 function parameter 'right' not
 described in 'vli_sub'
Warning: include/crypto/internal/ecc.h:271 expecting prototype for
 ecc_aloc_point(). Prototype was for ecc_alloc_point() instead
Warning: include/crypto/internal/ecc.h:287 function parameter 'point' not
 described in 'ecc_point_is_zero'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>

 include/crypto/internal/ecc.h |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- linux-next-20260205.orig/include/crypto/internal/ecc.h
+++ linux-next-20260205/include/crypto/internal/ecc.h
@@ -72,8 +72,8 @@ static inline void ecc_swap_digits(const
 /**
  * ecc_digits_from_bytes() - Create ndigits-sized digits array from byte array
  * @in:       Input byte array
- * @nbytes    Size of input byte array
- * @out       Output digits array
+ * @nbytes:   Size of input byte array
+ * @out:      Output digits array
  * @ndigits:  Number of digits to create from byte array
  *
  * The first byte in the input byte array is expected to hold the most
@@ -90,7 +90,7 @@ void ecc_digits_from_bytes(const u8 *in,
  * @private_key:	private key to be used for the given curve
  * @private_key_len:	private key length
  *
- * Returns 0 if the key is acceptable, a negative value otherwise
+ * Returns: 0 if the key is acceptable, a negative value otherwise
  */
 int ecc_is_key_valid(unsigned int curve_id, unsigned int ndigits,
 		     const u64 *private_key, unsigned int private_key_len);
@@ -104,7 +104,7 @@ int ecc_is_key_valid(unsigned int curve_
  * @ndigits:		curve number of digits
  * @private_key:	buffer for storing the generated private key
  *
- * Returns 0 if the private key was generated successfully, a negative value
+ * Returns: 0 if the private key was generated successfully, a negative value
  * if an error occurred.
  */
 int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits,
@@ -118,7 +118,7 @@ int ecc_gen_privkey(unsigned int curve_i
  * @private_key:	pregenerated private key for the given curve
  * @public_key:		buffer for storing the generated public key
  *
- * Returns 0 if the public key was generated successfully, a negative value
+ * Returns: 0 if the public key was generated successfully, a negative value
  * if an error occurred.
  */
 int ecc_make_pub_key(const unsigned int curve_id, unsigned int ndigits,
@@ -136,7 +136,7 @@ int ecc_make_pub_key(const unsigned int
  * Note: It is recommended that you hash the result of crypto_ecdh_shared_secret
  * before using it for symmetric encryption or HMAC.
  *
- * Returns 0 if the shared secret was generated successfully, a negative value
+ * Returns: 0 if the shared secret was generated successfully, a negative value
  * if an error occurred.
  */
 int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
@@ -179,6 +179,8 @@ int ecc_is_pubkey_valid_full(const struc
  *
  * @vli:		vli to check.
  * @ndigits:		length of the @vli
+ *
+ * Returns: %true if vli == 0, %false otherwise.
  */
 bool vli_is_zero(const u64 *vli, unsigned int ndigits);
 
@@ -189,7 +191,7 @@ bool vli_is_zero(const u64 *vli, unsigne
  * @right:		vli
  * @ndigits:		length of both vlis
  *
- * Returns sign of @left - @right, i.e. -1 if @left < @right,
+ * Returns: sign of @left - @right, i.e. -1 if @left < @right,
  * 0 if @left == @right, 1 if @left > @right.
  */
 int vli_cmp(const u64 *left, const u64 *right, unsigned int ndigits);
@@ -199,7 +201,7 @@ int vli_cmp(const u64 *left, const u64 *
  *
  * @result:		where to write result
  * @left:		vli
- * @right		vli
+ * @right:		vli
  * @ndigits:		length of all vlis
  *
  * Note: can modify in-place.
@@ -263,7 +265,7 @@ void vli_mod_mult_slow(u64 *result, cons
 unsigned int vli_num_bits(const u64 *vli, unsigned int ndigits);
 
 /**
- * ecc_aloc_point() - Allocate ECC point.
+ * ecc_alloc_point() - Allocate ECC point.
  *
  * @ndigits:		Length of vlis in u64 qwords.
  *
@@ -281,7 +283,7 @@ void ecc_free_point(struct ecc_point *p)
 /**
  * ecc_point_is_zero() - Check if point is zero.
  *
- * @p:			Point to check for zero.
+ * @point:		Point to check for zero.
  *
  * Return: true if point is the point at infinity, false otherwise.
  */
