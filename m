Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED9A3A6B6C;
	Fri, 27 Mar 2026 10:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774605996; cv=none; b=LRVmdmteZ1rc6DhUGGuQhlVMPmHpIZLfN9GWI99I8PAn/hbiVUg4CycxJCR9hMZ8G3lgrMAOFzvbMsGU4pC9fKy9p5/GRpe6cHEdRKExZ7xzE1jIWXMb4FSm9NWlcVSu3IfQnr1appgKv6htPsE2puk4XX3Ekwziyi90Q8cBh4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774605996; c=relaxed/simple;
	bh=zgogzunzZcX6DKdzenpH/ZG9zxsoo51A0yxt41mpKc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E+npNemJwFZmUJJDP3VfLhYGNKFxx2PAKAauk0K0qTVZh1lNGnkEJ8WpDFplspB8rQgwG47ESUv/c17HDB0Di+7teWO07voifF2/AsV2+Bt3wMwIY8djkMNPGeilJSX21DA+gtQEBoWksoD5vJdthRv3CaQPkP44O3yjIgAc6x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=nXM6NYqD; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="nXM6NYqD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=LOyXg9H270P1bQHj7985dPQaPCALrgmaL3wqV9ON7sc=; 
	b=nXM6NYqDmqG76a7m4HXCnY5uS/bM+AeJ5mqtubGX+vvlYa3VMwpmy707W5PhtzFqvI0bURDXzGk
	5YsWQTpsrRZltZwsqbLIZ47x7bqH+axIdZcIXD6/kT9X2o0DVeQfrdBGe7tZKSlvJyHditlqfs+K2
	mcH4AshpzIa8RbMGg1QKk+jf5XcArtsM+Skcu3NsVWgtwpNXyfW9TvEahsm5PE+k6bpKniNe5uPPX
	ZfwYUl+/cCG+/WsqKe95z7dYFTGsNLrZrmaq2ExlWdsmp6gapjDgy2K+Kg9kat3e+Q5n96+AK6WCQ
	iUkNCu3iKoxeukq50/AGM45isI0xDoJinp4w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w63ff-001bmJ-34;
	Fri, 27 Mar 2026 18:06:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 19:06:22 +0900
Date: Fri, 27 Mar 2026 19:06:22 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: marvell/cesa - use memcpy_and_pad in
 mv_cesa_ahash_export
Message-ID: <acZWnmc9IOO-ZyjU@gondor.apana.org.au>
References: <20260317165258.1304521-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165258.1304521-2-thorsten.blum@linux.dev>

On Tue, Mar 17, 2026 at 05:52:57PM +0100, Thorsten Blum wrote:
> Replace memset() followed by memcpy() with memcpy_and_pad() to simplify
> the code and to write to 'cache' only once.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/marvell/cesa/hash.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
