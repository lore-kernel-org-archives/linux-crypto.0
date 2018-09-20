From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/3] crypto: OFB and tests
Date: Thu, 20 Sep 2018 14:18:37 +0100
Message-ID: <1537449521-16182-1-git-send-email-gilad@benyossef.com>
Cc: ofir.drang@arm.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add OFB mode generic implementation and more SM4 tests

Gilad Ben-Yossef (3):
  crypto: testmgr: update sm4 test vectors
  crypto: add output feedback mode
  crypto: tcrypt: add OFB functional tests

 crypto/Kconfig   |  12 +++
 crypto/Makefile  |   1 +
 crypto/ofb.c     | 225 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/tcrypt.c  |  17 +++++
 crypto/tcrypt.h  |   1 +
 crypto/testmgr.c |  12 +++
 crypto/testmgr.h | 122 ++++++++++++++++++++++++++++--
 7 files changed, 383 insertions(+), 7 deletions(-)
 create mode 100644 crypto/ofb.c

-- 
2.7.4
