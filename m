From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 0/2] crypto: engine: permit to enqueue ashash_request
Date: Wed, 18 May 2016 11:21:23 +0200
Message-ID: <1463563285-11742-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: baolin.wang@linaro.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33485 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbcERJVf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 05:21:35 -0400
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

LABBE Corentin (2):
  crypto: engine: permit to enqueue ashash_request
  crypto: omap: convert to the new cryptoengine API

 crypto/crypto_engine.c    | 17 +++++++----------
 drivers/crypto/omap-aes.c | 10 ++++++----
 include/crypto/algapi.h   | 14 +++++++-------
 3 files changed, 20 insertions(+), 21 deletions(-)

-- 
2.7.3
