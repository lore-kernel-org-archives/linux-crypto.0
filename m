Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA56C3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83AFD21881
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:43:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VwfQIv3n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730103AbfICQn4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:43:56 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35233 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbfICQnz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:43:55 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so9462501pgv.2
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 09:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pASuIHos0NrmENDZ2qsaTQ78g3KIF/aki90Q37gkm4s=;
        b=VwfQIv3n1+0mlkY5Im5NOS6y6VwYlW+pVg6UmlywFKZtFItpUJeig3EXyYYJ4gYNAf
         fGyVMFVtTKJs0FtpW71ypblZTRG8FEJKujnOxMjVhzZpWSO6CB3umOfNAj4jiHFat4Kx
         6hIBRYPEusst4yKt8vFjlddE97wTbdbaoCbQrjsm9hwX6RD7l+nMOXGJgwZuH0Rz18xP
         QyyJ33rpF1NNnPaVjal3uowUw7ULy1D5PPW+XIHK7nGVL8kJBbyUgKKkJYBcPX5kclGH
         SS82P3CeF2QJtWcC3j914qeel4g+GA4zOeq49wwnhn3FvibDM1LNVqdniCr66ha/7BFM
         FPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pASuIHos0NrmENDZ2qsaTQ78g3KIF/aki90Q37gkm4s=;
        b=g57fd3Bnii2P/5SWPHnejKvOH6oIm+xuDd4VbAzH7acQgwP5q50VYCNA+0aUJODBOh
         Uyp2Y8acCoRPiKDPY1QT1ko1fPi3zVkZoVnnHBAV9gfrCr0AMwAzel4Q1LCWPKUHkp34
         KiIslBaUMUOq89ljHg+O9V5G5WLa1OLfgtYkd1pnMF0W0ZF69KbghcUuodiZjtCfdDs0
         6K7Iz66tdvvqlyvy8ZpzA1eqSxNqLkzr6Up8JcnfeBa9yPNe1C9PLp8lxghzYaps49y9
         BcVHQDlc1XG9IM7kqVwnkcvRziU+QhPd6b2SnQtHlWH0aR6sZA1lMu0VPthZFh8kXWj2
         a+kw==
X-Gm-Message-State: APjAAAW5O3N4lZ5UrDqHb0jVdsPiESpD91K1dfw4iOgJZbfm+9AouHcr
        H8rcr4FDrOMqFXPaY4Bf0/Zm3uxZkKv+itfF
X-Google-Smtp-Source: APXvYqyraC7iIvrlISC8JuBbbumPQ2tSAMDDqc5yKhWrG8C8w2KoHgEeyb4C/Pc0CN7cnKEMXs4h2Q==
X-Received: by 2002:a63:6ec1:: with SMTP id j184mr31086603pgc.232.1567529034711;
        Tue, 03 Sep 2019 09:43:54 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id b126sm20311847pfb.110.2019.09.03.09.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 09:43:53 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 08/17] crypto: skcipher - add the ability to abort a skcipher walk
Date:   Tue,  3 Sep 2019 09:43:30 -0700
Message-Id: <20190903164339.27984-9-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
References: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

After starting a skcipher walk, the only way to ensure that all
resources it has tied up are released is to complete it. In some
cases, it will be useful to be able to abort a walk cleanly after
it has started, so add this ability to the skcipher walk API.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/crypto/internal/skcipher.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index d68faa5759ad..734b6f7081b8 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -148,6 +148,11 @@ int skcipher_walk_aead_decrypt(struct skcipher_walk *walk,
 			       struct aead_request *req, bool atomic);
 void skcipher_walk_complete(struct skcipher_walk *walk, int err);
 
+static inline void skcipher_walk_abort(struct skcipher_walk *walk)
+{
+	skcipher_walk_done(walk, -ECANCELED);
+}
+
 static inline void ablkcipher_request_complete(struct ablkcipher_request *req,
 					       int err)
 {
-- 
2.17.1

