Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729051AbfAJUSX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 15:18:23 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 05/11] crypto: user - forward declare crypto_nlsk
Date: Thu, 10 Jan 2019 12:17:56 -0800
Message-Id: <20190110201802.82442-6-ebiggers@kernel.org>
In-Reply-To: <20190110201802.82442-1-ebiggers@kernel.org>
References: <20190110201802.82442-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Move the declaration of crypto_nlsk into internal/cryptouser.h.  This
fixes the following sparse warning:

    crypto/crypto_user_base.c:41:13: warning: symbol 'crypto_nlsk' was not declared. Should it be static?

Cc: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/crypto_user_stat.c            | 2 --
 include/crypto/internal/cryptouser.h | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/crypto_user_stat.c b/crypto/crypto_user_stat.c
index 3e9a53233d804..d4d1cb2bedd7f 100644
--- a/crypto/crypto_user_stat.c
+++ b/crypto/crypto_user_stat.c
@@ -22,8 +22,6 @@
 
 static DEFINE_MUTEX(crypto_cfg_mutex);
 
-extern struct sock *crypto_nlsk;
-
 struct crypto_dump_info {
 	struct sk_buff *in_skb;
 	struct sk_buff *out_skb;
diff --git a/include/crypto/internal/cryptouser.h b/include/crypto/internal/cryptouser.h
index 40623f4457df6..8c602b187c58a 100644
--- a/include/crypto/internal/cryptouser.h
+++ b/include/crypto/internal/cryptouser.h
@@ -1,6 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <net/netlink.h>
 
+extern struct sock *crypto_nlsk;
+
 struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int exact);
 
 #ifdef CONFIG_CRYPTO_STATS
-- 
2.20.1.97.g81188d93c3-goog
