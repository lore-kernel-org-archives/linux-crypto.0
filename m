Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF15C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Nov 2021 12:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4E04610A8
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Nov 2021 12:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhKCMtM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Nov 2021 08:49:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230282AbhKCMtL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Nov 2021 08:49:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635943594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=z6Gv9aPGAm2nkgSP8Un5y2TgCpXofV69fWr18YkFIeQ=;
        b=AlBOiaM2/FQAR6QEqjF3uH7XdY9a2m2KVbSipFasTRy8GeblOTZiWMpc5jKeAlJ3RgGudn
        4i/pmnF+qccXrHJ9cfFK9kf9qyU1vfKXqT6pENzs3wcZpH0BCxKUXnYpt/WgbWMX3ciBXe
        L9+ZQjSyTKZL6Y410uTF4QGY3jFQRzM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-nRiYLvqzPYK0wVmqGeNc8Q-1; Wed, 03 Nov 2021 08:46:31 -0400
X-MC-Unique: nRiYLvqzPYK0wVmqGeNc8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19444DF8A7;
        Wed,  3 Nov 2021 12:46:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85E4070F6A;
        Wed,  3 Nov 2021 12:46:15 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] crypto: x86/aes-ni: fix AVX detection
Date:   Wed,  3 Nov 2021 14:46:14 +0200
Message-Id: <20211103124614.499580-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix two semi-theoretical issues that are present.

1. AVX is assumed to be present when AVX2 is present.
 That can be false in a VM.
 This can be considered a hypervisor bug,
 but the kernel should not crash in this case if this is possible.

2. YMM state can be soft disabled in XCR0.

Fix both issues by using 'cpu_has_xfeatures(XFEATURE_MASK_YMM')
to check for usable AVX support.

Fixes: d764593af9249 ("crypto: aesni - AVX and AVX2 version of AESNI-GCM encode and decode")

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 0fc961bef299c..20db1e500ef6f 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1147,24 +1147,25 @@ static int __init aesni_init(void)
 	if (!x86_match_cpu(aesni_cpu_id))
 		return -ENODEV;
 #ifdef CONFIG_X86_64
-	if (boot_cpu_has(X86_FEATURE_AVX2)) {
-		pr_info("AVX2 version of gcm_enc/dec engaged.\n");
-		static_branch_enable(&gcm_use_avx);
-		static_branch_enable(&gcm_use_avx2);
-	} else
-	if (boot_cpu_has(X86_FEATURE_AVX)) {
-		pr_info("AVX version of gcm_enc/dec engaged.\n");
+	if (cpu_has_xfeatures(XFEATURE_MASK_YMM, NULL)) {
+
 		static_branch_enable(&gcm_use_avx);
-	} else {
-		pr_info("SSE version of gcm_enc/dec engaged.\n");
-	}
-	if (boot_cpu_has(X86_FEATURE_AVX)) {
+
+		if (boot_cpu_has(X86_FEATURE_AVX2)) {
+			static_branch_enable(&gcm_use_avx2);
+			pr_info("AVX2 version of gcm_enc/dec engaged.\n");
+		} else {
+			pr_info("AVX version of gcm_enc/dec engaged.\n");
+		}
+
 		/* optimize performance of ctr mode encryption transform */
 		static_call_update(aesni_ctr_enc_tfm, aesni_ctr_enc_avx_tfm);
 		pr_info("AES CTR mode by8 optimization enabled\n");
+
+	} else {
+		pr_info("SSE version of gcm_enc/dec engaged.\n");
 	}
 #endif
-
 	err = crypto_register_alg(&aesni_cipher_alg);
 	if (err)
 		return err;
-- 
2.26.3

