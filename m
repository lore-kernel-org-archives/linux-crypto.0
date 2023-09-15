Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380D9EE6452
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Sep 2023 10:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbjIOKZz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Sep 2023 06:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbjIOKZx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Sep 2023 06:25:53 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4A33A90
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 03:23:31 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 4D8CC3F04B
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 10:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1694773407;
        bh=z7JHAgWlYbo6190D8eD4+RynEQye8I21JfDjXnFF0Ck=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=pAWESwKbofXfirKQ+cu2GippwrcotREwgJ54a47CcWzLElpmUEpadEShek2P8Ob+g
         TQ0mG/8px4AIq/RjsyDUITFlluo2Aed8XeaM8zSZK0IlSSLDtgglyRp9I/gfmjto6t
         bMVv6SzWDLqe1bjsnTOMw/0SULcybFd6vgEoHboleE/dlj+LG/5tuf7NEgT1sTZ4TY
         DWHyO+xoHHGgzLqahCt2BH/KCXiv7YhPOXMUc5j6OWjIEw+jiOEXz+f8+6BCx8qTh8
         IBs89jqDa7XQw297bvsgrwUsH1TYmz2G8f31rmxQEo2BJ2MYg2Es9QdvI0/+VisMjt
         l+iDkDjGMLrww==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-99bcb13d8ddso142593966b.0
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 03:23:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694773406; x=1695378206;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z7JHAgWlYbo6190D8eD4+RynEQye8I21JfDjXnFF0Ck=;
        b=k2r+5NrhpvrJdTqnl7j3pe1aMvuok77NKmvnvCUk9G9WQGgxrPIXdvUZ/ZZNqMyXN4
         6pW4cCWVe5MXoWJ+r/XThCBqGe0y37GFdChLc3KbhHdt866h6iXZI2vLDDpnAqRXEqoa
         EJ8KVFjlmdEWyOChDrFlObBlNSgRAh6LJfotm11Y1ozgUc/ELRbn3FcB3uWJHm+Appjm
         uJJoST0eQ55SUUyA8M8TYNmYsBZWWGtu1u4a5vWmL8hxCSRsW0d6oXGw4ATHGrw701Fz
         S9B2xqDuzMX4TH05veSRh/xX4leJ6e67vBCStv/Nvmu/feR8F7ekLFrqxAFXNBmsZznp
         uYLw==
X-Gm-Message-State: AOJu0YzUr41BuO4OE5gU7/lfYdUn0sGBxecciXNuEMR57Xd9EVt3MxLq
        dXIPqWoKYW32oHVhhWMGmiVF7UpvuNkzFttWdrvZrjFbqRzzewzXyY8dTmIlngba0LsTJJbP6TD
        uFVPZXS91bpfN9pIyy4xArKgmltqrSb8uPzDK7l7Fsg==
X-Received: by 2002:a17:907:784f:b0:9a2:2635:daa8 with SMTP id lb15-20020a170907784f00b009a22635daa8mr941248ejc.56.1694773406593;
        Fri, 15 Sep 2023 03:23:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+FiyghSmdvhT78+MTXJZGFKg/xOgd32F1+tb9mlsD409KTBDcb1ilWTv89DV9DYE//HViLA==
X-Received: by 2002:a17:907:784f:b0:9a2:2635:daa8 with SMTP id lb15-20020a170907784f00b009a22635daa8mr941235ejc.56.1694773406299;
        Fri, 15 Sep 2023 03:23:26 -0700 (PDT)
Received: from work.lan (77-169-125-32.fixed.kpn.net. [77.169.125.32])
        by smtp.gmail.com with ESMTPSA id o9-20020a170906600900b0099bcd1fa5b0sm2189818ejj.192.2023.09.15.03.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 03:23:25 -0700 (PDT)
From:   Roxana Nicolescu <roxana.nicolescu@canonical.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com
Cc:     x86@kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: x86 - load optimized sha1/sha256 modules based on CPU features
Date:   Fri, 15 Sep 2023 12:23:25 +0200
Message-Id: <20230915102325.35189-1-roxana.nicolescu@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

x86 optimized crypto modules are built as modules rather than build-in and
they are not loaded when the crypto API is initialized, resulting in the
generic builtin module (sha1-generic) being used instead.

It was discovered when creating a sha1/sha256 checksum of a 2Gb file by
using kcapi-tools because it would take significantly longer than creating
a sha512 checksum of the same file. trace-cmd showed that for sha1/256 the
generic module was used, whereas for sha512 the optimized module was used
instead.

Add module aliases() for these x86 optimized crypto modules based on CPU
feature bits so udev gets a chance to load them later in the boot
process. This resulted in ~3x decrease in the real-time execution of
kcapi-dsg.

Fix is inspired from commit
aa031b8f702e ("crypto: x86/sha512 - load based on CPU features")
where a similar fix was done for sha512.

Cc: stable@vger.kernel.org # 5.15+
Suggested-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Suggested-by: Julian Andres Klode <julian.klode@canonical.com>
Signed-off-by: Roxana Nicolescu <roxana.nicolescu@canonical.com>
---
 arch/x86/crypto/sha1_ssse3_glue.c   | 12 ++++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c | 12 ++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
index 44340a1139e0..959afa705e95 100644
--- a/arch/x86/crypto/sha1_ssse3_glue.c
+++ b/arch/x86/crypto/sha1_ssse3_glue.c
@@ -24,8 +24,17 @@
 #include <linux/types.h>
 #include <crypto/sha1.h>
 #include <crypto/sha1_base.h>
+#include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 
+static const struct x86_cpu_id module_cpu_ids[] = {
+	X86_MATCH_FEATURE(X86_FEATURE_AVX2, NULL),
+	X86_MATCH_FEATURE(X86_FEATURE_AVX, NULL),
+	X86_MATCH_FEATURE(X86_FEATURE_SSSE3, NULL),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, module_cpu_ids);
+
 static int sha1_update(struct shash_desc *desc, const u8 *data,
 			     unsigned int len, sha1_block_fn *sha1_xform)
 {
@@ -301,6 +310,9 @@ static inline void unregister_sha1_ni(void) { }
 
 static int __init sha1_ssse3_mod_init(void)
 {
+	if (!x86_match_cpu(module_cpu_ids))
+		return -ENODEV;
+
 	if (register_sha1_ssse3())
 		goto fail;
 
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 3a5f6be7dbba..d25235f0ccaf 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -38,11 +38,20 @@
 #include <crypto/sha2.h>
 #include <crypto/sha256_base.h>
 #include <linux/string.h>
+#include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 
 asmlinkage void sha256_transform_ssse3(struct sha256_state *state,
 				       const u8 *data, int blocks);
 
+static const struct x86_cpu_id module_cpu_ids[] = {
+	X86_MATCH_FEATURE(X86_FEATURE_AVX2, NULL),
+	X86_MATCH_FEATURE(X86_FEATURE_AVX, NULL),
+	X86_MATCH_FEATURE(X86_FEATURE_SSSE3, NULL),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, module_cpu_ids);
+
 static int _sha256_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len, sha256_block_fn *sha256_xform)
 {
@@ -366,6 +375,9 @@ static inline void unregister_sha256_ni(void) { }
 
 static int __init sha256_ssse3_mod_init(void)
 {
+	if (!x86_match_cpu(module_cpu_ids))
+		return -ENODEV;
+
 	if (register_sha256_ssse3())
 		goto fail;
 

base-commit: aed8aee11130a954356200afa3f1b8753e8a9482
-- 
2.34.1

