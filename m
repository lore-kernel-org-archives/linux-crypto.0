Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78E2C433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Jan 2021 07:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 915E5239D4
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Jan 2021 07:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbhAWHap (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Jan 2021 02:30:45 -0500
Received: from mga12.intel.com ([192.55.52.136]:5178 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbhAWHam (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Jan 2021 02:30:42 -0500
IronPort-SDR: zvMTV25zZkIYA1ysM1EZQ3+O4EBzt9AcVGssWArcYU/50MwjlnFRY7v9kqJw7YaudyBWd/KYaH
 iadEoyjQrjKA==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="158731939"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="158731939"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 23:29:46 -0800
IronPort-SDR: T1GySwcfAnlsw6gP0ldz8yIbv2IiT99sRbCIAqHwd/DH3OdD2v8iKU1HlaU/c+K1g8XN3A/H+9
 tIX703O8Oc+A==
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="468448075"
Received: from megha-z97x-ud7-th.sc.intel.com ([143.183.85.154])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 22 Jan 2021 23:29:46 -0800
From:   Megha Dey <megha.dey@intel.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, dave.hansen@intel.com, megha.dey@intel.com,
        greg.b.tucker@intel.com, robert.a.kasten@intel.com,
        rajendrakumar.chinnaiyan@intel.com, tomasz.kantecki@intel.com,
        ryan.d.saffores@intel.com, ilya.albrekht@intel.com,
        kyung.min.park@intel.com, tony.luck@intel.com, ira.weiny@intel.com,
        ebiggers@kernel.org, ardb@kernel.org, x86@kernel.org
Subject: [RFC V2 2/5] x86: Probe assembler capabilities for VAES and VPLCMULQDQ support
Date:   Fri, 22 Jan 2021 23:28:37 -0800
Message-Id: <1611386920-28579-3-git-send-email-megha.dey@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611386920-28579-1-git-send-email-megha.dey@intel.com>
References: <1611386920-28579-1-git-send-email-megha.dey@intel.com>
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
index 26b8c08..1b07bc6 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -1,6 +1,16 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (C) 2020 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
 
+config AS_VAES_AVX512
+	def_bool $(as-instr,vaesenc %zmm0$(comma)%zmm1$(comma)%zmm1)
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

