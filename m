Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2853F175A73;
	Tue, 30 Jun 2026 08:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782808485; cv=none; b=Jq+nJ24jJquuzUw+5Z62cVZAVvMmvguHdANwVxI7Vh5V861Bi5ysHz90unPbPakRAw9KnX8e/d+vDeJeYFD6VaNjBZztfSS1nTJe6BRev7L/DeszquKCUUTozDNAfgf69CdCJNAEnL5W3QlvwTd2wjnkl16w49EoAugonkjqfdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782808485; c=relaxed/simple;
	bh=JYaumYkBv0kjz2xoFNFCDUpGr+z6z9dCpj1s0A6VBy8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GHEq3ZTZTp59TeqVgdlHJ33OlZaZe1mRlg3uiESC1rDMZQTb9X/ShJNo/5fsB7v2YRtBOxJAP1JvoFAcAffjVB9Qfp429m/h5Iy/Wyvy3rWg6j3mSRHkef8hh3tUde2xSFWkarNFSME566oDi0XbZeTn48rNVd7Ub7hzpAxm0xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=VXHkggGK; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="VXHkggGK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1782808484; x=1814344484;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0wWIWx6VxC5AOt4Sl1rdWlyfm+czyirB2HJBLKnJQeo=;
  b=VXHkggGKw31kpSjjDZb+yHsQhm+41MBJgxzuvw1orvVc1gy1DLJLBpk3
   jQVVGxJYGlzKlB59lcqtPwsTwFTIhTiqEuWAjJnz23Uz8tgXEFOeqQwuK
   VCcLV8kIKJwlr65oeyRVyRXhMjbMhIIdWhzdF88D7+vp6A0PfcjF05VPx
   ZttxI9rv+cxSJ4bPlbvIiH30RDjn/KSjgXB8rbeiyrf5UBL2FmTUB5EYC
   LvklJGZRX6IeI+C78i0/h0zteKm6Uc4swbdu7nG6AumZuib2eVbfnHcOx
   LoJDTMb+XqXdymWTjL0DvSLkNEHmuYuCkJN72ezIghkh5QMyjdaGRnhcz
   g==;
X-CSE-ConnectionGUID: 12m0zAUKRxGRhidSawgPKA==
X-CSE-MsgGUID: R5zjJiWCTVmc5S6g7A4MCQ==
X-IronPort-AV: E=Sophos;i="6.24,233,1774310400"; 
   d="scan'208";a="22629074"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 08:34:41 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:1149]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.142:2525] with esmtp (Farcaster)
 id a6d397e5-85fb-4904-9f2d-a0b67e412c02; Tue, 30 Jun 2026 08:34:40 +0000 (UTC)
X-Farcaster-Flow-ID: a6d397e5-85fb-4904-9f2d-a0b67e412c02
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 08:34:40 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 08:34:38 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>
CC: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ebiggers@kernel.org>,
	<snitzer@kernel.org>, <mpatocka@redhat.com>, <axboe@kernel.dk>
Subject: [PATCH v5 0/5] crypto: skcipher - multi-data-unit dispatch as a template
Date: Tue, 30 Jun 2026 08:34:26 +0000
Message-ID: <20260630083431.2772-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWA001.ant.amazon.com (10.13.139.100) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

This is v5. It reworks the multi-data-unit support from the in-core
auto-splitter of v4 into a crypto template, dun(...), addressing the v4
review: there is now no added cost on the core skcipher path, no
per-algorithm capability flag, and the per-data-unit split lives in an
algorithm rather than in crypto_skcipher_encrypt/decrypt the shape
Herbert suggested, which removes the "overhead for everyone" Eric
objected to.

v4: https://lore.kernel.org/linux-crypto/20260615105022.8025-1-lravich@amazon.com/

Model
---

A skcipher_request gains a data_unit_size field (patch 1). When set,
the request covers cryptlen / data_unit_size data units sharing one
starting IV; per-unit IVs are derived from the IV as a wide data-unit-
number (DUN) counter the convention blk-crypto already uses for
inline encryption.

dun(...) (patch 2) is a template that wraps an inner skcipher whose IV
is that counter (e.g. dun(xts(aes),le)). Its ->encrypt/->decrypt split
the request into one inner call per data unit, walking the IV +1 each
unit; each inner call is direct, so only the outer dispatch into the API
is indirect. A plain skcipher is unchanged and ignores data_unit_size,
so existing callers pay nothing the field is inert and the core
en/decrypt path is untouched.

The second template parameter selects how the per-unit IV advances. A
neighbour relates by a +1 step in exactly one of two ways, little- or
big-endian, so dun(...,le) / dun(...,be) is a closed parameter space,
not an open-ended set of "IV types". Internally each is one row of a
small struct dun_mode op table (an iv_next walk plus an ivsize
predicate); adding a future convention e.g. a width-bounded counter,
or an affine sector<<shift+k step is one row, with the dispatch loop
unchanged. IV constructions that are not such a counter are simply not
wrapped (the consumer keeps its per-unit path); an IV that is encrypted
(essiv) composes as the inner algorithm, dun(essiv(...),le), since the
encryption already lives in that inner template.

Why a template
--------------

  - No core cost for anyone. crypto_skcipher_encrypt/decrypt are stock;
    only a dun() tfm reads data_unit_size. (addresses Eric's "adds
    checks/overhead for everyone")

  - No capability flag. A hardware engine that handles a whole multi-DU
    request in one pass registers its own dun(xts(aes),le) at a higher
    cra_priority and is picked automatically exactly how
    xts-aes-aesni already beats generic xts. No CRYPTO_ALG_* bit, no
    core branch choosing native-vs-split. Such a native driver may also
    be async (it owns its dispatch); only the generic template is
    sync-only.

  - The split is in the algorithm. (the direction Herbert described)

  - It is the same kind of wrapper crypto/ already has. Like cryptd()
    (async dispatch) and pcrypt() (parallel dispatch), dun() wraps an
    inner skcipher and changes only how the request is dispatched 
    here, split across data units performing no cipher transform of
    its own.

  - It is a reusable primitive, not a dm-crypt feature. Two in-tree
    consumers are included: dm-crypt (patch 4) and blk-crypto-fallback
    (patch 5), which both open-code the per-DUN loop today; fscrypt's
    direct (non-inline) path open-codes the same loop and could follow.
    A HW engine is a provider via cra_priority. Consumers and providers
    are decoupled through one named algorithm.

What it does and does not buy
-----------------------------

On a software cipher this is not a throughput win: the generic template
still issues one inner encrypt per data unit, so the AES compute is
unchanged. It removes per-request overhead and the consumer's
open-coded per-unit loop, and is byte-for-byte identical to the
per-sector path (Verification). The win is for a one-pass provider; no
software throughput is claimed.

dm-crypt consumer (patch 4)
---------------------------

dm-crypt submits one request per contiguous bio segment with
data_unit_size = cc->sector_size (e.g. the default 512-byte sector with
a 4 KiB bio_vec -> one request of 8 data units), using only its existing
inline single-entry scatterlist no per-bio allocation, no regression.
It allocates dun(<cipher>,<endian>) instead of the bare cipher when the
config can form the DUN counter: a counter IV mode (plain64 -> le,
plain64be -> be; essiv/lmk/tcw etc. are not plain counters and stay
per-sector), single-tfm, non-aead, sector_size 512 or iv_large_sectors.
DM_CRYPT selects CRYPTO_DUN and the template resolves against a sync
inner, so there is no acceptable wrap failure the bare cipher would
survive; an integrity config keeps an inert dun() wrapper but never
batches (one inner call per request == the per-sector path).

blk-crypto-fallback consumer (patch 5)
--------------------------------------

Every blk-crypto inline-encryption mode feeds the DUN as a little-endian
counter, so the fallback wraps its cipher as dun(<cipher>,le)
unconditionally (BLK_INLINE_ENCRYPTION_FALLBACK selects CRYPTO_DUN).
Because the template handles any counter width up to 32 bytes, this
covers all four modes AES-256-XTS, AES-128-CBC-ESSIV, Adiantum
(32-byte IV) and SM4-XTS and the open-coded per-unit loop is removed
from both the encrypt and decrypt paths.

Verification
------------

Regression protocol in the tree, on x86 + arm64 under qemu: build clean
and checkpatch strict clean (the lone warning is the new-file
MAINTAINERS reminder; crypto/ is an F: catch-all); testmgr dun()
cross-check (batched == N x single-DU reference over a fragmented
scatterlist, plus a boundary-seeded IV that forces a carry across a
64-bit limb / byte run) for every accepted ivsize including 32 (Adiantum)
in BOTH dun(...,le) and dun(...,be), so the big-endian counter path is
exercised independently of any consumer; an AF_ALG probe forces the
dun() cross-check to run for each blk-crypto inner cipher
(dun(essiv(cbc(aes),sha256),le), dun(adiantum(xchacha12,aes),le), ...);
dm-crypt plain64/plain64be activate dun() (le/be), essiv / plain fall
back; negative gates (multikey and integrity not batched); plain64 and
plain64be round-trips and a 4096-byte iv_large_sectors round-trip;
low-memory; arm64 functional; an end-to-end blk-crypto-fallback test
(ext4 + fscrypt -o inlinecrypt with no inline HW, driving dun(xts,le)
and verifying a post-cache-drop round-trip); and byte-equivalence:
ciphertext is bit-identical to an unpatched axboe/for-next baseline
(sha256 4913910b...43efc0 le, da0869a9...63004 be).

Changes since v4
----------------

- The in-core auto-splitter and validator are gone; multi-DU dispatch is
  the dun(...) template. crypto_skcipher_encrypt/decrypt revert to
  stock, so there is no added cost on the core path.
- The CRYPTO_ALG_SKCIPHER_NATIVE_MULTI_DU capability flag is dropped; a
  native one-pass driver is selected by cra_priority instead.
- The template is dun(<inner>,<endian>) in the cryptd()/pcrypt() family
  of dispatch-only wrappers; the counter endianness (le/be) is its
  second parameter, backed by a struct dun_mode op table so a future
  counter convention is one table row. It handles any counter width up
 to 32 bytes (covering Adiantum) and rejects a data_unit_size 0 /
 cryptlen 0 request.
- dm-crypt allocates dun(<cipher>,le|be) when eligible (selecting the IV
 mode before tfm allocation); plain64 -> le, plain64be -> be. An
  integrity config keeps an inert dun() wrapper but never batches.
  DM_CRYPT selects CRYPTO_DUN.
- blk-crypto-fallback is a second consumer (patch 5), demonstrating the
  template is a shared primitive, not dm-crypt-only; it wraps every mode
  as dun(<cipher>,le) and BLK_INLINE_ENCRYPTION_FALLBACK selects
  CRYPTO_DUN.
- testmgr exercises the template via dun(<inner>,le) and dun(<inner>,be),
  including ivsize 32 and a carry-boundary IV; an end-to-end fscrypt
  -o inlinecrypt test drives the blk-crypto-fallback consumer.

Leonid Ravich (5):
  crypto: skcipher - add per-request data_unit_size
  crypto: dun - data-unit-number dispatch template
  crypto: testmgr - test dun() dispatch
  dm crypt: batch a bio segment's sectors via dun()
  blk-crypto: fallback - batch a segment's data units via dun()

 block/Kconfig               |   1 +
 block/blk-crypto-fallback.c |  74 ++++----
 crypto/Kconfig              |  14 ++
 crypto/Makefile             |   1 +
 crypto/dun.c                | 359 ++++++++++++++++++++++++++++++++++++
 crypto/testmgr.c            | 289 +++++++++++++++++++++++++++++
 drivers/md/Kconfig          |   1 +
 drivers/md/dm-crypt.c       | 208 ++++++++++++++++-----
 include/crypto/skcipher.h   |  34 ++++
 9 files changed, 899 insertions(+), 82 deletions(-)
 create mode 100644 crypto/dun.c


base-commit: a8cafdf8c949f17c92eca0045532e88ac0dac30d
-- 
2.47.3

