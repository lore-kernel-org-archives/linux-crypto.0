Return-Path: <SRS0=TjYB=2Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1D1C32771
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E48DF21D7D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jan 2020 04:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578024094;
	bh=W+vjy+rq1vdVci6oXj7vGift00pdKDFP/LwvQFdusRk=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HneCw1xTFWCawqBa26pUXiexo3hsYI3p+5FO+Coe/juOGMemc7CALQgG3Ml0zu23T
	 KYXigLww1lPG9hoYrPHEwe9DkBlIEKeIMP6UQaFIVK7yKbNt0k8N9UKJqgT8ddFJIi
	 oWAubIk6RAMWrC3dDvs/3+crmYE10S4k/cxwJauE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgACEBd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jan 2020 23:01:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbgACEBa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jan 2020 23:01:30 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC0042465D
        for <linux-crypto@vger.kernel.org>; Fri,  3 Jan 2020 04:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578024088;
        bh=W+vjy+rq1vdVci6oXj7vGift00pdKDFP/LwvQFdusRk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=e8t2QJy0ngk+GQ3XURGJ4//TeA5EvDpNc3ll+O/Qzd9JuEfyQC4lLE0NRBCf8VyOn
         HANCtS9jSE8GKhCs6H4lnGymah0sw5vPT8UKCA3sEi+X2QyWQnfEbsQGs3EziutaeV
         syqvYN4wcIqkMTqgrau3NVjc2LTGfdNgvAY2zYR8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 24/28] crypto: xcbc - use crypto_grab_cipher() and simplify error paths
Date:   Thu,  2 Jan 2020 19:59:04 -0800
Message-Id: <20200103035908.12048-25-ebiggers@kernel.org>
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

Make the xcbc template use the new function crypto_grab_cipher() to
initialize its cipher spawn.

This is needed to make all spawns be initialized in a consistent way.

This required making xcbc_create() allocate the instance directly rather
than use shash_alloc_instance().

Also simplify the error handling by taking advantage of crypto_drop_*()
now accepting (as a no-op) spawns that haven't been initialized yet, and
by taking advantage of crypto_grab_*() now handling ERR_PTR() names.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/xcbc.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 0bb26e8f6f5a..9b97fa511f10 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -188,6 +188,7 @@ static void xcbc_exit_tfm(struct crypto_tfm *tfm)
 static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct shash_instance *inst;
+	struct crypto_cipher_spawn *spawn;
 	struct crypto_alg *alg;
 	unsigned long alignmask;
 	int err;
@@ -196,28 +197,24 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
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
 
-	switch(alg->cra_blocksize) {
-	case XCBC_BLOCKSIZE:
-		break;
-	default:
-		goto out_put_alg;
-	}
+	err = crypto_grab_cipher(spawn, shash_crypto_instance(inst),
+				 crypto_attr_alg_name(tb[1]), 0, 0);
+	if (err)
+		goto err_free_inst;
+	alg = crypto_spawn_cipher_alg(spawn);
 
-	inst = shash_alloc_instance("xcbc", alg);
-	err = PTR_ERR(inst);
-	if (IS_ERR(inst))
-		goto out_put_alg;
+	err = -EINVAL;
+	if (alg->cra_blocksize != XCBC_BLOCKSIZE)
+		goto err_free_inst;
 
-	err = crypto_init_spawn(shash_instance_ctx(inst), alg,
-				shash_crypto_instance(inst),
-				CRYPTO_ALG_TYPE_MASK);
+	err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
 	if (err)
-		goto out_free_inst;
+		goto err_free_inst;
 
 	alignmask = alg->cra_alignmask | 3;
 	inst->alg.base.cra_alignmask = alignmask;
@@ -244,12 +241,9 @@ static int xcbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 
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

