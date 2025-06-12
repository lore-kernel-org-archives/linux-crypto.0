Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8590E1E51EC;
	Thu, 12 Jun 2025 19:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749755393; cv=none; b=eF0jDdrQof5hO8y8X2GSN77FpxpIlLxgNyYmrp+5Oy3Tj8Ox9kZRTWOf9dZdPbeosS6PnS8Z6Dkbq8yusv1FVwtVxsmskb4pZyCReyYjMN8kiB7A0mpRpS1RA8NV/tMhG3N3rzs+ozJjs1wXKP6tfs1u49+aZUv6R2hmlqOqnYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749755393; c=relaxed/simple;
	bh=1Af1d+zrUZuNAApVoW9yLRJ4UjiitNe/2/fUwbOm0M0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxSBGS+c9h9A6PUOX48xP4ldBGLWw89Ab2rR/1eq+eoaTIjvwbcsewYsfcaM2ob9MHGt6yTrUD5NgMvayfHkhURI55wIxRGRF8DkzJ4Oc4PcMsU2jytOtIn2ih2912PBJN/ChmyemBMMhs9nJ0AlsAHUR5nuz1OKFwRqrIqGxLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efhlF5hg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efhlF5hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE214C4CEEE;
	Thu, 12 Jun 2025 19:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749755393;
	bh=1Af1d+zrUZuNAApVoW9yLRJ4UjiitNe/2/fUwbOm0M0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=efhlF5hg5TAXEb4o1d5ltoWaiYZoYMOE5Kg6iJAySv8vXAOhdjjZfYI7KxdlEGses
	 Ip7NnFlAtVakr3t41s+Q2nS9OpokOgVA5xJzQqlkdT9BFLPA4CXo9gjUvLU7zoUriu
	 OJmzd/cNiu/hiDLSGi7oAC8ojAWQuAc2GTfmWuGWHp3JcDE7CCcFdcHdGfTbKroSIe
	 0fx339A77ayA0ivbZMFneVAY9oZWjMx2tLV96l3eEYpWSiuR2J9IH6gzOmdUsAY+kx
	 VzSs/qsmAwMCW2xMsY7osVkTjarlJWTz63GniioteQAIzFv3Nk910ELmKzV9zqPksF
	 zGo/ql0ukyyBw==
Date: Thu, 12 Jun 2025 12:09:26 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Fan Wu <wufan@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] ipe: use SHA-256 library API instead of crypto_shash API
Message-ID: <20250612190926.GD1283@sol>
References: <20250514050546.155041-1-ebiggers@kernel.org>
 <CAKtyLkEnJGFCAuurSihU_bUTCzEqTXEx_0dG0OHQ8353do0okA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKtyLkEnJGFCAuurSihU_bUTCzEqTXEx_0dG0OHQ8353do0okA@mail.gmail.com>

On Wed, May 14, 2025 at 12:40:45PM -0700, Fan Wu wrote:
> On Tue, May 13, 2025 at 10:06 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > audit_policy() does not support any other algorithm, so the crypto_shash
> > abstraction provides no value.  Just use the SHA-256 library API
> > instead, which is much simpler and easier to use.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Thanks. Will pull this into ipe/next.
> 
> -Fan

Thanks!  I notice this isn't in v6.16-rc1.  When is the pull request planned?

- Eric
