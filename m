Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8C42D5C68;
	Mon,  2 Mar 2026 19:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772478870; cv=none; b=CpbSq+sYOtILt56UMCuJhObO9VrqLbV++bStbWJ2bLoXzYWNau154KqZJy9EGo6A30802KiwRMFjWhkuBY+XcOVRlr9rRC1LKyAyk8CYX113gUuoQTAs9XEJgBVoYIV1vOZyA9lWtrbMESv8tG3vMFsOdhz4PlU9VPXWNtOgLCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772478870; c=relaxed/simple;
	bh=0M35LrSdZwLy+3zFROn1/VuOccdy5hGQJzOVxrh3nsU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DPBGWiRMdpzICQmIoA+Bo2lW0Ce8IX7Qb4wAUxWv3ouGKV72uONXqdYW5NIRs8npz+pnr/PcPfYOW3NkARE82KN4ZqVb//neze9NLCrd61BY4Fly+A41ubgNoSYYNnRM9IxtiFeb1ezCfgLtmAJFGyBfzpCNoa1c3y57+rZv36w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X2Zu+/VY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X2Zu+/VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DB6C19423;
	Mon,  2 Mar 2026 19:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772478869;
	bh=0M35LrSdZwLy+3zFROn1/VuOccdy5hGQJzOVxrh3nsU=;
	h=From:To:Cc:Subject:Date:From;
	b=X2Zu+/VY2vFLRDvyhVEcx1A+D1BFwjp9gm7yfM/bFLNb+YgIH1DfMDFM0yewTZzcj
	 us4CKbLcDk9p0r/yf6PPhdAVhn78Fq/PZdqUqtw3xmK6w7EQfnCNq8FDArBh2ZU63l
	 qCtYLd4Tomw8w4VJLycQLWcuwZ7a7BLg8rb9DrYwtBHaLjtXxbffHx85pyuJiXipIl
	 zArBMBljecFpdVAIs4Yrjd5QViTMwluRNs1jpK6pv2GzGj8YEJ/x8jNugQjrXkgqU/
	 3RwDcIzzoFWRRSkd2uGgdGW/1NRSx96k1OUn4c+WEzKLLUPSEXGMPWXdhIaH7Yjr+N
	 vYI9tXxO5BvJQ==
From: Tycho Andersen <tycho@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>,
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
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH 00/11] Move SEV-SNP initialization to ccp driver
Date: Mon,  2 Mar 2026 12:13:23 -0700
Message-ID: <20260302191334.937981-1-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

The SEV firmware has support for disabling SNP when doing a
SNP_SHUTDOWN_EX, which will turn off the SNPEn bit. If setting SNPEn is
also delayed until module load, this means that we can control the
lifecycle of SNP enablement with module load and unload. This way, the
SNP checks are only done while the module is actually loaded.

Tom Lendacky (3):
  x86/snp: Keep the RMP table bookkeeping area mapped
  x86/snp: Create a function to clear/zero the RMP
  crypto: ccp - Update HV_FIXED page states to allow freeing of memory

Tycho Andersen (AMD) (8):
  x86/snp: drop support for SNP hotplug
  x86/snp: drop WBINVD before setting SNPEn
  x86/snp: create snp_prepare_for_snp_init()
  x86/snp, crypto: move SNP init to ccp driver
  x86/snp, crypto: move HSAVE_PA setup to arch/
  x86/snp: allow disabling MFDM
  x86/snp: create snp_x86_shutdown()
  crypto: ccp - implement SNP x86 shutdown

 arch/x86/include/asm/sev.h   |   4 +
 arch/x86/virt/svm/sev.c      | 148 +++++++++++++++++++----------------
 drivers/crypto/ccp/sev-dev.c |  65 ++++++++-------
 include/linux/psp-sev.h      |   4 +-
 4 files changed, 125 insertions(+), 96 deletions(-)


base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
-- 
2.53.0

