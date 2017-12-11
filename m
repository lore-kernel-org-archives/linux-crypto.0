From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH v3 0/3] crypto: inside-secure - set of fixes
Date: Mon, 11 Dec 2017 09:48:05 +0100
Message-ID: <20171211084808.8272-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53754 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751307AbdLKIuD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 03:50:03 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

This series is a set of 4 fixes on the Inside Secure SafeXcel crypto
engine driver. The series will be followed by another non-fix one.

This is based on v4.15-rc3.

Thanks,
Antoine

Since v2:
  - Removed the patch only update the result buffer when provided.

Since v1:
  - Removed the crash.txt file which was part of patch 1/4.

Antoine Tenart (2):
  crypto: inside-secure - free requests even if their handling failed
  crypto: inside-secure - fix request allocations in invalidation path

Ofer Heifetz (1):
  crypto: inside-secure - per request invalidation

 drivers/crypto/inside-secure/safexcel.c        |  1 +
 drivers/crypto/inside-secure/safexcel_cipher.c | 83 ++++++++++++++++++++------
 drivers/crypto/inside-secure/safexcel_hash.c   | 80 ++++++++++++++++++-------
 3 files changed, 125 insertions(+), 39 deletions(-)

-- 
2.14.3
