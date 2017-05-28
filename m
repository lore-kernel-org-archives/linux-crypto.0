From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 00/12] staging: ccree: addtional driver cleanups
Date: Sun, 28 May 2017 17:40:25 +0300
Message-ID: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:42074 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750776AbdE1Okt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 May 2017 10:40:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is another batch of clean ups for the ccree driver.
Mostly comprised of:
- Coding Style fixes
- Move to kernel infrastructure from custom constructs
- Removal of dead code

Gilad Ben-Yossef (12):
  staging: ccree: correct coding style violations
  staging: ccree: move to kernel bitfields/bitops
  staging: ccree: remove 48 bit dma addr sim
  staging: ccree: cleanup lli access macro
  staging: ccree: remove cycle count debug support
  staging: ccree: move request_mgr to generic bitfield ops
  staging: ccree remove custom bitfield macros
  staging: ccree: remove unused struct
  staging: ccree: use snake_case for hash enums
  staging: ccree: drop no longer used macro
  staging: ccree: remove dead code
  staging: ccree: whitespace fixes

 drivers/staging/ccree/cc_bitops.h        |  35 --
 drivers/staging/ccree/cc_crypto_ctx.h    |  66 ++-
 drivers/staging/ccree/cc_hw_queue_defs.h | 770 +++++++++++++------------
 drivers/staging/ccree/cc_lli_defs.h      |  67 ++-
 drivers/staging/ccree/cc_regs.h          |  74 +--
 drivers/staging/ccree/dx_crys_kernel.h   | 308 +++++-----
 drivers/staging/ccree/dx_host.h          | 256 ++++-----
 drivers/staging/ccree/hash_defs.h        |  52 +-
 drivers/staging/ccree/ssi_aead.c         | 953 ++++++++++++++-----------------
 drivers/staging/ccree/ssi_buffer_mgr.c   | 128 +----
 drivers/staging/ccree/ssi_buffer_mgr.h   |  16 -
 drivers/staging/ccree/ssi_cipher.c       | 248 ++++----
 drivers/staging/ccree/ssi_config.h       |   6 -
 drivers/staging/ccree/ssi_driver.c       |   8 -
 drivers/staging/ccree/ssi_driver.h       |  30 +-
 drivers/staging/ccree/ssi_fips_ll.c      | 704 +++++++++++------------
 drivers/staging/ccree/ssi_hash.c         | 895 ++++++++++++++---------------
 drivers/staging/ccree/ssi_ivgen.c        |  80 ++-
 drivers/staging/ccree/ssi_request_mgr.c  | 152 +----
 drivers/staging/ccree/ssi_sram_mgr.c     |   8 +-
 20 files changed, 2170 insertions(+), 2686 deletions(-)
 delete mode 100644 drivers/staging/ccree/cc_bitops.h

-- 
2.1.4
