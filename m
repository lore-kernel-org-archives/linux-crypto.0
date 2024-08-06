Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E401A3C092
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2024 07:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722930379; cv=none; b=glt+6fFRSt/HiJ9iVnukID8ov6Gj8VbMgt9BNODttlyiPiB25p3VxTAIDJwMpFC+0Tg90HejJrSdUq315yB5FfPI7BvVRox6Qy3fxxgHODD7hvleSAX+xhB7gPUk4plfmql3MJ/Efa/cYxZrBBNxEs9rfjopto5VA+uBqDeOHos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722930379; c=relaxed/simple;
	bh=udHVDbouYGd8j7LPqztahda046aGvPYoLEGPAoTnkg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ICBPidwnu2Ianlqd05wdKrfre3R5hUr/rSsTC/LHMw73DOQx4F1z1ETmgntipSOKQjvEG6PaQjljBqkvJkPCO29J+oxsOnad+CXMh7XmU4Xxv+ioOywFmIL92byGe+297AIiT4aFU3NnLA/vywNdkQ9EhpBjgVtUSlaILmm7rYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=1tImh0bw; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=6hM40m1S; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="1tImh0bw";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="6hM40m1S"
Date: Tue, 6 Aug 2024 09:46:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1722930376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dZ3OIIWNWe9/6pNuk2Q02KdvDfWdsfM3xdOX118Zc3Y=;
	b=1tImh0bwcscsu0CUmpna5TtuCh5M8Bm4/9Oz6bcW03xhAOrWoZk51GY6nS10vIUnrJAs95
	0yKRZRI+k+q/z93ISXqwbAZBlarTY7ZAWCOgUdStLmqPqpOpJ4H0aeipNbt2DEB9G6p7xI
	wMnwlmmehhhIsMDCJ3oe7wBRyOBerRdFLBjLJ8n5oQ7JhANmSvFX+dyy3CHaxqWmwztIBK
	8Y4pQSUN5yBwp+naIzf/2D8Qci3G3ADSzxaVzybV1nIvjUMbHBgz1zVsrINLVtiPV56X4d
	bJiqxyge6NCAN5OD/a6eaFCY3gNXJKfXG7+5A/28SJ/pKB6QeRy09JW3mGhTFw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1722930376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dZ3OIIWNWe9/6pNuk2Q02KdvDfWdsfM3xdOX118Zc3Y=;
	b=6hM40m1SWSm8Ay8BGuQFRvYBDgJBpRQ/N2wGtnzY7lP9KQoQZRzGNCU1nfDfyRsknX9qZC
	sDd9nRH+QXBgeYBA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] crypto: x86/aes-gcm: Disable FPU around
 skcipher_walk_done().
Message-ID: <20240806074614.2c9Y52Lt@linutronix.de>
References: <20240802102333.itejxOsJ@linutronix.de>
 <20240802162832.GA1809@sol.localdomain>
 <20240805084121.XVnJxnOk@linutronix.de>
 <20240805173826.GA1564@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240805173826.GA1564@sol.localdomain>

On 2024-08-05 10:38:26 [-0700], Eric Biggers wrote:
> No, it was intentional.  See the comment above the first kernel_fpu_begin=
() in
> gcm_crypt():
>=20
> 	/*
> 	 * Since the AES-GCM assembly code requires that at least three assembly
> 	 * functions be called to process any message (this is needed to support
> 	 * incremental updates cleanly), to reduce overhead we try to do all
> 	 * three calls in the same kernel FPU section if possible.  We close the
> 	 * section and start a new one if there are multiple data segments or if
> 	 * rescheduling is needed while processing the associated data.
> 	 */
> 	kernel_fpu_begin();

Okay.

> > > Note that kfree() lacks a might_sleep(), and its kerneldoc does not s=
ay that it
> > > can sleep.  Have you checked for other instances of this same problem=
?  It seems
> > > it would be quite common kernel-wide. =20
> >=20
> > kfree() can't have a might_sleep() because it does not qualify for this
> > since you can use it in softirq context for instance with an acquired
> > spinlockt_t on !RT which would trigger it.
> > On PREEMPT_RT interrupts are threaded, softirq is preemptible,
> > spintlock_t is a sleeping lock so all these things where a kfree()
> > would have been invoked in preempt-disable context on !PREEMPT_RT is
> > actually preemptible on PREEMPT_RT.
> > This is of course not true in cases where preemption is explicitly
> > disabled like in this case.
>=20
> WARN_ON(!preemptible()) then?
>=20
> If I add that to kfree(), it triggers from lots of other places.  Are tho=
se
> problems on PREEMPT_RT too?

Nope, shouldn't. On PREEMPT_RT you can only invoke kfree() or kmalloc()
=66rom preemptible context. This is not a problem since interrupts are
threaded, softirqs are preemptbile,=E2=80=A6

> What I am trying to get at is what debugging options do I need to detect =
issues
> like this.  Is there really no option other than actually running a PREEM=
PT_RT
> kernel?

There is PROVE_RAW_LOCK_NESTING but this only catches something like
raw_spinlock_t -> spinlock_t or using a spinlock_t in an interrupt
handler that won't be threaded. It won't find anything where you disable
interrupts or preemption on purpose.

> I had tested this code with lots of debug options pre-merge and nothing c=
ame up.
>=20
> If there was something in CONFIG_SLUB_DEBUG, for example, I would have se=
en
> that, and you would never have had to deal with this issue at all as it w=
ould
> never have been introduced.

Don't worry. I didn't think for a second that there was lack of testing
on your side.

> - Eric

Sebastian
