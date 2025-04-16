Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F4322DFB6;
	Wed, 16 Apr 2025 07:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744790353; cv=none; b=kstMqMdXJDnTrDAnNlykVzT556tSW+hveUuPgUuEUHa7goHIi6e/qPStxWNqHFx5J7BHvnQoiV0Ehphi3pO2aUSxhX1oZHBqiNPNCxCxA62/SpRDGMifPLK//3qEnaESPg0y5lAwKEI+S4ntqU0jhg6aKz6vKD5BusV7hVFsmIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744790353; c=relaxed/simple;
	bh=T9ohAzgpAQ81/J5JK286o6ZKiKxWo7gi/XizJeLd2Lk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIJNwGu1rnS0VKSr8NRq99yQ2GZLPJuKCo2lnROTeXjUNduglpH8+nFOK57/on8SJdpEWDv+bsLIadMlRjSefVRGEILMlUmO0Eli54d2pizeAlcTlNsJxxEVXdbmILl6rABaKHGX67ACUFA2ZYLCToAJ7cK9udLTFwVD4RAG++k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=FtT0CWHf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="FtT0CWHf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4ijA6BDxKfx6f2Vcu+gHZqb3aYiVyAidVQZKPqkFHzM=; b=FtT0CWHfDMCFwN32mpB79OoLCU
	7/5joz0jT0VK4SUS6W43LTCwknhoTJXmvDA29Tg/lAL35dK1e6XKTz+OuCYDJzxDjpTlGcOLGlHhs
	WDiyOTlaNME9aEayVI6TBcEAz9YKSnCHC8yWahjYkSD5FO+DXjV2tc9QryYyMKkwgy6i6EzqyK97i
	EPHJiWflKv5jZCtg/RLb16KABCgI0EO6bM/BwSoKWNitYaz7/mDLn4llEsx70VjHLtdqmayohuWL1
	EntZac0FS1uByauH8aVdyDptOl/eiNbibRJbFprWk9N7D+8bTIw+Xp+9jLJ/wkd6R1qtL3+prQm+j
	83xYNGeg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4xfh-00G7wn-0e;
	Wed, 16 Apr 2025 15:59:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 15:59:01 +0800
Date: Wed, 16 Apr 2025 15:59:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@google.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: skcipher - Realign struct skcipher_walk to save
 8 bytes
Message-ID: <Z_9jRZgQJQgNtk0b@gondor.apana.org.au>
References: <20250411192053.461263-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250411192053.461263-2-thorsten.blum@linux.dev>

On Fri, Apr 11, 2025 at 09:20:51PM +0200, Thorsten Blum wrote:
> Reduce skcipher_walk's struct size by 8 bytes by realigning its members.
> 
> pahole output before:
> 
>   /* size: 120, cachelines: 2, members: 13 */
>   /* sum members: 108, holes: 2, sum holes: 8 */
>   /* padding: 4 */
>   /* last cacheline: 56 bytes */
> 
> and after:
> 
>   /* size: 112, cachelines: 2, members: 13 */
>   /* padding: 4 */
>   /* last cacheline: 48 bytes */
> 
> No functional changes intended.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  include/crypto/internal/skcipher.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
