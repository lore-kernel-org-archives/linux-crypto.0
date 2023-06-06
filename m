Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C81C77B73
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Jun 2023 17:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237989AbjFFRcJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Jun 2023 13:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbjFFRcH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2023 13:32:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724B21739
        for <linux-crypto@vger.kernel.org>; Tue,  6 Jun 2023 10:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D8E76361C
        for <linux-crypto@vger.kernel.org>; Tue,  6 Jun 2023 17:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A88C4339E;
        Tue,  6 Jun 2023 17:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686072704;
        bh=COgrZ1YXlLvADfpqRNR2ZPciDf8oE9re8kVj5fLwNG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBgde/DkLUxNzJpAPNbjE4cltWTqoL0PJ+tbjmXCJV6wLyv14mXeppT5FuXxJsZw+
         GoxfYh9c3r1jATropDp5WNJltDpnugaY4WJLDNWPwnC/j7nGMaMIf39YZpRU+kINtd
         ToRjnL4klHqpjb8I9eqqDhx+8oAl4z24Lk2CekTbBF/4qthQ3N7AwJmziZ0CcsMYSL
         hKqjE2noS5VQjfMzL14hrydqbLeTwJkRQ0FHGDxc3CHWh0+Mr7uhdz7GdImCcwvr+h
         QR62A2hAPxX/SWNlGPA+MIWqp95NkAV6SDgiBOtgVe7ta66zXTq0i+uYAuXK1wP6hr
         ZNNVHed+2mRgA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 1/3] crypto: arm64 - add some missing SPDX headers
Date:   Tue,  6 Jun 2023 19:31:25 +0200
Message-Id: <20230606173127.4050254-2-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230606173127.4050254-1-ardb@kernel.org>
References: <20230606173127.4050254-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5545; i=ardb@kernel.org; h=from:subject; bh=COgrZ1YXlLvADfpqRNR2ZPciDf8oE9re8kVj5fLwNG8=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIaU+NzN4VlcK17myRZuee3EuYd3f+Tb7R27DrlDjI+9NR BLquGZ1lLIwiHEwyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIk43GL4n298dJV4+rPoi91z lm592vx4xpK1T/ojhFOZDjJart/2JYSRodvU7dQOyy3bLrooqS1ec0X8oe3xNxEberzOJrt8zd3 +lA0A
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add some missing SPDX headers, and drop the associated boilerplate
license text to/from the arm64 implementations of ChaCha and CRC-T10DIF.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/chacha-neon-core.S  | 10 +----
 arch/arm64/crypto/chacha-neon-glue.c  | 10 +----
 arch/arm64/crypto/crct10dif-ce-core.S | 40 +-------------------
 3 files changed, 3 insertions(+), 57 deletions(-)

diff --git a/arch/arm64/crypto/chacha-neon-core.S b/arch/arm64/crypto/chacha-neon-core.S
index b70ac76f2610ce08..400c6239321aa7bc 100644
--- a/arch/arm64/crypto/chacha-neon-core.S
+++ b/arch/arm64/crypto/chacha-neon-core.S
@@ -1,21 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * ChaCha/XChaCha NEON helper functions
  *
  * Copyright (C) 2016-2018 Linaro, Ltd. <ard.biesheuvel@linaro.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
  * Originally based on:
  * ChaCha20 256-bit cipher algorithm, RFC7539, x64 SSSE3 functions
  *
  * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <linux/linkage.h>
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index af2bbca38e70fb35..c61152d6d9bd2137 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -1,22 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /*
  * ARM NEON and scalar accelerated ChaCha and XChaCha stream ciphers,
  * including ChaCha20 (RFC7539)
  *
  * Copyright (C) 2016 - 2017 Linaro, Ltd. <ard.biesheuvel@linaro.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
  * Based on:
  * ChaCha20 256-bit cipher algorithm, RFC7539, SIMD glue code
  *
  * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <crypto/algapi.h>
diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index 5604de61d06d04ee..bebdf4c72a5013c2 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -1,13 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
 //
 // Accelerated CRC-T10DIF using arm64 NEON and Crypto Extensions instructions
 //
 // Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
 // Copyright (C) 2019 Google LLC <ebiggers@google.com>
 //
-// This program is free software; you can redistribute it and/or modify
-// it under the terms of the GNU General Public License version 2 as
-// published by the Free Software Foundation.
-//
 
 // Derived from the x86 version:
 //
@@ -21,41 +18,6 @@
 //     James Guilford <james.guilford@intel.com>
 //     Tim Chen <tim.c.chen@linux.intel.com>
 //
-// This software is available to you under a choice of one of two
-// licenses.  You may choose to be licensed under the terms of the GNU
-// General Public License (GPL) Version 2, available from the file
-// COPYING in the main directory of this source tree, or the
-// OpenIB.org BSD license below:
-//
-// Redistribution and use in source and binary forms, with or without
-// modification, are permitted provided that the following conditions are
-// met:
-//
-// * Redistributions of source code must retain the above copyright
-//   notice, this list of conditions and the following disclaimer.
-//
-// * Redistributions in binary form must reproduce the above copyright
-//   notice, this list of conditions and the following disclaimer in the
-//   documentation and/or other materials provided with the
-//   distribution.
-//
-// * Neither the name of the Intel Corporation nor the names of its
-//   contributors may be used to endorse or promote products derived from
-//   this software without specific prior written permission.
-//
-//
-// THIS SOFTWARE IS PROVIDED BY INTEL CORPORATION ""AS IS"" AND ANY
-// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL INTEL CORPORATION OR
-// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
-// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-//
 //       Reference paper titled "Fast CRC Computation for Generic
 //	Polynomials Using PCLMULQDQ Instruction"
 //       URL: http://www.intel.com/content/dam/www/public/us/en/documents
-- 
2.39.2

