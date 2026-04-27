Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616C038E100;
	Mon, 27 Apr 2026 20:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777323051; cv=none; b=sug3wAAvnxLp8hdQfGonAet8u15Faov4TB0Yn6a4tJjWMe/DP/39+V/60cyxf42kVPFGq6gYzIhxVCQty9r2Shso1EjGpaubZS1R4tjgfBImCbhNvvBOp3jvmLhhRuU6kXRpeJnbG1llixuPiIABVMBiLvIbSU4Kh1z0DRGpU7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777323051; c=relaxed/simple;
	bh=esH8GoW/x0f4F3LQ0BiNpL6uFiMcPBcjR+T948qhS/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMcRfUSLAcWpkYGKc2CFgE/oKnONJ+QcDpT6OYjD4Gsa8wBRhlsm4TLRx2gSmu2ojcYm+kasv2csC2u7LruQYeMXfgC+w90eNP1m7B89xEI0PMxtCqjdrIlZAV0VqWEVfgolNQGjHUxHSZAefgsqt8ZMRHFW6d8RLtgjA6VuafM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zif4KKi0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zif4KKi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A24CC19425;
	Mon, 27 Apr 2026 20:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777323049;
	bh=esH8GoW/x0f4F3LQ0BiNpL6uFiMcPBcjR+T948qhS/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zif4KKi0l2HAdsKn4T3m4qINJILeE3GEdBTZPHgxd+050ZSlrwrTNVGRC6F0fkCEu
	 3Sk3kszX5JQbISumyKPCHQjHjAR2CnjAaE+iTyQjAaf7ObJoayDIunEBNVZsDafVcb
	 vNOjpgPCAxReOOT49cOi0ZHr07WcmTx8YoHsbYczlbAsnX5zjAYuUGnYt4DZvkHAUv
	 PpWWFCgLnsFTW3yPcHrvMdn2in4t6vaeuwRi6B8Qgo4pu0nTBUjXGe/Q49bL2Tk4uJ
	 L2l6HKd3yZF53lBTiSaprOJ2/tYITX7BE7UR3PlmOT1eMJZ2ou8vRV8ltEifpobpRd
	 ONC75s7s2vGLg==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
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
	Andrew Morton <akpm@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 4/4] KVM: selftests: Add a smoke test support for RAPL_DIS
Date: Mon, 27 Apr 2026 14:48:47 -0600
Message-ID: <20260427204847.112899-5-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260427204847.112899-1-tycho@kernel.org>
References: <20260427204847.112899-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

If the hardware supports the RAPL_DIS policy bit and the ccp has been
loaded with the RAPL_DIS bit set, make sure a VM can
actually start using it.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 tools/testing/selftests/kvm/include/x86/sev.h |  1 +
 .../selftests/kvm/x86/sev_smoke_test.c        | 24 ++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86/sev.h b/tools/testing/selftests/kvm/include/x86/sev.h
index 1af44c151d60..2bbac9cd192a 100644
--- a/tools/testing/selftests/kvm/include/x86/sev.h
+++ b/tools/testing/selftests/kvm/include/x86/sev.h
@@ -28,6 +28,7 @@ enum sev_guest_state {
 #define SNP_POLICY_SMT		(1ULL << 16)
 #define SNP_POLICY_RSVD_MBO	(1ULL << 17)
 #define SNP_POLICY_DBG		(1ULL << 19)
+#define SNP_POLICY_RAPL_DIS	(1ULL << 23)
 
 #define GHCB_MSR_TERM_REQ	0x100
 
diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index 1a49ee391586..15c848749de6 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -243,6 +243,18 @@ static void test_sev_smoke(void *guest, u32 type, u64 policy)
 	}
 }
 
+static u64 supported_policy_mask(void)
+{
+	int kvm_fd = open_kvm_dev_path_or_exit();
+	u64 policy_mask = 0;
+
+	kvm_device_attr_get(kvm_fd, KVM_X86_GRP_SEV,
+			    KVM_X86_SNP_POLICY_BITS,
+			    &policy_mask);
+	close(kvm_fd);
+	return policy_mask;
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
@@ -252,8 +264,18 @@ int main(int argc, char *argv[])
 	if (kvm_cpu_has(X86_FEATURE_SEV_ES))
 		test_sev_smoke(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
 
-	if (kvm_cpu_has(X86_FEATURE_SEV_SNP))
+	if (kvm_cpu_has(X86_FEATURE_SEV_SNP)) {
+		u64 supported_policy = supported_policy_mask();
+
 		test_sev_smoke(guest_snp_code, KVM_X86_SNP_VM, snp_default_policy());
 
+		if (supported_policy & SNP_POLICY_RAPL_DIS &&
+		    kvm_get_module_param_bool("kvm_amd", "rapl_disable")) {
+			u64 policy = snp_default_policy() | SNP_POLICY_RAPL_DIS;
+
+			test_sev_smoke(guest_snp_code, KVM_X86_SNP_VM, policy);
+		}
+	}
+
 	return 0;
 }
-- 
2.53.0

