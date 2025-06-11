Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B2B1D5CDD;
	Wed, 11 Jun 2025 20:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749672851; cv=none; b=hkWqgu3Ri+ij6kP/at9l5pdSJhtyiMhSGSiotlh46jezsZaBqgM55IuSygoB0EGRJJFZRWHKRJMeZyvp+JxB6mfuU6WSQtNH7r8KkkCp/UPiXryhYmq5KarwiZ7iLiw6C30bJnmqHH5xf+i4Fdccz/TazwH7cHUUZO2936sdJfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749672851; c=relaxed/simple;
	bh=pc4A14uBtyU5JBH56xfhuBFcz0wfEaJnMR+dxnKdUmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bdEUniD866/F2g6I4+nI8392bGnJPJD554sm5YFeDck+lYCJcOJGlFDHsu2/RDV19s8m6KDHVAOfkZvJEzRqmp83mqRrmpVRtLEFMlINiUHM+Xg6ktV8OUZXU01e+qrzNpT58yZAjeXDGC2UU/rdQWDrpHKriNM57T9OVAqjaBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuZNdPTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuZNdPTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74D4C4CEE3;
	Wed, 11 Jun 2025 20:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749672850;
	bh=pc4A14uBtyU5JBH56xfhuBFcz0wfEaJnMR+dxnKdUmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NuZNdPTKe0zGFI9gQLWE8FNtgpYjh+X7k+lHSctapDyd2JYhOcDKZpKToP1y/X5uD
	 YoOLq9tcnE7TFzJWaCJiOQRUEkJed2CZlnW7h1S31mi5v6bE3YnJHMPmPu419XVXTA
	 QZYGtKOYa48qXvYu922pgQjpklTe0KfZ/MGYsCcXE1M0H/dbwD1vDwiCJZMNhlCOgO
	 wKuN0t6r0lU4sPEQmMVIOAMl3IvGA6V82MDbLUuwGWpieny23xdvQcz6NoMhXsneId
	 Ee4LEwwUyJIBnEZlNAdSDPuNVEWuFZQpoxCgMfu6EpWk8pCq/0z+1ZSdtchRqBfs+b
	 Q7V8PgA/9AhDA==
Date: Wed, 11 Jun 2025 20:14:08 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Diederik de Haas <didi.debian@cknow.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, Ingo Franzki <ifranzki@linux.ibm.com>
Subject: Re: [PATCH] crypto: testmgr - reinstate kconfig support for fast
 tests only
Message-ID: <20250611201408.GB4097002@google.com>
References: <20250611175525.42516-1-ebiggers@kernel.org>
 <DAJXJHLY2ITB.3IBN23DX0RO4Z@cknow.org>
 <20250611190458.GA4097002@google.com>
 <DAJYOYMK9UJD.LB0N2L64FFA@cknow.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DAJYOYMK9UJD.LB0N2L64FFA@cknow.org>

On Wed, Jun 11, 2025 at 09:47:27PM +0200, Diederik de Haas wrote:
> On Wed Jun 11, 2025 at 9:04 PM CEST, Eric Biggers wrote:
> > On Wed, Jun 11, 2025 at 08:53:17PM +0200, Diederik de Haas wrote:
> >> I was about to respond to your reply, but I guess this may be a better
> >> fit for it. The TL;DR: version is this:
> >> 
> >> If you think distros shouldn't enable it, as you initially clearly
> >> described and it seems to me you still think so, the right thing for
> >> distros to do, is to disable those test. Which in turn means the fast
> >> tests should not be reinstated (?).
> >
> > I mean, not enabling the tests in production is how it should be.
> >
> > But Fedora already enabled CRYPTO_SELFTESTS, apparently because of FIPS
> > (https://gitlab.com/cki-project/kernel-ark/-/merge_requests/3886).
> 
> That is recent and there's at least 1 person I recognize as having
> proper expertise in this matter ;-)

FWIW, here's an example from just today where the crypto self-tests prevented a
buggy driver from being used in Debian:
https://lore.kernel.org/linux-crypto/20250611101750.6839-1-AlanSong-oc@zhaoxin.com/

> > throw untested and broken hardware drivers over the wall at users.  As long as
> 
> Only speaking for myself, my *assumption* is that crypto functionality
> in hardware is/should be faster and would lessen the load on the CPU
> (which with several SBCs seems really worthwhile).

Often the hardware offloads are actually slower.  They require sending the CPU
an interrupt once the operation is done, which has a lot of overhead.  They also
tend to be optimized for throughput rather than latency, and only provide good
throughput when given a large number of concurrent requests.

Inline encryption does actually work, but that is a separate type of accelerator
and not what we're talking about here.

- Eric
