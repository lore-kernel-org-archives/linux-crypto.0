From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 00/12] staging: ccree: coding style fixes
Date: Thu, 13 Jul 2017 11:19:50 +0300
Message-ID: <1499934004-28513-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:34224 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750933AbdGMIUN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2017 04:20:13 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Another batch of ccree coding style fixes.

These goes on top of commit a8c4ae12 ("staging: ccree: Fix alignment issues in ssi_sysfs.c")
in staging-testing.

Gilad Ben-Yossef (12):
  staging: ccree remove unnecessary parentheses
  staging: ccree: clean up struct ssi_aead_ctx
  staging: ccree: use proper printk format for dma_addr_t
  staging: ccree: fix parenthesis alignment
  staging: ccree: fix split strings
  staging: ccree: CamelCase to snake_case in func vars
  staging: ccree: CamelCase to snake_case in aead struct
  staging: ccree: avoid constant comparison
  staging: ccree: avoid unnecessary line continuation
  staging: ccree: remove func name from log messages
  staging: ccree: kmalloc by sizeof var not type
  staging: ccree: remove whitespace before a quoted newline

 drivers/staging/ccree/ssi_aead.c        | 242 +++++++++++++++++--------------
 drivers/staging/ccree/ssi_aead.h        |  12 +-
 drivers/staging/ccree/ssi_buffer_mgr.c  | 247 +++++++++++++++-----------------
 drivers/staging/ccree/ssi_cipher.c      |  65 ++++-----
 drivers/staging/ccree/ssi_driver.c      |  16 +--
 drivers/staging/ccree/ssi_hash.c        | 209 ++++++++++++++-------------
 drivers/staging/ccree/ssi_ivgen.c       |  17 +--
 drivers/staging/ccree/ssi_pm.c          |   4 +-
 drivers/staging/ccree/ssi_request_mgr.c |  29 ++--
 drivers/staging/ccree/ssi_sysfs.c       |  18 +--
 10 files changed, 435 insertions(+), 424 deletions(-)

-- 
2.1.4
