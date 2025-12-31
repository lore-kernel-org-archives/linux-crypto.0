Received: from flamingo.larch.relay.mailchannels.net (flamingo.larch.relay.mailchannels.net [23.83.213.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567DD2288CB;
	Wed, 31 Dec 2025 09:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.213.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767172817; cv=pass; b=RMy0RbjIlLL2mnCd9PWaWni7+GIF+77QhsXxHR44GprIs9NBBZavEjWhAGfnq0L6BwJKPVvevr0+sZev49uG3NQuY1QGtegse3a0peebtZvxhH2Of31fMMDMjzZ7BIv0NOb2l7u6RehwsxMQ09+B3YGAxp5EJgAV+Y5fdoCEgy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767172817; c=relaxed/simple;
	bh=+Gh+RTcuZHxpikvwnltiruLDqNo1h8p2r2lmz+EWDEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ejxcPjrQOi2ivWMRr9Kz03mj4CiwNSdbjz7gxW4DkpzJAwIwLfZzRgMWvULPu2ItnHL4hlfl08jtWeLh3SZanp3geQqDgVHgZvaEfcje5yDhizyUP9RG0AqJbWoIzIoA5ZKKTR/GluxgRt1rVzg22AQkdHvHI02vKULWmfwJsC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id; spf=pass smtp.mailfrom=kriptograf.id; dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b=ssNqRLc9; arc=pass smtp.client-ip=23.83.213.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b="ssNqRLc9"
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 2CE3C800524;
	Wed, 31 Dec 2025 09:20:12 +0000 (UTC)
Received: from vittoria.id.domainesia.com (100-112-114-238.trex-nlb.outbound.svc.cluster.local [100.112.114.238])
	(Authenticated sender: nlkw2k8yjw)
	by relay.mailchannels.net (Postfix) with ESMTPA id 95385800406;
	Wed, 31 Dec 2025 09:20:09 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1767172811;
	b=5iEZKy9bSb6Wf4MW3/GvqA0FUP8yNjce2vhSNcztxAQIx8ahs1ExkKcRlUE3psibCAk3Ks
	MPjvzhhUbs8NZK5sy/LJTONVc8EBOgkHqtoNCSqUbzZYOdjNNOJBemguDI2xeaSLKp0gQ1
	2e1JLpoliIyRNCSU1dlcg6sGBuCZ8o+Iw62fosA14JxIlgNBa7C8tMf3ynmHix/zCV7tb1
	lBvOeWLLLyHvF+EZVZXDe1fPI9sNSsGpqXOxHtxrbRZ2IEsPY8sMkU06NpcaWYoD+GctHS
	VJZZJJGYDs/7uw3TxEJHihG9Rsu+YlyraAjquXLF3I2y/QiN6ZrYJnscm/Nvnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1767172811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vOA0HyDb8IPEnJj8z34VUsoxWohtqQNG4IgXP0HlMY=;
	b=mWr3KbWUyPgFLmMZuAP7q+u97PLukE/py4Mre7SkgK9SA4y7x2Y5Hvb8cnf7J6WlVY5LVL
	KmUMaZvr1MXvQ3TOe9YFFMS9/Akt73vUrkgTpcyBC1fjT1vulwv2YVp4fZWdQL95kRSZS+
	X2YfYog0j3JawVgp/Svw+p7nT8DBKvJ0tQ07V0QzxtAbp0MdtDv6R3eKmyOgxEFsV+nXBo
	b5/bme4S2xsN+kQM0JQpSPf8Ypvl5RGgmYcwi8bdETCE1HrVs8TFT6p2QKXLANcfIkopcK
	y1jH7p7RBMVG0Kz21Ycg8W6GmIfIp7fTwuMEdBrL2y3sRErzmF8cHrHQt7QqPw==
ARC-Authentication-Results: i=1;
	rspamd-85db7f4c96-t7gj4;
	auth=pass smtp.auth=nlkw2k8yjw smtp.mailfrom=rusydi.makarim@kriptograf.id
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MC-Relay: Junk
X-MailChannels-SenderId: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MailChannels-Auth-Id: nlkw2k8yjw
X-Lettuce-Bitter: 2413a67e761ef21e_1767172811486_483830145
X-MC-Loop-Signature: 1767172811486:4247055270
X-MC-Ingress-Time: 1767172811486
Received: from vittoria.id.domainesia.com (vittoria.id.domainesia.com
 [36.50.77.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.112.114.238 (trex/7.1.3);
	Wed, 31 Dec 2025 09:20:11 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kriptograf.id; s=default; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5vOA0HyDb8IPEnJj8z34VUsoxWohtqQNG4IgXP0HlMY=; b=ssNqRLc9fN7At5g/eQiymnpMza
	wV/iQoFA90cMMqGB8oBi8lPCwak89Lk0wSyjw2KU65s1uQiVtQP7qGTVD8z13DLp3AC6GjInNi3IY
	7HCLFK7qNA13LMIsUgT1joYLnFsnAc0r8uZ+JlCYrwRZTXUqY/Ls1IOyq59C6/IvAKJe2rIeNMNgc
	QWEwyE++nEuLZ3YCRV40FmukciB98VQMXHwfVVAm+cgVOpMfje349d721v3MsxuRpRfv/BTwPyHy3
	XWQbnK9dL+HNkH3PODaByYkbEK2Oy3i5WjNdWrbXda6m2tUTmbfL8BIQOHGf+kVf1dZ33OjUtGpTf
	5mDkpAvQ==;
Received: from [182.253.89.89] (port=27919 helo=Rusydis-MacBook-Air.local)
	by vittoria.id.domainesia.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99)
	(envelope-from <rusydi.makarim@kriptograf.id>)
	id 1vasND-0000000AzUh-3XOg;
	Wed, 31 Dec 2025 16:20:06 +0700
Date: Wed, 31 Dec 2025 16:20:40 +0700
From: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] Implementation of Ascon-Hash256
Message-ID: <aVTq6HaRr4G2gmho@Rusydis-MacBook-Air.local>
References: <20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id>
 <20251215201932.GC10539@google.com>
 <7920c742b3be0723119e19e323dc92bc@kriptograf.id>
 <20251216180245.GD10539@google.com>
 <bb05699bc7922bb3668082367b4750f2@kriptograf.id>
 <20251217040617.GA3424@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217040617.GA3424@sol>
X-AuthUser: rusydi.makarim@kriptograf.id

On Tue, Dec 16, 2025 at 08:06:17PM -0800, Eric Biggers wrote:
> On Wed, Dec 17, 2025 at 10:33:22AM +0700, Rusydi H. Makarim wrote:
> > On 2025-12-17 01:02, Eric Biggers wrote:
> > > On Tue, Dec 16, 2025 at 01:27:17PM +0700, Rusydi H. Makarim wrote:
> > > > While no direct in-kernel use as of now
> > > 
> > > Thanks for confirming.  We only add algorithms when there is a real
> > > user, so it's best to hold off on this for now.
> > > 
> > > - Eric
> > 
> > Rather than leaving this work idle, would it be better to move the
> > implementation entirely into the Crypto API ?
> 
> No, that's actually the most problematic part because it would put it in
> the name-based registry and become impossible to change later.
> 
> There's a large maintenance cost to supporting algorithms.  We've
> learned this the hard way.  In the past the requirements to add new
> algorithms to the kernel were much more relaxed, and as a result, the
> Linux kernel community has ended up wasting lots of time maintaining
> unused, unnecessary, or insecure code.
> 
> Just recently I removed a couple algorithms (keywrap and vmac).  Looking
> back in more detail, there was actually never any use case presented for
> their inclusion, and they were never used.  So all the effort spent
> reviewing and maintaining that code was just wasted.  We could have just
> never added them in the first place and saved tons of time.

Looking at both lib/crypto/ and crypto/ directories, I initially did not
have an impression that mandatory in-kernel use of a cryptographic hash
function is a strict requirement for its inclusion in the linux kernel.
Such requirement is also not mentioned in the section "Adding New Algorithms"
of https://docs.kernel.org/crypto/api-intro.html. Now that you give a
historical context of it, so I completely understand your point.

> So this is nothing about Ascon not being a good algorithm, but rather
> we're just careful about adding unused code, as we don't want to repeat
> past mistakes.  And as you've made clear, currently you'd like to add
> the algorithm just for its own sake and there is no planned user --
> which is concerning.  I'm not sure if this is a school project or what
> not, but we don't really do that, sorry.  There has to be a clear
> technical justification with an in-kernel use case.

I am an external contractor working for a client that asked an implementation
of Ascon family of algorithms in the linux kernel, but did not disclose
its use case.

Just a heads up: I will send v2 of this patch to fix a compilation error
and a build warning. I will also send a separate patch that implements
Ascon-XOF128 and Ascon-CXOF128. I hope you understand that I simply have to
finish the tasks assigned to me, and these are not meant as an attempt to
put pressure for their acceptance.

On the other hand, I am also keen to see its possible use cases in the linux
kernel. Ascon-Hash256 specifically can be an alternative to SHA-256. For
instance, it can be an additional option of hash function in fs-verity for
processors with no SHA256 dedicated instructions. If that something that
interests you, I am open for further discussion.

> - Eric
>

Best,
Rusydi
