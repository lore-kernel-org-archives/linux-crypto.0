Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66855208AD;
	Wed, 17 Dec 2025 04:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765944386; cv=none; b=qev33vj2ISXO9aeuQTKhWGL2DRO37OFAoRP7KUHXXVTavpur48qtsU4sGAE005DY0g6NNxGc8ykP4JfXl7ZKgHXr2HYLStiaGbakwREdxwrKe69QQ3CI4DjvEetOPlzpkvSeqd57FG/rOw4XP9X3WqogpO2aDMzWyOp6H2ikNTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765944386; c=relaxed/simple;
	bh=svnVq++62g6Y0qGIL55PBs0FZANDiwaNI4K1ooLLj8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZ3ynmRtWhRjtpcg95hxPkFqODDHd83witHalr56EMebgXM3TB6xiB/vlD//jCCntf0SnNGy0H511lYztSVUrJfJxJ9vSIISkvrZF2BQhV1qIqxtSjs+4IfcHQ0DslMZ5I8TIniswnnblL3DipmrvYbXIne1AXu9V0shlN8S0sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cVuWqMZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cVuWqMZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD129C4CEFB;
	Wed, 17 Dec 2025 04:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765944385;
	bh=svnVq++62g6Y0qGIL55PBs0FZANDiwaNI4K1ooLLj8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cVuWqMZBXI7iNA1mYolP0sdAehNt6bsAtT61YlPFK4aj6ab4MI/+x+a/uOgf+ZvkC
	 pc4mJXEzYAqOkyoucUjIC1+0p0sm0V0zgPMooH51ZWmcRcvQiUo43sbwxSTDyPIOnd
	 z6p9DoeHF2vdiR5N9efBZxFmtzHwFuAp2AVap0Du2qwq1vINql1Hcq/qVfuO/8tzKw
	 y7EDMBVOVLXhmxfwcUPy32nixETQMNjzVft7zstyVjVYPoYgIW/1XV4b9Ng7vYM1Fi
	 R3uPME5C7AWJxbdo9hnHb93NVbFUQgJI6mb/lrpxbVPx0WCVRZkDuqSYr1fq9GKTPs
	 Qsl2/2yQzzprQ==
Date: Tue, 16 Dec 2025 20:06:17 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] Implementation of Ascon-Hash256
Message-ID: <20251217040617.GA3424@sol>
References: <20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id>
 <20251215201932.GC10539@google.com>
 <7920c742b3be0723119e19e323dc92bc@kriptograf.id>
 <20251216180245.GD10539@google.com>
 <bb05699bc7922bb3668082367b4750f2@kriptograf.id>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb05699bc7922bb3668082367b4750f2@kriptograf.id>

On Wed, Dec 17, 2025 at 10:33:22AM +0700, Rusydi H. Makarim wrote:
> On 2025-12-17 01:02, Eric Biggers wrote:
> > On Tue, Dec 16, 2025 at 01:27:17PM +0700, Rusydi H. Makarim wrote:
> > > While no direct in-kernel use as of now
> > 
> > Thanks for confirming.  We only add algorithms when there is a real
> > user, so it's best to hold off on this for now.
> > 
> > - Eric
> 
> Rather than leaving this work idle, would it be better to move the
> implementation entirely into the Crypto API ?

No, that's actually the most problematic part because it would put it in
the name-based registry and become impossible to change later.

There's a large maintenance cost to supporting algorithms.  We've
learned this the hard way.  In the past the requirements to add new
algorithms to the kernel were much more relaxed, and as a result, the
Linux kernel community has ended up wasting lots of time maintaining
unused, unnecessary, or insecure code.

Just recently I removed a couple algorithms (keywrap and vmac).  Looking
back in more detail, there was actually never any use case presented for
their inclusion, and they were never used.  So all the effort spent
reviewing and maintaining that code was just wasted.  We could have just
never added them in the first place and saved tons of time.

So this is nothing about Ascon not being a good algorithm, but rather
we're just careful about adding unused code, as we don't want to repeat
past mistakes.  And as you've made clear, currently you'd like to add
the algorithm just for its own sake and there is no planned user --
which is concerning.  I'm not sure if this is a school project or what
not, but we don't really do that, sorry.  There has to be a clear
technical justification with an in-kernel use case.

- Eric
