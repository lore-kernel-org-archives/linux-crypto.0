Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692C8C77B73
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Jun 2023 17:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbjFFRc1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Jun 2023 13:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238534AbjFFRcK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2023 13:32:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7491170C
        for <linux-crypto@vger.kernel.org>; Tue,  6 Jun 2023 10:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C7066305C
        for <linux-crypto@vger.kernel.org>; Tue,  6 Jun 2023 17:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADBDC433EF;
        Tue,  6 Jun 2023 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686072707;
        bh=0n347f54t8E7kqyXujbB5lQTzrx/FaX07ZMhVZaaoA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0iu5boHtd2g8mu48+e1466AT7zSe/YZ5q+v3pv8XzueHasx+wgqzY4aVpsIUq7Sd
         0zEmIadQj/+K459YHDYHcKCwrO5fngSCMIzWEZmnBKSPOoIbZRVcENvubv8Gv2BTbu
         843HGvSaAQubxGrzqVryei2zeqJX6OwyoVJc4G8rx/m/4hX2FiylNoYTWgJO8Zkoul
         kmCmKOtEqlauSfsBhMp62JVKdc9tL6ti+EX+ZMAt5AzyajQgxy6ODfDmsDoJJ/vauq
         wYfXbIUD7KooMaveZhELiUA3kXQ2tfWVoNAicIVaE+jiZhgauD1F574GSezGJraMiT
         NBsGeb7ypHFvQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 3/3] crypto: x86 - add some missing SPDX headers
Date:   Tue,  6 Jun 2023 19:31:27 +0200
Message-Id: <20230606173127.4050254-4-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230606173127.4050254-1-ardb@kernel.org>
References: <20230606173127.4050254-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=36633; i=ardb@kernel.org; h=from:subject; bh=0n347f54t8E7kqyXujbB5lQTzrx/FaX07ZMhVZaaoA8=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIaU+NydAJDBEVTLtwCk+oTsNPZye0vPZD7+TZDuzIOCAy ekMp7KOUhYGMQ4GWTFFFoHZf9/tPD1RqtZ5lizMHFYmkCEMXJwCMJHQLEaGD3M+fo74q8Up8DDX tFbnFGfn+7TE64azm8pK5fa6FX6TYmR4WG+pd//Z3iXG/0J9+UKkmvrePfN9dEM3SKf10RQp7xY +AA==
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add some missing SPDX headers, and drop the associated boilerplate
license text to/from the x86 accelerated implementations of various
crypto algorithms.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/x86/crypto/aesni-intel_avx-x86_64.S    | 36 +--------------
 arch/x86/crypto/camellia-aesni-avx-asm_64.S |  7 +--
 arch/x86/crypto/crc32-pclmul_glue.c         | 24 +---------
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S   | 29 +-----------
 arch/x86/crypto/crct10dif-pcl-asm_64.S      | 36 +--------------
 arch/x86/crypto/crct10dif-pclmul_glue.c     | 16 +------
 arch/x86/crypto/sha1_avx2_x86_64_asm.S      | 46 +-------------------
 arch/x86/crypto/sha1_ni_asm.S               | 46 +-------------------
 arch/x86/crypto/sha256-avx-asm.S            | 28 +-----------
 arch/x86/crypto/sha256-avx2-asm.S           | 29 +-----------
 arch/x86/crypto/sha256-ssse3-asm.S          | 29 +-----------
 arch/x86/crypto/sha256_ni_asm.S             | 46 +-------------------
 arch/x86/crypto/sha256_ssse3_glue.c         | 15 +------
 arch/x86/crypto/sha512-avx-asm.S            | 29 +-----------
 arch/x86/crypto/sha512-avx2-asm.S           | 29 +-----------
 arch/x86/crypto/sha512-ssse3-asm.S          | 29 +-----------
 arch/x86/crypto/sha512_ssse3_glue.c         | 16 +------
 arch/x86/crypto/twofish_glue.c              | 16 +------
 18 files changed, 18 insertions(+), 488 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index 46cddd78857bd9eb..c4cb35fb8df1641d 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -1,40 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
 ########################################################################
 # Copyright (c) 2013, Intel Corporation
-#
-# This software is available to you under a choice of one of two
-# licenses.  You may choose to be licensed under the terms of the GNU
-# General Public License (GPL) Version 2, available from the file
-# COPYING in the main directory of this source tree, or the
-# OpenIB.org BSD license below:
-#
-# Redistribution and use in source and binary forms, with or without
-# modification, are permitted provided that the following conditions are
-# met:
-#
-# * Redistributions of source code must retain the above copyright
-#   notice, this list of conditions and the following disclaimer.
-#
-# * Redistributions in binary form must reproduce the above copyright
-#   notice, this list of conditions and the following disclaimer in the
-#   documentation and/or other materials provided with the
-#   distribution.
-#
-# * Neither the name of the Intel Corporation nor the names of its
-#   contributors may be used to endorse or promote products derived from
-#   this software without specific prior written permission.
-#
-#
-# THIS SOFTWARE IS PROVIDED BY INTEL CORPORATION ""AS IS"" AND ANY
-# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL INTEL CORPORATION OR
-# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES# LOSS OF USE, DATA, OR
-# PROFITS# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ########################################################################
 ##
 ## Authors:
diff --git a/arch/x86/crypto/camellia-aesni-avx-asm_64.S b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
index 646477a13e110fed..9d717d382cbdd048 100644
--- a/arch/x86/crypto/camellia-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/camellia-aesni-avx-asm_64.S
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * x86_64/AVX/AES-NI assembler implementation of Camellia
  *
  * Copyright © 2012-2013 Jussi Kivilinna <jussi.kivilinna@iki.fi>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 /*
diff --git a/arch/x86/crypto/crc32-pclmul_glue.c b/arch/x86/crypto/crc32-pclmul_glue.c
index 98cf3b4e4c9fecfe..c4316c31c269785f 100644
--- a/arch/x86/crypto/crc32-pclmul_glue.c
+++ b/arch/x86/crypto/crc32-pclmul_glue.c
@@ -1,26 +1,4 @@
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
- */
-
+/* SPDX-License-Identifier: GPL-2.0-only */
 /*
  * Copyright 2012 Xyratex Technology Limited
  *
diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index 81ce0f4db555ce03..21303888071cf27b 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
 /*
  * Implement fast CRC32C with PCLMULQDQ instructions. (x86_64)
  *
@@ -13,34 +14,6 @@
  *	James Guilford <james.guilford@intel.com>
  *	David Cote <david.m.cote@intel.com>
  *	Tim Chen <tim.c.chen@linux.intel.com>
- *
- * This software is available to you under a choice of one of two
- * licenses.  You may choose to be licensed under the terms of the GNU
- * General Public License (GPL) Version 2, available from the file
- * COPYING in the main directory of this source tree, or the
- * OpenIB.org BSD license below:
- *
- *     Redistribution and use in source and binary forms, with or
- *     without modification, are permitted provided that the following
- *     conditions are met:
- *
- *      - Redistributions of source code must retain the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer.
- *
- *      - Redistributions in binary form must reproduce the above
- *        copyright notice, this list of conditions and the following
- *        disclaimer in the documentation and/or other materials
- *        provided with the distribution.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
  */
 
 #include <linux/linkage.h>
diff --git a/arch/x86/crypto/crct10dif-pcl-asm_64.S b/arch/x86/crypto/crct10dif-pcl-asm_64.S
index 5286db5b8165e632..b48f5ef074d16d00 100644
--- a/arch/x86/crypto/crct10dif-pcl-asm_64.S
+++ b/arch/x86/crypto/crct10dif-pcl-asm_64.S
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
 ########################################################################
 # Implement fast CRC-T10DIF computation with SSE and PCLMULQDQ instructions
 #
@@ -9,41 +10,6 @@
 #     James Guilford <james.guilford@intel.com>
 #     Tim Chen <tim.c.chen@linux.intel.com>
 #
-# This software is available to you under a choice of one of two
-# licenses.  You may choose to be licensed under the terms of the GNU
-# General Public License (GPL) Version 2, available from the file
-# COPYING in the main directory of this source tree, or the
-# OpenIB.org BSD license below:
-#
-# Redistribution and use in source and binary forms, with or without
-# modification, are permitted provided that the following conditions are
-# met:
-#
-# * Redistributions of source code must retain the above copyright
-#   notice, this list of conditions and the following disclaimer.
-#
-# * Redistributions in binary form must reproduce the above copyright
-#   notice, this list of conditions and the following disclaimer in the
-#   documentation and/or other materials provided with the
-#   distribution.
-#
-# * Neither the name of the Intel Corporation nor the names of its
-#   contributors may be used to endorse or promote products derived from
-#   this software without specific prior written permission.
-#
-#
-# THIS SOFTWARE IS PROVIDED BY INTEL CORPORATION ""AS IS"" AND ANY
-# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL INTEL CORPORATION OR
-# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
-# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-#
 #       Reference paper titled "Fast CRC Computation for Generic
 #	Polynomials Using PCLMULQDQ Instruction"
 #       URL: http://www.intel.com/content/dam/www/public/us/en/documents
diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
index 71291d5af9f4588b..ec8073c90dd9b068 100644
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Cryptographic API.
  *
@@ -5,21 +6,6 @@
  *
  * Copyright (C) 2013 Intel Corporation
  * Author: Tim Chen <tim.c.chen@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
  */
 
 #include <linux/types.h>
diff --git a/arch/x86/crypto/sha1_avx2_x86_64_asm.S b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
index 4b49bdc9526583d6..1fbb9149f0f0b848 100644
--- a/arch/x86/crypto/sha1_avx2_x86_64_asm.S
+++ b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
@@ -1,58 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
 /*
  *	Implement fast SHA-1 with AVX2 instructions. (x86_64)
  *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
  * Copyright(c) 2014 Intel Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
  * Contact Information:
  * Ilya Albrekht <ilya.albrekht@intel.com>
  * Maxim Locktyukhin <maxim.locktyukhin@intel.com>
  * Ronen Zohar <ronen.zohar@intel.com>
  * Chandramouli Narayanan <mouli@linux.intel.com>
- *
- * BSD LICENSE
- *
- * Copyright(c) 2014 Intel Corporation.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- * Redistributions of source code must retain the above copyright
- * notice, this list of conditions and the following disclaimer.
- * Redistributions in binary form must reproduce the above copyright
- * notice, this list of conditions and the following disclaimer in
- * the documentation and/or other materials provided with the
- * distribution.
- * Neither the name of Intel Corporation nor the names of its
- * contributors may be used to endorse or promote products derived
- * from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
  */
 
 /*
diff --git a/arch/x86/crypto/sha1_ni_asm.S b/arch/x86/crypto/sha1_ni_asm.S
index cade913d48822019..a9fb55ca8af6526f 100644
--- a/arch/x86/crypto/sha1_ni_asm.S
+++ b/arch/x86/crypto/sha1_ni_asm.S
@@ -1,56 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
 /*
  * Intel SHA Extensions optimized implementation of a SHA-1 update function
  *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
  * Copyright(c) 2015 Intel Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
  * Contact Information:
  * 	Sean Gulley <sean.m.gulley@intel.com>
  * 	Tim Chen <tim.c.chen@linux.intel.com>
- *
- * BSD LICENSE
- *
- * Copyright(c) 2015 Intel Corporation.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- * 	* Redistributions of source code must retain the above copyright
- * 	  notice, this list of conditions and the following disclaimer.
- * 	* Redistributions in binary form must reproduce the above copyright
- * 	  notice, this list of conditions and the following disclaimer in
- * 	  the documentation and/or other materials provided with the
- * 	  distribution.
- * 	* Neither the name of Intel Corporation nor the names of its
- * 	  contributors may be used to endorse or promote products derived
- * 	  from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
  */
 
 #include <linux/linkage.h>
diff --git a/arch/x86/crypto/sha256-avx-asm.S b/arch/x86/crypto/sha256-avx-asm.S
index 53de72bdd851ec8d..57d5484711ed0f32 100644
--- a/arch/x86/crypto/sha256-avx-asm.S
+++ b/arch/x86/crypto/sha256-avx-asm.S
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
 ########################################################################
 # Implement fast SHA-256 with AVX1 instructions. (x86_64)
 #
@@ -8,33 +9,6 @@
 #     Kirk Yap <kirk.s.yap@intel.com>
 #     Tim Chen <tim.c.chen@linux.intel.com>
 #
-# This software is available to you under a choice of one of two
-# licenses.  You may choose to be licensed under the terms of the GNU
-# General Public License (GPL) Version 2, available from the file
-# COPYING in the main directory of this source tree, or the
-# OpenIB.org BSD license below:
-#
-#     Redistribution and use in source and binary forms, with or
-#     without modification, are permitted provided that the following
-#     conditions are met:
-#
-#      - Redistributions of source code must retain the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer.
-#
-#      - Redistributions in binary form must reproduce the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer in the documentation and/or other materials
-#        provided with the distribution.
-#
-# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
-# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
-# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-# SOFTWARE.
 ########################################################################
 #
 # This code is described in an Intel White-Paper:
diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 9918212faf914ffc..3f6fcf3fa3189f05 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
 ########################################################################
 # Implement fast SHA-256 with AVX2 instructions. (x86_64)
 #
@@ -8,34 +9,6 @@
 #     Kirk Yap <kirk.s.yap@intel.com>
 #     Tim Chen <tim.c.chen@linux.intel.com>
 #
-# This software is available to you under a choice of one of two
-# licenses.  You may choose to be licensed under the terms of the GNU
-# General Public License (GPL) Version 2, available from the file
-# COPYING in the main directory of this source tree, or the
-# OpenIB.org BSD license below:
-#
-#     Redistribution and use in source and binary forms, with or
-#     without modification, are permitted provided that the following
-#     conditions are met:
-#
-#      - Redistributions of source code must retain the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer.
-#
-#      - Redistributions in binary form must reproduce the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer in the documentation and/or other materials
-#        provided with the distribution.
-#
-# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
-# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
-# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-# SOFTWARE.
-#
 ########################################################################
 #
 # This code is described in an Intel White-Paper:
diff --git a/arch/x86/crypto/sha256-ssse3-asm.S b/arch/x86/crypto/sha256-ssse3-asm.S
index 93264ee4454325b9..76979e13d95e0bdc 100644
--- a/arch/x86/crypto/sha256-ssse3-asm.S
+++ b/arch/x86/crypto/sha256-ssse3-asm.S
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
 ########################################################################
 # Implement fast SHA-256 with SSSE3 instructions. (x86_64)
 #
@@ -8,34 +9,6 @@
 #     Kirk Yap <kirk.s.yap@intel.com>
 #     Tim Chen <tim.c.chen@linux.intel.com>
 #
-# This software is available to you under a choice of one of two
-# licenses.  You may choose to be licensed under the terms of the GNU
-# General Public License (GPL) Version 2, available from the file
-# COPYING in the main directory of this source tree, or the
-# OpenIB.org BSD license below:
-#
-#     Redistribution and use in source and binary forms, with or
-#     without modification, are permitted provided that the following
-#     conditions are met:
-#
-#      - Redistributions of source code must retain the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer.
-#
-#      - Redistributions in binary form must reproduce the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer in the documentation and/or other materials
-#        provided with the distribution.
-#
-# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
-# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
-# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-# SOFTWARE.
-#
 ########################################################################
 #
 # This code is described in an Intel White-Paper:
diff --git a/arch/x86/crypto/sha256_ni_asm.S b/arch/x86/crypto/sha256_ni_asm.S
index 537b6dcd7ed80ef1..d339f8040832fd64 100644
--- a/arch/x86/crypto/sha256_ni_asm.S
+++ b/arch/x86/crypto/sha256_ni_asm.S
@@ -1,56 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
 /*
  * Intel SHA Extensions optimized implementation of a SHA-256 update function
  *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
- *
  * Copyright(c) 2015 Intel Corporation.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
  * Contact Information:
  * 	Sean Gulley <sean.m.gulley@intel.com>
  * 	Tim Chen <tim.c.chen@linux.intel.com>
- *
- * BSD LICENSE
- *
- * Copyright(c) 2015 Intel Corporation.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- * 	* Redistributions of source code must retain the above copyright
- * 	  notice, this list of conditions and the following disclaimer.
- * 	* Redistributions in binary form must reproduce the above copyright
- * 	  notice, this list of conditions and the following disclaimer in
- * 	  the documentation and/or other materials provided with the
- * 	  distribution.
- * 	* Neither the name of Intel Corporation nor the names of its
- * 	  contributors may be used to endorse or promote products derived
- * 	  from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
  */
 
 #include <linux/linkage.h>
diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 3a5f6be7dbba4e5a..30bc827916824e09 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Cryptographic API.
  *
@@ -10,20 +11,6 @@
  *
  * Author:
  *     Tim Chen <tim.c.chen@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
  */
 
 
diff --git a/arch/x86/crypto/sha512-avx-asm.S b/arch/x86/crypto/sha512-avx-asm.S
index d902b8ea07218467..1a1313de42d60baa 100644
--- a/arch/x86/crypto/sha512-avx-asm.S
+++ b/arch/x86/crypto/sha512-avx-asm.S
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
 ########################################################################
 # Implement fast SHA-512 with AVX instructions. (x86_64)
 #
@@ -9,34 +10,6 @@
 #     David Cote <david.m.cote@intel.com>
 #     Tim Chen <tim.c.chen@linux.intel.com>
 #
-# This software is available to you under a choice of one of two
-# licenses.  You may choose to be licensed under the terms of the GNU
-# General Public License (GPL) Version 2, available from the file
-# COPYING in the main directory of this source tree, or the
-# OpenIB.org BSD license below:
-#
-#     Redistribution and use in source and binary forms, with or
-#     without modification, are permitted provided that the following
-#     conditions are met:
-#
-#      - Redistributions of source code must retain the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer.
-#
-#      - Redistributions in binary form must reproduce the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer in the documentation and/or other materials
-#        provided with the distribution.
-#
-# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
-# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
-# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-# SOFTWARE.
-#
 ########################################################################
 #
 # This code is described in an Intel White-Paper:
diff --git a/arch/x86/crypto/sha512-avx2-asm.S b/arch/x86/crypto/sha512-avx2-asm.S
index f08496cd68708fde..0f39a19f3b9749bd 100644
--- a/arch/x86/crypto/sha512-avx2-asm.S
+++ b/arch/x86/crypto/sha512-avx2-asm.S
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
 ########################################################################
 # Implement fast SHA-512 with AVX2 instructions. (x86_64)
 #
@@ -9,34 +10,6 @@
 #     David Cote <david.m.cote@intel.com>
 #     Tim Chen <tim.c.chen@linux.intel.com>
 #
-# This software is available to you under a choice of one of two
-# licenses.  You may choose to be licensed under the terms of the GNU
-# General Public License (GPL) Version 2, available from the file
-# COPYING in the main directory of this source tree, or the
-# OpenIB.org BSD license below:
-#
-#     Redistribution and use in source and binary forms, with or
-#     without modification, are permitted provided that the following
-#     conditions are met:
-#
-#      - Redistributions of source code must retain the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer.
-#
-#      - Redistributions in binary form must reproduce the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer in the documentation and/or other materials
-#        provided with the distribution.
-#
-# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
-# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
-# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-# SOFTWARE.
-#
 ########################################################################
 #
 # This code is described in an Intel White-Paper:
diff --git a/arch/x86/crypto/sha512-ssse3-asm.S b/arch/x86/crypto/sha512-ssse3-asm.S
index 65be301568162654..bfd8a68759fccfe2 100644
--- a/arch/x86/crypto/sha512-ssse3-asm.S
+++ b/arch/x86/crypto/sha512-ssse3-asm.S
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause */
 ########################################################################
 # Implement fast SHA-512 with SSSE3 instructions. (x86_64)
 #
@@ -9,34 +10,6 @@
 #     David Cote <david.m.cote@intel.com>
 #     Tim Chen <tim.c.chen@linux.intel.com>
 #
-# This software is available to you under a choice of one of two
-# licenses.  You may choose to be licensed under the terms of the GNU
-# General Public License (GPL) Version 2, available from the file
-# COPYING in the main directory of this source tree, or the
-# OpenIB.org BSD license below:
-#
-#     Redistribution and use in source and binary forms, with or
-#     without modification, are permitted provided that the following
-#     conditions are met:
-#
-#      - Redistributions of source code must retain the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer.
-#
-#      - Redistributions in binary form must reproduce the above
-#        copyright notice, this list of conditions and the following
-#        disclaimer in the documentation and/or other materials
-#        provided with the distribution.
-#
-# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
-# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
-# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-# SOFTWARE.
-#
 ########################################################################
 #
 # This code is described in an Intel White-Paper:
diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 6d3b85e53d0eeb35..a0513534b3c1d1e8 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Cryptographic API.
  *
@@ -8,21 +9,6 @@
  *
  * Copyright (C) 2013 Intel Corporation
  * Author: Tim Chen <tim.c.chen@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
  */
 
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
diff --git a/arch/x86/crypto/twofish_glue.c b/arch/x86/crypto/twofish_glue.c
index 0614beece27932df..a79e90cc149090b4 100644
--- a/arch/x86/crypto/twofish_glue.c
+++ b/arch/x86/crypto/twofish_glue.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Glue Code for assembler optimized version of TWOFISH
  *
@@ -12,21 +13,6 @@
  * code and thus put it in the public domain. The subsequent authors
  * have put this under the GNU General Public License.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
- * USA
- *
  * This code is a "clean room" implementation, written from the paper
  * _Twofish: A 128-Bit Block Cipher_ by Bruce Schneier, John Kelsey,
  * Doug Whiting, David Wagner, Chris Hall, and Niels Ferguson, available
-- 
2.39.2

