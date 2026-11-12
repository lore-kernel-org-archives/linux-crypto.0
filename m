Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794472236;
	b=aIxgox3IKbXtERbFAp44xXr0H1gV6xqjHhoXTP4Fc6Wl8njb4S4Jjed3yVoaBafSmKlo
	 YAdOYZsoK5iOpaMpnhSoHpxzVla8LSQygOiVv6KBEBnEVvyQK2ExPJ3nTJ5A7K6ZEE/a7
	 5AoT1yU7YIwplTYU6NF05/k6ccsoY9Dai0F0+N2QCsQls31Abs6NEEWChVkwPZsOckTzP
	 FsPHoDk3Y5j/hMwgFLY51dWdZ5KHafKPp52KlFEUymMzKUuaPnOvNOpmT2/7h7O5csBE6
	 29+w8SNkbLr13KAdNJAE2Bsj6cKm7WvVlNO9Vy9zHsMNpoR8NosodRvB2NlrRjEUxoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794472236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hqnrMLwDyBRfghQ+MfEohtaUpTmDhVfrugBJxA9MRp0=;
	b=ziswO3UY1PlaE1opS//394FIJMN9Vb/eK8m9gJZ4ybRqIpzEHrs3yUr0IWAigP9GuUNs
	 Tf9DX+HBBGwZ61UgMkQ2Ca8+yt0waQ2jhbKDycm5EQpnbZ/gnp82TxK9qmYqFJX4b2zrj
	 Iftsg+yzZJzIr/hol2a+jXu7VZsVebbMpvJkgNU8EIohqwmdqsS+Cc8QScUII6whgbROT
	 1McQ0eNdBalrP+iHcZBApZmP1jmCEEUcI+HG/hWDiLdmVhTWZkuKSBC1KqVJ9uaQu/RgY
	 ZI0S//xGNwK6mYQ+Q8blv3wYLlEEslqfFzy+YMX7RaHLwHGPraklg/jYQ2llK+NH7HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BnqxF20F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FA6606A321
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 08:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BnqxF20F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0938B1F00A06;
	Thu, 12 Nov 2026 08:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794472236;
	bh=hqnrMLwDyBRfghQ+MfEohtaUpTmDhVfrugBJxA9MRp0=;
	h=From:To:Cc:Subject:Date;
	b=BnqxF20Fz5ztewoz0kaBXpEcjmEsh9bHOaBs8VS4TyvNmkBcH0VPFpGNlhKeBeiOp
	 HiUhxTlduLXTf/uva3CymYct6zQYtRN3vZLrvRC7h04l1mtapaUXZQEMIj698GJYyp
	 Prrl2v8JWXYKR41jgTnHU1ddJlrSWYwYKILg3KIzgVIMgv1XWOHJzaDV8nVPMQh+Gb
	 hiGXQSZyvpKgjzuBOygLKJ7THQHz0UxiB6lsZB8kssg0dxerdCyGdZskBaF+/vVo1i
	 t0Fx4VNPZ1yCWr9Usd/PnFffcUKw12gFJj7E0djK2AVCJaP/g0354QF4raDODI3CJT
	 W+M0aqmiTRsBA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/2] lib/crypto: x86/sha512: Partially roll up loops
Date: Thu, 12 Nov 2026 00:28:37 -0800
Message-ID: <20261112082839.414786-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some freshly baked loop rolls in the SSSE3 and AVX optimized SHA-512
code.

In each file, SHA-512 rounds 14 through 77 are rolled up into 8 groups
of 8 rounds.  This saves 20.2 KB of text.  It's also likely to increase
performance on the CPUs that actually run this code (i.e., CPUs without
AVX2), due to the improved use of the cache, though the oldest I was
able to confirm that on is Haswell which has AVX2 anyway.

Eric Biggers (2):
  lib/crypto: x86/sha512: Partially roll up sha512_transform_avx()
  lib/crypto: x86/sha512: Partially roll up sha512_transform_ssse3()

 lib/crypto/x86/sha512-avx-asm.S   | 124 +++++++++++++++--------------
 lib/crypto/x86/sha512-ssse3-asm.S | 126 ++++++++++++++++--------------
 2 files changed, 135 insertions(+), 115 deletions(-)


base-commit: 33b4f31b1aea3f62b61c892daefc0e6a77859032
-- 
2.56.1

