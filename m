Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDD1C1975A
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 11:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 180D52076A
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 11:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585136481;
	bh=PR+Ef+7MiScmj+xulyg7hZRwHI5bfGFmYsxdEn4YQhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JPfmdIwmw+5z8J3B/ASw0ovP+UA1kHRA3qh15NqD50oAPPLb1fepDhySzYaVuNHzy
	 YVafmcWEY655T/B14QFUGylyT0sSFxNs77CNCb4qKAzwSORXTs8ZHFpu2Lhyyw/pbp
	 W+wTxVKsFWjpz8Wb6KUv9Vc5y/sgvHHZpgs9gGMw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgCYLlU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Mar 2020 07:41:20 -0400
Received: from foss.arm.com ([217.140.110.172]:47200 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbgCYLlU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Mar 2020 07:41:20 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F251D31B;
        Wed, 25 Mar 2020 04:41:19 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7513D3F71F;
        Wed, 25 Mar 2020 04:41:19 -0700 (PDT)
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3/3] arm64: crypto: Use ARM64_EXTENSIONS()
Date:   Wed, 25 Mar 2020 11:41:10 +0000
Message-Id: <20200325114110.23491-4-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200325114110.23491-1-broonie@kernel.org>
References: <20200325114110.23491-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the newly introduced ARM64_EXTENSIONS() macro to enable the crypto
extensions.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/crypto/aes-ce-ccm-core.S   | 3 ++-
 arch/arm64/crypto/aes-ce-core.S       | 2 +-
 arch/arm64/crypto/aes-ce.S            | 2 +-
 arch/arm64/crypto/crct10dif-ce-core.S | 3 ++-
 arch/arm64/crypto/ghash-ce-core.S     | 3 ++-
 arch/arm64/crypto/sha1-ce-core.S      | 3 ++-
 arch/arm64/crypto/sha2-ce-core.S      | 3 ++-
 7 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/crypto/aes-ce-ccm-core.S b/arch/arm64/crypto/aes-ce-ccm-core.S
index 99a028e298ed..bb6d85c2a260 100644
--- a/arch/arm64/crypto/aes-ce-ccm-core.S
+++ b/arch/arm64/crypto/aes-ce-ccm-core.S
@@ -9,7 +9,8 @@
 #include <asm/assembler.h>
 
 	.text
-	.arch	armv8-a+crypto
+
+ARM64_EXTENSIONS(crypto)
 
 	/*
 	 * void ce_aes_ccm_auth_data(u8 mac[], u8 const in[], u32 abytes,
diff --git a/arch/arm64/crypto/aes-ce-core.S b/arch/arm64/crypto/aes-ce-core.S
index e52e13eb8fdb..a8291111f68d 100644
--- a/arch/arm64/crypto/aes-ce-core.S
+++ b/arch/arm64/crypto/aes-ce-core.S
@@ -6,7 +6,7 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
-	.arch		armv8-a+crypto
+ARM64_EXTENSIONS(crypto)
 
 SYM_FUNC_START(__aes_ce_encrypt)
 	sub		w3, w3, #2
diff --git a/arch/arm64/crypto/aes-ce.S b/arch/arm64/crypto/aes-ce.S
index 1dc5bbbfeed2..6493a8e8d8d0 100644
--- a/arch/arm64/crypto/aes-ce.S
+++ b/arch/arm64/crypto/aes-ce.S
@@ -12,7 +12,7 @@
 #define AES_FUNC_START(func)		SYM_FUNC_START(ce_ ## func)
 #define AES_FUNC_END(func)		SYM_FUNC_END(ce_ ## func)
 
-	.arch		armv8-a+crypto
+ARM64_EXTENSIONS(crypto)
 
 	xtsmask		.req	v16
 	cbciv		.req	v16
diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index 5a95c2628fbf..bb6f3a14e9e8 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -66,7 +66,8 @@
 #include <asm/assembler.h>
 
 	.text
-	.cpu		generic+crypto
+
+ARM64_EXTENSIONS(crypto)
 
 	init_crc	.req	w19
 	buf		.req	x20
diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index 6b958dcdf136..85839b701c83 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -57,7 +57,8 @@
 	HH34		.req	v19
 
 	.text
-	.arch		armv8-a+crypto
+
+ARM64_EXTENSIONS(crypto)
 
 	.macro		__pmull_p64, rd, rn, rm
 	pmull		\rd\().1q, \rn\().1d, \rm\().1d
diff --git a/arch/arm64/crypto/sha1-ce-core.S b/arch/arm64/crypto/sha1-ce-core.S
index 92d0d2753e81..8fa2d920be36 100644
--- a/arch/arm64/crypto/sha1-ce-core.S
+++ b/arch/arm64/crypto/sha1-ce-core.S
@@ -9,7 +9,8 @@
 #include <asm/assembler.h>
 
 	.text
-	.arch		armv8-a+crypto
+
+ARM64_EXTENSIONS(crypto)
 
 	k0		.req	v0
 	k1		.req	v1
diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index 3f9d0f326987..d8680b43a3fd 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -9,7 +9,8 @@
 #include <asm/assembler.h>
 
 	.text
-	.arch		armv8-a+crypto
+
+ARM64_EXTENSIONS(crypto)
 
 	dga		.req	q20
 	dgav		.req	v20
-- 
2.20.1

