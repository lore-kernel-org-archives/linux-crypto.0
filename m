Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B77E4C042E;
	Tue, 19 May 2026 12:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779192017; cv=none; b=e3ypam+MLdTfcH/zTXiP/ruzxQPN98B5D/qreQCjDe2WNU36XV3GBm6SMh42wsJENIS9UTXgc83YYbUxk7tUY0jpC1bE/V0MVoHatqd2GTDFC5WcPqpp9YLtGlBs/ILOIg2umV6b79p6Z6ftdrIzOuVq46L3MI7J0MM39eJRvCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779192017; c=relaxed/simple;
	bh=wDO7GEUXeXyS8E1uTDjcdFpqy7kj7xWfJZOdfjsOhkw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igQsfaS/H88PSl11WFQYH8yeLunrAM97iBL/p0QMW0Blh9Uoix2ZA8cX+sAVzYOMDTol1JvXHd73gCGfq6mKhgQklmFaRwJ1+miN5zoFFcf5Y+CvxpDJUK5JBqLU2VdtliouZ0R2IwEawGsJAOW8zCbNC1vt0F/HG0FAigWBS5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=RQKuCEyh; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="RQKuCEyh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1779192015; x=1810728015;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rXLG1KoMFoXc0km+qhdSqd7fNlctoDqz7/CFRz99ewY=;
  b=RQKuCEyhwl7FxkerMVQk957/8C0EBCotsxSb00qIaITP1gy10gCcSrGr
   F4hwJ2NYBKEWXXppiUpQZ7hdRAuOMgcuYDhq4dceGSPdFGtPHtdQpOYbN
   ILQk/xb3fMA+Ci8LKSbclaPv2FfOK5/XlGtq6nB487PWnju210XotkQTL
   IbL3YAOjPrWq7syjiskFzrM/tp9p3YlOGbfG7Zc4L8jrML0vqgqpKFisx
   0Nd+0pWxbgt+KuT8eyX+RXJQv/mpiGxCdNFAbW9zzdmpCMDY41HnZAPFm
   haol0q4YP2iNno+eDD74wKfrVOpYX+VetOnO5uKpfACxr5D2FAQzujAjn
   Q==;
X-CSE-ConnectionGUID: fDr5nkZATIKBpPap++WfdA==
X-CSE-MsgGUID: UxdCODDlRAG8lafNx2uvuQ==
X-IronPort-AV: E=Sophos;i="6.23,243,1770595200"; 
   d="scan'208";a="20004675"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 12:00:12 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:29478]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.56.132:2525] with esmtp (Farcaster)
 id 0a7f232c-d666-4c76-9bab-01baed5f38c4; Tue, 19 May 2026 12:00:12 +0000 (UTC)
X-Farcaster-Flow-ID: 0a7f232c-d666-4c76-9bab-01baed5f38c4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 19 May 2026 12:00:12 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 19 May 2026 12:00:09 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S . Miller" <davem@davemloft.net>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon
	<agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, Eric Biggers
	<ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: [PATCH 0/4] crypto: skcipher - per-tfm multi-data-unit batching
Date: Tue, 19 May 2026 11:59:56 +0000
Message-ID: <20260519120002.27267-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428101225.24316-1-lravich@amazon.com>
References: <20260428101225.24316-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D041UWB002.ant.amazon.com (10.13.139.179) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

This implements the multi-data-unit skcipher request flow proposed in
the RFC thread [1], following Herbert's ack of the IPsec-friendly
shape and the proof-of-concept performance numbers I posted in [2]
(+19% throughput / -40% CPU on a single-core arm64 system with a
hardware XTS-AES-256 accelerator running fio 4 KiB sequential writes
through dm-crypt).

The series adds a per-tfm "data unit size" to the skcipher API so a
caller can submit several data units in one crypto request, mirroring
the data_unit_size concept already exposed by struct blk_crypto_config
for inline encryption hardware.

The first user is dm-crypt, which today issues one skcipher request
per sector and so pays a per-sector cost in request allocation,
callback dispatch, completion handling, and scatterlist setup.
Allowing the cipher to consume a whole bio per request removes that
overhead.  As shown in [2], the per-sector cost dominates the profile
(~25% of CPU cycles) on a hardware accelerator where AES rounds
themselves are nearly free.

[1] https://lore.kernel.org/linux-crypto/...  (RFC: crypto: skcipher
    multi-data-unit requests for dm-crypt)
[2] Message-Id: 20260428101225.24316-1-lravich@amazon.com

Design overview
---------------

* Patch 1 adds an `unsigned int data_unit_size` field to
  `struct crypto_skcipher` (per-tfm: invariant for the consumer's
  lifetime, set once via `crypto_skcipher_set_data_unit_size()`),
  plus a capability flag CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT in
  `cra_flags` (type-specific high-byte range, mirroring the
  CRYPTO_AHASH_ALG_BLOCK_ONLY precedent).  `crypto_skcipher_encrypt()`
  and `crypto_skcipher_decrypt()` validate that `cryptlen` is a
  positive multiple of `data_unit_size`.  The setter rejects
  sub-blocksize values; algorithm registration rejects the flag for
  algorithms with `ivsize != 16`.

  Also exposes `skcipher_walk_data_units()` in
  <crypto/internal/skcipher.h> as a default per-DU dispatcher for
  drivers that don't want to roll their own.

* Patch 2 lets the generic `xts(...)` template advertise the flag
  when the inner cipher is synchronous.  This is the in-tree
  software producer of the new capability.

* Patch 3 extends `testmgr` with a self-comparison test that fires
  automatically for every alg advertising the flag.  The test
  encrypts random plaintext two ways - one batched request vs N
  back-to-back single-DU requests with derived IVs - and rejects
  the algorithm if the ciphertexts differ.

* Patch 4 turns dm-crypt on automatically when all of the following
  hold at table load: skcipher (not aead), `tfms_count == 1`, IV
  mode is plain or plain64, no per-sector `iv_gen_ops->post()`, no
  dm-integrity stacking, and the underlying cipher advertises the
  capability.  Heap-allocated scatterlists are stashed in
  `dm_crypt_request` and freed in `crypt_free_req_skcipher()`,
  initialised to NULL on every request alloc to keep the free path
  safe on the per-sector code path that does not use them.

This series intentionally does NOT add the capability flag to any
arch crypto driver.  Arch maintainers can opt in independently by
wrapping their xts(aes) entry points with skcipher_walk_data_units()
or, for hardware engines, by submitting one HW command for the whole
multi-DU request.  The contract documented in
crypto_skcipher_set_data_unit_size() is the only obligation.

Why per-tfm and why cra_flags
-----------------------------

`data_unit_size` is invariant for the tfm's lifetime in every
plausible consumer.  dm-crypt picks one sector size per mapped
target at table load.  fscrypt would pick one per master key.
IPsec would pick one per SA.  Putting the field on
`crypto_skcipher` (rather than on every `skcipher_request`) avoids
growing a hot per-request struct used by fscrypt, IPsec ESP,
AF_ALG, etc.  It also lets the driver validate the value once in
`setkey()` and keeps the encrypt/decrypt fast path single-branch
(`likely(!data_unit_size)`).

The capability lives in `cra_flags` for consistency with existing
skcipher capabilities, so it surfaces in `/proc/crypto` and templates
can OR it into derived algorithms.

IV semantics
------------

The contract documented in `crypto_skcipher_set_data_unit_size()`:
the algorithm treats the caller-supplied IV as a 128-bit
little-endian counter and adds the data-unit index for each
subsequent data unit.  This is what dm-crypt's plain and plain64
generators already produce, so no IV translation is needed at the
boundary.  For modes that don't fit (essiv, lmk, tcw, eboiv,
plain64be, random, null, benbi, elephant) dm-crypt falls back to the
existing per-sector path.

Verification
------------

* checkpatch.pl --strict: clean on all 4 patches.
* Builds clean on x86_64 and arm64.
* QEMU boots; existing xts-aes-aesni / xts-aes-ce / xts-aes-neon
  crypto self-tests pass.
* In-kernel testmgr self-comparison passes for any algorithm
  advertising the flag.
* dm-crypt round-trip with plain64: encrypt+decrypt produces correct
  data through both the existing per-sector path and the multi-DU
  path (the latter exercised against an out-of-tree arm64 / x86 xts
  enablement during development).
* dm-crypt activation gating: plain -> enabled, plain64 -> enabled,
  essiv:sha256 -> fallback (correctly rejected), plain64be ->
  fallback.
* Byte-equivalence: 256 MB of ciphertext written through the
  multi-DU path is bit-identical to ciphertext written through the
  per-sector path (sha256
  4913910b1aa6f8859fcb8f4adec20230274993a3ade8f4dd0140a323dc43efc0
  on plain64+xts-aes).  The on-disk format is unchanged.

Leonid Ravich (4):
  crypto: skcipher - add per-tfm data_unit_size for batched requests
  crypto: xts - support multiple data units per request in template
  crypto: testmgr - exercise multi-data-unit path for skcipher
  dm crypt: batch all sectors of a bio per crypto request

 crypto/skcipher.c                  | 120 ++++++++++++++
 crypto/testmgr.c                   | 129 +++++++++++++++
 crypto/xts.c                       |  25 ++-
 drivers/md/dm-crypt.c              | 248 ++++++++++++++++++++++++++++-
 include/crypto/internal/skcipher.h |  34 ++++
 include/crypto/skcipher.h          |  85 ++++++++++
 6 files changed, 632 insertions(+), 9 deletions(-)

-- 
2.47.3

