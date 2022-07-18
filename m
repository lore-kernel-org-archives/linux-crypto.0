Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79C6AC43334
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Jul 2022 14:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbiGROLz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Jul 2022 10:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbiGROLy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Jul 2022 10:11:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A8312714C
        for <linux-crypto@vger.kernel.org>; Mon, 18 Jul 2022 07:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658153512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w5ar1xL/lWu4+LzORYC79cebbS3mhMxSowTJXzIDy14=;
        b=Oy0g75aHSEljcev3+J0Dfex68Bxt0Y7k9iHue9UyhauJqYE1R1U4jASc0ycO7zzmSfua+0
        cnWl+/5snznE6q+B43Y0vx9KWi5FZ/YdEnHe7yGGsd6mUepcBSAohH3lcs6gojp1UQgFiW
        pDhH3edQKgyHiXxS0vEj3duq4WSGvQ0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-F11jd_UNMn6FzKPX6SELGw-1; Mon, 18 Jul 2022 10:11:42 -0400
X-MC-Unique: F11jd_UNMn6FzKPX6SELGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3250096AC62;
        Mon, 18 Jul 2022 14:11:40 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E7D92026D64;
        Mon, 18 Jul 2022 14:11:35 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Jane Malalane <jane.malalane@citrix.com>,
        Kees Cook <keescook@chromium.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-perf-users@vger.kernel.org,
        linux-crypto@vger.kernel.org (open list:CRYPTO API)
Subject: [PATCH v2 2/5] x86/cpuid: refactor setup_clear_cpu_cap()/clear_cpu_cap()
Date:   Mon, 18 Jul 2022 17:11:20 +0300
Message-Id: <20220718141123.136106-3-mlevitsk@redhat.com>
In-Reply-To: <20220718141123.136106-1-mlevitsk@redhat.com>
References: <20220718141123.136106-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently setup_clear_cpu_cap passes NULL 'struct cpuinfo_x86*'
to clear_cpu_cap to indicate that capability should be cleared from boot_cpu_data.

Later that is used in clear_feature to do recursive call to
clear_cpu_cap together with clearing the feature bit from 'cpu_caps_cleared'

Remove that code and just call the do_clear_cpu_cap on boot_cpu_data directly
from the setup_clear_cpu_cap.

The only functional change this introduces is that now calling clear_cpu_cap
explicitly on boot_cpu_data also sets the bits in cpu_caps_cleared,
which is the only thing that makes sense anyway.

All callers of both functions were checked for this and fixed.

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
2.34.3

