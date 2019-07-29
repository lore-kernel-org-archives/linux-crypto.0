Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B394AC7618B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 07:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 865F4206E0
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 07:44:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Oyohj/Ph"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfG2How (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 03:44:52 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39997 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfG2How (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 03:44:52 -0400
Received: by mail-ed1-f65.google.com with SMTP id k8so58409092eds.7
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2019 00:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=uLcmXwKVz1uKzcQy5USt42RZEFOKeYIUd0MaNWXoGOw=;
        b=Oyohj/Pho6THYUmEsJXmfGWp20+LaJ27t48zwWWAC9aJadGPOZSbHlg29A5y+w02Z7
         8xRvB//yl25J/hmAlyp9W6tOuHPuQYkUz92yKLC+ya0nciX2E1xzZEL5lrjvU7eqqGxb
         oYnIufvxxtp1i7CbxxLhlibI2CHE2UdJ0qH0A1JSljVQyn11Lel3s8t0FLDtXywy5cA2
         yH2vnBdzb/zkNNVhAMmJK45gCSMWFd5nNShauQzhw/pIJIfHrVMjT4RiegfpjiKCQQQF
         Pcm4ap0WgRZZlmuSNz/cMr5uW6lbuUVDbagr8G9tQ/fxjnhKlHNzUM4DCPVRA+aKyU/z
         lsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uLcmXwKVz1uKzcQy5USt42RZEFOKeYIUd0MaNWXoGOw=;
        b=oj5UWhEJXXiWIXkehoswA5y6y2D+4F2yXonQVO31xYY2vKf2AuAZVJHOlFkNIVRggR
         hJAUhsJt0BygzY7OXmf2SbxHAhT4zfknw/CHgQK7yQUdRwsvqRcfwzGYNXhh7fYg4LsV
         GT0H2eUvo/+qAM9Y/RhHklxnG7xBtUYOTVbbR9OP5m+yl8UcUyTZ9VItox83iDVo24bA
         1gUWmvocH1MRq4uiIqzDu6dq2baianVv3X7NmWiwpSLvFBgj1jR6V7vWmryGrvGBEohn
         GtljDE3+9UOUoErmYzTakhMzDdyzVse1+jm+RSus0VXM8w9KCSl5UhylCUGMmXQuNAw4
         7bmA==
X-Gm-Message-State: APjAAAWhF7dinO7cSTe8jkgRAkKUG7ehqfN6DSUjLvcgZ1vYZGFlK1cW
        +gBLkwNdDBVQDtyBbCJEkMJZvSjQ613i6Q==
X-Google-Smtp-Source: APXvYqzVIPpjdbAkajmvQH71dAA3hCbwlUAMPy71KGTG/zDPt7y7XDWQ6Dr/ZNvx0A7/psfJkmKXgQ==
X-Received: by 2002:a50:9871:: with SMTP id h46mr94043142edb.69.1564386290338;
        Mon, 29 Jul 2019 00:44:50 -0700 (PDT)
Received: from mba13.hotspot.parkpalaceresidence.com ([212.92.108.154])
        by smtp.gmail.com with ESMTPSA id hh16sm11170572ejb.18.2019.07.29.00.44.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 00:44:49 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, geert@linux-m68k.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: aegis128 - deal with missing simd.h header on some architecures
Date:   Mon, 29 Jul 2019 10:44:34 +0300
Message-Id: <20190729074434.21064-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The generic aegis128 driver has been updated to support using SIMD
intrinsics to implement the core AES based transform, and this has
been wired up for ARM and arm64, which both provide a simd.h header.

As it turns out, most architectures don't provide this header, even
though a version of it exists in include/asm-generic, and this is
not taken into account by the aegis128 driver, resulting in build
failures on those architectures.

So update the aegis128 code to only import simd.h (and the related
header in internal/crypto) if the SIMD functionality is enabled for
this driver.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/aegis128-core.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
index f815b4685156..d46a12872d35 100644
--- a/crypto/aegis128-core.c
+++ b/crypto/aegis128-core.c
@@ -8,7 +8,6 @@
 
 #include <crypto/algapi.h>
 #include <crypto/internal/aead.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
@@ -16,7 +15,11 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
+
+#ifdef CONFIG_CRYPTO_AEGIS128_SIMD
+#include <crypto/internal/simd.h>
 #include <asm/simd.h>
+#endif
 
 #include "aegis.h"
 
@@ -44,6 +47,15 @@ struct aegis128_ops {
 
 static bool have_simd;
 
+static bool aegis128_do_simd(void)
+{
+#ifdef CONFIG_CRYPTO_AEGIS128_SIMD
+	if (have_simd)
+		return crypto_simd_usable();
+#endif
+	return false;
+}
+
 bool crypto_aegis128_have_simd(void);
 void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg);
 void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
@@ -66,7 +78,7 @@ static void crypto_aegis128_update(struct aegis_state *state)
 static void crypto_aegis128_update_a(struct aegis_state *state,
 				     const union aegis_block *msg)
 {
-	if (have_simd && crypto_simd_usable()) {
+	if (aegis128_do_simd()) {
 		crypto_aegis128_update_simd(state, msg);
 		return;
 	}
@@ -77,7 +89,7 @@ static void crypto_aegis128_update_a(struct aegis_state *state,
 
 static void crypto_aegis128_update_u(struct aegis_state *state, const void *msg)
 {
-	if (have_simd && crypto_simd_usable()) {
+	if (aegis128_do_simd()) {
 		crypto_aegis128_update_simd(state, msg);
 		return;
 	}
@@ -396,7 +408,7 @@ static int crypto_aegis128_encrypt(struct aead_request *req)
 	unsigned int authsize = crypto_aead_authsize(tfm);
 	unsigned int cryptlen = req->cryptlen;
 
-	if (have_simd && crypto_simd_usable())
+	if (aegis128_do_simd())
 		ops = &(struct aegis128_ops){
 			.skcipher_walk_init = skcipher_walk_aead_encrypt,
 			.crypt_chunk = crypto_aegis128_encrypt_chunk_simd };
@@ -424,7 +436,7 @@ static int crypto_aegis128_decrypt(struct aead_request *req)
 	scatterwalk_map_and_copy(tag.bytes, req->src, req->assoclen + cryptlen,
 				 authsize, 0);
 
-	if (have_simd && crypto_simd_usable())
+	if (aegis128_do_simd())
 		ops = &(struct aegis128_ops){
 			.skcipher_walk_init = skcipher_walk_aead_decrypt,
 			.crypt_chunk = crypto_aegis128_decrypt_chunk_simd };
-- 
2.17.1

