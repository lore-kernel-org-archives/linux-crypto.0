Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D22CDB474
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbjJVITB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbjJVISv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB1BDD
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB4DC433CD
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962727;
        bh=vv+DmIoq1Yu+1izodwo+C0qCNOAzfQxHxI0uOGd0dFk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=MYY1fjaNu7s9sE7aWGuJXLeZS+yn9uoA5lDjiXby4IAJ/7W3FSNHrSTgWOfovQv9/
         k4TSxog0Z5k+zEhD3zRyksfddh/phJFgSTdh8P7OB8DMhacNCQMlqQFZDqaG3NyALV
         NSNWzWD4lpJoyPtBsStTngMYY0TnSerxqE9UPYDDRU5XJ96JLuUq2anxMbSCdV3IBE
         3I7CB792/dwkSPVvNHbgLDwO9UiO3BlydMBgOak7WmizXmua26Sm0/WFZgsHhIF2Uj
         vAdMJw+8aJE9Qz+u3InQ0H2hgTEZBPmmnt+6+WqaIhflj/NW6DV1uIvFxzJzmS/h00
         v7dhsHEYS7zYg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 20/30] crypto: ccm - stop using alignmask of ahash
Date:   Sun, 22 Oct 2023 01:10:50 -0700
Message-ID: <20231022081100.123613-21-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that the alignmask for ahash and shash algorithms is always 0,
simplify crypto_ccm_create_common() accordingly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ccm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index dd7aed63efc93..36f0acec32e19 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -497,22 +497,21 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 		goto err_free_inst;
 
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "ccm_base(%s,%s)", ctr->base.cra_driver_name,
 		     mac->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	inst->alg.base.cra_priority = (mac->base.cra_priority +
 				       ctr->base.cra_priority) / 2;
 	inst->alg.base.cra_blocksize = 1;
-	inst->alg.base.cra_alignmask = mac->base.cra_alignmask |
-				       ctr->base.cra_alignmask;
+	inst->alg.base.cra_alignmask = ctr->base.cra_alignmask;
 	inst->alg.ivsize = 16;
 	inst->alg.chunksize = ctr->chunksize;
 	inst->alg.maxauthsize = 16;
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_ccm_ctx);
 	inst->alg.init = crypto_ccm_init_tfm;
 	inst->alg.exit = crypto_ccm_exit_tfm;
 	inst->alg.setkey = crypto_ccm_setkey;
 	inst->alg.setauthsize = crypto_ccm_setauthsize;
 	inst->alg.encrypt = crypto_ccm_encrypt;
 	inst->alg.decrypt = crypto_ccm_decrypt;
-- 
2.42.0

