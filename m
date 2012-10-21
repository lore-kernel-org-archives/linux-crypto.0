From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH] crypto - ablk_helper: add module parameter to allow testing
 cryptd redirection of requests
Date: Sun, 21 Oct 2012 20:45:29 +0300
Message-ID: <20121021174529.11043.15034.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:35487 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2JURpb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Oct 2012 13:45:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add module parameter to allow forcing redirection of crypto requests to
cryptd worker threads. This allows these code paths to be actually tested
(easier).

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/ablk_helper.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/ablk_helper.c b/arch/x86/crypto/ablk_helper.c
index 43282fe..52385a3 100644
--- a/arch/x86/crypto/ablk_helper.c
+++ b/arch/x86/crypto/ablk_helper.c
@@ -33,6 +33,8 @@
 #include <asm/i387.h>
 #include <asm/crypto/ablk_helper.h>
 
+static int force_cryptd_redirect;
+
 int ablk_set_key(struct crypto_ablkcipher *tfm, const u8 *key,
 		 unsigned int key_len)
 {
@@ -70,7 +72,7 @@ int ablk_encrypt(struct ablkcipher_request *req)
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 
-	if (!irq_fpu_usable()) {
+	if (force_cryptd_redirect || !irq_fpu_usable()) {
 		struct ablkcipher_request *cryptd_req =
 			ablkcipher_request_ctx(req);
 
@@ -89,7 +91,7 @@ int ablk_decrypt(struct ablkcipher_request *req)
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct async_helper_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 
-	if (!irq_fpu_usable()) {
+	if (force_cryptd_redirect || !irq_fpu_usable()) {
 		struct ablkcipher_request *cryptd_req =
 			ablkcipher_request_ctx(req);
 
@@ -146,4 +148,7 @@ int ablk_init(struct crypto_tfm *tfm)
 }
 EXPORT_SYMBOL_GPL(ablk_init);
 
+module_param(force_cryptd_redirect, int, 0);
+MODULE_PARM_DESC(force_cryptd_redirect,
+		 "Force all crypto request to cryptd worker instead of using current context (Use only for testing purposes!)");
 MODULE_LICENSE("GPL");
