From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/8] staging: ccree: fixes and cleanups
Date: Tue,  7 Nov 2017 09:39:56 +0000
Message-ID: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:46318 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754244AbdKGJkS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Nov 2017 04:40:18 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is another batch of ccree fixes & cleanups.

The first patch is a bug fix. All others are pure
readability and coding style fixes.

Gilad Ben-Yossef (8):
  staging: ccree: fix leak of import() after init()
  staging: ccree: use more readable func names
  staging: ccree: simplify AEAD using local var
  staging: ccree: simplify buf mgr using local vars
  staging: ccree: fold common code into function
  staging: ccree: simplify pm manager using local var
  staging: ccree: remove compare to none zero
  staging: ccree: remove braces for single statement

 drivers/staging/ccree/ssi_aead.c        |  64 ++--
 drivers/staging/ccree/ssi_buffer_mgr.c  | 556 ++++++++++++++------------------
 drivers/staging/ccree/ssi_buffer_mgr.h  |  49 ++-
 drivers/staging/ccree/ssi_cipher.c      |  27 +-
 drivers/staging/ccree/ssi_driver.c      |  48 +--
 drivers/staging/ccree/ssi_hash.c        | 195 +++++------
 drivers/staging/ccree/ssi_ivgen.c       |   4 +-
 drivers/staging/ccree/ssi_pm.c          |  42 +--
 drivers/staging/ccree/ssi_pm.h          |  12 +-
 drivers/staging/ccree/ssi_request_mgr.c |  24 +-
 drivers/staging/ccree/ssi_request_mgr.h |   6 +-
 drivers/staging/ccree/ssi_sram_mgr.c    |  13 +-
 drivers/staging/ccree/ssi_sram_mgr.h    |   6 +-
 13 files changed, 494 insertions(+), 552 deletions(-)

-- 
2.7.4
