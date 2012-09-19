From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/3] crypto: testmgr - allow non-multi page and multi page
 skcipher tests from same test template
Date: Wed, 19 Sep 2012 09:42:49 +0300
Message-ID: <20120919064249.10607.45593.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:33724 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab2ISGnA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2012 02:43:00 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Allow non-multi page and multi page skcipher tests to be run on same test template, to avoid
duplicating data.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/testmgr.c |    2 -
 crypto/testmgr.h |  170 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 575b57c..8183777 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -804,7 +804,7 @@ static int test_skcipher(struct crypto_ablkcipher *tfm, int enc,
 		else
 			memset(iv, 0, MAX_IVLEN);
 
-		if (!(template[i].np)) {
+		if (!(template[i].np) || (template[i].also_non_np)) {
 			j++;
 
 			ret = -EINVAL;
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 6eb3ef5..70984f5 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -53,6 +53,7 @@ struct cipher_testvec {
 	char *result;
 	unsigned short tap[MAX_TAP];
 	int np;
+	unsigned char also_non_np;
 	unsigned char fail;
 	unsigned char wk; /* weak key flag */
 	unsigned char klen;
@@ -2468,6 +2469,9 @@ static struct cipher_testvec bf_enc_tv_template[] = {
 			  "\xC2\xF4\x6D\xFF\xF6\xCD\x6B\x40"
 			  "\xE1\xB3\xBF\xD4\x38\x2B\xC8\x3B",
 		.rlen	= 40,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 40 - 8, 8 },
 	},
 };
 
@@ -2541,6 +2545,9 @@ static struct cipher_testvec bf_dec_tv_template[] = {
 			  "\xAC\x20\xB7\x4E\xE5\x59\xF0\x87"
 			  "\x1E\x92\x29\xC0\x34\xCB\x62\xF9",
 		.rlen	= 40,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 40 - 8, 8 },
 	},
 };
 
@@ -2579,6 +2586,9 @@ static struct cipher_testvec bf_cbc_enc_tv_template[] = {
 			  "\x1B\xD9\x02\xB6\x48\xB0\x87\x25"
 			  "\x01\x9C\x93\x63\x51\x60\x82\xD2",
 		.rlen	= 40,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 40 - 8, 8 },
 	},
 };
 
@@ -2617,6 +2627,9 @@ static struct cipher_testvec bf_cbc_dec_tv_template[] = {
 			  "\xAC\x20\xB7\x4E\xE5\x59\xF0\x87"
 			  "\x1E\x92\x29\xC0\x34\xCB\x62\xF9",
 		.rlen	= 40,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 40 - 8, 8 },
 	},
 };
 
@@ -2661,6 +2674,9 @@ static struct cipher_testvec bf_ctr_enc_tv_template[] = {
 			  "\xE4\x1F\x5E\xA5\x89\xAC\x32\xBC"
 			  "\x3D\xA7\xE9",
 		.rlen	= 43,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 43 - 8, 8 },
 	},
 };
 
@@ -2705,6 +2721,9 @@ static struct cipher_testvec bf_ctr_dec_tv_template[] = {
 			  "\x1E\x92\x29\xC0\x34\xCB\x62\xF9"
 			  "\x6D\x04\x9B",
 		.rlen	= 43,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 43 - 8, 8 },
 	},
 };
 
@@ -2884,6 +2903,9 @@ static struct cipher_testvec tf_enc_tv_template[] = {
 			  "\x58\x33\x9B\x78\xC7\x58\x48\x6B"
 			  "\x2C\x75\x64\xC4\xCA\xC1\x7E\xD5",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -3049,6 +3071,9 @@ static struct cipher_testvec tf_dec_tv_template[] = {
 			  "\x6A\x01\x75\x0C\xA3\x17\xAE\x45"
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -3229,6 +3254,9 @@ static struct cipher_testvec tf_cbc_enc_tv_template[] = {
 			  "\x30\x70\x56\xA4\x37\xDD\x7C\xC0"
 			  "\x0A\xA3\x30\x10\x26\x25\x41\x2C",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -3409,6 +3437,9 @@ static struct cipher_testvec tf_cbc_dec_tv_template[] = {
 			  "\x6A\x01\x75\x0C\xA3\x17\xAE\x45"
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -3683,6 +3714,9 @@ static struct cipher_testvec tf_ctr_enc_tv_template[] = {
 			  "\xC5\xC9\x7F\x9E\xCF\x33\x7A\xDF"
 			  "\x6C\x82\x9D",
 		.rlen	= 499,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 499 - 16, 16 },
 	},
 };
 
@@ -3957,6 +3991,9 @@ static struct cipher_testvec tf_ctr_dec_tv_template[] = {
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7"
 			  "\x2B\xC2\x59",
 		.rlen	= 499,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 499 - 16, 16 },
 	},
 };
 
@@ -4206,6 +4243,9 @@ static struct cipher_testvec tf_lrw_enc_tv_template[] = {
 			  "\x80\x18\xc4\x6c\x03\xd3\xb7\xba"
 			  "\x11\xd7\xb8\x6e\xea\xe1\x80\x30",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -4456,6 +4496,9 @@ static struct cipher_testvec tf_lrw_dec_tv_template[] = {
 			  "\xe9\x2e\xc4\x29\x0f\x84\xdb\xc4"
 			  "\x21\xc4\xc2\x75\x67\x89\x37\x0a",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -4795,6 +4838,9 @@ static struct cipher_testvec tf_xts_enc_tv_template[] = {
 			  "\xa4\x05\x0b\xb2\xb3\xa8\x30\x97"
 			  "\x37\x30\xe1\x91\x8d\xb3\x2a\xff",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -5135,6 +5181,9 @@ static struct cipher_testvec tf_xts_dec_tv_template[] = {
 			  "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
 			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -5242,6 +5291,9 @@ static struct cipher_testvec serpent_enc_tv_template[] = {
 			  "\x30\xD4\x2C\xF2\x8E\x06\x4B\x39"
 			  "\xB3\x12\x1D\xB3\x17\x46\xE6\xD6",
 		.rlen	= 144,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 144 - 16, 16 },
 	},
 };
 
@@ -5377,6 +5429,9 @@ static struct cipher_testvec serpent_dec_tv_template[] = {
 			  "\x0D\xA4\x18\xAF\x46\xDD\x51\xE8"
 			  "\x7F\x16\x8A\x21\xB8\x2C\xC3\x5A",
 		.rlen	= 144,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 144 - 16, 16 },
 	},
 };
 
@@ -5468,6 +5523,9 @@ static struct cipher_testvec serpent_cbc_enc_tv_template[] = {
 			  "\x27\xDF\x89\x1D\x86\x3E\xF7\x5A"
 			  "\xF6\xE3\x0F\xC7\x6B\x4C\x96\x7C",
 		.rlen	= 144,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 144 - 16, 16 },
 	},
 };
 
@@ -5518,6 +5576,9 @@ static struct cipher_testvec serpent_cbc_dec_tv_template[] = {
 			  "\x0D\xA4\x18\xAF\x46\xDD\x51\xE8"
 			  "\x7F\x16\x8A\x21\xB8\x2C\xC3\x5A",
 		.rlen	= 144,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 144 - 16, 16 },
 	},
 };
 
@@ -5616,6 +5677,9 @@ static struct cipher_testvec serpent_ctr_enc_tv_template[] = {
 			  "\x5D\xE1\x4F\xA1\xEA\xB3\xCA\xB9"
 			  "\xE6\xD0\x97",
 		.rlen	= 147,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 147 - 16, 16 },
 	},
 };
 
@@ -5714,6 +5778,9 @@ static struct cipher_testvec serpent_ctr_dec_tv_template[] = {
 			  "\x7F\x16\x8A\x21\xB8\x2C\xC3\x5A"
 			  "\xF1\x65\xFC",
 		.rlen	= 147,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 147 - 16, 16 },
 	},
 };
 
@@ -5963,6 +6030,9 @@ static struct cipher_testvec serpent_lrw_enc_tv_template[] = {
 			  "\x5c\xc6\x84\xfe\x7c\xcb\x26\xfd"
 			  "\xd9\x51\x0f\xd7\x94\x2f\xc5\xa7",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -6213,6 +6283,9 @@ static struct cipher_testvec serpent_lrw_dec_tv_template[] = {
 			  "\xe9\x2e\xc4\x29\x0f\x84\xdb\xc4"
 			  "\x21\xc4\xc2\x75\x67\x89\x37\x0a",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -6552,6 +6625,9 @@ static struct cipher_testvec serpent_xts_enc_tv_template[] = {
 			  "\xaf\x43\x0b\xc5\x20\x41\x92\x20"
 			  "\xd4\xa0\x91\x98\x11\x5f\x4d\xb1",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -6892,6 +6968,9 @@ static struct cipher_testvec serpent_xts_dec_tv_template[] = {
 			  "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
 			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -7072,6 +7151,9 @@ static struct cipher_testvec cast6_enc_tv_template[] = {
 			  "\x84\x52\x6D\x68\xDE\xC6\x64\xB2"
 			  "\x11\x74\x93\x57\xB4\x7E\xC6\x00",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -7240,6 +7322,9 @@ static struct cipher_testvec cast6_dec_tv_template[] = {
 			  "\x6A\x01\x75\x0C\xA3\x17\xAE\x45"
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -7378,6 +7463,9 @@ static struct cipher_testvec cast6_cbc_enc_tv_template[] = {
 			  "\x4D\x59\x7D\xC5\x28\x69\xFA\x92"
 			  "\x22\x46\x89\x2D\x0F\x2B\x08\x24",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -7516,6 +7604,9 @@ static struct cipher_testvec cast6_cbc_dec_tv_template[] = {
 			  "\x6A\x01\x75\x0C\xA3\x17\xAE\x45"
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -7654,6 +7745,9 @@ static struct cipher_testvec cast6_ctr_enc_tv_template[] = {
 			  "\x0E\x74\x33\x30\x62\xB9\x89\xDF"
 			  "\xF9\xC5\xDD\x27\xB3\x39\xCB\xCB",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -7792,6 +7886,9 @@ static struct cipher_testvec cast6_ctr_dec_tv_template[] = {
 			  "\x6A\x01\x75\x0C\xA3\x17\xAE\x45"
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -7936,6 +8033,9 @@ static struct cipher_testvec cast6_lrw_enc_tv_template[] = {
 			  "\x8D\xD9\xCD\x3B\x22\x67\x18\xC7"
 			  "\xC4\xF5\x99\x61\xBC\xBB\x5B\x46",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -8080,6 +8180,9 @@ static struct cipher_testvec cast6_lrw_dec_tv_template[] = {
 			  "\xe9\x2e\xc4\x29\x0f\x84\xdb\xc4"
 			  "\x21\xc4\xc2\x75\x67\x89\x37\x0a",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -8226,6 +8329,9 @@ static struct cipher_testvec cast6_xts_enc_tv_template[] = {
 			  "\xA1\xAC\xE8\xCF\xC6\x74\xCF\xDC"
 			  "\x22\x60\x4E\xE8\xA4\x5D\x85\xB9",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -8372,6 +8478,9 @@ static struct cipher_testvec cast6_xts_dec_tv_template[] = {
 			  "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
 			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -9721,6 +9830,9 @@ static struct cipher_testvec aes_lrw_enc_tv_template[] = {
 			  "\xcd\x7e\x2b\x5d\x43\xea\x42\xe7"
 			  "\x74\x3f\x7d\x58\x88\x75\xde\x3e",
 		.rlen   = 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	}
 };
 
@@ -9972,6 +10084,9 @@ static struct cipher_testvec aes_lrw_dec_tv_template[] = {
 			  "\xe9\x2e\xc4\x29\x0f\x84\xdb\xc4"
 			  "\x21\xc4\xc2\x75\x67\x89\x37\x0a",
 		.rlen   = 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	}
 };
 
@@ -10313,6 +10428,9 @@ static struct cipher_testvec aes_xts_enc_tv_template[] = {
 			  "\xc4\xf3\x6f\xfd\xa9\xfc\xea\x70"
 			  "\xb9\xc6\xe6\x93\xe1\x48\xc1\x51",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	}
 };
 
@@ -10654,7 +10772,9 @@ static struct cipher_testvec aes_xts_dec_tv_template[] = {
 			  "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
 			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
 		.rlen	= 512,
-
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	}
 };
 
@@ -13695,6 +13815,9 @@ static struct cipher_testvec cast5_enc_tv_template[] = {
 			  "\x4F\xFE\x24\x9C\x9A\x02\xE5\x57"
 			  "\xF5\xBC\x25\xD6\x02\x56\x57\x1C",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -13853,6 +13976,9 @@ static struct cipher_testvec cast5_dec_tv_template[] = {
 			  "\x6A\x01\x75\x0C\xA3\x17\xAE\x45"
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -13988,6 +14114,9 @@ static struct cipher_testvec cast5_cbc_enc_tv_template[] = {
 			  "\x15\x5F\xDB\xE9\xB1\x83\xD2\xE6"
 			  "\x1D\x18\x66\x44\x5B\x8F\x14\xEB",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -14123,6 +14252,9 @@ static struct cipher_testvec cast5_cbc_dec_tv_template[] = {
 			  "\x6A\x01\x75\x0C\xA3\x17\xAE\x45"
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -14258,6 +14390,9 @@ static struct cipher_testvec cast5_ctr_enc_tv_template[] = {
 			  "\x8C\x98\xDB\xDE\xFC\x72\x94\xAA"
 			  "\xC0\x0D\x96\xAA\x23\xF8\xFE\x13",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -14393,6 +14528,9 @@ static struct cipher_testvec cast5_ctr_dec_tv_template[] = {
 			  "\x6A\x01\x75\x0C\xA3\x17\xAE\x45"
 			  "\xDC\x50\xE7\x7E\x15\x89\x20\xB7",
 		.rlen	= 496,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 496 - 16, 16 },
 	},
 };
 
@@ -15310,6 +15448,9 @@ static struct cipher_testvec camellia_enc_tv_template[] = {
 			  "\x0D\xD0\xFD\xC4\x65\xA5\x69\xB9"
 			  "\xF1\xF6\xB1\xA5\xB2\x75\x4F\x8A",
 		.rlen	= 48,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 48 - 16, 16 },
 	},
 };
 
@@ -15368,6 +15509,9 @@ static struct cipher_testvec camellia_dec_tv_template[] = {
 			  "\x1E\x92\x29\xC0\x34\xCB\x62\xF9"
 			  "\x6D\x04\x9B\x0F\xA6\x3D\xD4\x48",
 		.rlen	= 48,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 48 - 16, 16 },
 	},
 };
 
@@ -15422,6 +15566,9 @@ static struct cipher_testvec camellia_cbc_enc_tv_template[] = {
 			  "\xB9\xF9\xC2\x27\x6A\xB6\x31\x27"
 			  "\xA6\xAD\xEF\xE5\x5D\xE4\x02\x01",
 		.rlen	= 48,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 48 - 16, 16 },
 	},
 };
 
@@ -15476,6 +15623,9 @@ static struct cipher_testvec camellia_cbc_dec_tv_template[] = {
 			  "\x1E\x92\x29\xC0\x34\xCB\x62\xF9"
 			  "\x6D\x04\x9B\x0F\xA6\x3D\xD4\x48",
 		.rlen	= 48,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 48 - 16, 16 },
 	},
 };
 
@@ -15527,6 +15677,9 @@ static struct cipher_testvec camellia_ctr_enc_tv_template[] = {
 			  "\x60\xFC\xE8\x94\xE8\xB5\x09\x2C"
 			  "\x1E\x43\xEF",
 		.rlen	= 51,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 51 - 16, 16 },
 	},
 };
 
@@ -15578,6 +15731,9 @@ static struct cipher_testvec camellia_ctr_dec_tv_template[] = {
 			  "\x6D\x04\x9B\x0F\xA6\x3D\xD4\x48"
 			  "\xDF\x76\x0D",
 		.rlen	= 51,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 51 - 16, 16 },
 	},
 
 };
@@ -15828,6 +15984,9 @@ static struct cipher_testvec camellia_lrw_enc_tv_template[] = {
 			  "\xb2\x1a\xd8\x4c\xbd\x1d\x10\xe9"
 			  "\x5a\xa8\x92\x7f\xba\xe6\x0c\x95",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -16078,6 +16237,9 @@ static struct cipher_testvec camellia_lrw_dec_tv_template[] = {
 			  "\xe9\x2e\xc4\x29\x0f\x84\xdb\xc4"
 			  "\x21\xc4\xc2\x75\x67\x89\x37\x0a",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -16417,6 +16579,9 @@ static struct cipher_testvec camellia_xts_enc_tv_template[] = {
 			  "\xb7\x16\xd8\x12\x5c\xcd\x7d\x4e"
 			  "\xd5\xc6\x99\xcc\x4e\x6c\x94\x95",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
@@ -16757,6 +16922,9 @@ static struct cipher_testvec camellia_xts_dec_tv_template[] = {
 			  "\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
 			  "\xf8\xf9\xfa\xfb\xfc\xfd\xfe\xff",
 		.rlen	= 512,
+		.also_non_np = 1,
+		.np	= 2,
+		.tap	= { 512 - 16, 16 },
 	},
 };
 
