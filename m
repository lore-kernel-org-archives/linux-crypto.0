Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2700130C16A;
	Fri, 29 May 2026 00:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780014432; cv=none; b=ug8Mp+cHovCUwbrq2D1k6I8XHAqJfdOfw22I90svs8z3ZnOOsur67YRR57Mn0tzL5R4YKiQMv0sqvlXiUOI3QkoAzTrXAI512THy6GD/WgmNZ0vTFRLEeFO0lCTua/oqX380VBazUcp/94qURQpP8mDxyUH6u9piySp36RB2G3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780014432; c=relaxed/simple;
	bh=BLOUUxDdMzRr8p8nw/2Rlw6biIQSWT8cREBTJaKVGpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GsyoncAVk8+gPefyZ9MAUV0dc3PJZB7hGmK+vFrnS7SZmWiUkK05iEdvGYpFH5NYyofKQC2nnKktHNApvT3pBe9K3JwqJblHcUFMdJIFOzvXI0TYYRoaBoskUG2yR8NnR3oD6vLjgt5ZEtFdRIXwpR0LrgLAZsvrSGytLas5HHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Jji2aNSG; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Jji2aNSG"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7DBDD40E0031;
	Fri, 29 May 2026 00:27:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1y33qEMGB7YA; Fri, 29 May 2026 00:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1780014418; bh=APG7CvTk1QbJp6QkwE4o/fuROSyJFFsXAS50wfSJgwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jji2aNSGDeL47d7jGI1HCXkkIG0J6d46UVxTqKw2LIc0Ojyqs9SV4aSYuKbZfMQLE
	 Ek/+C3QbFKW7JCaI6m1c7CgSurdItnalZCyHjkmM9VYpu9xltpd+g1BjRR48E0Itg/
	 sHLDPMlLLrR9wxBp77hyb9CYOu612kg3wLsHhOTMKDLLVOiElaO7Bv+g9zLX0q0Xyr
	 x9sCEjadXmUIvsg+NikcYV6W88c4SDNqR0d8+aVfvS85+/iBt9hFSVuHkt2N7boJAV
	 xwrfw8Zo474ff295zxcvhfZUJoDXDYoZcoDn4iQ2oddxR388aNHqL/xDuJxeQGDTQD
	 X3M0QB/N/bWKNrCkZxmhPV/JN8EWBoWTgsmQKnra05cg9HNymJzHA0vSB3vxXjUk8H
	 qGT7wyau/sW1Wmc6KmMIlJPFBLY3zVYCdf6gG43QSvkdprHYmAMY7P97BTaoyI3IuP
	 1Jm7dbBC0r1gAIu2AFKQ7hNFGlfxSq0rpLOZfa9mefZg/9/6Q+6XhYUmS0v3cEe1Nh
	 mdxiDGvfE2S1oyq4pkAfXfdionWDWQjEbmyJk1KucdjPtR9IhoUrrvTJZvVMW8hBgF
	 YyipuNDCXNgZOSmuxlGJ/S3BbRMa32TlTBlYhjFNQHYvCLqe00YYy+X62RtpPdb0cq
	 SvQnFK1drPC51L4OXJBtddtk=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00:b8a3:f58e:8829:9ca6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2DBF440E0032;
	Fri, 29 May 2026 00:26:22 +0000 (UTC)
Date: Thu, 28 May 2026 17:26:13 -0700
From: Borislav Petkov <bp@alien8.de>
To: "Kalra, Ashish" <ashish.kalra@amd.com>
Cc: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
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
Message-ID: <20260529002613.GEahjdJRsX2uNz0GnH@fat_crate.local>
References: <cover.1779133590.git.ashish.kalra@amd.com>
 <c9fe5c2fef063f5006cc9bfa03eec824ac015db7.1779133590.git.ashish.kalra@amd.com>
 <20260527210603.GCahdcu8zvVjfKfGEL@fat_crate.local>
 <eea0497f-6930-43e3-947d-dae139e657ad@intel.com>
 <20260528004332.GDahePtGqVp2boiEJL@fat_crate.local>
 <2d164e19-5cc6-47ca-9150-f4d432dd10c4@amd.com>
 <c40dcb8c-5706-4c0f-ac85-c22957b9e192@intel.com>
 <3334a64a-9a5e-4ad5-94f3-01fef788df2e@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3334a64a-9a5e-4ad5-94f3-01fef788df2e@amd.com>

On Thu, May 28, 2026 at 02:55:44PM -0500, Kalra, Ashish wrote:
> Hello Dave,
> 
> On 5/28/2026 2:50 PM, Dave Hansen wrote:
> > On 5/28/26 12:37, Kalra, Ashish wrote:
> >> A simple loop would be perfectly fine and avoids the need for the wrmsrq_on_cpus() helper entirely:
> >>
> >>   for_each_cpu(cpu, &rmpopt_cpumask)
> >>       wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
> > 
> > I'm glad we're on the same page finally. I just hope we can get to this
> > point more quickly next time. I started off with exactly this
> > suggestion, but someone chimed in to the thread and said it was "slower":
> > 
> >> https://lore.kernel.org/lkml/6a50d050-f602-43fd-a44a-cecedd9823eb@amd.com/
> > 
> 
> Yes, actually i should have made it explicitly clear that we need to do it in
> parallel especially for issuing the RMPOPT instruction itself, as that is
> in a performance critical path (and for that we are using on_each_cpu_mask()).

So which is it? Do we need the wrmsrq_on_cpus() helper or not?

I'm confused.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
