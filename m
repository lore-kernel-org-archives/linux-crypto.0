Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80EF4A1D
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 03:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742095970; cv=none; b=Q77J5uzrNYph7EJyGHn+EGWOcpBc89cyWPM8/Xk5VgVK1XMQYjCs1jbpud6KHlObakjVvSDPxXgBK1RdWPnwrQlphkyJQD9IVpIS6i6qfj48mV7eOAqgae+THQQu1sJ9hlVviavaCDZIvP2eo3+4hK0Gm74b7mBZysSGX9r93j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742095970; c=relaxed/simple;
	bh=8BBWdutuL/hUf/bBaOyuvjT13IXJHIlKvLYCR7gtj7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZ/Zy5n5tL6wqocEr7uwyWl3pI4KlTmrNUbEKnMP4HJ82dq/UVJxKaioeUchzKEqyBB7TkTz3CgQtseGzNVNP41Y3mM71+250zWUOFTwpD7/HWyTymOIwUgAu6WDrpcxGSWqOaSVR9if3DgFYN8zXJxoCUKrtHVwLKuivgazsbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBywpdJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBywpdJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43372C4CEDD;
	Sun, 16 Mar 2025 03:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742095969;
	bh=8BBWdutuL/hUf/bBaOyuvjT13IXJHIlKvLYCR7gtj7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mBywpdJkaXht6J0Hs/teKwk0NiKOglK+IspV8HhyZQfkhSe/4/b3X77fpDg3g+dv2
	 fDNdRY0B+M+g6ZmyIvh8RXgmKJnjYFMuCm9BA90nsCM9wfK7hYyEzvndHdSB697RjQ
	 HQbjnBGdmiRmjHsFt52X74HlN66cxo1Ie2p4vnm/STf30pu3yDwrhprJmBTdMlNovj
	 /JcwOri3l9xdfiKA9o++Py66iWhc1msfN7lgsTKdL7phWWzuHZkiK95HXVNJ1F0lSb
	 Ky3TiNKUx2p4JJy1qwp6gnCGF62TX6ImzWQlNcKqgDgc1RO+hkyRD1tO8GIIFhniM3
	 U/65FILMHIbYA==
Date: Sat, 15 Mar 2025 20:32:47 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v3 PATCH 1/3] lib/scatterlist: Add SG_MITER_LOCAL and use it
Message-ID: <20250316033247.GB117195@sol.localdomain>
References: <cover.1741842470.git.herbert@gondor.apana.org.au>
 <eee86a8ed9152a79b21c41e900a47279c09c28fe.1741842470.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eee86a8ed9152a79b21c41e900a47279c09c28fe.1741842470.git.herbert@gondor.apana.org.au>

On Thu, Mar 13, 2025 at 01:14:53PM +0800, Herbert Xu wrote:
>   * Context:
> - *   May sleep if !SG_MITER_ATOMIC.
> + *   May sleep if !SG_MITER_ATOMIC && !SG_MITER_LOCAL.

This is incorrect.  kmap_local_page() does not disable preemption.

- Eric
