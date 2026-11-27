Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795756358;
	b=3pGyeTBOmkm+XfGMGMcOHVXQhdr0ZGJUSxYQpCyiTeZe6bJOUIo8oG3XtijKhGCTDRrH
	 B9ZdyCXsYgbJ0f+LNAxEsnU6nidEry6UaXqf87W12UX3mkyMA0eq5f1GQ0HMaYVS62QuZ
	 NnYfqXiu7NlS6rrArug1lykZOesVWO0jcvf2OOBzSB9WthQV7/zA763NEeByPqn60ubEh
	 oDUTmusRIvcCaQyRd3aHAFJO899sJVq75dl8JPVFvDROYLR3gTxx88itLGj9mEHTEmqrt
	 aYuLlz9lyf102yo4CMXG92+3tHNQsr+0QRbYBjZ6ch1tfxofgf/XdPdxQzJclDhESSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795756358;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=ixOJCpVuMu7BFcdEGtWuuR1omNJuvKI0an0AeTEtxQE=;
	b=IrRTCISa20O2uR/bvFonaMyQt5f4FBG24/GJbT0ylQs4L0nhLqwSMqWnAcwSfhmSr9PP
	 ug2f/vTccfSdHeWctPbQTssO0UiKsuD8fbc8IRDhBPmW83Tk4hziKpJiA8tb9eW1AK/79
	 epbxOdt4tf5NX3SzFpMpdoXtbrakKtuAGyRBNQgtymNIbNSKNhNYBGPOgSXWEygF1001/
	 noR4/3p+rNaqd4Wly33nJ0Ydp2IN1YNGGzRmmfIoiPx1z/SkF/mKYkG6AT9GFG7A6DdrQ
	 sFqesSHFuq8newwdVmQD7D8ZzsYo2FXNs82XyeM+XHWOWrFTU/QgB4cXr+cyR07L6eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b="BWj/ftta";
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8CB606A31E;
	Fri, 27 Nov 2026 05:12:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD8CB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=BWj/ftta
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ixOJCpVuMu7BFcdEGtWuuR1omNJuvKI0an0AeTEtxQE=; 
	b=BWj/fttaOmwODzxO3a+Bv6uKtme2xH2Zh0GXQZ51pF1a7fqbzUADAD9KL0qgBh8amyxSJ31TwWm
	MDtTnp44b7PrOe92utQkFyK3COlffWtQfvEv1NOCn/OOmZvv2hYRep4xx1X9bCBEUCMrYqpzdtGU0
	duqwlp+ibW6jof7BPlocucMCI5G6DEmw0xIQUOK6O+0aA7qAHUenSf5Yqgj0hJor0S5i+j/xM9KzT
	dN/fb1qYsLLLaOqWkWSXdHfkDaAmk2omgzoyLcmLV7mGelo7wcBiv9nwPIgxNA3/Yp5a0HORxlPAW
	4kwbFnJEqN56IowXhyx6W4H9hKmPxCUlfKtA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xWoGA-00000002VUZ-0aOm;
	Fri, 27 Nov 2026 13:12:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2026 13:12:34 +0800
Date: Fri, 27 Nov 2026 13:12:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kim Phillips <kim.phillips@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Rijo Thomas <Rijo-john.Thomas@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: ccp - fix misc_register() failure paths in
 SEV and SFS
Message-ID: <awkRQrIV0nb0oy0E@gondor.apana.org.au>
References: <20261117221901.746427-1-kim.phillips@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117221901.746427-1-kim.phillips@amd.com>

On Tue, Nov 17, 2026 at 04:18:59PM -0600, Kim Phillips wrote:
> sev_misc_init() and sfs_misc_init() both publish their newly allocated
> sev_misc_dev/sfs_misc_dev to a file-global pointer before registering
> the misc device, then return early if misc_register() fails.  Neither
> frees the allocation nor clears the global, and the early return is
> ahead of the kref_init(), so the embedded refcount is left at the zero
> from kzalloc_obj().
> 
> Both features can be detected on more than one device, and a failure
> here only aborts the probe of the device that hit it.  The next device
> to probe therefore sees a stale non-NULL global, takes the else branch,
> and calls kref_get() on a zeroed refcount:
> 
>   refcount_t: addition on 0; use-after-free.
> 
> The count stays at zero, so the matching kref_put() on teardown warns in
> the same way and never reaches sev_exit()/sfs_exit().  What is left is a
> leaked allocation plus a device whose ->misc points at a miscdevice that
> was never registered, while the driver still reports the feature as
> available and no /dev/sev or /dev/sfs node exists.
> 
> Both patches free the allocation and reset the global on the
> misc_register() error path.
> 
> Note the differing Fixes: tags.  The SEV stale-pointer half goes back to
> the original SEV support commit, but the allocation was devm_kzalloc()
> then, so backporting the kfree() that far would turn the leak into a
> double free; the tag points at the commit from which the fix is safe.
> 
> Found by review of the equivalent bug reports; no hardware failure was
> observed, as misc_register() only fails here on minor exhaustion or an
> OOM.  Compile-tested on x86_64 with CONFIG_CRYPTO_DEV_SP_PSP=y.
> 
> The two patches are independent of each other, and of the pending
> 
>   https://lore.kernel.org/linux-crypto/20261116203622.615371-1-kim.phillips@amd.com/
> 
> which touches psp-dev.c only.  This series applies on top of it, but
> also applies cleanly to cryptodev master without it.
> 
> Kim Phillips (2):
>   crypto: ccp - fix leak and stale misc_dev on SFS misc_register()
>     failure
>   crypto: ccp - fix leak and stale misc_dev on SEV misc_register()
>     failure
> 
>  drivers/crypto/ccp/sev-dev.c | 5 ++++-
>  drivers/crypto/ccp/sfs.c     | 5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> 
> base-commit: 26ca5f34841f0a86d0883664a1c13be89a01d351
> -- 
> 2.43.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
