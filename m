Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765F438A722;
	Tue, 23 Jun 2026 18:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782237905; cv=none; b=iXWlHGpqPjrjmq8LyBMo1Uv/z4TMucVtNBwLhRbpZX957QNfL78DMsDTGauyWsYfmV1/ehS0UHpW6AzRPtKgcIv/iYpAFTEvjxvQXDNNvuNpFeTqTenVfoGqKH7RLEX0in/dGAnLesHdyS8PSlvMPOyPJEt4gmJSZ+QCFWwTcZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782237905; c=relaxed/simple;
	bh=laPZuoKzOlRgjMu009Sv1XuC5u1F5zM24h/pb88UUgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gvzn2ZmUWOejzase+GBWEw3pFDxTYm0jtIkYJ/7PUrjeYxCKpfmJ0ZtICpWfJyPWIcF78Fzk6GXw+z+/eRcfNM3w51FSJtfSjpxovoGoWVr5GjDCAdYN6DMBPimKW5lA/qEd7q50OtXn5LDFW36OSVp7j9I/SuKhCsaN7WwAFkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LOuNqKAa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOuNqKAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE4F1F000E9;
	Tue, 23 Jun 2026 18:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782237904;
	bh=DcbPuct3JcioZ7MKEBA7Z8jvWe10D5XpmKWh6eWGb4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LOuNqKAa9bECpMHiIJ8rhDaCCQpm6/yHxaGtZrvh8/E4Z2q40mqJ3tKyCL6745HV8
	 x6GAW3AtEFeW/BFVRLXn3gEITy3i/MLrxsoicNPIUuF8GlEvNdEurHp0LHeejWM3i2
	 tj2jsrBf3KM1a0oOLrlLZaI/JhUYqL5bDGo1ki+dklz42tz76Ogh7AWA3AG5HSSXMx
	 OFLm1bBiI4U3eq/Cnl/cqg8SREI57wgZ6BXkPCQXUFSCgwAwf318FOEbd/OYVTSW02
	 Nd9rGlZYX8uzFJ5MWMQRNxHe8pSKdhW3t0Vapq5uwLwTA+tMc625EWDpZ4nPoZ9mXt
	 nouimSdmHgFSw==
Date: Tue, 23 Jun 2026 18:05:02 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev,
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
Message-ID: <20260623180502.GC1850517@google.com>
References: <20260622234803.6982-1-ebiggers@kernel.org>
 <CABBYNZ+QLvkYkn_EcBZ4+GopyhKqJLcfCoABYcw1VamavbSvhg@mail.gmail.com>
 <20260623165208.GB1793@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623165208.GB1793@sol>

On Tue, Jun 23, 2026 at 09:52:08AM -0700, Eric Biggers wrote:
> On Tue, Jun 23, 2026 at 11:04:14AM -0400, Luiz Augusto von Dentz wrote:
> > > +===  ==================================================================
> > > +0    AF_ALG is unrestricted.
> > > +
> > > +1    AF_ALG is supported with a limited list of algorithms. The list
> > > +     is designed for compatibility with known users such as iwd and
> > > +     bluez that haven't yet been fixed to use userspace crypto code.
> > 
> > Is the expectation that we go shopping for userspace crypto here?
> 
> Yes, same as what 99% of userspace already does.  Probably you'll just
> want to link to OpenSSL, but it could be something else if you want.
> 
> - Eric

By the way you do know that bluez already has a local implementation of
ECDH, right?  See src/shared/ecc.c.

- Eric
