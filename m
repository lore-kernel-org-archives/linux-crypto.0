Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B086170B
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 01:56:19 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8dmJ-005FB1-HZ; Thu, 30 Nov 2023 17:56:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 17:56:24 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Thu, 30 Nov 2023 17:56:24 +0800
Subject: [v2 PATCH 3/4] crypto: arc4 - Add internal state
References: <ZWhcDoBp8wPiWiYa@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Message-Id: <E1r8dmJ-005FB1-HZ@formenos.hmeau.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The arc4 algorithm has always had internal state.  It's been buggy
from day one in that the state has been stored in the shared tfm
object.  That means two users sharing the same tfm will end up
affecting each other's output, or worse, they may end up with the
same output.

Fix this by declaring an internal state and storing the state there
instead of within the tfm context.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/arc4.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/arc4.c b/crypto/arc4.c
index 2150f94e7d03..e285bfcef667 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -23,10 +23,15 @@ static int crypto_arc4_setkey(struct crypto_lskcipher *tfm, const u8 *in_key,
 }
 
 static int crypto_arc4_crypt(struct crypto_lskcipher *tfm, const u8 *src,
-			     u8 *dst, unsigned nbytes, u8 *iv, u32 flags)
+			     u8 *dst, unsigned nbytes, u8 *siv, u32 flags)
 {
 	struct arc4_ctx *ctx = crypto_lskcipher_ctx(tfm);
 
+	if (!(flags & CRYPTO_LSKCIPHER_FLAG_CONT))
+		memcpy(siv, ctx, sizeof(*ctx));
+
+	ctx = (struct arc4_ctx *)siv;
+
 	arc4_crypt(ctx, dst, src, nbytes);
 	return 0;
 }
@@ -48,6 +53,7 @@ static struct lskcipher_alg arc4_alg = {
 	.co.base.cra_module		=	THIS_MODULE,
 	.co.min_keysize			=	ARC4_MIN_KEY_SIZE,
 	.co.max_keysize			=	ARC4_MAX_KEY_SIZE,
+	.co.statesize			=	sizeof(struct arc4_ctx),
 	.setkey				=	crypto_arc4_setkey,
 	.encrypt			=	crypto_arc4_crypt,
 	.decrypt			=	crypto_arc4_crypt,
