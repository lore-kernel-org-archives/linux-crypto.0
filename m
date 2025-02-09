Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC39D167DB7
	for <linux-crypto@vger.kernel.org>; Sun,  9 Feb 2025 10:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739096668; cv=none; b=kFYxOf+VyjaCjvUm/5y9wpjOER5nvDudr9j1ch7M8tA6AeAIwrB7s2qCSzEMueWc7/83Q29e2CfVwSqglHyIHdKNZL4nnJR6rozHsdOvOflb9vj+FonWCpLaxjaEsdw17M8rw3rUL8LjxRmh97tre1hankNL00fRqoGFOP6eQLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739096668; c=relaxed/simple;
	bh=Qoa1a1p52Z5nJc+2ZymfnWZRKvbo+J7Rp/d+Fe89mh4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=LJx0Nnm5DXNjhEk9DfhEAsOm/Ro07UBwqxGfMMMrioeJd6OTJLV1vUSpGpCv7JOSGN5Gw7+Zv7gcdaVuvdOMj4IU0eTTaZJ5lCxHwQQYt5s4Y3Ii83D792316Hhu2O8IZknEv55hIT/7ajo8PU38chSqPOyFZLb9TOTWH8Rf/0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bKiNFh9U; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bKiNFh9U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=J1z1wrKOU0qEAssII7QsTArP5Bf6hKe5bV1/ats0dgk=; b=bKiNFh9UrXu7ag13qJsh1i9kgX
	eafO2/kvqZrMqyjuC/JoUy9576ne/i9DGZu2ybHncxfeMApHkZDBzhTYlPVatqdx/Rh5yo3Wfv11P
	Oql6/1kBJoSKmxeTD8v5w95y6zWyksqFEQpYG/Zpnk1/LF4D2Rn/6U5MQ29t8VZUUSHk4AVntVo27
	G+iwaivdxXiIVPX1FkjB7dbc4vV2y+RwmpHbFusaZi+zw+lOuv02X4VvjGzfguhhiqlVuG0zOx06Y
	lDHRGGFAPsdEbqeWTiWc35+QCEmaxEWVIxvzZpLLHTgfmDjruseG938l5WzCusvGhw4GovEtrdMAJ
	q8yyvVOw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th4HG-00GIon-0U;
	Sun, 09 Feb 2025 18:24:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 18:24:22 +0800
Date: Sun, 9 Feb 2025 18:24:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/aes-xts - make the fast path 64-bit specific
Message-ID: <Z6iCVgBUZKdguxhC@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250127211609.43938-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Remove 32-bit support from the fast path in xts_crypt().  Then optimize
> it for 64-bit, and simplify the code, by switching to sg_virt() and
> removing the now-unnecessary checks for crossing a page boundary.
> 
> The result is simpler code that is slightly smaller and faster in the
> case that actually matters (64-bit).
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/x86/crypto/aesni-intel_glue.c | 30 ++++++++++--------------------
> 1 file changed, 10 insertions(+), 20 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
