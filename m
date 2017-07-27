From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/4] staging: ccree: coding style clean ups
Date: Thu, 27 Jul 2017 13:43:14 +0300
Message-ID: <1501152199-7671-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:44612 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750836AbdG0Kna (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jul 2017 06:43:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Misc. coding style fixes for ccree driver.

These are the missing patches that failed to apply two weeks ago,
rebased onto latest staging-next.

By the way, I still do not understand why they failed to apply,
as they applied just fine being cherry picked on top of latest
staging-next apart for fixes for later changes. I hope these will
be good.

Gilad Ben-Yossef (4):
  staging: ccree: fix parenthesis alignment
  staging: ccree: fix split strings
  staging: ccree: remove func name from log messages
  staging: ccree: kmalloc by sizeof var not type

 drivers/staging/ccree/ssi_aead.c        |  63 ++++++++-------
 drivers/staging/ccree/ssi_buffer_mgr.c  | 116 ++++++++++++---------------
 drivers/staging/ccree/ssi_cipher.c      |  47 +++++------
 drivers/staging/ccree/ssi_driver.c      |   8 +-
 drivers/staging/ccree/ssi_hash.c        | 137 ++++++++++++++++----------------
 drivers/staging/ccree/ssi_ivgen.c       |  12 +--
 drivers/staging/ccree/ssi_pm.c          |   4 +-
 drivers/staging/ccree/ssi_request_mgr.c |  19 +++--
 8 files changed, 197 insertions(+), 209 deletions(-)

-- 
2.1.4
