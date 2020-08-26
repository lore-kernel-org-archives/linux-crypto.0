Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69090C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 13:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47D4621741
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 13:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgHZNZG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 09:25:06 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38111 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbgHZNZF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 09:25:05 -0400
Received: by mail-lf1-f67.google.com with SMTP id k10so977456lfm.5
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2020 06:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GXD+w9Y3wUdFkrAipgBiJuVffVg3UlyXwVKrdNA82vA=;
        b=YtHZsfnaWWCyhkkf+J7Jgm9BKptbAUuKVU+uO4pob/ELgJ56DoT9nwTa30iFIAO4bV
         DgROp/Mz2vNFhT4c5X4628U4r3rF7OctSgLs0SARz7r5VwGrQlBl6wur4bztElBiN4de
         hxPjprQIHoBiOBqk0T2rR12b6JJR+46cEHHkDpJtxqw5r+jQvQJMbcY2Vs2jIZj0ss45
         2QozetMAOmO1H9kXt3VYbqHWzDpfyeWMbDWmxZPPaTCCy4NmQWGFi/wxqyyMjQNE6Hhp
         tVv7lgQO3thJR67JuEEr6MlUgA/pcPPUwKnMJJnVVLkMEvSbxD+bTQ+QBZ9uLpoKruP/
         kc8w==
X-Gm-Message-State: AOAM533gUnzoAgK03cAzDXt453keUIaJtljMUKYG3eWd9jZbUrcnEpN6
        AfniiH/ktszRtBAGIsXsmNXYmI93u54=
X-Google-Smtp-Source: ABdhPJyOJOXtq1gQ3XSSxKnxDCUmRp7BZJUg46VcIpI2J2MNXCTOZKdXcG/+iLhT8Qidu2rkM/LCfQ==
X-Received: by 2002:a05:6512:3189:: with SMTP id i9mr4732243lfe.41.1598448301710;
        Wed, 26 Aug 2020 06:25:01 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id i26sm506856ljj.102.2020.08.26.06.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 06:25:00 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-crypto@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: sun8i-ss - use kfree_sensitive()
Date:   Wed, 26 Aug 2020 16:24:51 +0300
Message-Id: <20200826132451.398651-1-efremov@linux.com>
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
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 7b39b4495571..49d89b31eb6b 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -369,8 +369,7 @@ void sun8i_ss_cipher_exit(struct crypto_tfm *tfm)
 	struct sun8i_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
 
 	if (op->key) {
-		memzero_explicit(op->key, op->keylen);
-		kfree(op->key);
+		kfree_sensitive(op->key);
 	}
 	crypto_free_skcipher(op->fallback_tfm);
 	pm_runtime_put_sync(op->ss->dev);
@@ -394,8 +393,7 @@ int sun8i_ss_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		return -EINVAL;
 	}
 	if (op->key) {
-		memzero_explicit(op->key, op->keylen);
-		kfree(op->key);
+		kfree_sensitive(op->key);
 	}
 	op->keylen = keylen;
 	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
@@ -420,8 +418,7 @@ int sun8i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
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

