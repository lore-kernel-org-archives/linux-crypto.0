Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB70CC31E51
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9641C206B7
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbfFRJXD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:23:03 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55425 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728810AbfFRJXC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 05:23:02 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N49Yn-1icvsZ0urh-0102X2; Tue, 18 Jun 2019 11:22:50 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] crypto: testmgr - dynamically allocate crypto_shash
Date:   Tue, 18 Jun 2019 11:21:53 +0200
Message-Id: <20190618092215.2790800-2-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190618092215.2790800-1-arnd@arndb.de>
References: <20190618092215.2790800-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:bO58TLJx+C6E/baJmdAkbG6/15WeaVirgQ4dxIMpxNhBaUxJa5q
 0LKHAxCuKLWNgpKkZ91FP0UvVB47wZdeUjjc61FoclVxBvJf2I1v5Lu5BcENrE0kniyr+0J
 +hODOn4LOGP3bVsy0N4Cx8wn4xmyhQuSss3GQlFZ4YBDSPdXtPXI/L26EZOdiZZThdlwHBp
 xfKLQe3DBIyGjTamWkFbQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:xnuTpmV9pJQ=:mv+KzxkuI/BpPdXtwon4WS
 5shJO2YB6vQAJJemqacnK21USBZLkoBpP8/VKXFPIlFTobKD/fI3IA2kH0RnpKZvgmzUCrNb5
 X6k5SxAHAU30zt60pQr7xmvjipGmDc4os34k9Aoi3Fa7Nf5fTrUo+P6AnO7+UrGZo4jS2FDhy
 YOWuDG4VgNHa7CufBQVtNMRAji4Rpu0Xd9/qmXaUtlpqIm0BcysNlhUF+OwW4Nd3lMJKghQTn
 NKxOaocvsQhgkafE5dMpxKOB0YOMqiW61BllNUrc5iTu55nV6t2iSvjBVRadzcxQGAYvctwwb
 paBlwyOzwThsTB+CJUovcjrjst4So/LMVKgbBj0V236qhhI3t77s4GP7woVyRXH2NsPC2PC75
 SQgMggoN7eFBUqym4l9eRCuPnY6wusHgBGOSJVxpX0KVw7v0ZmAfAEFOM1oi+vOhHQ/Pjgf5q
 M89f1SlLqrNfh1p1xbcDorCWYz0lYADjp2UryTMuMWQM8dTxak1N4KUvqTP7EFvROmY7BarVw
 s5arN/KJcJJ/M37Nnp2COlUmdeegyj6x0Gs4UTc61itOgamC5k7i5xrgnNdGQCvQM6hLYKTZi
 PMDCQwRiWCsX2SFn/GQgimHYIOZSk9x12Tg3/E/1qnXUEUFz40/3rQ/XRM7tDcKCld5tMO129
 JIDVtzDbqtKOmPfqnBj276akm1LbdCuQuypX7m72K/UPM7DL6RvX+Ri3RX6snuYNz/639V2Wf
 sZekFWHuWQ9XlzapnkMv4aDG94VP+ZFf6BDefA==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The largest stack object in this file is now the shash descriptor.
Since there are many other stack variables, this can push it
over the 1024 byte warning limit, in particular with clang and
KASAN:

crypto/testmgr.c:1693:12: error: stack frame size of 1312 bytes in function '__alg_test_hash' [-Werror,-Wframe-larger-than=]

Make test_hash_vs_generic_impl() do the same thing as the
corresponding eaed and skcipher functions by allocating the
descriptor dynamically. We can still do better than this,
but it brings us well below the 1024 byte limit.

Suggested-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against their generic implementation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 crypto/testmgr.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0e07f61f1a31..0ce28b3aab3c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1503,14 +1503,12 @@ static int test_hash_vec(const char *driver, const struct hash_testvec *vec,
  * Generate a hash test vector from the given implementation.
  * Assumes the buffers in 'vec' were already allocated.
  */
-static void generate_random_hash_testvec(struct crypto_shash *tfm,
+static void generate_random_hash_testvec(struct shash_desc *desc,
 					 struct hash_testvec *vec,
 					 unsigned int maxkeysize,
 					 unsigned int maxdatasize,
 					 char *name, size_t max_namelen)
 {
-	SHASH_DESC_ON_STACK(desc, tfm);
-
 	/* Data */
 	vec->psize = generate_random_length(maxdatasize);
 	generate_random_bytes((u8 *)vec->plaintext, vec->psize);
@@ -1527,7 +1525,7 @@ static void generate_random_hash_testvec(struct crypto_shash *tfm,
 			vec->ksize = 1 + (prandom_u32() % maxkeysize);
 		generate_random_bytes((u8 *)vec->key, vec->ksize);
 
-		vec->setkey_error = crypto_shash_setkey(tfm, vec->key,
+		vec->setkey_error = crypto_shash_setkey(desc->tfm, vec->key,
 							vec->ksize);
 		/* If the key couldn't be set, no need to continue to digest. */
 		if (vec->setkey_error)
@@ -1535,7 +1533,6 @@ static void generate_random_hash_testvec(struct crypto_shash *tfm,
 	}
 
 	/* Digest */
-	desc->tfm = tfm;
 	vec->digest_error = crypto_shash_digest(desc, vec->plaintext,
 						vec->psize, (u8 *)vec->digest);
 done:
@@ -1562,6 +1559,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 	const char *algname = crypto_hash_alg_common(tfm)->base.cra_name;
 	char _generic_driver[CRYPTO_MAX_ALG_NAME];
 	struct crypto_shash *generic_tfm = NULL;
+	struct shash_desc *generic_desc = NULL;
 	unsigned int i;
 	struct hash_testvec vec = { 0 };
 	char vec_name[64];
@@ -1601,6 +1599,14 @@ static int test_hash_vs_generic_impl(const char *driver,
 		goto out;
 	}
 
+	generic_desc = kzalloc(sizeof(*desc) +
+			       crypto_shash_descsize(generic_tfm), GFP_KERNEL);
+	if (!generic_desc) {
+		err = -ENOMEM;
+		goto out;
+	}
+	generic_desc->tfm = generic_tfm;
+
 	/* Check the algorithm properties for consistency. */
 
 	if (digestsize != crypto_shash_digestsize(generic_tfm)) {
@@ -1632,7 +1638,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 	}
 
 	for (i = 0; i < fuzz_iterations * 8; i++) {
-		generate_random_hash_testvec(generic_tfm, &vec,
+		generate_random_hash_testvec(generic_desc, &vec,
 					     maxkeysize, maxdatasize,
 					     vec_name, sizeof(vec_name));
 		generate_random_testvec_config(cfg, cfgname, sizeof(cfgname));
@@ -1650,6 +1656,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 	kfree(vec.plaintext);
 	kfree(vec.digest);
 	crypto_free_shash(generic_tfm);
+	kzfree(generic_desc);
 	return err;
 }
 #else /* !CONFIG_CRYPTO_MANAGER_EXTRA_TESTS */
-- 
2.20.0

