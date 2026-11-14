Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794645855;
	b=CdX+YH/L4wU2vdkGywDfZgjLrzcL3AjJruddoG7xANxcfiFhkg4ZB8rLzdkmZ29dwBo7
	 ZTCNad572MwIvHkbwgAZeeHZaoqqbZm2losUUDeH9g+CH5b4ylOulkxIDqP1adwQ9BTMb
	 V0RkAsFzyR9oaO6AVsvrqXdhDPmJ09ylQfLSykhuaTiiOuEv4RmGO+TU3dOxKTHDzGImZ
	 HIc+7LGgOLyS0ELpHSBudlM0Dy44Qdj13mVlMMoLyfFSsxm1IS1dxV+TXS63jTZ1mvih5
	 AtwKAJl6VhJ3T/UfxXjvM2Fgrt9ljCmBxGU1vgyRgnWoLtDyd+wZ2vlYY7YWiLrIJ8Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794645855;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GvKtyHPkmI7ecgzjfuqKlpQxKIE3XgpyMCBHKqtOrZU=;
	b=hXucdopxa+8LlZav8SYnFbWRHfP5dm0GeWUQhdLABf1hapIN9y9QHXgaV8+WrSW79JFg
	 q4fusIvMOQNlYxSneb2cUtyPslgqjboFynssNd0lkhOw7aZm1BQ69EblMpOZu1kQhMHQY
	 Qx6RfWUC81U1w49Jr+0Aftj7t1mVN4bg92tX6B+9Bh5rzfX6AyFIuaRvNVwEakKe21orL
	 Y3uNgGD9Ex+whRTFGJLI66UD3HKmUdvaAx0mSzbR8GKSp1TLvPSaMkvU5BxXk/j/PV21C
	 zoROI+UdOl7eRvfK0PFsZRMWMxElHcl/PFA2iTCY9uwf0AIwu+/G2oCD/nxCCdM/dlA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZWZgPzAz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9189C606A880;
	Sat, 14 Nov 2026 08:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZWZgPzAz
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794645854;
	b=ReHGquSteyZ62YM2UbdYWBuvHY7yQa3E6ydA01ogQZwwZLCmCorYytPjV7Qe/U9wfdI/
	 XMU86utqL2utbQZlM52YeK7UbwLsUm87WAzfS2Ek76iC/oJ81LsKPs5mZJHRWyGe7pRd9
	 fY+YgJFgyGB5KKyDBX1JRRKsL6vKG9MftQe9TGqDjGiDFlYj+XGsHe5C7r4W2H3uu5Rnd
	 Kt2wmCq4Bw1G/XsQlDYC0h9MPld3kSx+LMBo9wzkNREJKmWluuAKeiYa+t5JZz2Dfy4xz
	 XEMa/Hm8Al+2vaR0IIvbT7CpnXQjtr1yWmMvJAZczwqkq98O8G4uQ+zAOljoLT9gMDw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794645854;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=GvKtyHPkmI7ecgzjfuqKlpQxKIE3XgpyMCBHKqtOrZU=;
	b=AmjdGouj2PKz8JjswZ1BLPcPUYxudgmK5OZl4uy/EPSHM+ehdJcbpFk0G/+J0Ka4+5KB
	 rH8XsJtpH9GBnpvXITc06IkflqcWBmyw62cVyx7GQWM9hXJNfDLyIcZMSMQzjXSTrj9dW
	 tAfn1SL/BoijXrwBQGXM3SBjlN3RNKa38AtkxgJZ5XqMqqapSdVYpe1Xrcg0+xMbYgiAE
	 +Nof3N33wipaDLgE9bEyrA6citpwWulf8CgQppGROTkAElFe5B04dadPaQQUkOe1F5PpC
	 7VLp1QBuxjHMtNVGZ74gT4pAxzFmWgxWVjyKiLLU7ZwHA/UuXkz+igwcn3f2DnKu0lg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E9E0E1F000C6;
	Sat, 14 Nov 2026 08:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794645854;
	bh=GvKtyHPkmI7ecgzjfuqKlpQxKIE3XgpyMCBHKqtOrZU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZWZgPzAzYLBDFxVQGQ14pYA6yqf1XGvliIJB1WQNxa2XjIT4mLIUyO7p5Dy1R4cIk
	 8s+cuTFF2BR1q+qSsk8RkXwGKaoi2kLb2iovRVRAzPJXcf+N/nlRJBftkgZE4WrOpc
	 pNdiHxwIk1R4Ymzkif3uBDQIKpYf7vn2yi5CGhzzDhXvGtwPjT8l1r3tXZdpx5pItZ
	 kV/ejSsS0DIo2TcrqSwHNxS2z/UV3RiOPqpWGRx2yI2b+YJq+5Np2CnhqKaihR8JRx
	 hXRKpBf9khrq5FuKj00LKdgHnforQcAtTS4xOcw+kuBxFBY0nEtjQxpVG/spY6bE7R
	 gJjaNW7734tfg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7350049D02;
	Sat, 14 Nov 2026 08:44:13 +0000 (UTC)
From: Arun Iyengar via B4 Relay <devnull+aiyengar1990.gmail.com@kernel.org>
Date: Sat, 14 Nov 2026 08:44:14 +0000
Subject: [PATCH 2/2] crypto: ecc - Fix P-521 scalar multiplication for
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
Message-Id: <20261114-ecc-p521-small-scalars-v1-2-7b114f076b33@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794645852; l=1867;
 i=aiyengar1990@gmail.com; s=20261110; h=from:subject:message-id;
 bh=ChgYZL5sUZcr2EItC0wbDpEzrtX14Y+YYUPb21F2SXA=;
 b=Uc/1ROh6prmhq8ZQxgMFw4YpS+STmEcKmdAaft7SbGrjt4Xtg3MNhB/aHPkICU5x9fZx65b4K
 qkP+z+SgvYsA/0+AlEeDofpQfCyTeweCSoFE5QfvADC00ESqPaItyw6
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

For k < n, k + n never carries out of the nine digits, so k + 2n is
always used. Its bit 522 is set only for k >= 2^522 - 2n (about
2^259.5); for smaller k the result is (k + 2^522) * P instead of k * P.

Use k + n if its bit 521 is set, else k + 2n, and start the ladder at
bit 521.

No caller is affected today: the only P-521 caller,
ecc_is_pubkey_valid_full(), passes k = n.

Tested in UML on top of the previous patch: ecc_make_pub_key() on
P-521 now matches a Python reference for k = 2, 3, 4, 2^200 + 5, k
around 2^521 - n and 2^522 - 2n, and 40 random k. Before, every k
below 2^522 - 2n was wrong. The ecdsa-nist-p521 self-tests (k = n)
still pass.

Fixes: 114e80437e0e ("crypto: ecc - Add special case for NIST P521 in ecc_point_mult")
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


