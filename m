Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFD613C81B;
	Fri, 21 Feb 2025 03:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740110036; cv=none; b=TGanfkwvGiMxM3aIaG8cnV7IT/BS0SVs/Ranf9FjSZBdyjv2AJz4HqJ7r+8UO+UsIBsOMktJ54yNDriujndsPZ8Vw8/a4Dzk7tfXpQmpozvUMI7mSnkM9oPnoAou9QfJ7EOERsSIs7Mrrbc8AtwAPwkYyZMzYBXUfjLas5Wcem8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740110036; c=relaxed/simple;
	bh=PUK5zs6uAFpIbb3BiVE5tGRgE1DkPqRRYNHMSZiGn4k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=O6BhgohJ+JukDPu718rFpkSlfuo5rYFrbBgStk4D8POjb2BL48GEi//ahQNI+xmBe6DLFwg/9yQD0Mz95p1qq60VsLt4++nfsx8n1eNXSS1fRY66hL8EXKS4gtV/1XDSPZOu/GpbhRNNlYbEPKdYiM2a0TPNBsa2GWA7Wp1in/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IuecNsnS; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IuecNsnS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=c0nwzZmCi+KS9iVsgfiBHH2SVQ02MIT2YIxlBiTfoM0=; b=IuecNsnS3dEGD5iib/vv8WdaSK
	Y3Q5fPelOpJfceK4pqWaR7Qu5BgW67XA1jotVEVx+fMOlkkQ3W4UrhZzT3/U6A19QpjYfrJwafK7w
	EzBE1/04rRWDLLDI2N7eIPIuh4X3PwTIZxJK4Y35WqPnyPKWPfVll+O8Htm17wlZJ0amBaPGHpxiD
	yuTLOabRcrrLtlHghyaljAospxRRwXpqEDGG26TZELNxzZGOlNn+OCEwlD5NRXRFiaH6mEkze40bA
	dFnRY6/QRIX1TDq5PbEVzk0JEKYZiNkWFxD7miKZ6be26TSaRmPm+vs9gxTj14xX0cL1BHI8y7ka8
	M04+qLDg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlK6m-000V3s-1w;
	Fri, 21 Feb 2025 11:53:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Feb 2025 11:53:48 +0800
Date: Fri, 21 Feb 2025 11:53:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, ardb@kernel.org,
	greearb@candelatech.com, shaw.leon@gmail.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	luto@kernel.org, Jason@zx2c4.com
Subject: Re: [RFC PATCH 0/2] Eliminate the no-SIMD en/decryption fallbacks on
 x86
Message-ID: <Z7f4zNVoVB1jamIP@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220051325.340691-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> The patchset can also be retrieved from:
> 
>    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git x86-softirq-fpu-fix-v1
> 
> This patchset fixes a longstanding issue where kernel-mode FPU (i.e.,
> SIMD) was not reliably usable in softirqs in x86, which was creating the
> need for a fallback.  The fallback was really bad for performance, and
> it even hurt performance for users that never encountered the edge case
> where kernel-mode FPU was not usable.

Great work!
 
> I also benchmarked bidirectional IPsec, which has been claimed to often
> hit the edge case where kernel-mode FPU was previously not usable in
> softirq context.  Ultimately, I was not actually able to reproduce that
> edge case being reached unless I reduced the number of CPUs to 1, in
> which case it then started being occasionally reached.  Regardless, even
> without that case being reached, IPsec throughput still improved by 2%.
> In situations where that case was being reached, or where users required
> a synchronous algorithm, a much larger improvement should be seen.

You would need a situation where your CPU is maxed out by your
bandwidth, so on a physical box these days you would need 10GbE
at the minimum.

However, I used to be able to easily reproduce this using virtualisation
because there the bandwidth is essentially unlimited.  So perhaps
a KVM guest with a single CPU doing bidirection IPsec to the host
should be enough to reproduce this case.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
