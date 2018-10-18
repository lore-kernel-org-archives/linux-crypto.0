Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:37494 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbeJRVBR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 17:01:17 -0400
From: Yael Chemla <yael.chemla@foss.arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org
Cc: Yael Chemla <yael.chemla@foss.arm.com>
Subject: [PATCH 0/3] crypto: ccree: add SM3 support
Date: Thu, 18 Oct 2018 13:59:56 +0100
Message-Id: <1539867599-20504-1-git-send-email-yael.chemla@foss.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for SM3 in CryptoCell 713.

Yael Chemla (3):
  crypto: ccree: adjust hash length to suit certain context specifics
  crypto: ccree:  modify set_cipher_mode usage from cc_hash
  crypto: ccree: add SM3 support

 drivers/crypto/Kconfig                  |   1 +
 drivers/crypto/ccree/cc_aead.c          |  19 +++-
 drivers/crypto/ccree/cc_crypto_ctx.h    |   4 +-
 drivers/crypto/ccree/cc_driver.c        |  10 +-
 drivers/crypto/ccree/cc_driver.h        |   2 +-
 drivers/crypto/ccree/cc_hash.c          | 175 +++++++++++++++++++++++---------
 drivers/crypto/ccree/cc_hw_queue_defs.h |  27 +++++
 7 files changed, 182 insertions(+), 56 deletions(-)

-- 
2.7.4
