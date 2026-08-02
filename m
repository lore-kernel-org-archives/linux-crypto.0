Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8569E331ECF;
	Sun,  2 Aug 2026 23:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785711724; cv=none; b=oJZTgdkFuGIZCmGRojZou33QR94jDuFbF+VglWFUKHNq4xz7bse3plA3zUrRoO5YLj+4qLYP2udsaPrsJ2XTmunenYR78kocs7M8z06V8/UjuiZtBomWAhO2FMGa5QPDlSIyI197Sgm7B7DB4lJr851PF2AbmrpQLnlrOfFz+vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785711724; c=relaxed/simple;
	bh=IgBk2RuccaGWOAfuCQKeVs1UuWvX7yKmR3ppuQ4gXBk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JxrGfVAxRJp/WFal3GaWMUCwHHvh5XLBG7wB4qks5Y+C1oLeCxEOHx2nm1eW54clUkYd2YgRbwbqbKrPGcwmnCKXfzP+LQYxQMJ7tDYQdkJr9BIyF+6FBYv1w5WYs1O/0rB4SbrVGd2nwrfhzMcGeGhmjV0d6T0Iv69NQN7/Oh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=keTDKvzt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="keTDKvzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87801F000E9;
	Sun,  2 Aug 2026 23:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785711723;
	bh=hcYDEAT1RM/+lD1yq3s92cR0HS73FUYrxw6JHoppXEI=;
	h=From:To:Cc:Subject:Date;
	b=keTDKvztQruC6LTkCf0SOvGTJVUkLbsEGnf8vrWNgpgyn9w6VlA7v8xc+gTxr0Abe
	 BZ9UwQ6wfm096r8Dfq1ii7q3b3Ji4OAlM4pY1u4HJkQ4sgsVlPkCGInZqig/aT3V8N
	 x7gHMpoh9pIrwsYoXWZk+45gQ2b61oMU/4bm/MHPX8NkF1A28SWXHbSwJp7sTW2Gsy
	 jeoK5nD0JK+7sLJL0xtAm8Ei37tYk6L2Cjl9roaHPJQ0jI+5EhT7hwnlUeB5XKE8Yv
	 cTOk6R1TFDmVT9YUT61i5Z1EbqGt/dNHYO7UwJs+eYOoJQOgmP9uuVw1n9IyG7D/aW
	 FBjiu7kQhBYDg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Richard Weinberger <richard@nod.at>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] crypto: af_alg_restrict cleanups
Date: Sun,  2 Aug 2026 16:00:52 -0700
Message-ID: <20260802230055.100746-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- Make cbc(paes) privileged-only for now, as previously discussed
- Make it more explicit when unprivileged use is allowed
- Avoid some redundant work during allowlist checking

Eric Biggers (3):
  crypto: af_alg - Make cbc(paes) privileged-only
  crypto: af_alg - Replace 'bool privileged' with flags
  crypto: af_alg - Stop after finding name in allowlist

 crypto/af_alg.c         | 10 +++++++---
 crypto/algif_aead.c     |  2 +-
 crypto/algif_hash.c     | 28 ++++++++++++++--------------
 crypto/algif_skcipher.c | 28 ++++++++++++++--------------
 include/crypto/if_alg.h |  6 +++++-
 5 files changed, 41 insertions(+), 33 deletions(-)


base-commit: 947d62c094367ef6064907d570b47612cd579df6
-- 
2.55.0

