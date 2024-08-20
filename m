Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928FA4D8AD;
	Tue, 20 Aug 2024 04:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724126832; cv=none; b=i6rdkhIk2SfFttHdLNa/PbVoTaUgYO65nLHnMCgVcvxPYC1h3epJkkv4fhYMZi3u5/1IE1vJHp+t3hwVEwkGO/I3lqm/K/PSwj07SUsoucj90EoBdW0p0mK8p9fVOnSjGqdzTyON5cJ3HxSCKVmo+i1U5+1UbqLV8PlQMkL9F3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724126832; c=relaxed/simple;
	bh=q/xZU7jlHqcrQkF+iAQgWWKjZaI5CQxA36jZFlKMwKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUX2q4K5rL5TmmcLZrrr0KYP+4RmtgNNzcnVfTOpLS3wS74ipbr3/7OtMDduH8kxp9Z8ie5ENMqXQIsXtqvWmTMMCFT5DEfj6YdyvJCglMAtTw36oQnG4aLWE8qofJy/rlNR655KLnNqKrF6Xl/ZWSe4/ebSmjyw8OF2gSUt72s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sgG0Q-005sIq-2p;
	Tue, 20 Aug 2024 12:06:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 20 Aug 2024 12:06:47 +0800
Date: Tue, 20 Aug 2024 12:06:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Waiman Long <longman@redhat.com>, steffen.klassert@secunet.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Fix possible divide-by-0 panic in
 padata_mt_helper()
Message-ID: <ZsQWV_j5zMuYWqvH@gondor.apana.org.au>
References: <Zrbm--AxRXgfHUek@gondor.apana.org.au>
 <e752f094-adb4-4448-8bc8-e2460330eaec@redhat.com>
 <ZrgXtLI1R5zJ9GFG@gondor.apana.org.au>
 <91d29649-ca88-4f6c-bf1d-19e49c9555df@redhat.com>
 <ZrgsU-1PdxvUVMOW@gondor.apana.org.au>
 <88c188dc-3664-45db-b54a-11feca59d7d2@redhat.com>
 <Zrgy1TDikPSkzaYP@gondor.apana.org.au>
 <c5cc5ea9-1135-4ac6-a38f-652ed07dae17@redhat.com>
 <ZsBNZXfVZbtZnb2Y@gondor.apana.org.au>
 <dgtppozpgkm2gtv7nnvranbkjudr7bwuvfe7hjbznipozcxyzd@3qcag7izn4fj>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dgtppozpgkm2gtv7nnvranbkjudr7bwuvfe7hjbznipozcxyzd@3qcag7izn4fj>

On Mon, Aug 19, 2024 at 06:29:52PM -0400, Daniel Jordan wrote:
>
> The DIV_ROUND_UP approach reads a bit nicer to me, but I can imagine
> oddball cases where rounding up is undesirable (say, near-zero values
> for size, min_chunk, and align; padata_work_alloc_mt returns many fewer
> works than requested; and a single unit of work is very expensive) so
> that rounding up makes a bigger difference.  So, the way it now is seems
> ok.

In that case let's do the max ahead of the align check:

	ps.chunk_size = max(ps.chunk_size, 1ul);
	ps.chunk_size = roundup(ps.chunk_size, job->align);

If we do it after then it may come out unaligned (e.g., job->align = 8
and ps.chunk_size = 1).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
