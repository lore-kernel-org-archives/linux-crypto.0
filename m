Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F2517C203;
	Tue, 21 Oct 2025 03:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761015636; cv=none; b=ZgJwYduulZv4tznUayIIFwL/kVC9/1Ok7ommQpHfOjLgkZ4xH6cy0XEcNBDrBCNWtwHGFN++uyE3XtH3It44Eo+QydV8nNRJ/nPFSn79Kqh6oHweqowFjMgq3V7kKxeetG2xa8RgeCWz1e1p/7exsE7EeVfnxRTi/i1m58/7fp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761015636; c=relaxed/simple;
	bh=pZLw1BYY4GG+r6eFNrq0J6KqLHiQ3DI35mbAzggqfNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OqeL2yzhf/uVuLYjr+0NF1xEmBHU52Z6UEs5zrbskN5I8quVSpoopZCz+qg8PdsDnRUaEgaPI9AVzaPqjogqHoi7pPjLMCbS3fTtglZjxb3olG/mPxvwT/rLx4zA/HxPKpm7aej8PPuYksPyfXbsGAVduRMtDIHUjoMykbpM63o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=T9xMBzo4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="T9xMBzo4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ScihMxZa44CqpIAxAUJyvKAr8hHW0Z4MXIDH2CVK1LE=; 
	b=T9xMBzo4q37Z6kFU2ZPI6CytiCrODwHhR0YZT4Qd+At8FGb/7MVfDtOs5T5qx4CFEx8LGEmmsDi
	sTKB1NaGI9uwA/9+CgYy5Uab3gU1pFCFxenXHwST7ZUKimZIvLRJ0VadFT8H37C7sjF5vrV1BcE2Y
	oMl+CvB1uEPF8L/Wawcnz+X9muViPAC9246yVw3ZobcdQPJa/hIIPL+slQ+H5CcGWcoY44nL1e1/l
	lk/CaVmMBdir27f78FcUGa5bXFtVrXQUrky++GrjDXxSU3R9fVCyWrfjbKfIPBwUUS7AYbGQwrx2B
	8xwzZIfEskwLOOsKf/KUZZmpp/qgLGEgynIQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vB2br-00EDzB-0l;
	Tue, 21 Oct 2025 11:00:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Oct 2025 11:00:27 +0800
Date: Tue, 21 Oct 2025 11:00:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, Jason@zx2c4.com
Subject: Re: [PATCH 0/8] VAES+AVX2 optimized implementation of AES-GCM
Message-ID: <aPb3S6I_tyb1zLjt@gondor.apana.org.au>
References: <20251014003123.GA2763@sol>
 <aPH9ZQP0m8Pq5Iy-@gondor.apana.org.au>
 <CAMj1kXGE6-xiUSyKa92=HWeywt=5-F2_G2H7V-UnVhKG65zwCA@mail.gmail.com>
 <20251017160437.GA1566@sol>
 <aPW2_B3utVHNxaEV@gondor.apana.org.au>
 <20251020165758.GA1644@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020165758.GA1644@sol>

On Mon, Oct 20, 2025 at 09:57:58AM -0700, Eric Biggers wrote:
>
> Well, one would think you would be subscribed to linux-crypto.
> But whatever, I'll Cc you explicitly on future patches.

I never said that I'm not subscribed to linux-crypto.  I will eventually
see it, but it could be too late if you wanted me to action on an item
that's only in the cover letter.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
