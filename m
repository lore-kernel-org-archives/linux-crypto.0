Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FC1345EB1;
	Wed, 22 Jul 2026 19:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784749227; cv=none; b=kS7WxQ+EeW3gMtZ+aSYbV39hqWC0VAAkx2mz3Wlh0cJiCSXFlLn90JNR9F0o81ucyAG8o3/hKH29q+M4Hqrfj2w9JV5ppjJ8tyu1NnswVVTy51eezrg1O/DnlhZgnNSk+p8muN5fCHTypSeMIgU9jJOJXnJmiGawb6zhyLg47LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784749227; c=relaxed/simple;
	bh=+5Ej9HMaoiaMW8sS+tlVbcLnWKY4n4f3MTd9ILnt9TA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HrYk71Lx6kqv1lmE1QCiukb69NCOmNXKOssFyaLGbOzOZL9R4bqH2GCX1aWcCVLvNS1Um8jJrSksic7J1OTBelGn1aLom3OA1GvQQ5hAwCyoFUia81tUmS41fiMnCYWvvqVUaZ0DvdqPYT36cu6IKZPONstfLsAeY1ZbufU7rrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K79vcf2D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K79vcf2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162CF1F000E9;
	Wed, 22 Jul 2026 19:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784749225;
	bh=V3HoiIU9m6qlnn4KOEG4TuTVKNis5K4xt/jfPqB0tRo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K79vcf2DRF2lcd+B0VM55vx8ZWOoLEjq9lkggL/qpSdx6uQSXlLDPTD/7Ps6VIU6u
	 8/Y1O/JJPLqWYFcVLtJQ6HQEjCxkROQCQIX5FFgOSvKADHNoZ942L9pSqUiE25HJAo
	 0NEoprtqgDWkXEzbheSFsNBGBMjyZtQVLq4rfWQlGgq1fzt6xHqqPKw53dJ5OlnZ/T
	 XQ7VzgbS/CarcBrJPIorbu47LP68AM3XzApL9saNUiVkfAiH9FXUdGYYC/Mopmpz2/
	 tRXlbJxACKTN/wPsiu3bdXB2BQnvOpWcWsl2a2cEdp5zJO6F/+sm5yiDEho8bPy+Rj
	 Pq+n4w7y5B9wg==
Date: Wed, 22 Jul 2026 12:40:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Hendrik Donner <hd@os-cillation.de>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/2] crypto: pcrypt - Remove pcrypt
Message-ID: <20260722194023.GB2118@quark>
References: <20260713223234.24812-1-ebiggers@kernel.org>
 <20260713223234.24812-2-ebiggers@kernel.org>
 <37ecba68-947a-45ad-9ec4-361facc06a05@os-cillation.de>
 <20260721195004.GA3383223@google.com>
 <19613c3e-9756-45fc-84b6-b650ba3723a7@os-cillation.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19613c3e-9756-45fc-84b6-b650ba3723a7@os-cillation.de>

On Wed, Jul 22, 2026 at 06:12:16PM +0200, Hendrik Donner wrote:
> Hello,
> 
> On 7/21/26 21:50, Eric Biggers wrote:
> > On Tue, Jul 21, 2026 at 08:59:21PM +0200, Hendrik Donner wrote:
> > > Hello,
> > > 
> > > On 7/14/26 00:32, Eric Biggers wrote:
> > > > pcrypt was originally intended to improve IPsec performance.  However,
> > > > it's no longer useful for that.  Reports from the rare cases that anyone
> > > > has actually tried to use it over the years indicate that it actually
> > > > reduces IPsec performance, e.g.:
> > > > 
> > > > * https://github.com/libreswan/libreswan/wiki/Internals:-Cryptographic-Acceleration#obsoleted-ipsec-accelerations
> > > > * https://users.strongswan.narkive.com/liqTaTq8/strongswan-problem-with-pcrypt
> > > > * https://unix.stackexchange.com/questions/594336/ipsec-multithreading-via-pcrypt-worse-than-single-thread
> > > > 
> > > > It's also undocumented and quite difficult to actually use.  Its design
> > > > is also broken, in that any unprivileged program can enable pcrypt
> > > > systemwide at any time (by instantiating it using AF_ALG).
> > > > 
> > > > Meanwhile, pcrypt has been a regular source of bugs, including at least
> > > > four that have received CVEs.
> > > > 
> > > > Let's just remove it.  No one seems to care about it anymore other than
> > > > people looking for vulnerabilities.
> > > > 
> > > 
> > > my company is a user. We have a hardware platform based on an IMX6 SoC
> > > using IPSec and configure pcrypt using crconf. Current performance
> > > difference:
> > > 
> > > iperf3 -c <IP> --time 60 -R
> > > 
> > > pcrypt:
> > > Download: 107 Mbits/sec
> > > 
> > > No pcrypt:
> > > Download: 59.3 Mbits/sec
> > > 
> > > iperf3 -c <IP> --time 60
> > > 
> > > pcrypt:
> > > Upload: 65.9 Mbits/sec
> > > 
> > > No pcrypt:
> > > Upload: 52.0 Mbits/sec
> > > 
> > > The relevant crypto templates are configured in early userspace and
> > > since i got curious, that has been the case since 2017.
> > > 
> > > Mostly using
> > > 
> > > pcrypt(gcm_base(ctr-aes-neonbs,ghash-generic))
> > > 
> > > nowadays, AES-CBC in the past/as a fallback option.
> > > 
> > > So at least on some platforms there is still a significant performance
> > > boots, at least for downloads in this case.
> > 
> > Thanks for bringing up your use case.
> > 
> > Have you looked into alternative solutions such as Receive Side Scaling
> > (https://docs.kernel.org/networking/scaling.html#rss-receive-side-scaling)?
> > AFAIK it's not just the crypto performance that makes pcrypt unnecessary
> > these days, but also the design of the networking layer.
> 
> I'm looking into this more, the IMX.6 is a bit limited with IRQ handling and
> queue distribution.

Thanks!  Maybe Steffen and the other IPsec folks would have some advice
too.

> > I understand that i.MX6 doesn't have the ARMv8 crypto extensions.
> > However, surely you could at least use the NEON-optimized GHASH code?
> > Is there a reason you're not using it?
> 
> I think it was historically not working well for us, retested:
> 
> NEON GHASH with pcrypt:
> 
> Download: 116 Mbits/sec
> Upload: 74.3 Mbits/sec
> 
> NEON GHASH baseline:
> 
> Download: 90.7 Mbits/sec
> Upload: 60.8 Mbits/sec
> 
> Looks better, still a ~15 Mbit improvement with pcrypt.
> 
> I want to point out that without IPSec our baseline is:
> 
> Download: 942 Mbits/sec
> Upload: 942 Mbits/sec
> 
> Intel IGB ethernet.

That already shows that about two-thirds of the improvement you were
getting from pcrypt can be gotten just by using the correct GHASH
implementation for the platform (59.3 => 90.7 download, vs 59.3 => 107;
and 52.0 => 60.8 upload, vs 52.0 => 65.9).

And with that new baseline, for downloads, pcrypt adds just 28% more
throughput (90.7 => 116) rather than 80% as it did before (59.3 => 107).

It seems clear that the usefulness of pcrypt rapidly decreases as the
actual crypto gets faster.

Note: we've been enabling crypto optimizations by default in recent
kernels, so that people can no longer use the generic code by accident.
For example in v7.1 and later, GHASH optimizations are always enabled.

I'm working on further optimizations to the AES-GCM code as well,
specifically implementing AES-GCM directly on all platforms without the
inefficient gcm_base template that is being used here.

So while maybe pcrypt does still help a bit on this platform for now,
the approach does seem quite dated and largely a workaround for
inefficiencies elsewhere in the stack (including systems where the
optimized crypto code is accidentally not enabled).

- Eric
