Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865A028B41A;
	Fri, 18 Jul 2025 11:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837102; cv=none; b=NUf2C2bSi4oZnAyWN0zI4Hy9+DQN7I11ZHZCF8nqhebK7EtRGlWobJa+5oShPxCzqgQJiOq9AjGRwIYLsZNBUn2DPDmGvzWgwIQMAQSS6MSbLckr+GSfCr4J3aXHQiQWyaQ+gavL10afIxJ13Yai/NRazvR+KPO9flXZquA8sRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837102; c=relaxed/simple;
	bh=h+SFilw+ons1Ma/HOlf+HSpOJa6aru4eoEZR0LBo6cI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=dr9DqTZCIYuKroaGDjOfLVGhfP718d+zgJ0ZacpdYCxPHykpVMQLWwKsP3w1UBMeiYwQCbWLHAvP3dHERwOxq3bwOH5zFkI/m9Aj10bix4h1VPvSZlQeHhvgWZcV9X1h8QDKz/Dw4zZ54CcS+PECLC3r/OMIq8rQssZti9u38LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=eQS4Kvrs; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="eQS4Kvrs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=b5zcfEOMXuz7RGxucdKJHtr/cKzUuWpBm3zVH5cKg+c=; b=eQS4Kvrs04xrCN48HvgJywFIrl
	cV233Ps6BZrICCyFH9Rsc9j2SExHVFHZ/84zr07B8gZpMfGszP9cUarM/rfxYSPd7Zp/SSlrat+qF
	XSJNkqghKuyGVWNxZfrZDhdrBgp30Uq+8Yh7C9KMgmwjdlp8vk1KB1EPhOL4ZkxV3FQMVqKPBZKno
	pYA+eRfSWySveOsye087eCQVIHHjU6TNK0tKHFFYBCZyIGypkopM3KgbF4m73ckwwN/6Vu9NF6DLr
	5v3xDuUcWa/6h4yrSpZJTbAlCCwbYCNRBZryCki1Cq4Pf9QJ57PDKRzlevss6xnevcGQXjsGfpQPv
	1o1oMCKg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ucikd-007ym0-10;
	Fri, 18 Jul 2025 19:11:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 21:11:35 +1000
Date: Fri, 18 Jul 2025 21:11:35 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-rt-devel@lists.linux.dev, ebiggers@kernel.org
Subject: Re: [PATCH 0/2] x86 AEGIS fixes
Message-ID: <aHor5-BxQPkh2GVc@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708193829.656988-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> Since the legacy crypto API likes to randomly allocate memory, the x86
> AEGIS code has some bugs.  This series fixes them.
> 
> Eric Biggers (2):
>  crypto: x86/aegis - Fix sleeping when disallowed on PREEMPT_RT
>  crypto: x86/aegis - Add missing error checks
> 
> arch/x86/crypto/aegis128-aesni-glue.c | 40 +++++++++++++++++++--------
> 1 file changed, 29 insertions(+), 11 deletions(-)
> 
> 
> base-commit: 181698af38d3f93381229ad89c09b5bd0496661a

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
