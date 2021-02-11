Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3DCC433E6
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD89064E4D
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhBKUFc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Feb 2021 15:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhBKUDS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Feb 2021 15:03:18 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F25AC061356
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:37 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id j3so169158qkk.9
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QVxt07NhH8i9s6gtmli+U/sos51ULXBrf5Wyl507Yss=;
        b=VpBxqcUzxTQuw+QYAmzO4hctY0VmJspmo6/IK/9FR6aVlrjGAJGeIxkEzHKiNBkGFP
         ByDXFmIKqkDmKiOCN6tslPbHpuitSWg/mkXhyS9G7cK+AIQtliCkrQl26BZETz4kWxWZ
         SmQeMhN+G1Ond83VwI3HEn/gx72dnkCp+B5ppeup4rY0CBAe5pgP6nAsXyv+Mzoi88Kp
         0dpgb/sc2TIfSun2TY47DZ+mWujQHHUB1xRG5CI7/NnpueQNOinA5l+DKnI4ftTcxNKW
         1tQF+yP3VXen3hJVKLNmZw7wPlS02sN7ID2Enj4xS3hcAE/Tvbzj0jUFk3pSNOwqrQOA
         SMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QVxt07NhH8i9s6gtmli+U/sos51ULXBrf5Wyl507Yss=;
        b=f+xzResRMARSkyGc4Jp2r6R13h+4qkL7DnoC6F5wQVFxELLO5PDVwSTllCmC8qwhW4
         H3woD4ffha5mCXk97IYCb6rDZOijtXNLkeblGD0ni6KOFmWWer2Lz98g0IrGCBTV7kDj
         jBAQwb8/3a778UhjiJSaAo2hqjsGvgl7MI+B4oPZprhL8bHLjJHqf9qCj8s7xAU7js0Q
         FslrpOOKKYexPQC2Cpr4vZnceodNqFB7UaCvhrCoOlCdxsGhU8rn2EksTE0F6Gmp1sKq
         Rlp736ni1TjdL9xo05BbeAx9zQ3Rjwipp0JoLlTV9VX7Piz57+2/28gtTzEVO85Sijij
         YWfA==
X-Gm-Message-State: AOAM533muOMMms5ipsDECBZncjsbhu0voGPhxFV0/Qbqwv9huriffuxa
        H5dSI3qrtWNQq0tXgeQhBU5x6w==
X-Google-Smtp-Source: ABdhPJxZmh8ro83WJhIR6p/rpciurw+BoKtlVT7oeK/pOCjeXKNk9PnPb350PyhBDMx5lgllk9cslA==
X-Received: by 2002:a05:620a:80e:: with SMTP id s14mr4872595qks.20.1613073696594;
        Thu, 11 Feb 2021 12:01:36 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id 17sm4496243qtu.23.2021.02.11.12.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 12:01:36 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 07/11] crypto: qce: skcipher: Set ivsize to 0 for ecb(aes)
Date:   Thu, 11 Feb 2021 15:01:24 -0500
Message-Id: <20210211200128.2886388-8-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211200128.2886388-1-thara.gopinath@linaro.org>
References: <20210211200128.2886388-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ECB transformations do not have an IV and hence set the ivsize to 0 for
ecb(aes).

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index c2f0469ffb22..11a2a30631af 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -353,7 +353,7 @@ static const struct qce_skcipher_def skcipher_def[] = {
 		.name		= "ecb(aes)",
 		.drv_name	= "ecb-aes-qce",
 		.blocksize	= AES_BLOCK_SIZE,
-		.ivsize		= AES_BLOCK_SIZE,
+		.ivsize		= 0,
 		.min_keysize	= AES_MIN_KEY_SIZE,
 		.max_keysize	= AES_MAX_KEY_SIZE,
 	},
-- 
2.25.1

