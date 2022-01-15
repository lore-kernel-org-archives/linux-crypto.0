Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2FCFC433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 15 Jan 2022 00:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbiAOARr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jan 2022 19:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiAOARr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jan 2022 19:17:47 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56931C06161C
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jan 2022 16:17:47 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id e18-20020a255012000000b00611b9fa7078so14461704ybb.4
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jan 2022 16:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:cc;
        bh=TEFOv4YS0Pv2L4ioEdK41WD5FaS6ABhUfwsLXh99f8U=;
        b=sN3IkgdFVVNugkPBMVaX1NQErDxMw2JjTs7fEo2IZHsKKUM7LTSV9HHpFS166HaH3W
         1smmvnBfC2u30IE5BLIk409N1YZOuqDC+aTiCGUwbpoHdcN4OqjXMxCsDTaFeS5P2VRq
         SmBZHpg8uW1ouZ/j7p3S+qI/pSM5yUosczI2Nj3gMldT1HQfoC/iWUsehWtmsGMiln9/
         RhEvTEGlrfQRvTK/FqSw7xhLyNl7Aq9RiFRjCvHxZr5sv0MlpTkooxxRhlsXEQfp/npd
         ki3xenMHB3KDK07iMrpR5qm5ThgDpUmuK8M6KClCzYuOt6imy1PMm2w3D2hS04k8KW0L
         NlbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
        bh=TEFOv4YS0Pv2L4ioEdK41WD5FaS6ABhUfwsLXh99f8U=;
        b=AoEEAKELudR8Ei8vcr4ct9rH4jcy0Apz5AqIpTprCr9K6zu4LaXCp7f5gFsuhg/z5b
         b5z1sk60DVsWAkC2hvUn/cMeXpk+69mlJmM3Ru+zFjOeNIY+RwyC/o3A3o8D4VjpAIGM
         P/RYhuOUSnRm5sCpCqydMUrUZD+a5cisdvhiZeegIsq0lbvZs29N/Kh0hVWx5ygcX+M1
         zCXBQtWKs8PrUl/IMt2dyUMnlqpPYNwIj3pOuHXozda4QHZBOGWdGtGujklzEeIrRr4S
         MCFClnEWcbLGTv/Errmgifj8gMzIsJCcD47q+/5LjzavTOwunFUQMCAlcxLi1OXmw2j4
         YHHA==
X-Gm-Message-State: AOAM5303enORgK7hWjZAwqyCS+Sxj0qMWU4wdRzxEKqBqPWA0ZOOpfsU
        X3N8OYvzyD6GpYYU4KR96NV06uWLEA==
X-Google-Smtp-Source: ABdhPJy8BbTFgHr7s6eDuLFYTIX87Wx1uQElAp//NDt5ogwcOGsWsYZHV8KXA3KKsn6Yu2DSgNTdK49S4w==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a5b:3c2:: with SMTP id t2mr16685965ybp.747.1642205866524;
 Fri, 14 Jan 2022 16:17:46 -0800 (PST)
Date:   Fri, 14 Jan 2022 18:17:19 -0600
Message-Id: <20220115001719.1040897-1-nhuck@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH] crypto: x86 - Convert to SPDX identifier
From:   Nathan Huckleberry <nhuck@google.com>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        James Guilford <james.guilford@intel.com>,
        Sean Gulley <sean.m.gulley@intel.com>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use SPDX-License-Identifier instead of a verbose license text and
update external link.

Cc: James Guilford <james.guilford@intel.com>
Cc: Sean Gulley <sean.m.gulley@intel.com>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 63 ++++---------------------
 1 file changed, 10 insertions(+), 53 deletions(-)

diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
index c799838242a6..43852ba6e19c 100644
--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -1,65 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
 /*
- *	Implement AES CTR mode by8 optimization with AVX instructions. (x86_64)
- *
- * This is AES128/192/256 CTR mode optimization implementation. It requires
- * the support of Intel(R) AESNI and AVX instructions.
- *
- * This work was inspired by the AES CTR mode optimization published
- * in Intel Optimized IPSEC Cryptograhpic library.
- * Additional information on it can be found at:
- *    http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=22972
- *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
- *
- * GPL LICENSE SUMMARY
+ * AES CTR mode by8 optimization with AVX instructions. (x86_64)
  *
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
  * James Guilford <james.guilford@intel.com>
  * Sean Gulley <sean.m.gulley@intel.com>
  * Chandramouli Narayanan <mouli@linux.intel.com>
+ */
+/*
+ * This is AES128/192/256 CTR mode optimization implementation. It requires
+ * the support of Intel(R) AESNI and AVX instructions.
  *
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
+ * This work was inspired by the AES CTR mode optimization published
+ * in Intel Optimized IPSEC Cryptographic library.
+ * Additional information on it can be found at:
+ *    https://github.com/intel/intel-ipsec-mb
  */
 
 #include <linux/linkage.h>
-- 
2.34.1.703.g22d0c6ccf7-goog

