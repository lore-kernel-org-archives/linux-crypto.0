Return-Path: <SRS0=ECh6=O2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbeLQHYr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Dec 2018 02:24:47 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Rice <rob.rice@broadcom.com>,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Yael Chemla <yael.chemla@foss.arm.com>
Subject: [PATCH 0/3] crypto: authenc - fix key parsing
Date: Sun, 16 Dec 2018 23:23:21 -0800
Message-Id: <20181217072324.16844-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix incorrect validation of the key passed to "authenc" AEADs that
allowed crashing the kernel via AF_ALG.  The real fix is in patch 1, but
two drivers had to be converted to use crypto_authenc_extractkeys() too.

Please note: for the bcm and ccree driver changes I haven't re-run the
self-tests, as I don't have that hardware.  Please do so if you can.

Eric Biggers (3):
  crypto: authenc - fix parsing key with misaligned rta_len
  crypto: bcm - convert to use crypto_authenc_extractkeys()
  crypto: ccree - convert to use crypto_authenc_extractkeys()

 crypto/authenc.c               | 14 ++++++++---
 drivers/crypto/Kconfig         |  1 +
 drivers/crypto/bcm/cipher.c    | 44 ++++++++++------------------------
 drivers/crypto/ccree/cc_aead.c | 40 +++++++++++++++----------------
 4 files changed, 44 insertions(+), 55 deletions(-)

-- 
2.19.2
