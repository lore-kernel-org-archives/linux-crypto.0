Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB87BC433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 13:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADFCE214F1
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 13:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgHZNZr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 09:25:47 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39165 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbgHZNZq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 09:25:46 -0400
Received: by mail-lj1-f194.google.com with SMTP id v9so2341174ljk.6
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2020 06:25:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rkb8UGFOuSR99GBMzJc4tfKvf9BH0mXjbOlM0/9ubsU=;
        b=V7ap62wvsXFqM4kXUawF/XtScohWFcyDX9iHw8sUScSJXCKrUd85ddNf9CW3KfniVk
         LAMJ2RfLtKtD0SyUsa90dVGe8W777iJw26QONXc9pzvOUM/8138aHJYi220dsoQA7ip1
         KIzDFFcVctwwnaVnHFGvF/MdtrBlPdYwwH/cOZhZaMa9r1sm1sCq8DFc//66mzJQMFvh
         9TrfwsY+5hSkYDJZab1MRdIKFNrzKUYo94LxIIb1wem5hL3eX/8k7uHYmozmRbNNrtZm
         p7pcqqjVGzjmEEtCdapF1t5roE8Y0zFbPRLuwx/a+/kq1fRhZ0rfk878BkTraWYt6aEi
         Kx5Q==
X-Gm-Message-State: AOAM532N5f6lhh4qM/ZuOmfQm5ucd8RObbq+19pim1dNfVEjMSyk+5Fp
        LtgES8wb0oKVjZ91xudM4+FWdCnpX8E=
X-Google-Smtp-Source: ABdhPJx7lt+ef1h4+hJp6CG98ZmujY+qwemuHUuyeWc7tNGeVYMkoCgmeNRLACmr66Cvjczrba7IcA==
X-Received: by 2002:a2e:98d7:: with SMTP id s23mr6398726ljj.117.1598448343537;
        Wed, 26 Aug 2020 06:25:43 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id v10sm573402lfo.11.2020.08.26.06.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 06:25:43 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-crypto@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: sun8i-ce - use kfree_sensitive()
Date:   Wed, 26 Aug 2020 16:25:37 +0300
Message-Id: <20200826132537.398778-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use kfree_sensitive() instead of open-coding it.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index b4d5fea27d20..970084463dbb 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -367,8 +367,7 @@ void sun8i_ce_cipher_exit(struct crypto_tfm *tfm)
 	struct sun8i_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
 
 	if (op->key) {
-		memzero_explicit(op->key, op->keylen);
-		kfree(op->key);
+		kfree_sensitive(op->key);
 	}
 	crypto_free_skcipher(op->fallback_tfm);
 	pm_runtime_put_sync_suspend(op->ce->dev);
@@ -392,8 +391,7 @@ int sun8i_ce_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		return -EINVAL;
 	}
 	if (op->key) {
-		memzero_explicit(op->key, op->keylen);
-		kfree(op->key);
+		kfree_sensitive(op->key);
 	}
 	op->keylen = keylen;
 	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
@@ -417,8 +415,7 @@ int sun8i_ce_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		return err;
 
 	if (op->key) {
-		memzero_explicit(op->key, op->keylen);
-		kfree(op->key);
+		kfree_sensitive(op->key);
 	}
 	op->keylen = keylen;
 	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
-- 
2.26.2

