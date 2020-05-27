Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AA3C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 14:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 016212073B
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 14:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389018AbgE0OSo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 10:18:44 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:51389 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388854AbgE0OSo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 10:18:44 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N3KgE-1ivQwf2h9O-010IcZ; Wed, 27 May 2020 16:17:59 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] x86: crypto: fix building crc32c with clang ias
Date:   Wed, 27 May 2020 16:17:40 +0200
Message-Id: <20200527141754.1850968-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:HhqJ2SV7RLSWCbDR/hTyZUI75A0ol3DrkPR+HKRt8s2B+uKPzr5
 sGoQbkyCOlcIasQJ4GxCZxVJVCybUkZrIKlLy9IDynmJxpbIr6jtpJwOIoBO7FElWCEZyX0
 PVTkdYDcAY6ovzIwph/0l4Pa5R7bYypb4vviB8FW3s/p3tFLishxI/6QBcuV2p/+K6l/MrR
 vuKeLGO1IwcOUFrRIWiYQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:WHbYaBFBR0Q=:+FS4KQXcRW9hNJM+f4Yhoc
 n7YjB7WfPFDkXieTES6QHnUzoXVQgicGfYasQXOkI0naBVDmtab6F8J2wJ9b/WrpeTPt9GeJx
 N+NN5PuTK+3GH9+WTU72Q3WxfbiV2M+3TG2amqi/CAfUfbREAVuYK2UktObbKQcBJdmEdFfCD
 7cJg17qONdtGsnYZoP9aBD50gP3Hm87AkpyeA40eangIsOP0IsA62Zc/alJLCF7Bxfl7THjb/
 3dyiw+ZDfqQCyvK7udDzfcvUQL38j4zha+eR4b0c1DuW5iRBy8/RHsR1g89eH/pKTENxL+vXj
 6S1p/TQ0pOrXha961k3Rrhup86FKDBLVJBmGUoLRgi/XrdWX3z5fYz1uDX7jgN2Gm0ShyNI5X
 vuwdwEkgkb1saDGQakKt2PfuFK9KNrRsV9jGLkgy08R39JXGy5Mr2+qn9sccEC0E1S281xf+g
 LEBttLehbAFaAxj592jr8sQnx2nl8hWsB1KKVaGtvWhibTBddCIFv7Mni1SjitLM4FGDp5lCB
 M+PusVi3dzep3k3HoN2DIt08B9p4gkLoaRRDg/65UF9heSYNwSnJX5FYhytxG38geSEQNibmT
 wfgpMfweD0FiIJHjtl2mC5FRhDOuukSstWXKrFJxl5Iyt4xeDphu/O5t0QFG9nEKcdM0+v4F6
 Sxc5qLI6cVDIAs2siPjM21Rb1k1b3ki9XjG5E2erMW3CucqQyHE/ZGBN32UPWtrPI+BTxiZR/
 kiB9nqxEDB7bYW1QXrNk5U2pAX5PLlL7lDJZD1ubhQ9irJy4svx/8ZtWLoWbNsnwrOlKFvnuR
 QxAf3V9rznLeg8bTkUgDclELrfx/8c4blhvV269am2Il/pZhh8=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The clang integrated assembler complains about movzxw:

arch/x86/crypto/crc32c-pcl-intel-asm_64.S:173:2: error: invalid instruction mnemonic 'movzxw'

It seems that movzwq is the mnemonic that it expects instead,
and this is what objdump prints when disassembling the file.

Fixes: 6a8ce1ef3940 ("crypto: crc32c - Optimize CRC32C calculation with PCLMULQDQ instruction")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index 8501ec4532f4..442599cbe796 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -170,7 +170,7 @@ continue_block:
 
 	## branch into array
 	lea	jump_table(%rip), %bufp
-	movzxw  (%bufp, %rax, 2), len
+	movzwq  (%bufp, %rax, 2), len
 	lea	crc_array(%rip), %bufp
 	lea     (%bufp, len, 1), %bufp
 	JMP_NOSPEC bufp
-- 
2.26.2

