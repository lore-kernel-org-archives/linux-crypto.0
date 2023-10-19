Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11465CDB487
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbjJSFyS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbjJSFyQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:54:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90E7FE
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:54:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7CFC433C9
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 05:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697694854;
        bh=20+UvtXYNWYcRu2KHZqRBA5odB5J1ZAywDOCONf/L4I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=YM7NMcpgyWaAKr8L3i6ehkyUtQbdbhRthdDKP+Cd1Ep6AVfdB4sUcJKHFrV+2IqGZ
         WEjfHnNJ2GdDcCPlU358vhq5oeNt4C1r1zJbhBq2e7M4/3bBRE1QYMw/rT/390B0I7
         HLKpSFzbAWlfAhe7lBbxRMgsVH71KWehD5G1C6h2/0DH+kYdB7l3RwMmLqNhX/NAm6
         E9WiScfWztz6CBhCVMRc+qGbzKx3OlDb5HIFhRApe0JAc05ZBuR0u1X+7Bnjh8j8sc
         7DpDta3Mfn0v02YqN/VLuyymCckJWFyjQS7zeRPoHz2nOx06RXW4K7+NasuacJP0wP
         mVFZ9pmHLEBYA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 09/17] crypto: vmac - don't set alignmask
Date:   Wed, 18 Oct 2023 22:53:35 -0700
Message-ID: <20231019055343.588846-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
References: <20231019055343.588846-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The vmac template is setting its alignmask to that of its underlying
'cipher'.  This doesn't actually accomplish anything useful, though, so
stop doing it.  (vmac_update() does have an alignment bug, where it
assumes u64 alignment when it shouldn't, but that bug exists both before
and after this patch.)  This is a prerequisite for removing support for
nonzero alignmasks from shash.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/vmac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/vmac.c b/crypto/vmac.c
index 4633b2dda1e0a..0a1d8efa6c1a6 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -642,21 +642,20 @@ static int vmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	err = -EINVAL;
 	if (alg->cra_blocksize != VMAC_NONCEBYTES)
 		goto err_free_inst;
 
 	err = crypto_inst_setname(shash_crypto_instance(inst), tmpl->name, alg);
 	if (err)
 		goto err_free_inst;
 
 	inst->alg.base.cra_priority = alg->cra_priority;
 	inst->alg.base.cra_blocksize = alg->cra_blocksize;
-	inst->alg.base.cra_alignmask = alg->cra_alignmask;
 
 	inst->alg.base.cra_ctxsize = sizeof(struct vmac_tfm_ctx);
 	inst->alg.base.cra_init = vmac_init_tfm;
 	inst->alg.base.cra_exit = vmac_exit_tfm;
 
 	inst->alg.descsize = sizeof(struct vmac_desc_ctx);
 	inst->alg.digestsize = VMAC_TAG_LEN / 8;
 	inst->alg.init = vmac_init;
 	inst->alg.update = vmac_update;
 	inst->alg.final = vmac_final;
-- 
2.42.0

