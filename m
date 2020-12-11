Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43ABC4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 11:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AF9323DE3
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 11:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395111AbgLKLqL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Dec 2020 06:46:11 -0500
Received: from ZXSHCAS2.zhaoxin.com ([203.148.12.82]:24280 "EHLO
        ZXSHCAS2.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395106AbgLKLps (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Dec 2020 06:45:48 -0500
X-Greylist: delayed 953 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Dec 2020 06:45:45 EST
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS2.zhaoxin.com
 (10.28.252.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 11 Dec
 2020 19:29:08 +0800
Received: from tony-HX002EA.zhaoxin.com (10.32.56.37) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 11 Dec
 2020 19:29:06 +0800
From:   Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <x86@kernel.org>, <hpa@zytor.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <TimGuo-oc@zhaoxin.com>, <CooperYan@zhaoxin.com>,
        <QiyuanWang@zhaoxin.com>, <HerryYang@zhaoxin.com>,
        <CobeChen@zhaoxin.com>, <SilviaZhao@zhaoxin.com>
Subject: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
Date:   Fri, 11 Dec 2020 19:29:04 +0800
Message-ID: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.32.56.37]
X-ClientProxiedBy: ZXSHCAS2.zhaoxin.com (10.28.252.162) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver crc32c-intel match CPUs supporting X86_FEATURE_XMM4_2.
On platforms with Zhaoxin CPUs supporting this X86 feature, When
crc32c-intel and crc32c-generic are both registered, system will
use crc32c-intel because its .cra_priority is greater than
crc32c-generic. This case expect to use crc32c-generic driver for
some Zhaoxin CPUs to get performance gain, So remove these Zhaoxin
CPUs support from crc32c-intel.

Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
---
 arch/x86/crypto/crc32c-intel_glue.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
index feccb52..6dafdae 100644
--- a/arch/x86/crypto/crc32c-intel_glue.c
+++ b/arch/x86/crypto/crc32c-intel_glue.c
@@ -222,8 +222,16 @@ MODULE_DEVICE_TABLE(x86cpu, crc32c_cpu_id);
 
 static int __init crc32c_intel_mod_init(void)
 {
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
 	if (!x86_match_cpu(crc32c_cpu_id))
 		return -ENODEV;
+
+	if (c->x86_vendor == X86_VENDOR_ZHAOXIN || c->x86_vendor == X86_VENDOR_CENTAUR) {
+		if (c->x86 == 0x6 || (c->x86 == 0x7 && c->x86_model <= 0x3b))
+			return -ENODEV;
+	}
+
 #ifdef CONFIG_X86_64
 	if (boot_cpu_has(X86_FEATURE_PCLMULQDQ)) {
 		alg.update = crc32c_pcl_intel_update;
-- 
2.7.4

