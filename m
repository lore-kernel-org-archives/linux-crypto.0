Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C224766B0;
	Thu, 23 Jul 2026 18:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784831589; cv=none; b=gIVdhMED/AbBOnXZbkscuQbzl15clrstvKNzZFxC5Y+XJmkSE0crh95Zizdc/F437J6BU91aQ96zhVSYBoFoci5vxySRMlUCIg4gLs4GH6KUGmBjlGQ6R69W9aWj8c1eGUqMvh9c/69kdkIlPK6P3Tsz28dBGTxca0rVvh7+LsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784831589; c=relaxed/simple;
	bh=KxB6Bf7QrgKpd89cxkInbDnCN4cFE5gwG52mQN8vsVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r94vjQvyV134uTEQiCVrLdmHStetvWl+jmktIc9AFN7z/u4IInuWZX3CySCjGkksM2MhY67A7HOjY3UD7udu2LzhbS3VVu/GgpMYNZMTP1rUHCGdE/Zg/AoCX4a7OiHBI1HdbVrphr/lXKnV5dpae4cfiMlTrGpjrIZ6TcUfrHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=agcbuZkP; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="agcbuZkP"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B7FB140E027F;
	Thu, 23 Jul 2026 18:32:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 6DrCDV76w-Oe; Thu, 23 Jul 2026 18:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1784831560; bh=qIGv8+++s5mjyrTvC7H+RqdRK5QUD/XRD6y9Qzv7ozU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=agcbuZkP+wJ1RYNio1jtpT6SL6H6OPPwG5tFRDveNd7ndNXYW47xGk3uekXf1trni
	 YYF7MOQQqm3eS+dt+UaJQH4w9YCONlol45UkjsVCH1aJBmRrJ2OPCslXmC+sysxWtd
	 RVgDodIui4SWL3TQSN4cQIG8u2fiUawRMmKZNk2t4oDvu9K+Km8M4M5VrwKsWVWobA
	 z7MCqUd9IB1iEBcUfo9ll43edYDXztjLbewb8ICSfwYj/choZs2sRIuxy8RMjqaG5q
	 wCI6iSDekhpiGdFzA5YFWsdvONoaU2t8rOsyikx271wZHbn9wEOX3/Xy6SXO8gQ1At
	 z50g4BYNNQUVVQlSqEDpJnbu+iLxGlRTV6OYJyljMPeM6ysp1ZsZgGdt5oW+rr51KR
	 /NxzjmLSQweq9+JN9UZ0wjKH5CHHDEp8JvW9bHJySQQ01WqdSzS6R4YlkaxaZm0qeC
	 PjbWazze1JAjO7s4wawy2rXA2FUxlwrjfs6b3QrGVQtIOv1nYht2oaaqwRxYLvWycw
	 9f2NokNRZb7CXwxSBT749bsrFuXR1u/ll2/RZNYP5OZLUxbFtOvHfIfk5CT7pYaG8e
	 zLdBx3N/N1Aj7nvQfdIOyjNIfnYHAKCR639tjHsvGd8SFECNCP9y0cqmqVTscnaYuc
	 5Kew0l3GS9numLrYV5749rBI=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BF57540E00E6;
	Thu, 23 Jul 2026 18:32:05 +0000 (UTC)
Date: Thu, 23 Jul 2026 11:32:02 -0700
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org,
	mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
	thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, ardb@kernel.org, pbonzini@redhat.com,
	aik@amd.com, Michael.Roth@amd.com, Tycho.Andersen@amd.com,
	Nathan.Fontenot@amd.com, ackerleytng@google.com, jackyli@google.com,
	pgonda@google.com, rientjes@google.com, jacobhxu@google.com,
	xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
	babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com,
	john.allen@amd.com, darwi@linutronix.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, linux-coco@lists.linux.dev
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
Message-ID: <20260723183202.GAamJeIr1Cey5clsfE@fat_crate.local>
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
 <20260723011031.GGamFqB1i4zt4Zlsx6@fat_crate.local>
 <9cfe76f4-8e16-4b21-a414-126a06859489@amd.com>
 <20260723051422.GGamGjLhlTqRDcFlee@fat_crate.local>
 <5460b946-b511-4060-8951-264d17a2b21b@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5460b946-b511-4060-8951-264d17a2b21b@amd.com>

On Thu, Jul 23, 2026 at 01:50:48AM -0500, Kalra, Ashish wrote:
> > What happens if you boot with a subset of cores, the boot flow enables RMPOPT
> > and then you online the rest?
> > 
> > Have we tried that?
> > 
>  It can't happen here. snp_prepare() does the following, in order:

Then the comment in the code is greatly misleading:

        /*
         * The RMPOPT_BASE MSR is per-core, so only one thread per core needs
         * to set up the RMPOPT_BASE MSR.
         * 
         * Note: only online primary threads are included.  If a core's
         * primary thread is offline, that core is not covered.  CPU hotplug
         * is not currently supported with SNP enabled.
         */     
        scoped_guard(cpus_read_lock) {
                for_each_online_cpu(cpu)
                        if (topology_is_primary_thread(cpu))

I'd expect to read there:

        /*
         * The RMPOPT_BASE MSR is per-core, so only one thread per core needs
         * to set up the RMPOPT_BASE MSR. All primary threads are online,
	 * otherwise SNP would not have been enabled.
         */

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
