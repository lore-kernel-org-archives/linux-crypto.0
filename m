Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AED319857
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 23:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780009923; cv=none; b=l37ID6GKYbxg3WFX/6C7IQPzWF5jW/i1s1uswOZffrGyo51MLUQJHItGV9MKt4/nfAvE2+6Vy7/3ZvOBmuVFumcyuSrAA8kl7AJ/9Pw0qQhvIutOAgntfA6I+oIbyRnZ0KbzRODtwDLyBZKk/QD6bIocKRtO3xvl41g5vj7zaew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780009923; c=relaxed/simple;
	bh=5adojc1go2KwpqMc05wDsZ4zJsAbD9xwCcHX4ApiQpE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=DKIsgo+2SW2qpnu/vFca9DPUtRi+boHxBb+WAR/pHf7ogy/FnI0rq17XuTYVRv8Q+KMAQvaecS4ceb2Vzd7yb1+GJ0dwoI35VHK4xpFoPSHeMIsybKWGHsZUrNGBlwdP8kfTNxejwKAjjD/gUUC6vbKnzGuFOcuPNIuTyIGW8Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iE6K5eni; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iE6K5eni"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780009908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MKHPi9+ltAWfK4xQDeY6Lr/5mupcQ2dHPDNSkERP3Kc=;
	b=iE6K5eniOKNQNutkwjMcx8rMi50fuHOggu4HA7XmDYcTuucmvdd1yweDbzlvIjwfkkSpjI
	cCKYlPQNA8Kla9XvPpO3VGDKLazPv3xQe690vdvPyWzXqyIbaiTGoPbL7vxaYitMGiKi+4
	slRCw9Q3aX7u5pRNw1+XfsFToIYhHFE=
From: Atish Patra <atish.patra@linux.dev>
Subject: [PATCH 0/2] KVM: Miscallenous SEV/SNP fixes
Date: Thu, 28 May 2026 16:11:37 -0700
Message-Id: <20260528-sev_snp_fixes-v1-0-d67a08151779@meta.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKrLGGoC/x3LQQqAIBBA0avIrBPUsLKrRITZVLMxcUCC6O5Jy
 8fnP8CYCRlG8UDGQkxXrNCNgHD6eKCkrRqMMp2yxkrGsnBMy043slRr3/aDC9o7DfVJGf9Ql2l
 +3w+rHfcLXwAAAA==
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

This series addresses a few issues found during code audit of the
KVM SEV/SNP and CCP driver code. The fixes include a incorrect lock state
and incomplete state handling during intra-host migration for SNP VMs.

To: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
To: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: x86@kernel.org
To: H. Peter Anvin <hpa@zytor.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
To: Marc Orr <marcorr@google.com>
To: Peter Gonda <pgonda@google.com>
To: Brijesh Singh <brijesh.singh@amd.com>
To: Youngjae Lee <youngjaelee@meta.com>
To: Ashish Kalra <ashish.kalra@amd.com>
To: Michael Roth <michael.roth@amd.com>
To: John Allen <john.allen@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: clm@meta.com
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: stable@vger.kernel.org

Signed-off-by: Atish Patra <atishp@meta.com>
---
Atish Patra (2):
      KVM: SEV: Do not allow SEV-SNP VMs from intra-host migration
      crypto: ccp: Fix possible deadlock in SEV init failure path

 arch/x86/kvm/svm/sev.c       | 3 ++-
 drivers/crypto/ccp/sev-dev.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)
---
base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
change-id: 20260525-sev_snp_fixes-0b73789c1a91

Best regards,
-- 
Atish Patra <atishp@meta.com>

