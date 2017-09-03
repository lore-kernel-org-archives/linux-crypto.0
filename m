From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/8] staging: ccree: more cleanup work for 4.14
Date: Sun,  3 Sep 2017 11:56:42 +0300
Message-ID: <1504429011-25514-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:49082 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751068AbdICI45 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Sep 2017 04:56:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

More cleanup work from Sunil and myself.

I've previously sent some of these as part of a larger patch set.
I've decided to split the patch set to smaller chunks to make it
more manageable.

This patch set applies on top of commit 28eb51f7468a
("staging:rtl8188eu:core Fix remove unneccessary else block").

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
 drivers/staging/ccree/ssi_buffer_mgr.c  |  14 +--
 drivers/staging/ccree/ssi_cipher.c      |   4 +-
 drivers/staging/ccree/ssi_cipher.h      |  10 +-
 drivers/staging/ccree/ssi_driver.c      | 196 +++++++++++++-------------------
 drivers/staging/ccree/ssi_driver.h      |  15 +--
 drivers/staging/ccree/ssi_hash.c        |   3 +-
 drivers/staging/ccree/ssi_pm.c          |   3 +-
 drivers/staging/ccree/ssi_request_mgr.c |  23 +++-
 9 files changed, 119 insertions(+), 152 deletions(-)

-- 
2.1.4
