Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22433D16EA;
	Wed,  8 Apr 2026 14:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775657217; cv=none; b=rieUUmoZWo+R5iS76JThqTpQ+Gbg5uXnDTHJ9jrzopsoE9Zd8m+XSUVz3Jix9R6SPE0bZZJI9viaNuQa4vDne7/6hMzW/5pJF/q/UrALlVLoe1HV5wWotCP11SlH++jvns1hs20C+MfiVJBs0LHVtJ5CH1NKTW527KvxJJ0r33c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775657217; c=relaxed/simple;
	bh=nVPN9n46FRLlu7+p+YjcOBDmYKxR4bWaQIWMioUe+CU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBz5cp2gwJnWn/SZ+2L3Wjr0e9WSUJRHOkJmB4My8LU8kl/aNL/Q6Zpl7MBHNEe1DnNyUusitAinPKF0wsUzJ3CMhjgpmqlYVqBeuBaQqfFN4t9Pg0fCxtP8vzX+3VRj1a/JAKkfqlvuJlIpSOEtR/9Ondw49z7EdQsk9Kr37Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6gMYjXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6gMYjXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7166CC2BCB0;
	Wed,  8 Apr 2026 14:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775657216;
	bh=nVPN9n46FRLlu7+p+YjcOBDmYKxR4bWaQIWMioUe+CU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i6gMYjXcG6U5kU9xekWPnqieahnULEf0SfBahQfyREyshPaC5ilVtgvEwKHtmElWY
	 tG3e/fLadAqPP3sXhEQbdpCjnRt6SLHEVXlanZME6GB1dsWqqac7sUvU1Wzb2a8tq7
	 7y92RbIEUxQ3rs/HaTOwo9Jnyt3kWy/47JA+z2+jYDyakPfoZuLyU+Mpqlsqg5jdS6
	 PKi/3YH7nPBjB4s1iOH904xLDJJuT0HZvVmoXLCuffmSLEFN7ocKRBS9Vd/94gaQtl
	 rkDbrAQalzW4qSwMUzidxkc9G9zaPwMslsy+7/A8EN7wImvFulT40JApGEy20+Leza
	 sGBTdEiIcCWLg==
Date: Wed, 8 Apr 2026 08:06:51 -0600
From: Tycho Andersen <tycho@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ardb@kernel.org>, 
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, Kishon Vijay Abraham I <kvijayab@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Kim Phillips <kim.phillips@amd.com>, 
	Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 2/2] crypto/ccp: Skip SNP_INIT if preparation fails
Message-ID: <adZgbOx6-JPhKMU-@tycho.pizza>
References: <20260407174713.439474-1-tycho@kernel.org>
 <20260407174713.439474-3-tycho@kernel.org>
 <d4f82d48-6f80-4e19-afd8-6f3df5a6d267@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4f82d48-6f80-4e19-afd8-6f3df5a6d267@amd.com>

On Wed, Apr 08, 2026 at 08:17:44AM -0500, Tom Lendacky wrote:
> On 4/7/26 12:47, Tycho Andersen wrote:
> > From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> > 
> > During SNP_INIT, the firmware checks to see that the SNP enable bit is set
> > on all CPUs. If snp_prepare() failed because not all CPUs were online,
> > SNP_INIT will fail, so skip it.
> 
> This should probably be more generic and state that if snp_prepare()
> fails for any reason then SNP_INIT will fail, so skip it.

Yep, thanks. I can send a v3 with all of these fixes.

And to preempt questions about sashiko:
https://sashiko.dev/#/patchset/20260407174713.439474-1-tycho%40kernel.org

The first one is bogus, but I also got it from AI when reviewing this
series: the previous code returned the error from the firmware as well
and killed initialization completely.

The other two are ones that were previously reported, I have fixes for
them but have not yet posted...

Tycho
