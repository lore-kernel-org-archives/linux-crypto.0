From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 07/10] crypto/des_generic: Make des_ekey prototype more
 specific.
Date: Sun, 08 Feb 2009 06:53:32 -0500
Message-ID: <20090208115332.5708.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux@horizon.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:17675 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752585AbZBHMAO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Feb 2009 07:00:14 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The C compiler treats it equivalently, but it's nice documentation
to explain how big the arrays pointed to are.
---
 crypto/des_generic.c |    4 ++--
 include/crypto/des.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 647189e..656039b 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -588,7 +588,7 @@ static const u32 S8[64] = {
  *   Choice 1 has operated on the key.
  *
  */
-unsigned long des_ekey(u32 *pe, const u8 *k)
+unsigned long des_ekey(u32 pe[DES_EXPKEY_WORDS], const u8 k[DES_KEY_SIZE])
 {
 	/* K&R: long is at least 32 bits */
 	unsigned long a, b, c, d, w;
@@ -668,7 +668,7 @@ EXPORT_SYMBOL_GPL(des_ekey);
  * No weak key checking is performed, as this is only used by triple DES
  *
  */
-static void dkey(u32 *pe, const u8 *k)
+sstatic void des_dkey(u32 pe[DES_EXPKEY_WORDS], const u8 k[DES_KEY_SIZE])
 {
 	/* K&R: long is at least 32 bits */
 	unsigned long a, b, c, d;
diff --git a/include/crypto/des.h b/include/crypto/des.h
index 2971c63..b99ea2a 100644
--- a/include/crypto/des.h
+++ b/include/crypto/des.h
@@ -14,6 +14,6 @@
 #define DES3_EDE_BLOCK_SIZE	DES_BLOCK_SIZE
 
 
-extern unsigned long des_ekey(u32 *pe, const u8 *k);
+unsigned long des_ekey(u32 pe[DES_EXPKEY_WORDS], const u8 k[DES_KEY_SIZE]);
 
 #endif /* __CRYPTO_DES_H */
-- 
1.6.0.6

