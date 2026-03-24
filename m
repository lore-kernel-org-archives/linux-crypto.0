Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F892318EF4;
	Tue, 24 Mar 2026 19:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774381330; cv=none; b=ceu+bE7G6Pu+iGextSthh0WlSfsDT8Wu2AjxCK74lvOrsUxJ42wI3J1N18Er82Tn1gQQSqOCusBIOEYZeBu1mKqWOUnJs7+OfG8pYVtvIpq0xU4fwySOYD51f+uAQtGTFDg+E/g7vXsMyqYItEkwmC7SLJ0Ju8Kv8QMJ2Aoruhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774381330; c=relaxed/simple;
	bh=aGw//K9x2xoCMLobIBr5Yc9BK3PcrQ5aUsk1vfFDBHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWXwdsWggxAoQ9rNoIhFFiUonsWlNqqIQDTYEYMJ5i6vp2vigzZhkcxOQbQhZTKjUI0kAYGnWo1mWSRu3eC+POo/S8DLXikQcS+wx7x39gi9/FihGlBHK8e4uGRajxb9Pt9WPeyr5DAsylVvY0yWqU0oCv1MMXKAm5GjfvTr1/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Em76d80s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Em76d80s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A1CC2BCB6;
	Tue, 24 Mar 2026 19:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774381330;
	bh=aGw//K9x2xoCMLobIBr5Yc9BK3PcrQ5aUsk1vfFDBHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Em76d80s2RhXJUhAqehyLEWOAxQsjLqrKCu3wUn5oTcSqdgPmAKYOu49ymTstVlh2
	 8mTrfDQu49119jN+qq3HkyT/1eJZ3tQD9ZY/fU3vvo3rWuJX3i1aSzfWuunBI9Xvpz
	 Zng/smzZbo4aR1Tbs7MfXR8AGwOYiv2D/ElT2A/0pKkAPvgijo87930KZfdN3pC3Mj
	 mePoyeSKMQ8QtWg3nIK7IrJxOCgok2hFjhfh9+x/gFMC0m/IuMo/LgA5YDnbHb8viG
	 TiIVRw1/tyJkzNFGfPDiTryu8cpNGHZDpD0l93/S76HXptmLNfY/S0sGrUSAcsjvIF
	 mZZFTlC628Vvg==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kim Phillips <kim.phillips@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Nikunj A Dadhania <nikunj@amd.com>,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 5/5] KVM: selftests: teach sev_*_test about revoking VM types
Date: Tue, 24 Mar 2026 13:40:34 -0600
Message-ID: <20260324194034.1442133-6-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260324194034.1442133-1-tycho@kernel.org>
References: <20260324194034.1442133-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Instead of using CPUID, use the VM type bit to determine support, since
those now reflect the correct status of support by the kernel and firmware
configurations.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
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
index 0a6dfba3905b..3f2c3b00e3bc 100644
--- a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
@@ -376,7 +376,7 @@ int main(int argc, char *argv[])
 
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
2.53.0

