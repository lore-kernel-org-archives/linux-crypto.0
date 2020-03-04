Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0EEC3F2CE
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 22:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B535B20716
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 22:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583361878;
	bh=7kagA36q7o6JUgkNkpStFltXSlxiCI9+NLGIEaE2l8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JjF/UaLwxcPvRI/uwWy2ySxx4mLgaX9vtoNuhHP5rhI1UKrjgQKzxO2vjc3oOvrZk
	 92Ce8l+hPWZfsmpWiSXaW27j34ArJCWz2jSOCkOehRpCsQqM/K5S6ycpnGN/ZrOnFq
	 pslJCTY2dd3wOkU/RloLXPPIlL8xpAOuJL4jNokA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388407AbgCDWoi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 17:44:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388351AbgCDWoi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 17:44:38 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BD2C2084E;
        Wed,  4 Mar 2020 22:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583361877;
        bh=7kagA36q7o6JUgkNkpStFltXSlxiCI9+NLGIEaE2l8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c96qHRVD09hFs+ygWqgS62l2Gn4YLMFoOVnnUW0WhB6WJwnMltmTROThk2ZhoLrjO
         fpi3oZisPg6yUhF7BXhTYdsnCpsktF8dcTsD8snvb2NStHf8HnOjF2MrtakaBnkG+8
         DA7Hd7ZFvsz9cxa5/Txcjwy+MazmKjme5sBijBlo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 1/3] crypto: testmgr - use consistent IV copies for AEADs that need it
Date:   Wed,  4 Mar 2020 14:44:03 -0800
Message-Id: <20200304224405.152829-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304224405.152829-1-ebiggers@kernel.org>
References: <20200304224405.152829-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

rfc4543 was missing from the list of algorithms that may treat the end
of the AAD buffer specially.

Also, with rfc4106, rfc4309, rfc4543, and rfc7539esp, the end of the AAD
buffer is actually supposed to contain a second copy of the IV, and
we've concluded that if the IV copies don't match the behavior is
implementation-defined.  So, the fuzz tests can't easily test that case.

So, make the fuzz tests only use inputs where the two IV copies match.

Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against their generic implementation")
Cc: Stephan Mueller <smueller@chronox.de>
Originally-from: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 88f33c0efb23..0a10dbde27ef 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -91,10 +91,11 @@ struct aead_test_suite {
 	unsigned int einval_allowed : 1;
 
 	/*
-	 * Set if the algorithm intentionally ignores the last 8 bytes of the
-	 * AAD buffer during decryption.
+	 * Set if this algorithm requires that the IV be located at the end of
+	 * the AAD buffer, in addition to being given in the normal way.  The
+	 * behavior when the two IV copies differ is implementation-defined.
 	 */
-	unsigned int esp_aad : 1;
+	unsigned int aad_iv : 1;
 };
 
 struct cipher_test_suite {
@@ -2167,9 +2168,10 @@ struct aead_extra_tests_ctx {
  * here means the full ciphertext including the authentication tag.  The
  * authentication tag (and hence also the ciphertext) is assumed to be nonempty.
  */
-static void mutate_aead_message(struct aead_testvec *vec, bool esp_aad)
+static void mutate_aead_message(struct aead_testvec *vec, bool aad_iv,
+				unsigned int ivsize)
 {
-	const unsigned int aad_tail_size = esp_aad ? 8 : 0;
+	const unsigned int aad_tail_size = aad_iv ? ivsize : 0;
 	const unsigned int authsize = vec->clen - vec->plen;
 
 	if (prandom_u32() % 2 == 0 && vec->alen > aad_tail_size) {
@@ -2207,6 +2209,9 @@ static void generate_aead_message(struct aead_request *req,
 
 	/* Generate the AAD. */
 	generate_random_bytes((u8 *)vec->assoc, vec->alen);
+	if (suite->aad_iv && vec->alen >= ivsize)
+		/* Avoid implementation-defined behavior. */
+		memcpy((u8 *)vec->assoc + vec->alen - ivsize, vec->iv, ivsize);
 
 	if (inauthentic && prandom_u32() % 2 == 0) {
 		/* Generate a random ciphertext. */
@@ -2242,7 +2247,7 @@ static void generate_aead_message(struct aead_request *req,
 		 * Mutate the authentic (ciphertext, AAD) pair to get an
 		 * inauthentic one.
 		 */
-		mutate_aead_message(vec, suite->esp_aad);
+		mutate_aead_message(vec, suite->aad_iv, ivsize);
 	}
 	vec->novrfy = 1;
 	if (suite->einval_allowed)
@@ -5202,7 +5207,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = {
 				____VECS(aes_gcm_rfc4106_tv_template),
 				.einval_allowed = 1,
-				.esp_aad = 1,
+				.aad_iv = 1,
 			}
 		}
 	}, {
@@ -5214,7 +5219,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = {
 				____VECS(aes_ccm_rfc4309_tv_template),
 				.einval_allowed = 1,
-				.esp_aad = 1,
+				.aad_iv = 1,
 			}
 		}
 	}, {
@@ -5225,6 +5230,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = {
 				____VECS(aes_gcm_rfc4543_tv_template),
 				.einval_allowed = 1,
+				.aad_iv = 1,
 			}
 		}
 	}, {
@@ -5240,7 +5246,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = {
 				____VECS(rfc7539esp_tv_template),
 				.einval_allowed = 1,
-				.esp_aad = 1,
+				.aad_iv = 1,
 			}
 		}
 	}, {
-- 
2.25.1

