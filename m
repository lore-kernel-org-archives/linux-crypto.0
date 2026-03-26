Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F20407108;
	Thu, 26 Mar 2026 16:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774541503; cv=none; b=h66CXRwe/Kuw60tLGE+Lpo+KdswlECMs5U17wvPWJzIhN9I/QVp8g9D5Kfil1ge2bKe5k2RKIkrBAfmmUUIpapugTIqEcSDdnGmVOyOiL+PQfhNBUlsAYEX/tKid3d3CJUk6uk1HQyS5OoKNt/2J6lE/paus0NabWVJ8gTMpL+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774541503; c=relaxed/simple;
	bh=avIBgmRYM8nE+ijQYpkV192AaG4Qv/ACBckx62a4mCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U66n6N7gAjI1jZdX0xyvTbvw6S57Oq50eWOngehBzHeD97w7K0oPSIYHqhVnPfKfje+p+I9S7JlqA1KxSK2gBKByxIgR42wBP3RYLmCINlsJDPjn+5KG9VXCvdi7Lzu+NsoUghR92crDWAH4c41p7PZ+1KeUDbjaqWCklecH7Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q3uh26Gk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q3uh26Gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB657C116C6;
	Thu, 26 Mar 2026 16:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774541503;
	bh=avIBgmRYM8nE+ijQYpkV192AaG4Qv/ACBckx62a4mCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3uh26Gk2siUQpkW0LGFztQS//E6v89OSw2mziTC7wu4H2gQChZKNYIGiweH7lhO8
	 jrH+lxZFIFfQPpdSfOCzjesokemeMOk/Yi9CMfaabD14FsBC0eSPc67ncBjs1W7KmQ
	 9Dms8WseFjFdoOPOqSwTodfdckK7pA2TpcoHEx/5Zbh41rtAlYeS6h3zScxTw9xeAg
	 VGDUkoLTuQsxoBfs+R5lketMMIj9TVXReV9xIi6QJuoHn9PdL1Edm+vq5yfu3gcSnl
	 J98u2HhJjJJp7LPscUVUL/t85sCPife2JwPS43ooOR8N7m9/a46URQGYgntlebBaf8
	 m8hUJfPG+mMaw==
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
Subject: [PATCH v5 4/7] x86/sev, crypto/ccp: Move SNP init to ccp driver
Date: Thu, 26 Mar 2026 10:11:07 -0600
Message-ID: <20260326161110.1764303-5-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260326161110.1764303-1-tycho@kernel.org>
References: <20260326161110.1764303-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Use the new snp_prepare() to initialize SNP from the ccp driver instead of
at boot time. This means that SNP is not enabled unless it is really going
to be used (i.e. kvm_amd loads the ccp driver automatically).

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/virt/svm/sev.c      | 2 --
 drivers/crypto/ccp/sev-dev.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 3b2273dca196..423fe77cc70f 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -562,8 +562,6 @@ int __init snp_rmptable_init(void)
 	if (!setup_rmptable())
 		return -ENOSYS;
 
-	snp_prepare();
-
 	/*
 	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
 	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index aebf4dad545e..4915b0125e8d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1373,6 +1373,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		return -EOPNOTSUPP;
 	}
 
+	snp_prepare();
+
 	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
 	on_each_cpu(snp_set_hsave_pa, NULL, 1);
 
-- 
2.53.0

