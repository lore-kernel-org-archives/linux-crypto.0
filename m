Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E7539C657;
	Mon, 30 Mar 2026 19:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774899978; cv=none; b=EuuaMeCxBeCr1sX8kr4uHudyBZGOPffNIhI8g+VgMQ/0Y9DsZ02V/ed3a9EKK3eqUqYNRRyHSiT6XQtGL18pNFR0gSNDh/a0zxsbVdefXMCk9YGpvr0KeQKjAiGu4DlXg08LFCjmJty8Ta65RDp5XJrvSPlooJUqRZua2yzEXYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774899978; c=relaxed/simple;
	bh=CJy5EVnpipi+f0FN9mzxPK88Kx1XqtQahPyiTMt0mWs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kO9JOG48TDhgExlO7a0j/ec4slVwJcS1pyvQjId8X8MJJ2TVg5gFFgjjmSh1G+8OqQjH35uQhXFu977tCA6Lmuc0JA1BRFu33adSWW8m1wjCCbdPUxhq8LEt4OtXYX/ycPb+PG25qwooY66b/wh5rgdTs4Rao8KXNf5qbysYNY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p/WD7RON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p/WD7RON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5EFC4CEF7;
	Mon, 30 Mar 2026 19:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774899977;
	bh=CJy5EVnpipi+f0FN9mzxPK88Kx1XqtQahPyiTMt0mWs=;
	h=Date:From:To:Cc:Subject:From;
	b=p/WD7RONSZdqWtdO7VBbzNzoXRPpuxefMGr/CTb/0ZZVIiG7MCxBe+TWkBrjMii2q
	 Ov8uNQh8jIgn60C3z/1NKxsxSMzJec9dKqeYY94QuoFYRI9mXIA3OcgHCOvyonKu4D
	 VjKwYeMRvy9G3YCpADYSw+pkj7ZOgMNtJE+hvFHbEq+EkyQ3slQb13uNHj6zp+7DHZ
	 MhEi1UAK1hDekFZNNMif53l9LC24zJZW9MVyRzpUzBRzCtXm5KgCm5+A3ks2Cio2Qc
	 9Jr8bBC94J+H1S4Oesm+htD1dRBso7eM9rb3veZcICtyg11yPepusJ0EnIOXczmRKW
	 2h4e6vNrKWl8w==
Date: Mon, 30 Mar 2026 12:45:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [GIT PULL] Crypto library fix for v7.0-rc7
Message-ID: <20260330194508.GD4303@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit c369299895a591d96745d6492d4888259b004a9e:

  Linux 7.0-rc5 (2026-03-22 14:42:17 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to e5046823f8fa3677341b541a25af2fcb99a5b1e0:

  lib/crypto: chacha: Zeroize permuted_state before it leaves scope (2026-03-27 13:35:35 -0700)

----------------------------------------------------------------

Fix missing zeroization of the ChaCha state

----------------------------------------------------------------
Eric Biggers (1):
      lib/crypto: chacha: Zeroize permuted_state before it leaves scope

 lib/crypto/chacha-block-generic.c | 4 ++++
 1 file changed, 4 insertions(+)
