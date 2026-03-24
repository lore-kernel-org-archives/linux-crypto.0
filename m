Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01D223B63E;
	Tue, 24 Mar 2026 19:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774381317; cv=none; b=IZBGucr9XLfyqCdYUDWzPCWVwwmcy8X+evDgoefAmesSiVjhbi7uknANqAuZJsSXvs6OyKqw7p/4cjvxlRGvWZSYRUC2VVP1VO+OVrdpJKhfJQH2FJ9a8+EymvOfwl2tN8XxLEO7KtsUmDykdvIU6N9tNuVRfA+q9FYQA3ax+4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774381317; c=relaxed/simple;
	bh=DHBGJzCD66m+H9Pwc7hWbSb/WS68n3w8A7k5i2r9CEc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OJdFe4gV3iiNeBeSWbEOAfi6m3J/sYSP/RfYrxZIWYFITUNfvNJqWFrLXkxr/OWepKuamZlCLOuBC+w0UotdI5sKCEAzBFBN2cHGsvke1EGxP8o6CflzOJ5K78xlKrBQ0O4KqdbQMTP1+j+wdlo3cvWO1mugKWg1i/HRFcOtAsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvKaLsL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvKaLsL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABC0C19424;
	Tue, 24 Mar 2026 19:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774381317;
	bh=DHBGJzCD66m+H9Pwc7hWbSb/WS68n3w8A7k5i2r9CEc=;
	h=From:To:Cc:Subject:Date:From;
	b=lvKaLsL4U2iYmc3fv+SdcKs34G7rFl3RFL1fmHc9kNkKwRZDLNFvLaZyMVjBWVj3G
	 ylXAJpVhf5d6C11Kk9nG2nhYgBGlz+cEVAl0R4TVGkVhJ/jw+YiR9Sr4tQLGiqc/X8
	 3ra+k6XZqgbkhpqqsRaJzPnmOkHCHj400Hfuy+UV4neX+oqVMGMR0RNsw5jTf6KgrF
	 wz4kA6TpBT4IHWZarm7FJeUFfeS79Qxz/4LzePvG2+NYPR7nQ6NU80Tti6wcyqH+Ry
	 dTFqXaN383cKBybM4rbnCwekB/gqj2/bBcDXU46aXEGF3haUk9UXBRjxU3JNq1llt5
	 mmLAsU7vUPvVg==
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
Subject: [PATCH v2 0/5] Revoke supported SEV VM types
Date: Tue, 24 Mar 2026 13:40:29 -0600
Message-ID: <20260324194034.1442133-1-tycho@kernel.org>
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
Expose this by revoking VM-types that are not supported by the current
configurations either from firmware restrictions or ASID configuration.

My previous version of this patch series [2] used SNP_VERIFY_MITIGATION
to test for a mitigation bit. While AMD-SB-3023 says that there is a
mitigation bit (3) for CVE-2025-48514, bit 3 corresponds to an unrelated
issue. The correct way to check for this is to use the SVN/SPL from the
TCB. We are in the process of updating the SB to reflect this.

changelog from v1:
* compare SVN as above
* fix commit message prefixes
* supported_vm_types local is a u32
* move crypto stuff before KVM stuff in the event of patch tetris

[1]: https://www.amd.com/en/resources/product-security/bulletin/amd-sb-3023.html
[2]: https://lore.kernel.org/all/20260303191509.1565629-1-tycho@kernel.org/

Tycho Andersen (AMD) (5):
  crypto/ccp: hoist kernel part of SNP_PLATFORM_STATUS
  crypto/ccp: export firmware supported vm types
  KVM: SEV: don't expose unusable VM types
  KVM: SEV: mask off firmware unsupported vm types
  KVM: selftests: teach sev_*_test about revoking VM types

 arch/x86/kvm/svm/sev.c                        |  15 ++-
 drivers/crypto/ccp/sev-dev.c                  | 101 ++++++++++++++++--
 include/linux/psp-sev.h                       |  37 +++++++
 .../selftests/kvm/x86/sev_init2_tests.c       |  14 ++-
 .../selftests/kvm/x86/sev_migrate_tests.c     |   2 +-
 .../selftests/kvm/x86/sev_smoke_test.c        |   4 +-
 6 files changed, 151 insertions(+), 22 deletions(-)


base-commit: c369299895a591d96745d6492d4888259b004a9e
-- 
2.53.0

