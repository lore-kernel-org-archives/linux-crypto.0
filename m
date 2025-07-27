Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906FC76025;
	Sun, 27 Jul 2025 23:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753659993; cv=none; b=os2BTGN65pmVk6VBOgUb94TooRcL9lBjGw/1JYV1C9wPla+tBg7k5NrI42iUVVrWSF3lNx0ypHT1pZoj/enk32U0CscsRiO7gVqUu2PX2+M4VbhsgSfKKSzSKiCzpi/3cun98pQ4gL1zGiQsm6M41owJjq/eAp/YqK6UXGwIpB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753659993; c=relaxed/simple;
	bh=G/a5ZBmNTUrAa53vvuk2OdNMQ7EuO3MHL5fDYbjnTfM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ByhT6hIf+W+O8oehAxj8VpEs5jI6uX4B2v8ul81iisj6OS9d0+nEIDT0Jm/n9zQjPnt/cIaR4QfxPFdOtiyU2z6+vZSbNVj9vIPOwOo4VcSiyGpBaDYbyD06T4ZTK7wA9OkCHQ74n3A/v86rLybGWex9WiCh6DCx2vJTlRkGZLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6dCBU62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6dCBU62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5958C4CEEB;
	Sun, 27 Jul 2025 23:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753659993;
	bh=G/a5ZBmNTUrAa53vvuk2OdNMQ7EuO3MHL5fDYbjnTfM=;
	h=Date:From:To:Cc:Subject:From;
	b=A6dCBU62n6vRp2tRBRUq3d6SH4ZnrhKIP46xvUhN8vQe+D7iFNjL5JzW/LBgMmBrH
	 QhI6zG4EOfiZDdQJhjRGNO3Q+dKLVq/05TNJeFvcAA/vKrb9pWseiiF2by8koWeuI4
	 5dUSm9joeJ8z9uEQMQN719eM7ep1EfShfmwB5oovItmcDlFXQc3c3WxWHhuw/QOPWv
	 rWe4ym1AyYePtJezvbfwZ8FSP5wdKajHMO1J5QafbW8qbKLn8rI2oFye0/Y+8qpPaO
	 eDcsD+eA3t0rZw4sNS6OoLBH62lA/L7kKuq58u4G2QuHP2SPZGCYt+Ie/2it1/tG43
	 jw3/GhO7GyqLQ==
Date: Sun, 27 Jul 2025 16:45:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	fsverity@lists.linux.dev, apparmor@lists.ubuntu.com,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [GIT PULL] Crypto library conversions for 6.17
Message-ID: <20250727234542.GC1261@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Note: this depends on the "Crypto library updates" pull request and
should be merged after it.

The following changes since commit c76ed8790b3018fe36647d9aae96e0373f321184:

  crypto: sha1 - Remove sha1_base.h (2025-07-14 11:28:38 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-conversions-for-linus

for you to fetch changes up to 998646b3c1129188f1fdffac3779feb9708b4b4a:

  fsverity: Switch from crypto_shash to SHA-2 library (2025-07-14 11:29:32 -0700)

----------------------------------------------------------------

Convert fsverity and apparmor to use the SHA-2 library functions
instead of crypto_shash. This is simpler and also slightly faster.

----------------------------------------------------------------
Eric Biggers (3):
      apparmor: use SHA-256 library API instead of crypto_shash API
      fsverity: Explicitly include <linux/export.h>
      fsverity: Switch from crypto_shash to SHA-2 library

 Documentation/filesystems/fsverity.rst |   3 +-
 fs/verity/Kconfig                      |   6 +-
 fs/verity/enable.c                     |   9 +-
 fs/verity/fsverity_private.h           |  24 ++--
 fs/verity/hash_algs.c                  | 194 +++++++++++----------------------
 fs/verity/measure.c                    |   1 +
 fs/verity/open.c                       |  37 +++----
 fs/verity/read_metadata.c              |   1 +
 fs/verity/verify.c                     |   8 +-
 security/apparmor/Kconfig              |   3 +-
 security/apparmor/crypto.c             |  85 ++-------------
 11 files changed, 120 insertions(+), 251 deletions(-)
