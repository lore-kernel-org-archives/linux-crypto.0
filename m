Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB320208A7
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 18:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758218810; cv=none; b=r4rhS9ZvOYzrAhAviuFKgHSD/Gm6wUANCdunEp7WvivMAOUpnvOlRXACPEU5sJgLmIrTbm/C1++GsRrpoy3PnYSevd1xyhCmdoup73nPhPmW0VVHYdjjQvO2BeIbU0RijWIDsVMIH7xDzisMwpzH/K/9bV0/rxSJlrsgDpCdFgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758218810; c=relaxed/simple;
	bh=hW/B/hDwwwq85sob2I3bPSmUk7McTgzjn5na0T6VC5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TWXpo0EUbEo5T3Y67PqoH8JJlreiwuXkVKN1H2BJYwlJhZSW1t7c8KjrduFHFpmLXyEXtxGPm1P18yNj6Al5Fnpk8gk0udM3S+LVXNOuVSZ8YZB+9SSQMPuxQK9XOoT8UMfvIZWUoLJV2zQ00epGM06/4eOwHJQcdLqgGTsCaAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQmhj7vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQmhj7vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D908CC4CEE7;
	Thu, 18 Sep 2025 18:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758218810;
	bh=hW/B/hDwwwq85sob2I3bPSmUk7McTgzjn5na0T6VC5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GQmhj7vfgSgKC/ZGqwgZlzgzuO9Pmgt9pcT4Owahs5egzSeVcMDHM+Y89zgRYBnkd
	 Z5zoBjqp5ojV579z2QyIAljSKW7kVX7XzUfXJKqvg7ac9x8c6wil9lc9JnwBFyoC5h
	 NaPSMnRWIcPzcf+cSnAahloxiP7Ok9XJoM5EvMp5xY/5avdUeWjwDSJMbW3mRb7O2b
	 UgVAcpuagPVLYKUN4uyAv7FJ368jw5bDankon0R9hrKb9oVxKBbG7TDKucY7jtDT1t
	 duKHhsIuFz1yNrg8yaAHjL/9tc3rARcAvLeS54NXAxDAVm52WVXTe+/+AQXMUnsUTL
	 BFC+3HcEcnDaQ==
Date: Thu, 18 Sep 2025 13:06:47 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Joachim Vandersmissen <joachim@jvdsn.com>
Cc: linux-crypto@vger.kernel.org, simo@redhat.com
Subject: Re: FIPS requirements in lib/crypto/ APIs
Message-ID: <20250918180647.GC1422@quark>
References: <0b7ce82a-1a2f-4be9-bfa7-eaf6a5ef9b40@jvdsn.com>
 <20250918163347.GB1422@quark>
 <3e06f746-775e-4b9e-93c9-d1f51f77148f@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e06f746-775e-4b9e-93c9-d1f51f77148f@jvdsn.com>

On Thu, Sep 18, 2025 at 12:48:52PM -0500, Joachim Vandersmissen wrote:
> Hi Eric,
> 
> On 9/18/25 11:33 AM, Eric Biggers wrote:
> > On Thu, Sep 18, 2025 at 11:00:45AM -0500, Joachim Vandersmissen wrote:
> > > Hi Eric,
> > > 
> > > I'm starting a new thread since I don't want to push the SHAKE256 thread
> > > off-topic too much.
> > > 
> > > One simple example of a FIPS requirement that I currently don't see in
> > > lib/crypto/ is that HMAC keys must be at least 112 bits in length. If the
> > > lib/crypto/ HMAC API wants to be FIPS compliant, it must enforce that (i.e.,
> > > disallow HMAC computations using those small keys). It's trivial to add a
> > > check to __hmac_sha1_preparekey or hmac_sha1_preparekey or
> > > hmac_sha1_init_usingrawkey, but the API functions don't return an error
> > > code. How would the caller know anything is wrong? Maybe there needs to be a
> > > mechanism in place first to let callers know about these kinds of checks?
> > > 
> > > It would be great to have your guidance since you've done so much work on
> > > the lib/crypto/ APIs, you obviously know the design very well.
> > That's misleading.  First, in the approach to FIPS certification that is
> > currently (sort of) supported by the upstream kernel, the FIPS module
> > contains the entire kernel.  lib/crypto/ contains kernel-internal
> > functions, which are *not* part of the interface of the FIPS module.
> > So, lib/crypto/ does *not* need to have a "FIPS compliant API".
> 
> Please correct me if I'm wrong, but are the lib/crypto/ APIs not exported
> for everyone to use? Even if the entire kernel is the FIPS module, wouldn't
> that mean the APIs could be used by e.g. dynamically loaded kernel modules?
>
> You are right there are some nuances about the HMAC key lengths, as with
> most FIPS requirements. There's other FIPS requirements, like tag sizes for
> HMAC, or IV generation for AES-GCM encryption, that also have very similar
> nuances.
> 
> I'm more trying to figure out a general approach to address these kinds of
> requirements. What I usually see in FIPS modules, is that the FIPS module
> API is as conservative as possible, rather than relying on the callers to
> perform the FIPS requirement checks.

Aren't these distros including the modules within their FIPS module
boundary too?  It seems they would need to.

Either way, they've been getting their FIPS certificates despite lib/
including non-FIPS-approved stuff for many years.  So it can't be that
much of an issue in practice.

- Eric
