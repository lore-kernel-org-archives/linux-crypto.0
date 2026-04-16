Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B03039DBDB
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 23:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776381819; cv=none; b=WfSnjucOJhJHTXA5BqUm/SK3jdl47VXAc4OOF27MOgQxtTPfF4yFr8TvmC+a0heDnpDIlHKC2rsx3G0kV9ZRno5uDZqIKilErjLVECtja2hFnbl9OUDmMRBwpIW3kkifA66v1Ivbl7HBt7w9H2/d+T1daZXxPtmT06iq4XD0bXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776381819; c=relaxed/simple;
	bh=XTF/Ml6zPKPfWMAwzbKlF2sbnfQKo9ci51FH3JVrn/w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WYy2GYnn/bW7UJ3exfG7XCDneSM6jDGGLcvxDvTmUn32uhZVwm99KXPVNnynV4hICMmYLz+mS81uCK1vDam/VFZ6lEcuuEM1XCP8jf6s7GsZw5B7AcjGA/vtIC9afxiQMZpVek74qvq8dxOosZrs4tN8z5p/5HghiHKXvOqtYV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cPMU6WdC; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cPMU6WdC"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82f6b984b3aso54156b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 16:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776381818; x=1776986618; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fcXVDSVlIDOLEOAoYc9j/aTZ1nVJQKX8oOKennXvDpE=;
        b=cPMU6WdCRW33DdZt0pY1lre09BjuRg2Ql0DlVUa+Pp5aC0NitSBmZbImZWTtr2mtZV
         3np5gYA3N3ipCuJbpwiZ9s2Kz1okQi0H/NWx/DQcnvwcZyyiL0Cz6rXi8ICVeY1HDBv/
         m2+eqvBijVV8f9DIq0DjEAtAoZZ4BajXcC9MgV9YqwaBUzvuXdzU6DUuz2CU61dzqwUy
         lHZDP7e7BJFHFkiF+lyaHbAR+/8E09aoae4JfBIoG9+N77mg14lc6HhqwWJ4WxChGCfb
         YhrN5UEuofmi2z8r8/xTxzE+ayg3k+1JKXSGgzq4gysPaAt1BlAHI1llPdoPRkfnZ4RB
         qVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776381818; x=1776986618;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fcXVDSVlIDOLEOAoYc9j/aTZ1nVJQKX8oOKennXvDpE=;
        b=NHHjHFsFCcXwRF+dbiws0HTs3iYOUfGq1ftpoC07S6CA7fcBjgMBJBvoG7SRyFRWpt
         nQ28yBUZTRb+Ya7mMkATsd0jYnHl/g5v9DMNjfvQzS0reIKljCaQX+0naO3wlVFm7MW5
         4E8Nw7uIa9NgSr/o6qUXpTqa3qbhCf7EsFpNF2LUL6OMe8O0yDZskG51gr5FX36J+L5h
         TEGbuYcRmL3mzEDQlb3J7vFB2SySldVYmr3jKvWcUAT9ROzsE+VZguNPmpb3gpg6XutD
         VTefMiGR4Wdu+www1+aSZY3S3JHCDkJ9Wz5le/+K14Xwjd9xYv96R+dbMfYMaOhQVeA/
         lrtA==
X-Forwarded-Encrypted: i=1; AFNElJ95Oa1CDpn7nVma146M7nOviLZPSPBn5Iyn4y05jwHW3E2THmxKA+E+JX20VdajGpFwrXNsE7b18VF2Qo4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoEdhKDkyVUbb2IAEQDI429gqNMbIUkjpe+nX1l273Qd0isLaO
	MXd1p1HnKFTg61NmP3t8Tr6zQ+2Rg37wxcMPhopOaFg+lzVNUw7qxQwdWlfVAJm5SXEqhPTvtB1
	z9qjb7w==
X-Received: from pfbg11.prod.google.com ([2002:a05:6a00:ae0b:b0:82c:989e:71f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2c94:b0:82f:656b:afe8
 with SMTP id d2e1a72fcca58-82f8c86db35mr223189b3a.20.1776381817575; Thu, 16
 Apr 2026 16:23:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Apr 2026 16:23:22 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc1.513.gad8abe7a5a-goog
Message-ID: <20260416232329.3408497-1-seanjc@google.com>
Subject: [PATCH v3 0/7] KVM: SEV: Don't advertise unusable VM types
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	Tycho Andersen <tycho@kernel.org>
Content-Type: text/plain; charset="UTF-8"

My preference would be to take this through the KVM tree, with acks on the
crypto patches.  I'd also be a-ok with a stable branch/tag of the crypto
changes.

In the words of Tycho:

Recent SEV firmware [1] does not support SEV-ES VMs when SNP is enabled.
Expose this by revoking VM-types that are not supported by the current
configurations either from firmware restrictions or ASID configuration.

My previous version of this patch series [2] used SNP_VERIFY_MITIGATION
to test for a mitigation bit. While AMD-SB-3023 says that there is a
mitigation bit (3) for CVE-2025-48514, bit 3 corresponds to an unrelated
issue. The correct way to check for this is to use the SVN/SPL from the
TCB. We are in the process of updating the SB to reflect this.

v3:
 - Relocate the supported_vm_types updates to sev_hardware_setup.
 - Report unusable VM types as such in dmesg.

v2:
 - https://lore.kernel.org/all/20260324194034.1442133-1-tycho@kernel.org
 - compare SVN as above
 - fix commit message prefixes
 - supported_vm_types local is a u32
 - move crypto stuff before KVM stuff in the event of patch tetris

[1]: https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3023.html
[2]: https://lore.kernel.org/all/20260303191509.1565629-1-tycho@kernel.org

Sean Christopherson (3):
  KVM: SEV: Set supported SEV+ VM types during sev_hardware_setup()
  KVM: SEV: Consolidate logic for printing state of SEV{,-ES,-SNP}
    enabling
  KVM: SEV: Don't advertise support for unusable VM types

Tycho Andersen (4):
  crypto/ccp: hoist kernel part of SNP_PLATFORM_STATUS
  crypto/ccp: export firmware supported vm types
  KVM: SEV: Don't advertise VM types that are disabled by firmware
  KVM: selftests: Teach sev_*_test about revoking VM types

 arch/x86/kvm/svm/sev.c                        |  40 ++++---
 drivers/crypto/ccp/sev-dev.c                  | 101 ++++++++++++++++--
 include/linux/psp-sev.h                       |  37 +++++++
 .../selftests/kvm/x86/sev_init2_tests.c       |  14 ++-
 .../selftests/kvm/x86/sev_migrate_tests.c     |   2 +-
 .../selftests/kvm/x86/sev_smoke_test.c        |   4 +-
 6 files changed, 163 insertions(+), 35 deletions(-)


base-commit: 6b802031877a995456c528095c41d1948546bf45
-- 
2.54.0.rc1.513.gad8abe7a5a-goog

