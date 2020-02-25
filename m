Return-Path: <SRS0=ER22=4N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61570C35E04
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 16:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B80C206E2
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Feb 2020 16:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgBYQKb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Feb 2020 11:10:31 -0500
Received: from foss.arm.com ([217.140.110.172]:52634 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728499AbgBYQKb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Feb 2020 11:10:31 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82F52101E;
        Tue, 25 Feb 2020 07:48:48 -0800 (PST)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.157])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1DAE3F703;
        Tue, 25 Feb 2020 07:48:46 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: testmgr - sync both RFC4106 IV copies
Date:   Tue, 25 Feb 2020 17:48:34 +0200
Message-Id: <20200225154834.25108-3-gilad@benyossef.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200225154834.25108-1-gilad@benyossef.com>
References: <20200225154834.25108-1-gilad@benyossef.com>
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
 crypto/testmgr.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index cf565b063cdf..288f349a0cae 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -95,6 +95,11 @@ struct aead_test_suite {
 	 * AAD buffer during decryption.
 	 */
 	unsigned int esp_aad : 1;
+
+	/*
+	 * Set if the algorithm requires the IV to trail the AAD buffer.
+	 */
+	unsigned int iv_aad : 1;
 };
 
 struct cipher_test_suite {
@@ -2207,6 +2212,10 @@ static void generate_aead_message(struct aead_request *req,
 
 	/* Generate the AAD. */
 	generate_random_bytes((u8 *)vec->assoc, vec->alen);
+	/* For RFC4106 algs, a copy of the IV is part of the AAD */
+	if (suite->iv_aad)
+		memcpy(((u8 *)vec->assoc + vec->alen - ivsize), vec->iv,
+		       ivsize);
 
 	if (inauthentic && prandom_u32() % 2 == 0) {
 		/* Generate a random ciphertext. */
@@ -2247,6 +2256,14 @@ static void generate_aead_message(struct aead_request *req,
 	vec->novrfy = 1;
 	if (suite->einval_allowed)
 		vec->crypt_error = -EINVAL;
+
+	/*
+	 * For RFC4106 algs, the IV is embedded as part of the AAD
+	 * and we might have mutated the AAD so sync the copies
+	 */
+	if (suite->iv_aad)
+		memcpy((u8 *)vec->iv, (vec->assoc + vec->alen - ivsize),
+		       ivsize);
 }
 
 /*
@@ -5243,6 +5260,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 				____VECS(aes_gcm_rfc4106_tv_template),
 				.einval_allowed = 1,
 				.esp_aad = 1,
+				.iv_aad = 1,
 			}
 		}
 	}, {
@@ -5255,6 +5273,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 				____VECS(aes_ccm_rfc4309_tv_template),
 				.einval_allowed = 1,
 				.esp_aad = 1,
+				.iv_aad = 1,
 			}
 		}
 	}, {
@@ -5265,6 +5284,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = {
 				____VECS(aes_gcm_rfc4543_tv_template),
 				.einval_allowed = 1,
+				.iv_aad = 1,
 			}
 		}
 	}, {
-- 
2.25.0

