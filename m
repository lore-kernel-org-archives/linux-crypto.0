From: Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: [PATCH 1/1] crypto: Undefined behaviour in crypto_aes_expand_key
Date: Wed, 22 Jul 2009 17:57:03 +0300
Message-ID: <d6993c333f1a82367e6b0228f03e1ae2f5d5b9dd.1248272328.git.ext-phil.2.carmody@nokia.com>
References: <>
 <1248274623-17158-1-git-send-email-ext-phil.2.carmody@nokia.com>
Cc: linux-crypto@vger.kernel.org,
	Phil Carmody <ext-phil.2.carmody@nokia.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36327 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZGVO6X (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 10:58:23 -0400
In-Reply-To: <1248274623-17158-1-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It's undefined behaviour in C to write outside the bounds of an array.
The key expansion routine takes a shortcut of creating 8 words at a
time, but this creates 4 additional words which don't fit in the array.

As everyone is hopefully now aware, GCC is at liberty to make any
assumptions and optimisations it likes in situations where it can
detect that UB has occured, up to and including nasal demons, and
as the indices being accessed in the array are trivially calculable,
it's rash to invite gcc to do take any liberties at all.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 crypto/aes_generic.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index b8b66ec..e78b7ee 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1174,7 +1174,7 @@ EXPORT_SYMBOL_GPL(crypto_il_tab);
 	ctx->key_enc[6 * i + 11] = t;		\
 } while (0)
 
-#define loop8(i)	do {			\
+#define loop8tophalf(i)	do {			\
 	t = ror32(t, 8);			\
 	t = ls_box(t) ^ rco_tab[i];		\
 	t ^= ctx->key_enc[8 * i];			\
@@ -1185,6 +1185,10 @@ EXPORT_SYMBOL_GPL(crypto_il_tab);
 	ctx->key_enc[8 * i + 10] = t;			\
 	t ^= ctx->key_enc[8 * i + 3];			\
 	ctx->key_enc[8 * i + 11] = t;			\
+} while (0)
+
+#define loop8(i)	do {				\
+	loop8tophalf(i);				\
 	t  = ctx->key_enc[8 * i + 4] ^ ls_box(t);	\
 	ctx->key_enc[8 * i + 12] = t;			\
 	t ^= ctx->key_enc[8 * i + 5];			\
@@ -1245,8 +1249,9 @@ int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
 		ctx->key_enc[5] = le32_to_cpu(key[5]);
 		ctx->key_enc[6] = le32_to_cpu(key[6]);
 		t = ctx->key_enc[7] = le32_to_cpu(key[7]);
-		for (i = 0; i < 7; ++i)
+		for (i = 0; i < 6; ++i)
 			loop8(i);
+		loop8tophalf(i);
 		break;
 	}
 
-- 
1.5.4.3

