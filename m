From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/2] crypto: introduce SM4 symmetric cipher algorithm
Date: Tue,  6 Mar 2018 09:44:41 +0000
Message-ID: <1520329484-23317-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Introduce the SM4 cipher algorithms (OSCCA GB/T 32907-2016) and
related tests.

SM4 (GBT.32907-2016) is a cryptographic standard issued by the
Organization of State Commercial Administration of China (OSCCA)
as an authorized cryptographic algorithms for the use within China.

SMS4 was originally created for use in protecting wireless
networks, and is mandated in the Chinese National Standard for
Wireless LAN WAPI (Wired Authentication and Privacy Infrastructure)
(GB.15629.11-2003).

Tested on arm 64 and 32 bit.

Gilad Ben-Yossef (2):
  crypto: introduce SM4 symmetric cipher algorithm
  crypto: introduce SM4 testmgr tests

 crypto/Kconfig       |  25 ++++++
 crypto/Makefile      |   1 +
 crypto/sm4_generic.c | 244 +++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/tcrypt.c      |   3 +
 crypto/testmgr.c     |   9 ++
 crypto/testmgr.h     | 131 +++++++++++++++++++++++++++
 include/crypto/sm4.h |  28 ++++++
 7 files changed, 441 insertions(+)
 create mode 100644 crypto/sm4_generic.c
 create mode 100644 include/crypto/sm4.h

-- 
2.7.4
