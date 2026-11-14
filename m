Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794645854;
	b=Al58NyFaYICcwbr2DUn8Di/rApvfMbj6zTiovYvAqr9lwDm9CZLkffLyUZJoDYl1wPzJ
	 vjk3a7c81578Z8QuEpA/u6UIWy+zRWb89iQsUHEOk/8Sz3KDr1nDaxd5a5QpULM3RWPF2
	 sHhNQWSlOPL0wrxbrBdZdKas3qvVBlRZzy3vjjsfvmTO+W+1CRqHdCkwe/Gdgn3vSU3jq
	 1CFzXsr9nCqV9xR37Kv229Es6Rm8qGBCle1fz+HXgYtGbufYNeTrfYWMWkIYLp3N28/B/
	 8U48sOCbO6ldvP3OR5RezXwiPWLATF979WsvJTGXgGFaM2zBD5KokVUCb998mPgGjNw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794645854;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=HFtDFqfkB6NjBjOqbI6Uvr67mPLsIsHobK9tPjF8ZQ8=;
	b=uFRQKacDXO42OAJiJKgRIXsDc4PfAY7OHUm2W4/u6l6P55swU0JmG4TBz1XoRxSDYx33
	 cAVy+DTnOVNzrVngP/i7l41LQbIiE6lEo+GNVK8AX9lkjHsz3UWYdRRnkBkAGCAN8psIC
	 4NBRwkfXxVZlNMf4gh/TA+WaRz9qfJ3n2UkusMjkm0ZtRoNP6ohv+xqHcspu2vTDwzGjH
	 /BpqUOxcCpVI6zMuktYf2D7J0SlaZzbNipUUPFybhfs+Yjz0EtpReo/FFla+DapwCY3A5
	 wkXqYufj0aY/7R8MgwpEObofDxSi4fM0OxlAnDC/mNT0h91e/faIVlue33TxT4INGaQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="OrnV/Tle";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83F6606A333;
	Sat, 14 Nov 2026 08:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OrnV/Tle
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794645854;
	b=hiAYMZsjUju1aZC6Av/pqHvWBK8I5aN8sTTSYQ5smtS14tMLWrp/9sw3Hix/1ZV7/hDW
	 qTl+YIsEMlR+/DH9XO3fsLXYwNmZQ1B80afWCREv1VyML16+fSg+3bSOADnU5Z3fXTrUH
	 zd5w1og5zauGK1NUdDhpdB9vuaxW4RTU78tq0oO5nKBCTBBXKsSCv9KVHmqFa8bNfiIhw
	 mXmoX6DnnjK1D/T0kPlwvBfnaDoyYiwcml+mCj90ZiAROYJRXF85PREoqToPNNqsOToSr
	 q7xhJXBtiicSUIEzqnneqO88QglfhxDDZBy/EkTSWO3ZxGVwKLKqJ/m6atMhgxs+Jbw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794645854;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=HFtDFqfkB6NjBjOqbI6Uvr67mPLsIsHobK9tPjF8ZQ8=;
	b=H8roOv3/M5JtyToq2dexF8aVHSh4RIM78CZ9hdLZCFXqeJIE1eVIaBakzpqA6/Y6Yq9r
	 QSQ807N6O8c/94EPBq/oU8cVATiR8BkDKZEsoDQtZIra24sQikP1tMUHY2+eiOquhBqbM
	 51xXzqxcKLTU5CbwE4w/ZRRz6cW8/wP/JUcCh57i+VOp9DZJeb+PKvmCT2ERMfqhLiHPp
	 lXyaoSieS7kRcGZfE2696pF5cVzl3On1SK+XJweiq3dIg3iS16C5hQ2CZUrv8v460zVmh
	 4N2Dm7Jn9FyPgEwapjNIYKElfZ5JBvC27qg4x6hKNnve50JlEvhoCmWc94x7lmBSixQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E71F01F000C5;
	Sat, 14 Nov 2026 08:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794645854;
	bh=HFtDFqfkB6NjBjOqbI6Uvr67mPLsIsHobK9tPjF8ZQ8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=OrnV/TleCfQJmieA3a0zDxjxMV4LcWUA3jxeuOlwxOiHzZHFqL8kpGklWDtR2z+6m
	 vptpBb9QDworcQSgJ/LfF0sdN2MDSebO8l1YNcEvZLjtH62/6b40cdrcOsBdD800kr
	 gJNREat28gL+GwTUYsPkkBkPu0peCcyIj9rbnRG30td0bk4YXOIQkpUdKFTTsA89mM
	 4Tw6FMNW225cZKJf7aqjP2MDI2pv+Ycq//DVuahuJG0LgMMxj5pd0Indeh2WiktH3A
	 drGYCGKv2uUkiYgUQ6qi/f/0W7mPt4soJ7jLNdMOs+wYwvrJbrCKx7x0MTvJB+7pfi
	 SKWMF+kzEjuMA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 5DF4E49CF6;
	Sat, 14 Nov 2026 08:44:13 +0000 (UTC)
From: Arun Iyengar via B4 Relay <devnull+aiyengar1990.gmail.com@kernel.org>
Date: Sat, 14 Nov 2026 08:44:13 +0000
Subject: [PATCH 1/2] crypto: ecc - Keep the random initial Z below 2^521 on
 P-521
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261114-ecc-p521-small-scalars-v1-1-7b114f076b33@gmail.com>
References: <20261114-ecc-p521-small-scalars-v1-0-7b114f076b33@gmail.com>
In-Reply-To: <20261114-ecc-p521-small-scalars-v1-0-7b114f076b33@gmail.com>
To: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>, 
 Stefan Berger <stefanb@linux.ibm.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Erwin Pawliczek <pawliczekerwin@gmail.com>, 
 Arun Iyengar <aiyengar1990@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794645852; l=2966;
 i=aiyengar1990@gmail.com; s=20261110; h=from:subject:message-id;
 bh=wa3uFN73ClJd7AvFAJuDLQdKh5vQeib0sCHSRe3QqSQ=;
 b=FcAzELUZBNaEmGagMVdfvJxjEzQxoUfrIcg9OFBUxu9czlokhL3k0AYFKAEKqwaduWH+AU2X4
 IxbxRS+NBwICAjs296DJcrJeUiF3Ko2yxjUfvTxy6bA4JyQ/XxO7bs0
X-Developer-Key: i=aiyengar1990@gmail.com; a=ed25519;
 pk=zXpRgUTrhaFe6jLyPqbBy3ccfkj04w0g2690Wv3mg+0=
X-Endpoint-Received: by B4 Relay for aiyengar1990@gmail.com/20261110 with
 auth_id=1480
X-Original-From: Arun Iyengar <aiyengar1990@gmail.com>
Reply-To: aiyengar1990@gmail.com
Content-Transfer-Encoding: 7bit

From: Arun Iyengar <aiyengar1990@gmail.com>

Erwin Pawliczek's commit cd65eaf17841 ("crypto: ecc - Randomize the
initial Z in ecc_make_pub_key()") takes the initial Z from ndigits * 8
random bytes, as crypto_ecdh_shared_secret() already did. On P-521 that
is a 576-bit number, but vli_mmod_fast_521() only reduces products of
numbers below 2^521. With a 576-bit Z, every P-521 ecc_make_pub_key()
call returns -EAGAIN. There is no in-tree P-521 caller yet.

Get Z from one helper at both sites that keeps the random bits to the
curve's bit length. The other curves are unchanged.

Tested in UML: P-521 ecc_make_pub_key() now matches a Python reference
for the tested keys from 2^522 - 2n up to n - 3. Smaller keys are fixed
by the next patch. The ecdsa-nist-p521 self-tests still pass.

Fixes: cd65eaf17841 ("crypto: ecc - Randomize the initial Z in ecc_make_pub_key()")
Cc: Erwin Pawliczek <pawliczekerwin@gmail.com>
Signed-off-by: Arun Iyengar <aiyengar1990@gmail.com>
---
 crypto/ecc.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 6696bf0d90a6..a56a33e4eccb 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1609,13 +1609,22 @@ int ecc_gen_privkey(unsigned int curve_id, unsigned int ndigits,
 }
 EXPORT_SYMBOL(ecc_gen_privkey);
 
+/* Random initial Z for ecc_point_mult(), below 2^nbits */
+static void ecc_rand_z(const struct ecc_curve *curve, u64 *z,
+		       unsigned int ndigits)
+{
+	get_random_bytes(z, ndigits << ECC_DIGITS_TO_BYTES_SHIFT);
+	/* P-521: the fast reduction only takes products of 521-bit numbers */
+	if (curve->nbits % 64)
+		z[ndigits - 1] &= GENMASK_ULL(curve->nbits % 64 - 1, 0);
+}
+
 int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 		     const u64 *private_key, u64 *public_key)
 {
 	int ret = 0;
 	struct ecc_point *pk;
 	u64 rand_z[ECC_MAX_DIGITS];
-	unsigned int nbytes;
 	const struct ecc_curve *curve = ecc_get_curve(curve_id);
 
 	if (!private_key || ndigits > ARRAY_SIZE(rand_z)) {
@@ -1623,9 +1632,7 @@ int ecc_make_pub_key(unsigned int curve_id, unsigned int ndigits,
 		goto out;
 	}
 
-	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
-
-	get_random_bytes(rand_z, nbytes);
+	ecc_rand_z(curve, rand_z, ndigits);
 
 	pk = ecc_alloc_point(ndigits);
 	if (!pk) {
@@ -1719,7 +1726,6 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 	int ret = 0;
 	struct ecc_point *product, *pk;
 	u64 rand_z[ECC_MAX_DIGITS];
-	unsigned int nbytes;
 	const struct ecc_curve *curve = ecc_get_curve(curve_id);
 
 	if (!private_key || !public_key || ndigits > ARRAY_SIZE(rand_z)) {
@@ -1727,9 +1733,7 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 		goto out;
 	}
 
-	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
-
-	get_random_bytes(rand_z, nbytes);
+	ecc_rand_z(curve, rand_z, ndigits);
 
 	pk = ecc_alloc_point(ndigits);
 	if (!pk) {

-- 
2.55.0


