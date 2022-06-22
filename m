Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18AB7CCA483
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jun 2022 14:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358173AbiFVOtL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jun 2022 10:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358381AbiFVOtE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jun 2022 10:49:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 790E83DDF0
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2022 07:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655909341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EfBoGV8G1t/ZFoRqhI564VYHfItzSstPW0YccRoMmqE=;
        b=MFyoSGIZW7rh72H34cf3+9tSYIC0Bpj+ma/9h1UCmZMXkrVT20zJpu6K5NJqu1icsvyMNj
        ylcEnjBrffI44jfFYZ/MvHAVsNQkd88NJNnFDrM0oASLjv1lgXPilMuoep3gvQzeTlVLZd
        yGFy5pOHKwR3BbbmT7cNPA1N6Osmgo4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-q1hoiWDCP5afXOn50jXiQA-1; Wed, 22 Jun 2022 10:48:58 -0400
X-MC-Unique: q1hoiWDCP5afXOn50jXiQA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FB1482406B;
        Wed, 22 Jun 2022 14:48:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2199240D2962;
        Wed, 22 Jun 2022 14:48:39 +0000 (UTC)
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
Subject: [PATCH 3/4] x86/cpuid: move filter_cpuid_features to cpuid-deps.c
Date:   Wed, 22 Jun 2022 17:48:19 +0300
Message-Id: <20220622144820.751402-4-mlevitsk@redhat.com>
In-Reply-To: <20220622144820.751402-1-mlevitsk@redhat.com>
References: <20220622144820.751402-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

No functional change intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/cpufeature.h |  1 +
 arch/x86/kernel/cpu/common.c      | 46 -----------------------------
 arch/x86/kernel/cpu/cpuid-deps.c  | 48 +++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index ea34cc31b0474f..3eb5fe0d654e63 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -147,6 +147,7 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 
 extern void setup_clear_cpu_cap(unsigned int bit);
 extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
+extern void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn);
 
 #define setup_force_cpu_cap(bit) do { \
 	set_cpu_cap(&boot_cpu_data, bit);	\
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4730b0a58f24a5..4cc79971d2d847 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -620,52 +620,6 @@ __noendbr void cet_disable(void)
 		wrmsrl(MSR_IA32_S_CET, 0);
 }
 
-/*
- * Some CPU features depend on higher CPUID levels, which may not always
- * be available due to CPUID level capping or broken virtualization
- * software.  Add those features to this table to auto-disable them.
- */
-struct cpuid_dependent_feature {
-	u32 feature;
-	u32 level;
-};
-
-static const struct cpuid_dependent_feature
-cpuid_dependent_features[] = {
-	{ X86_FEATURE_MWAIT,		0x00000005 },
-	{ X86_FEATURE_DCA,		0x00000009 },
-	{ X86_FEATURE_XSAVE,		0x0000000d },
-	{ 0, 0 }
-};
-
-static void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
-{
-	const struct cpuid_dependent_feature *df;
-
-	for (df = cpuid_dependent_features; df->feature; df++) {
-
-		if (!cpu_has(c, df->feature))
-			continue;
-		/*
-		 * Note: cpuid_level is set to -1 if unavailable, but
-		 * extended_extended_level is set to 0 if unavailable
-		 * and the legitimate extended levels are all negative
-		 * when signed; hence the weird messing around with
-		 * signs here...
-		 */
-		if (!((s32)df->level < 0 ?
-		     (u32)df->level > (u32)c->extended_cpuid_level :
-		     (s32)df->level > (s32)c->cpuid_level))
-			continue;
-
-		clear_cpu_cap(c, df->feature);
-		if (!warn)
-			continue;
-
-		pr_warn("CPU: CPU feature " X86_CAP_FMT " disabled, no CPUID level 0x%x\n",
-			x86_cap_flag(df->feature), df->level);
-	}
-}
 
 /*
  * Naming convention should be: <Name> [(<Codename>)]
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index d6777d07ba3302..bcb091d02a754b 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -131,3 +131,51 @@ void setup_clear_cpu_cap(unsigned int feature)
 {
 	clear_cpu_cap(&boot_cpu_data, feature);
 }
+
+
+/*
+ * Some CPU features depend on higher CPUID levels, which may not always
+ * be available due to CPUID level capping or broken virtualization
+ * software.  Add those features to this table to auto-disable them.
+ */
+struct cpuid_dependent_feature {
+	u32 feature;
+	u32 level;
+};
+
+static const struct cpuid_dependent_feature
+cpuid_dependent_features[] = {
+	{ X86_FEATURE_MWAIT,		0x00000005 },
+	{ X86_FEATURE_DCA,		0x00000009 },
+	{ X86_FEATURE_XSAVE,		0x0000000d },
+	{ 0, 0 }
+};
+
+void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
+{
+	const struct cpuid_dependent_feature *df;
+
+	for (df = cpuid_dependent_features; df->feature; df++) {
+
+		if (!cpu_has(c, df->feature))
+			continue;
+		/*
+		 * Note: cpuid_level is set to -1 if unavailable, but
+		 * extended_extended_level is set to 0 if unavailable
+		 * and the legitimate extended levels are all negative
+		 * when signed; hence the weird messing around with
+		 * signs here...
+		 */
+		if (!((s32)df->level < 0 ?
+		     (u32)df->level > (u32)c->extended_cpuid_level :
+		     (s32)df->level > (s32)c->cpuid_level))
+			continue;
+
+		clear_cpu_cap(c, df->feature);
+		if (!warn)
+			continue;
+
+		pr_warn("CPU: CPU feature " X86_CAP_FMT " disabled, no CPUID level 0x%x\n",
+			x86_cap_flag(df->feature), df->level);
+	}
+}
-- 
2.26.3

