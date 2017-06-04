From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 00/18] additional driver cleanups
Date: Sun,  4 Jun 2017 11:02:21 +0300
Message-ID: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52636 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750847AbdFDICw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jun 2017 04:02:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is another batch of clean ups for the ccree driver.
Mostly comprised of:
- Coding Style fixes
- Move to kernel infrastructure from custom constructs
- Replace macros with static inline functions
- Removal of dead code

Changes from v2:
- Rebase on top of commit ed5210cb07de90b8dc31a420466847755331536b
  ("Drivers: ccree: cc_hw_queue_defs.h - align block comments").
- Drop already upstream patches.
- Add three new patches to drop more unused code.

Changes from v1:
- Break up patches better to "do one thing" as indicated by GregKH
- Better description for some of the patches
- Better line breakup for code clarity as suggested by Joe Perches

Gilad Ben-Yossef (18):
  staging: ccree: replace bit shift with BIT macro
  staging: ccree: refactor HW command FIFO access
  staging: ccree: remove 48 bit dma addr sim
  staging: ccree: refactor LLI access macros
  staging: ccree: move M/LLI defines to header file
  staging: ccree: remove unused debug macros
  staging: ccree: remove cycle count debug support
  staging: ccree: move request_mgr to generic bitfield ops
  staging: ccree: remove custom bitfield macros
  staging: ccree: remove unused struct
  staging: ccree: use snake_case for hash enums
  staging: ccree: drop no longer used macro
  staging: ccree: remove dead code
  staging: ccree: remove spurious blank line
  staging: ccree: fix wrong whitespace usage
  staging: ccree: remove last remnants of sash algo
  staging: ccree: remove last remnants of sblkcipher
  staging: ccree: remove descriptor context definitions

 drivers/staging/ccree/cc_bitops.h        |   35 -
 drivers/staging/ccree/cc_crypto_ctx.h    |   88 +-
 drivers/staging/ccree/cc_hw_queue_defs.h |  686 ++++++++-------
 drivers/staging/ccree/cc_lli_defs.h      |   49 +-
 drivers/staging/ccree/cc_regs.h          |   77 +-
 drivers/staging/ccree/dx_crys_kernel.h   |  308 +++----
 drivers/staging/ccree/dx_host.h          |  256 +++---
 drivers/staging/ccree/hash_defs.h        |   53 +-
 drivers/staging/ccree/ssi_aead.c         |  953 ++++++++++-----------
 drivers/staging/ccree/ssi_buffer_mgr.c   |  117 +--
 drivers/staging/ccree/ssi_buffer_mgr.h   |   16 -
 drivers/staging/ccree/ssi_cipher.c       |  350 +++-----
 drivers/staging/ccree/ssi_config.h       |    6 -
 drivers/staging/ccree/ssi_driver.c       |    8 -
 drivers/staging/ccree/ssi_driver.h       |   31 +-
 drivers/staging/ccree/ssi_fips_ll.c      |  704 ++++++++--------
 drivers/staging/ccree/ssi_hash.c         | 1343 +++++++++++++-----------------
 drivers/staging/ccree/ssi_ivgen.c        |   80 +-
 drivers/staging/ccree/ssi_request_mgr.c  |  161 +---
 drivers/staging/ccree/ssi_sram_mgr.c     |    8 +-
 20 files changed, 2230 insertions(+), 3099 deletions(-)
 delete mode 100644 drivers/staging/ccree/cc_bitops.h

-- 
2.1.4
