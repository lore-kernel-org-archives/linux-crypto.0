Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C5937C904;
	Tue,  3 Mar 2026 19:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772565343; cv=none; b=FugV/W3frrqXfUOUH9S2M/V7zdZwTW/cT0DCcmjTn0SaAACjFZBu7U+GL1CC0YWiCV7gT4TtNr5F+kilRIndh4+0qH9655WoeKbVtBgGyJqZKzqAB74dLhy7jwUdL+hW+ftkBLeznKUnUUdInV5TC8PqoJTTyvspZGHVjFz7M6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772565343; c=relaxed/simple;
	bh=ntcvvjP8obpOAQSTZOCZsIkocrKc0EYZVEgtp1Q0FcE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZBfPzDoI5DCzEb4NIU0rpr81WNWMcGk7gWJQVgLdW7C29nYEHr1NadTzCKAuEev5vpOR2r8P1rBu3NmRxF9srIwJfChW5bH94n0yPCzea5fbJJNUsuGWWtynqZHw4uEhtYMHLsYpcAJNl0B4ofYunaWb4XBVDlXJwRbPiaGwsBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AYTonWmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AYTonWmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77026C116C6;
	Tue,  3 Mar 2026 19:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772565343;
	bh=ntcvvjP8obpOAQSTZOCZsIkocrKc0EYZVEgtp1Q0FcE=;
	h=From:To:Cc:Subject:Date:From;
	b=AYTonWmFSYej9IbogOfW1QgZyRhpducblPK/xO6xn84DHW6zv3m+OggJ1kanHBWQB
	 MaAtooRPcdRZcInZcKX66JAd9W68liuGRX0wc8RvcXdqpNA+eXxRPZ1JFSd9DExh8y
	 sHBBsHdXpNL2MSffD+3FgRP+qyjqyvksO9+WkKirjQBA4HLZp8SbpvLfRzfcJ/kTf0
	 cW52vwVTZMn+NEpvbxNu5phErXG6Bwt9OM1DhI+Xsz/KM73OBwOC+SJodDwXhhVbwc
	 JXyvPDHlOCzDZCDbxB7+Phh3CbTLmhXWghwJ/CX3rGenFgczvBJs9Sf7hf74HOvrCv
	 D+1YShFKda7uA==
From: Tycho Andersen <tycho@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Shuah Khan <shuah@kernel.org>
Cc: Kim Phillips <kim.phillips@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 0/5] Revoke supported SEV VM types
Date: Tue,  3 Mar 2026 12:15:04 -0700
Message-ID: <20260303191509.1565629-1-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Recent SEV firmware [1] does not support SEV-ES VMs when SNP is enabled.
Sean suggested [2] adding an API so that userspace can check for this
condition, so do that. Also introduce and use SNP_VERIFY_MITIGATION to
determine whether it is present or not.

[1]: https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3023.html
[2]: https://lore.kernel.org/all/aZyLIWtffvEnmtYh@google.com/

Tycho Andersen (AMD) (5):
  kvm/sev: don't expose unusable VM types
  crypto/ccp: introduce SNP_VERIFY_MITIGATION
  crypto/ccp: export firmware supported vm types
  kvm/sev: mask off firmware unsupported vm types
  selftests/kvm: teach sev_*_test about revoking VM types

 arch/x86/kvm/svm/sev.c                        | 16 +++-
 drivers/crypto/ccp/sev-dev.c                  | 84 +++++++++++++++++++
 include/linux/psp-sev.h                       | 56 +++++++++++++
 .../selftests/kvm/x86/sev_init2_tests.c       | 14 ++--
 .../selftests/kvm/x86/sev_migrate_tests.c     |  2 +-
 .../selftests/kvm/x86/sev_smoke_test.c        |  4 +-
 6 files changed, 162 insertions(+), 14 deletions(-)


base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
-- 
2.53.0

