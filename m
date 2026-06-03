Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC737305687;
	Wed,  3 Jun 2026 05:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780463243; cv=none; b=sZCJcyAAoXuGjM8SVpvuLqbwWYLBetE+Epb5MuYVEM2EceQQj04T7ju+BqFN40+hxnN6dPsAdjmEYYdQvWI/l8PStH78h1DdhhVMiGBELtZMQcvU+FGQLkX4s9f2ipVi7kCwVaTU09LO7NXRjtcP9FoD5xRJtixSN3GzNL9YgWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780463243; c=relaxed/simple;
	bh=ShBCDpb+nNi0u9x1/49snwBYQCd/jqe/tsYpi9A1mFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5JW6IBNFraG4rUvoX71ZRGApXTmRtqzdNgjA0pPio6q/hq1DqJuyP5gxF5udG9uu/hKevgKagXLRb75F78PouyUuymOJNP1jEeJPVXf636Ofga10jyRUlVaQm7xqXe1FPi8fnzO+9n/PzEePNXRs/5Jvhr+w/CQx+QI2UV+A50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lQiC8qDx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lQiC8qDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0589A1F00893;
	Wed,  3 Jun 2026 05:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780463242;
	bh=NZfs+8QOWHnzBC5Gw/raUgTWyy6cc00garM0ZCoyNHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lQiC8qDxBfCppepp8RAXwBm2d7G7zdfLHpWlC056Xc1ees/MkpyX/zWEZagIGK3lT
	 QVwPaIXwKL+J/lQWpL/Dp7CZ1VtoHm+kVDqrFVYdh1f0pl8RYJ0WNWgJqZNcFwG+gY
	 qh2YLl1aMavqpBi5YOOAHZN8SOneMPIqI8LVt28Y+HflsIQoyPfElIiMOmOULdp43G
	 cRBTkoT+15spsTsNvytRX5lJvp4TXMWP2tg+jjZZ45fAMkk1wlqswsoQ3jLIajb0G2
	 3NInLz/nGO85BSLAqJPLiZnogdVOIoVCGGwtjB2tcwbFgFJaAO9faTr4EHqitT0/Pa
	 dcS7tbMIyCBDw==
Date: Tue, 2 Jun 2026 22:05:57 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: netdev@vger.kernel.org, linux-afs@lists.infradead.org,
	David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net-next v2 0/5] Consolidate FCrypt and PCBC code into
 net/rxrpc/
Message-ID: <20260603050557.GB18149@sol>
References: <20260522050740.84561-1-ebiggers@kernel.org>
 <CAB9dFduBir-41_Ef4noEJPHsFU-++JHDxMU-6S7B8pBYynvadA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB9dFduBir-41_Ef4noEJPHsFU-++JHDxMU-6S7B8pBYynvadA@mail.gmail.com>

On Fri, May 22, 2026 at 10:06:49AM -0300, Marc Dionne wrote:
> On Fri, May 22, 2026 at 2:07 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > The FCrypt "block cipher" and the PCBC mode of operation are obsolete
> > and insecure.  Since their only user is net/rxrpc/, they belong there,
> > not in the crypto API.
> >
> > Therefore, this series removes these algorithms from the crypto API and
> > replaces them with local implementations in net/rxrpc/.
> >
> > The local implementations are simpler too, as they avoid the crypto API
> > boilerplate.
> >
> > I don't know how to test all the code in net/rxrpc/, but everything
> > should still work.  I added a KUnit test for the crypto functions.
> >
> > Changed in v2:
> >     - Added missing export of fcrypt_preparekey().
> >     - Write "RxRPC crypto KUnit test" instead of "RxRPC KUnit test".
> >     - Rebased onto latest net-next where decryption now happens in the
> >       linear buffer rxrpc_call::rx_dec_buffer, simplifying the code.
> 
> Looks good in testing with our kafs test suite, forcing the use of
> rxkad with encryption.
> 
> Feel free to add for the series:
> Tested-by: Marc Dionne <marc.dionne@auristor.com>

Thanks!

If there's no more feedback, could this be applied to net-next?

- Eric
