Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65055C43630
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38A1F2146E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EZelB1bm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387965AbfIYQOF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:14:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33312 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388050AbfIYQOF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 12:14:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id b9so7650017wrs.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 09:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GHZTUsgGCCxhaUqhh6GFmynzyGA2xAGilsSBrwWL8Ec=;
        b=EZelB1bmBbVqkj69RFWzhZDiyl+QrRS1Ld/4jAK9o8wa+U3Y4C9KupSUIqj2czhl7k
         ITiHGURXEqXrMJmGJNB9KMIUGwxFnx7bIhXwPlyP3otwQoRuaqODihXzE3AhyE+SuMOe
         Eupyf7hjZZlON1Utlzp/RmQMPvLJn2rjU8LmbXlYIzGZ+eXKz+3lmREZnr2u+zWgdOnC
         DnAE1RwkIUI90BBXqLfP2SQt/xl177ryb9XkpwBkxrUMcHJChPVU9vFbBntefNklJgCR
         eMbWcs4UmklFy7RjjpAUH6gGYaPbUv9a9jmIlTOejjFpzVISicNuFbq7E+U5L0HF88Yg
         IqzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GHZTUsgGCCxhaUqhh6GFmynzyGA2xAGilsSBrwWL8Ec=;
        b=PKJYWQnQKCXS+nktF7hzgWv9njLa5LaL6/EbqUeXVmnkEWgPwqaKCu1iUx6gedbxM4
         BTQGpyWgosStPi723MzNUmb92YlztxwLYjNwzTidojMDo1wVcZOv3MKFJibDyqxmSwzZ
         AlNj4oHWkvqmgSaDipgLvb1AJD4rC5GHktoawJz+uNZrcg19pcTLGDOz8nfGpgKicgkU
         yODFHDZFrEmzBIIesODAmq/k4SQzWsSFYUxu7u0Vx5+8ZhjWB2vahzNf1M2O3Xvf/jIV
         OjP8lmbjK8g+5b6yr4yhOmVFTMgx7ziOlmO8MHmNol0DIP9IKemnCAycbcZ/RBWW1Hal
         Jthg==
X-Gm-Message-State: APjAAAWIojzUrjU1etvZ4CBJDRTAJW+8o4EflYwyGtkoAET9mZ1jG1qx
        J80H3JyH8PjPAwTfYXZXlo1SAIOoQBGK3BEJ
X-Google-Smtp-Source: APXvYqz1sBIY8jpDffs/GzFrwhS+OK125T+2rgBRUTsh9BLcog3Q1msw/qOOPlbx/V81RfwvRmI7vA==
X-Received: by 2002:a5d:62c6:: with SMTP id o6mr9945348wrv.243.1569428043029;
        Wed, 25 Sep 2019 09:14:03 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id o70sm4991085wme.29.2019.09.25.09.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 09:14:02 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [RFC PATCH 11/18] int128: move __uint128_t compiler test to Kconfig
Date:   Wed, 25 Sep 2019 18:12:48 +0200
Message-Id: <20190925161255.1871-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to use 128-bit integer arithmetic in C code, the architecture
needs to have declared support for it by setting ARCH_SUPPORTS_INT128,
and it requires a version of the toolchain that supports this at build
time. This is why all existing tests for ARCH_SUPPORTS_INT128 also test
whether __SIZEOF_INT128__ is defined, since this is only the case for
compilers that can support 128-bit integers.

Let's fold this additional test into the Kconfig declaration of
ARCH_SUPPORTS_INT128 so that we can also use the symbol in Makefiles,
e.g., to decide whether a certain object needs to be included in the
first place.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/ecc.c | 2 +-
 init/Kconfig | 1 +
 lib/ubsan.c  | 2 +-
 lib/ubsan.h  | 2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index dfe114bc0c4a..6e6aab6c987c 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -336,7 +336,7 @@ static u64 vli_usub(u64 *result, const u64 *left, u64 right,
 static uint128_t mul_64_64(u64 left, u64 right)
 {
 	uint128_t result;
-#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
+#if defined(CONFIG_ARCH_SUPPORTS_INT128)
 	unsigned __int128 m = (unsigned __int128)left * right;
 
 	result.m_low  = m;
diff --git a/init/Kconfig b/init/Kconfig
index bd7d650d4a99..e66f64a26d7d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -785,6 +785,7 @@ config ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 #
 config ARCH_SUPPORTS_INT128
 	bool
+	depends on !$(cc-option,-D__SIZEOF_INT128__=0)
 
 # For architectures that (ab)use NUMA to represent different memory regions
 # all cpu-local but of different latencies, such as SuperH.
diff --git a/lib/ubsan.c b/lib/ubsan.c
index e7d31735950d..b652cc14dd60 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -119,7 +119,7 @@ static void val_to_string(char *str, size_t size, struct type_descriptor *type,
 {
 	if (type_is_int(type)) {
 		if (type_bit_width(type) == 128) {
-#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
+#if defined(CONFIG_ARCH_SUPPORTS_INT128)
 			u_max val = get_unsigned_val(type, value);
 
 			scnprintf(str, size, "0x%08x%08x%08x%08x",
diff --git a/lib/ubsan.h b/lib/ubsan.h
index b8fa83864467..7b56c09473a9 100644
--- a/lib/ubsan.h
+++ b/lib/ubsan.h
@@ -78,7 +78,7 @@ struct invalid_value_data {
 	struct type_descriptor *type;
 };
 
-#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
+#if defined(CONFIG_ARCH_SUPPORTS_INT128)
 typedef __int128 s_max;
 typedef unsigned __int128 u_max;
 #else
-- 
2.20.1

