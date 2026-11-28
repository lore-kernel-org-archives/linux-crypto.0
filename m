Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795887514;
	b=zvZ/aUUUPjfR0XnHEh54EmQkqKaxVODPA6KfEEtKZ5LOA+YeEmaMshsHMyNA604F1Q05
	 mLFmoEStYeGq9htRNGFnSgCORrKqfVjSqf6wGJ/LMPP2K+QtnDFIoE6DXPitdJkGjRfeI
	 +ujMnO+OeqDK38C7dkaZgcvJbcssMFmyWy080o1+Oy5BhieZFPplIN5AGGwzA5Jg3vF0A
	 /oior0GiuwtCYYU4vdPCGl+/R3RkUFaP+S6MLEeSMay1WY3rHehwcEfs1ZM2VvFafVz8b
	 pNgD4QSRLP0ZI4Eyvr78kmy4XOeAYTe4c1+udNXD082WAoXj0pHSvvxooP63uFMT0hg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795887514;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=iK7LbYpNKtDbXco8AA09lUFqxVOSNUJqctB9bmvDd6g=;
	b=4GcqfpDB5zKuVsdjMYwN7qTFMBMy1g6UNXTGDWqFLRMm/0P6IpgEWTh/eZIg1Sxcv/vE
	 uq5LK5lBlFuB8YcqxdbGUZER9r5yPv5uQaCGs/YtRbdVaBtvi5sx+cowBeBhWhOy6m9uB
	 YKIPDxFAPRlXILZ6dzHx5SjC5KmZVplzp2hKncD4M8u8kZtZ+80Odu+qqW/wam7ojSH3y
	 kIJYuwpwaWFHzmJSMYGBHjfYQyli/RfPDIRbROvB7gesDtX1jsGuos0eSVqnovdqOxaxi
	 dCIevAwHybYRhyRB4S7h5gFd13aDiK31NqpSVgZ9BP3BvCjALpMlP06qI+c69JkIamg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BiHZcbb2;
	arc=fail smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1567606A324;
	Sat, 28 Nov 2026 17:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BiHZcbb2
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795887514;
	b=u7yYUIZ9fbTfhF2VijPnGFekwkeLeWVm7xzsrJT84aSmdJ+RPYVuge1pdh4DsKCI+O+m
	 nMJN3jqKXlOhuT29coJLMvFoa2F24x7mzyLL8LMY09lI6SOZF5aH8zr37v+pCJw3fkCK2
	 5FjknJ3b43SYPsXAmkNZ/fxJ3CeKDjf2GjjH6IGwnyZtF60o9BLui/bhUnjZPNF/YlI6X
	 sjGLZn/qd7IcR04TB5JWccDlRB7yUUzCQDnFPCTnZgxhdGbGbWlyyLIMRgv4BPuTp64aD
	 Ski407toqzRmSPLQ9tTIHsl22efmk2V9aIM2c/C6j0wBS3wS939cfROvV8UPuD3HQuQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795887514;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=iK7LbYpNKtDbXco8AA09lUFqxVOSNUJqctB9bmvDd6g=;
	b=JDzUkaGDHaZgpEmkk5dOtSztwyue2Fdtn3rfA2eTXR/vmD107t+MBIqvhtrnvtKREBcV
	 vRWAmBo96Mwlja49XBgZcIEtUlrZN2hokV2W83/82HjZfbtCPur+hv1x1S9hTOu8E94YG
	 Mg/l7aZHJxXOXNvsIdnRo7YFwf0BAlDZPp0EDXAh6b/R4ZSVHX5e3/ntsgUi7dr6qUoU6
	 bt+MOwiO28PUo7OYaXQv99dhSpUL+XrHh+Z4O76NQjD7ZHLcP0lNDZKmtvm2YSCq35XJ4
	 AT82I2XImqzXBeoUF4GyXQdaX/hA8rM9IeXVDSYKUU7Pg4OY7KLTqlb5Gl2+BRPjvfQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 088D21F000C1;
	Sat, 28 Nov 2026 17:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795887514;
	bh=iK7LbYpNKtDbXco8AA09lUFqxVOSNUJqctB9bmvDd6g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=BiHZcbb2+sWFzPi8amDz6TEmtYWbbHC1Dc4MXfjARHYnvN9NjAFkPfbPhdpUJcQ21
	 d0c1C51huahNK7tZJTkNqACl3ix68Q97qA6jqi2ZZDDQl+zOiOMNj1+Mj51b0YQ4Uc
	 HTHhBocnq95XK8+Aw8G6yz6T9BnBCwu2rDXIBeW5/juWDVwcgCmwpK9C9nwMaM0iJr
	 NqDIj9hxV37QPVsY+jDWfE4OQtFkjglT+kzI1XvM4Z2kRZm8ZbhXB76qAPXnIBWaPR
	 87aI5DCEVE/7vtR+9CcuuW8tTIxgGFMJtcTlULisswuDKYJGgJTrQsjVoplmszj7gk
	 ufoDM/MhnUx2A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 924B34E1B2;
	Sat, 28 Nov 2026 17:38:28 +0000 (UTC)
From: Arun Iyengar via B4 Relay <devnull+aiyengar1990.gmail.com@kernel.org>
Date: Sat, 28 Nov 2026 17:38:28 +0000
Subject: [PATCH v2 1/3] crypto: ecc - Keep the random initial Z below 2^521
 on P-521
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
Message-Id: <20261128-ecc-p521-small-scalars-v2-1-0648f492bca4@gmail.com>
References: <20261128-ecc-p521-small-scalars-v2-0-0648f492bca4@gmail.com>
In-Reply-To: <20261128-ecc-p521-small-scalars-v2-0-0648f492bca4@gmail.com>
To: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>, 
 Stefan Berger <stefanb@linux.ibm.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Erwin Pawliczek <pawliczekerwin@gmail.com>, 
 Laveesh Bansal <laveeshb@laveeshbansal.com>, 
 Arun Iyengar <aiyengar1990@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795887508; l=3022;
 i=aiyengar1990@gmail.com; s=20261110; h=from:subject:message-id;
 bh=Fk4oHHgTkglLwJ99I/UvAawdd280eMlHqGN6ONo4cE0=;
 b=j0mAQaWLrgv9m5mMC/UeBcb1TyYmcUlSJs6H5EexOM9+bw6Yz2VCH5vECi3Yb09yL9t3b+WZU
 ZGwzM6e7ISABp8GKpYE6RfEg/HqKGamSPvAPWwUyRlqgXJviyCgoBe2
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
Tested-by: Laveesh Bansal <laveeshb@laveeshbansal.com>
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


