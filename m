Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668AE346784;
	Tue, 24 Mar 2026 19:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774381325; cv=none; b=EvvOSf1NHSZC/m9wu6cVVTU+h9YP6N7WAIDYYjawG3N23UYNp4AytEWwbdwvKemltEgYUwZSyY4azv/Rj85W4pC+JbD7aI2bNCL8Cu9GdOOgfJkepju1IIHiGqEPdsvSPtCtWymLcbJeMV4nUzZyYbB/coLGY5uBf0cv3lw4wXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774381325; c=relaxed/simple;
	bh=kzgfzvHh+9A5FdZ6vIUzenAJ6yzpP4p/WINlc2zceaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oe+bWRBWXaCNMRuwopj7b+giKdvemhZHej74pYbZHFgr4fi4phgJIDI5Gkv6Byv1cwEsDwEPq+J3AtlTCM5um04gcFdUoZtuJB6k9KZoueCJaJu+79sqNhl8b0X6nAjHNZCLWPf1LbBTDoLbfAmG+AD4TU6lpo4oxf3xiT4Qp7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7hIS6bN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7hIS6bN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD78C4AF0B;
	Tue, 24 Mar 2026 19:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774381325;
	bh=kzgfzvHh+9A5FdZ6vIUzenAJ6yzpP4p/WINlc2zceaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7hIS6bNAPjLQGsy/ETROyZ+6UbmaXwCor2Nj9zj7jxrf2jqw4La6J4irt9CsLth2
	 HxUMxeqrHsuT2QyP0yzTaViTIJdmrUfrjjcRDlfyXfiDd28CHDnzF0VQ267XFtF+xp
	 fKsPax++nSxCeg56dfuoye7A5RpYKgKxX46jknQUqkPg0bKLKm2U/9oxNPep1U8ML7
	 LX1f610arSJrl7npBJ7CNFT7D/dRvGEXNkxh/T7iCc/eljt/xHrEacOuil3gFeSApO
	 fmPVspoRXE45TjoNLPe2sLOgur3pWPZjtVe3jy7z1Nocd5saa0A1Pq1A3iCO+YLM3U
	 k2hr2koQjYxhA==
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
Subject: [PATCH v2 3/5] KVM: SEV: don't expose unusable VM types
Date: Tue, 24 Mar 2026 13:40:32 -0600
Message-ID: <20260324194034.1442133-4-tycho@kernel.org>
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
---
 arch/x86/kvm/svm/sev.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3f9c1aa39a0a..37490803f2e8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2957,18 +2957,26 @@ void sev_vm_destroy(struct kvm *kvm)
 
 void __init sev_set_cpu_caps(void)
 {
+	u32 supported_vm_types = 0;
+
 	if (sev_enabled) {
 		kvm_cpu_cap_set(X86_FEATURE_SEV);
-		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_VM);
+
+		if (min_sev_asid <= max_sev_asid)
+			supported_vm_types |= BIT(KVM_X86_SEV_VM);
 	}
 	if (sev_es_enabled) {
 		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
-		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
+
+		if (min_sev_es_asid <= max_sev_es_asid)
+			supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
 	}
 	if (sev_snp_enabled) {
 		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
-		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
+		supported_vm_types |= BIT(KVM_X86_SNP_VM);
 	}
+
+	kvm_caps.supported_vm_types |= supported_vm_types;
 }
 
 static bool is_sev_snp_initialized(void)
-- 
2.53.0

