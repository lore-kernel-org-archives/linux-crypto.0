Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BBEC77B73
	for <linux-crypto@archiver.kernel.org>; Tue,  2 May 2023 08:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjEBIDZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 May 2023 04:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbjEBIDY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 May 2023 04:03:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE284230
        for <linux-crypto@vger.kernel.org>; Tue,  2 May 2023 01:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683014558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qmSSxAyC/0y0EJhrGRTGG9Z1Cg2YU8/Y+E1SH5a6mWo=;
        b=HnjkzrrsIWFBwm+sJTNXyG80Q4raLuv9X/8MrqfloZSrgksRC5Xkrt9cMoevNecAXNRHYf
        5oBSkYcLFDixG+JxpyJsL8zZ7siu1ijlUTRZ6XNefqLzTheo8CC3U1c20oqhZNnQs/2MzS
        Sh8mOUSAtpEX3PMIJ7SwpW7VJQNFsAs=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-faxMiJxONY-HOzU6XKlPKg-1; Tue, 02 May 2023 04:02:37 -0400
X-MC-Unique: faxMiJxONY-HOzU6XKlPKg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-94a34e35f57so332436666b.3
        for <linux-crypto@vger.kernel.org>; Tue, 02 May 2023 01:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683014556; x=1685606556;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qmSSxAyC/0y0EJhrGRTGG9Z1Cg2YU8/Y+E1SH5a6mWo=;
        b=gY3MmjseHg2Kx7pZ302ZXg/arTqwaa7MAa7z+9I7F/IYavkCc5xHJhuuNQa9BDCVRm
         yAh0kOA4hXl8MY8HI2axWjzcf+R7TBO+SbhLP7cVUocL6gw73NTcOyQ57+PUdZPtYd8q
         tewbLJcnZCLHgsfP8DuaOeveWHNBTBhbv3ldGAmeUWMCBtOhKC9FOJQIHeU74ajm2eyE
         MqpJ4kMHtkBMm8vpJV/wVlrVHbfmobr7symMIH9+Sp13dUARbLB2Jl7++4xoiOVDpHBX
         hPuYLz8tHVlfQp9QakPvXZJeIvvjc1xRkGXpaU/HxZmYedd4Zn1WooOf7W665x30vkrP
         E+NA==
X-Gm-Message-State: AC+VfDydAa7w5rv5RtQxEe/RNPr3os1TWQG3ko02zxfMY7aqbBgxfTFr
        Q/Q+QiWPqRDXUX9Gd2lNuvsH9K7uaZyTl1x8pokoYoopvtPe9da86xeEk3JKq+tvq+h9Y71WJJR
        6d99zpevheEkSjaBc09o/sVBhTC1+vjfN5Qs=
X-Received: by 2002:a17:906:dac1:b0:961:8fcd:53b3 with SMTP id xi1-20020a170906dac100b009618fcd53b3mr4863098ejb.10.1683014555814;
        Tue, 02 May 2023 01:02:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ48N9OBfhJN7NM6T1GzCaJ9PXnhwR4lC/qI5Pr+nuZWnvqGnyra0VyQ19KTMY2ymEVYM1U/QQ==
X-Received: by 2002:a17:906:dac1:b0:961:8fcd:53b3 with SMTP id xi1-20020a170906dac100b009618fcd53b3mr4863080ejb.10.1683014555479;
        Tue, 02 May 2023 01:02:35 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id aa21-20020a170907355500b00957dad777c1sm13415186ejc.107.2023.05.02.01.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 01:02:34 -0700 (PDT)
From:   Ondrej Mosnacek <omosnace@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: api - Fix CRYPTO_USER checks for report function
Date:   Tue,  2 May 2023 10:02:33 +0200
Message-Id: <20230502080233.2964058-1-omosnace@redhat.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Checking the config via ifdef incorrectly compiles out the report
functions when CRYPTO_USER is set to =m. Fix it by using IS_ENABLED()
instead.

Fixes: c0f9e01dd266 ("crypto: api - Check CRYPTO_USER instead of NET for report")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 crypto/acompress.c | 2 +-
 crypto/aead.c      | 2 +-
 crypto/ahash.c     | 2 +-
 crypto/akcipher.c  | 2 +-
 crypto/kpp.c       | 2 +-
 crypto/rng.c       | 2 +-
 crypto/scompress.c | 2 +-
 crypto/shash.c     | 2 +-
 crypto/skcipher.c  | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 82a290df2822a..1c682810a484d 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -125,7 +125,7 @@ static const struct crypto_type crypto_acomp_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_acomp_show,
 #endif
-#ifdef CONFIG_CRYPTO_USER
+#if IS_ENABLED(CONFIG_CRYPTO_USER)
 	.report = crypto_acomp_report,
 #endif
 #ifdef CONFIG_CRYPTO_STATS
diff --git a/crypto/aead.c b/crypto/aead.c
index ffc48a7dfb349..d5ba204ebdbfa 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -242,7 +242,7 @@ static const struct crypto_type crypto_aead_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_aead_show,
 #endif
-#ifdef CONFIG_CRYPTO_USER
+#if IS_ENABLED(CONFIG_CRYPTO_USER)
 	.report = crypto_aead_report,
 #endif
 #ifdef CONFIG_CRYPTO_STATS
diff --git a/crypto/ahash.c b/crypto/ahash.c
index b8a607928e72d..3246510404465 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -509,7 +509,7 @@ static const struct crypto_type crypto_ahash_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_ahash_show,
 #endif
-#ifdef CONFIG_CRYPTO_USER
+#if IS_ENABLED(CONFIG_CRYPTO_USER)
 	.report = crypto_ahash_report,
 #endif
 #ifdef CONFIG_CRYPTO_STATS
diff --git a/crypto/akcipher.c b/crypto/akcipher.c
index 186e762b509a6..7960ceb528c36 100644
--- a/crypto/akcipher.c
+++ b/crypto/akcipher.c
@@ -98,7 +98,7 @@ static const struct crypto_type crypto_akcipher_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_akcipher_show,
 #endif
-#ifdef CONFIG_CRYPTO_USER
+#if IS_ENABLED(CONFIG_CRYPTO_USER)
 	.report = crypto_akcipher_report,
 #endif
 #ifdef CONFIG_CRYPTO_STATS
diff --git a/crypto/kpp.c b/crypto/kpp.c
index 74f2e8e918fa5..33d44e59387ff 100644
--- a/crypto/kpp.c
+++ b/crypto/kpp.c
@@ -96,7 +96,7 @@ static const struct crypto_type crypto_kpp_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_kpp_show,
 #endif
-#ifdef CONFIG_CRYPTO_USER
+#if IS_ENABLED(CONFIG_CRYPTO_USER)
 	.report = crypto_kpp_report,
 #endif
 #ifdef CONFIG_CRYPTO_STATS
diff --git a/crypto/rng.c b/crypto/rng.c
index ffde0f64fb259..279dffdebf598 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -118,7 +118,7 @@ static const struct crypto_type crypto_rng_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_rng_show,
 #endif
-#ifdef CONFIG_CRYPTO_USER
+#if IS_ENABLED(CONFIG_CRYPTO_USER)
 	.report = crypto_rng_report,
 #endif
 #ifdef CONFIG_CRYPTO_STATS
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 24138b42a648a..442a82c9de7de 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -240,7 +240,7 @@ static const struct crypto_type crypto_scomp_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_scomp_show,
 #endif
-#ifdef CONFIG_CRYPTO_USER
+#if IS_ENABLED(CONFIG_CRYPTO_USER)
 	.report = crypto_scomp_report,
 #endif
 #ifdef CONFIG_CRYPTO_STATS
diff --git a/crypto/shash.c b/crypto/shash.c
index 5845b7d59b2f2..717b42df3495e 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -548,7 +548,7 @@ static const struct crypto_type crypto_shash_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_shash_show,
 #endif
-#ifdef CONFIG_CRYPTO_USER
+#if IS_ENABLED(CONFIG_CRYPTO_USER)
 	.report = crypto_shash_report,
 #endif
 #ifdef CONFIG_CRYPTO_STATS
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 6caca02d7e552..7b275716cf4e3 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -776,7 +776,7 @@ static const struct crypto_type crypto_skcipher_type = {
 #ifdef CONFIG_PROC_FS
 	.show = crypto_skcipher_show,
 #endif
-#ifdef CONFIG_CRYPTO_USER
+#if IS_ENABLED(CONFIG_CRYPTO_USER)
 	.report = crypto_skcipher_report,
 #endif
 #ifdef CONFIG_CRYPTO_STATS
-- 
2.40.1

