Return-Path: <SRS0=4IwG=SP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7232C10F11
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Apr 2019 04:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C96921721
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Apr 2019 04:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555129564;
	bh=wXQFuoNP9Zm6uujHS3K77YDE3fcHiauA2W5i1nrXx8U=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=IH4kX/Oww8c1Trhw59jtcL83dT3lu0RBbrjxSex4CcI/mnCQg6L/+0pXfgc0uYcr5
	 poTQ0NBvXWAtc/b0Gn79vJe24hSXi4UEpNOOEQCtyxCbqXz1t6dnItbZMFnZKwF6qr
	 skzYe5b72bv3RCzvFYnLbQHKueSaT6cdmolWq8M8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbfDME0E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Apr 2019 00:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbfDME0D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Apr 2019 00:26:03 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAB7320848;
        Sat, 13 Apr 2019 04:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555129563;
        bh=wXQFuoNP9Zm6uujHS3K77YDE3fcHiauA2W5i1nrXx8U=;
        h=From:To:Cc:Subject:Date:From;
        b=Esr59eIETGC6rInOo6LOxmdNpKRJPOdC1+BpC9Z/5pjDArRw+eNnJp0LAiCd1KDTU
         ZzELSwV6gQg40TYdI0icvECKtX7tptw7Yl3x0Vr0yneE/+T1zM/fHhlhdJp9P6iiAr
         tJ5oFtqhCHyqiL/CXfzJ6yFwLkheCWL8BSgQvfd0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     George Cherian <george.cherian@cavium.com>,
        Nagadheeraj Rottela <rnagadheeraj@marvell.com>,
        Srikanth Jampala <jsrikanth@marvell.com>
Subject: [PATCH] crypto: cavium - remove bogus code handling cryptd
Date:   Fri, 12 Apr 2019 21:25:31 -0700
Message-Id: <20190413042531.16231-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The cavium crypto driver adds 'sizeof(struct ablkcipher_request)' to its
request size because "the cryptd daemon uses this memory for request_ctx
information".  This is incorrect and unnecessary; cryptd doesn't require
wrapped algorithms to reserve extra request space.  So remove this.

Also remove the unneeded memset() of the tfm context to 0.
It's already zeroed on allocation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/cavium/cpt/cptvf_algs.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index 600336d169a9e..8d53611e9d5db 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -10,7 +10,6 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
-#include <crypto/cryptd.h>
 #include <crypto/crypto_wq.h>
 #include <crypto/des.h>
 #include <crypto/xts.h>
@@ -338,16 +337,7 @@ static int cvm_ecb_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 
 static int cvm_enc_dec_init(struct crypto_tfm *tfm)
 {
-	struct cvm_enc_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	memset(ctx, 0, sizeof(*ctx));
-	tfm->crt_ablkcipher.reqsize = sizeof(struct cvm_req_ctx) +
-					sizeof(struct ablkcipher_request);
-	/* Additional memory for ablkcipher_request is
-	 * allocated since the cryptd daemon uses
-	 * this memory for request_ctx information
-	 */
-
+	tfm->crt_ablkcipher.reqsize = sizeof(struct cvm_req_ctx);
 	return 0;
 }
 
-- 
2.21.0

