Return-Path: <SRS0=tj8v=AO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9544FC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 14:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6651F20737
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Jul 2020 14:32:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RQPqUTY/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgGCOcX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Jul 2020 10:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbgGCOcX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Jul 2020 10:32:23 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FDCC08C5C1;
        Fri,  3 Jul 2020 07:32:23 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z13so32924805wrw.5;
        Fri, 03 Jul 2020 07:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aBK4xIyiQPwE9WexL/fXXMXlCGSw5m4ZqDOwI6txEYA=;
        b=RQPqUTY/F6g+PNFqX25BZvfKdVEOIfpvm1iucZNgnLH0Uo7mOKxWs9L/PqTHdkwK19
         vMFosRcSQ8YZJUJysCLrmlKLR2+l057HDLryRgbpVpg2Gzd3Qt6xDw+sRqVVvH7EkKKg
         KFsTmfNDanq88GCZzjUiAM1EYQL34FW/B0TNYAABXppTitTgFoXv5RW4jXH6Z3H+Su9y
         GFm6OPx4y+e+If22oOm9KQcbZhfTyuxVB2+Ps9ndEiKiXU0+VqUBDyxIe/xp39bVadij
         44UM6YJxwVC4fTLozxqX5kPEDmAgb9ZKKrTfVJXhlhBcTxv55KfvHGyP6yrEbBTW5JrW
         BBoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aBK4xIyiQPwE9WexL/fXXMXlCGSw5m4ZqDOwI6txEYA=;
        b=G0XEGvJvrPo+A2xn5QRu0fmNwQd7f9voy5ceyyCNBbIcVQGBVDHSpKZSzqpuXGp/D8
         3CcEtRNZajyL3P1ci8IrWK4XJ8Pk1WMqWt0nnzFqwVh861Ju3UCFItTeMen+8FY6JKM0
         XEVAcm2aIk7vTvrBf6/t9k1KD980gsbmQa0RMhf/Z87hBy3PmmWTb4W6QTm18Pz+BWjW
         nH/lYHQ0Nag50Rp96Rh/dQYMFxHbedARkaaGRZ9d3FDPFtrlhi3Y2t1oRYRRs455n13S
         Fcg8UX+WHXE9zzpEdnuqXuXDZopgZnaWjnXKurCHZDl8Md9ZHNMOhWAgfT7yVNnjNcO8
         CpZA==
X-Gm-Message-State: AOAM530IF39d5zbQ+26BlJHFWgKEF5jgO0X7Ms2nI1i+JVOF/w942wC3
        1UXtUzFp2RsJ2crtaY53oLg=
X-Google-Smtp-Source: ABdhPJwnKV/whFu7kraxtSUgzHib+rERP9qi2bi30aMo/ssL/efH5f0+XW3EGBRUQ7bFUmgcDy6v3Q==
X-Received: by 2002:a05:6000:1006:: with SMTP id a6mr35476948wrx.332.1593786741925;
        Fri, 03 Jul 2020 07:32:21 -0700 (PDT)
Received: from localhost.localdomain ([46.114.106.37])
        by smtp.gmail.com with ESMTPSA id z16sm14116810wrr.35.2020.07.03.07.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 07:32:21 -0700 (PDT)
From:   Sedat Dilek <sedat.dilek@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Cc:     Sedat Dilek <sedat.dilek@gmail.com>,
        Craig Topper <craig.topper@intel.com>,
        Craig Topper <craig.topper@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH v5] x86/crypto: aesni: Fix build with LLVM_IAS=1
Date:   Fri,  3 Jul 2020 16:32:06 +0200
Message-Id: <20200703143206.3994-1-sedat.dilek@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When building with LLVM_IAS=1 means using Clang's Integrated Assembly (IAS)
from LLVM/Clang >= v10.0.1-rc1+ instead of GNU/as from GNU/binutils
I see the following breakage in Debian/testing AMD64:

<instantiation>:15:74: error: too many positional arguments
 PRECOMPUTE 8*3+8(%rsp), %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
                                                                         ^
 arch/x86/crypto/aesni-intel_asm.S:1598:2: note: while in macro instantiation
 GCM_INIT %r9, 8*3 +8(%rsp), 8*3 +16(%rsp), 8*3 +24(%rsp)
 ^
<instantiation>:47:2: error: unknown use of instruction mnemonic without a size suffix
 GHASH_4_ENCRYPT_4_PARALLEL_dec %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, enc
 ^
arch/x86/crypto/aesni-intel_asm.S:1599:2: note: while in macro instantiation
 GCM_ENC_DEC dec
 ^
<instantiation>:15:74: error: too many positional arguments
 PRECOMPUTE 8*3+8(%rsp), %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
                                                                         ^
arch/x86/crypto/aesni-intel_asm.S:1686:2: note: while in macro instantiation
 GCM_INIT %r9, 8*3 +8(%rsp), 8*3 +16(%rsp), 8*3 +24(%rsp)
 ^
<instantiation>:47:2: error: unknown use of instruction mnemonic without a size suffix
 GHASH_4_ENCRYPT_4_PARALLEL_enc %xmm9, %xmm10, %xmm11, %xmm12, %xmm13, %xmm14, %xmm0, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7, %xmm8, enc
 ^
arch/x86/crypto/aesni-intel_asm.S:1687:2: note: while in macro instantiation
 GCM_ENC_DEC enc

Craig Topper suggested me in ClangBuiltLinux issue #1050:

> I think the "too many positional arguments" is because the parser isn't able
> to handle the trailing commas.
>
> The "unknown use of instruction mnemonic" is because the macro was named
> GHASH_4_ENCRYPT_4_PARALLEL_DEC but its being instantiated with
> GHASH_4_ENCRYPT_4_PARALLEL_dec I guess gas ignores case on the
> macro instantiation, but llvm doesn't.

First, I removed the trailing comma in the PRECOMPUTE line.

Second, I substituted:
1. GHASH_4_ENCRYPT_4_PARALLEL_DEC -> GHASH_4_ENCRYPT_4_PARALLEL_dec
2. GHASH_4_ENCRYPT_4_PARALLEL_ENC -> GHASH_4_ENCRYPT_4_PARALLEL_enc

With these changes I was able to build with LLVM_IAS=1 and boot on bare metal.

I confirmed that this works with Linux-kernel v5.7.5 final.

NOTE: This patch is on top of Linux v5.7 final.

Thanks to Craig and especially Nick for double-checking and his comments.

Suggested-by: Craig Topper <craig.topper@intel.com>
Suggested-by: Craig Topper <craig.topper@gmail.com>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: "ClangBuiltLinux" <clang-built-linux@googlegroups.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1050
Link: https://bugs.llvm.org/show_bug.cgi?id=24494
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
Changes v4->v5:
- Drop "5.7" tag from subject line as requested by Herbert Xu
- Add Link to LLVM bug #24494 (thanks Nick)

Changes v3->v4:
- Add <> around email address as desired by Nick
- Add Nick's Reviewed-by

Changes v2->v3:
- Add this Changelog

Changes v1->v2:
- Replace Cc by Suggested-by for Craig
- Replace Cc by Suggested-by for Nick (dropped Cc as desired)
- Really follow the suggestions of Craig
- Drop unneeded comments for my build-environment and Links

 arch/x86/crypto/aesni-intel_asm.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index cad6e1bfa7d5..c216de287742 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -266,7 +266,7 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	PSHUFB_XMM %xmm2, %xmm0
 	movdqu %xmm0, CurCount(%arg2) # ctx_data.current_counter = iv
 
-	PRECOMPUTE \SUBKEY, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
+	PRECOMPUTE \SUBKEY, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7
 	movdqu HashKey(%arg2), %xmm13
 
 	CALC_AAD_HASH %xmm13, \AAD, \AADLEN, %xmm0, %xmm1, %xmm2, %xmm3, \
@@ -978,7 +978,7 @@ _initial_blocks_done\@:
 * arg1, %arg3, %arg4 are used as pointers only, not modified
 * %r11 is the data offset value
 */
-.macro GHASH_4_ENCRYPT_4_PARALLEL_ENC TMP1 TMP2 TMP3 TMP4 TMP5 \
+.macro GHASH_4_ENCRYPT_4_PARALLEL_enc TMP1 TMP2 TMP3 TMP4 TMP5 \
 TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 
 	movdqa	  \XMM1, \XMM5
@@ -1186,7 +1186,7 @@ aes_loop_par_enc_done\@:
 * arg1, %arg3, %arg4 are used as pointers only, not modified
 * %r11 is the data offset value
 */
-.macro GHASH_4_ENCRYPT_4_PARALLEL_DEC TMP1 TMP2 TMP3 TMP4 TMP5 \
+.macro GHASH_4_ENCRYPT_4_PARALLEL_dec TMP1 TMP2 TMP3 TMP4 TMP5 \
 TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 
 	movdqa	  \XMM1, \XMM5
-- 
2.27.0

