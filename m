Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58AE41C72;
	Fri, 27 Mar 2026 22:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774652388; cv=none; b=esi4wqhIpYK5wcc6R04V/MWo7kFNeyLQozc369qmEmr6HGaM6C+S12ysBBs2ct5JXsrbCOp1tWVvdylNV4/1Nme6LFN/z4tUuV1GEfAJIN5r/cM1udOogO4EA1xkw0/+1coD3TuDyTGCPpTjDjIc/SoUsdtI0+zlHz+A6+uPk1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774652388; c=relaxed/simple;
	bh=QUmjau8hh9tyyt9TL8CABI89Fne4vfNMVxiOgcnAT0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ew2wqs+usVLN+fMJpJrVTSQoatMPG5fQ44CTDauUJJ+5UsG+MZyFloOnUoYejQZKcMbr5ABp/rLFkESgDgAAIgtXzb6HnZLIPLhBEVii2zLJGyaxPi0ozhFy8j5yNG73nhYEC5t/sISi7ygENRLZ95/ttbZzypRWWY3huxj/EZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X1PfpfWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X1PfpfWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E94C19423;
	Fri, 27 Mar 2026 22:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774652388;
	bh=QUmjau8hh9tyyt9TL8CABI89Fne4vfNMVxiOgcnAT0I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X1PfpfWu/YQTqGu/JkYGfsWQOtJ87AydqffrU3tFC/zL53YpyB6XxyS+UlQPW2++K
	 Au1sJCWqLSkPnYfNK1RhzVc6S0sHJHUfksueL43iTqlCB9F6m88Mq40PaeUig+GMYD
	 XUBSS79/rb5vlAsX6U4tnym/QSeAvSTP/Ojp2wzX+e5q9l/lS+YTWrcKg2QjCjRkrB
	 baXZqqj0fKgoVz6SEMvYlpzF94P6iT6T/MdEaPxDayYwbPt1eFSWWvH185XZZy78Cp
	 Tfidra/Wr/drEdbumLJWzkVX4pUO4jpPxIbMou6c2oKVbJTBp+EuoIxuHesNORZEAp
	 HegQ6lKBMOCrw==
Date: Fri, 27 Mar 2026 15:59:46 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto: cryptomgr - Select algorithm types only when
 CRYPTO_SELFTESTS
Message-ID: <20260327225946.GA66596@quark>
References: <20260324230220.5457-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324230220.5457-1-ebiggers@kernel.org>

On Tue, Mar 24, 2026 at 04:02:20PM -0700, Eric Biggers wrote:
> Enabling any template selects CRYPTO_MANAGER, which causes
> CRYPTO_MANAGER2 to enable itself, which selects every algorithm type
> option.  However, pulling in all algorithm types is needed only when the
> self-tests are enabled.  So condition the selections accordingly.
> 
> To make this possible, also add the missing selections to various
> symbols that were relying on transitive selections via CRYPTO_MANAGER.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting cryptodev/master
> 
> v3: addressed more transitive selections
> v2: add selections to options that were relying on transitive selection

Looks like CRYPTO_USER needs 'select CRYPTO_RNG' too, since otherwise
CRYPTO_RNG=m && CRYPTO_USER=y && CRYPTO_SELFTESTS=n breaks the build.

Though oddly enough crypto_del_default_rng() has an unused stub, which
implies that it may have been intended to be optional.

- Eric
