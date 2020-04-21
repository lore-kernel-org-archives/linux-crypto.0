Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1F6C54FC9
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 07:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A6442087E
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 07:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587454926;
	bh=zfWTlVRklzoUYvYMfb3pgdR/PiiHiH7kW4Od63H4h8s=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ULZ0Fo15U7cmk48GsF3KwcKL1CMToh9RYQ9v+2oZy6+7ZzIMkNtn+bi79KtU5bsHf
	 tVmWWcr//EhrfWsUro7jQ3+UeVJmdcGHKjTC8ZIyqkhFBP0vdMkDUuf/CQYdj1ilGZ
	 06+vYQJgWxv1pi0Bw99s8f6zI304nzGAV+UZZPy8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgDUHmF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 03:42:05 -0400
Received: from conuserg-08.nifty.com ([210.131.2.75]:31854 "EHLO
        conuserg-08.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgDUHmF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 03:42:05 -0400
Received: from oscar.flets-west.jp (softbank126090202047.bbtec.net [126.90.202.47]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id 03L7dstT022941;
        Tue, 21 Apr 2020 16:39:55 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com 03L7dstT022941
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1587454796;
        bh=Zv91K2NSW1zIQUpi6lT8xcoiatIzC59/CNYR7v9KfnQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Wym/VORynZ20qd8805OsjPiCKCp2lfUp/3sN0Q4KmKUws9o7Yl4rm+TpMd/7+dRRn
         v2rugZ3q0v2SLwUYMBhH41UDZdMqpf1815hSaHzp5bWRkvanoA5O7GeFVg8BPuqWiB
         CDd0uvDaJOihngQDK2hcA5W9DRHYtW7lkY9LtYSIrReTryePAKAFXdDlAjSdnoenhJ
         Gqvxf8fwlOyJywJxrqqvCbFVkcLzsxaxLJmupiQWS0gncVYDsBxwhgZYM/Z/OVHEmx
         MlIgCvtCjSP6mg4EkrgzfUHs32pWpHmjhi18gvPEQ55RvUwcrlxBBiGXHsR8daN6C3
         +2OlWPwvcDQLQ==
X-Nifty-SrcIP: [126.90.202.47]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     x86@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
Cc:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org, linux-um@lists.infradead.org
Subject: [PATCH 1/2] x86: check CONFIG options instead of __arch_um__
Date:   Tue, 21 Apr 2020 16:39:46 +0900
Message-Id: <20200421073947.586662-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If the intention is to check i386/x86_64 excluding UML, we can use
CONFIG options instead.

There are only some users of __arch_um__. This commit replaces them,
then removes the __arch_um__ definition.

The original reason for checking __i386__ / __x86_64__ was perhaps
because lib/raid6/algos.c is built not only for the kernel but also
for the user-space test program.

However, lib/raid6/test/Makefile passes -DCONFIG_X86, -DCONFIG_X86_32,
and -DCONFIG_X86_64 for this case. So, I do not see a good reason to
not use CONFIG options here.

What is confusing is, CONFIG_X86_{32,64} is defined not only in
arch/x86/Kconfig, but also in arch/x86/um/Kconfig. To exlucde UML,
we need to check CONFIG_X86 too.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---

 arch/um/Makefile  | 2 +-
 kernel/signal.c   | 2 +-
 lib/raid6/algos.c | 6 ++++--
 lib/raid6/x86.h   | 2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index d2daa206872d..064fbed7a4e9 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -62,7 +62,7 @@ KBUILD_CPPFLAGS += -I$(srctree)/$(HOST_DIR)/um
 #
 # These apply to USER_CFLAGS to.
 
-KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ \
+KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) \
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
 	-Dlongjmp=kernel_longjmp -Dsetjmp=kernel_setjmp \
 	-Din6addr_loopback=kernel_in6addr_loopback \
diff --git a/kernel/signal.c b/kernel/signal.c
index 713104884414..1af3ad707b02 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1246,7 +1246,7 @@ static void print_fatal_signal(int signr)
 	struct pt_regs *regs = signal_pt_regs();
 	pr_info("potentially unexpected fatal signal %d.\n", signr);
 
-#if defined(__i386__) && !defined(__arch_um__)
+#if defined(CONFIG_X86) && defined(CONFIG_X86_32)
 	pr_info("code at %08lx: ", regs->ip);
 	{
 		int i;
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 6d5e5000fdd7..978fa19efbbf 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -29,7 +29,8 @@ struct raid6_calls raid6_call;
 EXPORT_SYMBOL_GPL(raid6_call);
 
 const struct raid6_calls * const raid6_algos[] = {
-#if defined(__i386__) && !defined(__arch_um__)
+#ifdef CONFIG_X86
+#if defined(CONFIG_X86_32)
 #ifdef CONFIG_AS_AVX512
 	&raid6_avx512x2,
 	&raid6_avx512x1,
@@ -43,7 +44,7 @@ const struct raid6_calls * const raid6_algos[] = {
 	&raid6_mmxx2,
 	&raid6_mmxx1,
 #endif
-#if defined(__x86_64__) && !defined(__arch_um__)
+#if defined(CONFIG_X86_64)
 #ifdef CONFIG_AS_AVX512
 	&raid6_avx512x4,
 	&raid6_avx512x2,
@@ -56,6 +57,7 @@ const struct raid6_calls * const raid6_algos[] = {
 	&raid6_sse2x2,
 	&raid6_sse2x1,
 #endif
+#endif /* CONFIG_X86 */
 #ifdef CONFIG_ALTIVEC
 	&raid6_vpermxor8,
 	&raid6_vpermxor4,
diff --git a/lib/raid6/x86.h b/lib/raid6/x86.h
index 9a6ff37115e7..0436b32f7709 100644
--- a/lib/raid6/x86.h
+++ b/lib/raid6/x86.h
@@ -14,7 +14,7 @@
 #ifndef LINUX_RAID_RAID6X86_H
 #define LINUX_RAID_RAID6X86_H
 
-#if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
+#ifdef CONFIG_X86
 
 #ifdef __KERNEL__ /* Real code */
 
-- 
2.25.1

