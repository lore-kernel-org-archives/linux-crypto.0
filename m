Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28301200113;
	Wed, 17 Dec 2025 04:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765947426; cv=none; b=ZFd+hDaHNaiwGnVtgIXpOHDWNYr0MPFGgOQr4f6ULLqWYfs7gFxYIF5TvDqui4WnkcJIIZUyL8Qz6+7so4pu37Cl5zhJmu2s1dXMkVGRRW4X5pVoSOUgO3eYv02CCH2DXZy0/6xlShSNEAIh4JFGpOy6huUvhgtvKxdPiQE1s/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765947426; c=relaxed/simple;
	bh=1txrclJv0snf0X4fkmGoGtwG4/0N9D8XeCZ9KOjm7k0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rGbt7R3C5/MGkM+EWEqmBZ89/fQMKkl7t9E5buPwiJpb/CQD0itqz/02kGrWew/U9Onv1ZE/N4TzhgQacCBKY96JwmdCb8kIM980yp40dt53cZI1u/Ld6MvOa/rEQmgdHDVnCh7ASXuvLXA25sBdzbXYbWZJWBDtoID57LmmF88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=egBew8Hx; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="egBew8Hx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=P22O/raoZyiNHVBGA9XGwwnTDLiTCFxywjwLpPif188=; 
	b=egBew8HxCLvqFRxGmbireQSMmUIsNcA+aVulzocclGcnBj8Ew5a73TyEhKmXsKHonzLWaRaP1e7
	JC+6w5smex6V6Bssoit+IjQfb5zkD64+OSnjlkQeWSdYzulflGnuACH70/tW5DXO7xJCmfk54Is+p
	8QjBgdYEppmtFwW3MoAKloaYTroMlZV4E4BqCsvRYut6Avf2Ffc2NG7taUCFwAwnCx6yAqcQQxLFP
	BBQGcjfA7SFiCO7W4Kb3CUOQRIgpBfjHtKgcVvWwHSSC2WKjO6MP8qKhrg7NEPF/rLoMFOhDKqju8
	N3lVXppcdh/1KFyixFmWIuz0XUdG/TxHX98Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vVjaa-00Ahv1-1t;
	Wed, 17 Dec 2025 12:56:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 17 Dec 2025 12:56:40 +0800
Date: Wed, 17 Dec 2025 12:56:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, larryw3i <larryw3i@yeah.net>,
	stable@vger.kernel.org, CobeChen@zhaoxin.com, GeorgeXue@zhaoxin.com,
	HansHu@zhaoxin.com, LeoLiu-oc@zhaoxin.com, TonyWWang-oc@zhaoxin.com,
	YunShen@zhaoxin.com
Subject: Re: [PATCH] crypto: padlock-sha - Disable broken driver
Message-ID: <aUI4CGp6kK7mxgEr@gondor.apana.org.au>
References: <3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net>
 <20251116183926.3969-1-ebiggers@kernel.org>
 <aRvpWqwQhndipqx-@gondor.apana.org.au>
 <20251118040244.GB3993@sol>
 <cd6a8143-f93a-4843-b8f6-dbff645c7555@zhaoxin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd6a8143-f93a-4843-b8f6-dbff645c7555@zhaoxin.com>

On Wed, Dec 17, 2025 at 12:30:57PM +0800, AlanSong-oc wrote:
>
> Given the lack of a verification platform for the current padlock-sha
> driver, and the fact that these CPUs are rarely used today, extending
> the existing padlock-sha driver to support the ZHAOXIN platform is very
> difficult. To address the issues encountered when using the padlock-sha
> driver on the ZHAOXIN platform, would it be acceptable to submit a
> completely new driver that aligns with the previous advice?

Perhaps it would be easier if you just added Zhaoxin support to
lib/crypto instead?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
