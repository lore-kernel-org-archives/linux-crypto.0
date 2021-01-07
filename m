Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F012FC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 06:20:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5B0D22E00
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 06:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbhAGGUg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 01:20:36 -0500
Received: from ZXSHCAS1.zhaoxin.com ([203.148.12.81]:52908 "EHLO
        ZXSHCAS1.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbhAGGUg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 01:20:36 -0500
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS1.zhaoxin.com
 (10.28.252.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 7 Jan 2021
 14:19:20 +0800
Received: from tony-HX002EA.zhaoxin.com (10.32.56.37) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 7 Jan 2021
 14:19:17 +0800
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>,
        <dave.hansen@intel.com>, <seanjc@google.com>,
        <fenghua.yu@intel.com>, <thomas.lendacky@amd.com>,
        <kyung.min.park@intel.com>, <kim.phillips@amd.com>,
        <mgross@linux.intel.com>, <peterz@infradead.org>,
        <krish.sadhukhan@oracle.com>, <liam.merwick@oracle.com>,
        <mlevitsk@redhat.com>, <reinette.chatre@intel.com>,
        <babu.moger@amd.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <TimGuo-oc@zhaoxin.com>, <CooperYan@zhaoxin.com>,
        <QiyuanWang@zhaoxin.com>, <HerryYang@zhaoxin.com>,
        <CobeChen@zhaoxin.com>, <SilviaZhao@zhaoxin.com>
Subject: [PATCH v1 2/3] x86/cpu: Set low performance CRC32C flag on some Zhaoxin CPUs
Date:   Thu, 7 Jan 2021 14:19:07 +0800
Message-ID: <1610000348-17316-3-git-send-email-TonyWWang-oc@zhaoxin.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1610000348-17316-1-git-send-email-TonyWWang-oc@zhaoxin.com>
References: <1610000348-17316-1-git-send-email-TonyWWang-oc@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.32.56.37]
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some Zhaoxin CPUs declare support SSE4.2 instruction sets but
having a CRC32C instruction implementation that not working as
intended. Set low performance CRC32C flag on these CPUs for later
use.

Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
---
 arch/x86/kernel/cpu/centaur.c | 7 +++++++
 arch/x86/kernel/cpu/zhaoxin.c | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 345f7d9..13e6fbe 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -109,6 +109,13 @@ static void early_init_centaur(struct cpuinfo_x86 *c)
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
 	}
+
+	/*
+	 * These CPUs declare support SSE4.2 instruction sets but
+	 * having low performance CRC32C instruction implementation.
+	 */
+	if (c->x86 == 0x6 || (c->x86 == 0x7 && c->x86_model <= 0x3b))
+		set_cpu_cap(c, X86_FEATURE_CRC32C);
 }
 
 static void init_centaur(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/zhaoxin.c b/arch/x86/kernel/cpu/zhaoxin.c
index 05fa4ef..837ec65 100644
--- a/arch/x86/kernel/cpu/zhaoxin.c
+++ b/arch/x86/kernel/cpu/zhaoxin.c
@@ -79,6 +79,12 @@ static void early_init_zhaoxin(struct cpuinfo_x86 *c)
 			c->x86_coreid_bits = get_count_order((ebx >> 16) & 0xff);
 	}
 
+	/*
+	 * These CPUs declare support SSE4.2 instruction sets but
+	 * having low performance CRC32C instruction implementation.
+	 */
+	if (c->x86 == 0x6 || (c->x86 == 0x7 && c->x86_model <= 0x3b))
+		set_cpu_cap(c, X86_FEATURE_CRC32C);
 }
 
 static void init_zhaoxin(struct cpuinfo_x86 *c)
-- 
2.7.4

