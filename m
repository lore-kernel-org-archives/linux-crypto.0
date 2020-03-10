Return-Path: <SRS0=U1Ok=43=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F7DC18E5A
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 21:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E258215A4
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 21:05:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="LuNRf2B0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCJVFv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Mar 2020 17:05:51 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:42155 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgCJVFt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Mar 2020 17:05:49 -0400
Received: by mail-wr1-f47.google.com with SMTP id v11so17673324wrm.9
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2020 14:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FGYfQIh9wQobh/6Rhp+ohpDYSO5gZAqtEh8Zv2JwpXk=;
        b=LuNRf2B0fGHZf+MZKjsth4jgDkByxYLeWUqVjJ2tjXeELiAUHVqHodja4Ca5If9zd+
         DijJfhSdmJ0u0iAiLnMWtHUb4EBKYnEFzIbqnqd/YeEU6xhfYsI5XQKdDCGPfNE+apFC
         FPyHFo7UHCRuQJI2d3pobnvESVkqzN+9dIf4WCFRI0OZuU8L0bz6D+mq4JRpp6HyqKZz
         zY/pB2KQAFz0yONKXkyv4FmogXG/hMXylTWfldz1Fl9xZFmIUdvW5ujlSFnPU4NSbm1F
         Olj/e2JNEv5h3hd4P6QJvVl4pneS6Xo0dhHEfZEtes0wBw45xwgH+Nx9ke7qMhngrr2R
         1aiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FGYfQIh9wQobh/6Rhp+ohpDYSO5gZAqtEh8Zv2JwpXk=;
        b=UnnF4CP9bD/l3jB0FpPkECPMklSWSBM9RF7A9gi0EKo10wO99j817kLhXK/tobZJ17
         cfCelq9u1aoQaBdk3vRQ/JrPn5tnSthwtYYaISv6ygxhxhqHFJG0jhIXt2GIQDzSOI4O
         yoYtdP7kCGn9tcYoFUuzq07AjW6UTuJgLby7TPj4c2V+h31lu98OZYyg9j6EItPW52B5
         3KFSSt0bB4qFsQp0zA1mVg9vttwLBilFR+lS7kaqnPVLRdeQ7C6hDuafQorKu6/3fjle
         R3HxHLSiQ1a0x0sQGNrM3KqzcenicSC69c0W30K461YvUoakgF3B4OchuWygHqgcEa0M
         86jA==
X-Gm-Message-State: ANhLgQ0aPmBC+BQxb3pzkM3Qfk3c11IhIskgr1X8Xi08slG/V5J8y7Ck
        sPJSB1uDBy2AdPczlEew9LALXQ==
X-Google-Smtp-Source: ADFU+vuXKsOvVtJQKFzcYHrMl5dCj1zPN3CK19ZjAdiV7PYEEX2MfPoT5FA9kk81vQ7HEumhf0oxLw==
X-Received: by 2002:a5d:480c:: with SMTP id l12mr8606519wrq.19.1583874346504;
        Tue, 10 Mar 2020 14:05:46 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id f127sm5783049wma.4.2020.03.10.14.05.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Mar 2020 14:05:45 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 2/2] crypto: drbg: DRBG_CTR should select CTR
Date:   Tue, 10 Mar 2020 21:05:38 +0000
Message-Id: <1583874338-38321-2-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583874338-38321-1-git-send-email-clabbe@baylibre.com>
References: <1583874338-38321-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

if CRYPTO_DRBG_CTR is builtin and CTR is module, allocating such algo
will fail.
DRBG: could not allocate CTR cipher TFM handle: ctr(aes)
alg: drbg: Failed to reset rng
alg: drbg: Test 0 failed for drbg_pr_ctr_aes128
DRBG: could not allocate CTR cipher TFM handle: ctr(aes)
alg: drbg: Failed to reset rng
alg: drbg: Test 0 failed for drbg_nopr_ctr_aes128
DRBG: could not allocate CTR cipher TFM handle: ctr(aes)
alg: drbg: Failed to reset rng
alg: drbg: Test 0 failed for drbg_nopr_ctr_aes192
DRBG: could not allocate CTR cipher TFM handle: ctr(aes)
alg: drbg: Failed to reset rng
ialg: drbg: Test 0 failed for drbg_nopr_ctr_aes256

Since setting DRBG_CTR=CTR lead to a recursive dependency, let's depends
on CTR=y

Just selecting CTR lead also to a recursive dependency:
crypto/Kconfig:1800:error: recursive dependency detected!
crypto/Kconfig:1800:    symbol CRYPTO_DRBG_MENU is selected by
CRYPTO_RNG_DEFAULT
crypto/Kconfig:83:      symbol CRYPTO_RNG_DEFAULT is selected by
CRYPTO_SEQIV
crypto/Kconfig:330:     symbol CRYPTO_SEQIV is selected by CRYPTO_CTR
crypto/Kconfig:370:     symbol CRYPTO_CTR is selected by CRYPTO_DRBG_CTR
crypto/Kconfig:1822:    symbol CRYPTO_DRBG_CTR depends on
CRYPTO_DRBG_MENU

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
Changes since v1:
- Updated commit message with recursive dependency

 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6d27fc6a7bf5..eddeb43fc01c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1822,7 +1822,7 @@ config CRYPTO_DRBG_HASH
 config CRYPTO_DRBG_CTR
 	bool "Enable CTR DRBG"
 	select CRYPTO_AES
-	depends on CRYPTO_CTR
+	depends on CRYPTO_CTR=y
 	help
 	  Enable the CTR DRBG variant as defined in NIST SP800-90A.
 
-- 
2.24.1

