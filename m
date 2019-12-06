Return-Path: <SRS0=wI/w=Z4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCFEC2D0BF
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 01:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65C312077B
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Dec 2019 01:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfLFB6p (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Dec 2019 20:58:45 -0500
Received: from outbound.smtp.vt.edu ([198.82.183.121]:46130 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725988AbfLFB6p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Dec 2019 20:58:45 -0500
Received: from mr2.cc.vt.edu (mr2.cc.ipv6.vt.edu [IPv6:2607:b400:92:8400:0:90:e077:bf22])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id xB61whiR017115
        for <linux-crypto@vger.kernel.org>; Thu, 5 Dec 2019 20:58:43 -0500
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        by mr2.cc.vt.edu (8.14.7/8.14.7) with ESMTP id xB61wcv7003529
        for <linux-crypto@vger.kernel.org>; Thu, 5 Dec 2019 20:58:43 -0500
Received: by mail-qt1-f200.google.com with SMTP id z7so3945586qto.23
        for <linux-crypto@vger.kernel.org>; Thu, 05 Dec 2019 17:58:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=riisjDNipcQ6mLJDEmCllvpK43By0/4gxjSAOwUnCGE=;
        b=QV6tf9ZmufoKxezgIF4gp//uCmOVzQrF/iTyXKorj3TA0dP67vHNQCRgDSxcWABykL
         jmEqHsoFjpJB5B1fr9wVw8j3Gy1xWLsgiKpmtl0uHsl1lE61cKKUjWZ1xy51QfWm4cJB
         dXlRpjS8PMQCZNxXLjmuKhoI8qGsOuRmvRlJ3OhQSbfaQW4L0ElCZHAT+qZgEFhUJNOj
         xsV5BcEAhtdo0eX6u4Yu2z8ANCFSRUQF56LSRp28WNpFQ1WhQAguGLSezkhnvA2soOPc
         jzdpKiieSYKwMCK2oZOLgVjyNW6Q7Yzxs/gToK2NUbyS+QfktXbHZ1bdhCgdXzsWM4Ni
         rCdA==
X-Gm-Message-State: APjAAAWBUKiT/9aIvODEk2PRAFQGABrJTondPtHmMOks/M4f33sixRs3
        IkxR16DLVc7uBFLs1C63JyFHux6BnhtJfJ/xWmbhvmVKdlByDuBaPQwvkXRIWEpsY+Yl0BiMzRb
        CLh9fIeqi7Z/16ko34Ah5FZQd8n2aEzb9aw4=
X-Received: by 2002:ad4:5048:: with SMTP id m8mr10600907qvq.248.1575597518229;
        Thu, 05 Dec 2019 17:58:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqz+hL+mxqoNyEf5t4NRcsy0o76gJWeMjINukcLLmS8cOPOszKGYjEUgXKeEbtYC4rxsCMRejQ==
X-Received: by 2002:ad4:5048:: with SMTP id m8mr10600889qvq.248.1575597517909;
        Thu, 05 Dec 2019 17:58:37 -0800 (PST)
Received: from turing-police ([2601:5c0:c001:c9e1::359])
        by smtp.gmail.com with ESMTPSA id q34sm4750054qtc.33.2019.12.05.17.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 17:58:36 -0800 (PST)
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ard Biesheuvel <ardb@kernel.org>
cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: chacha - fix warning message in header file
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Thu, 05 Dec 2019 20:58:36 -0500
Message-ID: <31579.1575597516@turing-police>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Building with W=1 causes a warning:

  CC [M]  arch/x86/crypto/chacha_glue.o
In file included from arch/x86/crypto/chacha_glue.c:10:
./include/crypto/internal/chacha.h:37:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
   37 | static int inline chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
      | ^~~~~~
 
Straighten out the order to match the rest of the header file.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

diff --git a/include/crypto/internal/chacha.h b/include/crypto/internal/chacha.h
index aa5d4a16aac5..b085dc1ac151 100644
--- a/include/crypto/internal/chacha.h
+++ b/include/crypto/internal/chacha.h
@@ -34,7 +34,7 @@ static inline int chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	return chacha_setkey(tfm, key, keysize, 20);
 }
 
-static int inline chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
+static inline int chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				  unsigned int keysize)
 {
 	return chacha_setkey(tfm, key, keysize, 12);
diff --git a/include/crypto/internal/chacha.h b/include/crypto/internal/chacha.h
index aa5d4a16aac5..b085dc1ac151 100644
--- a/include/crypto/internal/chacha.h
+++ b/include/crypto/internal/chacha.h
@@ -34,7 +34,7 @@ static inline int chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	return chacha_setkey(tfm, key, keysize, 20);
 }
 
-static int inline chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
+static inline int chacha12_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				  unsigned int keysize)
 {
 	return chacha_setkey(tfm, key, keysize, 12);

