Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2E82CCC1;
	Fri, 16 May 2025 16:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747413920; cv=none; b=P3gxXms17Z0FE/JowkZ1Ji2CU8IPWGo4znAa9nNNmofk4p/wzEKNYwuDpoWaT8nI68EHsJ4Zf5BcTDMmnrMZGPTsc6b7DQLY5MxfDlOMGJMuuCN8idcCGo+d8yXBIUmDq/FN+ATVikx/X9pEGIoALBbVqimppZsdUjIhJzw+9bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747413920; c=relaxed/simple;
	bh=aaeddjKPS3lR8AN7yb8sQWTZ85Q1HGJPB3fzIMlS0qY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ImrjvjvTXaJXMgqlmbq4dT4zJdlO1P9sl1MtxRmmKXHyMCtO6R+w8PfXB+F8dphbzCwfqcxXzpHZwJsgKANCxyu0bNc28IIMLhMMblrb4Th1wF+G4blFUdRhRxKnlenjT0Sh9s7xio6Ytj+do/l3K+IihjxvfHEAvuzQEcUk/WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIm0MP71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIm0MP71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961F7C4CEE4;
	Fri, 16 May 2025 16:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747413920;
	bh=aaeddjKPS3lR8AN7yb8sQWTZ85Q1HGJPB3fzIMlS0qY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nIm0MP71xp35ItW1iqWDhC7qbcomrPszMSNm3MIGEUu5dBwVlNmFthv+Qj1dG0Eke
	 6AZBy0iib84gieYfeKwv1d1QJL759/ddO7Ae54wbNSqF93THWtB14U+SyblfZU4ZFU
	 nBGc0DzloOtBlMKsVD4HxYVx12UJMn8l0PkAYVt1AlyQgInQEZMB9IwUvDFRn6EQJ5
	 +irrFa5aecSdD2UIxXTX2JqxkTSwTV6gyxmBaEwmqZu7Nj3B3mjSJZS/cMwv+61uWe
	 lQhDnL0ee5Uu5X3uhmGTrsX+HqE56e68mq4NKDr9TxCKZ81hEKDil0JrZxZtUJEkv5
	 u6DpMuL8B02LQ==
Date: Fri, 16 May 2025 09:45:12 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: lrw - Only add ecb if it is not already there
Message-ID: <20250516164512.GC1241@sol>
References: <202505151503.d8a6cf10-lkp@intel.com>
 <aCWlmOE6VQJoYeaJ@gondor.apana.org.au>
 <20250515200455.GL1411@quark>
 <aCcCKJ0NpdvIpvsH@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCcCKJ0NpdvIpvsH@gondor.apana.org.au>

On Fri, May 16, 2025 at 05:15:20PM +0800, Herbert Xu wrote:
> On Thu, May 15, 2025 at 01:04:55PM -0700, Eric Biggers wrote:
> >
> > It didn't actually make a difference until 795f85fca229 ("crypto: algboss - Pass
> > instance creation error up") though, right?  Before then, if "ecb(...)" gave
> > ENOENT then "ecb(ecb(...))" gave ENOENT too.
> 
> I would consider this a success, it actually caught lrw doing
> something silly by trying to allocate "ecb(ecb(XXX))".  Sure we
> can sweep all of this under the rug with ENOENT but it might end
> up blowing up in a much worse place.
> 
> Also I don't think it's true that ecb(ecb(XXX)) will always give an
> ENOENT if ecb(XXX) gives an ENOENT.  The error is actually originating
> from the lskcipher code, which tries to construct ecb from either an
> lskcipher, or a simple cipher.  It is the latter that triggers the
> EINVAL error since the ecb template cannot create a simple cipher.
> 
> > As I said in
> > https://lore.kernel.org/linux-crypto/20240924222839.GC1585@sol.localdomain/,
> > that commit (which had no explanation) just seems wrong.  We should have simply
> > stuck with ENOENT.
> > 
> > But as usual my concern just got ignored and it got pushed out anyway.
> 
> I don't ignore all your concerns, just the ones that I think are
> unwarranted :)

I don't think this one is unwarranted.  We should keep the error codes simple
and just use ENOENT for algorithms that don't exist.  This also affected AF_ALG.

- Eric
