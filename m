Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652BA37D118;
	Mon, 20 Apr 2026 17:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776704547; cv=none; b=F7e97wRTgAFPzqIcZ+2Nr5Em5EysSRXBitwABMSRIegh4qV4Jqor/+wHmfPFipnkjoBcQVm8KHOftQTxa5aDG6oNZJDc43NKr0fEEnAkl7VqKqupRXGEOokwnj3MxWSaHL9gOVAG3aC5nmoHCqUvMqc+MrH/Qr5In7YUCSly2QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776704547; c=relaxed/simple;
	bh=v1oO3jW8lRgp36zUWn2Neyn10xmT93hmSdkpNveFPnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fVY2ONLByxpGB762v8W5/5TeQN3CjtPrbtqKci0zKxoOKtNVcdCx3yaL504feXwLA2fOFxjIMsmcQdwxnSiROXBXqPYLywRZHz+VpeGBfuxwj2pBJ9YtNBybJg33o4GeV2sHkA01LG/G+RW9v3VRDxQOD5wRO+xbqS1Xq646ySw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rvTqlXHg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rvTqlXHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7811C19425;
	Mon, 20 Apr 2026 17:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776704546;
	bh=v1oO3jW8lRgp36zUWn2Neyn10xmT93hmSdkpNveFPnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rvTqlXHgrkYIM8qLTWz1CTLZbvUpujtYrTW+M8EMuRWSuijgNK2gAffWQq9Fq9kzk
	 zf5AsS7sK5mrUc2qYM32IZM7CLCcfMuKiqyjzo/hSaauY0iFvBQBHJ9JZyaQcQbrNF
	 ILV1XdVYdfOuB9nKhrzG9nGwoexYd3FnxuH8y6dUz8ZSftJAFk0X5qX7e6KSnQ8WHD
	 d4kzHZM0A2lez5bmlh1GDaQINiFZpnV7aIxns581jLBK9oDRjg3IpKPHc9NA4wrkyz
	 zClDh2BBhTh9dit0/m+afezbSNBV82Pl8f2KqAr6MMN2/kkr1VwQMoIAk2RVCyp1tt
	 xPiVPv4LndwUg==
Date: Mon, 20 Apr 2026 07:02:25 -1000
From: Tejun Heo <tj@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Thomas Graf <tgraf@suug.ch>, Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] rhashtable: Bounce deferred worker kick through
 irq_work when insecure_elasticity is set
Message-ID: <aeZcIf2blLrdKvoB@slm.duckdns.org>
References: <67fedbf2-914b-44f7-9422-1fe97d833705@kernel.org>
 <aeXnak9Yl84a-kho@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeXnak9Yl84a-kho@gondor.apana.org.au>

On Mon, Apr 20, 2026 at 04:44:26PM +0800, Herbert Xu wrote:
> On Sun, Apr 19, 2026 at 08:19:33AM -1000, Tejun Heo wrote:
> >
> > +/*
> > + * Kick the deferred rehash worker. With insecure_elasticity the caller may
> > + * hold a raw spinlock. schedule_work() under a raw spinlock records
> > + * caller_lock -> pool->lock -> pi_lock -> rq->__lock. If any of these
> > + * locks is acquired in the reverse direction elsewhere, the cycle closes.
> > + * Bounce through irq_work so schedule_work() runs from hard IRQ context
> > + * with the caller's lock no longer held.
> > + */
> > +static void rhashtable_kick_deferred_worker(struct rhashtable *ht)
> > +{
> > +	if (ht->p.insecure_elasticity)
> > +		irq_work_queue(&ht->run_irq_work);
> > +	else
> > +		schedule_work(&ht->run_work);
> > +}
> 
> Can we just do irq_work_queue unconditionally?

Oh yeah, that works too. I'll respin the patch.

Thanks.

-- 
tejun
