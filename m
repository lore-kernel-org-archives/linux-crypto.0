Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE41143C4B
	for <linux-crypto@vger.kernel.org>; Mon,  5 Aug 2024 08:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722846084; cv=none; b=kE9mRiR/DM7dyuyXXRkLvRibPXgggEiExS3NkblOF+iGwIenrCS7+qDtHzRS9UgfhigusP9YKvrmlCZaHGEVUZ52AkOsRh6cx+ccnrXR8nNrlI04h2A0w8tV9j722CQ5KkyKJQtaisxvN/meLGoJqpwtazAJdpOPkjSQIKAoOxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722846084; c=relaxed/simple;
	bh=shggwruteTAijwBH/P2tjkyqc+4ZYZfBv+OOptwUKkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hIrmtYfU7MBfvQAeFLpUG3f/B5VImbTxWla+xd6BcS0InypSBisGcHn7YVoc2kSuGu4Cvj74cE08yKOYdjdOXY7VtbhWGPxog//2pypNhd1asyTKTPprjLl+3c4kvKti3XZZrSiHTzVFj61/RHXL0Uh3Mmqy1cnNSHWnrHd6idE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=TF+ZhEuF; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=lHtLeEe2; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="TF+ZhEuF";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="lHtLeEe2"
Date: Mon, 5 Aug 2024 10:21:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1722846081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0MQm3VuXrx4kkbndBIm8zzFT3CBKtQcsuReX6Zf0QK4=;
	b=TF+ZhEuFS0F2/pDhkT0wuDGvTV4tClEAKvt39UQUyyYea81lDd9unfaXhIXdrIloRRnrVn
	RWGz7bWXxc7GsoHRSUzFeL4gwRUbVsZfRuj0IHpLwNO3U0CMbCxwfOShhBP0/btO3A7AHp
	rqSU3D9ftvGFn5HgI5dxXW5LmjsGdvQ/UA5RbNtYKzt0hg3yOpX74VPZTp9AEZw0hHnD2i
	IZREQIvCqmDOjvLldcDI0euqe3y0dzaIDyLkak4sf+CQcj0qB6yCl/iakPKdMvT/MGkGIw
	JxhugnoHPGGx076QjQ/F2F56CSPSHZ2osZhkMA95EZGp70/dNBlP8vPukrxTIw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1722846081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0MQm3VuXrx4kkbndBIm8zzFT3CBKtQcsuReX6Zf0QK4=;
	b=lHtLeEe2WCfdqOzntvkgEHqQesJgbUUlmLsVCRBHUfNQ8+4qVR99LdQ9w/9Po8t1Ib9BBG
	OBKaq1NYBNhoF3BA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: x86/aes-gcm: Disable FPU around
 skcipher_walk_done().
Message-ID: <20240805082119.n252N8l8@linutronix.de>
References: <20240802102333.itejxOsJ@linutronix.de>
 <20240802162832.GA1809@sol.localdomain>
 <Zq16_XsbZrmfnc4q@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zq16_XsbZrmfnc4q@gondor.apana.org.au>

On 2024-08-03 08:34:05 [+0800], Herbert Xu wrote:
> On Fri, Aug 02, 2024 at 09:28:32AM -0700, Eric Biggers wrote:
> >
> > Note that kfree() lacks a might_sleep(), and its kerneldoc does not say that it
> > can sleep.  Have you checked for other instances of this same problem?  It seems
> > it would be quite common kernel-wide.  Is it really necessary that kfree() takes
> > a sleepable lock on PREEMPT_RT?
> 
> Agreed.  kfree() gets called in all sorts of places under softirq
> context in the network stack which would presumably have the same
> issue.
> 
> Please give a bit of context of when kfree started doing this.

I added "under PREEMPT_RT" in the patch description. The softirq under
PREEMPT_RT does not disable preemption so it is fully preemptible.
The other accelerated versions drop exclusive FPU access/ enable
preemption during these operations even on ARM/ ARM64.

> Cheers,

Sebastian
