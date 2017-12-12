From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 00/24] staging: ccree: cleanups and simplification
Date: Tue, 12 Dec 2017 14:52:46 +0000
Message-ID: <1513090395-7938-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:44972 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751729AbdLLOxY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Dec 2017 09:53:24 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

More CCREE code cleanup and simplifications, including:
- Drop code supporting long code synch cipher and hash usage
- Drop ifdef out code for features not supported by HW
- More naming convention and name space cleanup
- Coding style fixes

This patch set goes on top of Dan Carpenter's patch entitled
"staging: ccree: Uninitialized return in ssi_ahash_import()"
sent to the list.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad Ben-Yossef (24):
  staging: ccree: remove ahash wrappers
  staging: ccree: fix hash naming convention
  staging: ccree: amend hash func def for readability
  staging: ccree: func params should follow func name
  staging: ccree: shorten parameter name
  staging: ccree: fix func def and decl coding style
  staging: ccree: simplify expression with local var
  staging: ccree: fix func call param indentation
  staging: ccree: fix reg mgr naming convention
  staging: ccree: fix req mgr func def coding style
  staging: ccree: remove cipher sync blkcipher remains
  staging: ccree: fix cipher naming convention
  staging: ccree: fix cipher func def coding style
  staging: ccree: fix ivgen naming convention
  staging: ccree: fix ivgen func def coding style
  staging: ccree: drop unsupported MULTI2 mode code
  staging: ccree: remove SSI_CC_HAS_ macros
  staging: ccree: rename all SSI to CC
  staging: ccree: rename all DX to CC
  staging: ccree: rename vars/structs/enums from ssi_ to cc_
  staging: ccree: fix buf mgr naming convention
  staging: ccree: fix sram mgr naming convention
  staging: ccree: simplify freeing SRAM memory address
  staging: ccree: fix FIPS mgr naming convention

 drivers/staging/ccree/cc_crypto_ctx.h    |  17 -
 drivers/staging/ccree/cc_hw_queue_defs.h |   6 +-
 drivers/staging/ccree/cc_lli_defs.h      |   2 +-
 drivers/staging/ccree/dx_crys_kernel.h   | 314 +++++------
 drivers/staging/ccree/dx_host.h          | 262 +++++-----
 drivers/staging/ccree/dx_reg_common.h    |  10 +-
 drivers/staging/ccree/ssi_aead.c         | 176 +++----
 drivers/staging/ccree/ssi_aead.h         |  20 +-
 drivers/staging/ccree/ssi_buffer_mgr.c   | 320 +++++-------
 drivers/staging/ccree/ssi_buffer_mgr.h   |  36 +-
 drivers/staging/ccree/ssi_cipher.c       | 604 ++++++++--------------
 drivers/staging/ccree/ssi_cipher.h       |  16 +-
 drivers/staging/ccree/ssi_config.h       |  12 +-
 drivers/staging/ccree/ssi_driver.c       | 106 ++--
 drivers/staging/ccree/ssi_driver.h       |  79 ++-
 drivers/staging/ccree/ssi_fips.c         |  22 +-
 drivers/staging/ccree/ssi_fips.h         |  22 +-
 drivers/staging/ccree/ssi_hash.c         | 857 +++++++++++++------------------
 drivers/staging/ccree/ssi_hash.h         |  30 +-
 drivers/staging/ccree/ssi_ivgen.c        |  88 ++--
 drivers/staging/ccree/ssi_ivgen.h        |  24 +-
 drivers/staging/ccree/ssi_pm.c           |  18 +-
 drivers/staging/ccree/ssi_pm.h           |  10 +-
 drivers/staging/ccree/ssi_request_mgr.c  | 136 +++--
 drivers/staging/ccree/ssi_request_mgr.h  |  23 +-
 drivers/staging/ccree/ssi_sram_mgr.c     |  31 +-
 drivers/staging/ccree/ssi_sram_mgr.h     |  29 +-
 drivers/staging/ccree/ssi_sysfs.c        |  22 +-
 drivers/staging/ccree/ssi_sysfs.h        |  10 +-
 29 files changed, 1419 insertions(+), 1883 deletions(-)

-- 
2.7.4
