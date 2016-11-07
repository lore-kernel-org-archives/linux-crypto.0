From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v2] poly1305: generic C can be faster on chips with slow unaligned access
Date: Mon,  7 Nov 2016 20:12:53 +0100
Message-ID: <20161107191253.17998-1-Jason@zx2c4.com>
References: <20161102175810.18647-1-Jason@zx2c4.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Willi <martin@strongswan.org>,
        Eric Biggers <ebiggers@google.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161102175810.18647-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

By using the unaligned access helpers, we drastically improve
performance on small MIPS routers that have to go through the exception
fix-up handler for these unaligned accesses.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 crypto/poly1305_generic.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index 2df9835d..0b86f4e 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -66,9 +66,9 @@ static void poly1305_setrkey(struct poly1305_desc_ctx *dctx, const u8 *key)
 {
 	/* r &= 0xffffffc0ffffffc0ffffffc0fffffff */
 	dctx->r[0] = (le32_to_cpuvp(key +  0) >> 0) & 0x3ffffff;
-	dctx->r[1] = (le32_to_cpuvp(key +  3) >> 2) & 0x3ffff03;
-	dctx->r[2] = (le32_to_cpuvp(key +  6) >> 4) & 0x3ffc0ff;
-	dctx->r[3] = (le32_to_cpuvp(key +  9) >> 6) & 0x3f03fff;
+	dctx->r[1] = (get_unaligned_le32(key +  3) >> 2) & 0x3ffff03;
+	dctx->r[2] = (get_unaligned_le32(key +  6) >> 4) & 0x3ffc0ff;
+	dctx->r[3] = (get_unaligned_le32(key +  9) >> 6) & 0x3f03fff;
 	dctx->r[4] = (le32_to_cpuvp(key + 12) >> 8) & 0x00fffff;
 }
 
@@ -138,9 +138,9 @@ static unsigned int poly1305_blocks(struct poly1305_desc_ctx *dctx,
 
 		/* h += m[i] */
 		h0 += (le32_to_cpuvp(src +  0) >> 0) & 0x3ffffff;
-		h1 += (le32_to_cpuvp(src +  3) >> 2) & 0x3ffffff;
-		h2 += (le32_to_cpuvp(src +  6) >> 4) & 0x3ffffff;
-		h3 += (le32_to_cpuvp(src +  9) >> 6) & 0x3ffffff;
+		h1 += (get_unaligned_le32(src +  3) >> 2) & 0x3ffffff;
+		h2 += (get_unaligned_le32(src +  6) >> 4) & 0x3ffffff;
+		h3 += (get_unaligned_le32(src +  9) >> 6) & 0x3ffffff;
 		h4 += (le32_to_cpuvp(src + 12) >> 8) | hibit;
 
 		/* h *= r */
-- 
2.10.2
