Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC6B4189A5;
	Mon, 13 Jul 2026 13:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783948069; cv=none; b=HQSajkx0DtrFz49uGxtONAlMW2D70fNTiyQPM73wBXeVkYvLF4/IuvpoHZUs9SM9JjV5CdRZNDWlja1ekHsniVZ5tVme8mk9fpFrmv3CBv1vDeA8QzaNU9VFt8DqP20/PO3GUieeBX5gUZtBFurUyZ6Z8bMocyOhjLI/UV7z1bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783948069; c=relaxed/simple;
	bh=eZDb2Tb0TorVW6SVUJBl2A+95nQMtBtkxZCbkSWL+D0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYIbyf1wRiJj9ruU/axq9hyLB+HGrlm6TIhFXZv8IaG687QuwhRJGa8Gq4zYgoVXqV+gL0Y7UCP3DeRn8kpwIJypGChzaLamG5FUwAveWLxakUIxnui+bS9bn4WAYjzUY2iW/MHdURXQxRMIY4Sxwad8ebaWHmKTcU4VGMwrLQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M6WsI97x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M6WsI97x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D30F1F00A3D;
	Mon, 13 Jul 2026 13:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783948067;
	bh=kXQnTwBPub3tZDUV3lE7n/0kdw8aNXe/OrgkdMgIWss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M6WsI97x0WTAWfxR3KXWh9Utq+r9um1NRRAO4gUwOERZBkLePwAAszdV6RYGWd7RV
	 +GUZ6+s/4IFenPdHEgtOuSZaWu1zexnaqtBQ9rNpkPj4dQ/azMsiskt9R2rkXIpiwO
	 U9MSPRqaaVLtSVTffHNFxadDfVgQFogfJBZ6ikjx72rWfHBHJqQ9fXYnST9pD26a1L
	 aTKGHKrQB1MHm2r0WQdku6WYSh4P3NPyF3Asg0gLr7bRTHf996+1SxZ1Lm3W1y0TCJ
	 rBKyMAKxCMh5lgwcp/hkHlX8Jli69z+gP4qguXLv5HvPylT2D8Fv7p6S0uMmLx5WW+
	 NMAh5Kt/NVtFw==
Date: Mon, 13 Jul 2026 09:07:45 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: demiobenour@gmail.com, Russell King <linux@armlinux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
Message-ID: <20260713130745.GA2254@quark>
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <2026071312-uncover-refining-8cac@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026071312-uncover-refining-8cac@gregkh>

On Mon, Jul 13, 2026 at 06:47:07AM +0200, Greg KH wrote:
> On Sun, Jul 12, 2026 at 05:31:31PM -0400, Demi Marie Obenour via B4 Relay wrote:
> > From: Demi Marie Obenour <demiobenour@gmail.com>
> > 
> > This driver is harmful:
> > 
> > - It is much slower than the CPU [1] [2].
> > - It Has a history of bugs [2] [3].
> > - It does not have exclusive access to the hardware [4], causing races
> >   with the secure world.
> > - It register its implementations with too low a cra_priority for them
> >   to be actually used [5].
> > 
> > Therefore, disable it to ensure that nobody builds it into kernels they
> > intend to ship.
> > 
> > In the future, the driver will be used for processing restricted media
> > content.  However, the kernel does not currently support this.  Since
> > the driver will have future uses, allow building it if COMPILE_TEST is
> > enabled.
> 
> Why not just delete it now, and then bring it back when it is needed in
> the future?  Otherwise this will just trip up the static code checkers
> who will attempt to "fix" things in it.

That makes sense to me, but Qualcomm pushed back on deletion:
https://lore.kernel.org/linux-crypto/20260602-qcom-qce-broken-v1-1-a4ef756089e0@oss.qualcomm.com/

But I've still not seen any evidence that this driver is useful for
anything or has any users.  Even Qualcomm seems to be unwilling to make
such claims; they only claim that the IP is used (i.e., not in Linux)
and that new features are planned.

- Eric
