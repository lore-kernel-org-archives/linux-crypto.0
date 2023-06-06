Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8BAC7EE2A
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Jun 2023 17:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238396AbjFFRcJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Jun 2023 13:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238534AbjFFRcH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2023 13:32:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB951707
        for <linux-crypto@vger.kernel.org>; Tue,  6 Jun 2023 10:31:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C2F362B3C
        for <linux-crypto@vger.kernel.org>; Tue,  6 Jun 2023 17:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFE2C4339C;
        Tue,  6 Jun 2023 17:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686072705;
        bh=ZHGtpuKKtqq1E75hZzNwkwZTjilt2miWhf5UUu3HCTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkZTRzNiYpP/WUFcc9rHR+O9+lG4zKdPaGBiZR5vzi7/SBN0Jnrz1LGMo9gkBOFnc
         JtsTBMQAoBiSLddZppuPgKXYZJ+qDXGJwfk9jMHskEUI+mTlvTa0bL+aJmuHILMM3L
         uKhYnO8FVnk8u9YSycJGFSMhUsxyjEoz9WZv4yaZgpu3Xu7cCqn4rTESPndeUjDKXT
         QdjMjve8r8MKpWLYbHoF+Av0AN5pTe2UaVRZnWhYDS5aucmzvtkCEIdCYEqCn6XjcH
         sxgAWvlrV5+Cd8aT+a5ikj0hREAHSdnI/UbpqaoCfs+IwPkVHm7UHKWr2Zw02ZOcRW
         6Teo4LElQkbbQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/3] crypto: arm - add some missing SPDX headers
Date:   Tue,  6 Jun 2023 19:31:26 +0200
Message-Id: <20230606173127.4050254-3-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230606173127.4050254-1-ardb@kernel.org>
References: <20230606173127.4050254-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6151; i=ardb@kernel.org; h=from:subject; bh=ZHGtpuKKtqq1E75hZzNwkwZTjilt2miWhf5UUu3HCTw=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIaU+N/vsOsPLCeIT3t+M3iiUozUlz1+7Nfl9iN+kqYLlW sH3XQw6SlkYxDgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwEQa0xkZTu2LcP/JHJryvsFH 02tJ7E+TTZ1Nra43pJ7Nv5Pcsz7tGsP/LMFbf/hvLRW+9uutdtPC2dasz/ZeSeE/I5DIqHvqvM0 jDgA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add some missing SPDX headers, and drop the associated boilerplate
license text to/from the ARM implementations of ChaCha, CRC-32 and
CRC-T10DIF.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/chacha-neon-core.S  | 10 +----
 arch/arm/crypto/crc32-ce-core.S     | 30 ++-------------
 arch/arm/crypto/crct10dif-ce-core.S | 40 +-------------------
 3 files changed, 5 insertions(+), 75 deletions(-)

diff --git a/arch/arm/crypto/chacha-neon-core.S b/arch/arm/crypto/chacha-neon-core.S
index 13d12f672656bb8d..46d708118ef948ec 100644
--- a/arch/arm/crypto/chacha-neon-core.S
+++ b/arch/arm/crypto/chacha-neon-core.S
@@ -1,21 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * ChaCha/XChaCha NEON helper functions
  *
  * Copyright (C) 2016 Linaro, Ltd. <ard.biesheuvel@linaro.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
  * Based on:
  * ChaCha20 256-bit cipher algorithm, RFC7539, x64 SSE3 functions
  *
  * Copyright (C) 2015 Martin Willi
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
  /*
diff --git a/arch/arm/crypto/crc32-ce-core.S b/arch/arm/crypto/crc32-ce-core.S
index 3f13a76b9066e0f6..228a1f298f24d3d0 100644
--- a/arch/arm/crypto/crc32-ce-core.S
+++ b/arch/arm/crypto/crc32-ce-core.S
@@ -1,37 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Accelerated CRC32(C) using ARM CRC, NEON and Crypto Extensions instructions
  *
  * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-/* GPL HEADER START
- *
- * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 only,
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License version 2 for more details (a copy is included
- * in the LICENSE file that accompanied this code).
- *
- * You should have received a copy of the GNU General Public License
- * version 2 along with this program; If not, see http://www.gnu.org/licenses
- *
- * Please  visit http://www.xyratex.com/contact if you need additional
- * information or have any questions.
- *
- * GPL HEADER END
  */
 
 /*
+ * Derived from the x86 SSE version:
+ *
  * Copyright 2012 Xyratex Technology Limited
  *
  * Using hardware provided PCLMULQDQ instruction to accelerate the CRC32
diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
index 46c02c518a300ab0..5d24448fae1ccacb 100644
--- a/arch/arm/crypto/crct10dif-ce-core.S
+++ b/arch/arm/crypto/crct10dif-ce-core.S
@@ -1,13 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
 //
 // Accelerated CRC-T10DIF using ARM NEON and Crypto Extensions instructions
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

