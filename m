Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E11316BE3A
	for <linux-crypto@vger.kernel.org>; Mon,  5 Aug 2024 17:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722879509; cv=none; b=HmEejah9DcFu3eKdpPD+7v1ACl2pvWHqIgE2pEF/N42qSWLeMzmPy3ClXn83IzOnvHml0DMCbWyXd1FYNyELhirKwnBlbp8QCPVP8SDSs33uJVQDPCuqiQ2+cxh8xTZYj2+ghXeYFZVUEPL79z8tjb83wp/G/fER72WW7f4iiQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722879509; c=relaxed/simple;
	bh=/8St2FPKhNt7onTcny3gjlqotiTPh1Jf/cUdeZLD2rk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQV8a+6VGQHf7v8wuFGLhn4LrMVVWVCb0hiy3vH08xKK9BV+bS6qcLMqQa/Z1Uf19aTI5dDHAjI1ozW9ldW9n8Uqy2DT043VEhm6kRpC1qdqDOHjDhwNNAeav7JYGDgDtZY8D270fdVtPP6t4fpZ/heBvTQZzXkuLeMvD5r54ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ny5nwYwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ny5nwYwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEFDC4AF0B;
	Mon,  5 Aug 2024 17:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722879508;
	bh=/8St2FPKhNt7onTcny3gjlqotiTPh1Jf/cUdeZLD2rk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ny5nwYwx3dc2jGv2wRk/I1LjokyKBZArUSCQ5QBrsXiZPLRRW84q6a8if15V/BOHQ
	 uK1zmAOnJLHRhq8LFd0OA+LygOQWmIgFo/Ee16CmNM9S63T+XgnwygEsp0oyAQ3vwH
	 lANJM6bF5b9aE7/GZIPMzQT5Qg4xI8HITejU8Zcr4DBPO1EJ8Y/We4xw32t2eC2itn
	 NMTRc78lWz+ahA+L5h3G24V4HQawBhXq1o7EJW3E71iNaOEnczG4awyAgYMXsYTXFJ
	 o9gzPX9AIUNQbEuAc+vlDmeQGq/lagr4xgxGFLvAdbfpl72S/h6qJonaq5DTs9427l
	 nro8BSGe1p1Gw==
Date: Mon, 5 Aug 2024 10:38:26 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: x86/aes-gcm: Disable FPU around
 skcipher_walk_done().
Message-ID: <20240805173826.GA1564@sol.localdomain>
References: <20240802102333.itejxOsJ@linutronix.de>
 <20240802162832.GA1809@sol.localdomain>
 <20240805084121.XVnJxnOk@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240805084121.XVnJxnOk@linutronix.de>

On Mon, Aug 05, 2024 at 10:41:21AM +0200, Sebastian Andrzej Siewior wrote:
> On 2024-08-02 09:28:32 [-0700], Eric Biggers wrote:
> > Hi Sebastian,
> Hi Eric,
> 
> > > diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> > > index cd37de5ec4046..be92e4c3f9c7f 100644
> > > --- a/arch/x86/crypto/aesni-intel_glue.c
> > > +++ b/arch/x86/crypto/aesni-intel_glue.c
> > > @@ -1403,7 +1403,9 @@ gcm_crypt(struct aead_request *req, int flags)
> > >  			aes_gcm_update(key, le_ctr, ghash_acc,
> > >  				       walk.src.virt.addr, walk.dst.virt.addr,
> > >  				       nbytes, flags);
> > > +			kernel_fpu_end();
> > >  			err = skcipher_walk_done(&walk, 0);
> > > +			kernel_fpu_begin();
> > >  			/*
> > >  			 * The low word of the counter isn't used by the
> > >  			 * finalize, so there's no need to increment it here.
> > 
> > Can you make this conditional on CONFIG_PREEMPT_RT so that it doesn't hurt
> > performance for everyone else?
> 
> Every other instance in this file had a kernel_fpu_end/ begin() before
> skcipher_walk_done() so I though was just missed by chance.

No, it was intentional.  See the comment above the first kernel_fpu_begin() in
gcm_crypt():

	/*
	 * Since the AES-GCM assembly code requires that at least three assembly
	 * functions be called to process any message (this is needed to support
	 * incremental updates cleanly), to reduce overhead we try to do all
	 * three calls in the same kernel FPU section if possible.  We close the
	 * section and start a new one if there are multiple data segments or if
	 * rescheduling is needed while processing the associated data.
	 */
	kernel_fpu_begin();

> > Note that kfree() lacks a might_sleep(), and its kerneldoc does not say that it
> > can sleep.  Have you checked for other instances of this same problem?  It seems
> > it would be quite common kernel-wide.  
> 
> kfree() can't have a might_sleep() because it does not qualify for this
> since you can use it in softirq context for instance with an acquired
> spinlockt_t on !RT which would trigger it.
> On PREEMPT_RT interrupts are threaded, softirq is preemptible,
> spintlock_t is a sleeping lock so all these things where a kfree()
> would have been invoked in preempt-disable context on !PREEMPT_RT is
> actually preemptible on PREEMPT_RT.
> This is of course not true in cases where preemption is explicitly
> disabled like in this case.

WARN_ON(!preemptible()) then?

If I add that to kfree(), it triggers from lots of other places.  Are those
problems on PREEMPT_RT too?

What I am trying to get at is what debugging options do I need to detect issues
like this.  Is there really no option other than actually running a PREEMPT_RT
kernel?

I had tested this code with lots of debug options pre-merge and nothing came up.

If there was something in CONFIG_SLUB_DEBUG, for example, I would have seen
that, and you would never have had to deal with this issue at all as it would
never have been introduced.

- Eric
