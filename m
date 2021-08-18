Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590D8C432BE
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 05:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 396EB61029
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Aug 2021 05:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbhHRFjx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Aug 2021 01:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237809AbhHRFjv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Aug 2021 01:39:51 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAC5C0613CF
        for <linux-crypto@vger.kernel.org>; Tue, 17 Aug 2021 22:39:17 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f64-20020a2538430000b0290593bfc4b046so1703138yba.9
        for <linux-crypto@vger.kernel.org>; Tue, 17 Aug 2021 22:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WiP9HgfFffnWMWhcvdLBuLUWs2FAICpYV6zjCSodstc=;
        b=P5d31hh5vOF8UCVyLfij5pHCgatyTEnprnjz48lUR/QQ2E7SfxSMCwblt2FHfkDfo+
         QSTLLUyH2TsfavUcqw89bJCByn9dSp8QrIJxkxVd/lwTZKdD+Y7rjveCSbf4fztCUgca
         npdHNANe1QbR/obju31jRjMyELrgc+v+IVAcgLdFrOwN6l7zLtgE1GNTuzzf05W1bvDF
         fY0P4AHor6om6MtzOJuA8e9uQXFTQ8nkXU8FDTfNz7TLrUR9tSUNc6HmgsAiJiEwXxco
         FUPgbFeE5chpzWIuA+rznzFGsXVr1DdfILy3hnU6fUj3oehSHDHqN0nxyiH5Phmx2WSN
         oC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WiP9HgfFffnWMWhcvdLBuLUWs2FAICpYV6zjCSodstc=;
        b=TDdGpDQmsQSky68o1Gy/c9G74SR1+LgVpOPDcXKK/MqbpiKn5B90icyZu157G6+l7M
         fqfuFQHd+AkpHm+hAU292yKEFsAtFCtL4yE67Hyskrg4GIwLb10Ps9zEfCBhwipZfyZB
         u3QxsQrO2beTkgpuCvOyePNt1wsdgJUq6ktQPU+ghAO96LjfQFk86LRQ8Lfug8q0O98V
         VLV9EqxTSfr7eJQIC2vNn7ULhgUqZVISW5HN2cXEr/QjvbAyuT4XWw0nerIvBRtH7D4J
         1Culj8gj21X5/oVQ5Kh1I4w2E6VCfKpmvrrpqGhEPXPxXDeMYJfgtzK7n9geytetzApU
         CSuw==
X-Gm-Message-State: AOAM530NxWLPl63yGUVre1CeKbHLe4z6uN+5N2woE6afdpi3cxDGj58D
        TT1wdA6S1nrMbE3qlL068Rgdttkr3Y+m
X-Google-Smtp-Source: ABdhPJxCFOFGuoTsOROSCJ1NTKokiUsMORo0yKzUHyO06VSofqt1ILBv+0YQgs0T5mNF+jmcqNxoJCGbjPnJ
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a5b:7c4:: with SMTP id t4mr9212584ybq.509.1629265156833;
 Tue, 17 Aug 2021 22:39:16 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 18 Aug 2021 05:39:05 +0000
In-Reply-To: <20210818053908.1907051-1-mizhang@google.com>
Message-Id: <20210818053908.1907051-2-mizhang@google.com>
Mime-Version: 1.0
References: <20210818053908.1907051-1-mizhang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 1/4] KVM: SVM: fix missing sev_decommission in sev_receive_start
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

sev_decommission is needed in the error path of sev_bind_asid. The purpose
of this function is to clear the firmware context. Missing this step may
cause subsequent SEV launch failures.

Although missing sev_decommission issue has previously been found and was
fixed in sev_launch_start function. It is supposed to be fixed on all
scenarios where a firmware context needs to be freed. According to the AMD
SEV API v0.24 Section 1.3.3:

"The RECEIVE_START command is the only command other than the LAUNCH_START
command that generates a new guest context and guest handle."

The above indicates that RECEIVE_START command also requires calling
sev_decommission if ASID binding fails after RECEIVE_START succeeds.

So add the sev_decommission function in sev_receive_start.

Cc: Alper Gun <alpergun@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: David Rienjes <rientjes@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vipin Sharma <vipinsh@google.com>

Fixes: af43cbbf954b ("KVM: SVM: Add support for KVM_SEV_RECEIVE_START command")
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/sev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75e0b21ad07c..55d8b9c933c3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1397,8 +1397,10 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Bind ASID to this guest */
 	ret = sev_bind_asid(kvm, start.handle, error);
-	if (ret)
+	if (ret) {
+		sev_decommission(start.handle);
 		goto e_free_session;
+	}
 
 	params.handle = start.handle;
 	if (copy_to_user((void __user *)(uintptr_t)argp->data,
-- 
2.33.0.rc1.237.g0d66db33f3-goog

