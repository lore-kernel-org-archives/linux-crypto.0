Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B2A1494D7
	for <linux-crypto@vger.kernel.org>; Mon,  5 Aug 2024 08:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722847286; cv=none; b=bow1rsaGo6QragxCnfjVe9MFKh+XRy502miBI4ohIBXPkShAkzd8XoOF5OORQ4PPgdGaqJfVIuM6+BRTOg2V+uxKxXxj/i4EHfFlaR3FMtEjRRbCd/ufXAiCN7prB5wb0JYlz+cQF3JvIcqlhZEtg1JfMmnOIswqgj2LBPhl4xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722847286; c=relaxed/simple;
	bh=R5DE5Oiwu14XDKSTzRZ6wBgDQxW3JnRMJ6sQB5Sl7Dg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwQWr7PmZ1Zq8VhPtahLp4LzMlbdR5jcwq486ViNTcWU3KNwxG2tbR7wOmvyufEAx1yE34ELbn34YIoHC778TcPbDNZUHOzfLlX91CLiU1SDc6MvdMICDZphvHTEuIZWo55etXHvJ0zba2ef9jrz3Q9oU5TYIQgoaBNEU5hoURY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=eSKgxHGP; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=nhwEKLJl; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="eSKgxHGP";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="nhwEKLJl"
Date: Mon, 5 Aug 2024 10:41:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1722847283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ajCnVIpJODJZLzsqx5fKR6u+ZeSMmtXWPUg6d0J8MS0=;
	b=eSKgxHGPKhg+PLRyp6vmwFccwXLHlCUgI7eoQo9PLvHig5UBEiFKg/3RBVSDPYhTN2sxEQ
	uvlCGGAhKZCdAuYSPROHeSYlzFDsZa64y8OklyAv9suRBtE3SUy5oSlGcgp1fV5UO8XRC8
	qxsouLlEVwynmF/1MqPkQoIhieEscg5lM8RitG36GgehgezBFlUruUObHspCIGnIcNsS/9
	uma9vCiWCEAdidyJWHmJ7g1e0Mz6Zq5lAV77+10yxKkY7UiLYfCkuoViAtkvkBCiftAdS7
	FlDagJC+Jhr4I4jtVlVBtxbGlBYuchcnGd0/lexfdf3AY5TJsa1FODQZdjusyg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1722847283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ajCnVIpJODJZLzsqx5fKR6u+ZeSMmtXWPUg6d0J8MS0=;
	b=nhwEKLJlqenzNWcH+G+3pKLClnnlfmdCfPtMiDzpKapO8fc95kwamJV0KRJfwaWY9GQQOB
	dKZhlXK0/JCvlvBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: x86/aes-gcm: Disable FPU around
 skcipher_walk_done().
Message-ID: <20240805084121.XVnJxnOk@linutronix.de>
References: <20240802102333.itejxOsJ@linutronix.de>
 <20240802162832.GA1809@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240802162832.GA1809@sol.localdomain>

On 2024-08-02 09:28:32 [-0700], Eric Biggers wrote:
> Hi Sebastian,
Hi Eric,

> > diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> > index cd37de5ec4046..be92e4c3f9c7f 100644
> > --- a/arch/x86/crypto/aesni-intel_glue.c
> > +++ b/arch/x86/crypto/aesni-intel_glue.c
> > @@ -1403,7 +1403,9 @@ gcm_crypt(struct aead_request *req, int flags)
> >  			aes_gcm_update(key, le_ctr, ghash_acc,
> >  				       walk.src.virt.addr, walk.dst.virt.addr,
> >  				       nbytes, flags);
> > +			kernel_fpu_end();
> >  			err = skcipher_walk_done(&walk, 0);
> > +			kernel_fpu_begin();
> >  			/*
> >  			 * The low word of the counter isn't used by the
> >  			 * finalize, so there's no need to increment it here.
> 
> Can you make this conditional on CONFIG_PREEMPT_RT so that it doesn't hurt
> performance for everyone else?

Every other instance in this file had a kernel_fpu_end/ begin() before
skcipher_walk_done() so I though was just missed by chance.

> Note that kfree() lacks a might_sleep(), and its kerneldoc does not say that it
> can sleep.  Have you checked for other instances of this same problem?  It seems
> it would be quite common kernel-wide.  

kfree() can't have a might_sleep() because it does not qualify for this
since you can use it in softirq context for instance with an acquired
spinlockt_t on !RT which would trigger it.
On PREEMPT_RT interrupts are threaded, softirq is preemptible,
spintlock_t is a sleeping lock so all these things where a kfree()
would have been invoked in preempt-disable context on !PREEMPT_RT is
actually preemptible on PREEMPT_RT.
This is of course not true in cases where preemption is explicitly
disabled like in this case.

> Is it really necessary that kfree() takes
> a sleepable lock on PREEMPT_RT?
Yes. The locking in SLUB and page allocator is spinlock_t.

> - Eric

Sebastian
