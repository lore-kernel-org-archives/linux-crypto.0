From: Vitaly Chikunov <vt@altlinux.org>
Subject: [PATCH v2 0/2] crypto: streebog - add Streebog hash function
Date: Wed, 10 Oct 2018 15:12:50 +0300
Message-ID: <20181010121254.12220-1-vt@altlinux.org>
Cc: Vitaly Chikunov <vt@altlinux.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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

Vitaly Chikunov (2):
  crypto: streebog - add Streebog hash function
  crypto: streebog - add Streebog test vectors

 crypto/Kconfig            |   12 +
 crypto/Makefile           |    1 +
 crypto/streebog_generic.c | 1142 +++++++++++++++++++++++++++++++++++++++++++++
 crypto/tcrypt.c           |   27 ++
 crypto/testmgr.c          |   12 +
 crypto/testmgr.h          |   71 +++
 include/crypto/streebog.h |   34 ++
 7 files changed, 1299 insertions(+)
 create mode 100644 crypto/streebog_generic.c
 create mode 100644 include/crypto/streebog.h

-- 
2.11.0
