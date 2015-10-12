From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 6/8] crypto: akcipher: the key parameter must be const u8 *
Date: Mon, 12 Oct 2015 18:53:44 +0200
Message-ID: <1444668826-6531-7-git-send-email-clabbe.montjoie@gmail.com>
References: <1444668826-6531-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	thomas.lendacky@amd.com, geert+renesas@glider.be,
	ulf.hansson@linaro.org, wsa@the-dreams.de, keescook@chromium.org,
	maxime.ripard@free-electrons.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:38466 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbbJLQyc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Oct 2015 12:54:32 -0400
In-Reply-To: <1444668826-6531-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All cryptoAPI setkey function set the key parameter as const u8 *.
This patch make the crypto_akcipher_setkey parameters like others.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 include/crypto/akcipher.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
index 0c9fa68..ade053b 100644
--- a/include/crypto/akcipher.h
+++ b/include/crypto/akcipher.h
@@ -330,7 +330,8 @@ static inline int crypto_akcipher_verify(struct akcipher_request *req)
  *
  * Return: zero on success; error code in case of error
  */
-static inline int crypto_akcipher_setkey(struct crypto_akcipher *tfm, void *key,
+static inline int crypto_akcipher_setkey(struct crypto_akcipher *tfm,
+					 const u8 *key,
 					 unsigned int keylen)
 {
 	struct akcipher_alg *alg = crypto_akcipher_alg(tfm);
-- 
2.4.9
