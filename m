Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E799D318EE4;
	Mon, 23 Feb 2026 16:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771864283; cv=none; b=dZLSfD0EDgcOUsgfx1lUeXOV1PExVgKY80qJCC7zIwiPCuOr6pDP/yLzWYUDzOXoUROPk0SSae19RGhuJmWKcLfoM+XdXQvSncqoEVHnokXE5hsEURD+j7vPMRnesIDyXOmLc4QzKpXWDDBX06Vy4mqYioPD98L1wB//xJGpjeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771864283; c=relaxed/simple;
	bh=j1r3jSLPXenJHWtPXhz5B7SgywI7mhO4sMwe7uArPqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4qn6yFgwdDKf9JegTefXylKobqtuNC/MVpf6UY0MdpnhxJbbJFCcfaRL8Q9avDlG7lcDoRdcx9aeRtfzezfO/kWuLg9r5o103qKP6/bLTmVW+ecTyPz8HTz3Pn6rEu5ebqtEpK5MIhsqf2sUo8noX4YaUjCXJ8+bJV8NPKGWUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=otBREyNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otBREyNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586E3C116C6;
	Mon, 23 Feb 2026 16:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771864282;
	bh=j1r3jSLPXenJHWtPXhz5B7SgywI7mhO4sMwe7uArPqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otBREyNnNk8AW78n036fGfwS99ZdT9JlzE5JAsSaMyKPog0DePiD6RiRSFHPoV/pk
	 YJKt9fsRWqzJZMDXCj3ughu8qlPw9TFsw61ZxyxF0CO5b1LDQTNiR8VcwS2M3FSl8L
	 zbPbauzaTHhOG1mJRfI0mW1eXZbHHcuo+MYccSqbKMplakC1Ehmk/lawsRyL+dLSAX
	 kK2dNGjKQhuMNDT8B0h0C3n76yIDegAIKG9gDcKXW78TQiGrIz+NhkzamqDnjkVz1K
	 0hesc+vGPtelDsV+UTFmAW/ymbBHMXNuoSUlOoEWkB6t2H+VXX/HbIa/VIL6HwRlln
	 NXgjBCsvKstHw==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 2/4] selftests/kvm: check that SEV-ES VMs are allowed in SEV-SNP mode
Date: Mon, 23 Feb 2026 09:28:58 -0700
Message-ID: <20260223162900.772669-3-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260223162900.772669-1-tycho@kernel.org>
References: <20260223162900.772669-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

As in the comment, check to make sure that SEV-ES VMs are allowed before
running the test. Otherwise, there is a generic:

    ==== Test Assertion Failure ====
      lib/x86/sev.c:91: !ret
      pid=3678 tid=3678 errno=5 - Input/output error
         1	0x0000000000417000: sev_vm_launch at sev.c:91 (discriminator 4)
         2	0x0000000000417d49: vm_sev_launch at sev.c:191
         3	0x0000000000402a7d: test_sev at sev_smoke_test.c:132
         4	0x000000000040328f: test_sev_smoke at sev_smoke_test.c:198
         5	0x00000000004026c8: main at sev_smoke_test.c:223
         6	0x00007fdde5c2a1c9: ?? ??:0
         7	0x00007fdde5c2a28a: ?? ??:0
         8	0x00000000004027f4: _start at ??:?
      KVM_SEV_LAUNCH_START failed, rc: -1 errno: 5 (Input/output error)

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 .../selftests/kvm/x86/sev_smoke_test.c        | 37 ++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index 86ad1c7d068f..c7fda9fc324b 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -213,13 +213,48 @@ static void test_sev_smoke(void *guest, uint32_t type, uint64_t policy)
 	}
 }
 
+static bool sev_es_allowed(void)
+{
+	struct kvm_sev_launch_start launch_start = {
+		.policy = SEV_POLICY_ES,
+	};
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int firmware_error, ret;
+	bool supported = true;
+
+	if (!kvm_cpu_has(X86_FEATURE_SEV_ES))
+		return false;
+
+	if (!kvm_cpu_has(X86_FEATURE_SEV_SNP))
+		return true;
+
+	/*
+	 * In some cases when SEV-SNP is enabled, firmware disallows starting
+	 * an SEV-ES VM. When SEV-SNP is enabled try to launch an SEV-ES, and
+	 * check the underlying firmware error for this case.
+	 */
+	vm = vm_sev_create_with_one_vcpu(KVM_X86_SEV_ES_VM, guest_sev_es_code,
+					 &vcpu);
+
+	ret = __vm_sev_ioctl(vm, KVM_SEV_LAUNCH_START, &launch_start,
+			     &firmware_error);
+	if (ret == -1 && firmware_error == SEV_RET_UNSUPPORTED) {
+		pr_info("SEV-ES not supported with SNP\n");
+		supported = false;
+	}
+
+	kvm_vm_free(vm);
+	return supported;
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));
 
 	test_sev_smoke(guest_sev_code, KVM_X86_SEV_VM, 0);
 
-	if (kvm_cpu_has(X86_FEATURE_SEV_ES))
+	if (sev_es_allowed())
 		test_sev_smoke(guest_sev_es_code, KVM_X86_SEV_ES_VM, SEV_POLICY_ES);
 
 	if (kvm_cpu_has(X86_FEATURE_SEV_SNP))
-- 
2.53.0

