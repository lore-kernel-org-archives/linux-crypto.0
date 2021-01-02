Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D33C433E0
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 14:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE12522482
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 14:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbhABOAE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 09:00:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbhABOAD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 09:00:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29C4E22482;
        Sat,  2 Jan 2021 13:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609595963;
        bh=EDGYTmDI5XanuDSTDXlxBcRyNwx/6ihguZ8/C7JpKjc=;
        h=From:To:Cc:Subject:Date:From;
        b=SFeV8rF7tRs+d4NU2w+l/Wd9X/RO0DLgkLJzoRBDvMFeU6SQV3pmJvL1tBpzU6Vf/
         muGBUv8Q4QUTCpNxrdruzMMPUxteGCy1An6U8+Sig+aV0WtUfwj0Pw5zztsBu7rD3n
         9o3HUknJ78LzbibvPsoxCEL/lRR6xjyzoiKgieWawYZrCtxJCrLSlEQwtbYNZcH2lS
         WZfcDgtKbhKbctxA08omS6PIPk+oHseFsMFb1fu4ZxnWcvLcVeYiApSvO0Dlrck/08
         wzRQ2qazN8Vmp4ACewMd7bOAejRpKiXTjCSI29TNt3Fq9FNOl/mJ+6nEOgRWcQOdIZ
         6R/lAeTgZwkqQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, pavel@denx.de,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: ecdh - avoid buffer overflow in ecdh_set_secret()
Date:   Sat,  2 Jan 2021 14:59:09 +0100
Message-Id: <20210102135909.5637-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Pavel reports that commit 17858b140bf4 ("crypto: ecdh - avoid unaligned
accesses in ecdh_set_secret()") fixes one problem but introduces another:
the unconditional memcpy() introduced by that commit may overflow the
target buffer if the source data is invalid, which could be the result of
intentional tampering.

So check params.key_size explicitly against the size of the target buffer
before validating the key further.

Fixes: 17858b140bf4 ("crypto: ecdh - avoid unaligned accesses in ecdh_set_secret()")
Reported-by: Pavel Machek <pavel@denx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/ecdh.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index d56b8603dec9..96f80c8f8e30 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -39,7 +39,8 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	struct ecdh params;
 	unsigned int ndigits;
 
-	if (crypto_ecdh_decode_key(buf, len, &params) < 0)
+	if (crypto_ecdh_decode_key(buf, len, &params) < 0 ||
+	    params.key_size > sizeof(ctx->private_key))
 		return -EINVAL;
 
 	ndigits = ecdh_supported_curve(params.curve_id);
-- 
2.17.1

