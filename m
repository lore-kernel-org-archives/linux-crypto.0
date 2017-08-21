From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/2] crypto: add OSCCA SM3 secure hash and tests
Date: Mon, 21 Aug 2017 13:51:27 +0300
Message-ID: <1503312690-2770-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add OSCCA SM3 secure hash (OSCCA GM/T 0004-2012 SM3)
generic hash transformation, testmgr and tcrypt tests.

SM3 is a secure hash function which is part of the Chinese
"Commercial Cryptography" suite of algorithms which use is
required for certain commercial applications in China.

References:
 http://www.oscca.gov.cn/UpFile/20101222141857786.pdf
 https://datatracker.ietf.org/doc/html/draft-shen-sm3-hash

Tested via testmgr and tcrypt on Arm 64 and 32 bit. Compile
tested for x86_64.

Gilad Ben-Yossef (2):
  crypto: add OSCCA SM3 secure hash
  crypto: add SM3 test vectors

 crypto/Kconfig            |  11 +++
 crypto/Makefile           |   1 +
 crypto/sm3_generic.c      | 210 ++++++++++++++++++++++++++++++++++++++++++++++
 crypto/tcrypt.c           |  14 +++-
 crypto/testmgr.c          |   6 ++
 crypto/testmgr.h          |  67 +++++++++++++++
 include/crypto/sm3.h      |  40 +++++++++
 include/crypto/sm3_base.h | 117 ++++++++++++++++++++++++++
 8 files changed, 465 insertions(+), 1 deletion(-)
 create mode 100644 crypto/sm3_generic.c
 create mode 100644 include/crypto/sm3.h
 create mode 100644 include/crypto/sm3_base.h

-- 
2.1.4
