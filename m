Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07E24C9560;
	Fri,  5 Jun 2026 11:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780659755; cv=none; b=n6CsaFpgJ6OzDwWR+xvLTdtF2WEBbisMzcYeIYYGtCmc33d8JNVXnuCiY7ubkFatNy6a9LZsSCHG/8peW/gSLKOYlbQ4T6basghc3oeaGYfpKZcKVSlvtjonX+CaRxF+lNfGp35CrQM4h32gIJM1sFZbkRFg0kMFMRqp7PRDIRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780659755; c=relaxed/simple;
	bh=aECDGzlKDHWXIUQw+u4sGBsiAc6PQ7f7nhKXBGNhktI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VR/JbpjMcQc5ggMWf/E2Hch9CbVVqbqPbg/u9aq9VR+K9BAMa6OHSq9S2/Oqw10Lf1KvZyeaxvEMyUzonYJeAuoIE369v6Bgq21aGAZqkRZud2lYzDa3XRkX9ZTQtgj2G/Av+OyhbWsK7W5oaviKZ+xqcQaQbRCboqQboYx2Svk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=IcLmeEJr; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="IcLmeEJr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=aTy1XNVxRajlUmsekTI74t3WnZ3rR6lcNyVLeXOVEH0=; 
	b=IcLmeEJrshTweKmN4nFZA08XvRAIVIUw003euSC6d/a//5/n4JXuci3hxMDeaWf7LqAjr1nxtgh
	3WUnO/WmQ4Fd217xAUqPkFY76c6VjUaaha7aUAQ4TXHAVl49vCkCegXi1fHE7CBJGCAhiQE3EuaOh
	IRDnVOlrq/QZ4BriRT+ZHsMC5HR4OS0WBq8dzCrTWiegU+sKeZTCZPG1yOjBIQHZPVJs2q59r6gna
	4vWrmDibNJ3h6ddfI5SYAI5REN57y5qhswZ88vqzge7J0PmsXQkUDXoRGExFr1LAaeXx0rvmSkg8k
	wJCQB+CVuESt34YCbrXhz5CNPaFtQkiQFyvw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wVSwO-002oqK-2s;
	Fri, 05 Jun 2026 19:42:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 05 Jun 2026 19:42:20 +0800
Date: Fri, 5 Jun 2026 19:42:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: powerpc/aes - use min in
 ppc_{ecb,cbc,ctr,xts}_crypt
Message-ID: <aiK2HApEGY_9eam2@gondor.apana.org.au>
References: <20260527141146.1230672-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527141146.1230672-3-thorsten.blum@linux.dev>

On Wed, May 27, 2026 at 04:11:47PM +0200, Thorsten Blum wrote:
> Replace min_t() with the simpler min() macro since the values are
> unsigned and compatible.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  arch/powerpc/crypto/aes-spe-glue.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
