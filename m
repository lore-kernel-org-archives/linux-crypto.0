Return-Path: <SRS0=9w58=AX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E9F9C433E3
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 21:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6429120702
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 21:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbgGLVO2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jul 2020 17:14:28 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:19487 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbgGLVO2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jul 2020 17:14:28 -0400
Received: from localhost.localdomain ([93.22.148.52])
        by mwinf5d61 with ME
        id 2MER2300i183tQl03MEST8; Sun, 12 Jul 2020 23:14:26 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 12 Jul 2020 23:14:26 +0200
X-ME-IP: 93.22.148.52
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     ayush.sawal@chelsio.com, vinay.yadav@chelsio.com,
        rohitm@chelsio.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] Crypto/chcr: Fix some pr_xxx messages
Date:   Sun, 12 Jul 2020 23:14:24 +0200
Message-Id: <20200712211424.276263-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

At the top this file, we have:
   #define pr_fmt(fmt) "chcr:" fmt

So there is no need to repeat "chcr : " in some error message when the
pr_xxx macro is used.
This would lead to log "chcr:chcr : blabla"

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/chelsio/chcr_algo.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index ba2469008dd9..e02b56bd43c6 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1224,7 +1224,7 @@ static int chcr_handle_cipher_resp(struct skcipher_request *req,
 	wrparam.bytes = bytes;
 	skb = create_cipher_wr(&wrparam);
 	if (IS_ERR(skb)) {
-		pr_err("chcr : %s : Failed to form WR. No memory\n", __func__);
+		pr_err("%s : Failed to form WR. No memory\n", __func__);
 		err = PTR_ERR(skb);
 		goto unmap;
 	}
@@ -1556,7 +1556,7 @@ static int get_alg_config(struct algo_param *params,
 		params->result_size = SHA512_DIGEST_SIZE;
 		break;
 	default:
-		pr_err("chcr : ERROR, unsupported digest size\n");
+		pr_err("ERROR, unsupported digest size\n");
 		return -EINVAL;
 	}
 	return 0;
@@ -3571,7 +3571,7 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 		goto out;
 
 	if (get_alg_config(&param, max_authsize)) {
-		pr_err("chcr : Unsupported digest size\n");
+		pr_err("Unsupported digest size\n");
 		goto out;
 	}
 	subtype = get_aead_subtype(authenc);
@@ -3590,7 +3590,7 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	} else if (keys.enckeylen == AES_KEYSIZE_256) {
 		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
 	} else {
-		pr_err("chcr : Unsupported cipher key\n");
+		pr_err("Unsupported cipher key\n");
 		goto out;
 	}
 
@@ -3608,7 +3608,7 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 	}
 	base_hash  = chcr_alloc_shash(max_authsize);
 	if (IS_ERR(base_hash)) {
-		pr_err("chcr : Base driver cannot be loaded\n");
+		pr_err("Base driver cannot be loaded\n");
 		goto out;
 	}
 	{
@@ -3624,7 +3624,7 @@ static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
 						  keys.authkeylen,
 						  o_ptr);
 			if (err) {
-				pr_err("chcr : Base driver cannot be loaded\n");
+				pr_err("Base driver cannot be loaded\n");
 				goto out;
 			}
 			keys.authkeylen = max_authsize;
@@ -3709,7 +3709,7 @@ static int chcr_aead_digest_null_setkey(struct crypto_aead *authenc,
 	} else if (keys.enckeylen == AES_KEYSIZE_256) {
 		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
 	} else {
-		pr_err("chcr : Unsupported cipher key %d\n", keys.enckeylen);
+		pr_err("Unsupported cipher key %d\n", keys.enckeylen);
 		goto out;
 	}
 	memcpy(aeadctx->key, keys.enckey, keys.enckeylen);
@@ -3745,7 +3745,7 @@ static int chcr_aead_op(struct aead_request *req,
 
 	cdev = a_ctx(tfm)->dev;
 	if (!cdev) {
-		pr_err("chcr : %s : No crypto device.\n", __func__);
+		pr_err("%s : No crypto device.\n", __func__);
 		return -ENXIO;
 	}
 
@@ -4495,8 +4495,7 @@ static int chcr_register_alg(void)
 			break;
 		}
 		if (err) {
-			pr_err("chcr : %s : Algorithm registration failed\n",
-			       name);
+			pr_err("%s : Algorithm registration failed\n", name);
 			goto register_err;
 		} else {
 			driver_algs[i].is_registered = 1;
-- 
2.25.1

