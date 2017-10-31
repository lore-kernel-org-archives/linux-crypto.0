From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/3] staging: ccree: Fixes and cleanups
Date: Tue, 31 Oct 2017 11:56:14 +0000
Message-ID: <1509450978-17784-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:34738 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750872AbdJaL41 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2017 07:56:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes and cleanups for 4.15

Gilad Ben-Yossef (3):
  staging: ccree: copy IV to DMAable memory
  staging: ccree: handle limiting of DMA masks
  staging: ccree: remove dead code

 drivers/staging/ccree/ssi_cipher.c | 20 ++++++++++++++------
 drivers/staging/ccree/ssi_cipher.h |  1 +
 drivers/staging/ccree/ssi_driver.c | 22 ++++++++++++++++++----
 drivers/staging/ccree/ssi_driver.h |  1 -
 4 files changed, 33 insertions(+), 11 deletions(-)

-- 
2.7.4
