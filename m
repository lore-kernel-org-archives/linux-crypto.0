Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34321C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 06:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F86C20786
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 06:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgH0GpI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 02:45:08 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40307 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgH0GpC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 02:45:02 -0400
Received: by mail-lj1-f196.google.com with SMTP id 185so5150702ljj.7;
        Wed, 26 Aug 2020 23:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z1FtQqybTk7XeGKn+tbU1SxGG4A7Kn9b4E+VmVIA+4E=;
        b=QM0hma1AoivbeZTjGzIW4YhCx8nVHOSaSI1MOjB7VelmqZ53MhHZZ98537VNZYWkua
         YfqvI8NwNNGrZlJk1MKCTBsQvmGQJJHqpPI9TuwVaVgYdrOojZU2huKe23m9128My5UT
         nDr2LLnRloAAKHkLMusX/2R0hFkNaP7GDLjioIonO4auMgnuUTu5ma3uWkNJgtPItDog
         VmmiqAI08mITBXkX+Hdf5pz0cMGiXLURBeOC8MDIWfu8NvEtOMEt4IeA3tIo13H66BfF
         27grsA+hwqY65vFbkzpCiaGzHwG5sUKFUC9F4F1KVOKhDLDTchxygDmYatRPFE+GemOY
         NNOQ==
X-Gm-Message-State: AOAM532Zo41RZYhRTHGmNgPRDXbpGCswj67wr+2vCsdFlo6h5vMzuGHS
        8HbCHemuvSrC2WmnbQFhKhVbNaLFPjU=
X-Google-Smtp-Source: ABdhPJy/YgtnYLAzwc+zepGvHr3uKojbRx+/ttpKqGkFdWBQ+Mih5iRHExuBfwddNNTBXj4VSYR47g==
X-Received: by 2002:a2e:9284:: with SMTP id d4mr8696417ljh.64.1598510699078;
        Wed, 26 Aug 2020 23:44:59 -0700 (PDT)
Received: from localhost.localdomain ([213.87.147.111])
        by smtp.googlemail.com with ESMTPSA id j17sm282159lfr.32.2020.08.26.23.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 23:44:58 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-crypto@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] crypto: sun8i-ss - use kfree_sensitive()
Date:   Thu, 27 Aug 2020 09:44:02 +0300
Message-Id: <20200827064402.7130-5-efremov@linux.com>
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
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c   | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 7b39b4495571..deb8b39a86db 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -368,10 +368,7 @@ void sun8i_ss_cipher_exit(struct crypto_tfm *tfm)
 {
 	struct sun8i_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
 
-	if (op->key) {
-		memzero_explicit(op->key, op->keylen);
-		kfree(op->key);
-	}
+	kfree_sensitive(op->key);
 	crypto_free_skcipher(op->fallback_tfm);
 	pm_runtime_put_sync(op->ss->dev);
 }
@@ -393,10 +390,7 @@ int sun8i_ss_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		dev_dbg(ss->dev, "ERROR: Invalid keylen %u\n", keylen);
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
@@ -419,10 +413,7 @@ int sun8i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
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
-- 
2.26.2

