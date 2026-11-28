Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795887519;
	b=d66jx1xNIPD4Jh2KR9BYboUW/kqiC8xE89KfYtQu2bBhjCc1CqWPJibJhsAw5Y01xDjM
	 p5yMhmLrjBLnAl9lFkr8zVO4dqg7eJCP8VlnfoJCgzYc8KgicWbAKxsMe2rUNZyh+gpNw
	 BGnNMsllnbPDvRhYPHKz52AjYEJLhQOxvw3Sy0ySj5gf5Rkz6zoIey2CoqAP8rarAnfis
	 Pi5ygbXrjEBeljlYDf70PT/DGJKvusdPShD7Il8ORwn76+6gLwhthdUEtaMWzPTOHMu/x
	 5OecXBuPi5UHfOSzGmhoY91IQlgoe+u5IGHxjSHTJNkhIZPdanGooHJrbkflduUVxyA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795887519;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ciV6sH9NIcvxsWqjp+pVh6BX/xpNc7ABW6rb5elVJkE=;
	b=BrHJ8W/SpQIRribTRJGmTuUA2xyQ20ugN+ZK8I2L/u4NMBSODnZl+zkVRJ9//86lZtQI
	 VrUaPDKOWd0wXRnwgGo3e8eVKT670gbg2EYUKGE2RZwT2XsS9ywZaH1cnlXhWfgPe2IK9
	 OkmK2/rp++m4bcZCOx5wpWJ5p38TzmzNBE8gAbGPQLhwkqvHE+p4fxzEXy7eojs7Qu0Ue
	 WYohFX6rqYsMsFRTQGK0lOpbCHKrQJJpveJ1Ur5d8PVtpwXVJhcz/rLGyBiG7pAUjcGWF
	 ij+575h2xy8v06S76X3FIn0L9lUs8hOsssRlA1/uMpPqXpJYerdjzxED04nHYJyuoUg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kxtj6yJ8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5AE606A323;
	Sat, 28 Nov 2026 17:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kxtj6yJ8
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795887519;
	b=ETbfKYmEPeuuUYQ8twlHDWRDAFY7tDSgWcRRtHNZkf2vtFX1yyhv087CLNYT18Iuu2XN
	 SDPfLwY3b5UC42AKT2Yh31XPWwINN4WpPat7tA4B1OLXCFk2oA3e8dS7hK3MR6OV3oaL3
	 8lXSnO563ldzmlF+sGgf/R8P575ZT0L3webE96WicZ72q9q288EKZwQF9khNZWye27Tch
	 8bhe2gypZRpeK9Y9Kj8iXdeyTlBuOp8ldf0a7MNsxrn7yEvauK/UsmLgKWLyDdwToKkue
	 r0CcCJvBTGzCqdjSQ+pCMgPCRlYT9QE/dgr3KB6zsZjZV9miCLedtCHCRdlBujeLVwg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795887519;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ciV6sH9NIcvxsWqjp+pVh6BX/xpNc7ABW6rb5elVJkE=;
	b=Vzpxy7ocPobLvcYbOp+OyhYGPrt7vYKlm07nLleJqtGhuER2+6MlibBrtodhlaoNim6I
	 54+F0492/WJDbyER8g1hg0Y0w7aKUTfx9ZgB+9WrUWYq8hELTZAYr72F8k9XMouXhX1M6
	 kNNaVgh/4q6DJWk77AJDFSyWSRSHqbQrgqTHuraw4gJXYJ2TaRqG6TxhAeHBdk0WcbrM/
	 baSSnuSvv1YsIM9l3Hie4cRxysORAjWI2bDvuanb694pN53pFWr7hevWtHNoz2wAxSKlB
	 E2f4/l0UVGDAAewV/H6IS6Q3Mse0+fcxRwWRloIW10AGWI2lQAizczZ1T1wS+MXv0Ww==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2FC541F00897;
	Sat, 28 Nov 2026 17:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795887519;
	bh=ciV6sH9NIcvxsWqjp+pVh6BX/xpNc7ABW6rb5elVJkE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kxtj6yJ8AmIQ++1mrtVtSajmlOZD8F5aY8CctFpevwUpCEXRrLrDbMkVts94FOfPi
	 5XcioBY4vbHRCf/IUakrdPI6p68UjA05x6FHh+laODsX/YgjHKavh5Exj91tiygOLY
	 mnLjWMNq2yA/2i20PI0wKYQ4JliqSf/HOjS+19YCUFUANagIg50mddHOTYISn3nfky
	 HSxvbMCeA+qLNZUme9Q9ZTq/fUgfdi4ZSR5RN/vV9xEU/JXDrVTJtwSAJKlenxiPzo
	 bVIYxyqbdChB5vmvSP6pIxtqJjRny0L1+WSiliiwtQElrJAxahdOMcAIEs77bukGUR
	 Pm3RZr8aNg12g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B886A4E1C8;
	Sat, 28 Nov 2026 17:38:28 +0000 (UTC)
From: Arun Iyengar via B4 Relay <devnull+aiyengar1990.gmail.com@kernel.org>
Date: Sat, 28 Nov 2026 17:38:29 +0000
Subject: [PATCH v2 2/3] crypto: ecc - Fix P-521 scalar multiplication for
 small scalars
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
Message-Id: <20261128-ecc-p521-small-scalars-v2-2-0648f492bca4@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795887508; l=1819;
 i=aiyengar1990@gmail.com; s=20261110; h=from:subject:message-id;
 bh=8swt0d/3mPiEQ4HYrvtUfhuwkb2hZC6GxX5xty+8q9I=;
 b=K0NDjTHjayXNkwFbSVt+Ok2g4Am830fLLpLyH3wzB16QbCFy/GEQsVuM1U38ZSt7A3t3tSfCZ
 0HlYQUWLOP/D7i6Il8y2ih30LDfsUpls/rhmkf2RA8CjUGI/vSDsN3d
X-Developer-Key: i=aiyengar1990@gmail.com; a=ed25519;
 pk=zXpRgUTrhaFe6jLyPqbBy3ccfkj04w0g2690Wv3mg+0=
X-Endpoint-Received: by B4 Relay for aiyengar1990@gmail.com/20261110 with
 auth_id=1480
X-Original-From: Arun Iyengar <aiyengar1990@gmail.com>
Reply-To: aiyengar1990@gmail.com
Content-Transfer-Encoding: 7bit

From: Arun Iyengar <aiyengar1990@gmail.com>

Stefan Berger's commit 114e80437e0e ("crypto: ecc - Add special case
for NIST P521 in ecc_point_mult") made the ladder run on k + n or
k + 2n with bit 522 as the top bit.

For k < n that is always k + 2n, and its bit 522 is set only for
k >= 2^522 - 2n (about 2^259.5). For smaller k the result is
(k + 2^522) * P instead of k * P.

Use k + n if its bit 521 is set, else k + 2n, and start the ladder at
bit 521.

The only in-tree P-521 caller, ecc_is_pubkey_valid_full(), passes
k = n and gets the same result. Its ladder now runs on 2n instead of
3n, as on P-192, P-256 and P-384.

Tested in UML against a Python reference for small k, k on both sides
of 2^522 - 2n and 40 random k. The ecdsa-nist-p521 self-tests still
pass.

Fixes: 114e80437e0e ("crypto: ecc - Add special case for NIST P521 in ecc_point_mult")
Tested-by: Laveesh Bansal <laveeshb@laveeshbansal.com>
Signed-off-by: Arun Iyengar <aiyengar1990@gmail.com>
---
 crypto/ecc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index a56a33e4eccb..370c60595fa9 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1365,11 +1365,14 @@ static void ecc_point_mult(struct ecc_point *result,
 
 	carry = vli_add(sk[0], scalar, curve->n, ndigits);
 	vli_add(sk[1], sk[0], curve->n, ndigits);
-	scalar = sk[!carry];
-	if (curve->nbits == 521)	/* NIST P521 */
-		num_bits = curve->nbits + 2;
-	else
+	if (curve->nbits == 521) {	/* NIST P521 */
+		/* k + n or k + 2n, whichever has bit 521 as its top bit */
+		carry = !!vli_test_bit(sk[0], curve->nbits);
+		num_bits = curve->nbits + 1;
+	} else {
 		num_bits = sizeof(u64) * ndigits * 8 + 1;
+	}
+	scalar = sk[!carry];
 
 	vli_set(rx[1], point->x, ndigits);
 	vli_set(ry[1], point->y, ndigits);

-- 
2.55.0


