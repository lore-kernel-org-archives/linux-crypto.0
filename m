From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v4 00/14] fixes for kpp and akcipher
Date: Thu, 25 May 2017 10:18:02 +0300
Message-ID: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <horia.geanta@nxp.com>, <dan.douglass@nxp.com>,
        <giovanni.cabiddu@intel.com>, <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:48263 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756033AbdEYHSW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 May 2017 03:18:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

These are various fixes that I made while reading kpp and akcipher
implementations.

Changes in v4:
 - assume key is already set when calling crypto_akcipher/kpp_maxsize()

v3 can be found at:
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg25312.html

Tudor Ambarus (14):
  crypto: kpp, (ec)dh - fix typos
  crypto: ecc - remove unused function arguments
  crypto: ecc - remove unnecessary casts
  crypto: ecc - don't be selfish on pubkeys
  crypto: dh - fix memleak in setkey
  crypto: kpp: maxsize() - assume key is already set
  crypto: dh - comply with crypto_kpp_maxsize()
  crypto: ecdh - comply with crypto_kpp_maxsize()
  crypto: qat - comply with crypto_kpp_maxsize()
  crypto: akcipher: maxsize() - assume key is already set
  crypto: rsa - comply with crypto_akcipher_maxsize()
  crypto: caampkc - comply with crypto_akcipher_maxsize()
  crypto: qat - comply with crypto_akcipher_maxsize()
  crypto: pkcs1pad - comply with crypto_akcipher_maxsize()

 crypto/dh.c                                   |  9 +++++---
 crypto/dh_helper.c                            |  4 ++--
 crypto/ecc.c                                  | 32 ++++++++++++---------------
 crypto/ecc.h                                  | 25 +++++++++------------
 crypto/ecdh.c                                 | 25 +++++++++------------
 crypto/ecdh_helper.c                          |  4 ++--
 crypto/rsa-pkcs1pad.c                         | 10 ++-------
 crypto/rsa.c                                  |  4 ++--
 drivers/crypto/caam/caampkc.c                 |  5 ++---
 drivers/crypto/qat/qat_common/qat_asym_algs.c |  8 +++----
 include/crypto/akcipher.h                     | 11 ++++-----
 include/crypto/dh.h                           |  4 ++--
 include/crypto/ecdh.h                         |  4 ++--
 include/crypto/kpp.h                          | 15 +++++++------
 14 files changed, 73 insertions(+), 87 deletions(-)

-- 
2.7.4
