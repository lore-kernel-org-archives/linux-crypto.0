Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7032C1C84CB;
	Tue,  5 May 2026 03:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777951908; cv=none; b=H4nhxpCWNNA79O1nXZvCoyjtk3cCmr46wWih2h5vqziI5nQ+dEJK8+thyijXu7R/SUIJJZnQAL5WQ0r1NnJB/8x8bk7vi7PxeV40F+xeVKeZdoXLbqsfhyVHyN/VR8rNImlET2SfLTQFwKc6ziDY7m1SHfLUBkraPRwCaWTqqf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777951908; c=relaxed/simple;
	bh=iiqHOsAFsazNL57u8bihoo1YRGGwHorFLAbaNqpNYnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D8TtRVO0dilihBtOizasv2T9Q6K8uIInEaFMPTf9ha1H7AcOq7zBfmO+iDupwGb/akBTGyylUtqDWgq2WgOIUBD5IGyQpgTSDnyqNXUWWTFldU0fsHdSX7PfbfLzr2jykuJX20M/s4J54hlNN0ym+JLktTDTkQhlB/Kn38tp7nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=E/X/hK+8; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="E/X/hK+8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=BDIZaj9sKUzVIvKQBjt+PPO4Po68FG/I9lR6Wy4i0VU=; 
	b=E/X/hK+8uEptNJfGnO8wdcEaufyEtRun1JDFUwkNIAHIs+I3ZelzX04MB2BFB6IyYpgaFFp6ed1
	eVEroN9nSlhx7E3JQz0yFRfQLy4cnxnY4wIVRUbpaRi70u6ofU6iMz9aotHM089oyHnKu4nNUXa17
	wX5uxHbyS93FL5elTjmecCJOjKq6v1Nxq4/ylmoROIzkm/CE05bFevfkHPsdFiQxDxrV7BfM9AC4g
	nzUavhNkd1r+wl33O1+tjLLpk9VXkcIeDagdAoCkKWcgsh/nVyPN3uy71hQ/1xSIEp42Lzs72T1ww
	IMv/kCEGWy3Ns/NXIlRbrQq+461TLG4XjRrA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wK6VQ-00BJBl-2k;
	Tue, 05 May 2026 11:31:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 11:31:32 +0800
Date: Tue, 5 May 2026 11:31:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v12 2/4] crypto: spacc - Add SPAcc ahash support
Message-ID: <aflklGva2ZoAz-A9@gondor.apana.org.au>
References: <20260416064451.99886-1-pavitrakumarm@vayavyalabs.com>
 <20260416064451.99886-3-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416064451.99886-3-pavitrakumarm@vayavyalabs.com>

On Thu, Apr 16, 2026 at 12:14:49PM +0530, Pavitrakumar Managutte wrote:
>
> +/*
> + * Allocate a job for spacc module context and initialize
> + * it with an appropriate type.
> + */
> +int spacc_open(struct spacc_device *spacc, int enc, int hash, int ctxid,
> +	       int secure_mode, spacc_callback cb, void *cbdata)
> +{
> +	size_t i;
> +	int ret = 0;
> +	u32 ctrl = 0;
> +	int job_idx = 0;
> +	bool ctx_reused = false;
> +	struct spacc_job *job = NULL;
> +	const struct enc_config *enc_cfg = NULL;
> +	const struct hash_config *hash_cfg = NULL;
> +	unsigned long flags;
> +
> +	/*
> +	 * Acquire the semaphore. This will decrement the count. If the count
> +	 * is already zero (meaning all HW contexts are in use), this call
> +	 * will sleep interruptibly until another thread calls up().
> +	 */
> +	if (down_interruptible(&spacc->ctx_sem)) {
> +		dev_dbg(spacc->dptr, "ERR: Interrupted by signal\n");
> +		return -ERESTARTSYS; /* Woken by a signal */
> +	}

This may sleep.  While we used to allow sleeping in setkey, this
is being phased out so new drivers should not do that.

This also raises the question of whether spacc_open should even
be called from setkey.  The setkey call could be very far away
from the actual hash processing, so allocating a handle in setkey
seems to be a waste.

As you can allocate handles from do_one_request, why not just do
that always?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
