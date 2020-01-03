Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43A18C47409
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B0D7222C3
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024094;
	bh=TyFzwlzfBrW4/tW4Pb0/iLEh7VnCJjVScUUPyVQvKg0=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XV2fGBiTaN0Pulh+WLWKu6QlYG8kHXxCsxrhhefjR3AcQpPaeoU7p83Zk9nSBqQqe
	 yLOait5DjV83n25Xabm8gtynKCGR0L2cLjelriEJIvTThQ+LlmJ2sAXNukVNKFw30M
	 +SL4YbNQYsCs8jF9WDgUWGR8RB70CB1RLHIGVRg0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgACEBb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbgACEBa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:30 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B65F24655
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024088;
        bh=TyFzwlzfBrW4/tW4Pb0/iLEh7VnCJjVScUUPyVQvKg0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=EbwV8eHqFLs2uoGyJTpTHvFQvsQJ3PYTOMlz5Uviehnc1RKBAugdtBTihWt2kDXtX
         SWNQFGlWDha6jiLyHYEd7gD+V21df/iPyHYk/rjocqLhGdN2lk0HpGW+u+RkA85nDU
         adnOKf7LQVj00PBa1T8R2wNflUn0AozhALPUdDqg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 23/28] crypto: vmac - use crypto_grab_cipher() and simplify error paths
Date:   Thu,  2 Jan 2020 19:59:03 -0800
Message-Id: <20200103035908.12048-24-ebiggers@kernel.org>
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

Make the vmac64 template use the new function crypto_grab_cipher() to
initialize its cipher spawn.

This is needed to make all spawns be initialized in a consistent way.

This required making vmac_create() allocate the instance directly rather
than use shash_alloc_instance().

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet, and
by taking advantage of crypto_grab_*() now handling ERR_PTR() names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/vmac.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/crypto/vmac.c b/crypto/vmac.c
index f50a85060b39..8924f914dc44 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -620,6 +620,7 @@ static void vmac_exit_tfm(struct crypto_tfm *tfm)
 static int vmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct shash_instance *inst;
+	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
 	int err;
 
@@ -627,25 +628,24 @@ static int vmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		return err;
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
-			CRYPTO_ALG_TYPE_MASK);
-	if (IS_ERR(alg))
-		return PTR_ERR(alg);
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+	spawn = shash_instance_ctx(inst);
+
+	err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
+				 crypto_attr_alg_name(tb[1]), 0, 0);
+	if (err)
+		goto err_free_inst;
+	alg = crypto_spawn_cipher_alg(spawn);
 
 	err = -EINVAL;
 	if (alg->cra_blocksize != VMAC_NONCEBYTES)
-		goto out_put_alg;
+		goto err_free_inst;
 
-	inst = shash_alloc_instance(tmpl->name, alg);
-	err = PTR_ERR(inst);
-	if (IS_ERR(inst))
-		goto out_put_alg;
-
-	err = crypto_init_spawn(shash_instance_ctx(inst), alg,
-			shash_crypto_instance(inst),
-			CRYPTO_ALG_TYPE_MASK);
+	err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
 	if (err)
-		goto out_free_inst;
+		goto err_free_inst;
 
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
@@ -664,12 +664,9 @@ static int vmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = shash_register_instance(tmpl, inst);
 	if (err) {
-out_free_inst:
+err_free_inst:
 		shash_free_instance(shash_crypto_instance(inst));
 	}
-
-out_put_alg:
-	crypto_mod_put(alg);
 	return err;
 }
 
-- 
2.24.1

