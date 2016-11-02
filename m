From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] poly1305: generic C can be faster on chips with slow unaligned access
Date: Wed,  2 Nov 2016 18:58:10 +0100
Message-ID: <20161102175810.18647-1-Jason@zx2c4.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Willi <martin@strongswan.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On MIPS chips commonly found in inexpensive routers, this makes a big
difference in performance.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 crypto/poly1305_generic.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/crypto/poly1305_generic.c b/crypto/poly1305_generic.c
index 2df9835d..186e33d 100644
--- a/crypto/poly1305_generic.c
+++ b/crypto/poly1305_generic.c
@@ -65,11 +65,24 @@ EXPORT_SYMBOL_GPL(crypto_poly1305_setkey);
 static void poly1305_setrkey(struct poly1305_desc_ctx *dctx, const u8 *key)
 {
 	/* r &= 0xffffffc0ffffffc0ffffffc0fffffff */
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	dctx->r[0] = (le32_to_cpuvp(key +  0) >> 0) & 0x3ffffff;
 	dctx->r[1] = (le32_to_cpuvp(key +  3) >> 2) & 0x3ffff03;
 	dctx->r[2] = (le32_to_cpuvp(key +  6) >> 4) & 0x3ffc0ff;
 	dctx->r[3] = (le32_to_cpuvp(key +  9) >> 6) & 0x3f03fff;
 	dctx->r[4] = (le32_to_cpuvp(key + 12) >> 8) & 0x00fffff;
+#else
+	u32 t0, t1, t2, t3;
+	t0 = le32_to_cpuvp(key +  0);
+	t1 = le32_to_cpuvp(key +  4);
+	t2 = le32_to_cpuvp(key +  8);
+	t3 = le32_to_cpuvp(key + 12);
+	dctx->r[0] = t0 & 0x3ffffff; t0 >>= 26; t0 |= t1 << 6;
+	dctx->r[1] = t0 & 0x3ffff03; t1 >>= 20; t1 |= t2 << 12;
+	dctx->r[2] = t1 & 0x3ffc0ff; t2 >>= 14; t2 |= t3 << 18;
+	dctx->r[3] = t2 & 0x3f03fff; t3 >>= 8;
+	dctx->r[4] = t3 & 0x00fffff;
+#endif
 }
 
 static void poly1305_setskey(struct poly1305_desc_ctx *dctx, const u8 *key)
@@ -109,6 +122,9 @@ static unsigned int poly1305_blocks(struct poly1305_desc_ctx *dctx,
 	u32 s1, s2, s3, s4;
 	u32 h0, h1, h2, h3, h4;
 	u64 d0, d1, d2, d3, d4;
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	u32 t0, t1, t2, t3;
+#endif
 	unsigned int datalen;
 
 	if (unlikely(!dctx->sset)) {
@@ -135,13 +151,24 @@ static unsigned int poly1305_blocks(struct poly1305_desc_ctx *dctx,
 	h4 = dctx->h[4];
 
 	while (likely(srclen >= POLY1305_BLOCK_SIZE)) {
-
 		/* h += m[i] */
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 		h0 += (le32_to_cpuvp(src +  0) >> 0) & 0x3ffffff;
 		h1 += (le32_to_cpuvp(src +  3) >> 2) & 0x3ffffff;
 		h2 += (le32_to_cpuvp(src +  6) >> 4) & 0x3ffffff;
 		h3 += (le32_to_cpuvp(src +  9) >> 6) & 0x3ffffff;
 		h4 += (le32_to_cpuvp(src + 12) >> 8) | hibit;
+#else
+		t0 = le32_to_cpuvp(src +  0);
+		t1 = le32_to_cpuvp(src +  4);
+		t2 = le32_to_cpuvp(src +  8);
+		t3 = le32_to_cpuvp(src + 12);
+		h0 += t0 & 0x3ffffff;
+		h1 += sr((((u64)t1 << 32) | t0), 26) & 0x3ffffff;
+		h2 += sr((((u64)t2 << 32) | t1), 20) & 0x3ffffff;
+		h3 += sr((((u64)t3 << 32) | t2), 14) & 0x3ffffff;
+		h4 += (t3 >> 8) | hibit;
+#endif
 
 		/* h *= r */
 		d0 = mlt(h0, r0) + mlt(h1, s4) + mlt(h2, s3) +
-- 
2.10.2
