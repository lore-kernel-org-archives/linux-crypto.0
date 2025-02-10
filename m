Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E44C24FC04;
	Mon, 10 Feb 2025 21:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739221266; cv=none; b=AiN38oAgShAQME/hzZYO1K2GPM02xIhR8YOyHsQUIu1SxRzD3FV7HS2V11vsci1fkg3A9S5kc/wCKVrQAVegjLGT9TeQ1A/U7Lp/EqyHO/1VtMRK6NawVh5wETdCk3s23mjMPEzX4gBr6gaXE93aaEUgewIkyH/CJg2GBlTu43E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739221266; c=relaxed/simple;
	bh=rX+CaTOpnNJBe1N9PKxEsitkWtEz/gGzmxnSAcK40Xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kVsqfF2iE+3k8BKcRek+3v6BBIIfnZPORwCXmWLo/HopqFfFpIGuspz74HCfeqjf08v4xZXqPQv+VjiGs1K1fqosTniuS6QPPqZwuy9bmP0U7+NziaL0naw/feFOwe6u/d3XFHI2d4gcZ0h4Mz7igzmuNAXQ3T/EDDOffbG8KiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UpAXrvlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UpAXrvlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DD8C4CED1;
	Mon, 10 Feb 2025 21:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739221265;
	bh=rX+CaTOpnNJBe1N9PKxEsitkWtEz/gGzmxnSAcK40Xk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UpAXrvlN7MQ/riEQ2sH+jppapm4Ib9thD1dCRHJO9WGPE7VW+7R4WotpK2w/HYUng
	 EeOsOcOxX/kJ15PRfYbrbM6zzp/jBa1OAMRr5mwTiR34Vs4BwdV9pko1Zyw9nPCDW/
	 IoEWjydlK6hSxzI3xi9FVOAQhoHjvn7o0w2eCgGGCyz/9BufxdSvVReZaAOHmmTfMa
	 uQYvp0AIuwkFranpmOFIR/Fcf8dGsmRnIec2bErLaUaJLCJlQF15X7T0hbvSQ7Jrsz
	 eJl1lROJpSa/VT4bxa6sKEm7x2y7bEwukK5GJaPAMcwoJvXA4umruPiJXMK/2HXHJy
	 2FCdZPyl99Apg==
Date: Mon, 10 Feb 2025 13:01:03 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org, linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v4 1/6] x86: move ZMM exclusion list into CPU feature flag
Message-ID: <20250210210103.GC348261@sol.localdomain>
References: <20250210174540.161705-1-ebiggers@kernel.org>
 <20250210174540.161705-2-ebiggers@kernel.org>
 <20250210204030.GBZ6pkPumjGQMaHWLb@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210204030.GBZ6pkPumjGQMaHWLb@fat_crate.local>

On Mon, Feb 10, 2025 at 09:40:30PM +0100, Borislav Petkov wrote:
> On Mon, Feb 10, 2025 at 09:45:35AM -0800, Eric Biggers wrote:
> > @@ -1598,11 +1578,11 @@ static int __init register_avx_algs(void)
> >  					 ARRAY_SIZE(aes_gcm_algs_vaes_avx10_256),
> >  					 aes_gcm_simdalgs_vaes_avx10_256);
> >  	if (err)
> >  		return err;
> >  
> > -	if (x86_match_cpu(zmm_exclusion_list)) {
> > +	if (boot_cpu_has(X86_FEATURE_PREFER_YMM)) {
> 
> s/boot_cpu_has/cpu_feature_enabled/
> 

$ git grep boot_cpu_has arch/x86/crypto | wc -l
87
$ git grep cpu_feature_enabled arch/x86/crypto | wc -l
0

It wouldn't make sense to change just this one.  Should they really all be
changed?

I see that cpu_feature_enabled() uses code patching while boot_cpu_has() does
not.  All these checks occur once at module load time, though, so code patching
wouldn't be beneficial.

- Eric
