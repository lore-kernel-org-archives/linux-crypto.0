Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E2032E137;
	Mon,  2 Mar 2026 08:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772438480; cv=none; b=q5dao75qA6KVO+u90wWoLO2iw9JpIjmWrsvmIj1UijTrF0wF2YyWH+0LkQL/9Bq45OhOxE/ytWawsX5rOXd9vqZTxnmX80p8DD5VA9TjfQWLoMOpKKoasvYhpU7Lh20bpap2zQ7rcVdAM/D02QAmmZ2b6gmri31vCCpyxRUu1OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772438480; c=relaxed/simple;
	bh=harymnB7hCX/JjGHppJgWSHiwMixCAs5CzazQ0NoDZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rw09D0yCCXPxymozrsIMvPdfGD8WW0P1WVyE9XvLx9N/64w1GDOikgMr/5PF00JjAP5HukdNfkl9i0ryLvGJulD6R/im1bo4G3e6wFvsPRRcrv2qb9y4mAh/eRW3byOzZ9CbpzmuSxooemezBaodbRAJKLSCFwhFtd8Y4S69DfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SRgASHfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SRgASHfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EF9C2BCAF;
	Mon,  2 Mar 2026 08:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772438479;
	bh=harymnB7hCX/JjGHppJgWSHiwMixCAs5CzazQ0NoDZU=;
	h=From:To:Cc:Subject:Date:From;
	b=SRgASHfdbLnhF9xMKATAZFw1YLttrhvaHwDhCnn+CTUqgRHBxPiwKi97jZ6v6hnvF
	 hLgIEjo1xHoNtP12rQgHF9NzlxUkKt92IAeOtcuKfet3BBLT65Am2Q3ourzptXzTkm
	 lMfAkPd/RxjX3BIhsuFOTS/05gvmPcY1MYUpGYKfVUBeV3NYEcN5f3QdssHFE9mLBY
	 zFGD9e2OEBWLzHAzvyrIZFwAH2MhFRgnzMDKbFL5F41PhQwxCqMc5oDBbvH98r6Jf3
	 shdw0AFx9q+OYb6KtvDJ5e8wP7DNyAwbAH9qGnpIyFHtkvNK74oic+5gixllz3tDcg
	 xYOmG4gfa/pLg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-nvme@lists.infradead.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 00/21] nvme-auth: use crypto library for HMAC and hashing
Date: Sun,  1 Mar 2026 23:59:38 -0800
Message-ID: <20260302075959.338638-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series converts the implementation of NVMe in-band authentication
to use the crypto library instead of crypto_shash for HMAC and hashing.

The result is simpler, faster, and more reliable.  Notably, it
eliminates a lot of dynamic memory allocations, indirect calls, lookups
in crypto_alg_list, and other API overhead.  It also uses the library's
support for initializing HMAC contexts directly from a raw key, which is
an optimization not accessible via crypto_shash.  Finally, a lot of the
error handling code goes away, since the library functions just always
succeed and return void.

The last patch removes crypto/hkdf.c, as it's no longer needed.

This series applies to v7.0-rc1 and is targeting the nvme tree.

I've tested the TLS key derivation using the KUnit test suite added in
this series.  I don't know how to test the other parts, but it all
should behave the same as before.

Eric Biggers (21):
  nvme-auth: add NVME_AUTH_MAX_DIGEST_SIZE constant
  nvme-auth: common: constify static data
  nvme-auth: use proper argument types
  nvme-auth: common: add KUnit tests for TLS key derivation
  nvme-auth: rename nvme_auth_generate_key() to nvme_auth_parse_key()
  nvme-auth: common: explicitly verify psk_len == hash_len
  nvme-auth: common: add HMAC helper functions
  nvme-auth: common: use crypto library in nvme_auth_transform_key()
  nvme-auth: common: use crypto library in
    nvme_auth_augmented_challenge()
  nvme-auth: common: use crypto library in nvme_auth_generate_psk()
  nvme-auth: common: use crypto library in nvme_auth_generate_digest()
  nvme-auth: common: use crypto library in nvme_auth_derive_tls_psk()
  nvme-auth: host: use crypto library in
    nvme_auth_dhchap_setup_host_response()
  nvme-auth: host: use crypto library in
    nvme_auth_dhchap_setup_ctrl_response()
  nvme-auth: host: remove allocation of crypto_shash
  nvme-auth: target: remove obsolete crypto_has_shash() checks
  nvme-auth: target: use crypto library in nvmet_auth_host_hash()
  nvme-auth: target: use crypto library in nvmet_auth_ctrl_hash()
  nvme-auth: common: remove nvme_auth_digest_name()
  nvme-auth: common: remove selections of no-longer used crypto modules
  crypto: remove HKDF library

 crypto/Kconfig                         |   6 -
 crypto/Makefile                        |   1 -
 crypto/hkdf.c                          | 573 ------------------------
 drivers/nvme/common/.kunitconfig       |   6 +
 drivers/nvme/common/Kconfig            |  14 +-
 drivers/nvme/common/Makefile           |   2 +
 drivers/nvme/common/auth.c             | 587 ++++++++++---------------
 drivers/nvme/common/tests/auth_kunit.c | 175 ++++++++
 drivers/nvme/host/auth.c               | 160 +++----
 drivers/nvme/host/sysfs.c              |   4 +-
 drivers/nvme/target/auth.c             | 198 +++------
 drivers/nvme/target/configfs.c         |   3 -
 drivers/nvme/target/fabrics-cmd-auth.c |   4 +-
 drivers/nvme/target/nvmet.h            |   2 +-
 include/crypto/hkdf.h                  |  20 -
 include/linux/nvme-auth.h              |  41 +-
 include/linux/nvme.h                   |   5 +
 17 files changed, 571 insertions(+), 1230 deletions(-)
 delete mode 100644 crypto/hkdf.c
 create mode 100644 drivers/nvme/common/.kunitconfig
 create mode 100644 drivers/nvme/common/tests/auth_kunit.c
 delete mode 100644 include/crypto/hkdf.h


base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
-- 
2.53.0

