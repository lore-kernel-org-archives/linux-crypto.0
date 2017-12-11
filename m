From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v4 0/4] crypto: inside-secure - set of fixes
Date: Mon, 11 Dec 2017 12:10:54 +0100
Message-ID: <20171211111058.8878-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:58933 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbdLKLPE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 06:15:04 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

This series is a set of 4 fixes on the Inside Secure SafeXcel crypto
engine driver. The series will be followed by another non-fix one.

This is based on v4.15-rc3.

Thanks,
Antoine

Since v3:
  - Added one patch to only update areq->result on final operations.
  - Fixed two coding style issue in the patches.

Since v2:
  - Removed the patch only update the result buffer when provided.

Since v1:
  - Removed the crash.txt file which was part of patch 1/4.

Antoine Tenart (3):
  crypto: inside-secure - free requests even if their handling failed
  crypto: inside-secure - fix request allocations in invalidation path
  crypto: inside-secure - do not use areq->result for partial results

Ofer Heifetz (1):
  crypto: inside-secure - per request invalidation

 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 85 ++++++++++++++++++------
 drivers/crypto/inside-secure/safexcel_hash.c   | 89 ++++++++++++++++++--------
 3 files changed, 130 insertions(+), 45 deletions(-)

-- 
2.14.3
