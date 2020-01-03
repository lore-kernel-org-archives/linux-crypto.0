Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85134C33C9A
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C23822314
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024097;
	bh=1E5RBDoLVBtABBUS2OP6sJOSfTyOrDAVlQHMJSjNI4Y=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tN8/4cTv1oU2SXtYfHg1YBlfKpecucLWne/9X0d/z5Aq1xAzmwOdhomSCHwOpw6ix
	 BPoWQgQ0ap7083diRPR9gtoqGdv4vKtWetWQbklziH2LQC49dx5x4suqS5K5Dsvuzv
	 BUHzgsO2zed7BaluAmxLSjX4gj2ggFng0jG5WRW4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbgACEBf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgACEB2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:28 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CBF424653
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024088;
        bh=1E5RBDoLVBtABBUS2OP6sJOSfTyOrDAVlQHMJSjNI4Y=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ND8Rss7c5HYp35O/CQSsqis35eqBuhNnZ7NrIwc869LqDZyhLX9rHKkmBCHZkER6a
         5ac7sTXGV1b7zMV3VSHat/08YXvA1aqgT+V0AYAtiK0C/M8keRBapyoxC+IT+88oM7
         BI8BtTut92DVsJBr/Frtj29NTDEOPttQ6p/LPYFo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 21/28] crypto: cbcmac - use crypto_grab_cipher() and simplify error paths
Date:   Thu,  2 Jan 2020 19:59:01 -0800
Message-Id: <20200103035908.12048-22-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200103035908.12048-1-ebiggers@kernel.org>
References: <20200103035908.12048-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make the cbcmac template use the new function crypto_grab_cipher() to
initialize its cipher spawn.

This is needed to make all spawns be initialized in a consistent way.

This required making cbcmac_create() allocate the instance directly
rather than use shash_alloc_instance().

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet, and
by taking advantage of crypto_grab_*() now handling ERR_PTR() names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ccm.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 48c2b2c565a6..798ae729c77f 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -899,6 +899,7 @@ static void cbcmac_exit_tfm(struct crypto_tfm *tfm)
 static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct shash_instance *inst;
+	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
 	int err;
 
@@ -906,21 +907,20 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		return err;
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
-	if (IS_ERR(alg))
-		return PTR_ERR(alg);
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+	spawn = shash_instance_ctx(inst);
 
-	inst = shash_alloc_instance("cbcmac", alg);
-	err = PTR_ERR(inst);
-	if (IS_ERR(inst))
-		goto out_put_alg;
+	err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
+				 crypto_attr_alg_name(tb[1]), 0, 0);
+	if (err)
+		goto err_free_inst;
+	alg = crypto_spawn_cipher_alg(spawn);
 
-	err = crypto_init_spawn(shash_instance_ctx(inst), alg,
-				shash_crypto_instance(inst),
-				CRYPTO_ALG_TYPE_MASK);
+	err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
 	if (err)
-		goto out_free_inst;
+		goto err_free_inst;
 
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = 1;
@@ -940,13 +940,10 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	inst->alg.setkey = crypto_cbcmac_digest_setkey;
 
 	err = shash_register_instance(tmpl, inst);
-
-out_free_inst:
-	if (err)
+	if (err) {
+err_free_inst:
 		shash_free_instance(shash_crypto_instance(inst));
-
-out_put_alg:
-	crypto_mod_put(alg);
+	}
 	return err;
 }
 
-- 
2.24.1

