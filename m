Return-Path: <SRS0=z9QW=ZB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 857B5C43331
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 17:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C4DF20656
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 17:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573319507;
	bh=hfc1/O945SnRL73VHWK31MFGF1og32LtjQd9E+nXHF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ioJEjQNsxoiQG9f++wtVb31hIWbkqTvHbpVR4GI19zqod/nGfHIlHpzYj6VVCXOJp
	 Roq7ATb3mmv2aZK8U3FXgqIOeboHPmS0gKMZ7pyXOTuldmG1asQvxfK+TAiXLSXUrQ
	 Xl0x7Ty92oR5FajA3i0xcddCO1MgW8gFK6p3DQRc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfKIRLr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 12:11:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfKIRLq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 12:11:46 -0500
Received: from e123331-lin.home (lfbn-mar-1-643-104.w90-118.abo.wanadoo.fr [90.118.215.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE47B20869;
        Sat,  9 Nov 2019 17:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573319506;
        bh=hfc1/O945SnRL73VHWK31MFGF1og32LtjQd9E+nXHF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3EzBEIDVBXibH4a70ye2OjYy209vk0VBATiqiAEepWZHpwdkkiFNb72Cval9WDbj
         bay+ysJ2nBbjPUPG+ldvxN6erpnhFyAUKDYMKSHuCWSsLZi+H6jW8UvJu15k7dRsqB
         D8oizQruJ0aI5PBGBPgvIduft2MeOI0aaFjxLw98=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 29/29] crypto: ccree - update a stale reference to ablkcipher
Date:   Sat,  9 Nov 2019 18:09:54 +0100
Message-Id: <20191109170954.756-30-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191109170954.756-1-ardb@kernel.org>
References: <20191109170954.756-1-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ccree driver does not use the ablkcipher interface but contains
a rudimentary reference to it in the naming of an unrelated macro.
Let's rename it to avoid confusion.

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>
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
2.17.1

