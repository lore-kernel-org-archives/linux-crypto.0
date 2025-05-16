Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F0E1A704B;
	Fri, 16 May 2025 20:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747427676; cv=none; b=o3UY2A4oI8pgIBfOL9fwLhBdCx/GEGFOUfoo0nkcqjpqiIwqgszDp5vCNZUU9fKqMYLfaXmBgecECSA65oOP8eFRSHeKPTQNGRLN/kBuUadhBQE8culUO1wpPAiVsn8HbOkKI8A19uVRa0vriCVlAOQQya/hbwmTHwC+dELvQF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747427676; c=relaxed/simple;
	bh=oDITZp2JUKinj2OF3yzLkCxXdgtggFHsz66jrQHnX7E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gyuYGx9Ef9KiGWS1KgsKlwMElorF2TaRZagNaxM/3E1IHZ3zvs0Hzhl/5V6ZbXmIe27hNwGmH9gksH/8VjJGniffJhLuxft0/zr5rG+jtdGgP35VyNLM4U83dfYnqk2HRFZKeeQKrLhBKkUSac/DT1U6zp0TIfNzNbqltT08iTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=bEcwge25; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=6+GOcLMP; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="bEcwge25";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="6+GOcLMP"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1747427672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5NrUWaZXoz1DpdYXQ04WhnkJI4EjPXUKE2xGFcUiCM0=;
	b=bEcwge25WHvSPXYxmX1EfAKXU+1OW8cAagPhMlF24quearlFyfmB4OieaWIft/TYqRRE95
	CcWbMNoB5ytdvw59wXJ4rnKseIZ7YAmUaLwT1G3zjQFPGCwxmMSEMppiL9B7hZgrKPwuH8
	tG9RgFztCg/fAyfir7s2fR/dJoGaraOSSemPNTjs96K8cz26wvS7YAgBo0hVkFA2R8ckoe
	gowBIh/wAiY4/vODFZjxSaMh5vsYQdU29arGEqUoDus19NOsI6GVpzgZ6IibZ4EYh257Dh
	21l5NcaZRT7NFFHpgRdLTpJY+6TIXlCbx3eokDO65fDme0zbeULp39CZ1QUmKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1747427672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5NrUWaZXoz1DpdYXQ04WhnkJI4EjPXUKE2xGFcUiCM0=;
	b=6+GOcLMPecrhZkZJmyFAjBKqTblvXaeC0BAYdi0zoR4KZm5RCGrye9urGVI335Db781haK
	e6bq6QJ9p9h0piAA==
To: Eric Biggers <ebiggers@kernel.org>, Borislav Petkov <bp@alien8.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Jain@formenos.rohan.me.apana.org.au, Ayush <Ayush.Jain3@amd.com>, Stephen
 Rothwell <sfr@canb.auug.org.au>, x86-ml <x86@kernel.org>, lkml
 <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/sha256 - Disable SIMD
In-Reply-To: <20250516190637.GA32835@sol>
References: <20250516112217.GBaCcf6Yoc6LkIIryP@fat_crate.local>
 <aCcirrsFFrrRqf5A@gondor.apana.org.au>
 <aCcmJGuCnuyHmHbx@gondor.apana.org.au> <20250516170316.GD1241@sol>
 <20250516181322.GGaCeAQjnIVQx_tX_R@fat_crate.local>
 <20250516190637.GA32835@sol>
Date: Fri, 16 May 2025 22:34:31 +0200
Message-ID: <878qmwi9bc.ffs@tglx>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, May 16 2025 at 12:06, Eric Biggers wrote:
> What would you say about going back to my earlier plan to make irq_fpu_usable()
> return false when irqs_disabled(), like what arm64 does?  (As I had in
> https://lore.kernel.org/lkml/20250220051325.340691-2-ebiggers@kernel.org/).

> +	return !this_cpu_read(in_kernel_fpu) &&
> +		!in_hardirq() && !irqs_disabled() && !in_nmi();

The !in_hardirq() is redundant because hard interrupt context runs with
interrupts disabled.

> I think that would handle all these cases, as well as others.  We'd need to fix
> __save_processor_state() to save the FPU state directly without pretending that
> it's using kernel-mode FPU, but I don't know of any issues besides
> that.

Looks about right.

> Then we could also delete the irqs_disabled() checks that I added to
> kernel_fpu_begin() and kernel_fpu_end().

Yes. That conditional locking is horrible.

Thanks,

        tglx
