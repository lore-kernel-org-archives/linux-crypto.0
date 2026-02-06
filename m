Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EE83314DE;
	Fri,  6 Feb 2026 11:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375623; cv=none; b=sLxuHuZCqFNRktGGrWzMg0CRbjEjGhutbAQAB4nj8NRa3MVOoXREbLC9xintinZnGb7V1pFWLKo1rajAf702rFZ6Q2xiboPNIFBengjNvTOx7Ja8qecjCe/W+A9ixlQp6trx4LocFddPwB2MdcRQ9LO0hfH6Yb3IpP59n0s+Ieg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375623; c=relaxed/simple;
	bh=/4N8Ewly4FTyz0PzrKuKRorK6IiIfK7o3JBVIKHfmus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+sgrywqfCvroN90RqEMOrePuelVCRH2QZ+B1ZXiFhS2Qbpiu83xUDOMYQ0nTC+3KLDFJF5xiPC0OYlBGwW7RQTXqosYMsbC+B+AxXI8+Q0ojwUUrkWuK3mXxgTFPUPLVLmgSITmDEb256SB/6jnRsa0CTfPFmMIDEoNeO928gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Vw4QWvPQ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Vw4QWvPQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=FsfD+s9N2GtRvP6phYlWI5+xLjIZdcJEl/NsrnuZn0w=; 
	b=Vw4QWvPQpBgQXY9Q1nFlF7pkHMdCRRtabo+PiyQj9ku5ugVgKB1TRYaZj1PwtfO/rGtaLwIxPvm
	d9ef6nkV57Xj7R9q2S2PPMfP45+L3H0RKH6sh3UYMn4b/5etqgMwFueB78J6o+pYYV6Y6Wvm7pe5I
	L6rqfERC042dJHhm8CNZc1l/JUOGzmKULnyWreILxLLz6K5kqUNIjX2yeLn6B8EABLBQ45TJIU2A9
	97MiESSQeAB2yCQZ+53jSbsTDFm//bMw+65Bb+NQ2nywIUv6Ed8QggXpJBngcOgPwKAd579NetfYX
	/pkGDAtG0/DIDNFeF3Zc3uKZvKNOwN3Qb/ng==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voJZO-004zWO-0q;
	Fri, 06 Feb 2026 19:00:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 19:00:14 +0800
Date: Fri, 6 Feb 2026 19:00:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lianjie Wang <karin0.zst@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] hwrng: core - use RCU and work_struct to fix race
 condition
Message-ID: <aYXJvmJGIMLgCOKx@gondor.apana.org.au>
References: <20260129215016.3042874-1-karin0.zst@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129215016.3042874-1-karin0.zst@gmail.com>

On Fri, Jan 30, 2026 at 06:50:16AM +0900, Lianjie Wang wrote:
> Currently, hwrng_fill is not cleared until the hwrng_fillfn() thread
> exits. Since hwrng_unregister() reads hwrng_fill outside the rng_mutex
> lock, a concurrent hwrng_unregister() may call kthread_stop() again on
> the same task.
> 
> Additionally, if hwrng_unregister() is called immediately after
> hwrng_register(), the stopped thread may have never been executed. Thus,
> hwrng_fill remains dirty even after hwrng_unregister() returns. In this
> case, subsequent calls to hwrng_register() will fail to start new
> threads, and hwrng_unregister() will call kthread_stop() on the same
> freed task. In both cases, a use-after-free occurs:
> 
> refcount_t: addition on 0; use-after-free.
> WARNING: ... at lib/refcount.c:25 refcount_warn_saturate+0xec/0x1c0
> Call Trace:
>  kthread_stop+0x181/0x360
>  hwrng_unregister+0x288/0x380
>  virtrng_remove+0xe3/0x200
> 
> This patch fixes the race by protecting the global hwrng_fill pointer
> inside the rng_mutex lock, so that hwrng_fillfn() thread is stopped only
> once, and calls to kthread_run() and kthread_stop() are serialized
> with the lock held.
> 
> To avoid deadlock in hwrng_fillfn() while being stopped with the lock
> held, we convert current_rng to RCU, so that get_current_rng() can read
> current_rng without holding the lock. To remove the lock from put_rng(),
> we also delay the actual cleanup into a work_struct.
> 
> Since get_current_rng() no longer returns ERR_PTR values, the IS_ERR()
> checks are removed from its callers.
> 
> With hwrng_fill protected by the rng_mutex lock, hwrng_fillfn() can no
> longer clear hwrng_fill itself. Therefore, if hwrng_fillfn() returns
> directly after current_rng is dropped, kthread_stop() would be called on
> a freed task_struct later. To fix this, hwrng_fillfn() calls schedule()
> now to keep the task alive until being stopped. The kthread_stop() call
> is also moved from hwrng_unregister() to drop_current_rng(), ensuring
> kthread_stop() is called on all possible paths where current_rng becomes
> NULL, so that the thread would not wait forever.
> 
> Fixes: be4000bc4644 ("hwrng: create filler thread")
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Lianjie Wang <karin0.zst@gmail.com>
> ---
> v4:
>  - Include linux/workqueue_types.h in hw_random.h, rather than
>    linux/workqueue.h.
>  - Include linux/workqueue.h in core.c.
> 
> v3: https://lore.kernel.org/linux-crypto/20260128221052.2141154-1-karin0.zst@gmail.com/
>  - Add work_struct to delay the cleanup and protect it with rng_mutex
>    again to avoid races with hwrng_init().
>  - Change the waiting loop in hwrng_fillfn() to match the pattern in
>    fs/ext4/mmp.c, and add comments for clarity.
>  - Change kref_get_unless_zero() back to a plain kref_get() in
>    get_current_rng().
>  - Move the NULL check back to put_rng().
> 
> v2: https://lore.kernel.org/linux-crypto/20260124195555.851117-1-karin0.zst@gmail.com/
>  - Convert the lock for get_current_rng() to RCU to break the deadlock, as
>    suggested by Herbert Xu.
>  - Remove rng_mutex from put_rng() and move NULL check to rng_current_show().
>  - Move kthread_stop() to drop_current_rng() inside the lock to join the task
>    on all paths, avoiding modifying hwrng_fill inside hwrng_fillfn().
>  - Revert changes to rng_fillbuf.
> 
> v1: https://lore.kernel.org/linux-crypto/20251221122448.246531-1-karin0.zst@gmail.com/
> 
>  drivers/char/hw_random/core.c | 168 +++++++++++++++++++++-------------
>  include/linux/hw_random.h     |   2 +
>  2 files changed, 107 insertions(+), 63 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
