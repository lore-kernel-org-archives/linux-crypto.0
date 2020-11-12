Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE3C9C2D0E4
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 20:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31B112085B
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 20:07:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="myhEdHA1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgKLUHP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Nov 2020 15:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgKLUHP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Nov 2020 15:07:15 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC0DC0613D1;
        Thu, 12 Nov 2020 12:07:13 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id t5so5031567qtp.2;
        Thu, 12 Nov 2020 12:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E6ppXCmiSFyh9upyqD1fFw+i5gNBFjv39zREmHQXKsI=;
        b=myhEdHA1B+Ej9tlUM2QY462pQS+lE1+d0F8YJn7uklWfzytdxoWcCAY7P0ddXLrRDi
         088d1KYqblvd+TKWi/We+OXgH4RO15ateqbXuxp4CoAvzm3O+hPOUOZ7ImTo2JOmpbGi
         8J9V5W+0hjdMa/khKXfNGf7ULDi7+Zda1GOng3kRHW41Qbdd4wsQ7CqSLBM0bjijzqN8
         NINcJQ6a6UqrCowsKdOYlXdfLe03nnMuwJZWruePkHy76YQcsHc4Iv7k5ymP2Ezf0xix
         vCFRlGzW0Yj5bFx2udjeoppzzSLw5hZBr1AkWmvrrHcgzCJtu5ESuScfXAmTGRYn9See
         wh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E6ppXCmiSFyh9upyqD1fFw+i5gNBFjv39zREmHQXKsI=;
        b=Z9Dk8jG9J0XkRkFJUXYidVKgxjsJ+TTnof3DluRSoKoocNXxcpriGdyG5g4HSdg/vM
         bKHQGz2X2HynVSiSUjjoC3Tl1dZ7GdQE2cTk9Tj1Y8IW/1BZi4/++YdNbnCATExWM5v3
         q4fmUDClZer7MZPHh4Emg5y2mnszviU1zxjqrRTfDPn3M+9GZEk8Qu5dkdosm1dOPdcT
         W+VoyFQFVxoMZwXEc0/abDHFFNdXylQQxcEDCThck4nTwjv2mnt41VscoZZa2A4RWeTy
         E/Y69xm4AAF2ocnZcie28p8srFfTKZPg40ri7wD0ND+la2RtGwpxW4FnyxUkQ4eG9OFi
         s6eQ==
X-Gm-Message-State: AOAM531lphbQfG7uwHVjTzJd8+3kLow237+bioUIiVnB8kmp6pN4ibbe
        hWvFCCcSsBfSjHy4nyRw1N4mTyVFyQiCDg==
X-Google-Smtp-Source: ABdhPJyK2VTdheMhc7GlPstCpcPRnyiVHSljX9I6UvY8La8RTbcrrIwralXAX9uEeXERp6sXedo/Iw==
X-Received: by 2002:ac8:75da:: with SMTP id z26mr933380qtq.36.1605211632407;
        Thu, 12 Nov 2020 12:07:12 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id 207sm700295qki.91.2020.11.12.12.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 12:07:11 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] crypto: crypto4xx - Replace bitwise OR with logical OR in crypto4xx_build_pd
Date:   Thu, 12 Nov 2020 13:07:02 -0700
Message-Id: <20201112200702.1664905-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Clang warns:

drivers/crypto/amcc/crypto4xx_core.c:921:60: warning: operator '?:' has
lower precedence than '|'; '|' will be evaluated first
[-Wbitwise-conditional-parentheses]
                 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^
drivers/crypto/amcc/crypto4xx_core.c:921:60: note: place parentheses
around the '|' expression to silence this warning
                 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
                                                                         ^
                                                                        )
drivers/crypto/amcc/crypto4xx_core.c:921:60: note: place parentheses
around the '?:' expression to evaluate it first
                 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
                                                                         ^
                 (
1 warning generated.

It looks like this should have been a logical OR so that
PD_CTL_HASH_FINAL gets added to the w bitmask if crypto_tfm_alg_type
is either CRYPTO_ALG_TYPE_AHASH or CRYPTO_ALG_TYPE_AEAD. Change the
operator so that everything works properly.

Fixes: 4b5b79998af6 ("crypto: crypto4xx - fix stalls under heavy load")
Link: https://github.com/ClangBuiltLinux/linux/issues/1198
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 981de43ea5e2..2e3690f65786 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -917,7 +917,7 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 	}
 
 	pd->pd_ctl.w = PD_CTL_HOST_READY |
-		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) |
+		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AHASH) ||
 		 (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
 			PD_CTL_HASH_FINAL : 0);
 	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);

base-commit: f8394f232b1eab649ce2df5c5f15b0e528c92091
-- 
2.29.2

