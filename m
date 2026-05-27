Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0C030569E;
	Wed, 27 May 2026 06:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779864634; cv=none; b=lQnf8/HxVkFcyT678vg7OzLlh0SgQIlvdvurKHQpSKGuwJI1v3RrK25KzNUUw0Pkr3NM8BVce551VDe22N/wLez7y0bKTbztlmhqyOQjxd6CceaBuQ6GXh7nA4OIBNAPTes54wiXNlrYfaXixV3T0vRZ5HFT8mFS4HlLCJpKgKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779864634; c=relaxed/simple;
	bh=djbJ6vooGc0EJBfZODTN/mvJKoxZcL655+9VpiaHpw4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cq531FQQARoJaUICw25s8YJqJ3PgNDG5y4cVJZHZICfHgZmPMEsK/qBbp8xj+2/ME4ql0u2pg+JIkUwFJJje3SK37iN9d8qYqqlYW7xe3Hbx72MTw1uIM+LmfhQLz1Ldi+UJNQvQH/V5OsDgA8X6+mcTCCYqoAxk2/r8naUrM/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=hZIFNeqW; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="hZIFNeqW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1779864632; x=1811400632;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JK5dJh3OTuRpntIesE7c/TPDGOcT/qz3MBXu5Ltjclw=;
  b=hZIFNeqWxBFT6Yr/yqOAraDnzHKxi+N3kWDXT/LTVMFVUJtw3Tyw+2Qb
   DeX/IuaG7r+LVoNtKCLoKongVbbmVz7ixhHW4YrF+DFCU6YlmUMfIHrrG
   PKJ8QdIZDXVn5cNKmamMeY3eIoDUgaTnIWfGKNE5IrUQHDf3jgdfvyr7g
   YEX9PllEk2dGP/H+5ZCneZCmmj8UwDN47dGSVc2wdwbyk0QkKzilq3+h7
   iruy1d9QlJDNz0/cBsziLL/5B7bKJ02V+8ECBokwQARTn9Fb0weTanw7e
   1ITz5ZsbdApACM4iY6wRBaY//JHA+Jt3Au7cmJbIGh/B75hx/uI4dzuuS
   g==;
X-CSE-ConnectionGUID: WDe2ww3EQICOkeePhnr2mw==
X-CSE-MsgGUID: Z1FEUVU/TlOAvf5oscOtuA==
X-IronPort-AV: E=Sophos;i="6.24,171,1774310400"; 
   d="scan'208";a="20413745"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 06:50:29 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:2488]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.62.206:2525] with esmtp (Farcaster)
 id d7326058-5df9-4e01-89dc-72fa5bb92ea0; Wed, 27 May 2026 06:50:29 +0000 (UTC)
X-Farcaster-Flow-ID: d7326058-5df9-4e01-89dc-72fa5bb92ea0
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 27 May 2026 06:50:28 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Wed, 27 May 2026 06:50:26 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S . Miller" <davem@davemloft.net>, Mike Snitzer
	<snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon
	<agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, Eric Biggers
	<ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: [PATCH v2 0/4] crypto: skcipher - per-tfm multi-data-unit batching
Date: Wed, 27 May 2026 06:50:16 +0000
Message-ID: <20260527065021.19525-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D042UWA004.ant.amazon.com (10.13.139.16) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

This is v2 of the multi-data-unit skcipher request series, addressing
review feedback from Mikulas Patocka on v1.

v1: https://lore.kernel.org/linux-crypto/20260519115955.27267-1-lravich@amazon.com/

The series adds a per-tfm "data unit size" to the skcipher API so a
caller can submit several data units in one crypto request, mirroring
the data_unit_size concept already exposed by struct blk_crypto_config
for inline encryption hardware.  The first user is dm-crypt, which
today issues one skcipher request per sector and so pays a per-sector
cost in request allocation, callback dispatch, completion handling,
and scatterlist setup.

Proof-of-concept performance numbers from the RFC reply [1]: +19%
throughput / -40% CPU on a single-core arm64 system with a hardware
XTS-AES-256 accelerator running fio 4 KiB sequential writes through
dm-crypt, when an out-of-tree arm64 xts driver advertises the new
flag.  This series itself does not include arch enablement.

[1] https://lore.kernel.org/linux-crypto/20260428101225.24316-1-lravich@amazon.com/

Changes since v1
----------------

Patch 4 (dm-crypt) only.  Patches 1-3 are unchanged from v1.

  - Multi-DU scatterlist allocation now uses
    GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN, so the allocator does
    not loop forever waiting for memory that won't come on the
    swap-out-to-dm-crypt path.  (Mikulas)

  - On scatterlist allocation failure, return -EAGAIN instead of
    -ENOMEM.  crypt_convert() handles -EAGAIN by clearing its
    local multi_du flag and re-entering the per-sector path for
    the rest of this crypt_convert() invocation.  The per-tfm
    data_unit_size on the cipher remains set, so subsequent bios
    (which start a fresh crypt_convert() and re-read cipher_flags)
    get to try multi-DU again once memory pressure eases.

    This gives forward progress under total memory exhaustion: the
    per-sector path uses only cc->req_pool (a mempool with
    reservoir set up at table-load time) and the inline
    dmreq->sg_in[]/sg_out[] arrays, never doing any allocation
    that could fail.  The previous v1 mapping of -ENOMEM to
    BLK_STS_DEV_RESOURCE could loop indefinitely on swap, since
    the bio retry would try the same multi-DU allocation again.
    (Mikulas)

  - Walk the bio with __bio_for_each_bvec instead of
    __bio_for_each_segment.  __bio_for_each_segment splits each
    bvec at PAGE_SIZE boundaries; __bio_for_each_bvec keeps
    multi-page bvecs as single units, which is faster with folios
    and produces fewer scatterlist entries.  (Mikulas)

Design overview (unchanged from v1)
-----------------------------------

* Patch 1 adds an `unsigned int data_unit_size` field to
  `struct crypto_skcipher` (per-tfm: invariant for the consumer's
  lifetime, set once via `crypto_skcipher_set_data_unit_size()`),
  plus a capability flag CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT in
  `cra_flags` (type-specific high-byte range, mirroring the
  CRYPTO_AHASH_ALG_BLOCK_ONLY precedent).  `crypto_skcipher_encrypt()`
  and `crypto_skcipher_decrypt()` validate that `cryptlen` is a
  positive multiple of `data_unit_size`.  The setter rejects
  sub-blocksize values; algorithm registration rejects the flag
  for algorithms with `ivsize != 16`.

  Also exposes `skcipher_walk_data_units()` in
  <crypto/internal/skcipher.h> as a default per-DU dispatcher for
  drivers that don't want to roll their own.

* Patch 2 lets the generic `xts(...)` template advertise the flag
  when the inner cipher is synchronous.  This is the in-tree
  software producer of the new capability.

* Patch 3 extends `testmgr` with a self-comparison test that fires
  automatically for every alg advertising the flag.

* Patch 4 turns dm-crypt on automatically when all of the
  following hold at table load: skcipher (not aead), tfms_count
  == 1, IV mode is plain or plain64, no per-sector
  iv_gen_ops->post() hook, no dm-integrity stacking, and the
  underlying cipher advertises the capability.

This series intentionally does NOT add the capability flag to any
arch crypto driver.  Arch maintainers can opt in independently in
follow-up patches by wrapping their xts(aes) entry points with
skcipher_walk_data_units() or, for hardware engines, by submitting
one HW command for the whole multi-DU request.

Verification
------------

* checkpatch.pl --strict: clean on all 4 patches.
* Builds clean on x86_64 (defconfig + DM_CRYPT + CRYPTO_AES_NI_INTEL)
  and arm64 (cross-compile, defconfig + DM_CRYPT +
  CRYPTO_AES_ARM64_CE_BLK + CRYPTO_AES_ARM64_NEON_BLK) on top of
  axboe/for-next (a8cafdf8c949).
* QEMU boots; existing xts-aes-aesni / xts-aes-ce / xts-aes-neon
  crypto self-tests pass.
* In-kernel testmgr self-comparison passes for any algorithm
  advertising the flag.
* dm-crypt round-trip with plain64: PASS on x86 and arm64.
* dm-crypt round-trip with essiv:sha256 (single-DU path): PASS.
* dm-crypt large-bio: PASS.
* dm-crypt activation gating: plain -> enabled, plain64 ->
  enabled, essiv:sha256 -> fallback, plain64be -> fallback.
* Byte-equivalence: 256 MB of ciphertext written through the
  multi-DU path is bit-identical to ciphertext written on an
  unpatched axboe/for-next baseline (sha256
  4913910b1aa6f8859fcb8f4adec20230274993a3ade8f4dd0140a323dc43efc0).
* Low-memory boot (mem=128M): PASS — no regression in the
  per-sector path under tight memory.

The OOM-fallback path (multi-DU helper returns -EAGAIN, caller
reverts to per-sector) is verified by inspection: the fallback is
two lines in crypt_convert(), the per-sector path uses only the
existing mempool reserve and the inline dmreq SG arrays (no
allocation that could fail), and there is no shared state between
the two paths that could deadlock.

Leonid Ravich (4):
  crypto: skcipher - add per-tfm data_unit_size for batched requests
  crypto: xts - support multiple data units per request in template
  crypto: testmgr - exercise multi-data-unit path for skcipher
  dm crypt: batch all sectors of a bio per crypto request

 crypto/skcipher.c                  | 120 +++++++++++++
 crypto/testmgr.c                   | 129 ++++++++++++++
 crypto/xts.c                       |  25 ++-
 drivers/md/dm-crypt.c              | 272 ++++++++++++++++++++++++++++-
 include/crypto/internal/skcipher.h |  34 ++++
 include/crypto/skcipher.h          |  85 +++++++++
 6 files changed, 656 insertions(+), 9 deletions(-)


base-commit: a8cafdf8c949f17c92eca0045532e88ac0dac30d
-- 
2.47.3

