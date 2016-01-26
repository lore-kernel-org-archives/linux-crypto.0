From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH 1/3] crypto: Introduce crypto_queue_len() helper function
Date: Tue, 26 Jan 2016 20:25:38 +0800
Message-ID: <75865be3c2ff947df2fa422d37a7d404c320e15b.1453810716.git.baolin.wang@linaro.org>
References: <cover.1453810716.git.baolin.wang@linaro.org>
Cc: broonie@kernel.org, linus.walleij@linaro.org, arnd@arndb.de,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	baolin.wang@linaro.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:36334 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933947AbcAZM0c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 07:26:32 -0500
Received: by mail-pf0-f177.google.com with SMTP id n128so98445552pfn.3
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jan 2016 04:26:32 -0800 (PST)
In-Reply-To: <cover.1453810716.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1453810716.git.baolin.wang@linaro.org>
References: <cover.1453810716.git.baolin.wang@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch introduces crypto_queue_len() helper function to help to get the
queue length in the crypto queue list now.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 include/crypto/algapi.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index c9fe145..4f861c4 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -184,6 +184,10 @@ int crypto_enqueue_request(struct crypto_queue *queue,
 			   struct crypto_async_request *request);
 struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue);
 int crypto_tfm_in_queue(struct crypto_queue *queue, struct crypto_tfm *tfm);
+static inline unsigned int crypto_queue_len(struct crypto_queue *queue)
+{
+	return queue->qlen;
+}
 
 /* These functions require the input/output to be aligned as u32. */
 void crypto_inc(u8 *a, unsigned int size);
-- 
1.7.9.5
