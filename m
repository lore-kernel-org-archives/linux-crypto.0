Return-Path: <SRS0=zJfq=QF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81648C282CD
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Jan 2019 00:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56217214DA
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Jan 2019 00:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfA2ABh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Jan 2019 19:01:37 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:59158 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbfA2ABh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Jan 2019 19:01:37 -0500
Received: from gentoo.cpe.tdp.com (unknown [181.67.136.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: chrisadr)
        by smtp.gentoo.org (Postfix) with ESMTPSA id 22C5B335D4C;
        Tue, 29 Jan 2019 00:01:33 +0000 (UTC)
From:   Christopher Diaz Riveros <chrisadr@gentoo.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     Christopher Diaz Riveros <chrisadr@gentoo.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch-next] crypto: testmgr - use kmemdup
Date:   Mon, 28 Jan 2019 19:01:18 -0500
Message-Id: <20190129000118.15923-1-chrisadr@gentoo.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixes coccinnelle alerts:

/crypto/testmgr.c:2112:13-20: WARNING opportunity for kmemdup
/crypto/testmgr.c:2130:13-20: WARNING opportunity for kmemdup
/crypto/testmgr.c:2152:9-16: WARNING opportunity for kmemdup

Signed-off-by: Christopher Diaz Riveros <chrisadr@gentoo.org>
---
 crypto/testmgr.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index e4f3f5f688e7..9c95f0eea863 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2109,12 +2109,11 @@ static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
 
 	if (vec->genkey) {
 		/* Save party A's public key */
-		a_public = kzalloc(out_len_max, GFP_KERNEL);
+		a_public = kmemdup(sg_virt(req->dst), out_len_max, GFP_KERNEL);
 		if (!a_public) {
 			err = -ENOMEM;
 			goto free_output;
 		}
-		memcpy(a_public, sg_virt(req->dst), out_len_max);
 	} else {
 		/* Verify calculated public key */
 		if (memcmp(vec->expected_a_public, sg_virt(req->dst),
@@ -2127,13 +2126,12 @@ static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
 	}
 
 	/* Calculate shared secret key by using counter part (b) public key. */
-	input_buf = kzalloc(vec->b_public_size, GFP_KERNEL);
+	input_buf = kmemdup(vec->b_public, vec->b_public_size, GFP_KERNEL);
 	if (!input_buf) {
 		err = -ENOMEM;
 		goto free_output;
 	}
 
-	memcpy(input_buf, vec->b_public, vec->b_public_size);
 	sg_init_one(&src, input_buf, vec->b_public_size);
 	sg_init_one(&dst, output_buf, out_len_max);
 	kpp_request_set_input(req, &src, vec->b_public_size);
@@ -2149,12 +2147,11 @@ static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
 
 	if (vec->genkey) {
 		/* Save the shared secret obtained by party A */
-		a_ss = kzalloc(vec->expected_ss_size, GFP_KERNEL);
+		a_ss = kmemdup(sg_virt(req->dst), vec->expected_ss_size, GFP_KERNEL);
 		if (!a_ss) {
 			err = -ENOMEM;
 			goto free_all;
 		}
-		memcpy(a_ss, sg_virt(req->dst), vec->expected_ss_size);
 
 		/*
 		 * Calculate party B's shared secret by using party A's
-- 
2.20.1

