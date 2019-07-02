Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB7EC06513
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A16C21852
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oKXQkqHU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfGBTmu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:50 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45687 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfGBTms (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:48 -0400
Received: by mail-lj1-f193.google.com with SMTP id m23so18148492lje.12
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AD8PvOEZeWj16u5SSLkHbNcyzb21rPobxHD6kFBr7Fk=;
        b=oKXQkqHUsHz/edKeiBwZP+iX+iVXjat0a0wxD9FYSK6I34WTJH5GyBr8PLx+Lc0BqW
         i7Osdo+uG4VQ63D9ByGN9aD75YW9OtbSL0U77kSTqqZKJkbZhjcTNI66bGnEAetkaVsF
         ir/kL7d1uEZfPoC3j53N0sQSrFs+lN/ebS6OFrJbgPFWcOY9EIwaK7CTNbAP6f9EbEdT
         d8Naz+IAft9IASgma7UWg+rTD1V8bjU74UUlhk5uH+fmLnI/6umDv7+e9ElSEmKFquqh
         35u3JVZCr9+aIRBq2f50nUO3R7BZ30AdGp+eJy95L8qIO7junMmtlz6BWpPl/NwMsmkk
         POBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AD8PvOEZeWj16u5SSLkHbNcyzb21rPobxHD6kFBr7Fk=;
        b=HQUVaQxwX10F61ykFj3biXPsUcJm4cIOLuAb+H+ftbomPFq71hsU2za4ZoUSI9FxyS
         YjE14mQE46HAYGkebrrL5VvnTrSsG+2Sf9d3CJsHZ2M5E7cOeE8JCjefLvf2AqH6RkdG
         M5E1TXqNoJkJv/NFNxEr9XHnhM+RoSzZNTU7uTUuTqXAUKa8Xh2XSKJ7o+Med7wTp0fy
         IrjaArN6HRMAtFAY9b94l/97+CpWUEzHO3ZQYLOsFxtO0CzPr2j2kSiXG21oFbUh2kjo
         To8GNZWOdRPuZmCHpz8YON89Zh5ZNw2VKwXZzbsEkVAygtlXbGZWPOV6zUroIlSIy9Yy
         JjmA==
X-Gm-Message-State: APjAAAWBWIkjkfQuSl+HIdsoi+q3Q5sbuagB3xpGkw//j78+maUZyLEo
        6ApkZhGGe38jXHdsI+YBTXyhwk0Tof1YO8wc
X-Google-Smtp-Source: APXvYqzam4EIPCngfBlOMCPW61xe8V7JLUZ7QSB/+D7WdzoriZg1ysZ8oeCba8Tcm0n/GGhszuQBCw==
X-Received: by 2002:a2e:9643:: with SMTP id z3mr18859184ljh.43.1562096566046;
        Tue, 02 Jul 2019 12:42:46 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:45 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 27/32] crypto: aes/generic - unexport last-round AES tables
Date:   Tue,  2 Jul 2019 21:41:45 +0200
Message-Id: <20190702194150.10405-28-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The versions of the AES lookup tables that are only used during the last
round are never used outside of the driver, so there is no need to
export their symbols.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aes_generic.c | 6 ++----
 include/crypto/aes.h | 2 --
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index 426deb437f19..71a5c190d360 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -328,7 +328,7 @@ __visible const u32 crypto_ft_tab[4][256] ____cacheline_aligned = {
 	}
 };
 
-__visible const u32 crypto_fl_tab[4][256] ____cacheline_aligned = {
+static const u32 crypto_fl_tab[4][256] ____cacheline_aligned = {
 	{
 		0x00000063, 0x0000007c, 0x00000077, 0x0000007b,
 		0x000000f2, 0x0000006b, 0x0000006f, 0x000000c5,
@@ -856,7 +856,7 @@ __visible const u32 crypto_it_tab[4][256] ____cacheline_aligned = {
 	}
 };
 
-__visible const u32 crypto_il_tab[4][256] ____cacheline_aligned = {
+static const u32 crypto_il_tab[4][256] ____cacheline_aligned = {
 	{
 		0x00000052, 0x00000009, 0x0000006a, 0x000000d5,
 		0x00000030, 0x00000036, 0x000000a5, 0x00000038,
@@ -1121,9 +1121,7 @@ __visible const u32 crypto_il_tab[4][256] ____cacheline_aligned = {
 };
 
 EXPORT_SYMBOL_GPL(crypto_ft_tab);
-EXPORT_SYMBOL_GPL(crypto_fl_tab);
 EXPORT_SYMBOL_GPL(crypto_it_tab);
-EXPORT_SYMBOL_GPL(crypto_il_tab);
 
 /**
  * crypto_aes_set_key - Set the AES key.
diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 0a64a977f9b3..df8426fd8051 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -29,9 +29,7 @@ struct crypto_aes_ctx {
 };
 
 extern const u32 crypto_ft_tab[4][256] ____cacheline_aligned;
-extern const u32 crypto_fl_tab[4][256] ____cacheline_aligned;
 extern const u32 crypto_it_tab[4][256] ____cacheline_aligned;
-extern const u32 crypto_il_tab[4][256] ____cacheline_aligned;
 
 int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 		unsigned int key_len);
-- 
2.17.1

