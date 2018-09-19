From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 11/23] wusb: Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:48 -0700
Message-ID: <20180919021100.3380-12-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Johan Hovold <johan@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-usb@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919021100.3380-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this
replaces struct crypto_skcipher and SKCIPHER_REQUEST_ON_STACK() usage
with struct crypto_sync_skcipher and SYNC_SKCIPHER_REQUEST_ON_STACK(),
which uses a fixed stack size.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Johan Hovold <johan@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/usb/wusbcore/crypto.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
index aff50eb09ca9..68ddee86a886 100644
--- a/drivers/usb/wusbcore/crypto.c
+++ b/drivers/usb/wusbcore/crypto.c
@@ -189,7 +189,7 @@ struct wusb_mac_scratch {
  * NOTE: blen is not aligned to a block size, we'll pad zeros, that's
  *       what sg[4] is for. Maybe there is a smarter way to do this.
  */
-static int wusb_ccm_mac(struct crypto_skcipher *tfm_cbc,
+static int wusb_ccm_mac(struct crypto_sync_skcipher *tfm_cbc,
 			struct crypto_cipher *tfm_aes,
 			struct wusb_mac_scratch *scratch,
 			void *mic,
@@ -198,7 +198,7 @@ static int wusb_ccm_mac(struct crypto_skcipher *tfm_cbc,
 			size_t blen)
 {
 	int result = 0;
-	SKCIPHER_REQUEST_ON_STACK(req, tfm_cbc);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm_cbc);
 	struct scatterlist sg[4], sg_dst;
 	void *dst_buf;
 	size_t dst_size;
@@ -224,7 +224,7 @@ static int wusb_ccm_mac(struct crypto_skcipher *tfm_cbc,
 	if (!dst_buf)
 		goto error_dst_buf;
 
-	iv = kzalloc(crypto_skcipher_ivsize(tfm_cbc), GFP_KERNEL);
+	iv = kzalloc(crypto_sync_skcipher_ivsize(tfm_cbc), GFP_KERNEL);
 	if (!iv)
 		goto error_iv;
 
@@ -251,7 +251,7 @@ static int wusb_ccm_mac(struct crypto_skcipher *tfm_cbc,
 	sg_set_page(&sg[3], ZERO_PAGE(0), zero_padding, 0);
 	sg_init_one(&sg_dst, dst_buf, dst_size);
 
-	skcipher_request_set_tfm(req, tfm_cbc);
+	skcipher_request_set_sync_tfm(req, tfm_cbc);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, sg, &sg_dst, dst_size, iv);
 	result = crypto_skcipher_encrypt(req);
@@ -298,19 +298,19 @@ ssize_t wusb_prf(void *out, size_t out_size,
 {
 	ssize_t result, bytes = 0, bitr;
 	struct aes_ccm_nonce n = *_n;
-	struct crypto_skcipher *tfm_cbc;
+	struct crypto_sync_skcipher *tfm_cbc;
 	struct crypto_cipher *tfm_aes;
 	struct wusb_mac_scratch *scratch;
 	u64 sfn = 0;
 	__le64 sfn_le;
 
-	tfm_cbc = crypto_alloc_skcipher("cbc(aes)", 0, CRYPTO_ALG_ASYNC);
+	tfm_cbc = crypto_alloc_sync_skcipher("cbc(aes)", 0, 0);
 	if (IS_ERR(tfm_cbc)) {
 		result = PTR_ERR(tfm_cbc);
 		printk(KERN_ERR "E: can't load CBC(AES): %d\n", (int)result);
 		goto error_alloc_cbc;
 	}
-	result = crypto_skcipher_setkey(tfm_cbc, key, 16);
+	result = crypto_sync_skcipher_setkey(tfm_cbc, key, 16);
 	if (result < 0) {
 		printk(KERN_ERR "E: can't set CBC key: %d\n", (int)result);
 		goto error_setkey_cbc;
@@ -351,7 +351,7 @@ ssize_t wusb_prf(void *out, size_t out_size,
 	crypto_free_cipher(tfm_aes);
 error_alloc_aes:
 error_setkey_cbc:
-	crypto_free_skcipher(tfm_cbc);
+	crypto_free_sync_skcipher(tfm_cbc);
 error_alloc_cbc:
 	return result;
 }
-- 
2.17.1
