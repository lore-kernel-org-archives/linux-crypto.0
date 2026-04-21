Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D16936C9C0;
	Tue, 21 Apr 2026 18:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776796730; cv=none; b=JSUj88fYjwYtLzV9G240NJWzjigG9TxxQ4l5b/0/Fv7izCPQER03zOnEI6ve6dPGXLHy7m/naIFO4W6BCFc2zTzUVg2fxe09ycUv1G9xW34HfKpgVkzqs23pFTGItqpHGHT2RP54QeC1DXDsF3dof0g+BYpAQSymMGfpHIZcx+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776796730; c=relaxed/simple;
	bh=jBdZZez5rOUShQk6T498P2HWtiAvUM6Vu/wHjQYoaIA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WNhvPHBc9CIEfZQoJG6vA4v8tI/8Xf0DJ9R9W141KIQu94P+76AJOejDM36LRM0NWESVRhiMWXvCiTY1R/FQG98mib4aBL7ZIIsG10KAk7xobfo/oKMoxZlmAS5qvl5augbJLenHttMozci1VU1gttY/codzulzLfByhxrL9VN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rAdU7Bsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rAdU7Bsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF8DC2BCB0;
	Tue, 21 Apr 2026 18:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776796729;
	bh=jBdZZez5rOUShQk6T498P2HWtiAvUM6Vu/wHjQYoaIA=;
	h=Date:From:To:Cc:Subject:From;
	b=rAdU7BshopADlnMW+Hnm8nfqxdb9d8aqBzjalBic29ipdTrEjYiTWFldGqiWgOSre
	 69+u5N3ZUaNio4r8VpbbwEXihAYlPFyCT5DkuxVEIY+TwzVAELRNjEvtfYj4x4DLXg
	 NXokDOh++MA36xcrUE6FXSn3Vycyz4vmnEef0oKnNA01FVFIKVc1dNVI5bV53aUYsw
	 L06yGS5tw+Y9bnciZzwsHL1GlzzZ9U7TcZxhfobdVCkk2jjiDtYLKyy8RIXI/v+8e4
	 DOdNdGrluEUGZN1KA68GSnmIdUOM24GFHO3c9w2dkvPiV4fZ6bLE51UvNO8XfnHbVB
	 UF9ddsDXd3Ahw==
Date: Tue, 21 Apr 2026 11:38:47 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Lukas Wunner <lukas@wunner.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Yiming Qian <yimingqian591@gmail.com>
Subject: [GIT PULL] Crypto library fix and documentation update for 7.1
Message-ID: <20260421183847.GA2202@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d60bc140158342716e13ff0f8aa65642f43ba053:

  Merge tag 'pwrseq-updates-for-v7.1-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/brgl/linux (2026-04-13 20:28:22 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to e9af4f47d4a036b4be67e4be361f62e05081f7bf:

  lib/crypto: docs: Add rst documentation to Documentation/crypto/ (2026-04-18 17:32:02 -0700)

----------------------------------------------------------------

- Fix an integer underflow in the mpi library

- Improve the crypto library documentation

----------------------------------------------------------------
Eric Biggers (2):
      docs: kdoc: Expand 'at_least' when creating parameter list
      lib/crypto: docs: Add rst documentation to Documentation/crypto/

Lukas Wunner (1):
      lib/crypto: mpi: Fix integer underflow in mpi_read_raw_from_sgl()

 Documentation/crypto/index.rst                 |   2 +-
 Documentation/crypto/libcrypto-blockcipher.rst |  19 +++
 Documentation/crypto/libcrypto-hash.rst        |  86 +++++++++++++
 Documentation/crypto/libcrypto-signature.rst   |  11 ++
 Documentation/crypto/libcrypto-utils.rst       |   6 +
 Documentation/crypto/libcrypto.rst             | 165 +++++++++++++++++++++++++
 Documentation/crypto/sha3.rst                  |   2 +
 lib/crypto/mpi/mpicoder.c                      |   2 +-
 tools/lib/python/kdoc/kdoc_parser.py           |   5 +
 9 files changed, 296 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/crypto/libcrypto-blockcipher.rst
 create mode 100644 Documentation/crypto/libcrypto-hash.rst
 create mode 100644 Documentation/crypto/libcrypto-signature.rst
 create mode 100644 Documentation/crypto/libcrypto-utils.rst
 create mode 100644 Documentation/crypto/libcrypto.rst
