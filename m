Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B93346E56;
	Mon,  1 Jun 2026 08:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.245.243.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780304217; cv=none; b=qogqkOlFL4lXDz9yzxYoBAFhoxxyvArDd8tboIlek8latusKCxIjeKrJz/QNmWi273qqIzS48R55WUPB4TeP6cdU8wJLTx7/KX8/ILhY3QgmyCqTrWKjvVVHXkMIs6B+5y535tmDExGcW/cI9IK6K+bVK5WwksJVxJsXqz3Hlx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780304217; c=relaxed/simple;
	bh=qAZ4FgCDdoGgok26w2HQG3LR0EHPJ2K5/hlohTE+/9I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NZjMfSCkysZhl3yxtDQG8jdBmjb7uZpSvoW5pZFbpotXBckT1B8oijeXelb0h0He4jWZSAPgXzlX9sOPkwNQFk+KLJx4pFimx2oYbafUwLGABAbhBWv/e6yDx9tWAAY/M7tMbVUIt9mkXvb83SjF7oXT9TYez9/kd7N7ekvBPTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=BQ2A+hHV; arc=none smtp.client-ip=44.245.243.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="BQ2A+hHV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1780304214; x=1811840214;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ymtn60IMDtZyz70m2rrmpV8+GhXXyb9X4BQIXzuwKdo=;
  b=BQ2A+hHVgeftSp09JQJYH8tUk2bFQrRHCRgghIcr5jV7cwUgtvgwvwK+
   aHnvJ7ZeFcDPILemTiypp+0YaiEgMbHWgLeS5s3RQQvYkwwAKVl8DcmGa
   BRdw0fnHkSogXsdY3dwaTnK+yaJiK5H8n09ft76NHe+SMwsj+eRNrn/RB
   f30Ec48Kgqm/nRiYbARS05G2kXi67ZV3tVOLJjVVwGnY9mNAw7Gyw1zk/
   0tP8JYVRQpypNs75yMbD7Y39AvyuJMCd31iLX3gnVFP3I/cBnXeD2QaTi
   PKoYYUWHO/bNu1V3i59BLIitchRPiVR6N5WSYiKpwa/HWmsftekhYVJfF
   w==;
X-CSE-ConnectionGUID: kPkfHEvcQcy5lJL8BzXZhA==
X-CSE-MsgGUID: RgogAhS5SySxK/uXW20BPg==
X-IronPort-AV: E=Sophos;i="6.24,180,1774310400"; 
   d="scan'208";a="20338963"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 08:56:51 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:17165]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.6.91:2525] with esmtp (Farcaster)
 id 50f9dd4c-1df3-4494-874c-6a577002553d; Mon, 1 Jun 2026 08:56:51 +0000 (UTC)
X-Farcaster-Flow-ID: 50f9dd4c-1df3-4494-874c-6a577002553d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 1 Jun 2026 08:56:50 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Mon, 1 Jun 2026 08:56:48 +0000
From: Leonid Ravich <lravich@amazon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Alasdair Kergon <agk@redhat.com>, Ard Biesheuvel <ardb@kernel.org>, "Eric
 Biggers" <ebiggers@kernel.org>, Jens Axboe <axboe@kernel.dk>, Horia Geanta
	<horia.geanta@nxp.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
	<linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	<linux-block@vger.kernel.org>
Subject: [PATCH v3 0/4] crypto: skcipher - per-tfm multi-data-unit batching
Date: Mon, 1 Jun 2026 08:56:40 +0000
Message-ID: <20260601085644.13026-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

This is v3 of the multi-data-unit skcipher request series, addressing
review feedback from Mikulas Patocka on v2.

v2: https://lore.kernel.org/linux-crypto/20260527065021.19525-1-lravich@amazon.com/
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

Changes since v2
----------------

Patch 4 (dm-crypt) only.  Patches 1-3 are unchanged from v2.

  - Replace integer division with the equivalent shift, and tighten
    the size sanity check from "is total < sector_size?" to "is
    total a multiple of sector_size?".  Reject unaligned residues
    explicitly instead of silently truncating them.  The local
    n_sectors variable used only for a now-redundant !=0 check was
    dropped — crypt_convert()'s outer while-loop already guarantees
    iter_in.bi_size > 0 on entry.  (Mikulas)

  - Drop `min(iter_in.bi_size, iter_out.bi_size)` in favour of using
    iter_in.bi_size directly, with a WARN_ON_ONCE() to flag any
    future violation of the "iter_in and iter_out describe equally-
    sized payloads" invariant maintained by crypt_convert_init().
    Replaces a silent mask of a real bug with an explicit warning.
    (Mikulas)

Changes since v1
----------------

Patch 4 only.  Addressed Mikulas's review of v1:

  - Multi-DU scatterlist allocation uses
    GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN.

  - On scatterlist allocation failure, return -EAGAIN.
    crypt_convert() handles -EAGAIN by clearing its local multi_du
    flag and re-entering the per-sector path for the rest of this
    crypt_convert() invocation.  The per-tfm data_unit_size on the
    cipher remains set, so subsequent bios (which start a fresh
    crypt_convert() and re-read cipher_flags) get to try multi-DU
    again once memory pressure eases.

    This gives forward progress under total memory exhaustion: the
    per-sector path uses only cc->req_pool (a mempool with reservoir
    set up at table-load time) and the inline
    dmreq->sg_in[]/sg_out[] arrays, never doing any allocation that
    could fail.

  - Walk the bio with __bio_for_each_bvec instead of
    __bio_for_each_segment for folio-friendly SG construction.

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
  sub-blocksize values; algorithm registration rejects the flag for
  algorithms with `ivsize != 16`.

  Also exposes `skcipher_walk_data_units()` in
  <crypto/internal/skcipher.h> as a default per-DU dispatcher for
  drivers that don't want to roll their own.

* Patch 2 lets the generic `xts(...)` template advertise the flag
  when the inner cipher is synchronous.

* Patch 3 extends `testmgr` with a self-comparison test that fires
  automatically for every alg advertising the flag.

* Patch 4 turns dm-crypt on automatically when all of the
  following hold at table load: skcipher (not aead), tfms_count
  == 1, IV mode is plain or plain64, no per-sector
  iv_gen_ops->post() hook, no dm-integrity stacking, and the
  underlying cipher advertises the capability.

This series intentionally does NOT add the capability flag to any
arch crypto driver.  Arch maintainers can opt in independently in
follow-up patches.

Verification
------------

A formal regression protocol is included in the project tree
(.claude/regression-protocol.md, .claude/run-regression.sh).  The
v3 reference run reports 12/12 cases PASS:

  - x86 + arm64 build clean (with and without out-of-tree arch
    enablement).
  - checkpatch.pl --strict: clean on all 4 patches.
  - testmgr self-comparison: PASS for any algorithm advertising the
    flag (verified end-to-end against an out-of-tree arm64/x86 xts
    driver during regression).
  - dm-crypt activation gating: plain/plain64 enabled,
    essiv:sha256 / plain64be fall back.
  - dm-crypt round-trip plain64: PASS with multi-DU active.
  - dm-crypt round-trip essiv:sha256 (per-sector path on multi-DU
    kernel): PASS.
  - dm-crypt low-memory (mem=128M): PASS, no OOM kill.
  - Byte-equivalence: 256 MB of ciphertext written through the
    multi-DU path is bit-identical to ciphertext written through
    the per-sector path on an unpatched axboe/for-next baseline
    (sha256
    4913910b1aa6f8859fcb8f4adec20230274993a3ade8f4dd0140a323dc43efc0).
    The on-disk format is unchanged.
  - arm64 functional (activation + round-trip) under qemu-aarch64:
    PASS.

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

 crypto/skcipher.c                  | 120 ++++++++++++
 crypto/testmgr.c                   | 129 +++++++++++++
 crypto/xts.c                       |  25 ++-
 drivers/md/dm-crypt.c              | 281 ++++++++++++++++++++++++++++-
 include/crypto/internal/skcipher.h |  34 ++++
 include/crypto/skcipher.h          |  85 +++++++++
 6 files changed, 665 insertions(+), 9 deletions(-)


base-commit: a8cafdf8c949f17c92eca0045532e88ac0dac30d
-- 
2.47.3

