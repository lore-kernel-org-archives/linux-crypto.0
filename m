From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] crypto: camellia: add missing declarations
Date: Mon, 16 Jan 2017 17:06:51 +0100
Message-ID: <1484582811-3505-1-git-send-email-hofrat@osadl.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <hofrat@osadl.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:57611 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750863AbdAPQF5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Jan 2017 11:05:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add declarations for the camellia substitution box to allow a clean build.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---
Problem reported by sparse
arch/x86/crypto/camellia_glue.c:65:21: warning: symbol 'camellia_sp10011110' was not declared. Should it be static?
arch/x86/crypto/camellia_glue.c:154:21: warning: symbol 'camellia_sp22000222' was not declared. Should it be static?
arch/x86/crypto/camellia_glue.c:243:21: warning: symbol 'camellia_sp03303033' was not declared. Should it be static?
arch/x86/crypto/camellia_glue.c:332:21: warning: symbol 'camellia_sp00444404' was not declared. Should it be static?
arch/x86/crypto/camellia_glue.c:421:21: warning: symbol 'camellia_sp02220222' was not declared. Should it be static?
arch/x86/crypto/camellia_glue.c:510:21: warning: symbol 'camellia_sp30333033' was not declared. Should it be static?
arch/x86/crypto/camellia_glue.c:599:21: warning: symbol 'camellia_sp44044404' was not declared. Should it be static?
arch/x86/crypto/camellia_glue.c:688:21: warning: symbol 'camellia_sp11101110' was not declared. Should it be static?

Patch was compile tested with: x86_64_defconfig +
CONFIG_CRYPTO_CAMELLIA_X86_64=m

Patch is against 4.10-rc3 (localversion-next is next-20170116)

 arch/x86/include/asm/crypto/camellia.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/crypto/camellia.h b/arch/x86/include/asm/crypto/camellia.h
index bb93333..1cb98f2 100644
--- a/arch/x86/include/asm/crypto/camellia.h
+++ b/arch/x86/include/asm/crypto/camellia.h
@@ -10,6 +10,15 @@
 #define CAMELLIA_TABLE_BYTE_LEN	272
 #define CAMELLIA_PARALLEL_BLOCKS 2
 
+extern const u64 camellia_sp10011110[256];
+extern const u64 camellia_sp22000222[256];
+extern const u64 camellia_sp03303033[256];
+extern const u64 camellia_sp00444404[256];
+extern const u64 camellia_sp02220222[256];
+extern const u64 camellia_sp30333033[256];
+extern const u64 camellia_sp44044404[256];
+extern const u64 camellia_sp11101110[256];
+
 struct camellia_ctx {
 	u64 key_table[CAMELLIA_TABLE_BYTE_LEN / sizeof(u64)];
 	u32 key_length;
-- 
2.1.4
