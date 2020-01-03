Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B83C32771
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 303A221D7D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024097;
	bh=ruT2xBGpJQ0H0TVLybs5CZ6N4Ac42jgoc6/RMOEKKis=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=S1YdR18MdxCJmsioU/2IdqOjT+JjqRo44JY3lVXU5xuVILTAgjek4om2jGt+dZHHp
	 LHaE8/M/gjxoqCiplsekgYJdstH1BXx8wXGvMLwjI33U0AfX348xwNy8bFzP+dprUh
	 VsJ+m8pWtrWftJTB8ASGPT+vaCQAbv6CLAlF+E3w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgACEBg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727175AbgACEB1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:27 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D24AE222C3
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024086;
        bh=ruT2xBGpJQ0H0TVLybs5CZ6N4Ac42jgoc6/RMOEKKis=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=y+scjNSMd5XGCq20ow0vw7r2BjPEQTwO6d/+9+RhT250sJqTaAnGv5YLkPkNDAfdD
         XdE5aYrB3WWSx26z4JT0yWfxqZEisLoRvc9KxFf9tvRhSWbFgboraiGgClt9RgX76c
         uX3usVcNTB1flnv6q2b2BUtblQpeIOx1zOKzfTDQ=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 14/28] crypto: hmac - use crypto_grab_shash() and simplify error paths
Date:   Thu,  2 Jan 2020 19:58:54 -0800
Message-Id: <20200103035908.12048-15-ebiggers@kernel.org>
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

Make the hmac template use the new function crypto_grab_shash() to
initialize its shash spawn.

This is needed to make all spawns be initialized in a consistent way.

This required making hmac_create() allocate the instance directly rather
than use shash_alloc_instance().

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet, and
by taking advantage of crypto_grab_*() now handling ERR_PTR() names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/hmac.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 685e49953605..0a42b7075763 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -165,6 +165,7 @@ static void hmac_exit_tfm(struct crypto_shash *parent)
 static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct shash_instance *inst;
+	struct crypto_shash_spawn *spawn;
 	struct crypto_alg *alg;
 	struct shash_alg *salg;
 	int err;
@@ -175,31 +176,32 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (err)
 		return err;
 
-	salg = shash_attr_alg(tb[1], 0, 0);
-	if (IS_ERR(salg))
-		return PTR_ERR(salg);
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+	spawn = shash_instance_ctx(inst);
+
+	err = crypto_grab_shash(spawn, shash_crypto_instance(inst),
+				crypto_attr_alg_name(tb[1]), 0, 0);
+	if (err)
+		goto err_free_inst;
+	salg = crypto_spawn_shash_alg(spawn);
 	alg = &salg->base;
 
 	/* The underlying hash algorithm must not require a key */
 	err = -EINVAL;
 	if (crypto_shash_alg_needs_key(salg))
-		goto out_put_alg;
+		goto err_free_inst;
 
 	ds = salg->digestsize;
 	ss = salg->statesize;
 	if (ds > alg->cra_blocksize ||
 	    ss < alg->cra_blocksize)
-		goto out_put_alg;
+		goto err_free_inst;
 
-	inst = shash_alloc_instance("hmac", alg);
-	err = PTR_ERR(inst);
-	if (IS_ERR(inst))
-		goto out_put_alg;
-
-	err = crypto_init_shash_spawn(shash_instance_ctx(inst), salg,
-				      shash_crypto_instance(inst));
+	err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
 	if (err)
-		goto out_free_inst;
+		goto err_free_inst;
 
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
@@ -224,12 +226,9 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 
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

