Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72979C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A436208CA
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:49:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i589ezzq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406812AbfFLMs7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:48:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43857 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439221AbfFLMs7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:48:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so6668261wru.10
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rp2SyHztXuSc5EPDjn72803h6AQOk7vXYYLU7TdxcTM=;
        b=i589ezzqAAjlFViP74UzWJqZJFiqtT1FTmC1a0q0ImhT7u9tc+tCz60xh9CJLqUg8c
         UNA2tMsx9Yh1HnZlM21Aw5fUZlhYeViGelWAyjbm6p++n52DTRJpXRcZzw65FVgIjJqV
         OjBCZYAp5n3o3nQr3y/iU0RTpzpqIXaiPOVeiHghbqoDr2wiSK57WSDk3WeZfHGfj/bK
         zsIRzC2I36pon57I3tT8KN3q2OnloiQuNjPfEnMDRpSJENgsjy6djRQjffwk+WgctCp/
         lvuNIGWEjds6ZOpJKkedu/x9IYDIUhgSive3a62OmT6cPwWsNTLTnuRC7p7oViSpyU71
         Vewg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rp2SyHztXuSc5EPDjn72803h6AQOk7vXYYLU7TdxcTM=;
        b=DrqPr7GtZlf+G7L/zd8Qj4Um8v0vPG/rb7soZ/0IDYIdaab7ZqmUz+wbls8uN8u6f/
         KRSgKwu6Bus16q+kUn2IkrVRsm3YL75ErN3cEcPxaPXh2RKNOduwjxkt/6/dOmJ4jLny
         c/RxIsegu3nP7TsQDWFdbV1zNRN5OJew/rdfxlmLLV/maByFVzPcmbtGCT4gB9dmsvmv
         pBGQrcQGeSd5O0km36rgGtOb47lB38Id14ifPNagwc9eTIILTqyhrTfqoi8UIE/XXwOZ
         nT/ELBrnR7fMt+YQOnDZoMJkYe894RzMGSx5jizko7hmiI4XdslBMA7Z01qjzs8JomwA
         5p9A==
X-Gm-Message-State: APjAAAWMZfLUvRRucTWPSvjzPLNsb9IJKT/4/VJ+LhPnKfd2Z1SDNLdB
        1ui5/Dd+HVXjPMABkRwyffB3HtCe7jNYkA==
X-Google-Smtp-Source: APXvYqwH6HyQ7VqGyNJKlmKvWvkaDR0YvbujuJVEBHPVcsk7baLGxd/zb06pQ7W5AD/OminzAiskIA==
X-Received: by 2002:adf:db81:: with SMTP id u1mr53014316wri.296.1560343736822;
        Wed, 12 Jun 2019 05:48:56 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.48.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:48:56 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 09/20] crypto: safexcel/aes - switch to library version of key expansion routine
Date:   Wed, 12 Jun 2019 14:48:27 +0200
Message-Id: <20190612124838.2492-10-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Switch to the new AES library that also provides an implementation of
the AES key expansion routine. This removes the dependency on the
generic AES cipher, allowing it to be omitted entirely in the future.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/Kconfig                         | 2 +-
 drivers/crypto/inside-secure/safexcel_cipher.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 539592e1d6f1..a6067bb5a6a2 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -701,7 +701,7 @@ config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
 	depends on OF
 	depends on (ARM64 && ARCH_MVEBU) || (COMPILE_TEST && 64BIT)
-	select CRYPTO_AES
+	select CRYPTO_LIB_AES
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_DES
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index de4be10b172f..483632546260 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -158,7 +158,7 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 	struct crypto_aes_ctx aes;
 	int ret, i;
 
-	ret = crypto_aes_expand_key(&aes, key, len);
+	ret = aes_expandkey(&aes, key, len);
 	if (ret) {
 		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return ret;
-- 
2.20.1

