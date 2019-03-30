Return-Path: <SRS0=3MGL=SB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94759C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 01:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62308217F5
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Mar 2019 01:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553909815;
	bh=bWJNelJR/lwI8bQYkoLqjDtR2FngJVr0+nR4qS7QfeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wCKjqicoMvpG1tGv9fb6cebKS2vGykd0gsiRqVrorusDPw2cIx2PzbyAdIq1J3yUG
	 3RuaITmPsx8uflEOdH5ocBgx1qtU8N7VHyVkj+gHeIN1tdosNyQRJeEL6Rt/hJx1xK
	 b4dG76cWBY3maSvl7PPNnkcwRTRiugh8ck+28wcs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731839AbfC3BbD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Mar 2019 21:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731829AbfC3BbD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Mar 2019 21:31:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F1CE218D8;
        Sat, 30 Mar 2019 01:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553909462;
        bh=bWJNelJR/lwI8bQYkoLqjDtR2FngJVr0+nR4qS7QfeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRJInvu8M7BOJYw/PyZPKELjKT3jsaODE7qfXiiDaUbDbGAPB6UbUW8DI4GsvNpZQ
         gDkiUxrFQR4nT4VV2gIcuMuN5Ajn2E/gCq49wVPMtcoA8CWyVvo4J8l2FvIEzDs1jf
         HOxpkcLqxN5Ib1DHtDieFyXlt1IKnUKAq0wGgFgE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 20/37] crypto: sha256/arm - fix crash bug in Thumb2 build
Date:   Fri, 29 Mar 2019 21:30:03 -0400
Message-Id: <20190330013020.379-20-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190330013020.379-1-sashal@kernel.org>
References: <20190330013020.379-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit 69216a545cf81b2b32d01948f7039315abaf75a0 ]

The SHA256 code we adopted from the OpenSSL project uses a rather
peculiar way to take the address of the round constant table: it
takes the address of the sha256_block_data_order() routine, and
substracts a constant known quantity to arrive at the base of the
table, which is emitted by the same assembler code right before
the routine's entry point.

However, recent versions of binutils have helpfully changed the
behavior of references emitted via an ADR instruction when running
in Thumb2 mode: it now takes the Thumb execution mode bit into
account, which is bit 0 af the address. This means the produced
table address also has bit 0 set, and so we end up with an address
value pointing 1 byte past the start of the table, which results
in crashes such as

  Unable to handle kernel paging request at virtual address bf825000
  pgd = 42f44b11
  [bf825000] *pgd=80000040206003, *pmd=5f1bd003, *pte=00000000
  Internal error: Oops: 207 [#1] PREEMPT SMP THUMB2
  Modules linked in: sha256_arm(+) sha1_arm_ce sha1_arm ...
  CPU: 7 PID: 396 Comm: cryptomgr_test Not tainted 5.0.0-rc6+ #144
  Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
  PC is at sha256_block_data_order+0xaaa/0xb30 [sha256_arm]
  LR is at __this_module+0x17fd/0xffffe800 [sha256_arm]
  pc : [<bf820bca>]    lr : [<bf824ffd>]    psr: 800b0033
  sp : ebc8bbe8  ip : faaabe1c  fp : 2fdd3433
  r10: 4c5f1692  r9 : e43037df  r8 : b04b0a5a
  r7 : c369d722  r6 : 39c3693e  r5 : 7a013189  r4 : 1580d26b
  r3 : 8762a9b0  r2 : eea9c2cd  r1 : 3e9ab536  r0 : 1dea4ae7
  Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment user
  Control: 70c5383d  Table: 6b8467c0  DAC: dbadc0de
  Process cryptomgr_test (pid: 396, stack limit = 0x69e1fe23)
  Stack: (0xebc8bbe8 to 0xebc8c000)
  ...
  unwind: Unknown symbol address bf820bca
  unwind: Index not found bf820bca
  Code: 441a ea80 40f9 440a (f85e) 3b04
  ---[ end trace e560cce92700ef8a ]---

Given that this affects older kernels as well, in case they are built
with a recent toolchain, apply a minimal backportable fix, which is
to emit another non-code label at the start of the routine, and
reference that instead. (This is similar to the current upstream state
of this file in OpenSSL)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/crypto/sha256-armv4.pl       | 3 ++-
 arch/arm/crypto/sha256-core.S_shipped | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/crypto/sha256-armv4.pl b/arch/arm/crypto/sha256-armv4.pl
index fac0533ea633..f64e8413ab9a 100644
--- a/arch/arm/crypto/sha256-armv4.pl
+++ b/arch/arm/crypto/sha256-armv4.pl
@@ -205,10 +205,11 @@ K256:
 .global	sha256_block_data_order
 .type	sha256_block_data_order,%function
 sha256_block_data_order:
+.Lsha256_block_data_order:
 #if __ARM_ARCH__<7
 	sub	r3,pc,#8		@ sha256_block_data_order
 #else
-	adr	r3,sha256_block_data_order
+	adr	r3,.Lsha256_block_data_order
 #endif
 #if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
 	ldr	r12,.LOPENSSL_armcap
diff --git a/arch/arm/crypto/sha256-core.S_shipped b/arch/arm/crypto/sha256-core.S_shipped
index 555a1a8eec90..72c248081d27 100644
--- a/arch/arm/crypto/sha256-core.S_shipped
+++ b/arch/arm/crypto/sha256-core.S_shipped
@@ -86,10 +86,11 @@ K256:
 .global	sha256_block_data_order
 .type	sha256_block_data_order,%function
 sha256_block_data_order:
+.Lsha256_block_data_order:
 #if __ARM_ARCH__<7
 	sub	r3,pc,#8		@ sha256_block_data_order
 #else
-	adr	r3,sha256_block_data_order
+	adr	r3,.Lsha256_block_data_order
 #endif
 #if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
 	ldr	r12,.LOPENSSL_armcap
-- 
2.19.1

