Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D338CC2D0E4
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 21:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABFDE23B8A
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 21:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgLRVH0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 16:07:26 -0500
Received: from mga06.intel.com ([134.134.136.31]:16596 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbgLRVHX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 16:07:23 -0500
IronPort-SDR: xqSmZ4XoxMlar5V10Xs9ADSN4D01JQRmthJXFLWOObkA+PLOV+7KewpMJC8RPTL9w3KyAxcxEo
 yIVTa777mywg==
X-IronPort-AV: E=McAfee;i="6000,8403,9839"; a="237075265"
X-IronPort-AV: E=Sophos;i="5.78,431,1599548400"; 
   d="scan'208";a="237075265"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2020 13:06:41 -0800
IronPort-SDR: N3w/bmKwMTVnRSvyKH9j5V56MkVecWa0x2iOvGeE0u9TuNRLz2M/3TjZwWMn0XE4eEoLdyB8yC
 Y903HpFOX5uw==
X-IronPort-AV: E=Sophos;i="5.78,431,1599548400"; 
   d="scan'208";a="370785937"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 18 Dec 2020 13:06:41 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, dave.hansen@intel.com, megha.dey@intel.com,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        tony.luck@intel.com, ira.weiny@intel.com, x86@kernel.org
Subject: [RFC V1 1/7] x86: Probe assembler capabilities for VAES and VPLCMULQDQ support
Date:   Fri, 18 Dec 2020 13:10:58 -0800
Message-Id: <1608325864-4033-2-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a preparatory patch to introduce the optimized crypto algorithms
using AVX512 instructions which would require VAES and VPLCMULQDQ support.

Check for VAES and VPCLMULQDQ assembler support using AVX512 registers.

Cc: x86@kernel.org
Signed-off-by: Megha Dey <megha.dey@intel.com>
---
 arch/x86/Kconfig.assembler | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
index 26b8c08..9ea0bc8 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -1,6 +1,16 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (C) 2020 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
 
+config AS_VAES_AVX512
+	def_bool $(as-instr,vaesenc %zmm0$(comma)%zmm1$(comma)%zmm1) && 64BIT
+	help
+	  Supported by binutils >= 2.30 and LLVM integrated assembler
+
+config AS_VPCLMULQDQ
+	def_bool $(as-instr,vpclmulqdq \$0$(comma)%zmm2$(comma)%zmm6$(comma)%zmm4)
+	help
+	  Supported by binutils >= 2.30 and LLVM integrated assembler
+
 config AS_AVX512
 	def_bool $(as-instr,vpmovm2b %k1$(comma)%zmm5)
 	help
-- 
2.7.4

