Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA6A3914F0;
	Tue, 14 Apr 2026 11:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165424; cv=none; b=dIitQ9oU5Mf3O2kgrFR/vEGsNAIJAMgJwIDazLcxCfNhgnSXdDDf0qXEDsXibowITocDzKXmMrGo2j1NSbTIjpM8xvlamujdY9mI2iqRan5QqaCKVkvPp3c2lOJhrOSfGgG0r9u1NFq747amQlllflNkLKPwzlfl8SouRxTChlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165424; c=relaxed/simple;
	bh=tnSETDCgBj8UM0Ny7d5jOq8TMDd3NcVy67Q/ltBadYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H3NFQ5gLtTe2sdgN1Y+bkOweFzkHcYHBwSWZoEMXsDZDZ+6uA58RJl8reVPFX+uSeHRZH51nslushWo0WJdnuESn6qvD9oLx16QPXq2R63BUJ3Xd9Jn9+EkWWtfo3EgeDIPG0KYRtVUzww8nsTqjiF2wzuJQ8o6JoDphrjedr3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=KEU0GU0F; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="KEU0GU0F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=M/1Cl1M9mS/TId0xoFqflfEvIxM7Sb8tWX4TogxlKPk=; 
	b=KEU0GU0FFiqfLpEFBtReTaollVQ9U1i5vH6JPyjFICdMZZKuwnIX2iYsKon2LrHS1Dh8TP9oZrA
	Hp8+/eEdMlbMYxTiemDfid4e6BFqwFZGpXd1jQ9n4hXHzI+J/cXg6SzEJ/Iw+7sZAXPrcCTlQZIUR
	5m6p4rligW3XuLiJirKp11DUOBhpGM1jUPE6y4RNqDc2t3Sm03tJx+eThpv23HwmZUOxpfQS93DdG
	E+sK3KGMrqV9BqDCgIc4mNCj6yUYsdrxfAxP9XM2ZBhFV40NUAWlUG2x3AUIlNbcQ0hfpaOwo57zT
	W41fiXDM+XLhVt2D6T2rjIWfqbXEVZ2ssMjQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wCbLo-00609n-08;
	Tue, 14 Apr 2026 19:16:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 14 Apr 2026 19:16:54 +0800
Date: Tue, 14 Apr 2026 19:16:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v11 2/4] crypto: spacc - Add SPAcc ahash support
Message-ID: <ad4iJhEM-ZwgadBh@gondor.apana.org.au>
References: <20260318071808.817074-1-pavitrakumarm@vayavyalabs.com>
 <20260318071808.817074-3-pavitrakumarm@vayavyalabs.com>
 <acZL65nbtfMCPHhq@gondor.apana.org.au>
 <CALxtO0nFEG2Lm18Fnb=YVQfy4-Qjb5+WtOxsHNOwYTy2Kzyb4g@mail.gmail.com>
 <CALxtO0kj4JfL94qY-radGcLwMeTnq4NQF7vPqs6giuhBinvALw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALxtO0kj4JfL94qY-radGcLwMeTnq4NQF7vPqs6giuhBinvALw@mail.gmail.com>

On Tue, Apr 14, 2026 at 03:58:16PM +0530, Pavitrakumar Managutte wrote:
> Hi Herbert,
>    If the above snip looks good, I can push that and some more code
> clean-ups/improvements as part of V12 patchset. Do let me know.
> 
> Below are the code fixes and improvements
> 1. Multi-device safety handling - All packed up inside priv
> 2. Minor code polishes
> 3. memzero_explicit inside setkey, spacc_compute_xcbc_key etc.
> 4. Algo registration clean-ups

I would prefer if you left out sm3 for now.  If it really mattered
someone would move it to lib/crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
