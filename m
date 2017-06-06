From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 0/2] crypto: engine - Permit to enqueue skcipher request
Date: Tue,  6 Jun 2017 15:44:15 +0200
Message-ID: <20170606134417.18850-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The crypto engine could actually only enqueue hash and ablkcipher request.
This patch serie permit it to enqueue skcipher requets by adding all necessary
functions.

Changes since v1
- Aligned to column struct *dev in include
- Added missing mutex_unlock in crypto_engine_start()

Corentin Labbe (2):
  crypto: engine - replace pr_xxx by dev_xxx
  crypto: engine - Permit to enqueue skcipher request

 crypto/crypto_engine.c  | 157 ++++++++++++++++++++++++++++++++++++++++++------
 include/crypto/engine.h |  15 +++++
 2 files changed, 153 insertions(+), 19 deletions(-)

-- 
2.13.0
