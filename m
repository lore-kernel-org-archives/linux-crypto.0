Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319D7C433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 06:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16EFC22BEF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 06:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgH0GpA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 02:45:00 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39546 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbgH0Go7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 02:44:59 -0400
Received: by mail-lj1-f193.google.com with SMTP id v9so5155814ljk.6;
        Wed, 26 Aug 2020 23:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RUri7ENtOA6E3nbBwyRZL4Lb7nWu+4vuwV8JISffe0c=;
        b=HqdjxUu29zCe9COxFjizuY1p2XJU205RQP5tCuo3B2B1rKg/uqbAIaEq2F6p8+DMCY
         H1q7xWOn8d1xwQ0p48Ze5S3tcMASIyX+oocRLsjs9f0hUhF7xUwRlPYOc8msUJjFZujP
         jwD4M+4OFCjYHNDEn4vir2gT8BAARGcckjDy1Z1CrGwoANmsPHEYIUJJ/one6wAEJAIj
         bCXcLFXIFqlq/Fw+I7cPtw+1KiiQtwdwTlDzWMW5qk/MEw4JOMIrdlLMmwVvs514ONGb
         W6tMyTJkDpYfD+Wg1+75H3DLjlit1kgB7rYAuOsSmko3I0o72qOegYz2rdIIaFDHeLRF
         dPRQ==
X-Gm-Message-State: AOAM531tSjDLaiQaPIFat0TlfvfwJdiagb4bwms+aAKLfVJUCxhA1LuT
        MGm4T1h3uEqTfRg3coipVW+B+cpTvTk=
X-Google-Smtp-Source: ABdhPJzetXiGDcGzoWj3Qw8pHSa891wJyQwdGm5qLgZohqV21khoqBOLbCMT1OVX+LXzgFKYmEJQ7g==
X-Received: by 2002:a2e:960a:: with SMTP id v10mr9136863ljh.416.1598510696659;
        Wed, 26 Aug 2020 23:44:56 -0700 (PDT)
Received: from localhost.localdomain ([213.87.147.111])
        by smtp.googlemail.com with ESMTPSA id j17sm282159lfr.32.2020.08.26.23.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 23:44:56 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-crypto@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] crypto: sun8i-ce - use kfree_sensitive()
Date:   Thu, 27 Aug 2020 09:44:01 +0300
Message-Id: <20200827064402.7130-4-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200827064402.7130-1-efremov@linux.com>
References: <20200827064402.7130-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use kfree_sensitive() instead of open-coding it.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c   | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index b4d5fea27d20..f996dc3d7dcc 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -366,10 +366,7 @@ void sun8i_ce_cipher_exit(struct crypto_tfm *tfm)
 {
 	struct sun8i_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
 
-	if (op->key) {
-		memzero_explicit(op->key, op->keylen);
-		kfree(op->key);
-	}
+	kfree_sensitive(op->key);
 	crypto_free_skcipher(op->fallback_tfm);
 	pm_runtime_put_sync_suspend(op->ce->dev);
 }
@@ -391,10 +388,7 @@ int sun8i_ce_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		dev_dbg(ce->dev, "ERROR: Invalid keylen %u\n", keylen);
 		return -EINVAL;
 	}
-	if (op->key) {
-		memzero_explicit(op->key, op->keylen);
-		kfree(op->key);
-	}
+	kfree_sensitive(op->key);
 	op->keylen = keylen;
 	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
 	if (!op->key)
@@ -416,10 +410,7 @@ int sun8i_ce_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	if (err)
 		return err;
 
-	if (op->key) {
-		memzero_explicit(op->key, op->keylen);
-		kfree(op->key);
-	}
+	kfree_sensitive(op->key);
 	op->keylen = keylen;
 	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
 	if (!op->key)
-- 
2.26.2

