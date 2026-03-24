Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991BB314D06;
	Tue, 24 Mar 2026 19:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774381327; cv=none; b=MSYrTOIN0yI7v3IiGeGS8MN4qmWOW27PdR+/axCoPMRe2ciNa5ZgeFyGNPC+myj6ISinopQQiFKSnQNaIUV2gzHXm5ZnliTT5B/nYaHB9pAVFxgaqJSynt2LMbfNktEBEv3oAsyNpJXDIrVagPNiqxHMHyZeUuOJOpCZgSdGEoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774381327; c=relaxed/simple;
	bh=QV7DEFMMm2/evrynUJH6jPfaDQuuOY7hg6GbMEoafZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aj+gvLfe4SiyDoITIflNYPBqICa2EKOoGVLecUA/h7xmUTQZ+r2tQQUrUJv0AOVuSVYZBDbBdJ3quXc5/q/z55yvv6hgu22HfUWGM8C9Brk0mkkI00zxjjr9hOivKLD2EFzJ4ViJvWrRz4pigRv15yrdjfnLGmJK+d+9HJ2OC74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WfZa7qBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WfZa7qBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450AAC2BC9E;
	Tue, 24 Mar 2026 19:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774381327;
	bh=QV7DEFMMm2/evrynUJH6jPfaDQuuOY7hg6GbMEoafZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfZa7qBpeZZCPtJVheGFG5kyQj5vHF2KDFbQ4kesoPI6WAQ+38tUX/K7yc0J9O5bq
	 BCihssjDE4SUl1EaR4NYSqn/+WMKZ+0cNHnPVEhBN4WzFPPHAc3Kyw36TZTP4y4NfY
	 IL7x7JKNUiu1dhsKgjgf11hSJyvVUBOEi0rDweAQgOOKQKF0oSvM8qtm30oR6AFa32
	 sBnOwPqFP7PobS0xeI4yZWs5SNich0Mc/uUoH9ht+ygq7uXJynOFBnWK4OLnzox66d
	 hb7A9drCo37A5QV/CNKAZ+reC/0UORKShIsEoh/dx/uRGmUxRYf41eJ3xOhVajYik5
	 0YIzrBBqLXeGA==
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
Subject: [PATCH v2 4/5] KVM: SEV: mask off firmware unsupported vm types
Date: Tue, 24 Mar 2026 13:40:33 -0600
Message-ID: <20260324194034.1442133-5-tycho@kernel.org>
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

In some configurations not all VM types are supported by the firmware.
Reflect this information in the supported_vm_types that KVM exports.

Link: https://lore.kernel.org/all/aZyLIWtffvEnmtYh@google.com/
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 37490803f2e8..0fe9515db1e7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2976,7 +2976,8 @@ void __init sev_set_cpu_caps(void)
 		supported_vm_types |= BIT(KVM_X86_SNP_VM);
 	}
 
-	kvm_caps.supported_vm_types |= supported_vm_types;
+	kvm_caps.supported_vm_types |= (supported_vm_types &
+					sev_firmware_supported_vm_types());
 }
 
 static bool is_sev_snp_initialized(void)
-- 
2.53.0

