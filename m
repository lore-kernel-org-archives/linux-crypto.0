From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: use chunks smaller than algo block size in chunk tests
Date: Sun, 27 Jul 2014 19:18:50 +0200
Message-ID: <1406481530-21035-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-crypto@vger.kernel.org, mpatocka@redhat.com,
	catalin.marinas@arm.com, linux@arm.linux.org.uk,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:53124 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbaG0RTB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 27 Jul 2014 13:19:01 -0400
Received: by mail-wg0-f46.google.com with SMTP id m15so6338520wgh.29
        for <linux-crypto@vger.kernel.org>; Sun, 27 Jul 2014 10:19:00 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch updates many of the chunked tcrypt test cases so that not all of the
chunks are an exact multiple of the block size. This should help uncover cases
where the residue passed to blkcipher_walk_done() is incorrect.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

Herbert,

After this change, the ARM and arm64 bugs regarding blkcipher_walk_done() are
identified by tcrypt mode=10

Regards,
Ard.


 crypto/testmgr.h | 264 +++++++++++++++++++++++++++----------------------------
 1 file changed, 132 insertions(+), 132 deletions(-)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 69d0dd8ef27e..63ca0776cfca 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -3097,8 +3097,8 @@ static struct cipher_testvec des_enc_tv_template[] = {
 			  "\x5F\x62\xC7\x72\xD9\xFC\xCB\x9A",
 		.rlen	= 248,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 248 - 8, 8 },
+		.np	= 3,
+		.tap	= { 248 - 10, 2, 8 },
 	},
 };
 
@@ -3207,8 +3207,8 @@ static struct cipher_testvec des_dec_tv_template[] = {
 			  "\xC6\x2F\xBB\x24\x8D\x19\x82\xEB",
 		.rlen	= 248,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 248 - 8, 8 },
+		.np	= 3,
+		.tap	= { 248 - 10, 2, 8 },
 	},
 };
 
@@ -3333,8 +3333,8 @@ static struct cipher_testvec des_cbc_enc_tv_template[] = {
 			  "\xC6\x4A\xF3\x55\xC7\x29\x2E\x63",
 		.rlen	= 248,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 248 - 8, 8 },
+		.np	= 3,
+		.tap	= { 248 - 10, 2, 8 },
 	},
 };
 
@@ -3442,8 +3442,8 @@ static struct cipher_testvec des_cbc_dec_tv_template[] = {
 			  "\xC6\x2F\xBB\x24\x8D\x19\x82\xEB",
 		.rlen	= 248,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 248 - 8, 8 },
+		.np	= 3,
+		.tap	= { 248 - 10, 2, 8 },
 	},
 };
 
@@ -3517,8 +3517,8 @@ static struct cipher_testvec des_ctr_enc_tv_template[] = {
 			  "\x69\x74\xA1\x06\x46\x0F\x4E\x75",
 		.rlen	= 248,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 248 - 8, 8 },
+		.np	= 3,
+		.tap	= { 248 - 10, 2, 8 },
 	}, { /* Generated with Crypto++ */
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55",
 		.klen	= 8,
@@ -3663,8 +3663,8 @@ static struct cipher_testvec des_ctr_dec_tv_template[] = {
 			  "\xC6\x2F\xBB\x24\x8D\x19\x82\xEB",
 		.rlen	= 248,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 248 - 8, 8 },
+		.np	= 3,
+		.tap	= { 248 - 10, 2, 8 },
 	}, { /* Generated with Crypto++ */
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55",
 		.klen	= 8,
@@ -3899,8 +3899,8 @@ static struct cipher_testvec des3_ede_enc_tv_template[] = {
 			  "\xD8\x45\xFF\x33\xBA\xBB\x2B\x63",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -4064,8 +4064,8 @@ static struct cipher_testvec des3_ede_dec_tv_template[] = {
 			  "\xB8\x03\xEA\x7D\xE1\x48\xD3\x47",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -4244,8 +4244,8 @@ static struct cipher_testvec des3_ede_cbc_enc_tv_template[] = {
 			  "\x95\x63\x73\xA2\x44\xAC\xF8\xA5",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -4424,8 +4424,8 @@ static struct cipher_testvec des3_ede_cbc_dec_tv_template[] = {
 			  "\xB8\x03\xEA\x7D\xE1\x48\xD3\x47",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -4564,8 +4564,8 @@ static struct cipher_testvec des3_ede_ctr_enc_tv_template[] = {
 			  "\x5C\xEE\xFC\xCF\xC4\x70\x00\x34",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	}, { /* Generated with Crypto++ */
 		.key	= "\x9C\xD6\xF3\x9C\xB9\x5A\x67\x00"
 			  "\x5A\x67\x00\x2D\xCE\xEB\x2D\xCE"
@@ -4842,8 +4842,8 @@ static struct cipher_testvec des3_ede_ctr_dec_tv_template[] = {
 			  "\xB8\x03\xEA\x7D\xE1\x48\xD3\x47",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	}, { /* Generated with Crypto++ */
 		.key	= "\x9C\xD6\xF3\x9C\xB9\x5A\x67\x00"
 			  "\x5A\x67\x00\x2D\xCE\xEB\x2D\xCE"
@@ -5182,8 +5182,8 @@ static struct cipher_testvec bf_enc_tv_template[] = {
 			  "\xC9\x1A\xFB\x5D\xDE\xBB\x43\xF4",
 		.rlen	= 504,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 504 - 8, 8 },
+		.np	= 3,
+		.tap	= { 504 - 10, 2, 8 },
 	},
 };
 
@@ -5374,8 +5374,8 @@ static struct cipher_testvec bf_dec_tv_template[] = {
 			  "\x2B\xC2\x59\xF0\x64\xFB\x92\x06",
 		.rlen	= 504,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 504 - 8, 8 },
+		.np	= 3,
+		.tap	= { 504 - 10, 2, 8 },
 	},
 };
 
@@ -5531,8 +5531,8 @@ static struct cipher_testvec bf_cbc_enc_tv_template[] = {
 			  "\xB4\x98\xD8\x6B\x74\xE7\x65\xF4",
 		.rlen	= 504,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 504 - 8, 8 },
+		.np	= 3,
+		.tap	= { 504 - 10, 2, 8 },
 	},
 };
 
@@ -5688,8 +5688,8 @@ static struct cipher_testvec bf_cbc_dec_tv_template[] = {
 			  "\x2B\xC2\x59\xF0\x64\xFB\x92\x06",
 		.rlen	= 504,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 504 - 8, 8 },
+		.np	= 3,
+		.tap	= { 504 - 10, 2, 8 },
 	},
 };
 
@@ -6694,8 +6694,8 @@ static struct cipher_testvec tf_enc_tv_template[] = {
 			  "\x2C\x75\x64\xC4\xCA\xC1\x7E\xD5",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -6862,8 +6862,8 @@ static struct cipher_testvec tf_dec_tv_template[] = {
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -7045,8 +7045,8 @@ static struct cipher_testvec tf_cbc_enc_tv_template[] = {
 			  "\x0A\xA3\x30\x10\x26\x25\x41\x2C",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -7228,8 +7228,8 @@ static struct cipher_testvec tf_cbc_dec_tv_template[] = {
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -8302,8 +8302,8 @@ static struct cipher_testvec tf_lrw_enc_tv_template[] = {
 			  "\x11\xd7\xb8\x6e\xea\xe1\x80\x30",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -8555,8 +8555,8 @@ static struct cipher_testvec tf_lrw_dec_tv_template[] = {
 			  "\x21\xc4\xc2\x75\x67\x89\x37\x0a",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -8897,8 +8897,8 @@ static struct cipher_testvec tf_xts_enc_tv_template[] = {
 			  "\x37\x30\xe1\x91\x8d\xb3\x2a\xff",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -9240,8 +9240,8 @@ static struct cipher_testvec tf_xts_dec_tv_template[] = {
 			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -9438,8 +9438,8 @@ static struct cipher_testvec serpent_enc_tv_template[] = {
 			  "\xF4\x46\x2E\xEB\xAC\xF3\xD2\xB7",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -9664,8 +9664,8 @@ static struct cipher_testvec serpent_dec_tv_template[] = {
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -9846,8 +9846,8 @@ static struct cipher_testvec serpent_cbc_enc_tv_template[] = {
 			  "\xBC\x08\x3A\xA2\x29\xB3\xDF\xD1",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -9987,8 +9987,8 @@ static struct cipher_testvec serpent_cbc_dec_tv_template[] = {
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -11061,8 +11061,8 @@ static struct cipher_testvec serpent_lrw_enc_tv_template[] = {
 			  "\xd9\x51\x0f\xd7\x94\x2f\xc5\xa7",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -11314,8 +11314,8 @@ static struct cipher_testvec serpent_lrw_dec_tv_template[] = {
 			  "\x21\xc4\xc2\x75\x67\x89\x37\x0a",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -11656,8 +11656,8 @@ static struct cipher_testvec serpent_xts_enc_tv_template[] = {
 			  "\xd4\xa0\x91\x98\x11\x5f\x4d\xb1",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -11999,8 +11999,8 @@ static struct cipher_testvec serpent_xts_dec_tv_template[] = {
 			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -12182,8 +12182,8 @@ static struct cipher_testvec cast6_enc_tv_template[] = {
 			  "\x11\x74\x93\x57\xB4\x7E\xC6\x00",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -12353,8 +12353,8 @@ static struct cipher_testvec cast6_dec_tv_template[] = {
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -12494,8 +12494,8 @@ static struct cipher_testvec cast6_cbc_enc_tv_template[] = {
 			  "\x22\x46\x89\x2D\x0F\x2B\x08\x24",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -12635,8 +12635,8 @@ static struct cipher_testvec cast6_cbc_dec_tv_template[] = {
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -12792,8 +12792,8 @@ static struct cipher_testvec cast6_ctr_enc_tv_template[] = {
 			  "\xF9\xC5\xDD\x27\xB3\x39\xCB\xCB",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -12949,8 +12949,8 @@ static struct cipher_testvec cast6_ctr_dec_tv_template[] = {
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -13096,8 +13096,8 @@ static struct cipher_testvec cast6_lrw_enc_tv_template[] = {
 			  "\xC4\xF5\x99\x61\xBC\xBB\x5B\x46",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -13243,8 +13243,8 @@ static struct cipher_testvec cast6_lrw_dec_tv_template[] = {
 			  "\x21\xc4\xc2\x75\x67\x89\x37\x0a",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -13392,8 +13392,8 @@ static struct cipher_testvec cast6_xts_enc_tv_template[] = {
 			  "\x22\x60\x4E\xE8\xA4\x5D\x85\xB9",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -13541,8 +13541,8 @@ static struct cipher_testvec cast6_xts_dec_tv_template[] = {
 			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -13749,8 +13749,8 @@ static struct cipher_testvec aes_enc_tv_template[] = {
 			  "\x17\xBB\xC0\x6B\x62\x3F\x56\xE9",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -13921,8 +13921,8 @@ static struct cipher_testvec aes_dec_tv_template[] = {
 			  "\xED\x56\xBF\x28\xB4\x1D\x86\x12",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -14140,8 +14140,8 @@ static struct cipher_testvec aes_cbc_enc_tv_template[] = {
 			  "\xA3\xAA\x13\xCC\x50\xFF\x7B\x02",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -14359,8 +14359,8 @@ static struct cipher_testvec aes_cbc_dec_tv_template[] = {
 			  "\xED\x56\xBF\x28\xB4\x1D\x86\x12",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -16265,8 +16265,8 @@ static struct cipher_testvec aes_lrw_enc_tv_template[] = {
 			  "\x74\x3f\x7d\x58\x88\x75\xde\x3e",
 		.rlen   = 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	}
 };
 
@@ -16519,8 +16519,8 @@ static struct cipher_testvec aes_lrw_dec_tv_template[] = {
 			  "\x21\xc4\xc2\x75\x67\x89\x37\x0a",
 		.rlen   = 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	}
 };
 
@@ -16861,8 +16861,8 @@ static struct cipher_testvec aes_xts_enc_tv_template[] = {
 			  "\xb9\xc6\xe6\x93\xe1\x48\xc1\x51",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	}
 };
 
@@ -17203,8 +17203,8 @@ static struct cipher_testvec aes_xts_dec_tv_template[] = {
 			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	}
 };
 
@@ -17420,8 +17420,8 @@ static struct cipher_testvec aes_ctr_enc_tv_template[] = {
 			  "\xF1\x4C\xE5\xB2\x91\x64\x0C\x51",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	}, { /* Generated with Crypto++ */
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55"
 			  "\x0F\x32\x55\x78\x9B\xBE\x78\x9B"
@@ -17775,8 +17775,8 @@ static struct cipher_testvec aes_ctr_dec_tv_template[] = {
 			  "\xED\x56\xBF\x28\xB4\x1D\x86\x12",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	}, { /* Generated with Crypto++ */
 		.key	= "\xC9\x83\xA6\xC9\xEC\x0F\x32\x55"
 			  "\x0F\x32\x55\x78\x9B\xBE\x78\x9B"
@@ -20907,8 +20907,8 @@ static struct cipher_testvec cast5_enc_tv_template[] = {
 			  "\xF5\xBC\x25\xD6\x02\x56\x57\x1C",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -21068,8 +21068,8 @@ static struct cipher_testvec cast5_dec_tv_template[] = {
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -21206,8 +21206,8 @@ static struct cipher_testvec cast5_cbc_enc_tv_template[] = {
 			  "\x1D\x18\x66\x44\x5B\x8F\x14\xEB",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -21344,8 +21344,8 @@ static struct cipher_testvec cast5_cbc_dec_tv_template[] = {
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -21495,8 +21495,8 @@ static struct cipher_testvec cast5_ctr_enc_tv_template[] = {
 			  "\xC0\x0D\x96\xAA\x23\xF8\xFE\x13",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -21646,8 +21646,8 @@ static struct cipher_testvec cast5_ctr_dec_tv_template[] = {
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 496 - 16, 16 },
+		.np	= 3,
+		.tap	= { 496 - 20, 4, 16 },
 	},
 };
 
@@ -22805,8 +22805,8 @@ static struct cipher_testvec camellia_enc_tv_template[] = {
 			  "\x33\x1A\xBB\xD3\xA2\x7E\x97\x66",
 		.rlen	= 1008,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 1008 - 16, 16 },
+		.np	= 3,
+		.tap	= { 1008 - 20, 4, 16 },
 	},
 };
 
@@ -23105,8 +23105,8 @@ static struct cipher_testvec camellia_dec_tv_template[] = {
 			  "\x72\x09\xA0\x14\xAB\x42\xD9\x4D",
 		.rlen	= 1008,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 1008 - 16, 16 },
+		.np	= 3,
+		.tap	= { 1008 - 20, 4, 16 },
 	},
 };
 
@@ -23401,8 +23401,8 @@ static struct cipher_testvec camellia_cbc_enc_tv_template[] = {
 			  "\x70\xC5\xB9\x0B\x3B\x7A\x6E\x6C",
 		.rlen	= 1008,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 1008 - 16, 16 },
+		.np	= 3,
+		.tap	= { 1008 - 20, 4, 16 },
 	},
 };
 
@@ -23697,8 +23697,8 @@ static struct cipher_testvec camellia_cbc_dec_tv_template[] = {
 			  "\x72\x09\xA0\x14\xAB\x42\xD9\x4D",
 		.rlen	= 1008,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 1008 - 16, 16 },
+		.np	= 3,
+		.tap	= { 1008 - 20, 4, 16 },
 	},
 };
 
@@ -25283,8 +25283,8 @@ static struct cipher_testvec camellia_lrw_enc_tv_template[] = {
 			  "\x5a\xa8\x92\x7f\xba\xe6\x0c\x95",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -25536,8 +25536,8 @@ static struct cipher_testvec camellia_lrw_dec_tv_template[] = {
 			  "\x21\xc4\xc2\x75\x67\x89\x37\x0a",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -25878,8 +25878,8 @@ static struct cipher_testvec camellia_xts_enc_tv_template[] = {
 			  "\xd5\xc6\x99\xcc\x4e\x6c\x94\x95",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
@@ -26221,8 +26221,8 @@ static struct cipher_testvec camellia_xts_dec_tv_template[] = {
 			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
 		.rlen	= 512,
 		.also_non_np = 1,
-		.np	= 2,
-		.tap	= { 512 - 16, 16 },
+		.np	= 3,
+		.tap	= { 512 - 20, 4, 16 },
 	},
 };
 
-- 
1.8.3.2
