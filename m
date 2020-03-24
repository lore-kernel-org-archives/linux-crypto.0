Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09817C4332B
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6689206F9
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585008947;
	bh=/t8E5mF7gLl3InIp7W2BY/pKTGVQfH//5zDOuzQasXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=A7DTjUwWKg3qL/aLL7Cf2pZ91Nv5k2DpAyNbPGNSAjx/z7pFWJJpuxm7YrT68G/ix
	 htR5PWtOCM78zn7uqr97TCAg+u/eSDFVPwwMp3t9CpVD3Ue5M0o31ma7N6AROBtpGq
	 iewk9iKpIknZVNH2jZPmNHVUD164p1yK993vPqrw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgCXAPr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:15:47 -0400
Received: from conuserg-09.nifty.com ([210.131.2.76]:29705 "EHLO
        conuserg-09.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbgCXAPr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 20:15:47 -0400
Received: from grover.flets-west.jp (softbank126093102113.bbtec.net [126.93.102.113]) (authenticated)
        by conuserg-09.nifty.com with ESMTP id 02O0EHnp026701;
        Tue, 24 Mar 2020 09:14:20 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-09.nifty.com 02O0EHnp026701
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585008860;
        bh=w76PdnLBUJ71LHvA8T4MOfRPh/Z+7+i64nMxwKp/rWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dL37O19aq5cHlCk6J0qsXuZHNPVvSsdRbW3xKUBbMxhvYTs7svhNT2REU6qk8LbCa
         Qc8Hp8lGkbZaXqpNvajFhjA3MaxCl9oWxk/7WfM0HNiyLkoOjup6YElbSO26liMtv1
         BHRS40hQCZ6KOlUPhvJVnOyAfH1GdGFXPbPDQmj6Jqn7EEgRhMC0miqp9cJiP4Wmq3
         OAvNhdVzVmK8u1CT6xTgz5j+vWfVtVvEm5EkPcLrg/f3TMaYdYNXkZ1Ra5ECeHECRV
         frcdJZxpBQSkxim19W9eOobt3mHmm3CrqKaEsf/DYncI5hPsQtWOOgapTibiQtXQng
         c0PYQql0NhnXg==
X-Nifty-SrcIP: [126.93.102.113]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     x86@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 2/9] x86: remove unneeded defined(__ASSEMBLY__) check from asm/dwarf2.h
Date:   Tue, 24 Mar 2020 09:13:51 +0900
Message-Id: <20200324001358.4520-3-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324001358.4520-1-masahiroy@kernel.org>
References: <20200324001358.4520-1-masahiroy@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This header file has the following check at the top:

  #ifndef __ASSEMBLY__
  #warning "asm/dwarf2.h should be only included in pure assembly files"
  #endif

So, we expect defined(__ASSEMBLY__) is always true.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
---

Changes in v2: None

 arch/x86/include/asm/dwarf2.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index ae391f609840..5a0502212bc5 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -36,7 +36,7 @@
 #define CFI_SIGNAL_FRAME
 #endif
 
-#if defined(CONFIG_AS_CFI_SECTIONS) && defined(__ASSEMBLY__)
+#if defined(CONFIG_AS_CFI_SECTIONS)
 #ifndef BUILD_VDSO
 	/*
 	 * Emit CFI data in .debug_frame sections, not .eh_frame sections.
-- 
2.17.1

