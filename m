Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04712BE639;
	Fri, 15 May 2026 20:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778876059; cv=none; b=IZINDWIQ1osRijTribQ+FJsH6pWCXZ4sAy4Bcaz/UTNC7om7DZJEtxT7pGVxm7TYMCccgIBjlqFThxDy0cGdski858zKVB05sQG7KYJukxUzHmTFZHlkY65GhFGXYw9LCntOaSCJOrpcxH79FXyYZrqqeTgPWUO1aqYDXkExNT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778876059; c=relaxed/simple;
	bh=ulJYPETGiLGFPMwIPDuffMKtTKgscUihrnQ20VnSf3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBjy+LW4m4VjlgZWi+Nc26m4ANXaGfUJVmYyx8c26ZKIeSydaBFCFjCHpgJES71+wSPdbWCRw4qEE7E+stb3XVWyfjFVyYpHrCWpLKZJe+L5kos6Dm+dDOzrowz2T5/Zr0CSPU9v9XReB6y4Ol615tTb/gfngYrjjUIbho1G7XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbHpVugY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbHpVugY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758B5C2BCB0;
	Fri, 15 May 2026 20:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778876058;
	bh=ulJYPETGiLGFPMwIPDuffMKtTKgscUihrnQ20VnSf3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fbHpVugYTdJr3pf45pLdYehV4qtwpK4UAogLIeYx/NXlWj5ZYZC80Ng3A/u6XOOZf
	 tnqmPM8stpaCnnbw1y0qZZWvjLgrwE8zMyzqHIou4Kr5VPEF58jRjGzLVsjuNjUukx
	 wv/zRcOl8Ksh+lO0Mo2TjipmoPS1dTapXGGOkdIdxrSymyoAOmvkMwe1cfvG0kzwub
	 3usOOC8ecYfZwPu4d4IkCmV4wT0/uRYNsODFdAGc4245h6EqqgXmHxEyVHvNV1U5G1
	 C1Y4mVRmqYYunh2ecPnrHA/IWYu8ZrmzPakHiuIPgYLDLo19qk8u2xB7scGQ87/QW0
	 UqlVrmMwbUEzw==
Date: Fri, 15 May 2026 20:14:16 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, linux-afs@lists.infradead.org,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net-next 2/5] net/rxrpc: Use local FCrypt-PCBC
 implementation
Message-ID: <20260515201416.GA3484095@google.com>
References: <20260508182318.GA4145640@google.com>
 <20260428024400.123337-3-ebiggers@kernel.org>
 <20260428024400.123337-1-ebiggers@kernel.org>
 <286248.1778263325@warthog.procyon.org.uk>
 <287476.1778266603@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <287476.1778266603@warthog.procyon.org.uk>

On Fri, May 08, 2026 at 07:56:43PM +0100, David Howells wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > Also I'm waiting to see if the following patch gets merged:
> > https://lore.kernel.org/netdev/20260502211340.446927-1-n7l8m4@u.northwestern.edu/
> 
> This is the favoured solution:
> 
> 	https://lore.kernel.org/netdev/af2kdW2F1gJ9U-Gg@v4bel/
> 
> The problem with the one you mentioned is that it does a mandatory copy, even
> when it doesn't need to, for rxgk.  I can benchmark that to see what the
> performance impact it has.

Seems that the latest is now
https://lore.kernel.org/netdev/20260514155304.2249591-4-dhowells@redhat.com/
which is back to just using a linear buffer unconditionally.  I'll
resend this series after that goes in.

- Eric
