Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2501344DBD
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jun 2026 23:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780355097; cv=none; b=bayW6pxNUf8cI2921ETEuG1RYoEWc5foJwPgIyImTX7QoY8GpgCv7ErsMyqrRj8e7YzWiOsxLwJzCI/T2/J5b+gna5ju+hR6+8EuZB/FRRhLUdgF0dul3r9KVxYn93EAfCCytXwfxXQdQAp9ZGZayCwGxdBLiMS54Htj9AHEF1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780355097; c=relaxed/simple;
	bh=LlFLtsINCgccXSPn4jWjE8uZpKLYLfsXdGiD4JrYBSw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=LMHMiTDqY2e4Eu2DJcBqy+uNO5Z2wuz/l8tLDRjQg4uFt1NheU4qdpL6AzGwwpXCx+BIPI+ZEX6YauKLuq0ana8IocMurVnxQNoxW+iNRay8Qf4tEHBPBnQhsXSf0gBKm5innFRrgJ2YdbNh6tizVJoCcEzzwQedbdTthGoXGHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JTbu5ChD; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JTbu5ChD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780355084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fdOT1ubVljYo/8E3or6+JlpXdVVi9C39SjL7RbBhzUU=;
	b=JTbu5ChDEHc1Ha+ecWVBaCQpQlPo6d0ncrPhDvDiiXrtr5NBgcqPOaEBsW4ou+bVDM/o81
	bOhieV2T8oBQKGrIbyLFN9v4junbavukpB7NAUr6aMw6FDzTpqRWoQFrBRum9QT9uRCov6
	BC0B4tUGzrszlpR/aequhJjE5YNFbpM=
From: Atish Patra <atish.patra@linux.dev>
Subject: [PATCH v2 0/4] KVM: Miscellaneous SEV/SNP related fixes
Date: Mon, 01 Jun 2026 16:04:34 -0700
Message-Id: <20260601-sev_snp_fixes-v2-0-611891b28a86@meta.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAMQHmoC/12MwQ7CIBAFf6XZsxjAUMBT/8M0DdLVciht2IZoG
 v5dbOLF47yXmR0IU0CCa7NDwhwoLLGCPDXgJxefyMJYGSSXLVdSMcI8UFyHR3ghMX7XF22sF84
 KqM6a8DiqcusrT4G2Jb2PfBbf9Vcyf6UsGGdjqx03QgmtbTfj5s5+maEvpXwAwCvtyakAAAA=
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

 arch/x86/kvm/svm/sev.c                             |  4 +-
 drivers/crypto/ccp/sev-dev.c                       | 18 +++++++--
 .../testing/selftests/kvm/x86/sev_migrate_tests.c  | 47 ++++++++++++++++++++++
 3 files changed, 65 insertions(+), 4 deletions(-)
---
base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
change-id: 20260525-sev_snp_fixes-0b73789c1a91

Best regards,
-- 
Atish Patra <atishp@meta.com>

