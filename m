Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E583A3802
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 23:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776381829; cv=none; b=abCQg7CFOliURufzPKOyDM5Z29Zl3v9FV9DrKHE3feOBya2zh6Pp2KZ9dxpW9F9ybQSf0QIfHg2x1kUg8q3vId+7RBAwKMMA5Pa++u5NghMCMLALuXjVqswaWTWgq6qGaLH2JyuGjJvEzuU3v0ULWdRFtOYga+kBl5DNZuW6j6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776381829; c=relaxed/simple;
	bh=zKm4jq2+Ev4Sd7cYDHKHfbI/oMMYXorfvBJC06pU4MY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iuOBIoFvIzASHMXZ+3c1nEE+bjfzBd3+x/Y7tStlhYWUqxf9azfAwzz1M5jImbYGupHUdisT7LfUVr7Nf15E2cNM4c5nyZ88oEn6k4sOl8VZ3a6sdOM5NAvsBIQDb+KjQma4J0wiotVh/GFuHH/Q/crn0Gxnvx1xF/0byQkeoKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wNgtltwl; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wNgtltwl"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358e95e81aeso472655a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 16:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776381827; x=1776986627; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jdKPTqMov8cbfemJo4nynbMk23/qpGeXeEBr2ivwq2M=;
        b=wNgtltwlPHR7ofdEbgL01zPz7+zQKZKEEgGED+irQdlbrazUeZ/pd1nHYdKmAKd5bS
         5DluXPgk+t0eSKC8TqsOQFTNLrT9uxzZ3nSIKHf69Se/0ZNwcfswo4ezhbMAnG8qBvV7
         wYM9kfyHBuVoiwkGMmgFgl6ux61yYs3WoAl5QmhWw4/jHwkN/2tNkP1clgsAhWzgMJ85
         9ASswKIyo+2QeSAIousThIWFrBtH7kHgNBXVE0aj1wjdwhl+irV+T/nxKwecNO0y8eKu
         Fz0A/xp3LzfntpXRPuv8RkNK1E4F01GUrzCSXAy01XFdxgYvwJmWQle9w1X4I6O2O+YC
         1cmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776381827; x=1776986627;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jdKPTqMov8cbfemJo4nynbMk23/qpGeXeEBr2ivwq2M=;
        b=RkVx72K7YVmqtxk3Nak0h3Tw8iI1Cgun+WL/rFVx7jbpNmb1VJbaRmGCch07AY8eBq
         G1CahBZOImT/qG28K7GqnFtzKZ2fMJULEVj3mfxp/YoUa36GrRib/A2DJd1gOjl6Zd2V
         4RzslgqlxZbBt/kalFLH7DuYkrCiWlUO7wgRhC/lGhXBbiJxu6gMKyaJTXCWgf/KELHj
         njK9U4xtORJNFDQWiTxasjETr+h/OVjBUH+eRFYk8ItOl47XyVnuS4BQx7vUOU301hX9
         hJyqmx+EnwnJ+PTa5lWQZp/m1OEUljbKOZ2xtv3Ae20nEU7ttA/4HrmSOsjbLjg3D3jk
         kLSQ==
X-Forwarded-Encrypted: i=1; AFNElJ/kosApgy5+rfhIzy+IaKy9oxSbMQ0K6cGR2Q8aCaNf8LisXWsonLXc1qR1c8wOdBazcnYCap0K3Qh+Adw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy7J9GrlfRB9Qdu3uBll+Mc3/ubBNEQVmo4+WFIgF/dgSH9w5r
	FMRD9l/WJDPFJXfgYYZU7CKgJJ6qCxjraFZlisWxQjWsZRlo0ynuQ1vjF9aSbw+b5RFh0aoXUeE
	JREiATg==
X-Received: from pgac12.prod.google.com ([2002:a05:6a02:294c:b0:c76:8acb:773d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5288:b0:359:fe72:3559
 with SMTP id 98e67ed59e1d1-3614048b1aemr440448a91.21.1776381827205; Thu, 16
 Apr 2026 16:23:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Apr 2026 16:23:27 -0700
In-Reply-To: <20260416232329.3408497-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260416232329.3408497-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.513.gad8abe7a5a-goog
Message-ID: <20260416232329.3408497-6-seanjc@google.com>
Subject: [PATCH v3 5/7] KVM: SEV: Don't advertise support for unusable VM types
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Tycho Andersen <tycho@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Commit 0aa6b90ef9d7 ("KVM: SVM: Add support for allowing zero SEV ASIDs")
made it possible to make it impossible to use SEV VMs by not allocating
them any ASIDs.

Commit 6c7c620585c6 ("KVM: SEV: Add SEV-SNP CipherTextHiding support") did
the same thing for SEV-ES.

Do not export KVM_X86_SEV(_ES)_VM as supported types if in either of these
situations, so that userspace can use them to determine what is actually
supported by the current kernel configuration.

Also move the buildup to a local variable so it is easier to add additional
masking in future patches.

Link: https://lore.kernel.org/all/aZyLIWtffvEnmtYh@google.com/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
[sean: land code in sev_hardware_setup()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dfeb660b8f5d..0971cf652b0b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3062,6 +3062,7 @@ void __init sev_hardware_setup(void)
 	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
+	u32 vm_types = 0;
 
 	if (!sev_enabled || !npt_enabled || !nrips)
 		goto out;
@@ -3195,24 +3196,26 @@ void __init sev_hardware_setup(void)
 		}
 	}
 
-	if (sev_supported)
-		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_VM);
-	if (sev_es_supported)
-		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
+	if (sev_supported && min_sev_asid <= max_sev_asid)
+		vm_types |= BIT(KVM_X86_SEV_VM);
+	if (sev_es_supported && min_sev_es_asid <= max_sev_es_asid)
+		vm_types |= BIT(KVM_X86_SEV_ES_VM);
 	if (sev_snp_supported)
-		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
+		vm_types |= BIT(KVM_X86_SNP_VM);
+
+	kvm_caps.supported_vm_types |= vm_types;
 
 	if (boot_cpu_has(X86_FEATURE_SEV))
 		pr_info("SEV %s (ASIDs %u - %u)\n",
-			sev_str_feature_state(sev_supported, min_sev_asid <= max_sev_asid),
+			sev_str_feature_state(sev_supported, vm_types & BIT(KVM_X86_SEV_VM)),
 			min_sev_asid, max_sev_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_ES))
 		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
-			sev_str_feature_state(sev_es_supported, min_sev_es_asid <= max_sev_es_asid),
+			sev_str_feature_state(sev_es_supported, vm_types & BIT(KVM_X86_SEV_ES_VM)),
 			min_sev_es_asid, max_sev_es_asid);
 	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
 		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
-			sev_str_feature_state(sev_snp_supported, true),
+			sev_str_feature_state(sev_snp_supported, vm_types & BIT(KVM_X86_SNP_VM)),
 			min_snp_asid, max_snp_asid);
 
 	sev_enabled = sev_supported;
-- 
2.54.0.rc1.513.gad8abe7a5a-goog

