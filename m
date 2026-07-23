Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5DA488767;
	Thu, 23 Jul 2026 18:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784832863; cv=none; b=B7p2WYV66rvr+Ouwmex8MTaBTTG9lOdsPQXjVsxHg5wY75ROzYMraof1Sp/amvpCCiN3MTKA5eAhuDz2t0zXgZ9dk8oMg4YVlVy9bqCYKT1EJCJH8etrm7HQHpRujw+txwnOqo6XD4hMemnJDpL6qyNqfldY2GpihRq9hEw9TgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784832863; c=relaxed/simple;
	bh=h9OtEV4qVHAlX9KQYjihbUFKtfO6sstnIeiFiDgoNVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hPmeFl/G4FQrsNDPsFmkmi1xCh6yQAarAriW66oDzDt8Ksv1WK1Zs271Ecuzw6a4u5EAJgpzANEYgzZFIN9kqPh5CliX4OHJvdbsMSHl9A4nSd+mprXQ7x/LgNKs/8Q8j+hfnzh69P4dAjaT6UbqeDWqQwLK67q4QD6Vj4cmkXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=JsGnJrZ2; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="JsGnJrZ2"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C153C40E00DC;
	Thu, 23 Jul 2026 18:54:12 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4AZIU2mSZdwn; Thu, 23 Jul 2026 18:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784832841; bh=VjYfDXADIh0xhQ+fjHF1Jv01qoDx2xMCSHhEriUi0Hs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JsGnJrZ2/7sUYiUCIv2KOCQj1PrDOJvK4e83jLp7okg4LGN5J/RmmLUesfD5fr5I3
	 Mt5JYFHoNNWR4EzQNU127WyWMP2BGomGxaXMiPzEevVfpeDPrAwp9uZZo/gp12pc4X
	 wcdpHCT4jZ3XmCmFhpMgl4vTQwwxYyLMrTPTJwArefHleMRep1JN2t0zagEz8SOZDa
	 78XL3vCkRXRAD6zQPAMPRyS6bvF6/HPAHteaLDXrkojsKYDNbuHQd/0nHVSNHujasT
	 b3tbg+39biHsy66Q/XN1eHd2/5e7JweFSypSONu5Wt6+SIxcmfigN1xs2SsiyYl6kV
	 QTqEqq7lAqamE+mWduGefQ326mSlIqq1rToAd+6VDpmivnmtZOwaaEc6H8oCidIKsv
	 rhbkKvnV3zU+tMT1nFv8OJYnZQX/I2UIUmNL6rEfGLl6hjBsGw68Gf+s7yT/QkCrhf
	 mhQ/3JZXcGoqWN7FbqGvm5danDFL68OzlDKcHlYQd/rc5QWmqZ80NXwnBGsnRYClza
	 Wx/jQ9cBJEk+ecJEutmM+DDtRKNNQCu8gM/kMgFndV7N0ibCvRG7rzF+BhhBX1uJbR
	 QZpcjgYT94C8+FgnhdKdFiRnz+zN7v6Y3YbXOiNk85yBn3lQsA7gVCkLK49M5zjFgY
	 mOxi5lQM5Gy6jwIH2wOuJJ1M=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DE7A340E00E6;
	Thu, 23 Jul 2026 18:53:26 +0000 (UTC)
Date: Thu, 23 Jul 2026 11:53:23 -0700
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
Subject: Re: [PATCH v10 3/6] x86/sev: Disable CPU hotplug while SNP is active
Message-ID: <20260723185323.GAamJjI2HoM1gZmExw@fat_crate.local>
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <205a5259f9fd353dc0ca6b00565c8175a96768c7.1782841284.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <205a5259f9fd353dc0ca6b00565c8175a96768c7.1782841284.git.ashish.kalra@amd.com>

On Tue, Jun 30, 2026 at 06:11:03PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> While SNP is active, every memory write is checked against the RMP to
> protect SEV-SNP guest memory.  A core performs these RMP checks only once
> ...

Use this commit message for your next revision. The idea is to split it into
smaller paragraphs for easier parsing, do simple formulations and not talk
about future patches because git history is not always linear:

"While SNP is active, every memory write is checked against the RMP to
protect SEV-SNP guest memory.  A core performs these RMP checks only once SNP
has been initialized via SNP_INIT and the SNP-enable bit in SYSCFG is set on
that core; the firmware requires the SNP-enable bit to be set on every present
CPU before SNP initialization.

A core that is not SNP-enabled and not SNP-initialized performs no RMP checks
at all, so there is no valid configuration with SNP active and any CPU exempt
from RMP checks.

The firmware determines which CPUs are present from the processor and the
BIOS/UEFI configuration (e.g. SMT disabled in the BIOS) and enumerates them at
SNP init; it is not aware of the OS bringing CPUs online or offline
afterwards.

SNP_INIT fails unless SnpEn is set on all CPUs, so a CPU that is offline when
SNP_INIT is issued, does not have SnpEn set, SNP_INIT fails, and there can be
no SNP guest memory.  OS CPU hotplug can thus diverge from the firmware's
expectations and break SNP.

Tie CPU hotplug to the SNP-enable bit: disable it in snp_prepare() before
SNP is enabled, and re-enable it in snp_shutdown() once the firmware has
disabled SNP.

If snp_prepare() fails before enabling SNP it re-enables hotplug itself; once
SNP is enabled hotplug stays disabled, including across a failed SNP_INIT and
across the legacy SNP_SHUTDOWN_EX path, both of which leave SNP enabled.

A kexec target that boots with SNP already enabled, disables hotplug once in
snp_rmptable_init(), since snp_prepare() bails when SNP is already enabled."

> 
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/virt/svm/sev.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index dab6e1c290bc..04a58ac4339c 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -535,6 +535,15 @@ int snp_prepare(void)
>  
>  	clear_rmp();
>  
> +	/*
> +	 * Disable CPU hotplug before enabling SNP, so no CPU can come online
> +	 * without SnpEn while SNP is enabled; it is re-enabled in snp_shutdown()
> +	 * once SNP is disabled.  Must be before cpus_read_lock():
> +	 * cpu_hotplug_disable() takes cpu_add_remove_lock, which nests above
> +	 * cpu_hotplug_lock.
> +	 */
> +	cpu_hotplug_disable();
> +
>  	cpus_read_lock();

What's the point of grabbing the hotplug lock if you just disabled hotplug?

>  	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
> @@ -560,6 +569,10 @@ int snp_prepare(void)
>  unlock:
>  	cpus_read_unlock();

ditto.

>  
> +	/* Re-enable CPU hotplug; SnpEn was never set. */


^ Superfluous comment.

> +	if (ret)
> +		cpu_hotplug_enable();
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
> @@ -587,6 +600,13 @@ void snp_shutdown(void)
>  
>  	rmpopt_cleanup();
>  
> +	/*
> +	 * Re-enable CPU hotplug now that the firmware has disabled SNP; CPU
> +	 * hotplug is not re-enabled for a legacy SNP shutdown.  After
> +	 * rmpopt_cleanup() so RMPOPT_BASE is cleared with hotplug still disabled.
> +	 */

I can't parse that comment.

> +	cpu_hotplug_enable();
> +
>  	clear_rmp();
>  	on_each_cpu(mfd_reconfigure, NULL, 1);
>  }

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
