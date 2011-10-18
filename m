From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 00/18] crypto: Add helper functions for parallelized LRW and
	XTS modes
Date: Tue, 18 Oct 2011 13:32:08 +0300
Message-ID: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:53686 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1JRKcM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:32:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series adds lrw_crypt() and xts_crypt() functions for cipher implementations that
can benefit from parallel cipher block operations. To make interface flexible, 
caller is reponsible of allocating buffer large enough to store temporary cipher
blocks. This buffer size should be as large as size of parallel blocks processed at
once. Cryption callback is called with buffer size at maximum of parallel blocks size
and at minimum size of one block.

Series adds LRW/XTS support to serpent-sse2 and twofish-x86_64-3way, and therefore
depends on those series.

Patches 1-4: include LRW fixes/cleanups, export gf128mul table and add lrw_crypt().
Patches 5-7: add LRW support to serpent-sse2, with tcrypt tests and test vectors.
Patches 8-10: add LRW support to twofish-x86_64-3way, with tcrypt tests and test vectors.
Patches 11-12: include XTS cleanup for blocksize usage and add xts_crypt().
Patches 13-15: add XTS support to serpent-sse2, with tcrypt tests and test vectors.
Patches 16-18: add XTS support to twofish-x86_64-3way, with tcrypt tests and test vectors.

---

Jussi Kivilinna (18):
      crypto: lrw: fix memleak
      crypto: lrw: use blocksize constant
      crypto: lrw: split gf128mul table initialization from setkey
      crypto: lrw: add interface for parallelized cipher implementions
      crypto: testmgr: add lrw(serpent) test vectors
      crypto: tcrypt: add lrw(serpent) tests
      crypto: serpent-sse2: add lrw support
      crypto: testmgr: add lrw(twofish) test vectors
      crypto: tcrypt: add lrw(twofish) tests
      crypto: twofish-x86_64-3way: add lrw support
      crypto: xts: use blocksize constant
      crypto: xts: add interface for parallelized cipher implementations
      crypto: testmgr: add xts(serpent) test vectors
      crypto: tcrypt: add xts(serpent) tests
      crypto: serpent-sse2: add xts support
      crypto: testmgr: add xts(twofish) test vectors
      crypto: tcrypt: add xts(twofish) tests
      crypto: twofish-x86_64-3way: add xts support


 arch/x86/crypto/serpent_sse2_glue.c |  387 ++++++
 arch/x86/crypto/twofish_glue_3way.c |  250 ++++
 crypto/lrw.c                        |  155 ++
 crypto/serpent.c                    |   10 
 crypto/tcrypt.c                     |   28 
 crypto/tcrypt.h                     |    2 
 crypto/testmgr.c                    |   60 +
 crypto/testmgr.h                    | 2366 +++++++++++++++++++++++++++++++++++
 crypto/twofish_common.c             |   13 
 crypto/xts.c                        |   78 +
 include/crypto/lrw.h                |   43 +
 include/crypto/serpent.h            |    2 
 include/crypto/twofish.h            |    2 
 include/crypto/xts.h                |   27 
 14 files changed, 3379 insertions(+), 44 deletions(-)
 create mode 100644 include/crypto/lrw.h
 create mode 100644 include/crypto/xts.h
