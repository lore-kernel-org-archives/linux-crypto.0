Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93B8C43334
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jun 2022 14:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357478AbiFVOtG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jun 2022 10:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358107AbiFVOtE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jun 2022 10:49:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C53B3DDD2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jun 2022 07:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655909339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JV9YRdtqoo7wzkDPDGDuYdQDwku8zHdZp+0Mbg9ps38=;
        b=V2L1PMAoCL5mmB59k6U2+v/dv7zW6ReuX9ctia6Tkv1TD036f/IWmQZOlhWkCkJrW1uTJP
        YealInq9Nb6Pp35aC/XEjJp9TO1X3WnZeXxfaTUcNkWyY2sQF9XM0iBQO0a63nfig47nS3
        TyTFVTOLW1W4JCSdfALc5vHFGEWCpKc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-GvR57FqhPSOhQOOsE3g4wg-1; Wed, 22 Jun 2022 10:48:53 -0400
X-MC-Unique: GvR57FqhPSOhQOOsE3g4wg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C9E71DC245B;
        Wed, 22 Jun 2022 14:48:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3A2F404E4DF;
        Wed, 22 Jun 2022 14:48:28 +0000 (UTC)
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
Subject: [PATCH 1/4] perf/x86/intel/lbr: use setup_clear_cpu_cap instead of clear_cpu_cap
Date:   Wed, 22 Jun 2022 17:48:17 +0300
Message-Id: <20220622144820.751402-2-mlevitsk@redhat.com>
In-Reply-To: <20220622144820.751402-1-mlevitsk@redhat.com>
References: <20220622144820.751402-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

clear_cpu_cap(&boot_cpu_data) is very similar to setup_clear_cpu_cap
except that the latter also sets a bit in 'cpu_caps_cleared' which
later clears the same cap in secondary cpus, which is likely
what is meant here.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/events/intel/lbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/lbr.c b/arch/x86/events/intel/lbr.c
index 13179f31fe10fa..b08715172309a7 100644
--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1860,7 +1860,7 @@ void __init intel_pmu_arch_lbr_init(void)
 	return;
 
 clear_arch_lbr:
-	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_ARCH_LBR);
+	setup_clear_cpu_cap(X86_FEATURE_ARCH_LBR);
 }
 
 /**
-- 
2.26.3

