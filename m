From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 0/4] clean some ecc functions
Date: Wed, 10 May 2017 11:40:45 +0300
Message-ID: <1494405649-30322-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:41988 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752100AbdEJIua (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 May 2017 04:50:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ecc software implementation works with chunks of u64 data. There were some
unnecessary casts to u8 and then back to u64 for the ecc keys. Remove the
unncessary casts.

Tudor Ambarus (4):
  crypto: ecc - remove unused function arguments
  crypto: ecc - remove casts in ecdh_make_pub_key
  crypto: ecc - remove casts in crypto_ecdh_shared_secret
  crypto: ecc - remove casts in ecc_is_key_valid

 crypto/ecc.c  | 30 +++++++++++++-----------------
 crypto/ecc.h  | 15 ++++-----------
 crypto/ecdh.c | 12 +++++-------
 3 files changed, 22 insertions(+), 35 deletions(-)

-- 
2.7.4
