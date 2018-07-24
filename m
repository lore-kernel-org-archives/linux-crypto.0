From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 0/4] crypto: ccree: fixes and cleanups
Date: Tue, 24 Jul 2018 15:12:42 +0100
Message-ID: <1532441567-11694-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Various code clean ups and fix ups.

Gilad Ben-Yossef (4):
  crypto: ccree: drop useless type flag during reg
  crypto: ccree: remove cipher ivgen left overs
  crypto: ccree: zero all of request ctx before use
  crypto: ccree: allow bigger than sector XTS op

 drivers/crypto/ccree/cc_aead.c       | 16 +---------------
 drivers/crypto/ccree/cc_buffer_mgr.c |  8 ++------
 drivers/crypto/ccree/cc_cipher.c     | 36 ++++--------------------------------
 drivers/crypto/ccree/cc_cipher.h     |  1 -
 drivers/crypto/ccree/cc_driver.h     |  1 -
 5 files changed, 7 insertions(+), 55 deletions(-)

-- 
2.7.4
