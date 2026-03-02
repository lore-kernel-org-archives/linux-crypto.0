Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A36326952;
	Mon,  2 Mar 2026 21:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772486439; cv=none; b=ry3cZ77XsJ2sUYn/fvOeIP1t4hHzokDD20yvqcOClQyf4baGvT/3svSi6CLFpOf+An2z3HzfAHReg+//sdbN02iNOb1dS1TE20XF4RfRDXqTD+RBHiw2kJ/c840KKEQbeZAXvux33kcoZsYTd0F8J86uz90J6k8hhwQGxabYC6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772486439; c=relaxed/simple;
	bh=YGALtDZlEiD2F1T9KtPan3LNnqM1FDj8xY10c0Wlkm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W+Ggcpq5m1ZvENg12bsIsj1lDx8nZktQebaEoL8YfoPd5apnOhHzIuS768g8BdbMW5/uJUlDQfSEKbjwVpoThZ9ibTLGWKl+wCgRj0uWRREngSoEhCk5m1sqxSbHeT9InJUc/vVzjHeyGgdQtQxXh+dfSRiOl5ahICRWxOvasEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrAKQVys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrAKQVys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C27C19423;
	Mon,  2 Mar 2026 21:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772486438;
	bh=YGALtDZlEiD2F1T9KtPan3LNnqM1FDj8xY10c0Wlkm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lrAKQVysVibqoBBDvK32W+UtmBfwhDTgkU4caaXs0YlSmgTwV7PM6me8HUIrNoBg6
	 gkxqhFRh1txnPiK9ju34RrgrSsf+yr+C8SigVSbz4ECjpi3JyVRXEAnNnt3K4oVjl4
	 bINVRc+e0XOd2zHjxwSC8r4Wl3Dv31RvQ9lD+BXvBj3kGQsh//U3OIGd20z9H/LUEs
	 jRn9mY62lxWR2P1PljbzzE12cJ+2BfIS9zrAPO59aQqJMMMgY2iNkeA+/Rqz+raxIx
	 3TvIj4HWeoBtjiTUaSOfnluG84DL6RoQnpNgG5W9iW6wMr1xhXnAsGgidrDZXV4Z/Y
	 g8JK1KEQ6kw5g==
Date: Mon, 2 Mar 2026 14:20:35 -0700
From: Tycho Andersen <tycho@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 09/11] x86/snp: create snp_x86_shutdown()
Message-ID: <aaX_I1QKxeAj7iY4@tycho.pizza>
References: <20260302191334.937981-1-tycho@kernel.org>
 <20260302191334.937981-10-tycho@kernel.org>
 <b3beeb84-51e3-46df-8b9b-8808f478c408@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3beeb84-51e3-46df-8b9b-8808f478c408@amd.com>

Hi Tom,

On Mon, Mar 02, 2026 at 02:35:38PM -0600, Tom Lendacky wrote:
> > +void snp_x86_shutdown(void)
> > +{
> 
> Would it make sense to check for SNP being enabled before calling the
> functions below? I realize each of the functions in question will do
> that, but it could save a bunch of IPI's with the on_each_cpu() if SNP
> is still enabled. Not a big deal either way, so:

It is guarded at the call site by:

        if (data.x86_snp_shutdown &&
            !WARN_ON_ONCE(syscfg & MSR_AMD64_SYSCFG_SNP_EN)) {
                if (!panic)
                        snp_x86_shutdown();

but we could push that into here to protect any future callers.

If we require a v2 I will make the fix.

> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Thanks for this and the others!

Tycho
