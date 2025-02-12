Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3883597E;
	Wed, 12 Feb 2025 03:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331148; cv=none; b=RLtKb4xl6OTViEE1sh3342nn0tC13JrrJRyd5pC/oe8nSkH0CGwrZIqEHSTxJeRoD/BDGmi227Gf7TRPkam2fQx/5QmnOOFmrP5s+e+yMHwGLxadRbSzOHmjRCwZqPeery0d7bPN/rtwZSIcIGDvwikw7QHENr3YAcFzFRBrZzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331148; c=relaxed/simple;
	bh=Mj0b0CGmQXIPp40KRQKrUsT670AjOBqUVOmQaJ21IWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fMpHyrE9kpKyc7deLR9H+u6xu6UlMEVOUSX0jHwNwlWAlhKbDMCOcvw0B4NG8gkRYtSSkCRQbX59t1iuIlHM4gDqlQnp4FWBM9hsgil2HZoOKiSYWzNVxupI+2VRmn8bm5GEw/RQgvIdtOorTH1tRfk96pMChxOHHukI1Q88p/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aH44wEYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aH44wEYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E9AC4CEDF;
	Wed, 12 Feb 2025 03:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331148;
	bh=Mj0b0CGmQXIPp40KRQKrUsT670AjOBqUVOmQaJ21IWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aH44wEYIIOLr/V5xpJdQjxJ+g/Kgj2odbUYJ9z4jUN1a7WJ3cxyND+IrdE8lNq2Co
	 evLCAPV8RpltomRJnNIuUTQct0JFhXjvupDKtZ/GwlrEFs+yoGHkayIXTGTR7mXTSL
	 RIPqHmK0Tf5UqckXCY5mWVfVsHuB+j10smztIsTmlRjRAr2TOxnP3lZSEPSQP8o4AS
	 riF3dBeVVLUigGLNIR2dBfWTwgkFqXz4rw+gL7snE1gXcSCW9I9Hx6CL1/kr7zcYGu
	 LWx1i2M52APbp3h8bfVCSuUEDaVW9UJ4IB0pNiQbeTxizdvCg+lGXDh5QDeC6c2/MF
	 Ca0AIjXzcfl5w==
Date: Wed, 12 Feb 2025 03:32:26 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Harald Freudenberger <freude@linux.ibm.com>, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	dengler@linux.ibm.com
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key
 hash phmac
Message-ID: <20250212033226.GA2010357@google.com>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
 <265b5abbf32fcb6748abad7d0ec360cc@linux.ibm.com>
 <Z6wTTJz8uUNwT8Gg@gondor.apana.org.au>
 <Z6wUO-8wPTyzF5SK@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6wUO-8wPTyzF5SK@gondor.apana.org.au>

On Wed, Feb 12, 2025 at 11:23:39AM +0800, Herbert Xu wrote:
> On Wed, Feb 12, 2025 at 11:19:40AM +0800, Herbert Xu wrote:
> >
> > Don't worry about this.  It can easily be reverted once a patch
> > using it is submitted.
> 
> I just reverted it in cryptodev.
> 

Nacked-by: Eric Biggers <ebiggers@kernel.org>

- Eric
