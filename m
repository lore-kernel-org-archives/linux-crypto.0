Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303CE37C0E6;
	Tue, 24 Mar 2026 16:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774368800; cv=none; b=oIdvtxicatUIUb7b6+6xXoqq93Xb7351jPXdH1RA94VPTZIZkufkJWAG6YRGJq2on+RaD818YDJluahY4jvOsPTNx2tJSz+qs0YxORxHZf3ippxIUypEL4Hgra889okCx4QZwvihYcSahAeDKcuq2JKB6gOMdVG07JZVj6eFc/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774368800; c=relaxed/simple;
	bh=PoiSMYrW+yD2zMRAl8N97TugmYcrcOKYQDwPLlxE3tI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sugZqrrsiq+f1OU6I+8QaPXvGjbbk88219z2xIJQBNA/JfGALOOXSMh6h1M0EXjST4OZ4Ltr2tjYTw2b4GsXHIznXu1DSUAaDDx1S1q0VOdJLte7/wT/tBrcZHiZJ97zI/5BnYbBfrW2p4jhaJGFaQxWc7lOntyzZ0DTTBy9b/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUH1YR3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUH1YR3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877C1C19424;
	Tue, 24 Mar 2026 16:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774368799;
	bh=PoiSMYrW+yD2zMRAl8N97TugmYcrcOKYQDwPLlxE3tI=;
	h=From:To:Cc:Subject:Date:From;
	b=XUH1YR3oJJcRqUjdBn1lqgKfC18draAB4uCNTw5aWi11gWt759UGkFOsHiycZ2jrE
	 1zc8QH9w9iktxnv4wgKouFBg1gzbuJKf6pWx0+q6JHuwujeO5Si4OwdrU2QgEchEM1
	 NY1aMDc2SPyQQ4pWU/1Wz1ExctDxhah3VCrZASFGTEj6cIcXyv97KCWpmCQcfj39r5
	 c0li/wW0WBCCVMBhQvnO99QJUZeSJ67FB4wc1O+gHjtTe/NFwPRPZcE3Nbk8bioMWU
	 lXF8zk/WjEmjOKRrtZsoGyrFPaVityAVAW+Ec2Af7JsY/yzL9kEQI9ZchK9UsDieyE
	 GoDPXLZBrwWXw==
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
Subject: [PATCH v4 0/7] Move SNP initialization to the CCP driver
Date: Tue, 24 Mar 2026 10:12:54 -0600
Message-ID: <20260324161301.1353976-1-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Changes are:
* commit message fixes: snp -> sev, add arch/x86/ to path, capitalize things
* rename snp_set_hsave_pa() -> clear_hsave_pa(), since it's clearing the register
* snp_prepare_for_snp_init() -> snp_prepare()
* snp_x86_shutdown() -> snp_shutdown()
* 0 -> NULL, drop a newline in snp_shutdown()
* carry Herbert's acks as appropriate

v3 is here: https://lore.kernel.org/all/20260317162157.150842-1-tycho@kernel.org/

Tom Lendacky (2):
  x86/sev: Create a function to clear/zero the RMP
  crypto/ccp: Update HV_FIXED page states to allow freeing of memory

Tycho Andersen (AMD) (5):
  x86/sev: Create snp_prepare()
  x86/sev: Create snp_shutdown()
  x86/sev, crypto/ccp: Move SNP init to ccp driver
  x86/sev, crypto/ccp: Move HSAVE_PA setup to arch/x86/
  crypto/ccp: Implement SNP x86 shutdown

 arch/x86/include/asm/sev.h   |   4 ++
 arch/x86/virt/svm/sev.c      | 111 ++++++++++++++++++++++++-----------
 drivers/crypto/ccp/sev-dev.c |  62 ++++++++++---------
 include/linux/psp-sev.h      |   5 +-
 4 files changed, 120 insertions(+), 62 deletions(-)


base-commit: 2ca26dad836fb4cd18694ef85af7a71d2878b239
-- 
2.53.0

