Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09B419F420;
	Fri, 27 Jun 2025 03:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750996794; cv=none; b=UVLZ67mlBGMxs1QOjxoXqCDT904bUqY8NQfw7HkYjWkmDM/fyDZHlt1HD59rZFwDupulIZWHxxywMntQjQhzus234QHm+kZmr7KZKnIi+Qlu58wS2D/4bsTIcNtFUHHjq5houXYXmwq5cr5YXwXng5wSHYIAaxTliH6ObLNFWgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750996794; c=relaxed/simple;
	bh=30ofrfTmzxnxVEFkrGqHc6kxPyp7kpbqtMKKF0e3Fr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=anlF9GqsNNpjtoDFEFs3ISbRcKXj0oz5b1uDGf4V+s+50Ht8x6isFG+SZl0nVTR2prLemF/NuyyiG8o7DPOcL0FgqTj/MggwPVhy5U20HjD1N+S9L16C1wo/RREj+vuU1onDHawtXvPgztoyIlIU6Gw1DT2HseYDrIP+r6lYLm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8/iTcP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8/iTcP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BD6C4CEEB;
	Fri, 27 Jun 2025 03:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750996794;
	bh=30ofrfTmzxnxVEFkrGqHc6kxPyp7kpbqtMKKF0e3Fr0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C8/iTcP5umsFzug4zLePft5CeRdVZh9wtKEltjW4vJdNGv9X6o/qJ0WgNt6hK5EEG
	 gflZmchPMw8DcsK8JzZ2/yArBSRtFxRKre7nz6nY+6isfxxLzXlgMKgmNpqFqZL0Gp
	 TqIurcvfipphqx+zvUEhJIirczLt4tdg7Me9LNFvJFqVUDJ7LuvyeG/LanWpIVzUWK
	 1BkfrBwHw7jRy//Dwt5geNwnys2mc8lO6Lyt+wFYfYAwjqGwMqZejeWQRN9+K1zqMy
	 fVAUZVEX65w2VZXiLBK0i3IOa284NU+pN3p83Gqv//DO2JZ6guAp3u88rGFzwllWI+
	 TtgqvIaaYccMw==
Date: Thu, 26 Jun 2025 20:59:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: John Johansen <john.johansen@canonical.com>
Cc: apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] apparmor: use SHA-256 library API instead of
 crypto_shash API
Message-ID: <20250627035918.GA15797@sol>
References: <20250428190430.850240-1-ebiggers@kernel.org>
 <20250514042147.GA2073@sol>
 <4f37c07c-3a39-4c98-b9c4-13356f5a10dc@canonical.com>
 <20250612191105.GE1283@sol>
 <c80d4e69-ef03-462c-9084-e6bb56f428e6@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c80d4e69-ef03-462c-9084-e6bb56f428e6@canonical.com>

On Sun, Jun 22, 2025 at 02:16:07PM -0700, John Johansen wrote:
> On 6/12/25 12:11, Eric Biggers wrote:
> > On Sat, May 17, 2025 at 12:43:30AM -0700, John Johansen wrote:
> > > On 5/13/25 21:21, Eric Biggers wrote:
> > > > On Mon, Apr 28, 2025 at 12:04:30PM -0700, Eric Biggers wrote:
> > > > > From: Eric Biggers <ebiggers@google.com>
> > > > > 
> > > > > This user of SHA-256 does not support any other algorithm, so the
> > > > > crypto_shash abstraction provides no value.  Just use the SHA-256
> > > > > library API instead, which is much simpler and easier to use.
> > > > > 
> > > > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > > > ---
> > > > > 
> > > > > This patch is targeting the apparmor tree for 6.16.
> > > > > 
> > > > >    security/apparmor/Kconfig  |  3 +-
> > > > >    security/apparmor/crypto.c | 85 ++++++--------------------------------
> > > > >    2 files changed, 13 insertions(+), 75 deletions(-)
> > > > 
> > > > Any interest in taking this patch through the apparmor or security trees?
> > > > 
> > > I can take it through my tree
> > 
> > Thanks!  I notice this isn't in v6.16-rc1.  Do you have a pull request planned?
> > 
> 
> Hey Eric,
> 
> sorry I have been sick and didn't get a 6.16 pull request out. I am slowly trying
> to dig my way out of the backlog, which is several weeks deeo. I might get together
> a small PR of bug fixes before the 6.17 merge window but the bulk of what is in
> apparmor-next will be waiting to merge in 6.17 now.

Hope you're feeling better!  Actually, would you mind if instead I took this
patch (with your ack) through the libcrypto-next tree for 6.17?
Otherwise there will be a silent merge conflict after I apply
https://lore.kernel.org/r/20250625070819.1496119-11-ebiggers@kernel.org/

- Eric
