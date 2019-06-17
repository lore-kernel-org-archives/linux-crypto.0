Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C7EC31E57
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 13:24:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DF0B20657
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 13:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfFQNYI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 09:24:08 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:60447 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfFQNYI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 09:24:08 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Mofx1-1iR4jU3wzZ-00p4sv; Mon, 17 Jun 2019 15:23:50 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: testmgr - reduce stack usage in fuzzers
Date:   Mon, 17 Jun 2019 15:23:02 +0200
Message-Id: <20190617132343.2678836-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:FcRwzC9se0P11gJzOfwFRr1sHe4ttlAck8Hb394drcdEoCwQH8v
 V809DLMqf/KXADOpqBkJGBiEFcfZPH03hyOZKAXaO7I+irkUhoV1Uqc2VPH0Ssu00gM/ZGb
 OwUvWa7QnxF3ej4Q/AFE7TqT8g5ujL/x5gbeGWabcNkWmcnjRP7f0xfNOq0Ug4onvRYeso5
 EpJfq2RyEJl6MDBBCuOag==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9B/XLO/4TtU=:vnNPNqTUR5bZd2L/IJG8/I
 Mcas5MJHCIBoAcPrZ+6sVAf6RSl8BOIcxNr/f81N5KwmZBuQ7A5Pb3mU2Fb6B378iXFg5sOV7
 Diocjb2wWhDVZfHbgnuTSQ0gogidLfluNQsnZO91G4J04L9n+X1EWYXnASM2ZyyaaRc3cq7NW
 vNlBiiE0M0uF4GNZV3Sqk3ETLtrA4pI4BLEHAkc0L7qOtDiw9ZLrUwUg/QYh3xjwmQPmQYkr0
 jVA3OdML6kmZrlDQSAscujcI2C5YwA4IsFh4pqaTn8CnRepmuSCRIHpl8VRS+FRUN8Q2Nlhpn
 ICOVHKkwsTGUPG1fzoW7tEXuXQyYb5wVWQfZqhBsJqjoIRprGYgGaWfe5s0EYw2LEyxRFxKHN
 oAJLlYHnD7BkveQU96ddd7T+TjKhWxb4buk9bhnGnyftJsRUUQ1npIAMZHOu3UOJdGKNTuXgp
 OIgGVEVoKTRGI7dfvgbZ1wBlwMCoRWl1Qd8ELP8J0OUXDJJbg9ET6ERNlxJJAxGUAV6QXD8LW
 bhuaug3TGQwf3IMvPYesBH2IHYCJc1WXC8Gc2FIKZ7K/1xR3QBc/8RExjr6fwGNhtj0roTXOU
 0wz/X7TiRANOt2l2uE06mK/Ftw6CWuvMiou3dvUtWQd/jakScgetvN5Rrb/DSDVkJfm/vXUc3
 bdVcbsXmcjIzf9PnXYIzs3NgjO92dQrUryyszapuS5z7BT4Ug6eFvQ1iwpoLWsxtlkzA7ZiRv
 o46W7ETyFphLrfxGQgnonX93yU+m5deq25VjkruC4T9zbW0/jDKXPw9cbFs=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On arm32, we get warnings about high stack usage in some of the functions:

crypto/testmgr.c:2269:12: error: stack frame size of 1032 bytes in function 'alg_test_aead' [-Werror,-Wframe-larger-than=]
static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
           ^
crypto/testmgr.c:1693:12: error: stack frame size of 1312 bytes in function '__alg_test_hash' [-Werror,-Wframe-larger-than=]
static int __alg_test_hash(const struct hash_testvec *vecs,
           ^

On of the larger objects on the stack here is struct testvec_config, so
change that to dynamic allocation.

Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against their generic implementation")
Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against their generic implementation")
Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against their generic implementation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I only compile-tested this, and it's not completely trivial, so please
review carefully.
---
 crypto/testmgr.c | 61 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 45 insertions(+), 16 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6c28055d41ca..7928296cdcb3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1503,13 +1503,15 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
  * Generate a hash test vector from the given implementation.
  * Assumes the buffers in 'vec' were already allocated.
  */
-static void generate_random_hash_testvec(struct crypto_shash *tfm,
+static int generate_random_hash_testvec(struct crypto_shash *tfm,
 					 struct hash_testvec *vec,
 					 unsigned int maxkeysize,
 					 unsigned int maxdatasize,
 					 char *name, size_t max_namelen)
 {
-	SHASH_DESC_ON_STACK(desc, tfm);
+	struct shash_desc *desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(tfm), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
 
 	/* Data */
 	vec->psize = generate_random_length(maxdatasize);
@@ -1541,6 +1543,10 @@ static void generate_random_hash_testvec(struct crypto_shash *tfm,
 done:
 	snprintf(name, max_namelen, "\"random: psize=%u ksize=%u\"",
 		 vec->psize, vec->ksize);
+
+	kfree(desc);
+
+	return 0;
 }
 
 /*
@@ -1565,7 +1571,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 	unsigned int i;
 	struct hash_testvec vec = { 0 };
 	char vec_name[64];
-	struct testvec_config cfg;
+	struct testvec_config *cfg;
 	char cfgname[TESTVEC_CONFIG_NAMELEN];
 	int err;
 
@@ -1595,6 +1601,12 @@ static int test_hash_vs_generic_impl(const char *driver,
 		return err;
 	}
 
+	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+	if (!cfg) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	/* Check the algorithm properties for consistency. */
 
 	if (digestsize != crypto_shash_digestsize(generic_tfm)) {
@@ -1626,12 +1638,14 @@ static int test_hash_vs_generic_impl(const char *driver,
 	}
 
 	for (i = 0; i < fuzz_iterations * 8; i++) {
-		generate_random_hash_testvec(generic_tfm, &vec,
-					     maxkeysize, maxdatasize,
-					     vec_name, sizeof(vec_name));
-		generate_random_testvec_config(&cfg, cfgname, sizeof(cfgname));
+		err = generate_random_hash_testvec(generic_tfm, &vec,
+						   maxkeysize, maxdatasize,
+						   vec_name, sizeof(vec_name));
+		if (err)
+			goto out;
+		generate_random_testvec_config(cfg, cfgname, sizeof(cfgname));
 
-		err = test_hash_vec_cfg(driver, &vec, vec_name, &cfg,
+		err = test_hash_vec_cfg(driver, &vec, vec_name, cfg,
 					req, desc, tsgl, hashstate);
 		if (err)
 			goto out;
@@ -1639,6 +1653,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 	}
 	err = 0;
 out:
+	kfree(cfg);
 	kfree(vec.key);
 	kfree(vec.plaintext);
 	kfree(vec.digest);
@@ -2135,7 +2150,7 @@ static int test_aead_vs_generic_impl(const char *driver,
 	unsigned int i;
 	struct aead_testvec vec = { 0 };
 	char vec_name[64];
-	struct testvec_config cfg;
+	struct testvec_config *cfg;
 	char cfgname[TESTVEC_CONFIG_NAMELEN];
 	int err;
 
@@ -2165,6 +2180,12 @@ static int test_aead_vs_generic_impl(const char *driver,
 		return err;
 	}
 
+	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+	if (!cfg) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	generic_req = aead_request_alloc(generic_tfm, GFP_KERNEL);
 	if (!generic_req) {
 		err = -ENOMEM;
@@ -2219,13 +2240,13 @@ static int test_aead_vs_generic_impl(const char *driver,
 		generate_random_aead_testvec(generic_req, &vec,
 					     maxkeysize, maxdatasize,
 					     vec_name, sizeof(vec_name));
-		generate_random_testvec_config(&cfg, cfgname, sizeof(cfgname));
+		generate_random_testvec_config(cfg, cfgname, sizeof(cfgname));
 
-		err = test_aead_vec_cfg(driver, ENCRYPT, &vec, vec_name, &cfg,
+		err = test_aead_vec_cfg(driver, ENCRYPT, &vec, vec_name, cfg,
 					req, tsgls);
 		if (err)
 			goto out;
-		err = test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name, &cfg,
+		err = test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name, cfg,
 					req, tsgls);
 		if (err)
 			goto out;
@@ -2233,6 +2254,7 @@ static int test_aead_vs_generic_impl(const char *driver,
 	}
 	err = 0;
 out:
+	kfree(cfg);
 	kfree(vec.key);
 	kfree(vec.iv);
 	kfree(vec.assoc);
@@ -2682,7 +2704,7 @@ static int test_skcipher_vs_generic_impl(const char *driver,
 	unsigned int i;
 	struct cipher_testvec vec = { 0 };
 	char vec_name[64];
-	struct testvec_config cfg;
+	struct testvec_config *cfg;
 	char cfgname[TESTVEC_CONFIG_NAMELEN];
 	int err;
 
@@ -2716,6 +2738,12 @@ static int test_skcipher_vs_generic_impl(const char *driver,
 		return err;
 	}
 
+	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+	if (!cfg) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	generic_req = skcipher_request_alloc(generic_tfm, GFP_KERNEL);
 	if (!generic_req) {
 		err = -ENOMEM;
@@ -2763,20 +2791,21 @@ static int test_skcipher_vs_generic_impl(const char *driver,
 	for (i = 0; i < fuzz_iterations * 8; i++) {
 		generate_random_cipher_testvec(generic_req, &vec, maxdatasize,
 					       vec_name, sizeof(vec_name));
-		generate_random_testvec_config(&cfg, cfgname, sizeof(cfgname));
+		generate_random_testvec_config(cfg, cfgname, sizeof(cfgname));
 
 		err = test_skcipher_vec_cfg(driver, ENCRYPT, &vec, vec_name,
-					    &cfg, req, tsgls);
+					    cfg, req, tsgls);
 		if (err)
 			goto out;
 		err = test_skcipher_vec_cfg(driver, DECRYPT, &vec, vec_name,
-					    &cfg, req, tsgls);
+					    cfg, req, tsgls);
 		if (err)
 			goto out;
 		cond_resched();
 	}
 	err = 0;
 out:
+	kfree(cfg);
 	kfree(vec.key);
 	kfree(vec.iv);
 	kfree(vec.ptext);
-- 
2.20.0

