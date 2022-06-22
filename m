Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E95EC43334
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jun 2022 14:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358420AbiFVOtM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jun 2022 10:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358513AbiFVOtE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jun 2022 10:49:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E4713DDF9
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2022 07:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655909342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XCWooTms+wWlHXZcDu8ZPg89E6H/2XmTErhXmxcvgaE=;
        b=AqYIm6MfW97EttoMCBJZwhtag9T+nkbiYHuJ++lYp4Peg88OrWHPIYHMgtvi35Lng3uPDe
        uMBq+QKG+i55pFaxhkCLuMk+vVlq6mGWfJcOPWY/2NeNgvFulXmn32lg3gawXhatZw87hS
        R2c76PIYb4fSNstWfDoxysMogcGC5J0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-brYIksGeNkyLtuH1ievjYA-1; Wed, 22 Jun 2022 10:48:57 -0400
X-MC-Unique: brYIksGeNkyLtuH1ievjYA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCECA2A2AD44;
        Wed, 22 Jun 2022 14:48:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96EDC40E80FF;
        Wed, 22 Jun 2022 14:48:34 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jiri Olsa <jolsa@kernel.org>, linux-perf-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Borislav Petkov <bp@alien8.de>,
        Kees Cook <keescook@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jane Malalane <jane.malalane@citrix.com>,
        Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/4] x86/cpuid: refactor setup_clear_cpu_cap/clear_feature
Date:   Wed, 22 Jun 2022 17:48:18 +0300
Message-Id: <20220622144820.751402-3-mlevitsk@redhat.com>
In-Reply-To: <20220622144820.751402-1-mlevitsk@redhat.com>
References: <20220622144820.751402-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Simplify the code a bit by always passing &boot_cpu_data
in case the setup_clear_cpu_cap was called.

Also unify clear_cpu_cap and do_clear_cpu_cap.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kernel/cpu/cpuid-deps.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index c881bcafba7d70..d6777d07ba3302 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -88,18 +88,16 @@ static inline void clear_feature(struct cpuinfo_x86 *c, unsigned int feature)
 	 * rest of the cpufeature code uses atomics as well, so keep it for
 	 * consistency. Cleanup all of it separately.
 	 */
-	if (!c) {
-		clear_cpu_cap(&boot_cpu_data, feature);
+	clear_bit(feature, (unsigned long *)c->x86_capability);
+
+	if (c == &boot_cpu_data)
 		set_bit(feature, (unsigned long *)cpu_caps_cleared);
-	} else {
-		clear_bit(feature, (unsigned long *)c->x86_capability);
-	}
 }
 
 /* Take the capabilities and the BUG bits into account */
 #define MAX_FEATURE_BITS ((NCAPINTS + NBUGINTS) * sizeof(u32) * 8)
 
-static void do_clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int feature)
+void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int feature)
 {
 	DECLARE_BITMAP(disable, MAX_FEATURE_BITS);
 	const struct cpuid_dep *d;
@@ -129,12 +127,7 @@ static void do_clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int feature)
 	} while (changed);
 }
 
-void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int feature)
-{
-	do_clear_cpu_cap(c, feature);
-}
-
 void setup_clear_cpu_cap(unsigned int feature)
 {
-	do_clear_cpu_cap(NULL, feature);
+	clear_cpu_cap(&boot_cpu_data, feature);
 }
-- 
2.26.3

