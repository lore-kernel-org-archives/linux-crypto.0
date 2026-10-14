Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402924746B4;
	Wed, 14 Oct 2026 13:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983740; cv=none; b=YfqSm0ut84hCnUVnR/bvG75jcby+iy5z+KGt0EqxvBYjYYvWDks49uSe3vb21Sx6X8NTBiMuXk5ypQq+QM9WrVNhhvIzNxe5u5GgDeByA7MqjXi5NBLx3n0G+vktTB7CQiENZUat0SCQW1z35lR1yQ63ItY0vDggCcc8Jcjuv2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983740; c=relaxed/simple;
	bh=au62hHikhfKfH164066g9n4w/w1MzTf55ju+bpblt2I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=M31wYNOnckuTmsF9P2sBV+q9fZcy5wIjCx6a4SM68Z6l+VP2tZbzEzmofaycf3TinzB5AKSlqXulingF7S08B6Pvrjq2Lcu6r2nnJU8ZgFsoHOlNWgrejUxkU97ZVdGdE4hO9+so9oin4uhgkZPlsytV37L/hTnOzztSdfQukwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ibqO3xGf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ibqO3xGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4891F000FF;
	Wed, 14 Oct 2026 13:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791983738;
	bh=U1KKITFB6GlhcyFfeU69N87BQw+PUUe1B3PSBuzh+wo=;
	h=Date:From:To:Cc:Subject;
	b=ibqO3xGftDjNqqwvPpxHo+ch79GE6MZq2r4c62aKbdva4t+ZsDFa5rOCR1TqRiYMi
	 uCHdKXY7T2lneOiBKMk+L7V2d+MDmqeeUAi0d73uFOmuSdiVd3gMc1+HwqofPlPvkE
	 XpTZGYcmpzxpkRlEP3hEjcTIR7j7ItNQaVZdNbCc/UCQqCykTqk5zHWq3GPgfjSj+i
	 L6PHZ6wTujUZx41z5eNZZjXkBIE/IU5xNqhNohvN89lMQxicH3nubH9HL9Gf7BlAnp
	 8I2Jxc0hUpslIjwgYM9zBsca2brTCjxYU/BXMzkvOk4XS14yFYVXPTjDPqxahO2zYB
	 qScF/zYan/wZA==
Date: Wed, 14 Oct 2026 15:15:20 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [GIT PULL] Crypto library fixes for 7.3-final
Message-ID: <20261014131520.GA97513@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

The following changes since commit 572af6872e520c7102e58362ef7cd7c2ed4342be:

  crypto: aes - Fix undesired override of some optimized AES modes (2026-09-30 08:38:06 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus

for you to fetch changes up to 7b817748bf083ad715a8d70de63f2184178cc372:

  lib/crypto: tests: Add Poly1305 split-update carry regression test (2026-10-09 19:21:07 +0200)

----------------------------------------------------------------

Fix two Poly1305 bugs including a lost carry bit, and add a regression
test.

----------------------------------------------------------------
Eric Biggers (2):
      lib/crypto: poly1305: Use memzero_explicit() in poly1305_final()
      lib/crypto: tests: Add Poly1305 split-update carry regression test

Jérémy Jean (1):
      lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state

 lib/crypto/arm64/poly1305-armv8.pl |  2 +-
 lib/crypto/poly1305.c              |  2 +-
 lib/crypto/tests/poly1305_kunit.c  | 97 ++++++++++++++++++++++++++++++++++----
 3 files changed, 90 insertions(+), 11 deletions(-)
