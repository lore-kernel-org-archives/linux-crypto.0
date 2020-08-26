Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B4EC433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 13:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4D79208E4
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 13:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgHZNRF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 09:17:05 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37783 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729177AbgHZNRE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 09:17:04 -0400
Received: by mail-lj1-f193.google.com with SMTP id w14so2317761ljj.4;
        Wed, 26 Aug 2020 06:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vU/nQo+UBNG9xvKd9GuEpi2FmWTAJodJN80NdTSBLAk=;
        b=RcwuyWIef/Gt4ktGODHegTfBG33CSLzdiIcLnJOlH7LU/w6HDbC8xNHQ/RFczUqRhT
         6MqKlpU7s97d7AiekXg23QuheGTPO3QXKK/AQrFtX1ajv74ovFprZF/B9JOuIa9bc+h8
         ZLE2bqw2Re1SjHE8/YAkcTqXALSBvwQi4fWHkN2jdpSfAympAohm4/4KS5y2EIFmVUrq
         DtVnETyAxU3crAwQjgvji2xkdLVoZl/N+54Z7v4hmBspKjCteNGzqVjs9p4/aQN0UwLm
         AfV/qfnqqR9GvRY4/aq2Vp+EXt3l6HDNBoySrvEBzxr/cTj4v/7yLTRvUeglB+n6+Cex
         +vcg==
X-Gm-Message-State: AOAM530dtR87XfEYg8GYfRqAg75Cmw7LU/2sp/PJpSyBkLddjAFsQgKC
        IeojRspkEHMXFuNrbtlAKFHV+aFWurI=
X-Google-Smtp-Source: ABdhPJz7tHUoM8nJr9czWl1gcdQGwvnPgBvglHx5FCWqpeWj9hP2LVpyXxO/BRHRRUxT/7MnePBLcQ==
X-Received: by 2002:a05:651c:152:: with SMTP id c18mr6508091ljd.15.1598447821446;
        Wed, 26 Aug 2020 06:17:01 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id u19sm496556ljj.128.2020.08.26.06.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 06:17:00 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-crypto@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: amlogic - use kfree_sensitive()
Date:   Wed, 26 Aug 2020 16:16:57 +0300
Message-Id: <20200826131657.398090-1-efremov@linux.com>
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
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index d93210726697..f3dca456d9f8 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -341,8 +341,7 @@ void meson_cipher_exit(struct crypto_tfm *tfm)
 	struct meson_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
 
 	if (op->key) {
-		memzero_explicit(op->key, op->keylen);
-		kfree(op->key);
+		kfree_sensitive(op->key);
 	}
 	crypto_free_skcipher(op->fallback_tfm);
 }
@@ -368,8 +367,7 @@ int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		return -EINVAL;
 	}
 	if (op->key) {
-		memzero_explicit(op->key, op->keylen);
-		kfree(op->key);
+		kfree_sensitive(op->key);
 	}
 	op->keylen = keylen;
 	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
-- 
2.26.2

