Return-Path: <SRS0=WfFd=5F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE526C4332B
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 23:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77FC62072C
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 23:54:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WuxRt2Gn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgCTXyA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Mar 2020 19:54:00 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:53063 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgCTXyA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Mar 2020 19:54:00 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b4c7f8d8;
        Fri, 20 Mar 2020 23:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=Mtj2WRqHX3tgMyvl90+dc3Czy10=; b=WuxRt2
        GnkKVyNhw21V8+90/uKXGU0p3tyz0cRd3azMH143xDiKaNKbkdZG83IHxWUHWM6F
        FxRyu7XqRyRX/mx3XeB74X2ylvaR234sfOCRC3RDeRp3uZ0i7gGyAtvytHYrXXqe
        Bu12ONv1gzEg6DWE3YgBFSN4Z1rCaUPAagiyp6NymIheLmpqiaPi3XQjnwihK+Wq
        aZeUyyiF9qhyGgOvZ/vneZzVJZD/u2bcrzoMhDaRi2REEo2MlzWbnEndlw/KLRQl
        FDRrbqTTvdkXANH54ZWM46/qEmyaaEd6wYg4DeyXCtNMPzKs1vKuxd2P54IIfKsK
        Au2+pTI1vN37plpA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 383b6d3b (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 20 Mar 2020 23:47:18 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id q9so7950166iod.4;
        Fri, 20 Mar 2020 16:53:58 -0700 (PDT)
X-Gm-Message-State: ANhLgQ3QaR+aQZ+wMzJi1A/4bcAJ3awiu3N+XDO+QGbLPb5C+DiU6XIy
        cAQQSZp2nSQ67h39c6LNvBVDqxqiT2lV3BZ+mos=
X-Google-Smtp-Source: ADFU+vtD2BOYtouQvGPrKn2qGzWbV9DrmPDWV/bENvOwrYIOXBNvHBBFneWZTychusgjfeKVQUaJE7Ai014Nkod+OK4=
X-Received: by 2002:a6b:7902:: with SMTP id i2mr9941218iop.67.1584748437245;
 Fri, 20 Mar 2020 16:53:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190916084901.GA20338@gondor.apana.org.au> <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au> <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au> <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200224060042.GA26184@gondor.apana.org.au> <20200312115714.GA21470@gondor.apana.org.au>
 <CAHk-=wjbTF2iw3EbKgfiRRq_keb4fHwLO8xJyRXbfK3Q7cscuQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjbTF2iw3EbKgfiRRq_keb4fHwLO8xJyRXbfK3Q7cscuQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 20 Mar 2020 17:53:46 -0600
X-Gmail-Original-Message-ID: <CAHmME9pME41uHvhu5f_JGZbUNCuG0YVgRkBUQF9wtTO6YnMijw@mail.gmail.com>
Message-ID: <CAHmME9pME41uHvhu5f_JGZbUNCuG0YVgRkBUQF9wtTO6YnMijw@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Fixes for 5.6
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Funny, I always thought it was like that "for a good reason" that I
just didn't know about -- assumedly something having to do with a
difference between config time and compile time. I agree with you that
everything gets so much cleaner if we can do this in Kconfig. I've put
together the patch pasted below, which appears to work well. I'll work
on replumbing the other stuff and will send a series off to the list
hopefully not before too long.

From 12375354ddb4c8b1c75663312a9b6d9b9bc5f520 Mon Sep 17 00:00:00 2001
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 20 Mar 2020 17:49:36 -0600
Subject: [PATCH] x86: probe assembler instead of kconfig instead of makefile

Doing this probing inside of the Makefiles means we have a maze of
ifdefs inside the source code and child Makefiles that need to make
proper decisions on this too. Instead, we do it at Kconfig time, like
many other compiler and assembler options, which allows us to set up the
dependencies normally for full compilation units.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/x86/Kconfig           |  2 ++
 arch/x86/Kconfig.assembler | 33 +++++++++++++++++++++++++++++++++
 arch/x86/Makefile          | 22 ----------------------
 3 files changed, 35 insertions(+), 22 deletions(-)
 create mode 100644 arch/x86/Kconfig.assembler

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index beea77046f9b..707673227837 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2935,3 +2935,5 @@ config HAVE_ATOMIC_IOMAP
 source "drivers/firmware/Kconfig"

 source "arch/x86/kvm/Kconfig"
+
+source "arch/x86/Kconfig.assembler"
diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
new file mode 100644
index 000000000000..809adcf6f7c3
--- /dev/null
+++ b/arch/x86/Kconfig.assembler
@@ -0,0 +1,33 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2020 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+
+config AS_CFI
+ def_bool $(as-instr,.cfi_startproc\n.cfi_rel_offset
rsp$(comma)0\n.cfi_endproc) if 64BIT
+ def_bool $(as-instr,.cfi_startproc\n.cfi_rel_offset
esp$(comma)0\n.cfi_endproc) if !64BIT
+
+config AS_CFI_SIGNAL_FRAME
+ def_bool $(as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc)
+
+config AS_CFI_SECTIONS
+ def_bool $(as-instr,.cfi_sections .debug_frame)
+
+config AS_SSSE3
+ def_bool $(as-instr,pshufb %xmm0$(comma)%xmm0)
+
+config AS_AVX
+ def_bool $(as-instr,vxorps %ymm0$(comma)%ymm1$(comma)%ymm2)
+
+config AS_AVX2
+ def_bool $(as-instr,vpbroadcastb %xmm0$(comma)%ymm1)
+
+config AS_AVX512
+ def_bool $(as-instr,vpmovm2b %k1$(comma)%zmm5)
+
+config AS_SHA1_NI
+ def_bool $(as-instr,sha1msg1 %xmm0$(comma)%xmm1)
+
+config AS_SHA256_NI
+ def_bool $(as-instr,sha256msg1 %xmm0$(comma)%xmm1)
+
+config AS_ADX
+ def_bool $(as-instr,adox %r10$(comma)%r10)
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 513a55562d75..b65ec63c7db7 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -177,28 +177,6 @@ ifeq ($(ACCUMULATE_OUTGOING_ARGS), 1)
  KBUILD_CFLAGS += $(call cc-option,-maccumulate-outgoing-args,)
 endif

-# Stackpointer is addressed different for 32 bit and 64 bit x86
-sp-$(CONFIG_X86_32) := esp
-sp-$(CONFIG_X86_64) := rsp
-
-# do binutils support CFI?
-cfi := $(call as-instr,.cfi_startproc\n.cfi_rel_offset
$(sp-y)$(comma)0\n.cfi_endproc,-DCONFIG_AS_CFI=1)
-# is .cfi_signal_frame supported too?
-cfi-sigframe := $(call
as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1)
-cfi-sections := $(call as-instr,.cfi_sections
.debug_frame,-DCONFIG_AS_CFI_SECTIONS=1)
-
-# does binutils support specific instructions?
-asinstr += $(call as-instr,pshufb %xmm0$(comma)%xmm0,-DCONFIG_AS_SSSE3=1)
-avx_instr := $(call as-instr,vxorps
%ymm0$(comma)%ymm1$(comma)%ymm2,-DCONFIG_AS_AVX=1)
-avx2_instr :=$(call as-instr,vpbroadcastb
%xmm0$(comma)%ymm1,-DCONFIG_AS_AVX2=1)
-avx512_instr :=$(call as-instr,vpmovm2b %k1$(comma)%zmm5,-DCONFIG_AS_AVX512=1)
-sha1_ni_instr :=$(call as-instr,sha1msg1
%xmm0$(comma)%xmm1,-DCONFIG_AS_SHA1_NI=1)
-sha256_ni_instr :=$(call as-instr,sha256msg1
%xmm0$(comma)%xmm1,-DCONFIG_AS_SHA256_NI=1)
-adx_instr := $(call as-instr,adox %r10$(comma)%r10,-DCONFIG_AS_ADX=1)
-
-KBUILD_AFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr)
$(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr)
$(sha256_ni_instr) $(adx_instr)
-KBUILD_CFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr)
$(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr)
$(sha256_ni_instr) $(adx_instr)
-
 KBUILD_LDFLAGS := -m elf_$(UTS_MACHINE)

 #
-- 
2.25.1
