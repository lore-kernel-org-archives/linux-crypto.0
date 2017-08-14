From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 0/3 v3] crypto: engine - Permit to enqueue skcipher request
Date: Mon, 14 Aug 2017 15:17:22 +0200
Message-ID: <20170814131725.9402-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35350 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750876AbdHNNTf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 09:19:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

The crypto engine could actually only enqueue hash and ablkcipher request.
This patch serie permit it to enqueue skcipher requests by adding all necessary
functions.

Changes since v2
- added two patch for finding request type according to its cra_type

Changes since v1
- Aligned to column struct *dev in include
- Added missing mutex_unlock in crypto_engine_start()

Corentin Labbe (3):
  crypto: skcipher - export crypto_skcipher_type2
  crypto: engine - find request type with cra_type
  crypto: engine - Permit to enqueue skcipher request

 crypto/crypto_engine.c  | 133 ++++++++++++++++++++++++++++++++++++++++++++----
 crypto/skcipher.c       |   3 +-
 include/crypto/algapi.h |   1 +
 include/crypto/engine.h |  14 +++++
 4 files changed, 139 insertions(+), 12 deletions(-)

-- 
2.13.0
