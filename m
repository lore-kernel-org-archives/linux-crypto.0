From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 00/22] staging: ccree: fixes and simplifications
Date: Tue, 15 Aug 2017 09:26:28 +0300
Message-ID: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:48008 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752494AbdHOG1C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Aug 2017 02:27:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The series includes various bug fixes, code simplification and style
cleanups. 

Changer from v2:
- Drop M32R as supported architecture, which resolve the kbuild bot
  warnings on Joe Perches patch.
- Bug fix that properly saves last bytes of ciphertext for CTS in
  skcipher
- Even more coding style fixes

Changes from v1:

- Rebase on top of current staging-next.
- Added resource release on error simplification patch suggested by
  Dan C. as part of the review.

Based on top of staging-next commit 0116ced91d3a
("staging: fsl-mc: add explicit dependencies for compile-tested arches")

Gilad Ben-Yossef (18):
  staging: ccree: fix split strings
  staging: ccree: kmalloc by sizeof var not type
  staging: ccree: simplify resource release on error
  staging: ccree: remove unused completion
  staging: ccree: remove m32r as supported platform
  staging: ccree: rewrite GET_DMA_BUFFER_TYPE as func
  staging: ccree: fix line indentation and breaks
  staging: ccree: align box comment correctly
  staging: ccree: fix line indentation and breaks
  staging: ccree: fix struct init braces
  staging: ccree: fix line indentation and breaks
  staging: ccree: fix spelling mistakes
  staging: ccree: clean up comments
  staging: ccree: move over to BIT macro for bit defines
  staging: ccree: fix code indent
  staging: ccree: replace noop macro with inline
  staging: ccree: save ciphertext for CTS IV
  staging: ccree: remove BUG macro usage

Joe Perches (1):
  staging: ccree: Fix format/argument mismatches

Suniel Mahesh (3):
  staging: ccree: Replace kzalloc with devm_kzalloc
  staging: ccree: Convert to devm_ioremap_resource for map, unmap
  staging: ccree: Use platform_get_irq and devm_request_irq

 drivers/staging/ccree/Kconfig           |    2 +-
 drivers/staging/ccree/ssi_aead.c        | 1076 ++++++++++++++++---------------
 drivers/staging/ccree/ssi_aead.h        |   47 +-
 drivers/staging/ccree/ssi_buffer_mgr.c  |  216 ++++---
 drivers/staging/ccree/ssi_buffer_mgr.h  |    6 +-
 drivers/staging/ccree/ssi_cipher.c      |   88 ++-
 drivers/staging/ccree/ssi_cipher.h      |   10 +-
 drivers/staging/ccree/ssi_config.h      |    7 +-
 drivers/staging/ccree/ssi_driver.c      |  306 +++++----
 drivers/staging/ccree/ssi_driver.h      |   26 +-
 drivers/staging/ccree/ssi_hash.c        |  598 +++++++++--------
 drivers/staging/ccree/ssi_hash.h        |   12 +-
 drivers/staging/ccree/ssi_ivgen.c       |   19 +-
 drivers/staging/ccree/ssi_ivgen.h       |    3 +-
 drivers/staging/ccree/ssi_pm.c          |    3 +-
 drivers/staging/ccree/ssi_request_mgr.c |   75 ++-
 drivers/staging/ccree/ssi_request_mgr.h |    2 +-
 drivers/staging/ccree/ssi_sysfs.c       |   13 +-
 18 files changed, 1364 insertions(+), 1145 deletions(-)

-- 
2.1.4
