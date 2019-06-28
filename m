Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3965C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A85A82083B
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 17:08:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c9j2Zutu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfF1RIM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 13:08:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54980 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfF1RIL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 13:08:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id g135so9787880wme.4
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 10:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pjc8Ij8Y09mce/aaMgeAqNcF4yfEEvBFQu5xP/Kzcq0=;
        b=c9j2Zutu9EDcMb85IPhR5HkDdANRDstVkiyHsSpnOcRWQmiVwa1yp/za76vAByLKu5
         lUb8St0oxflWXOkf+vGYITkcz95Ptr00nmWX6E965gzxTG0VePtCJcGeVb2VlC/pD6t5
         iBBcj7NjAfOCnk8pjSYl/UK2oTw1NuPjZwGrhHLhm7fV0xjafhLohy42ZHu1Xf3SVMsX
         5f1J2369gmMZaQDttUrNwnJp0ZPk7yiEnWeMiHoGzV1x3YU23Z70G4KD//3tSOFOkuNo
         x2KpzGpX7VqQGW9beDDToU9rg6sSi72yfYO0Rwtj310cdTwpDjpJuAmX7Gh68zXb1jRO
         G29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pjc8Ij8Y09mce/aaMgeAqNcF4yfEEvBFQu5xP/Kzcq0=;
        b=nkyGzxUeKuWsz12KpWQQLSZ4I/Wra/1jV2ZI+A2ehsUv4gyrohVmAc49czt9qPuTbN
         A/MgRdDkFkZcl/0I/AJmEgBUzF/UOyo1KpAIQbgLKi3hKH3uBiINPT5QRnpLTxB0EUN/
         4yJ6Ohkn7b0dOe186bRnjvkjyDoEBpd3nteYlYE0trEx2v4r3MxxS9T/7eh6FsVRwN9t
         joXSvoEHU8PGy28JoDSvy4BQU4f/rWHIhW52KdtZx9sMF7DzEhCeHuxBucCyVWi2QjWv
         08tnfajeGFOcgOKtqvMkKdazLgsi3UJh1EC3i8nBNFLKVW4z5jn6vpMZ28e0F0ipf9OP
         beYQ==
X-Gm-Message-State: APjAAAW1pGydBhOakdUI62gl35KyVYR1M4h18CcHeBV1a/cfO7sFkoT7
        3Qb0SHwemWv+1jnbyG1LQgAPL7pTb+Q8Lg==
X-Google-Smtp-Source: APXvYqwLaETLiUc1Czgw6dXi9KzDjfBwY08P7Ie69exDBXfWLwkoFKXyfLjsq/nt2LQkxfmj/4A12A==
X-Received: by 2002:a1c:c706:: with SMTP id x6mr7785707wmf.162.1561741689443;
        Fri, 28 Jun 2019 10:08:09 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id c15sm3833251wrd.88.2019.06.28.10.08.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 10:08:08 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v2 3/7] crypto: aegis128 - drop empty TFM init/exit routines
Date:   Fri, 28 Jun 2019 19:07:42 +0200
Message-Id: <20190628170746.28768-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628170746.28768-1-ard.biesheuvel@linaro.org>
References: <20190628170746.28768-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

TFM init/exit routines are optional, so no need to provide empty ones.

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aegis128.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/crypto/aegis128.c b/crypto/aegis128.c
index d78f77fc5dd1..32840d5e7f65 100644
--- a/crypto/aegis128.c
+++ b/crypto/aegis128.c
@@ -403,22 +403,11 @@ static int crypto_aegis128_decrypt(struct aead_request *req)
 	return crypto_memneq(tag.bytes, zeros, authsize) ? -EBADMSG : 0;
 }
 
-static int crypto_aegis128_init_tfm(struct crypto_aead *tfm)
-{
-	return 0;
-}
-
-static void crypto_aegis128_exit_tfm(struct crypto_aead *tfm)
-{
-}
-
 static struct aead_alg crypto_aegis128_alg = {
 	.setkey = crypto_aegis128_setkey,
 	.setauthsize = crypto_aegis128_setauthsize,
 	.encrypt = crypto_aegis128_encrypt,
 	.decrypt = crypto_aegis128_decrypt,
-	.init = crypto_aegis128_init_tfm,
-	.exit = crypto_aegis128_exit_tfm,
 
 	.ivsize = AEGIS128_NONCE_SIZE,
 	.maxauthsize = AEGIS128_MAX_AUTH_SIZE,
-- 
2.20.1

