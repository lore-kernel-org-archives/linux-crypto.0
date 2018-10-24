Return-Path: <SRS0=schb=NE=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:45258 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbeJXLuv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Oct 2018 07:50:51 -0400
From: Vitaly Chikunov <vt@altlinux.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] crypto: streebog - add Streebog hash function
Date: Wed, 24 Oct 2018 06:23:48 +0300
Message-Id: <20181024032356.3388-1-vt@altlinux.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add GOST/IETF Streebog hash function (GOST R 34.11-2012, RFC 6986)
generic hash transformation with appropriate testmgr and tcrypt
tests and vectors.

Streebog Hash Function (GOST R 34.11-2012, RFC 6986) is one of the Russian
cryptographic standard algorithms (called GOST algorithms).

References:
  https://tc26.ru/upload/iblock/fed/feddbb4d26b685903faa2ba11aea43f6.pdf
  https://tools.ietf.org/html/rfc6986

Tested using testmgr and tcrypt on x86_64, arm, arm64, and s390x on qemu.

Changes from v1:
- Fix of big-endian problem in add512.
- More architectures are tested, including big-endian and 32-bit.

Changes from v2:
- Register hash in Hash Info for use by IMA.
- Add hmac() tests.

Vitaly Chikunov (3):
  crypto: streebog - add Streebog hash function
  crypto: streebog - register Streebog in hash info for IMA
  crypto: streebog - add Streebog test vectors

 crypto/Kconfig                 |   12 +
 crypto/Makefile                |    1 +
 crypto/hash_info.c             |    4 +
 crypto/streebog_generic.c      | 1142 ++++++++++++++++++++++++++++++++++++++++
 crypto/tcrypt.c                |   35 ++
 crypto/testmgr.c               |   24 +
 crypto/testmgr.h               |  114 ++++
 include/crypto/hash_info.h     |    1 +
 include/crypto/streebog.h      |   34 ++
 include/uapi/linux/hash_info.h |    2 +
 10 files changed, 1369 insertions(+)
 create mode 100644 crypto/streebog_generic.c
 create mode 100644 include/crypto/streebog.h

-- 
2.11.0
