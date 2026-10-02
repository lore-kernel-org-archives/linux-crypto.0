Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F030844D00D;
	Fri,  2 Oct 2026 08:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790929923; cv=none; b=FMrIHU6NE9RrTwTy7r6jsG5c9aOtOC8mzziS2C9NdbemomZwY86UgDeIYh64P++mLwnWlAFyoXNEnvkt2KmUuvw2RLH1n+3a98GD25nYJPmwy19BBNXMJ1gA/kJt+IlH31ZWjDjOLZTAmPYcpUawkji9xQ2/lEJUNnHtgGg/a78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790929923; c=relaxed/simple;
	bh=cy7ApzXstdVj4Tfu30LVIjQuadA3Vd94/WodUwBgnkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXmzh43GUr5tFuvShm3kUBQOimyDXGHe+46t1lKgGBXZJyAWxqCRHb8sgK8Iv24jeTk+CDaEUugOIZuzXZHApU/lNwqpfd0b1MScMU1eO2wymS5ANOAqpCpPrsZZn+bMYmvaZknTaZUIhu5JjTpbcbtpP8a4nnz3E8HfpOea36w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OTpoqiUS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OTpoqiUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4463D1F000FF;
	Fri,  2 Oct 2026 08:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790929921;
	bh=VhRq2QxjH/GFd6p1HBiOhkCq4H/AIVqR20QgHUYCFkk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OTpoqiUSX6mSnjwKNaqsLx4pbchWeXuWr1t/5MD2p0F4vE9pYos491WzDM6QXbWwx
	 r5rKJ3FbNMqUhPNnrCj8OmPCsiEmJQk5WrFoB1DZj4DrOJPqmRp06g668QtNIM25CM
	 +rhGMK+9CWt0ZCxfDMsuOfip0L8KAz0ihNTiedtHkWPsPlDyPDBiqyJpPAE1cneYhG
	 WdVDNJ6EZE1r8xBHfVSbmA3v+2WP94V+hQDSLvIjhlD2bfrX0//9l7ipTVW7qOzHlE
	 cOGR7ZoxfXPg5JArbHHUbC+SOtCx5dxnNGR8ydbBMv94fSXXyZ07RyC0xRhWgzMWvj
	 kPBRZCOnrL3hQ==
Date: Fri, 2 Oct 2026 10:31:56 +0200
From: Thorsten Blum <blum@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Olivia Mackall <olivia@selenic.com>, Kees Cook <kees@kernel.org>,
	Michael Buesch <mb@bu3sch.de>, Andrew Morton <akpm@osdl.org>,
	Jan Beulich <jbeulich@novell.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Chris Wright <chrisw@sous-sol.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hwrng: intel - return -ENOMEM when ioremap() fails
Message-ID: <ar9r_KsYh2qGSfE6@kernel.org>
References: <20260922181102.67309-3-blum@kernel.org>
 <ar9bjjPC6xAgfPzT@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar9bjjPC6xAgfPzT@gondor.apana.org.au>

On Fri, Oct 02, 2026 at 05:21:50PM +1000, Herbert Xu wrote:
> On Tue, Sep 22, 2026 at 08:11:01PM +0200, Thorsten Blum wrote:
> > intel_init_hw_struct() incorrectly returns -EBUSY when ioremap() fails.
> > Return -ENOMEM instead.
> > 
> > Fixes: 641dd002d207 ("[PATCH] fix Intel RNG detection")
> 
> This commit ID appears to be incorrect (but the subject is correct).

The commit ID is from stable, in mainline it is:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c24c95a085c6b52c11c2f5afecc38b0ca143cdae

The correct tag is therefore:

Fixes: c24c95a085c6 ("[PATCH] fix Intel RNG detection")

Should I submit a v2 or can you apply it like this?

Thanks,
Thorsten
