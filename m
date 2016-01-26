From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH 0/3] Introduce the cypto engine framework
Date: Tue, 26 Jan 2016 20:25:37 +0800
Message-ID: <cover.1453810716.git.baolin.wang@linaro.org>
Cc: broonie@kernel.org, linus.walleij@linaro.org, arnd@arndb.de,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	baolin.wang@linaro.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now block cipher engines need to implement and maintain their own queue/thread
for processing requests, moreover currently helpers provided for only the queue
itself (in crypto_enqueue_request() and crypto_dequeue_request()) but they
don't help with the mechanics of driving the hardware (things like running the
request immediately, DMA map it or providing a thread to process the queue in)
even though a lot of that code really shouldn't vary that much from device to
device.

This patch introduces the crypto engine framework to help the crypto hardware
drivers to queue requests.

Baolin Wang (3):
  crypto: Introduce crypto_queue_len() helper function
  crypto: Introduce the block request crypto engine framework
  crypto: omap-aes: Support crypto engine framework

 crypto/Kconfig            |    3 +
 crypto/Makefile           |    1 +
 crypto/crypto_engine.c    |  355 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/Kconfig    |    1 +
 drivers/crypto/omap-aes.c |   97 ++++++-------
 include/crypto/algapi.h   |   74 ++++++++++
 6 files changed, 478 insertions(+), 53 deletions(-)
 create mode 100644 crypto/crypto_engine.c

-- 
1.7.9.5
