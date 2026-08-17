Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD00C44C64D;
	Mon, 17 Aug 2026 17:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786988431; cv=none; b=tzZl5Hdpvxg8etEYNvz2XXX2bWFHD+l6WUxGO8qGOhJNP60UHvovS2XrdJ3fdcMVAhKhyxFc5eb1lFbN9hSd3C+4xSEhaOMznhGThuuWmhE91rgDFjZu46yROASjqDe/joPht2oH0NKZEHWaFrjgGeM0g/aIqo01Y9ncrHPZ+lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786988431; c=relaxed/simple;
	bh=1ybYUgDPDUyvMn9x1+3Mrud9EbhBxLWlq4t7K+kS2pg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=g5HTsD4nDjaM2zWUfrLN+o3gB8fpCLfmmHolLLxCOcee1nUKcK4fCp9ouBbyllBqLsxDmlnE+9e1OFEw8XhzIMC9Tw0ltz7DPrISMkmbKRrTzlEuUDl+rhw6K2J0xeKRQp9ddITncLgQ4co0vXx2nUNv51Yk0L7ugSGOrZVJ/Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RVo5a6/R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVo5a6/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA801F000E9;
	Mon, 17 Aug 2026 17:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786988429;
	bh=UCn9FJRCfzR6WrukhtxpnzDfAYwsUWE9aAXfaVDEc34=;
	h=Date:From:To:Cc:Subject;
	b=RVo5a6/Rqj2ge9U1srZMg1HcNS8h0n2MWQGUF2jJPRJo9SYRtT8SIeXcqARDspNBL
	 MBOsErHA2blxjxQU5pu+f/FvUqEtPG5ayROFQ0ZKrs5m3yeioca67vkd581VgAJMYo
	 c67zm9BjiqmBXM/wpO4zKrdZ/wT5UVe+uN0o8U8hoyxX0oVjmDVLVRWI8nhT0z57zM
	 5k43lCUp6Q6oGS8yB/r4iIHIGfIrDddSVGZCrCxlT9qseOQ/Y/jFOVTM0gRRliOUgu
	 nERzc0Gl9tRYQt1ggNTiHPWLBJM0XfJ1ARq5e6Q8w2LjdiU41VyVrGFO9L3SscZkJB
	 e2ILGEwOxYrZQ==
Date: Mon, 17 Aug 2026 10:40:28 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL] Crypto library updates for 7.3
Message-ID: <20260817174028.GC8327@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 1590cf0329716306e948a8fc29f1d3ee87d3989f:

  Linux 7.2-rc4 (2026-07-19 13:54:41 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-updates-for-linus

for you to fetch changes up to ff6ac629076fb3f369c6ad35d6ead1c666469b95:

  mac80211: fils_aead: Use __cleanup() instead of memzero_explicit() (2026-08-12 18:50:59 -0700)

----------------------------------------------------------------

Add library APIs for most AES encryption modes that are used in the
kernel (ECB, CBC, CBC-CTS, CTR, XCTR, XTS, GCM, CCM).

These AES modes have many in-kernel users that are currently using the
crypto_skcipher or crypto_aead APIs. These existing APIs are difficult
to use and inefficient. Until now, the lack of proper library support
for these has been the main gap in the crypto library.

This set of changes is the next stage of addressing it:

  - Implement the new APIs on top of the existing support for
    single-block AES in the library.

  - Fully document the new APIs.

  - Migrate the only user of the old AES-GCM library API to the new,
    more flexible API; then remove the old API and its implementation.

  - Wire up the new APIs to the traditional crypto API by adding
    crypto_skcipher and crypto_aead algorithms.

    This makes the new APIs be covered by the traditional crypto API's
    self-tests. It also makes them be already used for real on systems
    that don't have architecture-optimized code for these modes.

    But most importantly, this is a prerequisite for migrating the
    architecture-optimized code for these AES modes (i.e.
    arch/*/crypto/aes*) into the library, which as usual will
    eliminate a lot of redundant "glue" code.

Note that unlike some of the other algorithms that have been migrated
to the library, e.g. SHA-512, for these AES modes there was too much
to get done in one cycle. Nor did it make sense to handle these modes
one at a time, because they tend to be coupled together or depend on
each other, especially in the architecture-optimized AES code.

Thus, most of the benefits (reductions in lines of code, performance
improvements, etc.) will follow in later cycles when
architecture-optimized code is migrated into the library and users of
crypto_skcipher and crypto_aead are updated to use the new APIs.

The design of the new APIs was informed by writing proof-of-concept
patches for many kernel subsystems currently accessing these same
algorithms via crypto_skcipher or crypto_aead (patches 18-33 of
https://lore.kernel.org/r/20260707053503.209874-1-ebiggers@kernel.org/).

While those patches will be resent for real later, the total diffstat
for them was negative 1905 lines. So clearly the new APIs are quite a
bit easier to use and align better with what users actually need.

Besides the new AES encryption APIs, there are also a few changes for
improved AES-CMAC key and context zeroization.

----------------------------------------------------------------
Eric Biggers (16):
      crypto: xts - Split out __xts_verify_key() helper
      lib/crypto: aes: Add ECB support
      lib/crypto: aes: Add CBC and CBC-CTS support
      lib/crypto: aes: Add CTR and XCTR support
      lib/crypto: aes: Add XTS support
      lib/crypto: aes: Add GCM support
      lib/crypto: aes: Add CCM support
      crypto: aes - Add ECB support using library
      crypto: aes - Add CBC and CBC-CTS support using library
      crypto: aes - Add CTR and XCTR support using library
      crypto: aes - Add XTS support using library
      crypto: aes - Add GCM support using library
      crypto: aes - Add CCM support using library
      x86/sev: Use new AES-GCM library
      x86/sev: Remove obsolete virtual address check
      lib/crypto: aesgcm: Remove old AES-GCM library

Thomas Huth (4):
      lib/crypto: aes-cmac: Add zeroization functions
      smb: clear the aes_cmac_key and aes_cmac_ctx when done
      Bluetooth: SMP: clear the aes_cmac_key when done
      mac80211: fils_aead: Use __cleanup() instead of memzero_explicit()

 Documentation/crypto/libcrypto-auth-encryption.rst |   20 +
 .../crypto/libcrypto-unauth-encryption.rst         |   49 +
 Documentation/crypto/libcrypto.rst                 |    2 +
 arch/x86/Kconfig                                   |    2 +-
 arch/x86/coco/sev/core.c                           |   53 +-
 arch/x86/include/asm/sev.h                         |    2 +-
 crypto/Kconfig                                     |   11 +
 crypto/aes.c                                       |  892 ++++++++++++++-
 drivers/virt/coco/sev-guest/sev-guest.c            |    7 +-
 fs/smb/client/smb2transport.c                      |    4 +-
 fs/smb/server/auth.c                               |    2 +-
 include/crypto/aes-cbc-macs.h                      |   34 +
 include/crypto/aes-cbc.h                           |   77 ++
 include/crypto/aes-ccm.h                           |  266 +++++
 include/crypto/aes-ctr.h                           |   65 ++
 include/crypto/aes-ecb.h                           |   49 +
 include/crypto/aes-gcm.h                           |  260 +++++
 include/crypto/aes-xts.h                           |   94 ++
 include/crypto/gcm.h                               |   25 +-
 include/crypto/xts.h                               |   18 +-
 lib/crypto/Kconfig                                 |   41 +-
 lib/crypto/Makefile                                |    3 -
 lib/crypto/aes.c                                   | 1163 ++++++++++++++++++++
 lib/crypto/aesgcm.c                                |  721 ------------
 lib/crypto/tests/Kconfig                           |    6 +
 net/bluetooth/smp.c                                |    3 +-
 net/mac80211/fils_aead.c                           |    3 +-
 27 files changed, 3073 insertions(+), 799 deletions(-)
 create mode 100644 Documentation/crypto/libcrypto-auth-encryption.rst
 create mode 100644 Documentation/crypto/libcrypto-unauth-encryption.rst
 create mode 100644 include/crypto/aes-cbc.h
 create mode 100644 include/crypto/aes-ccm.h
 create mode 100644 include/crypto/aes-ctr.h
 create mode 100644 include/crypto/aes-ecb.h
 create mode 100644 include/crypto/aes-gcm.h
 create mode 100644 include/crypto/aes-xts.h
 delete mode 100644 lib/crypto/aesgcm.c
