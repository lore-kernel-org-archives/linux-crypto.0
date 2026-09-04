Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B75378824;
	Fri,  4 Sep 2026 09:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788514195; cv=none; b=OqSVpuxtfzN3r6vAlYykfhX/0CoxFDkbVeG594erqCmIebzKan5lNiLcpdLVCbYwzX7mo0BL6nl39fepZa9vYkljlAkyjMD0ZZZp5tbxPLRRX1QS9eW2HG1UG10BQSm1LNGm3RE/S9qiOCs8022ayu83AeV1j0irYy1U5CGKpek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788514195; c=relaxed/simple;
	bh=P8LmKQms1gVmwAIyeQorRqaWdAowLRObdTgwPpZRWvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dLUfre0mxPR45Z+GThUEyAw/E1Pw8h0bv8auYSLZylsYPmjB6TfHFZbnQkteOkVTB5V1hrd+b92FhK3HgnVAsBS4MnMZnALLRdkiqy1eH2G/lx+rw74hTOtjP0qfmiXEwof+i8y9ytfvauI9SPJoq7fsHCgAfaqwzj7MGaMB8Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=pzpW1CqI; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="pzpW1CqI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=s+wFOwox1ZzuXpljuka+wh+45j6pHkY87YsvLOgchgY=; 
	b=pzpW1CqIdFkrOC1GuHC3Herwi8R29bTcX+vzFyDhRvo1NzRzpMvjHm1PcRlrdCXrUyuxZHmkEN2
	KjElJ6FCbhi3342+cqsvTHlw4AAeieg03KtXHkjxip1NTMeXL0+EQREjilJe0XSMvRYUrRXpWGjdy
	Fdqvdw+LSXHlo4XZ3A/BAldsq+Ax2AIOy/o4oMbqc0zgiYm5KW+qrBHj/gZg/gvPuzjAWxOM6NIOX
	oUh3AVTuhiOt6SoeNnKAm7CXEQHf9U9wjykU2Ed/1W+aCHXRBQxnyDc7IFjoyFIbbhXhx+WRTjWrO
	/X/Xow9Ch88vz6Y2ViHpZTV7qBZD+t1+DMAQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2QF1-0000000AmfU-2YPj;
	Fri, 04 Sep 2026 17:29:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 19:29:47 +1000
Date: Fri, 4 Sep 2026 19:29:47 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: amcc: trng: use devm_of_iomap()
Message-ID: <apqPiw_Oar-BaAtv@gondor.apana.org.au>
References: <20260812185747.79173-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812185747.79173-1-rosenp@gmail.com>

On Wed, Aug 12, 2026 at 11:57:47AM -0700, Rosen Penev wrote:
> Convert of_iomap() to devm_of_iomap() so that the TRNG register
> mapping is automatically unmapped on driver detach, eliminating
> the need for manual iounmap() calls in the error and remove paths.
> 
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_trng.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Please check Sashiko:

https://sashiko.dev/#/patchset/20260812185747.79173-1-rosenp%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
