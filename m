Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C45C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 03:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A10BE60F59
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 03:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbhJODtn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Oct 2021 23:49:43 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:41164 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229907AbhJODtn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Oct 2021 23:49:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0Us1MPhB_1634269654;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Us1MPhB_1634269654)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Oct 2021 11:47:35 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Heyuan Shi <heyuan@linux.alibaba.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] crypto: x86/sm4 - Fix invalid section entry size
Date:   Fri, 15 Oct 2021 11:47:33 +0800
Message-Id: <20211015034733.51205-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fixes the following warning:

  vmlinux.o: warning: objtool: elf_update: invalid section entry size

The size of the rodata section is 164 bytes, directly using the
entry_size of 164 bytes will cause errors in some versions of the
gcc compiler, while using 16 bytes directly will cause errors in
the clang compiler. This patch correct it by filling the size of
rodata to a 16-byte boundary.

Fixes: a7ee22ee1445 ("crypto: x86/sm4 - add AES-NI/AVX/x86_64 implementation")
Fixes: 5b2efa2bb865 ("crypto: x86/sm4 - add AES-NI/AVX2/x86_64 implementation")
Reported-by: Peter Zijlstra <peterz@infradead.org>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Tested-by: Heyuan Shi <heyuan@linux.alibaba.com>
---
 arch/x86/crypto/sm4-aesni-avx-asm_64.S  | 6 +++++-
 arch/x86/crypto/sm4-aesni-avx2-asm_64.S | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/sm4-aesni-avx-asm_64.S b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
index 18d2f5199194..1cc72b4804fa 100644
--- a/arch/x86/crypto/sm4-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/sm4-aesni-avx-asm_64.S
@@ -78,7 +78,7 @@
 	vpxor tmp0, x, x;
 
 
-.section	.rodata.cst164, "aM", @progbits, 164
+.section	.rodata.cst16, "aM", @progbits, 16
 .align 16
 
 /*
@@ -133,6 +133,10 @@
 .L0f0f0f0f:
 	.long 0x0f0f0f0f
 
+/* 12 bytes, only for padding */
+.Lpadding_deadbeef:
+	.long 0xdeadbeef, 0xdeadbeef, 0xdeadbeef
+
 
 .text
 .align 16
diff --git a/arch/x86/crypto/sm4-aesni-avx2-asm_64.S b/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
index d2ffd7f76ee2..9c5d3f3ad45a 100644
--- a/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/sm4-aesni-avx2-asm_64.S
@@ -93,7 +93,7 @@
 	vpxor tmp0, x, x;
 
 
-.section	.rodata.cst164, "aM", @progbits, 164
+.section	.rodata.cst16, "aM", @progbits, 16
 .align 16
 
 /*
@@ -148,6 +148,10 @@
 .L0f0f0f0f:
 	.long 0x0f0f0f0f
 
+/* 12 bytes, only for padding */
+.Lpadding_deadbeef:
+	.long 0xdeadbeef, 0xdeadbeef, 0xdeadbeef
+
 .text
 .align 16
 
-- 
2.24.3 (Apple Git-128)

