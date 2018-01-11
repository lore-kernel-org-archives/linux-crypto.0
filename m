From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 0/5] crypto: chelsio - Cleanup and bug fixes
Date: Thu, 11 Jan 2018 16:45:47 +0530
Message-ID: <cover.1515669022.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:12484 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933727AbeAKLQD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 06:16:03 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series include cleanup, bug fixes and authenc algo supporting
 ctr(aes)-sha operation.

Harsh Jain (5):
  crypto: chelsio - Fix Indentation
  crypto: chelsio - check for sg null
  crypto: chelsio - Fix IV updated in XTS operation
  crypto: chelsio - Add authenc versions of ctr and sha
  crypto: chelsio - Remove dst sg size zero check

 drivers/crypto/chelsio/chcr_algo.c   | 299 ++++++++++++++++++++++++++---------
 drivers/crypto/chelsio/chcr_crypto.h |   7 +-
 2 files changed, 233 insertions(+), 73 deletions(-)

-- 
2.1.4
