From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 0/8] cleanning and fixes for ecc, (ec)dh
Date: Fri, 12 May 2017 13:11:38 +0300
Message-ID: <1494583906-15472-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:27442 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757556AbdELKLv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2017 06:11:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The first two patches fix some typos and remove unused function arguments.

The next three remove some unnecessary casts for the ecc keys.

The next two fix the max_size() implemtations for (ec)dh. They were missing
the check if the key was set.

The last one allows other algorithms to use the function that generates
ecc public keys.

Tudor Ambarus (8):
  crypto: kpp, (ec)dh - fix typos
  crypto: ecc - remove unused function arguments
  crypto: ecc - remove casts in ecdh_make_pub_key
  crypto: ecc - remove casts in crypto_ecdh_shared_secret
  crypto: ecc - remove casts in ecc_is_key_valid
  crypto: dh - fix dh_max_size
  crypto: ecdh - fix ecdh_max_size
  crypto: ecc - don't be selfish on pubkeys

 crypto/dh.c           |  6 +++---
 crypto/dh_helper.c    |  4 ++--
 crypto/ecc.c          | 32 ++++++++++++++------------------
 crypto/ecc.h          | 25 ++++++++++---------------
 crypto/ecdh.c         | 24 +++++++++++-------------
 crypto/ecdh_helper.c  |  4 ++--
 include/crypto/dh.h   |  4 ++--
 include/crypto/ecdh.h |  4 ++--
 include/crypto/kpp.h  |  4 ++--
 9 files changed, 48 insertions(+), 59 deletions(-)

-- 
2.7.4
