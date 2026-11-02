Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793641480;
	b=dnum8rx6O9Ui62y/vvBRpJh7YsJe9RqL2vd2RLGYAb+tzXAzGe4qsy/LfR3iU1PnYMBC
	 GEVDPwGGV1EDCm9pwa9ceqLMqlNv8iIMq7pgsxK8cW099z00NFnWOu+Lwqc5Wt9KsY3dY
	 cqU5EpqSdt2oMM04NpOezNEXkk20tmgXCxmMQ1WDw886p40MSnmDS4el5LUkrnBYaZ3kG
	 CS3QcnVW+y4kVeQtapQhQ2GX6YtwawLxbZMkpteALzxOrtAlqmGMU4pud0V/8dJ0IeuQD
	 5Gt05YDgLGwKWk6UEp6/lBkLbFl1d9aCaWM8lYjio2oOWQYyxf/4R1yGDIkesf5abCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793641480;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=k7UZvy0vvY5D+HhvfYF+E9EdpF9huO3k00rhqXCPC6I=;
	b=FZTuScbxXH0rdI81ewF9sL09T9HNi40/QCsLjmMrpnrv1uHnTgeXZ6DW1WZ4jee6zleS
	 eBXTPMwOewgkSYJ8wxo5bRGiCRUjRI/BI7jds/nk/XoOLz8/6zLvrTm6aEV503M/ucUDZ
	 rwKOKmo64XSX0Y8cLk7RCAqeT8Pmxb/sGPm0y5as1cZmVWi4iLrm6dWCcaWKchMaOc9Dk
	 vF9xtQMhYvs17+zSwlsMF1DlvTsl9JFJQEYUJrLZ/7CsB6FKkOK3+28GOYAdCbfMuiyBq
	 qpVPWaTdGfOo2/K6Dm4E8jirkzKUDn04C3ZwRduN/yUIt7mZ0FfXZ4YcDuVBjKTEedA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=apVTG27u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882B5606A33E;
	Mon,  2 Nov 2026 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=apVTG27u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051721F00A16;
	Mon,  2 Nov 2026 17:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793641480;
	bh=k7UZvy0vvY5D+HhvfYF+E9EdpF9huO3k00rhqXCPC6I=;
	h=Date:From:To:Cc:Subject;
	b=apVTG27uMskhhbZTrmLmAV9eRr9HrS1HUR5qbi9zfTEALUM2OekHVl6dM07zMhU9I
	 2IDsL3D3Oqs9Yv2+o+lKAP1ZE6sPozEY9TDuJIWdBHoVTH3ZqF8pVhQDU2pq3pBlZy
	 cso0jW6KHw63Itn0ESPx72NSLUQ5ql6Zran0/05c+3YC3O3tmvJ92NdfhlMmhxq+XS
	 rHGaMzx+AOvEqqAFoJnwodS2ALIQnpyNqN2E3u3gtmkKIkOYkg81oTsY71i6CVU176
	 WBSw2QyqukddCaWlN2qrGfIb42MZwr4tef8qcZogYwLm2+uiVsF/JNscjJKHUomu0U
	 +Kdm741227oMQ==
Date: Mon, 2 Nov 2026 09:44:28 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [GIT PULL] Crypto library fixes for v7.4-rc2
Message-ID: <20261102174428.GA1935@sol>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 5b0764a53235d3c77e1ed674e836e1b3fe1a4b1f:

  Merge tag 'drm-next-2026-10-21' of https://gitlab.freedesktop.org/drm/kernel (2026-10-23 18:29:02 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to 01ad209f122b7c173477bd60c7997564f9c65961:

  lib/crypto: mldsa: Add __must_check to mldsa_verify() (2026-10-29 10:12:11 -0700)

----------------------------------------------------------------

- Disable the MIPS64 Octeon optimized SHA-1, SHA-256, and SHA-512 code
  on little-endian kernels, since it doesn't work correctly on them

- Remove the PowerPC optimized Poly1305 code. It's already been marked
  as BROKEN for over a year due to not working in softirq context, but
  it turns out some of the Poly1305 math is incorrect too

- A few robustness improvements for the ML-DSA code

----------------------------------------------------------------
Eric Biggers (5):
      lib/crypto: mips: Disable Octeon SHA code on little-endian kernels
      lib/crypto: powerpc/poly1305: Remove BROKEN implementation
      lib/crypto: mldsa: Check pk_len before doing pointer arithmetic
      lib/crypto: mldsa: Explicitly check that 'alg' is a valid value
      lib/crypto: mldsa: Add __must_check to mldsa_verify()

 include/crypto/mldsa.h                 |    6 +-
 lib/crypto/Kconfig                     |   12 +-
 lib/crypto/Makefile                    |    2 -
 lib/crypto/mldsa.c                     |   15 +-
 lib/crypto/powerpc/poly1305-p10le_64.S | 1076 --------------------------------
 lib/crypto/powerpc/poly1305.h          |   76 ---
 lib/crypto/tests/mldsa_kunit.c         |    9 +
 7 files changed, 28 insertions(+), 1168 deletions(-)
 delete mode 100644 lib/crypto/powerpc/poly1305-p10le_64.S
 delete mode 100644 lib/crypto/powerpc/poly1305.h
