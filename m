Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18543A1E9F
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 23:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776381835; cv=none; b=mwx4kvQ8MlccEn0giONj/pcqRyQJgUsdqYNk+iFvV7c8Dyiz8sW+DOjvWYblhIR8r0pIgY/unMLyvhSDes11PUKy/+MP4cARaeD/UCNwWtmUHLakz8p0HPrjJtEBaTMYoITsGx4dQPakxwiGsb2EBeI7a070sTK/U6nKv5mpIFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776381835; c=relaxed/simple;
	bh=z9lIX9DuyErNsdEarWQrJGrRTnr2frPfAGsuiIhhPJ8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Sp/uMupHS4zXpm8PAB6HvChzPiBTtoz0ZjlwGrF/RV2V2K9tDr0a4KvOW6HETtO4AxU6/KHoHnBNxMcJrQCJNTWSW2NMb6MRFrvkAgC5AM0ppKiZ0+2EFdqlZgzVbeRrPVHahy+w8VFRw6H9bbuRud0MNkkUG87keIcVOeiOr3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y3lUCtue; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y3lUCtue"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82f71437218so67264b3a.2
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 16:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776381831; x=1776986631; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=zAK6S4K1O30Zc7+4RITzFic55CfupiQzind/IcIwTPU=;
        b=Y3lUCtueEg9o845zn/Z2+HHYEBQ8uEUQg1ZnM+doXc6i4fXP2GR+Xyt4a3Vv/6DtBz
         aJ0rjAJE1w7mZiPGyqtu4wv25rb5bZsa2aXXCs9SdV9Av7BrXVuaAsWN34uY+dDD841g
         4LnoNvbe5y4wwKlGmRJgbRB/Tu9H1fI7CJ/XWXfTU6GWRwYrNhSSSBjzU7JKuahV/+LU
         g7hFOMnwGAHeFXnbKJISS9lGc6xHml43ivWwmQapSI3NSpW/MvKjQYE6YuCHGllYgEKx
         UrNhLfWCfl8hgeyropwG4Oeu7ay7HAaYQJz6obWCDEOwJWp+tAcjitWbGOh9opM+Cj5O
         RGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776381831; x=1776986631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zAK6S4K1O30Zc7+4RITzFic55CfupiQzind/IcIwTPU=;
        b=Ferzb57rUDTTyiY3/s1d3h3xT7/qMhiJ3Rpq/DDSr2futiIIc2WrCn/TOb29yiAADm
         3KAp2jVVc4QN24fWihdK/8jhEJB5BCO8UkqtjFn4WZ2TJ/i/ktL8EB8zMZE7Qj+/UG25
         x7QEx7QwE6xq489gVxbQQ9ekInDey2ao7dkHicJUU0dag5lNWERq/rh4kL3M9s+aQxyQ
         Cgcf5ZSm0w46xXpqOmT43oj8IcBdamZZgsneRSqB7Rt7swzXfoOVhCUEaAuTsAHI8CCK
         cj8P31ddA5On/Ngu5ORqepbEw9Sx41fklB1jnJSeBtMWcA0lazpcBQY3Aezj1imUFMrK
         Sm7Q==
X-Forwarded-Encrypted: i=1; AFNElJ87RHInBWkKmtz9hqr21N3aiEtOTJpjhMFU3BeuLDUKCPLBphM14vL7mF4vIXA51CZJedy0HOpgkApS+uY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzf8X/xtu32vNy0iF/JsaetdKb593iq31m776HPLKn7DGAwNqX
	llQ0mwRdBRHu0S6RNf4xFldA2YLmvYT5VnoKdtmFeF03Zv72AIfL5d9Z9KUsbXA4Q4msseO0cVq
	cAQsZlw==
X-Received: from pfbmb8.prod.google.com ([2002:a05:6a00:7608:b0:82f:60a5:8a3d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:18aa:b0:82c:eb46:acb9
 with SMTP id d2e1a72fcca58-82f8c961f8amr240636b3a.24.1776381831072; Thu, 16
 Apr 2026 16:23:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Apr 2026 16:23:29 -0700
In-Reply-To: <20260416232329.3408497-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260416232329.3408497-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.rc1.513.gad8abe7a5a-goog
Message-ID: <20260416232329.3408497-8-seanjc@google.com>
Subject: [PATCH v3 7/7] KVM: selftests: Teach sev_*_test about revoking VM types
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Tycho Andersen <tycho@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Tycho Andersen <tycho@kernel.org>

Instead of using CPUID, use the VM type bit to determine support, since
those now reflect the correct status of support by the kernel and firmware
configurations.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/sev_init2_tests.c  | 14 ++++++--------
 .../testing/selftests/kvm/x86/sev_migrate_tests.c  |  2 +-
 tools/testing/selftests/kvm/x86/sev_smoke_test.c   |  4 ++--
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/sev_init2_tests.c b/tools/testing/selftests/kvm/x86/sev_init2_tests.c
index b238615196ad..97bd036b4f1c 100644
--- a/tools/testing/selftests/kvm/x86/sev_init2_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_init2_tests.c
@@ -136,16 +136,14 @@ int main(int argc, char *argv[])
 		    kvm_check_cap(KVM_CAP_VM_TYPES), 1 << KVM_X86_SEV_VM);
 
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_VM));
-	have_sev_es = kvm_cpu_has(X86_FEATURE_SEV_ES);
+	have_sev_es = kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_ES_VM);
 
-	TEST_ASSERT(have_sev_es == !!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_ES_VM)),
-		    "sev-es: KVM_CAP_VM_TYPES (%x) does not match cpuid (checking %x)",
-		    kvm_check_cap(KVM_CAP_VM_TYPES), 1 << KVM_X86_SEV_ES_VM);
+	TEST_ASSERT(!have_sev_es || kvm_cpu_has(X86_FEATURE_SEV_ES),
+		    "sev-es: SEV_ES_VM supported without SEV_ES in CPUID");
 
-	have_snp = kvm_cpu_has(X86_FEATURE_SEV_SNP);
-	TEST_ASSERT(have_snp == !!(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SNP_VM)),
-		    "sev-snp: KVM_CAP_VM_TYPES (%x) indicates SNP support (bit %d), but CPUID does not",
-		    kvm_check_cap(KVM_CAP_VM_TYPES), KVM_X86_SNP_VM);
+	have_snp = kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SNP_VM);
+	TEST_ASSERT(!have_snp || kvm_cpu_has(X86_FEATURE_SEV_SNP),
+		    "sev-snp: SNP_VM supported without SEV_SNP in CPUID");
 
 	test_vm_types();
 
diff --git a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
index 6b0928e69051..42bc023d5193 100644
--- a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
@@ -374,7 +374,7 @@ int main(int argc, char *argv[])
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
 
-	have_sev_es = kvm_cpu_has(X86_FEATURE_SEV_ES);
+	have_sev_es = kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_ES_VM);
 
 	if (kvm_has_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM)) {
 		test_sev_migrate_from(/* es= */ false);
diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index 8bd37a476f15..f3c39335ff39 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -249,10 +249,10 @@ int main(int argc, char *argv[])
 
 	test_sev_smoke(guest_sev_code, KVM_X86_SEV_VM, 0);
 
-	if (kvm_cpu_has(X86_FEATURE_SEV_ES))
+	if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SEV_ES_VM))
 		test_sev_smoke(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
 
-	if (kvm_cpu_has(X86_FEATURE_SEV_SNP))
+	if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SNP_VM))
 		test_sev_smoke(guest_snp_code, KVM_X86_SNP_VM, snp_default_policy());
 
 	return 0;
-- 
2.54.0.rc1.513.gad8abe7a5a-goog

