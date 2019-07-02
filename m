Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26B6C06511
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9B0921850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B/8h1V42"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfGBTmZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:25 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38238 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfGBTmZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:25 -0400
Received: by mail-lf1-f68.google.com with SMTP id b11so12267780lfa.5
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yr+3Q9TRlnFwRP1ePoUuE5UXQ0fVFG8IySkaq4i3ZqU=;
        b=B/8h1V42vB/KOIakIJ//DCOWkkqLanAZVkjURxJlw5bg+u8PUbrzmtBO6GRJggmRKJ
         TLBIOUmrqFJ6RZUZIV2SynJPPYI29sId4CH9q6ld2aYsS1WsTkIvViuuBCvMlbzGIQTX
         TCuOTE/G0OM9d9R1WfmDUF5m+JYoa+MYm1p5NEveAy3oAE6iqyrzQUXeycgHaJlRKgiu
         8jyrGMP+QNILHIdrJZ33mpWlJxayjJwH08rPya/qVp7rlBj6bJHJyFs6aF9t9DHXs52X
         YkLhEZr5u1cmnQd5tkpbcprnHqG7fq30l2CJERsQkh4ZHFHksg4qXPtAKeczXizY3lH1
         Q5ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yr+3Q9TRlnFwRP1ePoUuE5UXQ0fVFG8IySkaq4i3ZqU=;
        b=PED8soIbi72WDp+q0rba7Hd8HKwAd7k49/+ed84LKZt0t8rjOT6/2xYRWo6PyFmr5m
         Rv+i22oLEavBqwdjH3Mb0C21HTh8c+TA0c5Uf/XIXu21ihKX3lLDWtHTYkjpLV0d1Z3L
         VSxMhjdtsEhPTIBEEXbEXhamS1XmAquxUVEss/ngyImNfS7eYdJGv+Pz0ujgB5QqkH90
         /1nswsT0mG7Y54gbjSBLDG3DrGWm8VuW6WcNDmDUeN1CorWXm0JxJ5e54mjG0b7k06Do
         ploB63+AyKdamQHGtHHSLkwzH+HvRsbqY3fuiVB+Rd46lGvqBawzKF/yI9edcjJ/N/7+
         PRKQ==
X-Gm-Message-State: APjAAAWpkILwP2JVlzTPUNOIgK6z1tRjrh5piVcxQdJS01v9gbOkVL6d
        r7OV6hx28Usd+XQpLCcjeyO4ADY+Kbwi99/C
X-Google-Smtp-Source: APXvYqwoTEWxfe1QRhHzgz46NjKduGcW2WWL/rE9RVghsbLr00ia0md/DpWNpFfeIQDgNJZ76YYSJg==
X-Received: by 2002:ac2:4a78:: with SMTP id q24mr14501522lfp.59.1562096542780;
        Tue, 02 Jul 2019 12:42:22 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:21 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 09/32] crypto: safexcel/aes - switch to library version of key expansion routine
Date:   Tue,  2 Jul 2019 21:41:27 +0200
Message-Id: <20190702194150.10405-10-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
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
index fdccadc94819..b30b84089d11 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -718,7 +718,7 @@ config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
 	depends on OF
 	depends on (ARM64 && ARCH_MVEBU) || (COMPILE_TEST && 64BIT)
-	select CRYPTO_AES
+	select CRYPTO_LIB_AES
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_DES
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 8cdbdbe35681..19ec086dce4f 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -178,7 +178,7 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 	struct crypto_aes_ctx aes;
 	int ret, i;
 
-	ret = crypto_aes_expand_key(&aes, key, len);
+	ret = aes_expandkey(&aes, key, len);
 	if (ret) {
 		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return ret;
-- 
2.17.1

