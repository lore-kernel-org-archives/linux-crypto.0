From: <yanjiang.jin@windriver.com>
Subject: [PATCH] crypto/testmgr.c: fix !x==y confusion
Date: Fri, 29 Jul 2016 16:32:09 +0800
Message-ID: <1469781129-24304-1-git-send-email-yanjiang.jin@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<jinyanjiang@gmail.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Yanjiang Jin <yanjiang.jin@windriver.com>

"if (!ret == template[i].fail)" is confusing to compilers (gcc5):

crypto/testmgr.c: In function '__test_aead':
crypto/testmgr.c:531:12: warning: logical not is only applied to the
left hand side of comparison [-Wlogical-not-parentheses]
   if (!ret == template[i].fail) {
            ^

Let there be 'if (template[i].fail == !ret) '.

Signed-off-by: Yanjiang Jin <yanjiang.jin@windriver.com>
---
 crypto/testmgr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5c9d5a5..c2a8bd3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -665,7 +665,7 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		memcpy(key, template[i].key, template[i].klen);
 
 		ret = crypto_aead_setkey(tfm, key, template[i].klen);
-		if (!ret == template[i].fail) {
+		if (template[i].fail == !ret) {
 			pr_err("alg: aead%s: setkey failed on test %d for %s: flags=%x\n",
 			       d, j, algo, crypto_aead_get_flags(tfm));
 			goto out;
@@ -770,7 +770,7 @@ static int __test_aead(struct crypto_aead *tfm, int enc,
 		memcpy(key, template[i].key, template[i].klen);
 
 		ret = crypto_aead_setkey(tfm, key, template[i].klen);
-		if (!ret == template[i].fail) {
+		if (template[i].fail == !ret) {
 			pr_err("alg: aead%s: setkey failed on chunk test %d for %s: flags=%x\n",
 			       d, j, algo, crypto_aead_get_flags(tfm));
 			goto out;
@@ -1023,7 +1023,7 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 
 		ret = crypto_cipher_setkey(tfm, template[i].key,
 					   template[i].klen);
-		if (!ret == template[i].fail) {
+		if (template[i].fail == !ret) {
 			printk(KERN_ERR "alg: cipher: setkey failed "
 			       "on test %d for %s: flags=%x\n", j,
 			       algo, crypto_cipher_get_flags(tfm));
@@ -1133,7 +1133,7 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 
 		ret = crypto_skcipher_setkey(tfm, template[i].key,
 					     template[i].klen);
-		if (!ret == template[i].fail) {
+		if (template[i].fail == !ret) {
 			pr_err("alg: skcipher%s: setkey failed on test %d for %s: flags=%x\n",
 			       d, j, algo, crypto_skcipher_get_flags(tfm));
 			goto out;
@@ -1211,7 +1211,7 @@ static int __test_skcipher(struct crypto_skcipher *tfm, int enc,
 
 		ret = crypto_skcipher_setkey(tfm, template[i].key,
 					     template[i].klen);
-		if (!ret == template[i].fail) {
+		if (template[i].fail == !ret) {
 			pr_err("alg: skcipher%s: setkey failed on chunk test %d for %s: flags=%x\n",
 			       d, j, algo, crypto_skcipher_get_flags(tfm));
 			goto out;
-- 
1.9.1
