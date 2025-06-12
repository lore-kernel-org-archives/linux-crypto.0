Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9FB4A1E;
	Thu, 12 Jun 2025 19:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749755492; cv=none; b=GY3m9FzF1MPVAxmr4VDlVC22aHXc3P4LZp8uMd5LJC7j6PJgM1USV4sLOiDB4F6tdb0wZ3O0FLXRo00WgvP/buZE7WnYBVHWKSEFdAawNyTbfTT9Nh8Uy9fO7d2YEnoWwHj2RN1pvc/41TOmWgL45TONriiAZRVHkjc59Liv+pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749755492; c=relaxed/simple;
	bh=mHIboB/8+98iLbDnR9XcHUg73vr4yYdA3IntcaSKlYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WT42GewIa9FfeHEl6bwg79ttUI1/N9v669ynzPpOjPg0PnwD6kaJSqHqnIg5Ayy2/YXkmn7UXvDONP3vpFOZLjVb8BT/sTnxcHGEsN7IClph/EtMhdU10iaRnLPneuTNejTbmNRfaU5Nwu+vTCwpsn1H+qK5JfeG7VYNpC7/Fvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jhz9u3bT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jhz9u3bT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB64BC4CEEA;
	Thu, 12 Jun 2025 19:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749755492;
	bh=mHIboB/8+98iLbDnR9XcHUg73vr4yYdA3IntcaSKlYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jhz9u3bTuLAYjGvkNhkFN5YcFERAePZZdskOOxvSAWxTg79NU7BpCW7GEH6usoYQ0
	 r8aZ5FGYsayc1MaJN7ZeHAymvnAuOFg2HSGFLgnQRBeR2e7S8oy5cWgyymlN/kQk+q
	 I57n06724+6/ABRtveWGVVGRuLtnNv0woz2p2yL3R4D0qP6OekijzEPMTVtQIw1XJP
	 QaM2H/7V5xKTpoBPhB4zb9k7b8Kj8Nrl0akeGy39z5HHmEcunlW7JGw6LePIyHZ37P
	 6pfVpfkqWFpCa3wA7J/+UIcCWGi9lDYzjLM01/2JWke6UWe9cZBX72sbIg9piH2V6E
	 5DChYCUSWtBMg==
Date: Thu, 12 Jun 2025 12:11:05 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: John Johansen <john.johansen@canonical.com>
Cc: apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] apparmor: use SHA-256 library API instead of
 crypto_shash API
Message-ID: <20250612191105.GE1283@sol>
References: <20250428190430.850240-1-ebiggers@kernel.org>
 <20250514042147.GA2073@sol>
 <4f37c07c-3a39-4c98-b9c4-13356f5a10dc@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f37c07c-3a39-4c98-b9c4-13356f5a10dc@canonical.com>

On Sat, May 17, 2025 at 12:43:30AM -0700, John Johansen wrote:
> On 5/13/25 21:21, Eric Biggers wrote:
> > On Mon, Apr 28, 2025 at 12:04:30PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > This user of SHA-256 does not support any other algorithm, so the
> > > crypto_shash abstraction provides no value.  Just use the SHA-256
> > > library API instead, which is much simpler and easier to use.
> > > 
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> > > 
> > > This patch is targeting the apparmor tree for 6.16.
> > > 
> > >   security/apparmor/Kconfig  |  3 +-
> > >   security/apparmor/crypto.c | 85 ++++++--------------------------------
> > >   2 files changed, 13 insertions(+), 75 deletions(-)
> > 
> > Any interest in taking this patch through the apparmor or security trees?
> > 
> I can take it through my tree

Thanks!  I notice this isn't in v6.16-rc1.  Do you have a pull request planned?

- Eric
