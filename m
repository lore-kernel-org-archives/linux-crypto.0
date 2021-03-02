Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8C0C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA48C64E28
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Mar 2021 01:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhCCB11 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Mar 2021 20:27:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:38806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378841AbhCBJCz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Mar 2021 04:02:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2FFF64F17;
        Tue,  2 Mar 2021 09:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614675727;
        bh=2dT6mS2FFzladJNHwGXpprvyDFYQ/2V8jtWs5f4jiaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhM2Ee6sYkTSCapuxbPzIjkGhESYtS5C/hARH/qMLkj5Uc9MzgzsBEnFExA8gA7qL
         NBqmr2a/08IPUke5S954S5b0jfoBcUtVzplbVQa86O4fifwsRMjh544cfin8IcDjZw
         q89BiAGy8uxuuBNIqbh8YIIz4N7sv53u2JAwgHV6RkmMMpzw661Ext7Iu4wVYm+Nhz
         pbztFkPDBT9P6hViEui+nSljTW1BF6ryE6sy0Dha68B/pM2BO607SN1T0Dy+1jYZzK
         +t2XKCH6CxTjmSJVqt6W1SjcnpvF/uKNxIiK50SyoJSeF837UN91dWrwKrLwTXq4Jk
         7JUIW8Wcu5tTw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Dave Martin <dave.martin@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH v2 2/9] arm64: assembler: introduce wxN aliases for wN registers
Date:   Tue,  2 Mar 2021 10:01:11 +0100
Message-Id: <20210302090118.30666-3-ardb@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302090118.30666-1-ardb@kernel.org>
References: <20210302090118.30666-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AArch64 asm syntax has this slightly tedious property that the names
used in mnemonics to refer to registers depend on whether the opcode in
question targets the entire 64-bits (xN), or only the least significant
8, 16 or 32 bits (wN). When writing parameterized code such as macros,
this can be annoying, as macro arguments don't lend themselves to
indexed lookups, and so generating a reference to wN in a macro that
receives xN as an argument is problematic.

For instance, an upcoming patch that modifies the implementation of the
cond_yield macro to be able to refer to 32-bit registers would need to
modify invocations such as

  cond_yield	3f, x8

to

  cond_yield	3f, 8

so that the second argument can be token pasted after x or w to emit the
correct register reference. Unfortunately, this interferes with the self
documenting nature of the first example, where the second argument is
obviously a register, whereas in the second example, one would need to
go and look at the code to find out what '8' means.

So let's fix this by defining wxN aliases for all xN registers, which
resolve to the 32-bit alias of each respective 64-bit register. This
allows the macro implementation to paste the xN reference after a w to
obtain the correct register name.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/assembler.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index e0fc1d424f9b..7b076ccd1a54 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -23,6 +23,14 @@
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
 
+	/*
+	 * Provide a wxN alias for each wN register so what we can paste a xN
+	 * reference after a 'w' to obtain the 32-bit version.
+	 */
+	.irp	n,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
+	wx\n	.req	w\n
+	.endr
+
 	.macro save_and_disable_daif, flags
 	mrs	\flags, daif
 	msr	daifset, #0xf
-- 
2.30.1

