Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BECF31B131;
	Mon,  2 Mar 2026 19:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772478872; cv=none; b=XXlMk6e7ESo9pAqjnjDzuazLj5CbsuRJccn7ThtS47oPXjSZCs6BRVyznydnTkVqtDFiua+Guk3gmM5GIy0K9LwaQk517LIukzBy3u44q7ISyW3ohUK+xk93MNIA8V98ChgeO71cS1RpnpOau9paxaootc+jsHg7P0JVm+OQIjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772478872; c=relaxed/simple;
	bh=mr8fnQHScadkR4uCG8Cf45gkFhDtXzkKMTtJf6PxiUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elUaVWIwqgLdt/7MW31L84nztI6hzWdm5UzTi6++68Po3xAPI1G2Vw4mL8RzzgK7iOfYgXrWciD5+/43R17jEZk4/HlilMEva7XxvW5furW54x9z1WtoAAgUrkkGeMiYSK8ACh/VFMpMtH46sVg1ghXOUhcxTzI5GAoopf3r75E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ek69pEVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ek69pEVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63D9C2BC9E;
	Mon,  2 Mar 2026 19:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772478872;
	bh=mr8fnQHScadkR4uCG8Cf45gkFhDtXzkKMTtJf6PxiUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ek69pEVrM5DLnyG1fkSNDUUmECUKMulNQ4QjxEUBdO8/I7c7cWbxw+o4ASmFeh6YQ
	 13VJVP3169mx4aLEYT+cPiDvbTijzhkO/1P8L6464dfjm3npMs9/6isr8Kp9VqQO0N
	 b7FHbrqAP5MM5RAMmD4/Fq1Bd074h5a6zjC4HToAMHMHwqxL8QhL2xX/wPwLxT5rL6
	 Y64HRQNc4Tg25Dqmf4xGGwUytQ/Xf08j2nlUEc9l+D7UW9ZwvFaOzhv3nLdObjNP+8
	 2tBU+OspJFwobxxMOcgUs9bn5Lfc+NZtSJja0DZzKDl76rQYkWVqcCq35pzirUjszw
	 8ZkP7jsIzCmjg==
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
Subject: [PATCH 01/11] x86/snp: drop support for SNP hotplug
Date: Mon,  2 Mar 2026 12:13:24 -0700
Message-ID: <20260302191334.937981-2-tycho@kernel.org>
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

During an SNP_INIT(_EX), the SEV firmware checks that all CPUs have SNPEn
set, and fails if they do not. As such, it does not make sense to have
offline CPUs: the firmware will fail initialization because of the offlined
ones that the kernel did not initialize.

Futher, there is a bug: SNP_INIT(_EX) require MFDM to be set in addition to
SNPEn which the previous hotplug code did not do. Since
k8_check_syscfg_dram_mod_en() enforces this be cleared, hotplug wouldn't
work.

Drop the hotplug code. Collapse the __{mfd,snp}__enable() wrappers into
their non-__ versions, since the cpu number argument is no longer needed.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 arch/x86/virt/svm/sev.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index a4f3a364fb65..1446011c6337 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -130,33 +130,26 @@ static unsigned long snp_nr_leaked_pages;
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
-static int __mfd_enable(unsigned int cpu)
+static __init void mfd_enable(void *arg)
 {
 	u64 val;
 
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
-		return 0;
+		return;
 
 	rdmsrq(MSR_AMD64_SYSCFG, val);
 
 	val |= MSR_AMD64_SYSCFG_MFDM;
 
 	wrmsrq(MSR_AMD64_SYSCFG, val);
-
-	return 0;
 }
 
-static __init void mfd_enable(void *arg)
-{
-	__mfd_enable(smp_processor_id());
-}
-
-static int __snp_enable(unsigned int cpu)
+static __init void snp_enable(void *arg)
 {
 	u64 val;
 
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
-		return 0;
+		return;
 
 	rdmsrq(MSR_AMD64_SYSCFG, val);
 
@@ -164,13 +157,6 @@ static int __snp_enable(unsigned int cpu)
 	val |= MSR_AMD64_SYSCFG_SNP_VMPL_EN;
 
 	wrmsrq(MSR_AMD64_SYSCFG, val);
-
-	return 0;
-}
-
-static __init void snp_enable(void *arg)
-{
-	__snp_enable(smp_processor_id());
 }
 
 static void __init __snp_fixup_e820_tables(u64 pa)
@@ -553,8 +539,6 @@ int __init snp_rmptable_init(void)
 	on_each_cpu(snp_enable, NULL, 1);
 
 skip_enable:
-	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
-
 	/*
 	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
 	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
-- 
2.53.0

