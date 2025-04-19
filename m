Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2158126C03;
	Sat, 19 Apr 2025 03:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745032919; cv=none; b=fGy2QXtksrTEGCccU5XJ3c8QDQgnSsVF7qET0h1gkCEMGhb2i9Bzjg6bVz0dZ58ueCLwjRThCOzhQmZtsM8n/6P9BGdLjdSSz6nAkNAhhzsce2HsGk8LYpTiHMsEdNJco6VIn/U56FghAasBZYqbZJ28ycSjV3dPSddYit6NbVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745032919; c=relaxed/simple;
	bh=cbaWcMGcIVUZgxadtbmxKR7Dj6dMx21CJt35Vtv0h9s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=lRtEigxOoW9zkDOp67dl8N2wz22P/bCZV2I3uwSSpwQefNMIvUAHiAu7gXQQW2QgJn/IBNHqv6VicOt8a5QoCEixHeOK9X2NqJf/EgtSsV5be3k3TwnYEy0crk1sXn37IspUu3OYxNc6iMLk6iyn0TlclXI4TOMBiJ2Wy/7Hsvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bqkVkn8i; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bqkVkn8i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=9AEZothU3ucJ26d47EBKWlbtqRNvEFyGXrvcgckGEME=; b=bqkVkn8iswqpmOx7JXeQhy4zZh
	eIZfxLa/oYprhEv68Vw1wTcmENPcCoCSfbO5QVpDT4rgM0049cZcEaPkZnIIFMHGVfKQeltpOPMVR
	e/Dv+9XaYwvuLHiKiZ7bMeidjigH133youARj19oZlan89pSyQStt89PY7f875gg/tmtp+A0iG2no
	Gfm3kF66G9QjVI+w0xfG2ApM9mPaLJ5RzEjrNGCe5mSNMG01jefz3IW2/882kv4oOeN61gDoBx+qC
	q40cCnYOfHLnMlF2KF66mcmjE1eNql4aLAB7DtqWw6JUuzbMcJOJnPr9HrOh2qbEspiG2bknYtzjR
	PdBM48iQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5ym9-00GuQ1-33;
	Sat, 19 Apr 2025 11:21:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Apr 2025 11:21:53 +0800
Date: Sat, 19 Apr 2025 11:21:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/poly1305 - restore ability to remove modules
Message-ID: <aAMW0dy2GJb7sf2q@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418040017.65086-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Though the module_exit functions are now no-ops, they should still be
> defined, since otherwise the modules become unremovable.
> 
> Fixes: 1f81c58279c7 ("crypto: arm/poly1305 - remove redundant shash algorithm")
> Fixes: f4b1a73aec5c ("crypto: arm64/poly1305 - remove redundant shash algorithm")
> Fixes: 378a337ab40f ("crypto: powerpc/poly1305 - implement library instead of shash")
> Fixes: 21969da642a2 ("crypto: x86/poly1305 - remove redundant shash algorithm")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/arm/crypto/poly1305-glue.c         | 5 +++++
> arch/arm64/crypto/poly1305-glue.c       | 5 +++++
> arch/powerpc/crypto/poly1305-p10-glue.c | 5 +++++
> arch/x86/crypto/poly1305_glue.c         | 5 +++++
> 4 files changed, 20 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
