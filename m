Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5BD21EEA3C
	for <linux-crypto@vger.kernel.org>; Tue, 27 May 2025 12:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748348946; cv=none; b=mx3ZOhou6l/gO8ntvf6TYAv6RsaAR7H/IvbdeTOpwNNsMpMHw8M22MopzJkIC/Veh0H+VPvyszM2px0E3HOAmQde5tuyLF31tWBIq//eozf3fNLogsmAWcwQA+Eq5ZVJNX6YORygxXUN9Y4JG6UrrKkv0eAGrpNSJbOVR5ySwdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748348946; c=relaxed/simple;
	bh=jIdfSPAtapucf2pz9VffwxvCD01/5/RbGpYZAnS6ooE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nwNWGckIyRWnVmSLyoaGtYttR72q9GR554b4gCbZnBkJ/CO94RLNbZ2Phaz0q47+tZKRdvTccJJ2G9eT9r+AssOHfYcP1DVcR4EXHw09WUGvbjRZOgLuhgpCNxzLKPyhrIYC5dgTrYrK4nLKxtmw4yP5Oj9TkTCw4DDxUuZEXvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UpdwxLrT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UpdwxLrT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iErVh1MgT3j5G32sWUcGGohocwVWTxTJOAk5AWR65JY=; b=UpdwxLrTPlpUvdU894SRp07PDn
	byZuHjskBoNNciqNr/SvIsYNEj3uqa2zZUAUMJOl8BJW2rfyeBaxEkFgpU5SnVFbKnwTPjS+sGnX5
	FgN6e+DR8g8z1AbkBJqZoAexBRBGFNkxpFlV2uVgs73TK2/wZBrVTxB9ujW1K9RS5/f55vUlSI3EV
	pSIz5SFFXZLF7TTUBi/QmKV8wjc2Xy/e79wZXTvdH4HqGJwln6wTmINx3IEXls7op4FRzJbHU7zLh
	tzt5TJd3yfc8fMZKUn1HsDSKdmmqPMEWKG5nvzzB9DOiqPAUz6s+IMz14GODFAoYnaQ15dEnM9J5v
	pPfCl1XQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uJtQQ-009FIP-1B;
	Tue, 27 May 2025 20:28:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 27 May 2025 20:28:58 +0800
Date: Tue, 27 May 2025 20:28:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com, dsterba@suse.com,
	terrelln@fb.com, clabbe.montjoie@gmail.com
Subject: Re: [v4] crypto: zstd - convert to acomp
Message-ID: <aDWwCjXn3swOWUmp@gondor.apana.org.au>
References: <20250527122547.529861-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250527122547.529861-1-suman.kumar.chakraborty@intel.com>

On Tue, May 27, 2025 at 01:25:47PM +0100, Suman Kumar Chakraborty wrote:
>
> +	do {
> +		scur = acomp_walk_next_src(&walk);
> +		if (scur) {
> +			inbuf.pos = 0;
> +			inbuf.size = scur;
> +			inbuf.src = walk.src.virt.addr;
> +		} else {
> +			break;
> +		}
> +
> +		do {
> +			dcur = acomp_walk_next_dst(&walk);
> +			if (dcur == req->dlen && scur == req->slen) {
> +				ret = zstd_decompress_one(req, ctx, &total_out);
> +				acomp_walk_done_src(&walk, scur);
> +				acomp_walk_done_dst(&walk, dcur);

The kmaps need to be unmapped in the correct order.  So you need
to do done_dst before done_src in this case.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
