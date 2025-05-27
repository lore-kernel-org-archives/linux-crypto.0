Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869A343ABC
	for <linux-crypto@vger.kernel.org>; Tue, 27 May 2025 11:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748344836; cv=none; b=kQpUCKy9BD1CvLjqUJ0sKKRMVb2FaZFkj/3LXAuDyaWRo4IWIULLN3Iet2VwuAfMHxayqfWnpFGWrWlcXAv0HIZgawKt74KqEUe9C4UofQnAtCvNP8Vt+D36vEAjnQm3PQHG74Q+gfiDDzn/QDqJDH4e3G4Lxw6HJjWMwINpey8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748344836; c=relaxed/simple;
	bh=INUsowipPv+8/r1o3nQaa6OhgtaeMcbUD7durt1A85c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KeRwdo3/KUmRYVW7PIjkH54K2toGnruywxcvRzCQUQL7Q0OPtTk1D+055zmnPQoJU1ShveBZClmdlwjezf3unQpXCo85niuEEPw8OcZ5L0vDUNrirhuHH044J81NcXwHCj5zRRGj107fE/9/BZDRWaI067oLJuHCQrY+i0fcvsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fV6hikRj; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fV6hikRj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XX3aZu0VnWyIUAwLhN62NWukqKZHiMvxF6c/3i9M/QA=; b=fV6hikRjzlRzE6GxAzZXbCL6N4
	2EBTtMHM6OmIBCPs4JB8wYKomnjeAFNLbB3BtaXyPIzeCixeqLnnxRIEO09A6ODun0zNMpVvIMEXY
	sYNTUZl478EE5Ip0k9jJk0wo4y84E2R/sxPIp19I+VRvx1yZ4VqulwoEg7EGhUzKkxMSsXAYqAWM8
	Ga20ZKC6waJ91X7brkV+6jCdB93ll3lTpK5rVtpTOfJ5QNlJWbeP58o4/KRQyeITYiijXkvCmDyod
	VXtum/lPH4x4klIooJOFNvN2XQDaB5KSOy4zFj00bEapBaYDBhPC7vORe3Mw4BtGPMtesr+B9ASR9
	/h6NQ44A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uJsM1-009ERy-2W;
	Tue, 27 May 2025 19:20:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 27 May 2025 19:20:21 +0800
Date: Tue, 27 May 2025 19:20:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com, dsterba@suse.com,
	terrelln@fb.com, clabbe.montjoie@gmail.com
Subject: Re: [v3] crypto: zstd - convert to acomp
Message-ID: <aDWf9VNapNYfMqQj@gondor.apana.org.au>
References: <20250527102321.516638-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250527102321.516638-1-suman.kumar.chakraborty@intel.com>

On Tue, May 27, 2025 at 11:23:21AM +0100, Suman Kumar Chakraborty wrote:
>
> +		do {
> +			scur = acomp_walk_next_src(&walk);
> +			if (dcur == req->dlen && scur == req->slen) {
> +				ret = zstd_compress_one(req, ctx, &total_out);
> +				goto out;

You still need to call acomp_walk_done_src/dst afterwards as the
pages may be kmapped.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
