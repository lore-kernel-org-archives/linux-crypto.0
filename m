Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D822279329;
	Thu, 24 Sep 2026 07:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790236737; cv=none; b=XOUSgfRCdmaLOqrYFAUOfkgPcV0UDcXN4n5YGRW7FeDPofGB5hxbnfDCJSX18i71d08ookzMplelIstwwWD80YCfSFVSjzJVd9tWevFa/ua4jjyDVqcP/sKHj9MhPRXXlt7KoGVpJkN7Ov7IIMVcBoAZAu0JnJTdax6TwllI/Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790236737; c=relaxed/simple;
	bh=vibUG4so5EH9ywxQ6diDY/oZL2b0mGWxV6lMKYpqOk8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=X7aaXsL4R8UcGo72TAiJ9oQ9YwMVvbDqo2mrpcXlcBQRYs8MlSEJU1RbmtrfV/S9BRiGmlDBel055r9Vt233hN9dcBW6FUVgfBgpZ1mMJNxBUcJKdkYK9OM1TjfKjVE6ZIjWWwd8e03PrDP4ZIVRzbyQ+si+8KKlUjyXSHixChI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=qXwTnx5t; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="qXwTnx5t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1790236736; x=1821772736;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HfNlKugKhi71MH1XOZe/sAFG/OFrGjMISEGx9M/PIss=;
  b=qXwTnx5tlUc43gdbdfXvK1mA5pSSgtSrdWrHANKLnu8ie8viLySpq307
   Qu9Tfx3jX1NPan0cWL2RFx0IPFJg2yZbaAM9S76M1pvBlIpbv3Y2F8FUF
   d2evMSknDMj3X3czNv4d0CpSVxRCOdbsNNcxWd+0ARf8b124xqB/JF/DP
   ng6+iXcoR8vKReN2bkuEvVAI91YnK5tIbEIRxXtBWUvAnGQ/GahftvCG1
   iExTNm26U02GvoWFDtTkkyUe64FPVvzDgmT0fmxit5yP/K0oUxKeuOyEu
   pjnoKnYeQrQ7DrWZnd/lQMc/7i00xsQjseEjg7Dgu/tao8SP3buJk2tKg
   A==;
X-CSE-ConnectionGUID: J8FvrPaQRSKo4RQWn0duGA==
X-CSE-MsgGUID: +6CqHUjTRwS74WhcMBBuTQ==
X-IronPort-AV: E=Sophos;i="6.27,120,1787011200"; 
   d="scan'208";a="29382417"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 07:58:53 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:4030]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.53.187:2525] with esmtp (Farcaster)
 id 2aaca981-8e13-42f5-b7c7-54def876fe85; Thu, 24 Sep 2026 07:58:53 +0000 (UTC)
X-Farcaster-Flow-ID: 2aaca981-8e13-42f5-b7c7-54def876fe85
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:58:53 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 24 Sep 2026 07:58:51 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<ebiggers@kernel.org>, <agk@redhat.com>, <snitzer@kernel.org>,
	<mpatocka@redhat.com>, <bmarzins@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 0/6] crypto: skcipher - multi-data-unit request splitting
Date: Thu, 24 Sep 2026 07:58:40 +0000
Message-ID: <20260924075846.28203-1-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D040UWB002.ant.amazon.com (10.13.138.89) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Hi all,

This series lets a caller submit several data units in one skcipher
request: the request carries a unit_size, the IV is the data-unit
number of the first unit, and the API layer walks the counter across
units.  dm-crypt is the first (and in this series the only) user --
it stops issuing one skcipher request per sector and instead hands
the cipher a whole contiguous bio segment (8 units for a 4 KiB
bio_vec with the default 512 B sector).

v6 is a full rework of v5 along the lines Herbert laid out, so the
design section below is mostly new rather than a delta.  The v5
dun() template is gone; the split now lives in the mid-API layer and
is skipped entirely for algorithms that advertise native multi-unit
support.

v5: https://lore.kernel.org/linux-crypto/20260630083431.2772-1-lravich@amazon.com/

Answers to Herbert's v5 questions
=================================

1. "Could you send me the patch so I can take a look?" (per-unit cost)
---------------------------------------------------------------------

Patch 4 is that patch -- the API-layer split, self-contained in
crypto/skcipher.c.  The cost I measured, and where I believe it goes:

An in-kernel microbench of skcipher_crypt_unit() against the legacy
per-unit loop (identical inner AES, VAES-AVX512, r7i.metal) shows a
fixed ~48-52 ns per data unit, CV <1%, and it is the *same* ~50 ns
for a 512 B unit and a 4096 B unit -- so it is per-call setup, not a
crypto effect.  Against ~70 ns of VAES work for a 512 B sector that
is ~+70% on the crypto call itself; end-to-end in dm-crypt it is
~2% of an ~18 us I/O and does not show up in fio at all (see the
Performance section below).

The three things the split does per unit:

  * copies the running counter IV into a per-unit scratch buffer
    (req->iv must come back unmodified, and the algorithm is free to
    clobber the IV it is given, so the copy cannot be elided by
    handing the algorithm the counter directly);
  * re-slices the source and destination scatterlists to the unit's
    offset/length, which walks the sglist from the previous unit's
    position;
  * pays one extra call frame plus the save/restore of the fields it
    mutates on the caller's request.

The sg re-slice is the part I expect can be made cheaper (a stateful
walk carried across units rather than an offset-based slice each
time), and the IV copy could go away for algorithms that promise not
to modify the IV -- but I did not want to invent a new "does not
clobber IV" contract unprompted.  I would rather hear which of these
you had in mind than guess.

2. "no templates for plain64, the other ones should use a template"
------------------------------------------------------------------

Implemented, with one mode left out.  With unit-splitting in use,
dm-crypt now always passes the little-endian sector number as the IV
and the API layer walks it as a 64-bit little-endian counter in the
low 8 bytes; there is no endianness knob anywhere in the API.  So:

  * plain64  -- batched, no template, and one *fewer* indirect call
                than before (no ->generator per sector).
  * essiv    -- batched, unchanged: its IV input already is
                le64(sector) and the salt encryption already lives
                in the essiv() template, which is exactly the shape
                you described.
  * plain64be -- not batched in this series.  Its on-disk IV is a
                big-endian counter in the *high* 8 bytes, which is
                not the low-limb little-endian layout the split
                walks, so it keeps the existing per-sector path.
                Batching it wants a plain64be() template that
                byte-swaps the low limb into the high one.  I left
                that out deliberately: it is a new template with a
                single user and no measurement behind it, and it is
                additive on top of this series.  Say the word and I
                will add it as a 7th patch (or a follow-up).
  * everything else (plain, benbi, lmk, tcw, eboiv, random, elephant,
                null) is not a step-of-one counter at all and keeps
                the per-sector path; those would each need their own
                template, which is the follow-up work your scheme
                makes possible.

Net indirect calls, as you predicted: unchanged for essiv, one fewer
for plain64, unchanged for the unbatched modes.

3. "Is this going to use the generated IV for reading through
   dm-crypt?  Shouldn't it be using the IV stored on disk instead of
   generating it again for reading?"
-------------------------------------------------------------------

For the modes this series batches, there is no IV stored on disk to
use -- and that is pre-existing dm-crypt behaviour, not something the
batching changes.  plain64 and essiv are deterministic functions of
the sector number (essiv = E_salt(le64(sector))), so read and write
derive bit-identically from the same input; dm-crypt has always
regenerated them on both paths and there is nowhere in the plain
sector-mapped format to store an IV anyway.

The configurations that *do* carry a per-sector IV/tag on disk are
the integrity ones (dm-integrity stacking, AEAD, random IV), and
those are excluded from batching by crypt_can_batch_units(): the
gate requires !crypt_integrity_aead and no integrity metadata,
precisely because a stored per-sector IV cannot be walked as a
counter.  Those keep the per-sector loop, where the stored IV is
read as before.

So no behaviour change on reads: same IV, same ciphertext, verified
byte-identical against an unpatched kernel (see Verification below).

Design overview
===============

 1/6 adds `unsigned int unit_size` to struct skcipher_request plus
     skcipher_request_set_unit_size(), mirroring the acomp field and
     setter.  0 (the default) is a normal single-unit request;
     set_tfm() and set_callback() zero it, so the opt-in is explicit
     and per-operation -- same contract as acomp.

 2/6 is Herbert's CRYPTO_ALG_REQ_SEG patch, carried verbatim from the
     acomp batching series (see the note at the end of this letter).

 3/6 adds crypto_skcipher_req_seg(), the skcipher-side mirror of
     crypto_acomp_req_seg().

 4/6 is the split: when unit_size is set and the algorithm does not
     advertise CRYPTO_ALG_REQ_SEG, crypto_skcipher_{en,de}crypt()
     issue one call per unit, advancing a 64-bit little-endian DUN in
     the low 8 bytes of the IV.  The counter wraps at 2^64 and never
     carries above, so output is bit-identical to the per-unit path
     across rollover.  The caller's request is reused and restored
     (same tfm, so the request context is already the right size);
     req->iv is never modified, and each unit gets a private IV copy
     aligned to MAX_ALGAPI_ALIGNMASK so it keeps the alignment the
     caller's IV had.  The split is synchronous, so a multi-unit
     request on an async non-native algorithm is rejected
     -EOPNOTSUPP, and it reschedules between units when the caller
     allows sleeping.  Callers that never set unit_size pay one
     unlikely() test.  The unit_size test runs *before* the
     lskcipher redirect, so lskcipher-backed modes (cbc) split
     correctly too.

 5/6 extends testmgr: for every self-tested sync skcipher with an
     eligible IV, one batched request over a deliberately fragmented
     scatterlist must produce ciphertext byte-identical to N
     single-unit requests with counter-walked IVs, then round-trip.
     The reference counter is written independently of the API
     layer's, and each unit size is also run with the IV seeded to
     force a wrap to zero.  Covers ivsize 16 (xts) and 32
     (Adiantum).  The caller's IV must come back unmodified.

 6/6 is dm-crypt: set unit_size = cc->sector_size and submit one
     request per contiguous bio segment, using only the existing
     inline single-entry scatterlist -- no per-bio allocation.
     Gated on a little-endian step-of-one sector counter (plain64,
     essiv), single tfm, non-aead, sector_size 512 or
     iv_large_sectors, and no integrity metadata.

Performance
===========

* dm-crypt fio, r7i.metal-24xl (Sapphire Rapids, VAES-AVX512),
  tmpfs-backed loop, series vs the same tree without it: no
  measurable regression across aes-xts-plain64, aes-cbc-essiv:sha256
  and aes-xts-plain64be at 512 B, plus a 4096 B non-batching control
  (median delta +0.0%, and +0.8% read / -0.7% write at the decisive
  512 B qd=1 point).  Two caveats: this rig is dispatch-bound on this
  CPU, so a flat result here mostly means the per-unit cost is under
  the noise floor rather than absent -- hence the microbench in
  answer 1 above; and the run predates the rework, on a tree that
  also batched plain64be, which the rework only removes from the
  batched path.
* No throughput *win* is claimed for software AES.  The win is for
  accelerators that amortise setup across units; the software split
  exists so the interface works on every existing skcipher today and
  goes quiet as algorithms gain CRYPTO_ALG_REQ_SEG.

Verification
============

* 19/19 cases of a qemu regression protocol pass on x86_64 and
  arm64: builds clean with and without the series, checkpatch
  --strict clean, testmgr multi-unit cross-check, activation gating
  (plain64/essiv batched; plain64be, multikey, integrity not
  batched), round-trips, 4096-sector iv_large_sectors, low-memory
  (128 MB) run, and blk-crypto-fallback/fscrypt unaffected.
* End-to-end byte equivalence against an unpatched baseline
  (a8cafdf8c949), whole-device sha256:
    plain64  f462a2ff4ec6f7d1219ef34897793b32d8e19b777cff914a7860289da9044b53
    essiv    d9e8add5c8c1ac75a00bca754d73b222ec7594245d3cafaf336ce967b3dad589
  The on-disk format is unchanged.

Changelog
=========

v6 (this posting; addresses Herbert's v5 review):
- the dun() template is gone; the split moved into the mid-API layer
  (crypto/skcipher.c) and is skipped for algorithms advertising
  native support.
- data_unit_size renamed unit_size; field, setter and opt-in
  semantics aligned with the acomp batching series, whose
  CRYPTO_ALG_REQ_SEG patch is carried here (2/6).
- no endianness knob: the IV is always a little-endian DUN in its low
  8 bytes; other on-disk layouts are a template's job.  plain64
  needs no template, essiv already is one, plain64be is left
  unbatched pending a plain64be() template.
- blk-crypto-fallback dropped as a consumer (Eric is moving it to
  lib/crypto); dm-crypt is the only user.
- counter is specified and implemented as 64-bit wrapping at 2^64
  with no carry into higher IV bytes, matching dm-crypt's
  generators; testmgr exercises the wrap.
- per-unit IV copy aligned to MAX_ALGAPI_ALIGNMASK (a misaligned IV
  would force an internal allocation, which dm-crypt excludes via
  CRYPTO_ALG_ALLOCATES_MEMORY).
- cond_resched() between units when CRYPTO_TFM_REQ_MAY_SLEEP, so a
  large batch keeps dm-crypt's per-sector preemption point.

v5 and earlier: see the v5 link above.

A note on patch 2
=================

Patch 2 ("crypto: acomp - Add bit to indicate segmentation support")
is Herbert's commit from the acomp batching series, carried here
verbatim because the skcipher split needs the CRYPTO_ALG_REQ_SEG bit
and that series has not landed yet.  It is unmodified apart from my
own Signed-off-by and a cherry-pick reference, so it carries its
author's authorship but only Herbert's Signed-off-by -- which
checkpatch reports as a missing author Signed-off-by.  That is
inherent to carrying the commit rather than a defect in it; it
disappears once the acomp series is upstream and this patch can be
dropped from the series.  I would rather flag it here than silently
rewrite authorship on someone else's commit.

Thanks,
Leonid

Kanchana P Sridhar (1):
  crypto: acomp - Add bit to indicate segmentation support

Leonid Ravich (5):
  crypto: skcipher - add per-request unit_size
  crypto: skcipher - add crypto_skcipher_req_seg() helper
  crypto: skcipher - split multi-unit requests in the API layer
  crypto: testmgr - test multi-unit dispatch
  dm crypt: batch a bio segment's sectors via multi-unit requests

 crypto/skcipher.c                   | 112 ++++++++++++
 crypto/testmgr.c                    | 272 ++++++++++++++++++++++++++++
 drivers/md/dm-crypt.c               | 136 +++++++++++---
 include/crypto/algapi.h             |   5 +
 include/crypto/internal/acompress.h |   5 +
 include/crypto/internal/skcipher.h  |   5 +
 include/crypto/skcipher.h           |  46 +++++
 include/linux/crypto.h              |   3 +
 8 files changed, 562 insertions(+), 22 deletions(-)


base-commit: a8cafdf8c949f17c92eca0045532e88ac0dac30d
-- 
2.47.3

