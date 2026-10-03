Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01CB330676;
	Sat,  3 Oct 2026 17:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791049070; cv=none; b=NJtojdzkBaC28XUnFMvZzV2A/goGHu0Bj2ja8G4TxZkabreJCgdyYVQm+34PdvtjQuBziHUgzU/I+c57ObroZMJ4H8JPxSVX0kGT1K+BaGIPMPNj2gcCuLJcnAVEZSvn0iot78O6PgcBGZs6eXca59WEmoNrNWOGtB7V8EtaX1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791049070; c=relaxed/simple;
	bh=N2mlPGr3KJtQ7HJcI33ecwGbwBRP0Il+vtWsix3/HoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TgqIP+DxSY9dL+bSweLBQG3Qq1E0ud8dG/jPKo6C9YEsyP1qgYaFd1N42dcRwW5ipasN2zask/eVnlXDdnNuFobB3MCFeWy+zkjGF1HiqfpFNL3CnJijy/Fmq2hG7rGYdw18TcABn9jZznYn0Z9x56ud9X/atMd4RG4jAq5+sEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJaP+B5k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJaP+B5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB69F1F0089B;
	Sat,  3 Oct 2026 17:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791049069;
	bh=rgUQWSplCJn9QoMhBsViDTTXDkHysnhRtJ3gvU0TiP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XJaP+B5kJLeTgWSBzCu0bMFjEiewAKI6GDVmTd3Q8ez6Y2ZwRUrXH3aW90cSvlHs1
	 c8kPasn4Dn+zGGvSa4ygtJYs243eq+LQ/43to677orMeoRDJsHB+Hq499PApwzXIox
	 rlsOc04af9DK8s5y9sGhDiw+r69mVZITZFHF8Kl63B2DyEQcWJD9Ohc/mljOv6n3hx
	 ThaQT1x/BDfEAapP7mJHww/+lkJ6biaZ1zFbFncL2QGASQOc88LJMcMw5vI3WjiAJM
	 ifuSbs0+FOg44VwYBMvtbbhCNzpEZ07CcsFDizlIpiJ59GHBeJM/3knDeFaHRjuv0U
	 TiW6kW8bvIFIA==
Date: Sat, 3 Oct 2026 19:37:44 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: Justin Forbes <jforbes@fedoraproject.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow hmac(sha512) for unpriviledged users
Message-ID: <20261003173744.GA158720@quark>
References: <20261003160302.3000325-1-jforbes@fedoraproject.org>
 <20261003161859.GA152469@quark>
 <asE128W4CxHDCFiB@fedora64.linuxtx.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asE128W4CxHDCFiB@fedora64.linuxtx.org>

On Sat, Oct 03, 2026 at 11:05:31AM -0600, Justin Forbes wrote:
> On Sat, Oct 03, 2026 at 06:18:59PM +0200, Eric Biggers wrote:
> > On Sat, Oct 03, 2026 at 10:03:02AM -0600, Justin M. Forbes wrote:
> > > By default users cannot run sha512hmac with the current set up. This
> > > is problematic because our kernel builds call this for FIPS compliance.
> > > Rather than have anyone turn off af_alg_restrict all together, let's
> > > allow a common use case.
> > > 
> > > Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
> > 
> > The fips hook in dracut was taken into account already, and it runs as
> > root.  So this patch shouldn't be needed.  Can you clarify why you think
> > it is needed?
> > 
> > - Eric
> 
> Specifically for the case of Fedora and all Red Hat kernels, we call
> sha512hmac to sign the kernel, and a couple of UKI images that are
> created during the kernel build. Users on Fedora 45 and newer are now
> unable to build the kernel from spec without turning off af_alg_restrict
> all together, while any user can build a kernel on Fedora 44 or older.

I see, it's in redhat/kernel.spec.template in the Fedora kernel source
tree which is used when packaging the kernel into an RPM package.
Please make that super clear in your commit message, because it wasn't
clear you were talking about something different from the use in dracut.

I guess the actual diff is fine then, since something like this that's
being used should continue to be allowed.

Of course, this is yet another gratuitous use of AF_ALG, as I've
explained previously
(https://lore.kernel.org/r/20260504173952.GA2291@sol/).  Depending
AF_ALG to build the kernel (vs. just using OpenSSL for example) is even
more misguided than using it in the integrity check itself, as at least
there are FIPS boundary considerations for the integrity check itself,
but those are irrelevant for the build tools.

So even though this will keep being allowed for now, please work to get
this fixed to not need AF_ALG.  Note also that Fedora 45 explicitly
deprecates AF_ALG (https://lwn.net/Articles/1088489/) on top of the
already-documented upstream deprecation.

- Eric
