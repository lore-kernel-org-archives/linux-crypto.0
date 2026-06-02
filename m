Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18D63AD50E
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jun 2026 22:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439816; cv=none; b=D85EmcL/rn1tO2t10HuuLAOpmDyve5/xJxLTOMOYLQloDiXCSIgwKqLMsbeT7cQxRCu4i7RfN1PyeiN91sRn0efWehzelWaonIqS8y275XkXSkTvTE4AmyfdcHjsLW54xsaqCYT+982euGDdaAejD3wye/VMBHLS+dbfZLF+yZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439816; c=relaxed/simple;
	bh=hJHj9af2b4aGE8hdvzxfH1HNHgYHgZ+5YN6mW3BKutM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Kb9wJVJoxT+2vS/TBSi4W6Pmd7OAo+R17TvaYzN2bM57QQ+0N3YWGBQ0GN+mVqCJL+a/wEInLQmcKDlpPz4uFJS21VNl4SstAsS2AxwRtmNaFAcH7SEXWb/utoAiF9mOxYKT9B8UgDUwB1EcHUf/NZBEQCkFuH1bir10051XoJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SoyRONPK; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SoyRONPK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780439812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qwUuu9T1lQ6cMXR7h0uQbhUHWqF4ALjjRwoKhkOobCI=;
	b=SoyRONPKp4Ug4mCFZHWRI62iAUsegWvVxtlzNu8Iv1nqJ5WrOm3merrIDlJo9ie/xt+VMy
	KpiFMb0f65wJFnw1va/ETFuvcxziFT2PU583U/gVnwJzj/rnbAMstfh78K7/W19qRMwMXC
	aIonyrqntDDY2OxVaSUyU7/CXvuZEQ8=
From: Atish Patra <atish.patra@linux.dev>
Date: Tue, 02 Jun 2026 15:36:33 -0700
Subject: [PATCH v3 2/4] KVM: selftests: Verify SNP VMs are rejected from
 migration and mirroring
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260602-sev_snp_fixes-v3-2-24bfd3ae047c@meta.com>
References: <20260602-sev_snp_fixes-v3-0-24bfd3ae047c@meta.com>
In-Reply-To: <20260602-sev_snp_fixes-v3-0-24bfd3ae047c@meta.com>
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
 Peter Gonda <pgonda@google.com>, Brijesh Singh <brijesh.singh@amd.com>, 
 Youngjae Lee <youngjaelee@meta.com>, Ashish Kalra <ashish.kalra@amd.com>, 
 Michael Roth <michael.roth@amd.com>, John Allen <john.allen@amd.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: clm@meta.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, stable@vger.kernel.org, 
 Atish Patra <atishp@meta.com>
X-Migadu-Flow: FLOW_OUT

From: Atish Patra <atishp@meta.com>

Migration and mirroring of SEV-SNP VMs are not supported yet.

Add two selftests that verify KVM rejects intra-host migration and
mirroring when the source VM is an SNP VM, so the restriction stays enforced
until proper SNP state transfer is implemented.

Signed-off-by: Atish Patra <atishp@meta.com>
---
 .../testing/selftests/kvm/x86/sev_migrate_tests.c  | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
index 6b0928e69051..acef6ab26d3d 100644
--- a/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86/sev_migrate_tests.c
@@ -313,6 +313,49 @@ static void test_sev_mirror_parameters(void)
 	kvm_vm_free(vm_no_vcpu);
 }
 
+static void test_sev_snp_migrate_reject(void)
+{
+	struct kvm_vm *src_vm, *dst_vm;
+	int ret;
+
+	src_vm = vm_create_barebones_type(KVM_X86_SNP_VM);
+	snp_vm_init(src_vm);
+	__vm_vcpu_add(src_vm, 0);
+	vm_sev_launch(src_vm, snp_default_policy(), NULL);
+
+	dst_vm = vm_create_barebones_type(KVM_X86_SNP_VM);
+	__vm_vcpu_add(dst_vm, 0);
+
+	ret = __sev_migrate_from(dst_vm, src_vm);
+	TEST_ASSERT(ret == -1 && errno == EINVAL,
+		    "SNP VM migration should be rejected. ret: %d, errno: %d",
+		    ret, errno);
+
+	kvm_vm_free(src_vm);
+	kvm_vm_free(dst_vm);
+}
+
+static void test_sev_snp_mirror_reject(void)
+{
+	struct kvm_vm *src_vm, *dst_vm;
+	int ret;
+
+	src_vm = vm_create_barebones_type(KVM_X86_SNP_VM);
+	snp_vm_init(src_vm);
+	__vm_vcpu_add(src_vm, 0);
+	vm_sev_launch(src_vm, snp_default_policy(), NULL);
+
+	dst_vm = aux_vm_create(false);
+
+	ret = __sev_mirror_create(dst_vm, src_vm);
+	TEST_ASSERT(ret == -1 && errno == EINVAL,
+		    "SNP VM mirroring should be rejected. ret: %d, errno: %d",
+		    ret, errno);
+
+	kvm_vm_free(src_vm);
+	kvm_vm_free(dst_vm);
+}
+
 static void test_sev_move_copy(void)
 {
 	struct kvm_vm *dst_vm, *dst2_vm, *dst3_vm, *sev_vm, *mirror_vm,
@@ -384,12 +427,16 @@ int main(int argc, char *argv[])
 		test_sev_migrate_parameters();
 		if (kvm_has_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM))
 			test_sev_move_copy();
+		if (kvm_cpu_has(X86_FEATURE_SEV_SNP))
+			test_sev_snp_migrate_reject();
 	}
 	if (kvm_has_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM)) {
 		test_sev_mirror(/* es= */ false);
 		if (have_sev_es)
 			test_sev_mirror(/* es= */ true);
 		test_sev_mirror_parameters();
+		if (kvm_cpu_has(X86_FEATURE_SEV_SNP))
+			test_sev_snp_mirror_reject();
 	}
 	return 0;
 }

-- 
2.53.0-Meta

