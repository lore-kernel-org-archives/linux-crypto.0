Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D90D470451;
	Tue, 21 Jul 2026 19:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663407; cv=none; b=odlV0Vzv8TPySDosB24K/Ak4XB2VdPxKEWDChiK4O6ieqVdVMJB4vCAXVb5O42Ez5NYSBoHJC8mpm2pUOs6uyFdD9Uq6scr1PlkS+u8UPpR94HHMqypV2Xjxojqj1jWhO+y6nifi+V5Euu9YQUDVB+YR9r5p8vQrmDb3QWe5NUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663407; c=relaxed/simple;
	bh=EpvXUFJmaTHJTzKTlbzIHJMgfkEgqWDNsf9y96DZH1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eBgEcwpq91/Jm8FT01mJ4fPNH34MduVo7iXZUXBvAVgic4BoMvRuCf9euH2LCwfnSgK/fKHy0An/FgYgXTkYsN93dojNyAHaLYBXH8m21lL8eKEKgDCFTedL+zJ60iqQLWdZ4tPiNfJxgn83I+Fxe3zl7TZ/sAnKCtTWoP2tbnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cwL2T6mh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cwL2T6mh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AF81F00A3A;
	Tue, 21 Jul 2026 19:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784663406;
	bh=7w9900dAZNqZ/4nI/Tsr/deCRjs5pr6BaXEj4g+eCyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cwL2T6mhGhK9N2ZOqLBhrto7Qbm2Wrp0pF2aApKdp8xRNf+5prWw4N/HOoFDHZop9
	 l+Fuzv/LQnMa5opwfwe3lXuN0/hwA6hXtdJJ8bDPzEnPSIl0QYcaL9sL1nJwGQ8iRA
	 2n13Ms1ZBNa8bBITauDFk+42zt+24VQX4G6XpTFo13CTaw483aWJ1b4TgNofqFIXHR
	 8Ehbo9SmgI3KNBCQENlRZ6kTNHRZISiWotpknKTRCglLJlXMLxQqlXelopIJS09obY
	 OHgQON5OjRkoG65h9x8A2DiPvfq1xg5zS4aQ1Zx7H2BCLySZjKbbmzRTYbGCzkC3hu
	 XjC08rD6XDR6w==
Date: Tue, 21 Jul 2026 19:50:04 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Hendrik Donner <hd@os-cillation.de>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/2] crypto: pcrypt - Remove pcrypt
Message-ID: <20260721195004.GA3383223@google.com>
References: <20260713223234.24812-1-ebiggers@kernel.org>
 <20260713223234.24812-2-ebiggers@kernel.org>
 <37ecba68-947a-45ad-9ec4-361facc06a05@os-cillation.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37ecba68-947a-45ad-9ec4-361facc06a05@os-cillation.de>

On Tue, Jul 21, 2026 at 08:59:21PM +0200, Hendrik Donner wrote:
> Hello,
> 
> On 7/14/26 00:32, Eric Biggers wrote:
> > pcrypt was originally intended to improve IPsec performance.  However,
> > it's no longer useful for that.  Reports from the rare cases that anyone
> > has actually tried to use it over the years indicate that it actually
> > reduces IPsec performance, e.g.:
> > 
> > * https://github.com/libreswan/libreswan/wiki/Internals:-Cryptographic-Acceleration#obsoleted-ipsec-accelerations
> > * https://users.strongswan.narkive.com/liqTaTq8/strongswan-problem-with-pcrypt
> > * https://unix.stackexchange.com/questions/594336/ipsec-multithreading-via-pcrypt-worse-than-single-thread
> > 
> > It's also undocumented and quite difficult to actually use.  Its design
> > is also broken, in that any unprivileged program can enable pcrypt
> > systemwide at any time (by instantiating it using AF_ALG).
> > 
> > Meanwhile, pcrypt has been a regular source of bugs, including at least
> > four that have received CVEs.
> > 
> > Let's just remove it.  No one seems to care about it anymore other than
> > people looking for vulnerabilities.
> > 
> 
> my company is a user. We have a hardware platform based on an IMX6 SoC
> using IPSec and configure pcrypt using crconf. Current performance
> difference:
> 
> iperf3 -c <IP> --time 60 -R
> 
> pcrypt:
> Download: 107 Mbits/sec
> 
> No pcrypt:
> Download: 59.3 Mbits/sec
> 
> iperf3 -c <IP> --time 60
> 
> pcrypt:
> Upload: 65.9 Mbits/sec
> 
> No pcrypt:
> Upload: 52.0 Mbits/sec
> 
> The relevant crypto templates are configured in early userspace and
> since i got curious, that has been the case since 2017.
> 
> Mostly using
> 
> pcrypt(gcm_base(ctr-aes-neonbs,ghash-generic))
> 
> nowadays, AES-CBC in the past/as a fallback option.
> 
> So at least on some platforms there is still a significant performance
> boots, at least for downloads in this case.

Thanks for bringing up your use case.

Have you looked into alternative solutions such as Receive Side Scaling
(https://docs.kernel.org/networking/scaling.html#rss-receive-side-scaling)?
AFAIK it's not just the crypto performance that makes pcrypt unnecessary
these days, but also the design of the networking layer.

I understand that i.MX6 doesn't have the ARMv8 crypto extensions.
However, surely you could at least use the NEON-optimized GHASH code?
Is there a reason you're not using it?

- Eric
