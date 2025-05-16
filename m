Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF7E7261B
	for <linux-crypto@vger.kernel.org>; Fri, 16 May 2025 16:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747413814; cv=none; b=aVALWB/6+/avcHzzQXKmiMBFGdF6cEsWoCJYn19ojJaP0OU1JVX+CIdk36rpUGLGkfTB1Baj+V8nr5pq9eiravO8ANBJcFUjOky2UgqZnl7YepdcFMlig/IDLwYT9dERPcak/0eVt1XKMyUretxiXK6wvy6lXWLQ8gIqyZu64BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747413814; c=relaxed/simple;
	bh=dL2/6rI+VT8TIiTHuWFBnmkJarWDyarWG4vZtQnYWrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gkvtkIhLbA9KXu9mCJ0FG4tzYsyzbTHY1Jjpb7Z3PG1Jkud1KjkukoLnRVDkLXL++Ip60IlY2SD/xCnqhm6bHLx8Q/3RD0OEUHn7i4xViJB1fftoGz1l6nXvtCeGqT8K323AmPaUOnA+6U4eiYhJjyVauRxba6mCDkk80Iv8nsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fcGRiSOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcGRiSOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C486C4CEE4;
	Fri, 16 May 2025 16:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747413814;
	bh=dL2/6rI+VT8TIiTHuWFBnmkJarWDyarWG4vZtQnYWrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fcGRiSOeL7a9yqBP8rcaToUB3GKQZZ6LScIxpVD7B4k2S6o6Jy2mfYYxBtmtz/ZqH
	 2+9Ary2XVXc0iaOert/nKOOQn3sT266z04SS5rX2ot3JEuvkAjvd0KsEJfTtEq5GRM
	 aQ2lTAoUcmLUeG6AbGuewGgU3QitFoTjzGYyMrQX4Yz4FdbgkBkBhHM61dJCjqpd2k
	 u5CsDswFTsit0wXTn5janCK1so1Lb/bNcmOEdKZ8M+6QH1a3YRIdAhwgx+8Jk0gCI0
	 lFZjm0UkNfRNIA2SEtcJ+8aBw1LrayJs+cZhv28C1fxCI//1wqTwIAP9aMXhg3qDS5
	 wjDllT968HqCw==
Date: Fri, 16 May 2025 09:43:26 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v4 PATCH 00/11] crypto: Add partial block API and hmac to ahash
Message-ID: <20250516164326.GB1241@sol>
References: <cover.1747288315.git.herbert@gondor.apana.org.au>
 <20250515193529.GJ1411@quark>
 <aCcD92EWd_8oxlEU@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCcD92EWd_8oxlEU@gondor.apana.org.au>

On Fri, May 16, 2025 at 05:23:03PM +0800, Herbert Xu wrote:
> On Thu, May 15, 2025 at 12:35:29PM -0700, Eric Biggers wrote:
> > 
> > That seems backwards.  The shash one should be the regular one and ahash should
> > be special.
> 
> That's how it was in v3 but because of the switch to ahash in
> testmgr

So don't do that.

> > Still lacks any explanation for why this even matters.
> 
> I've explained it many times before.  The point is so that you
> can fallback from async to sync at any point in time by exporting
> the async hash state and importing it into the sync fallback that's
> now allocated for every async ahash.

So how come this hasn't been a problem until now?

> > As usual, missing a base-commit.  (Use the --base option to 'git format-patch')
> 
> It's based on cryptodev.

Which is a moving target.  You still need to use base-commit.

- Eric
