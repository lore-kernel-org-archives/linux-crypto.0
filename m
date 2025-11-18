Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D3C24CEEA;
	Tue, 18 Nov 2025 04:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763438668; cv=none; b=R9Qz5lhXy0tHc9kTQM4EIc6t93zF3RS7lgNK3P8XQGEFdxbDGlsgdsb2cj8t8BtwOrcNbNZ6COhffDx8FCzKRV9sQv+m2mkDlJz+Ix1HNHWk2NQ0pWTpQ8BUXr0VCVGWurZnN8MjXDtuDH5Xlud39ARG716vpKPNS94eIwWaUaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763438668; c=relaxed/simple;
	bh=76lr0rMNNtcRQ+EMGxYxu7wzsIgUlJKZ1RXPoFDNCJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/uP+RDzrOSCF8xBnU7k7ytPQMj7Mic9R4qaRufJuzs6eNyDk+BBGSwiYDOWhRBZe79HG24g1DT9MM3997XmHWamvm105MbfjEztsbLSn7uUcb4xsOXHYpdALYAeil1w/4WoLhTQUwKNHoRai4hQWz7n1y3+uQmJaJUq4Qxg9rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rgZs2++L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rgZs2++L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40117C19421;
	Tue, 18 Nov 2025 04:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763438667;
	bh=76lr0rMNNtcRQ+EMGxYxu7wzsIgUlJKZ1RXPoFDNCJU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rgZs2++L7pFueySLCXJNNgKm5EfVCqh2d7cpJ8D3zNbbp3oO0UDZ2o2iyQZGO2qIE
	 NiGCztkBQKUuzyj7LZLv0HuVRDgKb5Xy/YdjEQfbRt4PLC5zpHNBZsZIi/BVdGchD+
	 rkPMY0AJFC11YGj5SXiX3eAVoz+9r+0tXgCNyxFLhkkZX+vNwY6ZhqG/wbhyW0/1Gw
	 MSy6N5qI6lYEz7B4LzqsOGBtj+NjbY+3DXTY9W60WNLFtmErbYgusaZfjIFN1L6m+y
	 riKN3Pj8WY0BdmbE/DBCyOXsEKoPPLM2CsjxvYwIipVlueRDNGOsnhtT0P3PVUxsW2
	 c2BrG0ZNUr+IA==
Date: Mon, 17 Nov 2025 20:02:44 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	larryw3i <larryw3i@yeah.net>, stable@vger.kernel.org,
	AlanSong-oc@zhaoxin.com, CobeChen@zhaoxin.com,
	GeorgeXue@zhaoxin.com, HansHu@zhaoxin.com, LeoLiu-oc@zhaoxin.com,
	TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com
Subject: Re: [PATCH] crypto: padlock-sha - Disable broken driver
Message-ID: <20251118040244.GB3993@sol>
References: <3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net>
 <20251116183926.3969-1-ebiggers@kernel.org>
 <aRvpWqwQhndipqx-@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRvpWqwQhndipqx-@gondor.apana.org.au>

On Tue, Nov 18, 2025 at 11:34:50AM +0800, Herbert Xu wrote:
> On Sun, Nov 16, 2025 at 10:39:26AM -0800, Eric Biggers wrote:
> > This driver is known broken, as it computes the wrong SHA-1 and SHA-256
> > hashes.  Correctness needs to be the first priority for cryptographic
> > code.  Just disable it, allowing the standard (and actually correct)
> > SHA-1 and SHA-256 implementations to take priority.
> 
> ...
>  
> > diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> > index a6688d54984c..16ea3e741350 100644
> > --- a/drivers/crypto/Kconfig
> > +++ b/drivers/crypto/Kconfig
> > @@ -38,11 +38,11 @@ config CRYPTO_DEV_PADLOCK_AES
> >  	  If unsure say M. The compiled module will be
> >  	  called padlock-aes.
> >  
> >  config CRYPTO_DEV_PADLOCK_SHA
> >  	tristate "PadLock driver for SHA1 and SHA256 algorithms"
> > -	depends on CRYPTO_DEV_PADLOCK
> > +	depends on CRYPTO_DEV_PADLOCK && BROKEN
> 
> It's only broken on ZHAOXIN, so this should be conditional on
> CPU_SUP_ZHAOXIN.
> 

I.e., it's apparently broken on at least every CPU that has this
hardware that's been released in the last 14 years.  How confident are
you that it still works on VIA CPUs from 2011 and earlier and is worth
maintaining for them?

- Eric
