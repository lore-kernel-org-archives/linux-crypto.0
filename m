Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458C830FC26;
	Tue, 17 Mar 2026 16:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773764595; cv=none; b=pJZ5suGQzrkhIAvH3B2l+pp5LsV48r8rYkRWl9SuAIwPyP0J0wA1A4DoQPZ/Sp3fd+f44lBej1hCTfzEZ+fOZqq8RLOv9Zw0ECHceHQVAr72byeOoT7cXny2hcU8TounYDLERmuiHY81Sxw7oaIt4MAUA7J+c2kXU84I6XDzodA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773764595; c=relaxed/simple;
	bh=jz7KIRTPzk3fLbrESkoyqHwAq01VsJjWNGycMnURNgM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fTgiBHE2IlMRmrjnM1T/op9IHAxpgfOr64X0LHwqjwzvyPdKvmI8ENEupccj0X2kjLY3hNcqQ3YxzEIHDd7LCFhGTXoSy/3O2bcRSc3w0KnKQC6ahx3xm5X1Wa3uFHGA/ANa68LprP6rrVvwD1ZPgyjogldumsQMN1E31N3opSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dgKvP+46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dgKvP+46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31E8C4CEF7;
	Tue, 17 Mar 2026 16:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773764594;
	bh=jz7KIRTPzk3fLbrESkoyqHwAq01VsJjWNGycMnURNgM=;
	h=From:To:Cc:Subject:Date:From;
	b=dgKvP+46Is8WU5cD8w93g7oPHP/M3Kr69lWwVcKVodq0sJ2NIeZhpkNgQxIjXwjjP
	 3sUe5Rx/jQ0Re/f1dZ4T+7BtcpvpSofeM7OQXq9GizMfPYT5zQYSpqxJt/ggk+LFyn
	 hq4VyqMT26rr0vcroMCxy3fz8pd9bMqKnvgIycKHueiZj307KGuGuUqjpxqvoFmH2W
	 VgzIGsH2xaQfJ2DcWCHpvbLT6goaIMW7+gYrGV4mFfyCdHuHbFGlDNwbs+ndAAttlw
	 OgOJhWhdL2EggPW8cP13CD6Lz6hBBLLfvSUEJov8SV/jVbxr75Xz/oT8g4H5P1Xijv
	 FnVwU9VIwIpaw==
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
	linux-crypto@vger.kernel.org,
	"Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: [PATCH v3 0/7] Move SNP initialization to the CCP driver
Date: Tue, 17 Mar 2026 10:21:50 -0600
Message-ID: <20260317162157.150842-1-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Here's v3 of the series. Changes are:
* rebase on tip/master and drop the three patches that are already there
* prep -> preparation in one more place that I missed
* snp_clear_rmp() -> clear_rmp()
* move the create snp_x86_shutdown() patch earlier, so the order is now: x86
  only stuff, x86 + crypto stuff, crypto only stuff. Hopefully that makes it
  easier to apply in the event of patch tetris.

v2 is here: https://lore.kernel.org/all/20260309180053.2389118-1-tycho@kernel.org/

Thanks,

Tycho

Tom Lendacky (2):
  x86/snp: Create a function to clear/zero the RMP
  crypto: ccp - Update HV_FIXED page states to allow freeing of memory

Tycho Andersen (AMD) (5):
  x86/snp: create snp_prepare_for_snp_init()
  x86/snp: create snp_x86_shutdown()
  x86/snp, crypto: move SNP init to ccp driver
  x86/snp, crypto: move HSAVE_PA setup to arch/
  crypto: ccp - implement SNP x86 shutdown

 arch/x86/include/asm/sev.h   |   4 ++
 arch/x86/virt/svm/sev.c      | 112 ++++++++++++++++++++++++-----------
 drivers/crypto/ccp/sev-dev.c |  62 ++++++++++---------
 include/linux/psp-sev.h      |   4 +-
 4 files changed, 120 insertions(+), 62 deletions(-)


base-commit: 270b06a2452b0a20b149591ee90e22e3d8d55358
-- 
2.53.0

