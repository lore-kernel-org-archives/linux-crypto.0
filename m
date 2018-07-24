From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 4/4] crypto: ccree: allow bigger than sector XTS op
Date: Tue, 24 Jul 2018 15:12:46 +0100
Message-ID: <1532441567-11694-5-git-send-email-gilad@benyossef.com>
References: <1532441567-11694-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1532441567-11694-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The ccree driver had a sanity check that we are not asked
to encrypt an XTS buffer bigger than a sane sector size
since XTS IV needs to include the sector number in the IV
so this is not expected in any real use case.

Unfortunately, this breaks cryptsetup benchmark test which
has a synthetic performance test using 64k buffer of data
with the same IV.

Remove the sanity check and allow the user to hang themselves
and/or run benchmarks if they so wish.

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 9da0ecc..7623b299 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -19,8 +19,6 @@
 
 #define template_skcipher	template_u.skcipher
 
-#define CC_MIN_AES_XTS_SIZE 0x10
-#define CC_MAX_AES_XTS_SIZE 0x2000
 struct cc_cipher_handle {
 	struct list_head alg_list;
 };
@@ -98,8 +96,7 @@ static int validate_data_size(struct cc_cipher_ctx *ctx_p,
 	case S_DIN_to_AES:
 		switch (ctx_p->cipher_mode) {
 		case DRV_CIPHER_XTS:
-			if (size >= CC_MIN_AES_XTS_SIZE &&
-			    size <= CC_MAX_AES_XTS_SIZE &&
+			if (size >= AES_BLOCK_SIZE &&
 			    IS_ALIGNED(size, AES_BLOCK_SIZE))
 				return 0;
 			break;
-- 
2.7.4
