Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04588C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 08:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbiA0IMi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 03:12:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51056 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiA0IMh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 03:12:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A070361A66
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 08:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC9CC340E4;
        Thu, 27 Jan 2022 08:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643271157;
        bh=TCpC1uwXd4b31Hg0OSChdp6NRwRet+vBcX4sFew1KUo=;
        h=From:To:Cc:Subject:Date:From;
        b=Z3SfFu33IR5y3xvHofqTLHsJ+HYHdR/l6kL2CYIOfvTNpCf0pYp9zjgo/8fY1POPr
         +8ZLivNybBbLkWxXLm9omt3D0z0YLKLYX2pykWaFZwI+6tx13HInUFMa4oWznR+2ye
         A772xGCXlvHt1Hj/vlpdmuCW79WJZ/Sh+ffzUtfVce+hdYPJ7H1XsBLE1fxnEvj+/h
         3QI1hjBr/d8cp5xliSyGViHa6crF1L5rBJ2qCLUMVtoUtlrKCGWyBU/HJrLdy3Ytun
         10LzHZh0pTnYCy0pscFLOo2nAGee+i5ku2MTShQHJcNsvfL37Cxor4aHHcq9ivfYQ3
         X84/bJMAY8EAQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/2] xor: enable auto-vectorization in Clang
Date:   Thu, 27 Jan 2022 09:12:25 +0100
Message-Id: <20220127081227.2430-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1726; h=from:subject; bh=TCpC1uwXd4b31Hg0OSChdp6NRwRet+vBcX4sFew1KUo=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8lPoEizNNL11wHsIQgWm+NL0aDOm5Fz5RYkW2Yeo n4JgScWJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfJT6AAKCRDDTyI5ktmPJLFKC/ 4/EG49TDcqPZdwg4Nc7TGUZtJIqxueKGowE181xsBxTESpvXUZ0KpuLaWKavs7vT3txeguwYAFhZYM ++YS00+is1BObYSNJYJCqJrJxt9xEuV3gHYgn7XUHOJZNUDlYyHYk38er6KEA4BxXmKIEQuKJTkwfw oEe9XwoUYqKNDv0uD6nnobfT5zy4hOp+VHi2rgR3tsyQq4I9CJgyHPyNEe9hfdaA5TKCUW/FKZJgnD KZNI92UQU/3pTHALe7ajq3cx3dxZy0PucnilrriCz6y01CocgFJlqJPL6BGaYLfLqt8Fg0uaYBT/q2 JuFoVcPZHu7MfyaxHX+V+OHUeKv7HMnBLQJXFTQv7wzfy50Nyxi2GYF4PVcLec7+zUqSbxHnIWd2yt MadhzgzdUSFMla5Hjm+lbLrHlF1o6ThvFra6UVxbMbyvjfHgtRJQS4hZj/0hIa0ynYVciyLFauk5bb gyT6zuKmqUBPggKRsh2prjooD/FnN+jNAHapmUe/jXUmU=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Update the xor_blocks() prototypes so that the compiler understands that
the inputs always refer to distinct regions of memory. This is implied
by the existing implementations, as they use different granularities for
the load/xor/store loops.

With that, we can fix the ARM/Clang version, which refuses to SIMD
vectorize otherwise, and throws a spurious warning related to the GCC
version being incompatible.

Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>

Ard Biesheuvel (2):
  lib/xor: make xor prototypes more friendely to compiler vectorization
  crypto: arm/xor - make vectorized C code Clang-friendly

 arch/alpha/include/asm/xor.h           | 53 ++++++++----
 arch/arm/include/asm/xor.h             | 42 ++++++----
 arch/arm/lib/xor-neon.c                | 12 +--
 arch/arm64/include/asm/xor.h           | 21 +++--
 arch/arm64/lib/xor-neon.c              | 23 +++---
 arch/ia64/include/asm/xor.h            | 21 +++--
 arch/powerpc/include/asm/xor_altivec.h | 25 +++---
 arch/powerpc/lib/xor_vmx.h             | 27 ++++---
 arch/powerpc/lib/xor_vmx_glue.c        | 32 ++++----
 arch/s390/lib/xor.c                    | 21 +++--
 arch/sparc/include/asm/xor_32.h        | 21 +++--
 arch/sparc/include/asm/xor_64.h        | 42 ++++++----
 arch/x86/include/asm/xor.h             | 42 ++++++----
 arch/x86/include/asm/xor_32.h          | 42 ++++++----
 arch/x86/include/asm/xor_avx.h         | 21 +++--
 include/asm-generic/xor.h              | 84 +++++++++++++-------
 include/linux/raid/xor.h               | 21 +++--
 17 files changed, 351 insertions(+), 199 deletions(-)


base-commit: e783362eb54cd99b2cac8b3a9aeac942e6f6ac07
-- 
2.30.2

