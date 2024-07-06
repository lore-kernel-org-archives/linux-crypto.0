Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1B5695;
	Sat,  6 Jul 2024 00:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720224295; cv=none; b=Sdnzsmqy3SRbZvfuSE/9T2jvge5BLiJrJNU5n4c820SOLlWDb0IYf7gBT2+VrUnq3oYv5aPSTIRwjMoKbP6YoH88qb8rhLtgVgyqKyu9XQ1hVCPO4VArWpxbYn5Ix5tYovGdwrs33wB9oH7oX/y+iVk7Ws6qXlcBrm1pabobTPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720224295; c=relaxed/simple;
	bh=8VrNBXrrSYVvjEYjG0Y3PcsJgMk9a1vP66XtOzIxkx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+gtS8hl+KUQkHc/HPqWPcYSX07aa/7xPVYac9wmoB9Mlz9UUX3FzwjjBpvErO5L4xzKeGK1O0ipvA7qjnh+YmO1TiA2b9CgYMnHNCGSttJ/lSxj1Wuub40ZLYGtxWAUIvutKvAfH/OCers8xawa5WWaCGxSTDAGj2Y/9c1q3ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sPsul-006gYm-1n;
	Sat, 06 Jul 2024 10:04:46 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Jul 2024 10:04:31 +1000
Date: Sat, 6 Jul 2024 10:04:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Helge Deller <deller@kernel.org>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: xor - fix template benchmarking
Message-ID: <ZoiKD2A4pJhaEWpW@gondor.apana.org.au>
References: <ZnMWDdKJHfYQLDzS@p100>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnMWDdKJHfYQLDzS@p100>

On Wed, Jun 19, 2024 at 07:31:57PM +0200, Helge Deller wrote:
>
> +	t0 = ktime_get();
> +	/* delay start until time has advanced */
> +	do { start = ktime_get(); } while (start == t0);

Please rewrite this loop in the usual kernel coding style.

What about adding a cpu_relax() in there if ktime_get doesn't
advance? Something like

	while ((start = ktime_get()) == t0)
		cpu_relax();

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
