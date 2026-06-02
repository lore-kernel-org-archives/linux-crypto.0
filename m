Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F72436657B
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jun 2026 22:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439809; cv=none; b=dA+X7F8ONL1cfD2XyQMz5HG61lOGMjCd+iPqhpL4KyEU08O2wLNAKg517JdLldw3mSJuQ8U+Ql6VajZE4Q8mzP9ueHYwF1NB4cXZS9Lkrl4AdFYb/0d02zBzToVq+XweLZh9MUiZxN0BAXdnNxzU7I6d60AG6zTFfjddire+CJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439809; c=relaxed/simple;
	bh=urESQJEzugHb1URckCLzAK6tTchZl5F7MkXkyCmt6GQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=HM7RmnREQt51u/xNSXZ6eWLkjhOJjtvxkNyj2p4/rMkrSDLdervh1RoE2qh3nx71nRrMJIB4uAbXqpIlpMHAD2luDGABmAXVSxZOc1obeXld8oPcml5Cy0ZXVk8mMaoIw2JcQCB2UYxlfqECvjo505rVDJU/Dko0V6kzFMlsRAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=URx3qGJ1; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="URx3qGJ1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780439804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DXwo4i9Kx+guFPQ/MiUMcJ80u+YI2AYi7oCtxG+RLHM=;
	b=URx3qGJ1hCz5S0rxT20jA1uzsXBENZPYaKDo7t9lrflb+HambGro9A+5I64SRAd6aB7Aex
	yLsJ/MdSDok7ZEdCLCkzRCypvcEsiVsWtWG5O9ZrpEkqe0zA18kLuDLaNFvloB0vHFR6Mt
	xW1tsODevEaYIcpxqwg1ChtmGqQoWJw=
From: Atish Patra <atish.patra@linux.dev>
Subject: [PATCH v3 0/4] KVM: Miscellaneous SEV/SNP related fixes
Date: Tue, 02 Jun 2026 15:36:31 -0700
Message-Id: <20260602-sev_snp_fixes-v3-0-24bfd3ae047c@meta.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAO9aH2oC/13MywqDMBCF4VeRrJuSieTWVd+jFIk6rVl4ISOhR
 Xz3RqG0uDwzfP/CCGNAYpdiYRFToDAOeZSngjWdH57IQ5s3k0JqoaTihKmiYaoe4YXERW1KY10
 D3gHLZoq4PzK53fPuAs1jfO/5BNv1W7KHUgIueKuNFxYUGOOuPc7+3Iw920JJ/rAWcMQyYw1gH
 dTSeqv/8LquH3ZEK7fmAAAA
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
 Atish Patra <atishp@meta.com>, Sashiko <sashiko-bot@kernel.org>
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
Changes in v3:
- Added comments, fixed commit messages and fixes tag as per discussions on v2. 
- sev_init_ex_buffer initialized with zero at allocation to prevent any kernel
  data leak in case of init_ex_file is not present. Reported by Sashiko
- Link to v2: https://lore.kernel.org/r/20260601-sev_snp_fixes-v2-0-611891b28a86@meta.com

Changes in v2:
- Added fixes based on the reports by Sashiko. 
- Added a kselftest for validating SNP VM mirroring/migration rejection. 
- Link to v1: https://lore.kernel.org/r/20260528-sev_snp_fixes-v1-0-d67a08151779@meta.com

---
Atish Patra (4):
      KVM: SEV: Do not allow intra-host migration/mirroring of SNP VMs
      KVM: selftests: Verify SNP VMs are rejected from migration and mirroring
      crypto: ccp: Fix possible deadlock in SEV init failure path
      crypto: ccp: Fix memory leak in SEV INIT_EX path

 arch/x86/kvm/svm/sev.c                             |  6 ++-
 drivers/crypto/ccp/sev-dev.c                       | 19 +++++++--
 .../testing/selftests/kvm/x86/sev_migrate_tests.c  | 47 ++++++++++++++++++++++
 3 files changed, 67 insertions(+), 5 deletions(-)
---
base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
change-id: 20260525-sev_snp_fixes-0b73789c1a91

Best regards,
-- 
Atish Patra <atishp@meta.com>

