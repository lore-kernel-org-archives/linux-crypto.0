Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B81F499F11;
	Wed, 16 Sep 2026 12:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789562387; cv=none; b=bD1tfJwTDVDy2D/xV0JckVSKy+xmSLRWsn6h2TIRKsugg3yPds8/ujJLXJiEeltynK8OxcMNmk7grUnP+rJ0pAszjPWmIjXF4vyEQlSSih/appjJhyskY4MbUYQGyQ0uU0xqJOlS2ej0EtP35Q8vhhmx4JzRGe+zGJ9RNF9gydg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789562387; c=relaxed/simple;
	bh=wZbMWjFPwUAHck+KtbXlCVb5dVQVnPgrMO/5Eo17fWw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=COoEBj9lgvjL+EKG6gaPdwQuBcyNTfHlNz4LStxmh5ZK39sTnVG5f22hbSABMPEkR0HLv3r6MPVmnwiLpWi2TXte2kEwHxopU34ShSXwQjAYDagXFMraWNhpSIEWvccWQlPxwurB0ERlT7edUS8FJWaE1CwI9363JIxvM2XuaLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Qv8efVgF; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Qv8efVgF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=qyo1SEzXZ4zo1i3funmFk+KuWFph9NetKxaeyruiUOo=; b=Qv8efVgFVjJplDsCQDHvpPdNTF
	bolrn3EtnlNyqaRXsNAdM7b489QB3OSI6h9TftEDj+CZBFYu0Zp5BLa3/kWKE8GnGl5ZXonblpvWl
	Bz8F02o75J1aDCp03tUwCrbqItrBl9+2uH/uwLJEV2vcsXvbW4poicKB/H0I44VUB92/vNdwCrwsT
	PiKtHnofskapniGrxn9YUj90dgvh1JHmYNzFKO7i5jYpzvdITf8NBXU/Rt67edPYocqEaK+9tRIu8
	SFga5fNkBXu62t7vnUPJ1JyjWpayHG3aJFChy/jkEZlsBJYxlYcz/pINHxpmeq91xnvcIEFWYuFI1
	7bcxlFBA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6ovL-0000000EcDr-1YVm;
	Wed, 16 Sep 2026 20:39:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 22:39:39 +1000
Date: Wed, 16 Sep 2026 22:39:39 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: talitos: request irq after tasklet_init()
Message-ID: <aqqOC6BiCDRRGyMD@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904211230.81963-1-rosenp@gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Rosen Penev <rosenp@gmail.com> wrote:
> The talitos interrupt handlers schedule priv->done_task[] via
> tasklet_schedule().  In probe(), talitos_probe_irq() ran before
> tasklet_init(), so an interrupt arriving during that window (a shared
> IRQ, or a completion pending from an earlier transmission) would
> schedule an uninitialized tasklet.
> 
> Move talitos_probe_irq() after the tasklet_init() calls so the
> tasklets are fully set up before interrupts are enabled.  This matches
> remove(), which frees the IRQs before killing the tasklets.
> 
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
> drivers/crypto/talitos.c | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)

Please have a look at

https://sashiko.dev/#/patchset/20260904211230.81963-1-rosenp%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
