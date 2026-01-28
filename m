Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB185255E43;
	Wed, 28 Jan 2026 01:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564641; cv=none; b=qx2f2YZWIJOnB8PF4AN7nyfRcyZRBapM7cvyMFdZOSoQCzAlymI1+ywfyUS37+tk9sNKycSEEHbecrS/0SZjOq+Iei/fn8QV5fuOmOuUYlyc7VBnoYbOiTO7geybQW4Xl69kaDiTpmnL6C9p73UkYY7nhUHVr2xt+b14f3RY87M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564641; c=relaxed/simple;
	bh=kObptGzYKGHiP+qqG53X3f0ccdJ68sqDyS4Y+ftKMDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pHRS+2aVW2JBERc+xJm4YV9hGBUWMQjM03Ho5bfowqCGa2uvncrrFLyVxF5VoV69EZB4t95sCej02aq4EYxv5yGwB+Y6KPdGwMOjW4AIzoUWxYoEneVt14ghBTDFongCRoWeSEp31G/LgC6s11ISKz9ZpVjkZz2a0de+zpxxToo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=N4F9qwYU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="N4F9qwYU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4ozVjupN70NNxSObIAAi4OpBrU5B6mEXMnRy7ird/aA=; 
	b=N4F9qwYUcfoi435b6DHvFM5huMjj+/M9LTOoFoMpoJd/DSSlSqH0TVhoi4sxBKF/5cM7UL43Fp8
	o0zYtvmPPnpI1wUx/Gjlzj/d8EHs2GJx28ZAIfLdEPnFK9fqmWfhiV0QjO9Ky3xKmkq5GbvIMeWBh
	pl1tudHv13qkqKlP0q8Nue7fdzu84pc8CRxFv085jhBPAUHNDjrjsE0QlDbGbjdnvsPfDnEVfyGMb
	NayWXY5rBAWlkLm/J+iiU0KuRa3+c7PdEgnBoCD6ekoBLrIiTX2dpE0Ad61kZsHePML032l3QZ0p2
	Ukm16PAs1TSr31SMvRNO4sbINVLt1a9PXAzw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vkuas-002cug-0F;
	Wed, 28 Jan 2026 09:43:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 28 Jan 2026 09:43:42 +0800
Date: Wed, 28 Jan 2026 09:43:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lianjie Wang <karin0.zst@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwrng: core - use RCU for current_rng to fix race
 condition
Message-ID: <aXlpzqh9K6bqBh4T@gondor.apana.org.au>
References: <aXbwM1wiPKqmC94v@gondor.apana.org.au>
 <aXirTffsg1GWk2Yw@kator>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXirTffsg1GWk2Yw@kator>

On Tue, Jan 27, 2026 at 10:32:30PM +0900, Lianjie Wang wrote:
>
> It is true that cleanup_rng() can race with hwrng_init(). However,
> currently put_rng() is also called in hwrng_fillfn(), where we want to
> avoid holding rng_mutex to prevent deadlock in hwrng_unregister().
> 
> To solve this race, should we introduce a separate lock (e.g.,
> init_mutex) to serialize only hwrng_init() and cleanup_rng()?
> 
> Alternatively, I think we could stop the thread also in
> set_current_rng() before switching current_rng, so that each lifetime of
> hwrng_fillfn() thread strictly holds a single RNG instance, avoiding the
> need to call get_current_rng() or put_rng() inside hwrng_fillfn().

Yes I missed the dead-lock.

I suggest that we delay the work in cleanup_rng into a work_struct,
IOW cleanup_work will simply schedule a work_struct to perform the
actual cleanup.

Then the work_struct can take the mutex safely, immediately check
the reference count on the rng, and if it is non-zero it should return
because the rng has been re-used in the mean time.

If it is zero then it can proceed with the clean-up while holding the
mutex, thus preventing any re-use from occurring.

> I removed the NULL check in put_rng() and moved it to rng_current_show()
> in v2, since all the other callers of put_rng() already check for NULL
> before calling put_rng(). I can restore the NULL check in put_rng() in
> v3 if preferred.

Let's keep this patch simpler by keeping things as they are.  If
it turns out that moving the NULL check makes the code more readable,
you can do that in a follow-up patch.

> > > @@ -489,8 +502,17 @@ static int hwrng_fillfn(void *unused)
> > >  		struct hwrng *rng;
> > > 
> > >  		rng = get_current_rng();
> > > -		if (IS_ERR(rng) || !rng)
> > > +		if (!rng) {
> > > +			/* This is only possible within drop_current_rng(),
> > > +			 * so just wait until we are stopped.
> > > +			 */
> > > +			while (!kthread_should_stop()) {
> > > +				set_current_state(TASK_INTERRUPTIBLE);
> > > +				schedule();
> > > +			}
> > >  			break;
> > > +		}
> > > +
> > 
> > Is the schedule necessary? Shouldn't the break just work as it
> > did before?
> 
> With the break alone, the task_struct might get freed before
> kthread_stop() is called, which can still cause use-after-free
> sometimes:

Please change the comment above to say that this loop is needed
to keep the task_struct alive for kthread_stop as it isn't obvious.

I wonder why nobody has added a helper for this since this seems
to be a common pattern in other kthread users? For example,
fs/ext4/mmp.c also does this, and they also set the task state
to TASK_RUNNING, perhaps we should do that too?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
