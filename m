Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D78837C937;
	Tue, 21 Apr 2026 06:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776751626; cv=none; b=ZgSrdXsa2psSA2W8qXIOkzueV+CVJ8HADXt55fNYvZAQwj8yjkQhSBi1s1x2CaR0/CUO5bRbOW4/P7LDLxvYU+UmlNy3DzHAahMjQ9EsMMoea1pDKoTSDCqs23DRs68ldTRAQCnQncY2/i/Mpr09QJFw+LbeHaNsC4DNS0C0daQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776751626; c=relaxed/simple;
	bh=pgGsYGyv9ZGVbUX7xOLTM+fRofvUc4FuA4k8aYzSwV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pYeTYKiX6L1YMqwJMtCrnhBfyOhi/n5Hju1T7cuko9nbqbn+W2YocCxW5LzzNsdVjnHi02PV08E5QKAHjZZrBVzWqT/2CPKTcp7EKUMa1pCQvOFrpolweF+gfkhHrT26SwKggTGdvmhXnKUC0b+aAtUOVKSQJn1oUJBfBB4Oc7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=pbSwrRMf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="pbSwrRMf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=MXtL3oNl9z984K2NkPtQUinh/OZ0M3bUHGQHqkrolLE=; 
	b=pbSwrRMfyIn4zW1OpRknnmgKXBq+HSoBCfQ7c+p1bRK3AesdPQiL2DRYF81cFKbmLV2TPx1/3Ej
	L2HyIfsvpnov1rfol2jS7ZxsY5e/j8DJDGKPwPhxaOsCntnqAp/RPfyu7BAzK6HTfh9SkN5BiM0aK
	mgVUYELc0uAnqLUi2a1wPUaFC7E68aui8t+QTM0WF3asZCR+otrdNCvFulpuVfM7R374jpsiViwDn
	YijXbeBn4tDDlZkyR1IpnStTi9Q7ADf2RZ/BHjcBXfDB0G4360lvtm3sxcJ9VDnQKTvlMxiQWmXW8
	fmyJ1ZM9IB3KoidYVJVsCfVC4XpUsmkqGoWg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wF4G6-007cju-1a;
	Tue, 21 Apr 2026 14:06:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 Apr 2026 14:06:54 +0800
Date: Tue, 21 Apr 2026 14:06:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rhashtable: Bounce deferred worker kick through
 irq_work
Message-ID: <aecT_nyT2cU6kmlF@gondor.apana.org.au>
References: <4ff731fc-3791-4b96-a997-89c3bcd2d69b@kernel.org>
 <20260421060326.2836354-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421060326.2836354-1-tj@kernel.org>

On Mon, Apr 20, 2026 at 08:03:26PM -1000, Tejun Heo wrote:
> Inserts past 75% load call schedule_work(&ht->run_work) to kick an
> async resize. If a caller holds a raw spinlock (e.g. an
> insecure_elasticity user), schedule_work() under that lock records
> 
>   caller_lock -> pool->lock -> pi_lock -> rq->__lock
> 
> A cycle forms if any of these locks is acquired in the reverse
> direction elsewhere. sched_ext, the only current insecure_elasticity
> user, hits this: it holds scx_sched_lock across rhashtable inserts of
> sub-schedulers, while scx_bypass() takes rq->__lock -> scx_sched_lock.
> Exercising the resize path produces:
> 
>   Chain exists of:
>     &pool->lock --> &rq->__lock --> scx_sched_lock
> 
> Bounce the kick from the insert paths through irq_work so
> schedule_work() runs from hard IRQ context with the caller's lock no
> longer held. rht_deferred_worker()'s self-rearm on error stays on
> schedule_work(&ht->run_work) - the worker runs in process context with
> no caller lock held, and keeping the self-requeue on @run_work lets
> cancel_work_sync() in rhashtable_free_and_destroy() drain it.
> 
> v3: Keep rht_deferred_worker()'s self-rearm on schedule_work(&run_work).
>     Routing it through irq_work in v2 broke cancel_work_sync()'s
>     self-requeue handling - an irq_work queued after irq_work_sync()
>     returned but while cancel_work_sync() was still waiting could fire
>     post-teardown.
> 
> v2: Bounce unconditionally instead of gating on insecure_elasticity,
>     as suggested by Herbert.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
> Herbert, dropped your Ack on v2. v2 routed rht_deferred_worker()'s
> self-rearm through irq_work, which would race with
> cancel_work_sync() in rhashtable_free_and_destroy(). v3 keeps only
> the insert-path kicks on irq_work; the worker's self-rearm stays on
> schedule_work(&ht->run_work).
> 
>  include/linux/rhashtable-types.h |  3 +++
>  include/linux/rhashtable.h       |  3 ++-
>  lib/rhashtable.c                 | 31 ++++++++++++++++++++++++++++---
>  3 files changed, 33 insertions(+), 4 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
