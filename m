From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v4 0/2] crypto: engine: permit to enqueue ashash_request
Date: Wed, 31 Aug 2016 14:02:56 +0200
Message-ID: <1472644978-9003-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, baolin.wang@linaro.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35939 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932341AbcHaMD0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2016 08:03:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

I wanted to use the crypto engine for my Allwinner crypto driver but something
prevented me to use it: it cannot enqueue hash requests.
This patch convert crypto engine to permit enqueuing of ahash_requests.
It also convert the only driver using crypto engine.

The modifications against omap was only compile tested but the crypto engine with
hash support was tested on two different offtree driver (sun4i-ss and sun8i-ce)

Regards

Changes since v1:
- rebased on cryptodev for handling omap-des

Changes since v2:
- Fusionned both patch
- Renamed crypt_one_request to do_one_request
- Test the type of request before processing it

Changes sunce v3
- Add functions for each type (ablkcipher/ahash)

LABBE Corentin (2):
  crypto: move crypto engine to its own header
  crypto: engine: permit to enqueue ashash_request

 crypto/crypto_engine.c    | 187 ++++++++++++++++++++++++++++++++++++----------
 drivers/crypto/omap-aes.c |   9 ++-
 drivers/crypto/omap-des.c |   9 ++-
 include/crypto/algapi.h   |  70 -----------------
 include/crypto/engine.h   | 107 ++++++++++++++++++++++++++
 5 files changed, 266 insertions(+), 116 deletions(-)
 create mode 100644 include/crypto/engine.h

-- 
2.7.3
