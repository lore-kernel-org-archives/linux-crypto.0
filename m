Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AAAC31E51
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0AF3206B7
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbfFRJWi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:22:38 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49445 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728810AbfFRJWi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 05:22:38 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MGi6k-1hqtpz3gm2-00Dpcp; Tue, 18 Jun 2019 11:22:25 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] crypto: testmgr - dynamically allocate testvec_config
Date:   Tue, 18 Jun 2019 11:21:52 +0200
Message-Id: <20190618092215.2790800-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:mxKuVA8iA1EbQfNShrkOV2y+cvXiII8ei0xEg5HLxKaIKUwQuVc
 2G84oK0ClHsBzhAK53bwhfdYfWM/CVUu7TioI1P7yksRUKhTK8EaAGP1beY90+aE81sHqR7
 txwyrqNaFpwoHsvHHnKqXu3XhBCjiS0jHqYzMy0DnsAG9IJ66HzuEatosUWj+LQfpRYvVmT
 n/AWdCJda+kuhrwtywS+A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7KlQ5KnBSR0=:cS0VUCasrt2uRndfHhgRew
 r15mI8vLZfA0SJrqf6PAECM3suMt7b79rXiOAwgGqK4IxXsRq4Vb/6t7UWcqlZkTBG/tE/kMH
 C97mo46aeNt9AI88gV44BHyvhyCdpHyZQyyKVXdVjqiWudZy6wEuPNINXJ6vpCq97FKKXqtvd
 8vLk9CQjdxAdRvrCaR0qHfuCuGMAOmXaGPVOxt59qJkdvdIkZ2zNUcAqBX+O9aFYmktpFBFSU
 AtLD2Xp409UHC2TPiYMuvbQW5WXlfQcq50FCDTZE7YOLbfBzFKGkdtzcQzIw3cK1PixT3c8GQ
 +Hh7kYogyzPuHcOyJTavbO0scIYLpCRLDT2E0GvzZ3VOl/qL5Pz33lkLQPfqRuBOAX4DqsfaO
 UsShMI/L1AQcadA6o99kJOy6u4Sn0zHbH9xcuybcLHHgao+UxMq6e+KHD5T0KKDXJYms40euR
 YaXF0bNLUlJmHHJLHxEhV57pnhusrj2y/sznyVsUN35QvjpwbdE/qjRvh7rle6QmIUWKY+CUa
 BDC3DawFXc69AJKYMQlj7hGgaL7ojzKrn4XhQclCM7EjPoO2xjo0MF6rnkbXXToOQ90sXoihL
 s5StOvj5dhSd0nyB6H1BVbrOkJ3iGFPYwwRqnnYj2+ZdKTxD5SvaN4uya99xRs0v1b0XkD8lh
 OBszwQ9mgG7PGD/cQGoLYl93rMqTuCJH4DU/tzcWlR/IFpeT6LSd6k3QaS55/Q1LliObD2TwP
 5uLbiACg4jgwWgC4s7NQt6DntytFaBrgd211+Q==
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
 crypto/testmgr.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6c28055d41ca..0e07f61f1a31 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1565,7 +1565,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 	unsigned int i;
 	struct hash_testvec vec = { 0 };
 	char vec_name[64];
-	struct testvec_config cfg;
+	struct testvec_config *cfg;
 	char cfgname[TESTVEC_CONFIG_NAMELEN];
 	int err;
 
@@ -1595,6 +1595,12 @@ static int test_hash_vs_generic_impl(const char *driver,
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
@@ -1629,9 +1635,9 @@ static int test_hash_vs_generic_impl(const char *driver,
 		generate_random_hash_testvec(generic_tfm, &vec,
 					     maxkeysize, maxdatasize,
 					     vec_name, sizeof(vec_name));
-		generate_random_testvec_config(&cfg, cfgname, sizeof(cfgname));
+		generate_random_testvec_config(cfg, cfgname, sizeof(cfgname));
 
-		err = test_hash_vec_cfg(driver, &vec, vec_name, &cfg,
+		err = test_hash_vec_cfg(driver, &vec, vec_name, cfg,
 					req, desc, tsgl, hashstate);
 		if (err)
 			goto out;
@@ -1639,6 +1645,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 	}
 	err = 0;
 out:
+	kfree(cfg);
 	kfree(vec.key);
 	kfree(vec.plaintext);
 	kfree(vec.digest);
@@ -2135,7 +2142,7 @@ static int test_aead_vs_generic_impl(const char *driver,
 	unsigned int i;
 	struct aead_testvec vec = { 0 };
 	char vec_name[64];
-	struct testvec_config cfg;
+	struct testvec_config *cfg;
 	char cfgname[TESTVEC_CONFIG_NAMELEN];
 	int err;
 
@@ -2165,6 +2172,12 @@ static int test_aead_vs_generic_impl(const char *driver,
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
@@ -2219,13 +2232,13 @@ static int test_aead_vs_generic_impl(const char *driver,
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
@@ -2233,6 +2246,7 @@ static int test_aead_vs_generic_impl(const char *driver,
 	}
 	err = 0;
 out:
+	kfree(cfg);
 	kfree(vec.key);
 	kfree(vec.iv);
 	kfree(vec.assoc);
@@ -2682,7 +2696,7 @@ static int test_skcipher_vs_generic_impl(const char *driver,
 	unsigned int i;
 	struct cipher_testvec vec = { 0 };
 	char vec_name[64];
-	struct testvec_config cfg;
+	struct testvec_config *cfg;
 	char cfgname[TESTVEC_CONFIG_NAMELEN];
 	int err;
 
@@ -2716,6 +2730,12 @@ static int test_skcipher_vs_generic_impl(const char *driver,
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
@@ -2763,20 +2783,21 @@ static int test_skcipher_vs_generic_impl(const char *driver,
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

