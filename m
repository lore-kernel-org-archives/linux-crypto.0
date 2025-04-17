Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3930F1D5CF8;
	Thu, 17 Apr 2025 16:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744909140; cv=none; b=CZI095ga8TVcnAbv2uoT1YBP5b7BP81vhk4rOIWkUsBAVpwP+0bVurfVygIwGyjeHrN8mjFEIY/as8yLoFyp8KBMk5EOF0Tkn8Rs3N+d4LyjV/cIXWOSrmnxsu+euJwNg7pXRimICW7423E4NM7UGPdTEyRgyGVsV5NLJAgZHmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744909140; c=relaxed/simple;
	bh=jxIXxKxaNPo3dQmGxoi0tG5S1YbEPJ8HH1VVwK4JwsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AUimLyWcrlmyllnYPuChe5sRaYKdDNeM2wtJct6MauOTGK2J5Z5myLYkEp9lQVTqKiNtlrDcIJTajE+iOZmyexegFkWr4lJRh8GZA0lUka7WD0OLiMCPNNNcAaOcZnkbDIx7qjZfln344BgCnYHAtGcD5vYQb7lUalm3/iveAsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N8AX4HSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N8AX4HSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39E2C4CEE4;
	Thu, 17 Apr 2025 16:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744909139;
	bh=jxIXxKxaNPo3dQmGxoi0tG5S1YbEPJ8HH1VVwK4JwsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N8AX4HSlMyK+6vjGU6LNISIWaMI2Kvl2ZIRqMHxyDAt/Vmem72yJ1zLaip+GqanQC
	 roC/3ASqU987M0/pMgs09BI3a7n17pIPMzEmba0a+moJ47+F4yhsVk0jx/GHxtke1g
	 sYl5I0WW57wSgkij+x1IH+ySGmYxZeZNYLY4mdXW2Nl2ycVCqmdrdoOwi6BNGJ/zpC
	 eoZaqiX+XCZN3nQOYCC9V43vKoHRrp8TBYF4aJqbYMAih+fJPsNb0j9+Tl3bhq+uf7
	 LR7WJaM6XqazLHqR1lV4SDC5PxKdSMInlgW59aaXMAHlHsCeFYKgLWrTMV/htMXQWT
	 JfeVOXg8AU9DQ==
Date: Thu, 17 Apr 2025 09:58:56 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Qingfang Deng <dqfext@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Christoph =?iso-8859-1?Q?M=FCllner?= <christoph.muellner@vrull.eu>,
	Heiko Stuebner <heiko.stuebner@vrull.eu>,
	Qingfang Deng <qingfang.deng@siflower.com.cn>
Subject: Re: [RFC PATCH] crypto: riscv: scalar accelerated GHASH
Message-ID: <20250417165856.GB800@quark.localdomain>
References: <20250417064940.68469-1-dqfext@gmail.com>
 <CAMj1kXFPAVXOtPoETKvHB49kjZUPYrsAqsJwdL7p5Cu4xk75Rg@mail.gmail.com>
 <CALW65jY=LnVBYoKPOQnSKgGSA0brKzmo0vqoRDcqF_=jofLAng@mail.gmail.com>
 <CAMj1kXH-u7hiKGQfgYHj_16V4ATN_aHmA_wkvMSyLh+E3+QaAA@mail.gmail.com>
 <CALW65jZVYUZoka7Gbjcoh43qbkD7rGpw8gTZjjOYpZD-BhLyBQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jZVYUZoka7Gbjcoh43qbkD7rGpw8gTZjjOYpZD-BhLyBQ@mail.gmail.com>

On Thu, Apr 17, 2025 at 04:42:46PM +0800, Qingfang Deng wrote:
> > I see. But do you have a particular configuration in mind? Does it
> > have scalar AES too? I looked into that a while ago but I was told
> > that nobody actually incorporates that. So what about these
> > extensions? Are they commonly implemented?
> 
> It's aes-generic.c (LUT-based) with accelerated GHASH.

That's an odd combination.  Normally accelerated AES and GHASH go together.
Presumably you're targeting some specific RISC-V CPU.  Is this going to be a
one-off thing for that specific CPU?  Or can we expect many RISC-V CPUs to have
GHASH acceleration without AES?  And if so, why?

- Eric
