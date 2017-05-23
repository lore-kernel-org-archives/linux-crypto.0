From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH v3 00/11] fixes for ecc, ec(dh), rsa & testmgr
Date: Tue, 23 May 2017 16:18:54 +0300
Message-ID: <1495545545-16872-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:44704 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933426AbdEWNTT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 09:19:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

These are various fixes that I made while reading kpp and akcipher
implementations.

For KEYS there is only one patch. It checks the return value of
crypto_akcipher_maxsize().

Changes in v3:
 - change error code to ENOKEY instead of EINVAL in
   dh/ecdh/rsa_max_size()
 - reorder commits
 - update some commit messages
 - drop "crypto: rsa - do checks before allocating data",
   it didn't consider leading zeros.

Changes in v2:
 - squash the patches that removed the unnecessary casts
 - add the last five patches

v1 can be found at:
http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg25139.html

Tudor Ambarus (11):
  crypto: kpp, (ec)dh - fix typos
  crypto: ecc - remove unused function arguments
  crypto: ecc - remove unnecessary casts
  crypto: dh - fix dh_max_size
  crypto: ecdh - fix ecdh_max_size
  crypto: rsa - change err code in rsa_max_size
  crypto: testmgr - check err on kpp maxsize
  crypto: testmgr - check err on akcipher maxsize
  crypto: KEYS: check err on akcipher maxsize
  crypto: ecc - don't be selfish on pubkeys
  crypto: dh - fix memleak in setkey

 crypto/asymmetric_keys/public_key.c |  5 +++++
 crypto/dh.c                         |  9 ++++++---
 crypto/dh_helper.c                  |  4 ++--
 crypto/ecc.c                        | 32 ++++++++++++++------------------
 crypto/ecc.h                        | 25 ++++++++++---------------
 crypto/ecdh.c                       | 24 +++++++++++-------------
 crypto/ecdh_helper.c                |  4 ++--
 crypto/rsa.c                        |  2 +-
 crypto/testmgr.c                    | 10 ++++++++++
 include/crypto/dh.h                 |  4 ++--
 include/crypto/ecdh.h               |  4 ++--
 include/crypto/kpp.h                |  4 ++--
 12 files changed, 67 insertions(+), 60 deletions(-)

-- 
2.7.4
