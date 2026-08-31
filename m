Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8184B3932FC;
	Mon, 31 Aug 2026 20:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788208905; cv=none; b=NbLkVuRWdL/RQE/4ZRwKYS9b8Uq9wOASZeh8Kz8Cui/f7HeOzG1M/zvlOTYhLVc90J/CATL2zlI5xvANYj7Hpz/5lQ6UcLvh+oLas7uO4ilKvPYpS5ui4wgWHyUOSQJmR6MWeAZwbw5LOZO11GanLuKTPa0My2wqEXt50aYtiYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788208905; c=relaxed/simple;
	bh=B/lgg/o0BIcuaGotbl6thy8IsfQu0pXNiDvQbm9kdjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ipMec/kQhDn716MnAL/FES2LzDaKZODr135PhMD9V1BEJunsEr7gxK5bOm6reekAlEq4ZZ43toAZlIgh/67YyI6MF+5UcuT0wUXHnu75aG9FLopezE0horyzYCr4vzBKpxJywbTdP8kJooOq72qaqhoT4TuoM6etXoCHNSZMdGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZRuDUb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZRuDUb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8387C1F00A3D;
	Mon, 31 Aug 2026 20:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788208902;
	bh=58qzWRlFT+1LEsCbv2NU3eA6ucyiCa9T+H9aKr1gZ+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cZRuDUb6UDYEUMwbqZvOWZV7DspR+NZNocPKIuoQAoyTZ/s0hzPoo8bOQL9Es8FC4
	 l3xGoUsnoEf0RvEhwcfYqvRjrGikuZ7NEn010wl3/rKteOolN5w1q0L5B7SxdYX2Jt
	 qGnjGWjpa5z+1RfcTS4oE/YDkZ20gZPx85d4cp3NFvpa427ijPxRUMZCvlgSq782I/
	 HaIAvZkjtmonvbo6cNYuVblmEKdAeZwbXmtHoiSJDopKl6cnIvTVsIpfEmagESZO4v
	 08JfJsb3g0oOsYfvr5LPEldqn5wZhBJQFdruBoJjtaFr+exZIjbMG4IrtQdaQRYBTs
	 CHioeyU/9rQcw==
Date: Mon, 31 Aug 2026 13:41:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Cheng-Yang Chou <yphbchou0911@gmail.com>,
	Kees Cook <kees@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: arm64/aes-neonbs: transition to kmalloc_obj()
Message-ID: <20260831204141.GD86114@quark>
References: <20260830101714.625728-3-manuelebnerli@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830101714.625728-3-manuelebnerli@mailbox.org>

On Sun, Aug 30, 2026 at 12:17:14PM +0200, Manuel Ebner wrote:
> Convert to type aware allocation as suggested in commit 2932ba8d9c99
> ("slab: Introduce kmalloc_obj() and family")
> 
> CC: Kees Cook <kees@kernel.org>
> Fixes: 652a3017c485 ("crypto: arm64/aes-neonbs - Move key expansion off the stack")
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>

Please don't use the Fixes tag for behavior-preserving conversions like
this.

- Eric
