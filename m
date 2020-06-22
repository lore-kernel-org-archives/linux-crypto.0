Return-Path: <SRS0=/YgZ=AD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56456C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 15:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35CAB20716
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 15:50:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G7XYSMvo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgFVPua (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jun 2020 11:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729493AbgFVPu3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jun 2020 11:50:29 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E40FC061573;
        Mon, 22 Jun 2020 08:50:29 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l11so17225509wru.0;
        Mon, 22 Jun 2020 08:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A9RIkDdR+eW81+khisoGH0wOpXlMTKss39s/rvDLd5c=;
        b=G7XYSMvoQzkIe/kigarObt0EQulVm934Rk3pUYF7HFTav/SoMUqr5KVQ4675We5OoP
         kowuWeAZOrnPmUgNu4ZEY+jhDDsZmmY+VQ8jkw+g+U5pR35n1fUTzSxB4EN/fRCTKViB
         AZIp0Wp5Lh0rGykc0uuX0yVwIaYQXjdxD7fVhcuzuMpJUZ2cKdz6KPBDHqryPxadW7WO
         5L1cSVociJPB0SPD7Amv4iPlmU8UWCc4niC31oGbszG+2Ex0EKUOCtDspa5v0xLLZM/M
         Cw60QyH/AtSiUzg+TzQJPDUf9m5x6VFXIBZ4/XrhoNJ4/nzzht6PGphlPhUHRwDULsW2
         npAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A9RIkDdR+eW81+khisoGH0wOpXlMTKss39s/rvDLd5c=;
        b=pO++lH93dveu0FiW9O/FbEchjHnpGueXyDQSIlEJwG2hlxCtvRFidv7IWSUzmjSOHm
         mRD70cHYUe0tn+y6GKwn3Yuchh4CP1ib55/SolBlJDBGkHlVI0x2s+WjqT8xXcsiwWcc
         ZoyKGqWNk2vN96301BNcdvyejqrJczls4b1Z+az3huNAG7CKB20arWxNvJ9HjzBtmWpj
         Wn96E+GqWmHBUGEXPVdEEVW1bY/LJS4uNvOEJZH1NU7G8kS/tFc2MhWjFxSJWF1e6hTI
         +c3BSdREP+rjv7almggKqTs/ABv00JT4g5twEUTd74wvLjVWSVGJYv47Lq/JNq4W1TTk
         MMYw==
X-Gm-Message-State: AOAM530bW/tZBuW4LwkFuqrTWheKbXnjj/eEbg6ZwfC2Xb+2pMNoI0+W
        eAqU2X5ONfcr53o8rFUwplT1aSPNnKY=
X-Google-Smtp-Source: ABdhPJzNoXWFTLmRsytfHlcscpJv6h+Z67Ft5meox1L1/lo+eUuPs+9Yjpbwek1U60VA/uCYzqOF7Q==
X-Received: by 2002:adf:edc8:: with SMTP id v8mr18278992wro.125.1592841028007;
        Mon, 22 Jun 2020 08:50:28 -0700 (PDT)
Received: from localhost.localdomain ([46.114.108.171])
        by smtp.gmail.com with ESMTPSA id t205sm1190169wmt.8.2020.06.22.08.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 08:50:27 -0700 (PDT)
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
        Craig Topper <craig.topper@gmail.com>
Subject: [PATCH 5.7] x86/crypto: aesni: Fix build with LLVM_IAS=1
Date:   Mon, 22 Jun 2020 17:50:18 +0200
Message-Id: <20200622155018.6043-1-sedat.dilek@gmail.com>
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
1. GCM_ENC_DEC dec -> GCM_ENC_DEC DEC
2. GCM_ENC_DEC enc -> GCM_ENC_DEC ENC

With these changes I was able to build with LLVM_IAS=1 and boot on bare metal.

As llvm-toolchain I used v10.0.1-rc1+ and v11.0.0-git pre-releases:
1. release/10.x Git: 2dc664d578f0e9c8ea5975eed745e322fa77bffe
2.       master Git: 8da5b9083691b557f50f72ab099598bb291aec5f (default)

Just for the sake of completeness:
1. CONFIG_DEBUG_INFO_DWARF4=y
2. OBJDUMP=llvm-objdump (passed to my make-line)

Please have a look into "llvm.rst" kernel-doc for further informations and
how to pass LLVM kbuild-options to your make-line.

I confirmed that this works with Linux-kernel v5.7.3 and v5.7.5 final.

NOTE: This patch is on top of Linux v5.7 final.

Thanks to Craig and the folks from the ClangBuiltLinux project.

Cc: Craig Topper <craig.topper@intel.com>
Cc: Craig Topper <craig.topper@gmail.com>
Cc: Nick Desaulniers ndesaulniers@google.com
Cc: "ClangBuiltLinux" <clang-built-linux@googlegroups.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1050
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/kbuild/llvm.rst

---
 arch/x86/crypto/aesni-intel_asm.S | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index cad6e1bfa7d5..983eb2eec51a 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -266,7 +266,7 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	PSHUFB_XMM %xmm2, %xmm0
 	movdqu %xmm0, CurCount(%arg2) # ctx_data.current_counter = iv
 
-	PRECOMPUTE \SUBKEY, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
+	PRECOMPUTE \SUBKEY, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7
 	movdqu HashKey(%arg2), %xmm13
 
 	CALC_AAD_HASH %xmm13, \AAD, \AADLEN, %xmm0, %xmm1, %xmm2, %xmm3, \
@@ -1596,7 +1596,7 @@ SYM_FUNC_START(aesni_gcm_dec)
 	FUNC_SAVE
 
 	GCM_INIT %arg6, arg7, arg8, arg9
-	GCM_ENC_DEC dec
+	GCM_ENC_DEC DEC
 	GCM_COMPLETE arg10, arg11
 	FUNC_RESTORE
 	ret
@@ -1684,7 +1684,7 @@ SYM_FUNC_START(aesni_gcm_enc)
 	FUNC_SAVE
 
 	GCM_INIT %arg6, arg7, arg8, arg9
-	GCM_ENC_DEC enc
+	GCM_ENC_DEC ENC
 
 	GCM_COMPLETE arg10, arg11
 	FUNC_RESTORE
@@ -1719,7 +1719,7 @@ SYM_FUNC_END(aesni_gcm_init)
 */
 SYM_FUNC_START(aesni_gcm_enc_update)
 	FUNC_SAVE
-	GCM_ENC_DEC enc
+	GCM_ENC_DEC ENC
 	FUNC_RESTORE
 	ret
 SYM_FUNC_END(aesni_gcm_enc_update)
@@ -1734,7 +1734,7 @@ SYM_FUNC_END(aesni_gcm_enc_update)
 */
 SYM_FUNC_START(aesni_gcm_dec_update)
 	FUNC_SAVE
-	GCM_ENC_DEC dec
+	GCM_ENC_DEC DEC
 	FUNC_RESTORE
 	ret
 SYM_FUNC_END(aesni_gcm_dec_update)
-- 
2.27.0

