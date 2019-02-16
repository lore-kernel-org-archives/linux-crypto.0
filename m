Return-Path: <SRS0=wTi7=QX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B14C43381
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Feb 2019 13:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 940C921924
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Feb 2019 13:51:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JO4Fk4pZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbfBPNvh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Feb 2019 08:51:37 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39091 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbfBPNvh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Feb 2019 08:51:37 -0500
Received: by mail-wr1-f67.google.com with SMTP id l5so12121983wrw.6
        for <linux-crypto@vger.kernel.org>; Sat, 16 Feb 2019 05:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I+oUlVJkZNLWLH2zCR29dR9mlQ4zkguT7+X//Rq8/xk=;
        b=JO4Fk4pZxeYirKMx+GQ8BMWw4baIlBo5Lx7P1Pd/svvRMGEjxPCm0LsUYrWc7ap2cE
         zyzEr1WU3bphbU7uAw0XZyjrDvD9J6wluwgFwzBcIx4vtzc4M9N385DKkEDD+DBR7sti
         /xLkSASC63uHdeBXnIGNMnOmUbkUBT+o1sVxW3zTQSmqFjZ72FbW904CK3BCLEtG4hBN
         Yhf/UYemjJ8jIz5+r9FnD/8ViYnObvB/RttD5IE/pSDzz7J7U6qkJi2u6Em+oCi8pXEu
         g8iEWWQVh+8Di8otkZqEE2lnGSb6YWhiCglpAjUJWibqe59zCBqKYM4eAN0q9aC9cqQO
         xm4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I+oUlVJkZNLWLH2zCR29dR9mlQ4zkguT7+X//Rq8/xk=;
        b=proAhPXM7ELJ7+N7yL7Evd+EgnHvbSuWJf6HzwygWjjA8G0/Luqlckbt4dhAXHB4Vy
         ZbLkUSKnCeJRE7hqinDWdI2q6Al1E/r/Avmw5NjphyoelYUWYP0c3HQiaBQ+l/ZXPhcH
         IGKN1CpJK4+zpFTD00EoegdE62VR+7hS3epwMnCUSuSxlZyp17wmNaLTm+9jZPtPF0Uh
         vb2vWXvA8QbE0xUf+Y2umwzYJLtGp89dxAlQbdFcY+nrQH/QRJqUmMFqbSXYA2KugzEd
         eN+JRwSBEDuMpy+hnl0E6nJMdqRINapmeZnZXg42/K8tNiJvO+yYZjy1slQSFEGg+Fc2
         ePmQ==
X-Gm-Message-State: AHQUAuaNRT8J3voHcE8KDnV0DBWMjt7RNWXsDZ9NVqcoOFDgpBCzQwcG
        nX54k0eMfumAS6Y4D8G2ds6zq+lF8MQ=
X-Google-Smtp-Source: AHgI3IbwNKJ1loMaD3OXjHMuEmLD79yXMezdOsx81EDjJK6dAxtVfQ+bPX6jdCO+UEMW+pY/h7mF8Q==
X-Received: by 2002:adf:9123:: with SMTP id j32mr11063249wrj.122.1550325095433;
        Sat, 16 Feb 2019 05:51:35 -0800 (PST)
Received: from sudo.home ([2a01:cb1d:112:6f00:8ee:778e:6c2d:d201])
        by smtp.gmail.com with ESMTPSA id z17sm7452339wrs.75.2019.02.16.05.51.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Feb 2019 05:51:34 -0800 (PST)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        ebiggers@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: sha512/arm - fix crash bug in Thumb2 build
Date:   Sat, 16 Feb 2019 14:51:26 +0100
Message-Id: <20190216135126.17290-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190216135126.17290-1-ard.biesheuvel@linaro.org>
References: <20190216135126.17290-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The SHA512 code we adopted from the OpenSSL project uses a rather
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
---
 arch/arm/crypto/sha512-armv4.pl       | 3 ++-
 arch/arm/crypto/sha512-core.S_shipped | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/crypto/sha512-armv4.pl b/arch/arm/crypto/sha512-armv4.pl
index fb5d15048c0b..788c17b56ecc 100644
--- a/arch/arm/crypto/sha512-armv4.pl
+++ b/arch/arm/crypto/sha512-armv4.pl
@@ -274,10 +274,11 @@ WORD64(0x5fcb6fab,0x3ad6faec, 0x6c44198c,0x4a475817)
 .global	sha512_block_data_order
 .type	sha512_block_data_order,%function
 sha512_block_data_order:
+.Lsha512_block_data_order:
 #if __ARM_ARCH__<7
 	sub	r3,pc,#8		@ sha512_block_data_order
 #else
-	adr	r3,sha512_block_data_order
+	adr	r3,.Lsha512_block_data_order
 #endif
 #if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
 	ldr	r12,.LOPENSSL_armcap
diff --git a/arch/arm/crypto/sha512-core.S_shipped b/arch/arm/crypto/sha512-core.S_shipped
index b1c334a49cda..710ea309769e 100644
--- a/arch/arm/crypto/sha512-core.S_shipped
+++ b/arch/arm/crypto/sha512-core.S_shipped
@@ -141,10 +141,11 @@ WORD64(0x5fcb6fab,0x3ad6faec, 0x6c44198c,0x4a475817)
 .global	sha512_block_data_order
 .type	sha512_block_data_order,%function
 sha512_block_data_order:
+.Lsha512_block_data_order:
 #if __ARM_ARCH__<7
 	sub	r3,pc,#8		@ sha512_block_data_order
 #else
-	adr	r3,sha512_block_data_order
+	adr	r3,.Lsha512_block_data_order
 #endif
 #if __ARM_MAX_ARCH__>=7 && !defined(__KERNEL__)
 	ldr	r12,.LOPENSSL_armcap
-- 
2.20.1

