Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D42C56201
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Nov 2020 10:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00EB52076B
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Nov 2020 10:47:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ugji4IwG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbgKXKr4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Nov 2020 05:47:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730434AbgKXKr4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Nov 2020 05:47:56 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4252206F9;
        Tue, 24 Nov 2020 10:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606214875;
        bh=3GhyShOv3dqmAaR1AL7M0eI9NM5IfrLU+Vm8o5Ow8cw=;
        h=From:To:Cc:Subject:Date:From;
        b=Ugji4IwGYP6ylC0qPrP4CInDhmkGdL/oWFtJ1srXvCos2YtlnsxMgOvj7xxI6cuA6
         CnIzl+kHG5PW60ntYirHgzgRzJk1eS0qplTywgf46ISx1XknXDmiRH3oDv8agGVagA
         CVb9TNDRO0kEuf2lO/XcsFeWq2m9wZiYWqly42Ew=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: ecdh - avoid unaligned accesses in ecdh_set_secret()
Date:   Tue, 24 Nov 2020 11:47:19 +0100
Message-Id: <20201124104719.13415-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ecdh_set_secret() casts a void* pointer to a const u64* in order to
feed it into ecc_is_key_valid(). This is not generally permitted by
the C standard, and leads to actual misalignment faults on ARMv6
cores. In some cases, these are fixed up in software, but this still
leads to performance hits that are entirely avoidable.

So let's copy the key into the ctx buffer first, which we will do
anyway in the common case, and which guarantees correct alignment.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/ecdh.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index b0232d6ab4ce..d56b8603dec9 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -53,12 +53,13 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
 				       ctx->private_key);
 
-	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
-			     (const u64 *)params.key, params.key_size) < 0)
-		return -EINVAL;
-
 	memcpy(ctx->private_key, params.key, params.key_size);
 
+	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
+			     ctx->private_key, params.key_size) < 0) {
+		memzero_explicit(ctx->private_key, params.key_size);
+		return -EINVAL;
+	}
 	return 0;
 }
 
-- 
2.17.1

