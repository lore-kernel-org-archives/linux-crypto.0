Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D551F8AC5;
	Sun, 11 Jan 2026 19:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768160353; cv=none; b=dmjFcPFb8rbWtmUURI+01QXoMm7sN9jz9HvcIouU2LImlvFou3uB4/E85zOcDAZAR3A9LIFMm542N7TMrRK4j4OteOm9hnl/UzVt36r6wM8QG6TjSf0nnToBz8sKZq0Etp64IldgYXIL2ZIvBIoqWKDoqfAmAf9np/QEi8TbPS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768160353; c=relaxed/simple;
	bh=aj+Gjzhf93hCf1ciRD7JtTYLSaZNxVYGbkLZQLvJ6Z8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=e2xKKM7/5pXqUFczxhKt3sKgZzTmCiOTGDX99Vbibbp3IPtwtXpaj4+ObbECBRWo/jKRTOg+5nC0Wi00QYhQGueR1+6R5GTcJNJlWJ14bVoDX+7TzFjkF/8rKdeXJK0Hv7u9bOEFtjGsK/VSK3wCr3/LJwJZqnm5kBOqw4AZEvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jtqfu/Hd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jtqfu/Hd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8D5C4CEF7;
	Sun, 11 Jan 2026 19:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768160353;
	bh=aj+Gjzhf93hCf1ciRD7JtTYLSaZNxVYGbkLZQLvJ6Z8=;
	h=Date:From:To:Cc:Subject:From;
	b=Jtqfu/Hd6SP+oFTnZzYTky2dh8BpxPXndBcyZD5qPc0hN7HIdpwVKwIUhqtnYrcuR
	 r//gK2g85nlA6yoCUXZtTwgV6mv1pV6xrwKkxHnZNfTunzTeulW+yUQhb/QjwWnaiK
	 QwAK9KFst3Aki/nlSyG3UaG8EXpMPX35Jig6IxGzZb1DWhxmMmUQldLS4tv89QyOcg
	 S3tK9v86KtXb2awNAMo3pdHrr23yJUI6XkiJjY2q0T9fztfKcq9Gh9xDxIXhXvhHwV
	 yDw6HwKklwVJd9l9VQpeQ4sBgcOo6UCtkNSb+pjkPVt0XMdui6thKmSFWUuTYDz+Hf
	 i2nh0l/3XUyug==
Date: Sun, 11 Jan 2026 11:39:09 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jie Zhan <zhanjie9@hisilicon.com>, Qingfang Deng <dqfext@gmail.com>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Subject: [GIT PULL] Crypto library fixes for v6.19-rc5
Message-ID: <20260111193909.GA4348@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

The following changes since commit 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb:

  Linux 6.19-rc4 (2026-01-04 14:41:55 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to 74d74bb78aeccc9edc10db216d6be121cf7ec176:

  lib/crypto: aes: Fix missing MMU protection for AES S-box (2026-01-08 11:14:59 -0800)

----------------------------------------------------------------
Crypto library fixes for v6.19-rc5

- A couple more fixes for the lib/crypto KUnit tests

- Fix missing MMU protection for the AES S-box

----------------------------------------------------------------
Eric Biggers (2):
      MAINTAINERS: add test vector generation scripts to "CRYPTO LIBRARY"
      lib/crypto: aes: Fix missing MMU protection for AES S-box

Jie Zhan (1):
      lib/crypto: tests: Fix syntax error for old python versions

Thomas Weiﬂschuh (1):
      lib/crypto: tests: polyval_kunit: Increase iterations for preparekey in IRQs

 MAINTAINERS                         | 1 +
 lib/crypto/aes.c                    | 4 ++--
 lib/crypto/tests/polyval_kunit.c    | 2 +-
 scripts/crypto/gen-hash-testvecs.py | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)
