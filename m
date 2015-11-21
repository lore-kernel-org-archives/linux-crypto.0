From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] crypto: padlock-aes - use offset_in_page macro
Date: Sat, 21 Nov 2015 22:24:11 +0800
Message-ID: <19b0bc324e0d893c4b516f3873b6dcbcff0da6ea.1448115766.git.geliangtang@163.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m50-133.163.com ([123.125.50.133]:49360 "EHLO m50-133.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbbKUOZV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 21 Nov 2015 09:25:21 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use offset_in_page macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/crypto/padlock-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index da2d677..be2dd10 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -238,7 +238,7 @@ static inline void ecb_crypt(const u8 *in, u8 *out, u32 *key,
 	/* Padlock in ECB mode fetches at least ecb_fetch_bytes of data.
 	 * We could avoid some copying here but it's probably not worth it.
 	 */
-	if (unlikely(((unsigned long)in & ~PAGE_MASK) + ecb_fetch_bytes > PAGE_SIZE)) {
+	if (unlikely(offset_in_page(in) + ecb_fetch_bytes > PAGE_SIZE)) {
 		ecb_crypt_copy(in, out, key, cword, count);
 		return;
 	}
@@ -250,7 +250,7 @@ static inline u8 *cbc_crypt(const u8 *in, u8 *out, u32 *key,
 			    u8 *iv, struct cword *cword, int count)
 {
 	/* Padlock in CBC mode fetches at least cbc_fetch_bytes of data. */
-	if (unlikely(((unsigned long)in & ~PAGE_MASK) + cbc_fetch_bytes > PAGE_SIZE))
+	if (unlikely(offset_in_page(in) + cbc_fetch_bytes > PAGE_SIZE))
 		return cbc_crypt_copy(in, out, key, iv, cword, count);
 
 	return rep_xcrypt_cbc(in, out, key, iv, cword, count);
-- 
2.5.0
