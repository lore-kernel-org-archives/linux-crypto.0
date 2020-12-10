Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF90BC4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 18:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9219223C44
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 18:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404075AbgLJSMz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 13:12:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404100AbgLJSMq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 13:12:46 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ben Greear <greearb@candelatech.com>
Subject: [RFC PATCH 0/3] crypto: ARM - run kernel mode NEON with softirqs disabled
Date:   Thu, 10 Dec 2020 19:11:55 +0100
Message-Id: <20201210181158.28960-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series is presented in response to the discussion [0] that has been going
on on the linux-crypto list regarding the use of SIMD in synchronous skciphers
and AEADs, which is problematic if such transforms may be used in softirq
context while the SIMD unit is already being used by the kernel in process
context as well.

This series proposes a way to work around this restriction. It is mainly
intended to elicit discussion, so it is based on ARM not x86, which is
probably more instructive, given that ARM does not permit SIMD use in
softirq context at all (which is changed by patch #1), and also already
carries some of these fallbacks that we should be able to remove if these
changes work as intended (patches #2 and #3)

The primary assumption here is that use of skciphers and AEADs is currently
only supported in process or softirq context. If this is true, we can avoid
the need for dealing with nested use of the SIMD unit (when softirq uses
the SIMD unit while it is already being used in process context), by
disabling softirq processing entirely when the NEON unit is enabled for
kernel mode use.

If this approach works and turns out to be suitable for x86 as well (which
will require a separate discussion involving the x86 maintainers), we will
probably need to reduce the scope of the kernel_fpu_begin/end blocks to
ensure that softirq processing latency is not affected. Given that x86 has
recently been updated to drastically reduce the overhead of preserving/
restoring the FPU state, this should not adversely affect performance.

[0] https://lore.kernel.org/linux-crypto/20201201194556.5220-1-ardb@kernel.org/

Cc: Eric Biggers <ebiggers@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ben Greear <greearb@candelatech.com>

Ard Biesheuvel (3):
  ARM: vfp: allow kernel mode NEON in softirq context
  crypto: arm/aes-ce - drop non-SIMD fallbacks and SIMD helper
  crypto: arm/aes-neonbs - drop non-SIMD fallbacks and SIMD helper

 arch/arm/crypto/aes-ce-glue.c     |  84 +-------------
 arch/arm/crypto/aes-neonbs-glue.c | 119 ++------------------
 arch/arm/include/asm/simd.h       |  12 ++
 arch/arm/vfp/vfpmodule.c          |  11 +-
 4 files changed, 31 insertions(+), 195 deletions(-)
 create mode 100644 arch/arm/include/asm/simd.h

-- 
2.17.1

