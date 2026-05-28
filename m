Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192653F9FB;
	Thu, 28 May 2026 00:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779929080; cv=none; b=HZh4j86GzsFGaqa8YL0Jgtp9xIZzygWoGay0f7DroIlwJilvQNTqKfZrw0HxyGf1pNZvBhrh0oxaMfTwFXcsKFE3mu8gAP5Mh9d6dw2RVlym/sJV70aUXUWTs8Wra7aqb4CfZ3KUsU8kDTa/hjzpvEp8nLc6YPHdmtzCSKvK4No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779929080; c=relaxed/simple;
	bh=bDTrfEuwom6i5MThXI5R1UwEnTXDV0vKQACpDJnvGh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AiSAct87iI1z73DH1qBTGhr5wqeDpKwY0nDhHGidIaS3Q2Mcj7R/F44kAUGYedFuFG2wm0QQqwmt+z34r3UR7PMGH9Yj2BhUbKFe+6lORG52VNioMxAHUTXy1SKdkgrf+Py1UUKt15b+F2rxMa588PvEBu6ztjWcbntifUrXvHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=OrncL6jv; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="OrncL6jv"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 38FC440E01A1;
	Thu, 28 May 2026 00:44:35 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id KR4e47BzWvud; Thu, 28 May 2026 00:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1779929065; bh=AaWMBYTf75iaPkQ8SFSigt2tHVLgPRWYvQ0dA7Bz0YA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OrncL6jvU2vsKhSsUwU7nlF7luLIEvDiLKsrYxqPzQg2zwqBwjGUdRPg+/kPProId
	 hN+5WEsnYO1eqnVnKgrEt/zJkiTQ5BbBhQXG17u+eXAzZ3hjvAvOYGsuVoxCuX77Q7
	 EIJr5y1/o+mprpbqNY5vBu4dOVw5Kx561JDaTabvTNGWdc5Iba/e8DkUQ91INeirVg
	 QTxGVGbx1HsuI58iq/5Rj5cqMQv2eI4W1spJvpm+yAKMaIKgQtniAAZhGeAvPToP/b
	 71QBH0qRdpfQl0xtxjO6izjnivOC2yTD7tNTjKCUFxHfWGQZ4O+fI2sGe2Udc6zAvS
	 3lanrSpvvQtZENPj+ASpudqGY1XLfGFc+xyIqWoS3XARVqgXfwZ7nHkqWBxXupKbtZ
	 pmj2Q4zvTQyDvBSRxNiEBWDMHUR//l4GnF5DQ25q+wvm0JDFLo/GRF2bWjvibadahv
	 bQGt78AhbbbJ8GVhH2xSjCqjQ6cmijfWyu7rTgVeJFVW7kUF9rcJnX+XAXsX+JGlU3
	 VKoMJaB9zi1SNMAV8wh/o+cjrDYo53hcWJYinGqaH2KvUR7tclHjI6h0NvNGYHx51E
	 Nmn8yCL4FUwNa3Y8Hq0wGaeEaeHFzg8+bQWUVIfr503YE3uwDYEJTCyTMC4spgYqNd
	 vfzCDnbZC6zeUwCM+mkcppbA=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00:b8a3:f58e:8829:9ca6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0928340E0031;
	Thu, 28 May 2026 00:43:49 +0000 (UTC)
Date: Wed, 27 May 2026 17:43:32 -0700
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
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
Subject: Re: [PATCH v5 2/7] x86/msr: add wrmsrq_on_cpus helper
Message-ID: <20260528004332.GDahePtGqVp2boiEJL@fat_crate.local>
References: <cover.1779133590.git.ashish.kalra@amd.com>
 <c9fe5c2fef063f5006cc9bfa03eec824ac015db7.1779133590.git.ashish.kalra@amd.com>
 <20260527210603.GCahdcu8zvVjfKfGEL@fat_crate.local>
 <eea0497f-6930-43e3-947d-dae139e657ad@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eea0497f-6930-43e3-947d-dae139e657ad@intel.com>

On Wed, May 27, 2026 at 02:38:05PM -0700, Dave Hansen wrote:
> This one is my doing.

I know.

But hey, maybe we should not disagree on the public ML because the submitter
might disappear like the last one. :-P

> wrmsr_on_cpus() is kinda a mess. I think it only has a single user. It's
> also not very flexible because it needs a 'struct msr __percpu *msrs'
> argument where each MSR has a value in memory.

Right, we did that a looong time ago.

The only reason I'd have for per-CPU MSR structs is reading different MSR
values on different cores, modifying only the bits you need and then *keeping*
the remaining values as they were. And that interface allows you to do that
while this new thing won't.

And I'm going to venture a guess here that adding a simpler interface which
simply forces a new value ontop of a whole MSR could cause a lot of subtle
bugs when people don't pay attention to keep the old values.

> The use case for RMPOPT is that all CPUs get the same value. It'd be a
> little awkward to go create a percpu data structure to duplcate the same
> value to call wrmsr_on_cpus(). The RMPOPT case is also arguably
> performance sensitive since it's done during boot. It should do the IPIs
> in parallel.

Oh sure, my meaning was to create something that serves both purposes.

> toggle_ecc_err_reporting(), on the other hand, is done at module init
> time. It's not really performance sensitive. It's probably pretty easy
> to zap wrmsr_on_cpus() and just have toggle_ecc_err_reporting() do
> something slightly less efficient.

Sure. That's fine.

> Yeah, the
> 
> 	wrmsr_on_cpus()
> 	wrmsrq_on_cpus()
> 
> naming pain is real. There's little chance of bugs coming from it
> because the function signatures are *SO* different. But, it certainly
> could confuse humans for a minute.

Yap.

> But the real solution to this is axing wrmsr_on_cpus(). 

Yap, for example. Basically reingeneering the whole
write-MSRs-on-multiple-CPUs functionality is what I meant.

> Which I think we could do after killing its one user which the attached
> (completely untested) patch does. The only downside of the patch is that it
> does RDMSR via IPIs one CPU at a time. But, looking at the code, I'm not
> sure anyone would care. If anyone did, I _think_ all those MSRs have the
> same value and the code could be simplified further. But that would take
> more than 3 minutes.
> 
> It's also possible that my grepping was bad or I'm completely
> misunderstanding amd64_edac.c. Cluebat welcome if I'm being dense.

Looks ok to me, we can surely do that. I even hw to test it. I think...

> BTW, I also don't feel the need to make Ashish go do any of this edac
> cleanup. I think it can just be done in parallel. But I wouldn't stop
> him if he volunteered.

Why not?

It has always been the case: cleanups and bug fixes first, new features ontop.

So yeah, modulo figuring out how to redefine the *msr_on_cpus() interface,
I think this all makes sense.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
