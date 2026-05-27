Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9073101D0;
	Wed, 27 May 2026 21:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779916020; cv=none; b=qczHr48coXJJop8m0ywxcipEErACpWlpTv0bqFYUfqi987wv+DJgFrynPAFvor3/i/VVNcRsc3YhiNEJPy9D4v9PS2YUiJlArcNwHlQQ5ZEBuG4vsIiFRsI3jpNVU2Eolrs96hneZyPMb3rnjFOhJ2Fb+mCTDRp0aPFJSCk7CRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779916020; c=relaxed/simple;
	bh=T333W9UzfwFRyZqUtUnwPK7/vCADoN8h+s30/wxT1NY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xyzs0byPnl0n2wFNTPrpffEYNLtLtx3i9zt4arlet69df2elqqUXjsJxXgqtqF9EFKYVyzkONmSb7UzPoGCk5fEKB3iuwTRP//Cz0E7+mgJLGYAa/qI52xZzXYUoUlFtSkFMWRltyLZgzILIwkoJMLmDkKD914jRWX1OdJe3xHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=MSNmsJrs; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="MSNmsJrs"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C70D940E00BA;
	Wed, 27 May 2026 21:06:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id LXhOfZMt6doO; Wed, 27 May 2026 21:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1779916006; bh=+HB2pTTn+1mGkcvaE+8Ypvs3xq7dhmSiIMi7/IobGeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MSNmsJrsZfquvctjkm4A7wVSPWQOst3IF/Ws+ghRkWMWkMP/YEKONQcC/qPpK7EiN
	 yRp3ZCmBr/nR1EJd65n9wjhmlc47wLNlTDM2Xb+CDagdckY/2uTalX0xAIP7p/pt+N
	 Pb3Og82D0J+SrNTropVuIZrgwZ+EInH0jFN804aDxxv+XlInolW/FBo+RN8bRx++LX
	 HY1dIGdOOGdqLvmuzCdKu0/w4VVGJxbGxSdvy/DN8o4wZbl8Ygjbnbel5PCFfKiefb
	 vRpl0gYl4EOrUfkmHVvVHsy3SeFZpg2A8n6oRr3Odmv5xz46w6O19qDQ6zgZhxJmmr
	 ejekiD93wbcnL1itzHQKcxtpaSrKk3OJVAl6iIhL36kYPtoltq3PYfFa/oHV2c9Z7e
	 GjAqkiMaScudmRdwI99NGe7ThOSD8VdNhJZD0S/4SJOP10Ejzzc3pU0SJcZ74Vrmrf
	 GgVinXTIIU13ofpT0UxWm/UbX2kc6ijleadMethc3GuMkl7g59iY1dSHZWFpN5AvZE
	 51X7tOq/sq7j47vcuOoIGjBz+iERbEugz583sQzIg9CAnpKOlXbAN1N89PniWOKHMu
	 b23Io7bghPsIbPOs723PXEROUXMPenr8/uRypKPWUs0OKJef90ZM8l5xkf0uUhXTff
	 1HTpp10UT6W8ircra4oNcLcI=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00:b8a3:f58e:8829:9ca6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 573BC40E01A1;
	Wed, 27 May 2026 21:06:11 +0000 (UTC)
Date: Wed, 27 May 2026 14:06:03 -0700
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
Subject: Re: [PATCH v5 2/7] x86/msr: add wrmsrq_on_cpus helper
Message-ID: <20260527210603.GCahdcu8zvVjfKfGEL@fat_crate.local>
References: <cover.1779133590.git.ashish.kalra@amd.com>
 <c9fe5c2fef063f5006cc9bfa03eec824ac015db7.1779133590.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c9fe5c2fef063f5006cc9bfa03eec824ac015db7.1779133590.git.ashish.kalra@amd.com>

On Mon, May 18, 2026 at 09:42:15PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The existing wrmsr_on_cpus() takes a per-cpu struct msr array, requiring
> callers to allocate and populate per-cpu storage even when every CPU
> receives the same value. This is unnecessary overhead for the common
> case of writing a single uniform u64 to a per-CPU MSR across multiple
> CPUs.
> 
> Add wrmsrq_on_cpus() which writes the same u64 value to the specified
> MSR on all CPUs in the given cpumask.

So let's add yet another function which name differs from the other one by
a single letter and have people go look at the implementation to know which is
which...?

Instead of unifying what's there and extending this one to do what you want it
to do?

And now you have a wrmsrQ_on_cpus() but no rdmsrQ_on_cpus()?

Because if you look at the code, you'll see how those are used: first you
rdmsr on CPUs, modify each value and then wrmsr on same CPUs.

So no, try again pls.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
