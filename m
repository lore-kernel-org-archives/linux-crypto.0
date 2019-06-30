Return-Path: <SRS0=31iC=U5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC440C5B57E
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Jun 2019 16:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9510620665
	for <linux-crypto@archiver.kernel.org>; Sun, 30 Jun 2019 16:50:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q94vcS7+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfF3Quq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 30 Jun 2019 12:50:46 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38965 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF3Qup (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jun 2019 12:50:45 -0400
Received: by mail-lf1-f68.google.com with SMTP id p24so7119442lfo.6
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jun 2019 09:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FsynkDGHcI3FuVlz//acB7VJ0fqaGYFF4yMXPjLoHBk=;
        b=q94vcS7+PDwg+NvpbLTHSA6TF5ZT+Ku0WDmm/kSnlTP1PpJd2jEun+/YBzQ6RIS850
         WDRnhT6JEH4DCJ+vZLPJOnB7Az4647wrrodVTgPXwL5YutdCtsArpzIxWUC3iGU1W4/B
         /25Fgfcsqa0XcovPAIbaoyNIgOI2NOk3Pty8++oNKVnka7ffC+BusQ4isvVwA3PppENS
         y0MMlop0caZcG6zaZOojuNQWTP5F6GMqLd1B4RJ8ln5TU0ENU0jvpaeNFM38ytsa0xit
         zMMC6Hc1BSodA1XKsld0QcCPvBDefZ5iYx5j9Fwn7jvtoQSZqc17xGH34TscZldjsp1Q
         QPqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FsynkDGHcI3FuVlz//acB7VJ0fqaGYFF4yMXPjLoHBk=;
        b=js23PrJ42wSvE7RlWSrwZuU6Igu8bw2lgnvIXfjClzphh9hnB7q4Ii7r3y7J/izNHP
         yE+yjcwyhbUtzOjwrHhdQ5LmezRIyuQCyzDpQsoIZbhfNRKAmtBFxqV1PEMN1JAmdTBp
         FFr6tPY9MJnnPLGPOBRF3eZ59P4Iszj1QCpKzPI1HWzn18GxOu+SlC5vwkpmxz9JFBIo
         THBpOTt9SL9SWzTevpeVy6PnIpvPK7OpiOnOBebQcOuknpb8fzm59GPlrPd4JvV4K38F
         USM7deqWsGA60rc+uZtj8hgI0V+hpZOwrTYl7//zUVkFFDTZQZ50c96oLBTtbT2f6HTW
         gBJg==
X-Gm-Message-State: APjAAAWh1UOuPqQC5WKy4QPB3Q66hmnbNyh73kAtDRCD3k0CczEbtmWC
        vTFGMSUIujCjaCLFdMNxsL/IQWxidi7hNA==
X-Google-Smtp-Source: APXvYqxiXtJrt763IpJKENa95JV7UfFChVSjN+nMWt+NBPHSgZucDsGpoRAWzSyiPAkWWi7QHDRD6Q==
X-Received: by 2002:ac2:558a:: with SMTP id v10mr10075831lfg.41.1561913443596;
        Sun, 30 Jun 2019 09:50:43 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id t15sm2097367lff.94.2019.06.30.09.50.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 30 Jun 2019 09:50:42 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@arm.com>,
        Eric Biggers <ebiggers@google.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve Capper <steve.capper@arm.com>,
        Milan Broz <gmazyland@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 3/7] crypto: aegis128 - drop empty TFM init/exit routines
Date:   Sun, 30 Jun 2019 18:50:27 +0200
Message-Id: <20190630165031.26365-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190630165031.26365-1-ard.biesheuvel@linaro.org>
References: <20190630165031.26365-1-ard.biesheuvel@linaro.org>
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
2.17.1

