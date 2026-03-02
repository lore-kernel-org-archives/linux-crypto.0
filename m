Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378E83E0C4B;
	Mon,  2 Mar 2026 19:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772478887; cv=none; b=Uh9aUoCdrJftvhm5QTIO4wKtzhzG9wPYPVbBgrOTpzZ5bh/faP1p8l0wCvJcfvv/1YkGmxpBkXi/ErDmT5SmcaC9Td0c8hViF6iZ+bzpmMfEz7B4nl/JwKkxHwwZ1ciiQXp5gLl2ZHoy4ghxfsGKkSs1P0DbCiNuq/zyxQt+6Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772478887; c=relaxed/simple;
	bh=UFroV8mauc76cWxH7swPjhVFjeW5UFWPeFCqSXmtJJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BeywJs7YwDfrb/VTarupAGu0qORTLCd/0OA/kI/sc7QpY8YSkP5CWeJMq30ZExo5KxjTu4Xz1wgiJekBP3SA7yhm63OltoQixtmbUEYqmcM7oTyDsRaWHh1mtBJHQXryRLJ9152pmaQfDEDO1C12JBEDJ2AA+BznuD49ZLHEU7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CbzdbfOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CbzdbfOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70072C2BC9E;
	Mon,  2 Mar 2026 19:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772478886;
	bh=UFroV8mauc76cWxH7swPjhVFjeW5UFWPeFCqSXmtJJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbzdbfOgQmocbWi0A2sz3VRTX3m6zmsdHQUvZP1oxbl32S5QZpF/KmhA4vnLKbazT
	 FixfPD/+dU3QE6dEWwEtnL9LYfweJqap2agTBLxlRcHN3itltHwzTDieQvot/EyC/5
	 U2CxanvRO4I+gDbq/+LPNCKZ75v5iDo8IY6I1SSCeRrX/oTgxNq7AInV4rgpHWOsEj
	 79tAspZsC9JGhOYPrrYjyxUzaJvZG4EZNWOlknW39zLqRf5jyMH3F5FwKm7iO6PP1f
	 cRmDsnJ8/bJW5Ga/wvrigdRXjYpuOcnT3axmNtSFYexM+QD9klNSOOntPm+SkXJrmC
	 ArE8fNDBP3UHw==
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
Subject: [PATCH 07/11] x86/snp, crypto: move HSAVE_PA setup to arch/
Date: Mon,  2 Mar 2026 12:13:30 -0700
Message-ID: <20260302191334.937981-8-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302191334.937981-1-tycho@kernel.org>
References: <20260302191334.937981-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Now that there is snp_prepare_for_snp_init() that indicates when the CCP
driver wants to prepare the architecture for SNP_INIT(_EX), move this
architecture-specific bit of code to a more sensible place.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/virt/svm/sev.c      | 8 ++++++++
 drivers/crypto/ccp/sev-dev.c | 8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index aa784542b32d..53bc0c7f2c50 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -509,6 +509,11 @@ static bool __init setup_rmptable(void)
 	return true;
 }
 
+static void snp_set_hsave_pa(void *arg)
+{
+	wrmsrq(MSR_VM_HSAVE_PA, 0);
+}
+
 void snp_prepare_for_snp_init(void)
 {
 	u64 val;
@@ -530,6 +535,9 @@ void snp_prepare_for_snp_init(void)
 	on_each_cpu(mfd_enable, NULL, 1);
 
 	on_each_cpu(snp_enable, NULL, 1);
+
+	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
+	on_each_cpu(snp_set_hsave_pa, NULL, 1);
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare_for_snp_init, "ccp");
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 5b1a24b11e3e..ef45977b09b6 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1076,11 +1076,6 @@ static inline int __sev_do_init_locked(int *psp_ret)
 		return __sev_init_locked(psp_ret);
 }
 
-static void snp_set_hsave_pa(void *arg)
-{
-	wrmsrq(MSR_VM_HSAVE_PA, 0);
-}
-
 /* Hypervisor Fixed pages API interface */
 static void snp_hv_fixed_pages_state_update(struct sev_device *sev,
 					    enum snp_hv_fixed_pages_state page_state)
@@ -1377,9 +1372,6 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 
 	snp_prepare_for_snp_init();
 
-	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
-	on_each_cpu(snp_set_hsave_pa, NULL, 1);
-
 	/*
 	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list
 	 * of system physical address ranges to convert into HV-fixed page
-- 
2.53.0

