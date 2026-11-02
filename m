Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.109.113.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630929;
	b=NL1qS29Fi0svbsgbywMeLT8ogBINrjAdX9eXGhhZDtNUTW8k/NsLya7HK068siEf0UNp
	 MDCKSR8+Pi7hNFWJiNoOyC8hE57fZd4/4v7bwGjbSZo7kts2aw5c5APz0RzSVABuoH/xX
	 HDM7grF/44roXqNRUV6fEf4nV8t0wQOQ1AEqBCkz57A9ZmoQ+u3fBmn+TM6kMeanBu9N7
	 wDhu/zpl37oOLjPH8q18ui+F02JJLpcwT+ILOlUNw2uiYGVeqtYnZH+7lJXHZ+trChNGH
	 UJIoS+WiGxfad4jFpXJlPvz8fmHMYFaN+9qnYNdJ+NcpUwT5HAWjfdB9GRyMDeKF6tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630929;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=kTl2tYFK2rIvSoC4+0aJLJGloAG0Iver2j5Lm+e9Iik=;
	b=oZDT6caOSZ1c/qI7JXOeIFSVYsxKU5XfzO3eH1NjBRrP9xkLVMxYdiwCQBMPAFM4hVh2
	 LCMSTW548yZVi5tYlur8w2gZI9mW4vFmbSNRmbLReNIUjnUiGIz3vey5kbFjHuqX4v8hc
	 RBJLeJTZU1aolomhDUUm8Ct7saYhM2csQS5+EAil1oXeY0mFDKP6ach5KMHUg9P2AmNT3
	 /VNb/dLuKE1zA1Z7NS+W07uxXOqbYiCoKqTj9DPbWcbloXhAQAXb4525TuG73y2lZ6t5M
	 z3YUxW41e2fSDRZlJlwqq6i9cOFoDgmxCBs9ZrrlL7LAjGeaY/cfegJM+3cOS3bpQZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alien8.de;
	spf=pass smtp.mailfrom=alien8.de;
	dkim=pass header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=kNFL8Leu;
	arc=none smtp.remote-ip=65.109.113.108
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77B5606ABA8;
	Mon,  2 Nov 2026 14:48:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B77B5606ABA8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=kNFL8Leu
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C2C0840E03FF;
	Mon,  2 Nov 2026 14:48:45 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id LXL3UopgkXRM; Mon,  2 Nov 2026 14:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1793630922; bh=kTl2tYFK2rIvSoC4+0aJLJGloAG0Iver2j5Lm+e9Iik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kNFL8Leu+qyoWZWcejy2EkZ4B6XrgXCuWGQjIlku/BCZLjD7tbCav0+UqrhjlXbSd
	 Ee2/AETOZQ+jWeQk12Pv4JLq9Q588l+nn+XJQ9PIXf1BXDzvtJGuBqxwqq+fTKW75E
	 0ZDmJRZkjcyePUub+AttHlbBLgFdBta2aIeE8DJ1B3HlQgthWfWmENzgkE3CS2pivd
	 RmbeaSz9UQf32FLtbLxf5gO5Xp11K9qPyynRL35n632cVq1QA4m49YIGneDIPaB6Cp
	 0gQPq6JznE4XCRaGDY3qKR509+h2DZ+9BeAhHFNhbV8lNUH3v5kwdEYphpTxN8a/+u
	 sKKWpLHQ4FBMpYpQbNfdCIolwn1RztsUVy150FVi6ivi02cHm7VIl9ymBdrMTjGo93
	 3OpuKo04RkWwd+yEsJ7m3XOibqcKQ7Vt3K2eXOQ/f9pwSoTCmcyBAQbFmSBgwLxuNT
	 Q66AYINwtJNM+6t5hHEDtMDuEuSdzSandJM0qBwpTC4WXP95T7PL4ahyqxOERuDplp
	 vQ3TBPP0bVu7sTYbQTdclQ4JgAJSZPY7qV411F9ACTkkL2Cfhc7GWVVasxxaf/xKyo
	 TFYBZSRZpCVR+ooGgGfeC4AD3mFBldaNU9l7C2wkEfSuaybtpuVx0tgiCyBJuLokkJ
	 Q5vXGtNR2dsA1IC5h2ysu+ew=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A7C6940E03BE;
	Mon,  2 Nov 2026 14:48:08 +0000 (UTC)
Date: Mon, 2 Nov 2026 06:48:05 -0800
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>,
	Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
	herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org,
	pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
	Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
	ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
	rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
	pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
	dyoung@redhat.com, nikunj@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v4 1/2] x86/sev: Clear RMPOPT when segmented RMP is
 disabled by firmware
Message-ID: <20261102144805.GCauiipTaEXcg6Lr59@fat_crate.local>
References: <cover.1793216372.git.ashish.kalra@amd.com>
 <56da047d63b22f03a7e709fc172a5543da894d67.1793216372.git.ashish.kalra@amd.com>
 <20261102052841.GBaugfibOXxGorZKgq@fat_crate.local>
 <69ed0d93-f96d-4baa-a587-fade5a0a3262@amd.com>
 <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <414b2fc2-a55a-4b2d-ac70-4def101c4aee@amd.com>

On Mon, Nov 02, 2026 at 08:12:16AM -0600, Tom Lendacky wrote:
> Heh, I don't think that is a nit, it is broken.
>
> I think the code as it was read fine, but that's just my opinion.

Lemme see if you like this more (pasting it in applied form because the diff
is unreadable):

bool snp_probe_rmptable_info(void)
{
        if (!cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
                goto out;
        
        rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
        if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
                if (probe_segmented_rmptable_info())
                        return true;
        }       

out:
        setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
        return probe_contiguous_rmptable_info();
}

No repeated code, no if-else conditionals, just what needs to happen.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
