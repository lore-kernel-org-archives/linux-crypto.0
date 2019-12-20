Return-Path: <SRS0=juXm=2K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D25C43603
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CC96206D8
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 19:03:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GjOofQD/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbfLTTDN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Dec 2019 14:03:13 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42326 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727390AbfLTTDM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Dec 2019 14:03:12 -0500
Received: by mail-pf1-f193.google.com with SMTP id 4so5705439pfz.9
        for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2019 11:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k9VHXoez7FZfV4pIIvUMPzblEmmwCwWAxaZpHU4B+7o=;
        b=GjOofQD/GmW4vYJvez9BqInw0uQfcV+qDSNSfuAXt+OQ+d8N3UQy2ZKwFrSn7c6x9B
         myzur66DozRkTCuDkKyCB07fdKoLwTxM3yzjIVJsNib19Q9yHEwVmiP0wQJTThlaqP9i
         QJCXP9FcpgCCDj4D2Km8063mAMJZGNInj6r/fcbJIu8CJeXivhbf4yiH6DEmKNj/Gen2
         RWimY+zPu+gY/aBkLzC6cts/g2wxGYRxblS6FAx92TcC6WMiPw9+q1G5d5dtwDeHmeHE
         Y+8h9p+7f8tNqRiAkR+b9DjWryrJ/IP6r+7xpx7Gd/Xz+jN98DOOjJV6lYOUDq4mMdlU
         a3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k9VHXoez7FZfV4pIIvUMPzblEmmwCwWAxaZpHU4B+7o=;
        b=m8MF568SRQQVPd1nYd64OqFGgF044hKxXDFcTiRkGSV3qv5kt5UaT+FH2yenQQ2Rm/
         jxresQeyHlGYiPhn7CJcTrkDyslpJhhqUWyNqlEple7uXJGvWpOhfkQHWapgNW/LwsQ0
         p3xHCkbloJe+/0Q54O8zRl1aTQAkm61AspSvJ3N8zhR+VRm4Wy49LXdSZRAMmZ9+a/y1
         mGul9IMHe0pwJdE+iGqSlEW1aDJy6pTK4BpAIRHu6vGsMhDTM9oNFchwXAc6zap7V3t4
         uQRwAVDsq4IcupPOyhJU2PCN7PcaFHq2T83eFDN5OYbr/NSWln/iK4YvF6jypRJH/1H2
         5xvw==
X-Gm-Message-State: APjAAAVgcNDQZiKMTfr7anYXybomMzUHBDshT1uNUnwFHkYeZ4K0rBSi
        tRAH5Sg41MhKqmOcBxOhJN2oQxvXzOc=
X-Google-Smtp-Source: APXvYqwyJRqy9ByNaKLL4SnNmJ3K6ABI5BKC3KmNdi7gg6gBXU1tbmXnlYW3JBKKP3S4mEwBPndDXg==
X-Received: by 2002:a62:2a12:: with SMTP id q18mr18410054pfq.203.1576868592064;
        Fri, 20 Dec 2019 11:03:12 -0800 (PST)
Received: from gateway.troianet.com.br (ipv6.troianet.com.br. [2804:688:21:4::2])
        by smtp.gmail.com with ESMTPSA id i4sm10833612pjw.28.2019.12.20.11.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 11:03:10 -0800 (PST)
From:   Eneas U de Queiroz <cotequeiroz@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     Eneas U de Queiroz <cotequeiroz@gmail.com>
Subject: [PATCH 5/6] crypto: qce - initialize fallback only for AES
Date:   Fri, 20 Dec 2019 16:02:17 -0300
Message-Id: <20191220190218.28884-6-cotequeiroz@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191220190218.28884-1-cotequeiroz@gmail.com>
References: <20191220190218.28884-1-cotequeiroz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adjust cra_flags to add CRYPTO_NEED_FALLBACK only for AES ciphers, where
AES-192 is not handled by the qce hardware, and don't allocate & free
the fallback skcipher for other algorithms.

Signed-off-by: Eneas U de Queiroz <cotequeiroz@gmail.com>
---
 drivers/crypto/qce/skcipher.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index d3852a61cb1d..4217b745f124 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -257,7 +257,14 @@ static int qce_skcipher_init(struct crypto_skcipher *tfm)
 
 	memset(ctx, 0, sizeof(*ctx));
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct qce_cipher_reqctx));
+	return 0;
+}
 
+static int qce_skcipher_init_fallback(struct crypto_skcipher *tfm)
+{
+	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	qce_skcipher_init(tfm);
 	ctx->fallback = crypto_alloc_sync_skcipher(crypto_tfm_alg_name(&tfm->base),
 						   0, CRYPTO_ALG_NEED_FALLBACK);
 	return PTR_ERR_OR_ZERO(ctx->fallback);
@@ -387,14 +394,18 @@ static int qce_skcipher_register_one(const struct qce_skcipher_def *def,
 
 	alg->base.cra_priority		= 300;
 	alg->base.cra_flags		= CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_NEED_FALLBACK |
 					  CRYPTO_ALG_KERN_DRIVER_ONLY;
 	alg->base.cra_ctxsize		= sizeof(struct qce_cipher_ctx);
 	alg->base.cra_alignmask		= 0;
 	alg->base.cra_module		= THIS_MODULE;
 
-	alg->init			= qce_skcipher_init;
-	alg->exit			= qce_skcipher_exit;
+	if (IS_AES(def->flags)) {
+		alg->base.cra_flags    |= CRYPTO_ALG_NEED_FALLBACK;
+		alg->init		= qce_skcipher_init_fallback;
+		alg->exit		= qce_skcipher_exit;
+	} else {
+		alg->init		= qce_skcipher_init;
+	}
 
 	INIT_LIST_HEAD(&tmpl->entry);
 	tmpl->crypto_alg_type = CRYPTO_ALG_TYPE_SKCIPHER;
