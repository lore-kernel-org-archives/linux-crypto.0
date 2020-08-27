Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18583C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 06:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F408622BEB
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 06:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgH0Go5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 02:44:57 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46841 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgH0Go5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 02:44:57 -0400
Received: by mail-lf1-f67.google.com with SMTP id v12so2310372lfo.13;
        Wed, 26 Aug 2020 23:44:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U2daWJJtrQ8PsrKDLxSLxHGhIi/TLSRYqSh0K45MS9k=;
        b=oHdvoJ/0/lFY8SMxEx/C9+T3TRFxUbeGHnr67+znByt0vYWOs0vZwpRkqyPmIcGomL
         DyjhJK5KUBQy/pfTxxehqc1YV6m3/OpcV6ansI/xRJo9l0OmOan6CsbBjUcPVqvso26R
         jyom61QMTyYhaArPrjNAa6RAwipTmbZtvcy8QI2J58XPU6j2IeouaoJzNoinoHO1u2Ap
         p4c0t3vSKTLtYXJfz2VqBTNdtOLjEMNl6bCtA3wnvetP6wx0JyZy36VqNcCG0eNJ7Q4g
         Rw0EHzOAR9ZVgbTHWEoCbZmzSCVrJUhZ5k5nxvKWmOZfcl8ZYxUX7HOwRBNiUcxw4l85
         /y7A==
X-Gm-Message-State: AOAM533t2RtDOf9i8yFW/Q7Mjtse61f+gacDmm9r6kx0LBnf4uTV6GMB
        7G4E7MkXNG0KQ3fbnz62Coim7mrbPnM=
X-Google-Smtp-Source: ABdhPJwbHFp7pHbWeaClnVmQcu9AS9yOPisalduB8kWsJrwOs0ES0P1+RaTzpqBw/lJlTh/RgwkRrA==
X-Received: by 2002:a19:3fc9:: with SMTP id m192mr1178911lfa.36.1598510694400;
        Wed, 26 Aug 2020 23:44:54 -0700 (PDT)
Received: from localhost.localdomain ([213.87.147.111])
        by smtp.googlemail.com with ESMTPSA id j17sm282159lfr.32.2020.08.26.23.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 23:44:53 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-crypto@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] crypto: amlogic - use kfree_sensitive()
Date:   Thu, 27 Aug 2020 09:44:00 +0300
Message-Id: <20200827064402.7130-3-efremov@linux.com>
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
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index d93210726697..ee5998af2fe8 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -340,10 +340,7 @@ void meson_cipher_exit(struct crypto_tfm *tfm)
 {
 	struct meson_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
 
-	if (op->key) {
-		memzero_explicit(op->key, op->keylen);
-		kfree(op->key);
-	}
+	kfree_sensitive(op->key);
 	crypto_free_skcipher(op->fallback_tfm);
 }
 
@@ -367,10 +364,7 @@ int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		dev_dbg(mc->dev, "ERROR: Invalid keylen %u\n", keylen);
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

