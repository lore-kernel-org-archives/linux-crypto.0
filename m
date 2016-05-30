From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 0/2] crypto: engine: permit to enqueue ashash_request
Date: Mon, 30 May 2016 15:32:00 +0200
Message-ID: <1464615122-16685-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	baolin.wang@linaro.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33595 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508AbcE3NcZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 May 2016 09:32:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

I wanted to use the crypto engine for my Allwinner crypto driver but something
prevented me to use it: it cannot enqueue hash requests.
The first patch convert crypto engine to permit enqueuing of ahash_requests.
The second patch convert the only driver using crypto engine.

The second patch was only compile tested but the crypto engine with
hash support was tested on two different offtree driver (sun4i-ss and sun8i-ce)

Regards

Changes since v1:
- rebased on cryptodev for handling omap-des

LABBE Corentin (2):
  crypto: engine: permit to enqueue ashash_request
  crypto: omap: convert to the new cryptoengine API

 crypto/crypto_engine.c    | 17 +++++++----------
 drivers/crypto/omap-aes.c | 10 ++++++----
 include/crypto/algapi.h   | 14 +++++++-------
 3 files changed, 20 insertions(+), 21 deletions(-)

-- 
2.7.3
