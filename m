Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22295C3A59D
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 10:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E42F9233A2
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 10:25:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uXSt5Sht"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387552AbfHVKZB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 06:25:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:47095 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387545AbfHVKZB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 06:25:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id z1so4853934wru.13
        for <linux-crypto@vger.kernel.org>; Thu, 22 Aug 2019 03:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=o7be3La0xqbM1+XB6BOf/tB1xXnCIEmRWtI29Pxo614=;
        b=uXSt5ShtItflxlygNLbhRNaSWt6v6rjDyWIlF6x60PoJSj3IbAM+MxYrX0mgxEAyQw
         ijHnLoocwsJWI6fMAubiIVemkd6Z9DeY0xQqBu1amh/6PvwteSBphdNS/J+mt839WsN6
         /Q5YIofXWemnErL7oA2SjCDfnSz47Is4Ad/MLdp2QcnlsBWyhcY5re85tXIqXUt4c9KA
         m7sl2lKTb3u5hFuZPk6gd+rXABYTBgHgBMQfBm87V0ktaWu6MfNQNOLulnjs/M6j53fl
         WxKNRMWJIRSicWB+dxy1QStmSESah2UgOD/NC8ZzHFRfnqUTY0sfOjXMih4CO5qPQZ1p
         rPpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=o7be3La0xqbM1+XB6BOf/tB1xXnCIEmRWtI29Pxo614=;
        b=i1U0yZw5biWodQab9yrwyc+tTdvC7kiDh4MgRrYSzCXXQZkklrxZEF1rmV0t22nkWI
         ooLnc80qNJZD5hN6b8nVvzE6/JYzbCuO67MIVXr3J7GKbpdJ7arHxMliI833RhGD4Xd6
         6noAmia/sGt8WeeEfa0INO+4rm1ur5GLSkQm9I54cdJ//ao6dCrLj4OaJcMBfxOXkxDs
         HCwlU8jv7fO8m0EzNpLKigNHyZvGgzugtoaUcWr7U0T0znUJi0anQTNA+krbW6C24xDb
         no8BC9rWbTEpXWhlyb1kML5W7slw+NpGmo1QXQ4FQm0UC8lPB3zevRtuXfPAoj1zM8M7
         CjHA==
X-Gm-Message-State: APjAAAX1nKUoUWHrVnlXMpuDbMwqjnEQAQG6algbVQVRR8PXWuRB/qhm
        YzxAhs9M8TMv7etrijiTHxZ1o4EVoRPm5A==
X-Google-Smtp-Source: APXvYqyqBz0nGRAjKV+m3kM7SclenblYL95IjbI1L9vyIUIFeV734yYIiOAY5wr2W4RyUZPDYp/fHQ==
X-Received: by 2002:adf:f481:: with SMTP id l1mr47301012wro.123.1566469498955;
        Thu, 22 Aug 2019 03:24:58 -0700 (PDT)
Received: from mba13.lan (adsl-91.109.242.50.tellas.gr. [109.242.50.91])
        by smtp.gmail.com with ESMTPSA id f17sm3700130wmj.27.2019.08.22.03.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 03:24:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH cryptodev buildfix] crypto: s390/aes - fix typo in XTS_BLOCK_SIZE identifier
Date:   Thu, 22 Aug 2019 13:24:54 +0300
Message-Id: <20190822102454.4549-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix a typo XTS_BLOCKSIZE -> XTS_BLOCK_SIZE, causing the build to
break.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
Apologies for the sloppiness.

Herbert, could we please merge this before cryptodev hits -next?

 arch/s390/crypto/aes_s390.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index a34faadc757e..d4f6fd42a105 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -586,7 +586,7 @@ static int xts_aes_encrypt(struct blkcipher_desc *desc,
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
-	if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCKSIZE) != 0))
+	if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCK_SIZE) != 0))
 		return xts_fallback_encrypt(desc, dst, src, nbytes);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
@@ -600,7 +600,7 @@ static int xts_aes_decrypt(struct blkcipher_desc *desc,
 	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
 	struct blkcipher_walk walk;
 
-	if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCKSIZE) != 0))
+	if (unlikely(!xts_ctx->fc || (nbytes % XTS_BLOCK_SIZE) != 0))
 		return xts_fallback_decrypt(desc, dst, src, nbytes);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
-- 
2.17.1

