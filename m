From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 0/8] staging: ccree: more cleanup work for 4.15
Date: Thu,  7 Sep 2017 12:00:08 +0300
Message-ID: <1504774817-11984-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:57206 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754109AbdIGJBV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Sep 2017 05:01:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

More cleanup work from Sunil and myself.

I've previously sent some of these as part of a larger patch set.
I've decided to split the patch set to smaller chunks to make it
more manageable.

This patch set applies on top of commit 28eb51f7468a
("staging:rtl8188eu:core Fix remove unneccessary else block").

Changes from v2:
- Cleanup return after error in BUG replacement patch
  as suggested by Dan Carpenter

Changes from v1:
- Fix kbuild reported error of "label at end of compound statement"

Gilad Ben-Yossef (5):
  staging: ccree: simplify resource release on error
  staging: ccree: remove unused completion
  staging: ccree: move over to BIT macro for bit defines
  staging: ccree: replace noop macro with inline
  staging: ccree: remove BUG macro usage

Suniel Mahesh (3):
  staging: ccree: Replace kzalloc with devm_kzalloc
  staging: ccree: Convert to devm_ioremap_resource for map, unmap
  staging: ccree: Use platform_get_irq and devm_request_irq

 drivers/staging/ccree/ssi_aead.c        |   3 +-
 drivers/staging/ccree/ssi_buffer_mgr.c  |  18 +--
 drivers/staging/ccree/ssi_cipher.c      |   4 +-
 drivers/staging/ccree/ssi_cipher.h      |  10 +-
 drivers/staging/ccree/ssi_driver.c      | 196 +++++++++++++-------------------
 drivers/staging/ccree/ssi_driver.h      |  15 +--
 drivers/staging/ccree/ssi_hash.c        |   3 +-
 drivers/staging/ccree/ssi_pm.c          |   3 +-
 drivers/staging/ccree/ssi_request_mgr.c |  22 +++-
 9 files changed, 118 insertions(+), 156 deletions(-)

-- 
2.1.4
