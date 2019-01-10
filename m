Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727545AbfAJUSY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 15:18:24 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 08/11] crypto: stat - remove unused mutex
Date: Thu, 10 Jan 2019 12:17:59 -0800
Message-Id: <20190110201802.82442-9-ebiggers@kernel.org>
In-Reply-To: <20190110201802.82442-1-ebiggers@kernel.org>
References: <20190110201802.82442-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

crypto_cfg_mutex in crypto_user_stat.c is unused.  Remove it.

Cc: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/crypto_user_stat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index d4d1cb2bedd7f..a03f326a63d32 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -20,8 +20,6 @@
 
 #define null_terminated(x)	(strnlen(x, sizeof(x)) < sizeof(x))
 
-static DEFINE_MUTEX(crypto_cfg_mutex);
-
 struct crypto_dump_info {
 	struct sk_buff *in_skb;
 	struct sk_buff *out_skb;
-- 
2.20.1.97.g81188d93c3-goog
