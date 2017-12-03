From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 00/10] staging: ccree: cleanups & fixes
Date: Sun,  3 Dec 2017 13:58:11 +0000
Message-ID: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:55130 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752025AbdLCN7M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Dec 2017 08:59:12 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Another batch of ccree work. Includes the usual mix of mostly cleanups
and one fix. Also includes an updated TODO to reflect recent progress
and removal of interim documentation of device tree strings as the
official string and documentation thereof got blessed into the crypto tree.

Gilad Ben-Yossef (10):
  staging: ccree: remove inline qualifiers
  staging: ccree: remove unproven likely/unlikely
  staging: ccree: remove more unnecessary parentheses
  staging: ccree: fix indentation of var assignment
  staging: ccree: remove braces for single statement blocks
  staging: ccree: remove interim DT docs
  staging: ccree: update TODO list
  staging: ccree: NULLify backup_info when unused
  staging: ccree: fix AEAD func naming convention
  staging: ccree: amend aead func def for readability

 .../devicetree/bindings/crypto/arm-cryptocell.txt  |  27 -
 drivers/staging/ccree/TODO                         |  23 +-
 drivers/staging/ccree/ssi_aead.c                   | 706 ++++++++++-----------
 drivers/staging/ccree/ssi_aead.h                   |   4 +-
 drivers/staging/ccree/ssi_buffer_mgr.c             | 189 +++---
 drivers/staging/ccree/ssi_cipher.c                 |  61 +-
 drivers/staging/ccree/ssi_driver.c                 |  40 +-
 drivers/staging/ccree/ssi_hash.c                   | 105 ++-
 drivers/staging/ccree/ssi_ivgen.c                  |   2 +-
 drivers/staging/ccree/ssi_request_mgr.c            |  33 +-
 drivers/staging/ccree/ssi_sram_mgr.c               |   4 +-
 11 files changed, 541 insertions(+), 653 deletions(-)
 delete mode 100644 drivers/staging/ccree/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt

-- 
2.7.4
