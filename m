Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B962361DDC
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 23:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780009925; cv=none; b=OfjIsxRHvOf67drS64TkorEndTD56e3ueVl91N8kGOhZv+/RWL8wMrWM7gQSE0uiMhzoxX29PIhe5KHP3LMXBRcTWzbTGmRyTUzgHllcLUFiibQ0QEP+6I2glI6k7GZzL7lAU0jDjVipR8JWVCDCfadmjVa5c7EGdVHRg/fCYxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780009925; c=relaxed/simple;
	bh=0SRtLywbtSurzeqEFPiQwtA3Ef8TPShnXFjpjQsg7GY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WDrIuBAyR4TCB7PvYN/qnDWocXdAz6xhSmf9cQ+WFurt7Bb3mu+myBB5vpqnVwO5577T5GN5ptk6VLxof+0hAZW+z6kakaigYQt2d8dBe7jlRAAu0jduYTKaoMxoUgaU+3s4VNWpAzmP+b/t8Vaf8+EOebdApIGzJp/M1ICPw6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I6nQSKE/; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I6nQSKE/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780009921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r1750RrUr2OSKFkOGW1fGK+AkRlnCbVk2rTP6i3DUa0=;
	b=I6nQSKE/nhSSsap75tS7Ny4/d1LzbZQE4GXX3Tbdjctlphwrq0/BUk2ZiKi58y/+HUghgN
	vxjfKN/0W7noMmIUF8sSMDDU3BgcYnP4JWzYViZvUPb18AFI+z9qK+PqKqBjkttMgXFKml
	BsoQwhYHUvVF3m95+3/NAhECNOE7MsI=
From: Atish Patra <atish.patra@linux.dev>
Date: Thu, 28 May 2026 16:11:38 -0700
Subject: [PATCH 1/2] KVM: SEV: Do not allow SEV-SNP VMs from intra-host
 migration
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-sev_snp_fixes-v1-1-d67a08151779@meta.com>
References: <20260528-sev_snp_fixes-v1-0-d67a08151779@meta.com>
In-Reply-To: <20260528-sev_snp_fixes-v1-0-d67a08151779@meta.com>
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
 Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>, 
 Brijesh Singh <brijesh.singh@amd.com>, Youngjae Lee <youngjaelee@meta.com>, 
 Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: clm@meta.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, stable@vger.kernel.org, 
 Atish Patra <atishp@meta.com>
X-Migadu-Flow: FLOW_OUT

From: Atish Patra <atishp@meta.com>

The intra-host migration feature is not fully implemented for SEV-SNP
VMs which require additional SNP-specific state such as guest_req_mutex,
guest_req_buf, and guest_resp_buf to be transferred or initialized on
the destination.

Reject SNP source VMs in sev_vm_move_enc_context_from() until proper
SNP state transfer is implemented.

Fixes: 0b020f5af092 ("KVM: SEV: Add support for SEV-ES intra host migration")

Reported-by: Chris Mason <clm@meta.com>
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Atish Patra <atishp@meta.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c2126b3c3072..aff6a0cf5bfe 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2142,7 +2142,8 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 		return ret;
 
 	if (kvm->arch.vm_type != source_kvm->arch.vm_type ||
-	    sev_guest(kvm) || !sev_guest(source_kvm)) {
+	    sev_guest(kvm) || !sev_guest(source_kvm) ||
+	    sev_snp_guest(source_kvm)) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}

-- 
2.53.0-Meta

