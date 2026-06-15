Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D60A3E451B;
	Mon, 15 Jun 2026 11:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.155.198.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781522113; cv=none; b=HeiFgtWDaibPLlDT/ADIbTeD05mLUG6zwUqXw97ToS+rCr39ug2XZss5VERCLmBV2RIiHg+X0WCoyzyXmNyxlTSs7Fbe6gNLwG5RvL8zCnq/WIlzH7fFBfVrzXWoxuWnvwVAmkPqiExTHyiAC3UTCBfCBxjBWwIJez35L6Y+Nqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781522113; c=relaxed/simple;
	bh=4qxA6nt12MB6J4JYhxoU/BaIab0VkodCSt1YcG1ZBgM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=a6Up9p9bk7jZ1tl1dmVcXakeMpjSVWXAJ5O1cuKgv1eXSQMrwFlebe0dekI5d7ztsDqtf+ozB88k6NKEBpmGJCFn9BVxmESIOGTK3jwdNE+4IYfYQlKGflWnxWnluH1mh8PREXKsCrqm90MGV5wN3hJfKMgkLr4j7DtzvAzj564=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=CLfzPQlk; arc=none smtp.client-ip=35.155.198.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="CLfzPQlk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1781522111; x=1813058111;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=opXr0pmLNEySRB5LXiXE6+JDy/6A+VBsccrBU2jakqQ=;
  b=CLfzPQlkg/qLOl9RLIcw6yw+uwwB4oawYPveDT+ggfmVRqc3JhafMqXR
   aViwC6vLyGX9r1Yoe5dqvMNGkFKuBqoFuFyikHrgs1k2DBV8H9KIAUTlL
   dCr2Egv7+MGHqhvrz7od/JAnlVg76K/EAmH0ugsSnUHzn47s0eHaCWRgV
   65wP3Asl0Eqn1L1Yfw5woDIaJk/PPlqJh7RzHhGdvyEO8su9tXY+1Y4W9
   fDGpdJXZQpvBPgaItItsvslY2uKJsuVnCEj8jKdhOIu8DVdBjXc2EvL5d
   RAkGV4TH9mqijfrEUEIoLQfGxFZBQpq4zLyIlgUK1v1bRWlPb/8ODOnDa
   g==;
X-CSE-ConnectionGUID: hYXEEybsQFqGqhk2NmeNiQ==
X-CSE-MsgGUID: TIDpFDxnRoCTZYeU+aixKQ==
X-IronPort-AV: E=Sophos;i="6.24,206,1774310400"; 
   d="scan'208";a="21651477"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2026 11:15:07 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:11302]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.63.253:2525] with esmtp (Farcaster)
 id c2ed247b-4800-4aae-be93-7f2b1a40870b; Mon, 15 Jun 2026 11:15:06 +0000 (UTC)
X-Farcaster-Flow-ID: c2ed247b-4800-4aae-be93-7f2b1a40870b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 15 Jun 2026 11:15:06 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 15 Jun 2026 11:15:04 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Alasdair Kergon <agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, "Eric
 Biggers" <ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: [PATCH v4 0/3] crypto: skcipher - per-request multi-data-unit batching
Date: Mon, 15 Jun 2026 11:14:56 +0000
Message-ID: <20260615111459.9452-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D035UWA004.ant.amazon.com (10.13.139.109) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

This is v4, addressing Herbert's review of v3.  Two architectural
changes:

  - data_unit_size is now per-request (on struct skcipher_request)
    rather than per-tfm.  Reverts to the v1 placement.

  - The crypto API auto-splits multi-data-unit requests when the
    underlying algorithm does not advertise
    CRYPTO_ALG_SKCIPHER_NATIVE_MULTI_DU.  Consumers no longer test
    for multi-DU support before submitting; setting data_unit_size
    on any skcipher request whose algorithm uses the 128-bit LE
    counter IV convention "just works".

These two changes shrink the series from 4 patches to 3 (the
generic xts(...) template needs no special handling - the
auto-splitter calls its single-DU encrypt/decrypt once per data
unit) and simplify the dm-crypt consumer (no advertise-flag check,
no per-tfm setup).

v3: https://lore.kernel.org/linux-crypto/20260601085641.16028-1-lravich@amazon.com/
v2: https://lore.kernel.org/linux-crypto/20260527065021.19525-1-lravich@amazon.com/
v1: https://lore.kernel.org/linux-crypto/20260519115955.27267-1-lravich@amazon.com/

The series adds a per-request "data unit size" to the skcipher API
so a caller can submit several data units (typically 512..4096-byte
sectors) sharing one starting IV in a single request.  Algorithms
derive each data unit's IV from the caller-supplied IV by treating
it as a 128-bit little-endian counter and adding the data-unit
index, matching the layout produced by dm-crypt's plain64 IV mode
and by typical inline-encryption hardware.

This mirrors the data_unit_size concept already exposed by
struct blk_crypto_config for inline encryption.

The first user is dm-crypt, which today issues one skcipher request
per sector and so pays a per-sector cost in request allocation,
callback dispatch, completion handling, and scatterlist setup.

Proof-of-concept performance numbers from the RFC reply [1]: +19%
throughput / -40% CPU on a single-core arm64 system with a hardware
XTS-AES-256 accelerator running fio 4 KiB sequential writes through
dm-crypt, when an out-of-tree arm64 xts driver advertises
CRYPTO_ALG_SKCIPHER_NATIVE_MULTI_DU.  This series itself does not
include arch enablement; the fast path is opt-in per driver, the
slow path is universal via the auto-splitter.

The native fast path amortises both per-sector dispatch and per-sector
crypto setup across a bio - the measured win above, on an engine that
offloads the AES compute.  The auto-splitter is for correctness and
reach: any consumer can set data_unit_size and get correct output with
the per-request allocation/callback/completion cost removed, but it
still issues one alg->encrypt per data unit, so on a software cipher it
saves only dispatch overhead (no throughput figure claimed - that is
hardware- and workload-dependent).  What it guarantees unconditionally
is byte-identical output (Verification below) at O(entries + units),
walking the scatterlists with a pair of struct scatter_walk cursors
rather than rescanning from the head per unit.

[1] https://lore.kernel.org/linux-crypto/20260428101225.24316-1-lravich@amazon.com/

Changes since v3
----------------

- data_unit_size moved from struct crypto_skcipher (per-tfm) to
  struct skcipher_request (per-request).  (Herbert)

- Crypto API auto-splits multi-data-unit requests when the algorithm
  does not advertise CRYPTO_ALG_SKCIPHER_NATIVE_MULTI_DU.  Drops the
  per-tfm setter/probe in favour of a single
  skcipher_request_set_data_unit_size() usable by every consumer.
  (Herbert)

- CRYPTO_ALG_SKCIPHER_NATIVE_MULTI_DU is a type-specific cra_flags
  bit (0x01000000) in crypto/internal/skcipher.h, not a generic bit
  in the public header; drivers set it to opt OUT of auto-splitting.

- The auto-splitter advances through src/dst with a pair of struct
  scatter_walk cursors (scatterwalk_start / scatterwalk_get_sglist /
  scatterwalk_skip) instead of scatterwalk_ffwd() per unit, which
  rescans from the head and is O(units^2) under fragmentation; the
  cursors give a single linear pass.  (Eric)

- crypto_skcipher_validate_multi_du() reports -EINVAL for a malformed
  geometry (du not a power of two, cryptlen not a positive multiple)
  and -EOPNOTSUPP for a target that cannot do multi-DU (ivsize != 16,
  lskcipher, or async without the native flag), so a caller can fall
  back.  Gates the native path too, not just the auto-splitter.
  (Eric)

- testmgr cross-checks the batched dispatch against an independent
  N x single-DU reference with LE128-walked IVs over a fragmented
  scatterlist (pins the IV convention and exercises the cursor),
  round-trips, and checks IV preservation.  Ineligible algorithms
  skip via -EOPNOTSUPP; a real mismatch returns -EBADMSG.

- dm-crypt enables batching only for IV modes flagged sector_iv_le128
  (a new bool on struct crypt_iv_operations, set on plain64 only),
  plus ivsize 16, sync, single-tfm, no integrity, no post() hook.  The
  flag replaces a hardcoded plain64 pointer-compare, so eligibility is
  a self-documenting property of the IV mode rather than a special
  case.  plain stays excluded (its 32-bit counter wraps differently
  past 2^32 sectors).  Sets req->data_unit_size = sector_size and
  submits; -EOPNOTSUPP/-EAGAIN fall back to the per-sector path.
  Mikulas's v2 Reviewed-by is dropped as the dm-crypt patch was
  substantially rewritten.

- The generic xts(...) template needs no separate handling, dropping
  the v3 crypto/xts.c patch (4 -> 3 patches).

Design overview
---------------

* Patch 1 adds the data_unit_size field, the setter, the
  CRYPTO_ALG_SKCIPHER_NATIVE_MULTI_DU flag, and the auto-splitter in
  crypto_skcipher_encrypt()/decrypt().  skcipher_request_set_tfm()
  resets the field so a reused request defaults to single-DU.

* Patch 2 adds the testmgr multi-DU test (every ivsize == 16
  skcipher).

* Patch 3 turns dm-crypt batching on automatically under the
  conditions above and sets req->data_unit_size = cc->sector_size.

This series does NOT add the capability flag to any arch driver; the
auto-splitter ensures correctness without that opt-in.

Verification
------------

A regression protocol is included in the project tree
(.claude/regression-protocol.md, .claude/run-regression.sh).  The
reference run reports 12/12 PASS:

  - x86 + arm64 build clean; checkpatch.pl --strict clean.
  - testmgr multi-DU: PASS for every ivsize == 16 skcipher in-tree.
  - dm-crypt activation gating: plain64 enabled; essiv:sha256 /
    plain64be / plain fall back.
  - dm-crypt round-trip plain64 with multi-DU via the auto-splitter
    (xts-aes-aesni, no native flag): PASS.
  - dm-crypt round-trip essiv:sha256 (per-sector path): PASS.
  - dm-crypt low-memory (mem=128M): PASS, no OOM kill.
  - Byte-equivalence: 256 MB of ciphertext through the auto-splitter
    is bit-identical to an unpatched axboe/for-next baseline (sha256
    4913910b1aa6f8859fcb8f4adec20230274993a3ade8f4dd0140a323dc43efc0).
  - arm64 functional under qemu-aarch64: PASS.



Leonid Ravich (3):
  crypto: skcipher - add per-request data_unit_size with auto-splitting
  crypto: testmgr - test for multi-data-unit dispatch
  dm crypt: batch all sectors of a bio per crypto request

 crypto/skcipher.c                  | 132 +++++++++++++++++++
 crypto/testmgr.c                   | 192 +++++++++++++++++++++++++
 drivers/md/dm-crypt.c              | 215 +++++++++++++++++++++++++++--
 include/crypto/internal/skcipher.h |  10 ++
 include/crypto/skcipher.h          |  28 ++++
 5 files changed, 569 insertions(+), 8 deletions(-)


base-commit: a8cafdf8c949f17c92eca0045532e88ac0dac30d
--
2.47.3

