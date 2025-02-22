Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFC42010FD;
	Sat, 22 Feb 2025 08:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740212595; cv=none; b=W8ixTHn+SQJIBlhQGs9EBq+b3SKhSXMpcToUbrN7Gow2CtPczaVxpRkn+GgYe9VR1AFtaOh6GzApOlbisUOMxNzX02ZdfCc/Mlo8TtglQ8odDt4lx+CVJhCS0FTjpwC4EJH7IqKTYifhwAnYUpmgEHbKzUoEALUeE1cKk7CIfho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740212595; c=relaxed/simple;
	bh=DyuhcNQ4BYyGgdd0YMCl2K5ih3s5StW34Q6vUfin47o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxAXnT/eV5yXg/UCvCO/63AhH3iprW40pIZHhTkd0yS9j4Yw487cU00dPR33angBQNI4tDp9MJozBESHDcc2lmYxSE2bMP6VEdX/3PosYglW75cQ1CWyMm+hdcifQ7F6e0Gb5xxasMd6p0CoetlWRZxaqf8kxyKnlmKuxvJ7cK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DqjTVwy/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DqjTVwy/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=M2GQkbDJYOHDat2atdcUeSIimKVwjQQ67L6QMfJu40w=; b=DqjTVwy/8ryooIoWm/bjv4nQpB
	XC/0Ci/aaD6YgCh+9eoZlFGYmuOh9HeF3fFqnslOR6cYtgP1vdp0zzN1W/ZQJ3fbKOAtwhLcTGNcd
	7BSLLX8rRVd894spP8T0bmr7H+OOOHPZPIJ5vREy5jRSVc/CZPX4WwhTd5DpkfJnoUdfi8LNPU5aQ
	MDfTaWhhfTPyp7VkczHMdjR3cbNo3U7j8xyl3d1GytsKZv2l1wy1h2PZgn/uWFq9ciQrzDr8BOr/6
	lloM/PMUw4mU4ziGRniVQ3gNCMuov3ljFP0pG6J7VsBUxzEb8Q+hh72/lL4d6wbq94s+7HUAOlJ2D
	ZmQwHwQA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlkmw-000oZE-02;
	Sat, 22 Feb 2025 16:23:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Feb 2025 16:23:06 +0800
Date: Sat, 22 Feb 2025 16:23:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Harald Freudenberger <freude@linux.ibm.com>, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	dengler@linux.ibm.com
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key
 hash phmac
Message-ID: <Z7mJadq3V2k7IgOY@gondor.apana.org.au>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
 <265b5abbf32fcb6748abad7d0ec360cc@linux.ibm.com>
 <Z6wTTJz8uUNwT8Gg@gondor.apana.org.au>
 <Z6wUO-8wPTyzF5SK@gondor.apana.org.au>
 <20250212033226.GA2010357@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212033226.GA2010357@google.com>

On Wed, Feb 12, 2025 at 03:32:26AM +0000, Eric Biggers wrote:
> On Wed, Feb 12, 2025 at 11:23:39AM +0800, Herbert Xu wrote:
> > On Wed, Feb 12, 2025 at 11:19:40AM +0800, Herbert Xu wrote:
> > >
> > > Don't worry about this.  It can easily be reverted once a patch
> > > using it is submitted.
> > 
> > I just reverted it in cryptodev.
> > 
> 
> Nacked-by: Eric Biggers <ebiggers@kernel.org>

I actually pulled the revert out again, not so much because of
your nack, but because I'm going to redo the walking helpers to
incorporate direct support for multibuffer.

So it's more convenient if the old walk interface is moved out
of the way first.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
