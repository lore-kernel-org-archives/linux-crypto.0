From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 0/1] crypto: engine: permit to enqueue ashash_request
Date: Thu,  2 Jun 2016 15:13:31 +0200
Message-ID: <1464873212-15426-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	baolin.wang@linaro.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35014 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbcFBNNn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 09:13:43 -0400
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

LABBE Corentin (1):
  crypto: engine: permit to enqueue ashash_request

 crypto/crypto_engine.c    | 19 ++++++++-----------
 drivers/crypto/omap-aes.c | 18 +++++++++++++-----
 drivers/crypto/omap-des.c | 18 +++++++++++++-----
 include/crypto/algapi.h   | 18 +++++++++---------
 4 files changed, 43 insertions(+), 30 deletions(-)

-- 
2.7.3
