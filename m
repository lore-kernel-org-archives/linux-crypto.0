Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.118.77.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793976171;
	b=QEzJqmPqmkPs5/+qqzK8CDcQ4g6EbgXg6fDwiXms6aDSOOwFCgfTERG81XTIGqumSo/5
	 YLjJ04ucdhOUeNSdVpz+fZW0pR3KmeXwmCw7Oay4YkmQtyduxSuizW7uG3FVBTizP145x
	 5EDj41GRc/5mPckbv5jP6b7y8Xn4Eog3oH6zGPcfBF853VZ1uAKSvkdDJwhcSaslrFvG3
	 KFjU4ofOiJ1gdr0SDewkkqezWrmwXPE7pzSS4R8PM3xvqU6doNsks4GlPyqlFyyaCpLjt
	 JnuMv6fdCf/QD6+uQnlrVPskQxjF2PgMKnY5DoPBUQOWYmBL5u43yt1BY0u/ZFL7/Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793976171;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 From:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-CMS-MailID:X-Msg-Generator:Content-Type:X-RootMTR:
	 X-EPHeader:X-CMS-RootMailID:References;
	bh=qEvUsSQ8oHgd+U12jDuRB72u7Zwo8Q4AXWrOiHlDlZI=;
	b=UQ1LCTWjhM4S+lWsxjfZQFVfak4dJF44f/WX39Ca/DC8HRkii3Unez8S3mvbteSIp/mc
	 tzbZiLnfFnF3kJjQZntSaqsYJwbI7hKK1Ky2IWCxLPbddbG0v+R6lCv0no0AowdnyPzm3
	 /2ACwySsIqakv+NC1/kzd62/ZHhH6S0zNqN0GURchZrRYjC9p4H67kMprR2h5+GobB2A0
	 nm10bTbVDkGCEVNvkTSJTXvbqdr1f62q6wBVqlUnjATlnabVBFyF6Ve0ZMKGsU+t2XD6x
	 m+w7/TvcgkT3NQ3wLr2E2pNKE9ldopV8Bb9frrPrmRVRGsXiXmcOeehNG9Vfs35vNHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b="O/KOIhPM";
	arc=none smtp.remote-ip=210.118.77.12
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC95606A32C;
	Fri,  6 Nov 2026 14:42:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BC95606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=O/KOIhPM
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261106144248euoutp02f49d0ceb5c399c84a56a0d9efbe9d496~le9Hs_U2k1199311993euoutp02B;
	Fri,  6 Nov 2026 14:42:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261106144248euoutp02f49d0ceb5c399c84a56a0d9efbe9d496~le9Hs_U2k1199311993euoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793976168;
	bh=qEvUsSQ8oHgd+U12jDuRB72u7Zwo8Q4AXWrOiHlDlZI=;
	h=From:Subject:Date:To:Cc:References:From;
	b=O/KOIhPMNr5fvGwnIFx0OHpQiEz8JdSZLEtl0RQ/qRetqaNI1X9cja2oaka5Lhopz
	 o3+qiAgVYknoP4vOvWrVkK55MsAy+4qtuMElPNieKOyEMrnUQUobYKR4Do09K0IlAW
	 5lluxIhdkIx047/zGIDlcEmnqr+P6uuq8knZHMCQ=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144247eucas1p15bdd0704f32d1cb3b19f9d2296a0cbc3~le9G5JH1c0320803208eucas1p1W;
	Fri,  6 Nov 2026 14:42:47 +0000 (GMT)
Received: from AMDC4942.eu.corp.samsungelectronics.net (unknown
	[106.210.136.40]) by eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261106144245eusmtip1424e79dc85f8d505d60f5a807f37d8a5~le9FUmO2M0066400664eusmtip1W;
	Fri,  6 Nov 2026 14:42:45 +0000 (GMT)
From: Michal Wilczynski <m.wilczynski@samsung.com>
Subject: [PATCH v2 00/15] lib/lz4: stop forking upstream LZ4, vendor it
 instead
Date: Fri, 06 Nov 2026 15:42:40 +0100
Message-Id: <20261106-lz4-vendor-upstream-v2-0-ee04c3f0d7dc@samsung.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGDn7WoC/22NwQ6CMBBEf4Xs2TVtUzV68j8Ih1K20ERa0oVGJ
	fy7lXj0+CYzb1ZgSp4YbtUKibJnH0MBdajADib0hL4rDEqos7gKjY+3xkyhiwmXiedEZkTdWlU
	KnXDOQllOiZx/7ta6KTx4nmN67SdZftOfT53++rJEgdJenGtJSavbO5uRl9AfbRyh2bbtA0LW5
	9G4AAAA
X-Change-ID: 20260904-lz4-vendor-upstream-4bc2202d0ffc
To: Michal Wilczynski <m.wilczynski@samsung.com>,  Nathan Chancellor
	<nathan@kernel.org>,  Nick Desaulniers <ndesaulniers@google.com>,  Bill
	Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,  Russell
	King <linux@armlinux.org.uk>,  Thomas Bogendoerfer
	<tsbogend@alpha.franken.de>,  "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>,  Helge Deller <deller@gmx.de>,
	Heiko Carstens <hca@linux.ibm.com>,  Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>,  Christian Borntraeger
	<borntraeger@linux.ibm.com>,  Sven Schnelle <svens@linux.ibm.com>, Thomas
	Gleixner <tglx@kernel.org>,  Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>,  Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Minchan Kim <minchan@kernel.org>,  Sergey
	Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-block@vger.kernel.org, Yann Collet <yann.collet.73@gmail.com>,  Nick
	Terrell <terrelln@meta.com>, Gao Xiang <xiang@kernel.org>,  Chao Yu
	<chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,  Eric Biggers
	<ebiggers@kernel.org>,  Herbert Xu <herbert@gondor.apana.org.au>,  David
	Laight <david.laight.linux@gmail.com>,  Sungguk <sungguk.na@samsung.com>,
	Jaehoon Chung <jh80.chung@samsung.com>,  Marek Szyprowski
	<m.szyprowski@samsung.com>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=10637;
	i=m.wilczynski@samsung.com; h=from:subject:message-id;
	bh=wz6WKeqe9aM/51sYWqggJMCdGKknzWWNE5KRnyp6sjs=;
	b=owGbwMvMwCGWumv6zndzRCIZT6slMWS9fZ4y20Jt3qO5Hc4C/EfW7vFdUCzJIrNi5qfGlESR2
	T0TnCSudJSyMIhxMMiKKbKc3RhtJPmP4Wn58ce/YOawMoEMYeDiFICJmMcx/DOtMv9k+ftIImMA
	m+V9X+Ulr5ItPu+eu2z1muXeRTK2i94xMjTuE3xZtyDYes7GKJVcMTur+hn7twUyrGHYd1Ppdfx
	na3YA
X-Developer-Key: i=m.wilczynski@samsung.com; a=openpgp;
	fpr=CDB15B3219FE00E577C7E3FA65BA97B9EE9C1459
X-CMS-MailID: 20261106144247eucas1p15bdd0704f32d1cb3b19f9d2296a0cbc3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261106144247eucas1p15bdd0704f32d1cb3b19f9d2296a0cbc3
X-EPHeader: CA
X-CMS-RootMailID: 20261106144247eucas1p15bdd0704f32d1cb3b19f9d2296a0cbc3
References: <CGME20261106144247eucas1p15bdd0704f32d1cb3b19f9d2296a0cbc3@eucas1p1.samsung.com>

The in-kernel LZ4 is a fork. The decompressor was last synced with
upstream v1.8.3 in 2018 and the compressor with v1.7.3 in 2017, both by
hand. Upstream has made 488 commits against lib/ since, and the gap is
maintained one cherry-pick at a time.

That has left real bugs in place for example the forked
LZ4_decompress_fast() has no bounds checks on its input, so corrupted
input reads past its end and before the output buffer.

This series vendors the upstream sources unmodified and adapts them at
build time, so a re-sync becomes a directory copy:

  upstream/lz4.c, upstream/lz4.h    verbatim upstream sources
  upstream/lz4hc.c, upstream/lz4hc.h
  lz4_deps.h                        the build environment
  lz4_kernel_api.h                  hands the LZ4 names back
  freestanding/                     ISO C headers -nostdinc drops
  lz4_compress.c                    the kernel's entry points
  lz4_decompress.c
  lz4hc_compress.c

Patches 1-3 apply to the fork as it stands: patch 1 moves the pre-boot
decompressor off LZ4_decompress_fast(), patch 2 removes it and its
variants, and patch 3 stops zram's lz4hc backend resetting its stream
for every page. Patch 4 imports the sources. Patches 5-7 backport the
upstream fixes the kernel needs on top of v1.10.0. Patch 8 adds the
build environment. Patch 9 puts the freestanding headers on the pre-boot
decompressor path. Patches 10, 11 and 13 convert the compressor, HC
compressor and decompressor in turn; patch 12 widens the in-place margin
erofs relies on for the new decoder. Patch 14 drops the last duplicated
prototype list. Patch 15 gives lib/lz4 a MAINTAINERS entry, which it has
never had.

This is meant to go through Andrew's tree; patch 9 needs acks from the
boot maintainers.

The exported API changes in four ways.

The three stream types become incomplete. <linux/lz4.h> spelled out their
layout for the fork's benefit, upstream headers define the same types and
lib/decompress_unlz4.c ends up with both in one translation unit. Callers
allocate LZ4_MEM_COMPRESS, LZ4HC_MEM_COMPRESS or LZ4_MEM_DECOMPRESS bytes
instead of sizeof() every caller but zram already did. Each conversion
patch makes its own type incomplete so no step leaves the tree broken.

Sixteen macros go with them: the hash geometry (LZ4_HASHLOG,
LZ4_HASHTABLESIZE, LZ4_HASH_SIZE_U32, LZ4HC_DICTIONARY_LOGSIZE, LZ4HC_MAXD,
LZ4HC_MAXD_MASK, LZ4HC_HASH_LOG, LZ4HC_HASHTABLESIZE, LZ4HC_HASH_MASK) and
the sizes derived from it (LZ4_MEMORY_USAGE, LZ4_STREAMSIZE{,_U64},
LZ4_STREAMHCSIZE{,_SIZET}, LZ4_STREAMDECODESIZE{,_U64}). They existed to
lay out structures the fork defined here none has an in tree user outside
lib/lz4. LZ4_compressBound() goes too a static inline whose only caller
was lib/decompress_unlz4.c, now using the LZ4_COMPRESSBOUND() macro.

LZ4_MEM_DECOMPRESS and LZ4HC_CLAMP_CLEVEL are new.

LZ4_decompress_fast(), LZ4_decompress_fast_continue() and
LZ4_decompress_fast_usingDict() go. Upstream has deprecated them since
v1.9, and their last in-tree user, the pre-boot decompressor, now uses
LZ4_decompress_safe_partial().

There are some behaviour changes. All of them come from upstream rather
than from this series and I have kept them rather than patching them
out: a local fix on top of vendored sources is exactly the divergence
this series exists to remove.

 - LZ4HC levels 10 and up are clamped to 9. Upstream routes them to its
   optimal parser, whose ~64K opt[] does not fit a kernel stack. The
   fork had no optimal parser at all - level only scaled search depth -
   so its levels 10-16 beat its own level 9 by 0.01%. Clamping rather
   than rejecting keeps existing f2fs and zram settings working.

 - LZ4_decompress_safe_partial() with a zero-length target returns 0
   rather than -1, matching upstream since 725cb0aafdf7. No in-tree
   caller depends on it.

 - The compressors require wrkmem aligned to 8 bytes. Upstream checks
   this and LZ4_initStream() returns NULL, which upstream's own callers
   then dereference or ignore. The entry points check the alignment
   themselves, warn once and fail the call. Every in-tree caller uses
   kmalloc() or vmalloc() and is already aligned; <linux/lz4.h> now
   documents the requirement.

The layout follows lib/zstd, which keeps upstream's sources in a
subdirectory and the kernel glue on top. zstd has an upstream import
tool and an upstream zstd_deps.h; LZ4 has neither, so the kernel glue
here lives outside the vendored files.

The import is the v1.10.0 release tag. It does not build under
-Wmissing-prototypes without upstream commit 5ef1f16929b5, which patch 5
backports. Patch 6 backports upstream's arm64 fast decode loop and patch
7 its match length limit fix; those are the only deviations from the
tag. The rest of PR #1753 fixes code added after v1.10.0, so it will
come with the next release.

checkpatch reports some 3500 errors against patch 4: upstream's coding
style, and no SPDX tags, in files kept verbatim.

Measured in the kernel: three kernels differing only in lib/lz4, booted
one core under KVM, each reading 1.3GB of kernel source from an LZ4
erofs image with the page cache dropped before every pass. For v2 this
was remeasured with more runs on an idle machine: median of 140 passes.
The middle column is upstream v1.10.0 with LZ4_FAST_DEC_LOOP=0,
to separate the version bump from the decode loop upstream added in
v1.9.0.

                        erofs read, MB/s
  erofs cluster    today   v1.10.0   + fast loop    net
             4K     2486      2549          2665    +7%
            64K     3013      3104          3225    +7%

The same three decoders at the library level, each block decompressed
on its own the way zram treats a page. x86_64, the fork's and upstream's
sources built with the kernel's code generation flags (so no SSE), all
decoding the same compressed input, median of 21 interleaved runs. The
first corpus is upstream's tests/datagen with a fixed seed, so it is
byte-identical anywhere; the second is a tar of kernel sources:

                                 decompression, MB/s
  corpus           block  ratio    today   v1.10.0  + fast loop   net
  datagen -s0 -P60   4K  1.09x     4584      4535         5097   +11%
                    16K  1.34x     3960      3978         4828   +22%
                    64K  1.90x     4797      4802         5598   +17%
                   256K  1.92x     6749      6559         7600   +13%
  kernel source tar  4K  2.29x     3719      3832         4219   +13%
                    16K  2.57x     3778      3880         4203   +11%
                    64K  2.80x     3792      3886         4179   +10%
                   256K  2.95x     4165      4280         4750   +14%

Compression is not uniformly faster: lz4hc on small blocks of poorly
compressible data is up to 15% slower. Patches 10 and 11 have the
numbers.

The cost is size: lib/lz4 grows from 45K to 86K of text on x86_64,
lz4hc most (12K to 39K). That is upstream code the fork never had.

---
Changes in v2:
- Drop the RFC prefix
- New patches 1-2: move the pre-boot decompressor to
  LZ4_decompress_safe_partial() and remove LZ4_decompress_fast() and its
  variants from the fork, ahead of the import (Sergey)
- New patch 3: zram's lz4hc backend resets its stream once, not per page
- New patches 6-7: backport upstream's arm64 fast decode loop (Sergey)
  and its match length limit fix
- New patch 12: widen LZ4_DECOMPRESS_INPLACE_MARGIN for the fast decode
  loop
- Compressor entry points check wrkmem alignment, warn and fail (Sergey)
- Patch 13 names the upstream counterpart of each retired local patch
  (Sergey)
- MAINTAINERS: also cover lib/decompress_unlz4.c and
  include/linux/decompress/unlz4.h (Eric)
- Remeasure erofs reads with more runs on an idle machine
- Link to v1: https://lore.kernel.org/r/20260925-lz4-vendor-upstream-v1-0-1c7ffbe21c4b@samsung.com

---
Michal Wilczynski (15):
      lib/decompress_unlz4: use LZ4_decompress_safe_partial() before boot
      lib/lz4: remove LZ4_decompress_fast() and its variants
      zram: lz4hc: reset the dictionary stream once, not per page
      lib/lz4: import upstream LZ4 sources verbatim
      lib/lz4: backport upstream's -Wmissing-prototypes fix
      lib/lz4: backport upstream's aarch64 fast decode loop enablement
      lib/lz4: backport upstream's match length limit fix
      lib/lz4: add the build environment for the vendored sources
      arch: boot: put the LZ4 freestanding headers on the decompressor path
      lib/lz4: switch the compressor to the vendored sources
      lib/lz4: switch the HC compressor to the vendored sources
      lib/lz4: widen LZ4_DECOMPRESS_INPLACE_MARGIN for the fast decode loop
      lib/lz4: switch the decompressor to the vendored sources
      lib/lz4: replace lz4_kernel_api.h's prototypes with <linux/lz4.h>
      MAINTAINERS: add an entry for the LZ4 compression library

 Documentation/filesystems/f2fs.rst   |    2 +
 MAINTAINERS                          |   10 +
 arch/arm/boot/compressed/Makefile    |    3 +
 arch/mips/boot/compressed/Makefile   |    4 +
 arch/parisc/boot/compressed/Makefile |    3 +
 arch/s390/boot/Makefile              |    3 +
 arch/x86/boot/compressed/Makefile    |    3 +
 drivers/block/zram/backend_lz4.c     |    8 +-
 drivers/block/zram/backend_lz4hc.c   |    8 +-
 include/linux/lz4.h                  |  253 +--
 lib/decompress_unlz4.c               |   17 +-
 lib/lz4/Makefile                     |   16 +-
 lib/lz4/freestanding/limits.h        |   14 +
 lib/lz4/freestanding/stddef.h        |   15 +
 lib/lz4/freestanding/stdint.h        |   14 +
 lib/lz4/freestanding/string.h        |   14 +
 lib/lz4/lz4_compress.c               |  946 +-----------
 lib/lz4/lz4_decompress.c             |  724 +--------
 lib/lz4/lz4_deps.h                   |  118 ++
 lib/lz4/lz4_kernel_api.h             |   34 +
 lib/lz4/lz4defs.h                    |  247 ---
 lib/lz4/lz4hc_compress.c             |  792 +---------
 lib/lz4/upstream/lz4.c               | 2824 ++++++++++++++++++++++++++++++++++
 lib/lz4/upstream/lz4.h               |  884 +++++++++++
 lib/lz4/upstream/lz4hc.c             | 2192 ++++++++++++++++++++++++++
 lib/lz4/upstream/lz4hc.h             |  414 +++++
 26 files changed, 6813 insertions(+), 2749 deletions(-)
---
base-commit: 93f51579e7df248780214094418f205253383cc5
change-id: 20260904-lz4-vendor-upstream-4bc2202d0ffc

Best regards,
-- 
Michal Wilczynski <m.wilczynski@samsung.com>

