Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA47C4332B
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB274206F9
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585008944;
	bh=FDoEBBs+HnI4gFuEm/Z1p13b6BibN0GLHt8TNDh+blI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uemzl7aL67crJiraKs4hYBlEXVmcNJH5w4c0fr5I+8gjwwh/aXF0yL9Dc5lkw28al
	 raN9bRDUNxgX8hnuwHAhfs+I9R2B8lWi16vtKf3rMSVhuzLYVmBxj98o4VEHKwsQ7P
	 xukhGBreBtjg40NT/fftokTskF2CeuHSxbGs8+Ew=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgCXAPo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:15:44 -0400
Received: from conuserg-09.nifty.com ([210.131.2.76]:29608 "EHLO
        conuserg-09.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbgCXAPo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 20:15:44 -0400
Received: from grover.flets-west.jp (softbank126093102113.bbtec.net [126.93.102.113]) (authenticated)
        by conuserg-09.nifty.com with ESMTP id 02O0EHnw026701;
        Tue, 24 Mar 2020 09:14:27 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-09.nifty.com 02O0EHnw026701
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585008867;
        bh=eQUmDsxcuakkVwkNBx9dyHAfCNiv3XqyWmjW773HKZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbYcN4ltycVuHSGlbZhSF02txyBiFZVaz8eVguMOcep4QSh8A03F2G1b05ffHSpZA
         YqaLDRnQuQdI7sHagJb1nGRkEurleUcDVuPc1Qxgk1YNuvYWwCE/ftHPTrRW4NALzN
         d+tGEJPRyZv6w+0Cs2jUI9URPe+CObQzjRBe6W+eKxxeB6zE8kS/fR/d3cZVgQGOPg
         cBo8rogLmZn21vXUgH47JdRGXAZoITD+vcqLerWYdmVLFQrtlJitiIdIBC7fDPZ/jV
         G2Y4LpH6OwZscN9zc6kKkqxocKkPOIegkYrdBbKw2OigB5JwSbjJV20+48kRgOTVuj
         dJbEilZlPiwLg==
X-Nifty-SrcIP: [126.93.102.113]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     x86@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH v2 9/9] x86: replace arch macros from compiler with CONFIG_X86_{32,64}
Date:   Tue, 24 Mar 2020 09:13:58 +0900
Message-Id: <20200324001358.4520-10-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324001358.4520-1-masahiroy@kernel.org>
References: <20200324001358.4520-1-masahiroy@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If the intention is to check i386/x86_64 excluding UML,
checking CONFIG_X86_{32,64} is simpler.

The reason for checking __i386__ / __x86_64__ was perhaps because
lib/raid6/algos.c is built not only for the kernel but also for
testing the library code from userspace.

However, lib/raid6/test/Makefile passes -DCONFIG_X86_{32,64} for
this case. So, I do not see a reason to not use CONFIG option here.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

Changes in v2: None

 kernel/signal.c   | 2 +-
 lib/raid6/algos.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 5b2396350dd1..db557e1629e5 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1246,7 +1246,7 @@ static void print_fatal_signal(int signr)
 	struct pt_regs *regs = signal_pt_regs();
 	pr_info("potentially unexpected fatal signal %d.\n", signr);
 
-#if defined(__i386__) && !defined(__arch_um__)
+#ifdef CONFIG_X86_32
 	pr_info("code at %08lx: ", regs->ip);
 	{
 		int i;
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index df08664d3432..b5a02326cfb7 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -29,7 +29,7 @@ struct raid6_calls raid6_call;
 EXPORT_SYMBOL_GPL(raid6_call);
 
 const struct raid6_calls * const raid6_algos[] = {
-#if defined(__i386__) && !defined(__arch_um__)
+#ifdef CONFIG_X86_32
 #ifdef CONFIG_AS_AVX512
 	&raid6_avx512x2,
 	&raid6_avx512x1,
@@ -45,7 +45,7 @@ const struct raid6_calls * const raid6_algos[] = {
 	&raid6_mmxx2,
 	&raid6_mmxx1,
 #endif
-#if defined(__x86_64__) && !defined(__arch_um__)
+#ifdef CONFIG_X86_64
 #ifdef CONFIG_AS_AVX512
 	&raid6_avx512x4,
 	&raid6_avx512x2,
-- 
2.17.1

