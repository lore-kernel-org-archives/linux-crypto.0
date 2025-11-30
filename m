Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1D4191;
	Sun, 30 Nov 2025 02:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764471117; cv=none; b=mPDpw43NFbavEppwVQPycekqrtGo/hOxPi2zUJdz0Lv6aBgk//81hYfnwHgRyWV50uvikWDIxVwQQfwiJoZrmn2/lOT/tN5c9Y+lxMjka7LCNSEiJSIi1coAhDFS8WJTaaSl7kdHjLBg7aQOEV1Ny4wSybMKv9WF/R/scD4+DGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764471117; c=relaxed/simple;
	bh=iP2nnz3SLsAsPXQaewl2x+7GiDsiPr1YKG7UmsnWKjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Asat4YFNE5AylqakabC1vW/QMx06fPzG3QtKe6owS5tWzDLJLLntPigUj68wnx6ZzELzPIFeKklZtF6c3LUqxJNJqzLaZsEABiX8S456OdR9RrcVZGb7J329r1m5rGvzsruC5xcKdagkmpktgSfg0/RDOixtLpEjcQOot/+jep0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FnAGRCRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FnAGRCRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60563C4CEF7;
	Sun, 30 Nov 2025 02:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764471116;
	bh=iP2nnz3SLsAsPXQaewl2x+7GiDsiPr1YKG7UmsnWKjQ=;
	h=Date:From:To:Cc:Subject:From;
	b=FnAGRCRJlujYxId/hdAf2D47Xuf+jhGrsdG0oykmwZzwYIGT/rXEszWuTJmf0Tms2
	 b4aeq5UVzUGGtziiERgnkXyhArDZr9Ny7pwM3YZn0F0we9IAPvZDIGqSQqJ/l2+yA1
	 4zkzBm95kgq0lTh6JaXFXx4Vmt9JsQOc3UDFdsDSoERPPR4wxXthkEP+a5SqrINbN9
	 mwrQi+wtWLFxqXiWK9wbldtxbSG/31ZGnuwt7Gtgi8dmd93NNyHryxwPn+73UdN67P
	 kb8XXupYvIiNc2AKO1lU9+9v7zOaazI/G8B4Nn3oGqUAM2NajNS1dRzeRH8VwQDiHj
	 o39czpT29jE8w==
Date: Sat, 29 Nov 2025 18:50:06 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Kees Cook <kees@kernel.org>
Subject: [GIT PULL] 'at_least' array sizes for 6.19
Message-ID: <20251130025006.GE12664@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa:

  Linux 6.18-rc3 (2025-10-26 15:59:49 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-at-least-for-linus

for you to fetch changes up to 4f0382b0901b43552b600f8e5f806295778b0fb0:

  lib/crypto: sha2: Add at_least decoration to fixed-size array params (2025-11-23 12:19:47 -0800)

----------------------------------------------------------------

C supports lower bounds on the sizes of array parameters, using the
static keyword as follows: 'void f(int a[static 32]);'. This allows
the compiler to warn about a too-small array being passed.

As discussed, this reuse of the 'static' keyword, while standard, is a
bit obscure. Therefore, add an alias 'at_least' to compiler_types.h.

Then, add this 'at_least' annotation to the array parameters of
various crypto library functions.

----------------------------------------------------------------
Eric Biggers (6):
      lib/crypto: chacha: Add at_least decoration to fixed-size array params
      lib/crypto: curve25519: Add at_least decoration to fixed-size array params
      lib/crypto: md5: Add at_least decoration to fixed-size array params
      lib/crypto: poly1305: Add at_least decoration to fixed-size array params
      lib/crypto: sha1: Add at_least decoration to fixed-size array params
      lib/crypto: sha2: Add at_least decoration to fixed-size array params

Jason A. Donenfeld (3):
      wifi: iwlwifi: trans: rename at_least variable to min_mode
      compiler_types: introduce at_least parameter decoration pseudo keyword
      lib/crypto: chacha20poly1305: Statically check fixed array lengths

 drivers/net/wireless/intel/iwlwifi/iwl-trans.c |  8 ++--
 include/crypto/chacha.h                        | 12 +++---
 include/crypto/chacha20poly1305.h              | 19 ++++-----
 include/crypto/curve25519.h                    | 24 +++++++-----
 include/crypto/md5.h                           | 11 +++---
 include/crypto/poly1305.h                      |  2 +-
 include/crypto/sha1.h                          | 12 +++---
 include/crypto/sha2.h                          | 53 +++++++++++++++-----------
 include/linux/compiler_types.h                 | 15 ++++++++
 lib/crypto/chacha20poly1305.c                  | 18 ++++-----
 10 files changed, 103 insertions(+), 71 deletions(-)
