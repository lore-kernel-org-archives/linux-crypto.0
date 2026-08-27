Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B69F37E5DA;
	Thu, 27 Aug 2026 02:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787796419; cv=none; b=dDWQFO8DL/fi6UGBQbXdAZQsuVZQ1TconYOzMFa0mGoBVGMiaSyMMR5ZBzbaapniDmb4oIC0jwuUfI6D+tM3Zy+s/vI09P4qTQLOwUDL+cftK//aHHIjlIk87Ny4Y/9/9Evr0DKoSOc2RFHa85yqCLl1rqG6VQm6AcaUlrPV2E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787796419; c=relaxed/simple;
	bh=gL0phxzVoVhVemXwWCd4xZC1JDHdiO9EhSL9gt+YRbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lX7KkchheBw4rCiXNo0lThmunK4PbpX0LF7iAA0YybHuVONzKhU37m1GUl8beADe9kPxZ9FbpmAES76lkLPPoKdATBQIYxpTTRzBUms/0oXLF3Tu6gX9Z9PeXF68cxdwN3ahDuClqbWSEwHe1ofsfHM8nsA8D7W2ZVEVovTpa9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bsrMXhAq; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bsrMXhAq"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7D74840E01A2;
	Thu, 27 Aug 2026 02:06:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id jd_fD0SB0TYW; Thu, 27 Aug 2026 02:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1787796402; bh=tvL5rKHzTbVYhzBl9qHb4PL59PMigbMXonEm7pq5+dQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bsrMXhAqesv5sWmU7bf5gApE2BR3rfOLkTFEj+daNgpEHVhRDtPz52LPifWUHlz3d
	 DWBoKQT5Erwzv6MflMnL56czhzDNHWkoN40OPRdksiWLYPM6FY8iR4W+X0e1DCXQUL
	 21E2Co0g+5FwhMBH5qIi4z1Z1bhlsTQyb0OrPRSIFKoKXQ5WIlLl7tAA/t0A3R6g2u
	 5sJcuPSDYSvTF/TwAf5FARD2yEqH+G6Dy5sLa1LiQk8uVLgjmUws2Pbf3qAv5gYbV7
	 vHqROTqRwdk2TTg4uig9vrhhtXBLinhrTUQPYl3BAdCVNZ8oeSW7lNoozEvzjSEnzL
	 nQ+KhebLPX0iqv0E+1nozmQa1Wgb3duLUIWrxKFPOE43/pp23F4zpLOMwbmrJ4hsrI
	 lp3O7hPL7Few4odcG4CzdpbLF2IbMuV9BZl3kyWQ7hTyEwrFRkdUX4cYoMaoC+MVnY
	 iyPRtekgxShMRzfHmRfp44HFnIh3bCXEQcIax8+L33R/vTjRWXWP5INu6jsvcXCOOR
	 bMGV2JG/uPOPzTxQRDJLrnIbHQ6lpoV3qY2Kkd4TjMo/o++XGeo0BrXEzGt2vfjlae
	 UO6QA4P8YwJChK9R+9xFTsHRqAuzMs1AgId4IWKpYAX4KOtwH0upE3buqlYXV3gJaJ
	 B6Yxn6S89nIktwbdRXcxN02Q=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BDAEA40E00E6;
	Thu, 27 Aug 2026 02:06:07 +0000 (UTC)
Date: Wed, 26 Aug 2026 19:06:04 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	peterz@infradead.org, thomas.lendacky@amd.com,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com,
	Nathan.Fontenot@amd.com, ackerleytng@google.com, jackyli@google.com,
	pgonda@google.com, rientjes@google.com, jacobhxu@google.com,
	xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com,
	john.allen@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v12 3/5] x86/sev: Initialize RMPOPT configuration MSRs
Message-ID: <20260827020604.GCao-bjMkHGnQlAWnL@fat_crate.local>
References: <cover.1786389115.git.ashish.kalra@amd.com>
 <19b316f26a145646c521943f5fdd5dfc4b2d1e84.1786389115.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19b316f26a145646c521943f5fdd5dfc4b2d1e84.1786389115.git.ashish.kalra@amd.com>

On Mon, Aug 10, 2026 at 07:21:53PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The new RMPOPT instruction helps manage per-CPU RMP optimization
> structures inside the CPU. It takes a 1GB-aligned physical address
> and either returns the status of the optimizations or tries to enable
> the optimizations.
> 
> Per-CPU RMPOPT tables support at most 2 TB of addressable memory for
> RMP optimizations.
> 
> Initialize the per-CPU RMPOPT table base to the starting physical
> address. This enables RMP optimization for up to 2 TB of system RAM on
> all CPUs.
> 
> Additionally, add support to setup and enable RMPOPT once SNP is
> enabled and initialized.
> 
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
> Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/msr-index.h |  3 ++
>  arch/x86/include/asm/sev.h       |  2 +
>  arch/x86/virt/svm/sev.c          | 75 +++++++++++++++++++++++++++++---
>  drivers/crypto/ccp/sev-dev.c     |  2 +
>  4 files changed, 77 insertions(+), 5 deletions(-)

Some cleanups ontop:

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 923b7869acd1..982753002a3c 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -558,7 +558,7 @@ int snp_prepare(void)
 }
 EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
 
-static void snp_cleanup_rmpopt(void)
+static void rmpopt_disable(void)
 {
 	int cpu;
 
@@ -577,8 +577,7 @@ void snp_shutdown(void)
 	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
 		return;
 
-	/* Disable RMPOPT while CPU hotplug is disabled. */
-	snp_cleanup_rmpopt();
+	rmpopt_disable();
 
 	clear_rmp();
 	on_each_cpu(mfd_reconfigure, NULL, 1);
@@ -612,8 +611,7 @@ void snp_setup_rmpopt(void)
 	}
 
 	/*
-	 * The RMPOPT_BASE MSR is per-core, so only one thread per core needs
-	 * to set up the RMPOPT_BASE MSR.  All primary threads are online,
+	 * The RMPOPT_BASE MSR has core scope. All primary threads are online,
 	 * otherwise SNP would not have been enabled.
 	 */
 	for_each_online_cpu(cpu)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
