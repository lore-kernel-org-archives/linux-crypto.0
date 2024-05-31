Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C42145FE2
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 08:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717144220; cv=none; b=iudCXhzLTPzd1IQq1+un/dk7Zi5VOWX+XXqh2C2VdUOi4W6f8cqzaOntwPhUoLbrHTC4gW6cJOunpnoRXYZ2UQW8Xo7OcvsJbtXozZckpNsnkQ61THy+PabXDLZ5I/TuAWOgIE8IFTsiBMnaIRTSacGXQZMioEt8+Lbjl3zcx9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717144220; c=relaxed/simple;
	bh=uhDghJ2Iw1O0Fwrty2wrGaXXh05mqJy358TaZHrHmbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fge7MMPhc/yG9k95BXWF6lAX9bNNn5ZNEEo/9djaukzebVY1euMzVLoPMjHWS+3y8bgjpMk+stgy92UawVN/cKrpF1rfBkLRG899FPWmW5oWQXoZygu0jyWXLXgZ0M4CT8fBG7kzpXtOwcL2/l9pG6GbepKSFh596uR60PMtIE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCxeO-0048A8-35;
	Fri, 31 May 2024 16:30:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 16:30:14 +0800
Date: Fri, 31 May 2024 16:30:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: scomp - Add setparam interface
Message-ID: <ZlmKlmjBhWXb4cGZ@gondor.apana.org.au>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <84523e14722d0629b2ee9c8e7e3c04aa223c5fb5.1716202860.git.herbert@gondor.apana.org.au>
 <20240531054759.GE8400@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531054759.GE8400@google.com>

On Fri, May 31, 2024 at 02:47:59PM +0900, Sergey Senozhatsky wrote:
>
> Is the idea here that each compression driver will have its own structure
> for params?

The API is agnostic.  You can either have a common format shared
by all (your) algorithms, or you can do individual structures.

Since you're the only user, you get to make up the rules :)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
