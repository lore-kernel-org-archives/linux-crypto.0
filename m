Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C40C3F2CD
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 12:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4277F20857
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 12:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgCCMJc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 07:09:32 -0500
Received: from foss.arm.com ([217.140.110.172]:46210 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbgCCMJc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 07:09:32 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8E84FEC;
        Tue,  3 Mar 2020 04:09:31 -0800 (PST)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.151])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 539263F534;
        Tue,  3 Mar 2020 04:09:30 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: testmgr - sync both RFC4106 IV copies
Date:   Tue,  3 Mar 2020 14:09:25 +0200
Message-Id: <20200303120925.12067-1-gilad@benyossef.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

RFC4106 AEAD ciphers the AAD is the concatenation of associated
authentication data || IV || plaintext or ciphertext but the
random AEAD message generation in testmgr extended tests did
not obey this requirements producing messages with undefined
behaviours. Fix it by syncing the copies if needed.

Since this only relevant for developer only extended tests any
additional cycles/run time costs are negligible.

This fixes extended AEAD test failures with the ccree driver
caused by illegal input.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Eric Biggers <ebiggers@kernel.org>
---

 crypto/testmgr.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 88f33c0efb23..379bd1c7dd5b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -91,10 +91,16 @@ struct aead_test_suite {
 	unsigned int einval_allowed : 1;
 
 	/*
-	 * Set if the algorithm intentionally ignores the last 8 bytes of the
-	 * AAD buffer during decryption.
+	 * Set if the algorithm includes a copy of the IV (last 8 bytes)
+	 * in the AAD buffer but does not include it in calculating the ICV
 	 */
-	unsigned int esp_aad : 1;
+	unsigned int skip_aad_iv : 1;
+
+	/*
+	 * Set if the algorithm includes a copy of the IV (last 8 bytes)
+	 * in the AAD buffer and does include it when calculating the ICV
+	 */
+	unsigned int auth_aad_iv : 1;
 };
 
 struct cipher_test_suite {
@@ -2167,14 +2173,20 @@ struct aead_extra_tests_ctx {
  * here means the full ciphertext including the authentication tag.  The
  * authentication tag (and hence also the ciphertext) is assumed to be nonempty.
  */
-static void mutate_aead_message(struct aead_testvec *vec, bool esp_aad)
+static void mutate_aead_message(struct aead_testvec *vec,
+				const struct aead_test_suite *suite)
 {
-	const unsigned int aad_tail_size = esp_aad ? 8 : 0;
+	const unsigned int aad_ivsize = 8;
+	const unsigned int aad_tail_size = suite->skip_aad_iv ? aad_ivsize : 0;
 	const unsigned int authsize = vec->clen - vec->plen;
 
 	if (prandom_u32() % 2 == 0 && vec->alen > aad_tail_size) {
 		 /* Mutate the AAD */
 		flip_random_bit((u8 *)vec->assoc, vec->alen - aad_tail_size);
+		if (suite->auth_aad_iv)
+			memcpy((u8 *)vec->iv,
+			       (vec->assoc + vec->alen - aad_ivsize),
+			       aad_ivsize);
 		if (prandom_u32() % 2 == 0)
 			return;
 	}
@@ -2208,6 +2220,10 @@ static void generate_aead_message(struct aead_request *req,
 	/* Generate the AAD. */
 	generate_random_bytes((u8 *)vec->assoc, vec->alen);
 
+	if (suite->auth_aad_iv && (vec->alen > ivsize))
+		memcpy(((u8 *)vec->assoc + vec->alen - ivsize), vec->iv,
+		       ivsize);
+
 	if (inauthentic && prandom_u32() % 2 == 0) {
 		/* Generate a random ciphertext. */
 		generate_random_bytes((u8 *)vec->ctext, vec->clen);
@@ -2242,7 +2258,7 @@ static void generate_aead_message(struct aead_request *req,
 		 * Mutate the authentic (ciphertext, AAD) pair to get an
 		 * inauthentic one.
 		 */
-		mutate_aead_message(vec, suite->esp_aad);
+		mutate_aead_message(vec, suite);
 	}
 	vec->novrfy = 1;
 	if (suite->einval_allowed)
@@ -5202,7 +5218,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = {
 				____VECS(aes_gcm_rfc4106_tv_template),
 				.einval_allowed = 1,
-				.esp_aad = 1,
+				.skip_aad_iv = 1,
 			}
 		}
 	}, {
@@ -5214,7 +5230,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = {
 				____VECS(aes_ccm_rfc4309_tv_template),
 				.einval_allowed = 1,
-				.esp_aad = 1,
+				.skip_aad_iv = 1,
 			}
 		}
 	}, {
@@ -5225,6 +5241,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = {
 				____VECS(aes_gcm_rfc4543_tv_template),
 				.einval_allowed = 1,
+				.auth_aad_iv = 1,
 			}
 		}
 	}, {
@@ -5240,7 +5257,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = {
 				____VECS(rfc7539esp_tv_template),
 				.einval_allowed = 1,
-				.esp_aad = 1,
+				.skip_aad_iv = 1,
 			}
 		}
 	}, {
-- 
2.25.1

