Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB5FC17460
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 13:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C167D21882
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 13:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572960579;
	bh=rknUie/5FLh/E/jZRyM9TCKhdP4wfCUrpAV9GEc5nnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0cBYa+jNgXfXVzJYqXwEPf67Hu00w4DWlyLaSHoLGj+s/VttW1gej0ud/o0b6fe9J
	 JHKRIPMfK3veghPEkgQO+uvr1pAUVCuHdxEJUMAUUV/XrBUPzqR280t6u+0oMh50JF
	 NFW6WcBURJUiVTilAytpqDrVHRfUhlp8wklnb0xk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389235AbfKEN3i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 08:29:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389214AbfKEN3i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 08:29:38 -0500
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr [92.154.90.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3557C21D71;
        Tue,  5 Nov 2019 13:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572960577;
        bh=rknUie/5FLh/E/jZRyM9TCKhdP4wfCUrpAV9GEc5nnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/wWkRT1+72Bfqxtj28IFp7rFV8z/yuEpS/qQl3TMKL8c2dj3I0ZdowAcF30fFCxP
         0lDD0DIV/DjC7MaRg2d0gjs5SU5gOMjwsBgSGr9IxJArLE1sflUSLGt8GlNZNrx2q+
         0yMd+7AMsa9NB+O2T4p+5kJ6A9WIeeW77q0NC3AI=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 29/29] crypto: ccree - update a stale reference to ablkcipher
Date:   Tue,  5 Nov 2019 14:28:26 +0100
Message-Id: <20191105132826.1838-30-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105132826.1838-1-ardb@kernel.org>
References: <20191105132826.1838-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ccree driver does not use the ablkcipher interface but contains
a rudimentary reference to it in the naming of an unrelated macro.
Let's rename it to avoid confusion.

Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/ccree/cc_cipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 254b48797799..3112b58d0bb1 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -16,7 +16,7 @@
 #include "cc_cipher.h"
 #include "cc_request_mgr.h"
 
-#define MAX_ABLKCIPHER_SEQ_LEN 6
+#define MAX_SKCIPHER_SEQ_LEN 6
 
 #define template_skcipher	template_u.skcipher
 
@@ -822,7 +822,7 @@ static int cc_cipher_process(struct skcipher_request *req,
 	void *iv = req->iv;
 	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
-	struct cc_hw_desc desc[MAX_ABLKCIPHER_SEQ_LEN];
+	struct cc_hw_desc desc[MAX_SKCIPHER_SEQ_LEN];
 	struct cc_crypto_req cc_req = {};
 	int rc;
 	unsigned int seq_len = 0;
-- 
2.20.1

