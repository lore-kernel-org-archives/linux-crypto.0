Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C058C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 11:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05EAD20870
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 11:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfAWL75 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 06:59:57 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:40657 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfAWL75 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 06:59:57 -0500
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id BA9C71849C;
        Wed, 23 Jan 2019 12:59:54 +0100 (CET)
X-Axis-User: NO
X-Axis-NonUser: YES
X-Virus-Scanned: Debian amavisd-new at bastet.se.axis.com
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id e-KxI6pp37oY; Wed, 23 Jan 2019 12:59:53 +0100 (CET)
Received: from boulder03.se.axis.com (boulder03.se.axis.com [10.0.8.17])
        by bastet.se.axis.com (Postfix) with ESMTPS id 1FA951848F;
        Wed, 23 Jan 2019 12:59:53 +0100 (CET)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C23661E06A;
        Wed, 23 Jan 2019 12:59:52 +0100 (CET)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B67851E064;
        Wed, 23 Jan 2019 12:59:52 +0100 (CET)
Received: from seth.se.axis.com (unknown [10.0.2.172])
        by boulder03.se.axis.com (Postfix) with ESMTP;
        Wed, 23 Jan 2019 12:59:52 +0100 (CET)
Received: from pc32929-1845.se.axis.com (pc32929-1845.se.axis.com [10.88.129.17])
        by seth.se.axis.com (Postfix) with ESMTP id AADD41CA2;
        Wed, 23 Jan 2019 12:59:52 +0100 (CET)
Received: by pc32929-1845.se.axis.com (Postfix, from userid 20456)
        id A8635409B9; Wed, 23 Jan 2019 12:59:52 +0100 (CET)
From:   Lars Persson <lars.persson@axis.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Lars Persson <larper@axis.com>
Subject: [PATCH 5/7] crypto: axis - support variable AEAD tag length
Date:   Wed, 23 Jan 2019 12:59:44 +0100
Message-Id: <d5b31e69c35168c4e0f8dbec13074309f513b2ef.1548243646.git.larper@axis.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1548243646.git.larper@axis.com>
References: <cover.1548243646.git.larper@axis.com>
In-Reply-To: <cover.1548243646.git.larper@axis.com>
References: <cover.1548243646.git.larper@axis.com>
X-TM-AS-GCONF: 00
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The implementation assumed that the client always wants the whole 16
byte AES-GCM tag. Now we respect the requested authentication tag size
fetched using crypto_aead_authsize().

Signed-off-by: Lars Persson <larper@axis.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 4936f8fb253a..1be5bdd658a4 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -1907,7 +1907,7 @@ static int artpec6_crypto_prepare_aead(struct aead_request *areq)
 	/* For the decryption, cryptlen includes the tag. */
 	input_length = areq->cryptlen;
 	if (req_ctx->decrypt)
-		input_length -= AES_BLOCK_SIZE;
+		input_length -= crypto_aead_authsize(cipher);
 
 	/* Prepare the context buffer */
 	req_ctx->hw_ctx.aad_length_bits =
@@ -1972,7 +1972,7 @@ static int artpec6_crypto_prepare_aead(struct aead_request *areq)
 		size_t output_len = areq->cryptlen;
 
 		if (req_ctx->decrypt)
-			output_len -= AES_BLOCK_SIZE;
+			output_len -= crypto_aead_authsize(cipher);
 
 		artpec6_crypto_walk_init(&walk, areq->dst);
 
@@ -2001,19 +2001,32 @@ static int artpec6_crypto_prepare_aead(struct aead_request *areq)
 		 * the output ciphertext. For decryption it is put in a context
 		 * buffer for later compare against the input tag.
 		 */
-		count = AES_BLOCK_SIZE;
 
 		if (req_ctx->decrypt) {
 			ret = artpec6_crypto_setup_in_descr(common,
-				req_ctx->decryption_tag, count, false);
+				req_ctx->decryption_tag, AES_BLOCK_SIZE, false);
 			if (ret)
 				return ret;
 
 		} else {
+			/* For encryption the requested tag size may be smaller
+			 * than the hardware's generated tag.
+			 */
+			size_t authsize = crypto_aead_authsize(cipher);
+
 			ret = artpec6_crypto_setup_sg_descrs_in(common, &walk,
-								count);
+								authsize);
 			if (ret)
 				return ret;
+
+			if (authsize < AES_BLOCK_SIZE) {
+				count = AES_BLOCK_SIZE - authsize;
+				ret = artpec6_crypto_setup_in_descr(common,
+					ac->pad_buffer,
+					count, false);
+				if (ret)
+					return ret;
+			}
 		}
 
 	}
@@ -2174,27 +2187,29 @@ static void artpec6_crypto_complete_aead(struct crypto_async_request *req)
 	/* Verify GCM hashtag. */
 	struct aead_request *areq = container_of(req,
 		struct aead_request, base);
+	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
 	struct artpec6_crypto_aead_req_ctx *req_ctx = aead_request_ctx(areq);
 
 	if (req_ctx->decrypt) {
 		u8 input_tag[AES_BLOCK_SIZE];
+		unsigned int authsize = crypto_aead_authsize(aead);
 
 		sg_pcopy_to_buffer(areq->src,
 				   sg_nents(areq->src),
 				   input_tag,
-				   AES_BLOCK_SIZE,
+				   authsize,
 				   areq->assoclen + areq->cryptlen -
-				   AES_BLOCK_SIZE);
+				   authsize);
 
 		if (memcmp(req_ctx->decryption_tag,
 			   input_tag,
-			   AES_BLOCK_SIZE)) {
+			   authsize)) {
 			pr_debug("***EBADMSG:\n");
 			print_hex_dump_debug("ref:", DUMP_PREFIX_ADDRESS, 32, 1,
-					     input_tag, AES_BLOCK_SIZE, true);
+					     input_tag, authsize, true);
 			print_hex_dump_debug("out:", DUMP_PREFIX_ADDRESS, 32, 1,
 					     req_ctx->decryption_tag,
-					     AES_BLOCK_SIZE, true);
+					     authsize, true);
 
 			result = -EBADMSG;
 		}
-- 
2.11.0

