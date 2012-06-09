From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/3] crypto: arc4: improve performance by using u32 for ctx
 and variables
Date: Sat, 09 Jun 2012 18:25:46 +0300
Message-ID: <20120609152546.16420.95998.stgit@localhost6.localdomain6>
References: <20120609152535.16420.13917.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Jon Oberheide <jon@oberheide.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:37512 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2FIPZs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Jun 2012 11:25:48 -0400
In-Reply-To: <20120609152535.16420.13917.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch changes u8 in struct arc4_ctx and variables to u32 (as AMD seems
to have problem with u8 array). Below are tcrypt results of old 1-byte block
cipher versus ecb(arc4) with u8 and ecb(arc4) with u32.

tcrypt results, x86-64 (speed ratios: new-u32/old, new-u8/old):

                  u32    u8
AMD Phenom II   : x3.6   x2.7
Intel Core 2    : x2.0   x1.9

tcrypt results, i386 (speed ratios: new-u32/old, new-u8/old):

                  u32    u8
Intel Atom N260 : x1.5   x1.4

Cc: Jon Oberheide <jon@oberheide.org>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/arc4.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/arc4.c b/crypto/arc4.c
index 07913fc..5a772c3 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -22,8 +22,8 @@
 #define ARC4_BLOCK_SIZE		1
 
 struct arc4_ctx {
-	u8 S[256];
-	u8 x, y;
+	u32 S[256];
+	u32 x, y;
 };
 
 static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
@@ -39,7 +39,7 @@ static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		ctx->S[i] = i;
 
 	for (i = 0; i < 256; i++) {
-		u8 a = ctx->S[i];
+		u32 a = ctx->S[i];
 		j = (j + in_key[k] + a) & 0xff;
 		ctx->S[i] = ctx->S[j];
 		ctx->S[j] = a;
@@ -53,9 +53,9 @@ static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 static void arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in,
 		       unsigned int len)
 {
-	u8 *const S = ctx->S;
-	u8 x, y, a, b;
-	u8 ty, ta, tb;
+	u32 *const S = ctx->S;
+	u32 x, y, a, b;
+	u32 ty, ta, tb;
 
 	if (len == 0)
 		return;
