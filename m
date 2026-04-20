Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5A92E62AC;
	Mon, 20 Apr 2026 08:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776674678; cv=none; b=XHTY/FDAThktTM+tugpc4vFse4Eg+YnOKU4HS51AyZEIL71xN3G7U++R3Sg+TPkBhTDeTGMPmezf55HoGo0vhU7Sl04D4m6vqcdbWRly+0j1eLNszk4Qi+y9do12ntaifsWnIt0RZ/YKMSQdoBxLlTPg2XC+HwB1N1lTePMxX3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776674678; c=relaxed/simple;
	bh=T4RuO10d34UqtGclbnICdSW3D3p/xibFtfZCKTUQFdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nXznNmKtHDjUsbsHJ+3vvm+AlRflR/8F9vlxVjy/HYAtOLbrjbkhEjwYFvSh/aYsyTJqfTYTSZOAnOTZe2Mdc6ib41CD04wm/wUurjDymRpiespR1mwAdiK6QuBUh+Gwu375EqqPoBMbq73Lphs7GUzxLB84X66xrUVVJCGYSfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=epq2oawj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="epq2oawj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=JAYzQKjlxaWlnADyi12VQ99N7o6jHWhWokrMPHDtBPA=; 
	b=epq2oawjpDaKKvvDBbJhSOneMrRs7OrQgHdJpdq/SX9E3f5eyCyLNDOquqR+ReOOdXQyhW4KaJ/
	sGpyBqmhdK/puWsZ/nQ0lZPn2S5q2VT4UhI8IiB2nhvyJEupjjZqeJPTgSILMJZ5n/OGPz1NKh/eu
	0WtJ/yyjJRokMfpEfBmEq/3FTMzuDd7R1WMMntTEIGGgd8RolzgX/OUGTxWmM+T0GIHzZQxJDI5hE
	IskGkSy6zcL7injiTP7GLEJNE6yo0r2Q6T7iq0FLM8iXBe/Gc8h1BH7+BDR7yP61Gn8YhIr7Ts/a9
	t+SAR8Q5jjorFo1ZUYhFnK4cUybU9+zDLP/Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wEkF0-007LxT-2s;
	Mon, 20 Apr 2026 16:44:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Apr 2026 16:44:26 +0800
Date: Mon, 20 Apr 2026 16:44:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] rhashtable: Bounce deferred worker kick through
 irq_work when insecure_elasticity is set
Message-ID: <aeXnak9Yl84a-kho@gondor.apana.org.au>
References: <67fedbf2-914b-44f7-9422-1fe97d833705@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67fedbf2-914b-44f7-9422-1fe97d833705@kernel.org>

On Sun, Apr 19, 2026 at 08:19:33AM -1000, Tejun Heo wrote:
>
> +/*
> + * Kick the deferred rehash worker. With insecure_elasticity the caller may
> + * hold a raw spinlock. schedule_work() under a raw spinlock records
> + * caller_lock -> pool->lock -> pi_lock -> rq->__lock. If any of these
> + * locks is acquired in the reverse direction elsewhere, the cycle closes.
> + * Bounce through irq_work so schedule_work() runs from hard IRQ context
> + * with the caller's lock no longer held.
> + */
> +static void rhashtable_kick_deferred_worker(struct rhashtable *ht)
> +{
> +	if (ht->p.insecure_elasticity)
> +		irq_work_queue(&ht->run_irq_work);
> +	else
> +		schedule_work(&ht->run_work);
> +}

Can we just do irq_work_queue unconditionally?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
