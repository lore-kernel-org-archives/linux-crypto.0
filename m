Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 529A6C49ED7
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 21:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22D3C21907
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 21:33:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oQHv0p38"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390274AbfISVdc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 17:33:32 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43344 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390087AbfISVdb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 17:33:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id c3so6142817qtv.10
        for <linux-crypto@vger.kernel.org>; Thu, 19 Sep 2019 14:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xd9djg4ZRInQK4PJ0owr0vHD3gVJUKPRxwMSxJDmg4o=;
        b=oQHv0p38vP/Ijcd+wWuwLDNq2oI/EpvE62fN3fdohzueHvB0bay02mwhPmLazeuRZE
         zEUlAOLbwKrg22kmyt1+0rXYaA18MzehZTZ9K5yWRNDuKc9sD0YY3GzfzYfPlJXZvtMR
         uKF3/eDcYQmOhH2dctAMJc31sa1r+EagiwEGO8ploVlUepvmXa480h60KNhdBhLa+jK7
         k9yMK+XG+zf12LH7rIr72mN4v7e0PRky5OJtBZMYH/BrTvkexNAFMSGkS5ccuHKUcds9
         iqiYF+69RhJLdK75JUECDy/WNa5weazuy+lsIjJQKyN01/NzbeXAV9S6OTqLaU3SSy/b
         oQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xd9djg4ZRInQK4PJ0owr0vHD3gVJUKPRxwMSxJDmg4o=;
        b=Qi9L/T/ohNeywqk2CNrh1PNDkR4pAObGGfCQeWQn5EU8L/UxuJikvT+DL91RU8m1vi
         Ogk4EKiEcUMENyg724MqHCvFeqowBJzHOBZzyvGakfqk/v+QDQsdbY1Ob0xCGGMtoI3s
         1OZHjea5Rk/kYWeYg13vOmS7MTSqXJoQyicZxQ6HgHmGTkPF0VEQdo3FDrhF84ZeCa7W
         x0eJejhCa+aZKaDjtJmRZwLipeKT/I8UlDY2GFZ1zKxKQ3kmQdeE8klTTel7rCk9L4JC
         opsQVhO1WM7v0CSswHrT/fHrPOeCjgviM9Bd1UTJZnm5jxU+vBgO7z6IypzU/tlUhNal
         kkGA==
X-Gm-Message-State: APjAAAVqlyUxjxbOX7VHVsdDkJxMw05zLJ9EOR/K6sfi/m5oVYrfEtXV
        pNEplOErZZgbxHCv7E0OMRQ=
X-Google-Smtp-Source: APXvYqw9E/c51b0XjHTLXttNPW8SPW46/35SI0KXUVVpHjxBjzeLniXFzNFLVjwU9dxnH3ZoeFqtlQ==
X-Received: by 2002:ad4:4382:: with SMTP id s2mr9808785qvr.90.1568928810270;
        Thu, 19 Sep 2019 14:33:30 -0700 (PDT)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id t40sm6031805qta.36.2019.09.19.14.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 14:33:29 -0700 (PDT)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Eneas U de Queiroz <cotequeiroz@gmail.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: qce - add CRYPTO_ALG_KERN_DRIVER_ONLY flag
Date:   Thu, 19 Sep 2019 18:33:02 -0300
Message-Id: <20190919213302.9174-1-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Set the CRYPTO_ALG_KERN_DRIVER_ONLY flag to all algorithms exposed by
the qce driver, since they are all hardware accelerated, accessible
through a kernel driver only, and not available directly to userspace.

Signed-off-by: Eneas U de Queiroz <cotequeiroz@gmail.com>

diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index 7a98bf5cc967..f0b59a8bbed0 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -380,7 +380,7 @@ static int qce_ablkcipher_register_one(const struct qce_ablkcipher_def *def,
 
 	alg->cra_priority = 300;
 	alg->cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER | CRYPTO_ALG_ASYNC |
-			 CRYPTO_ALG_NEED_FALLBACK;
+			 CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_KERN_DRIVER_ONLY;
 	alg->cra_ctxsize = sizeof(struct qce_cipher_ctx);
 	alg->cra_alignmask = 0;
 	alg->cra_type = &crypto_ablkcipher_type;
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 0853e74583ad..95ab16fc8fd6 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -495,7 +495,7 @@ static int qce_ahash_register_one(const struct qce_ahash_def *def,
 	base = &alg->halg.base;
 	base->cra_blocksize = def->blocksize;
 	base->cra_priority = 300;
-	base->cra_flags = CRYPTO_ALG_ASYNC;
+	base->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
 	base->cra_ctxsize = sizeof(struct qce_sha_ctx);
 	base->cra_alignmask = 0;
 	base->cra_module = THIS_MODULE;
