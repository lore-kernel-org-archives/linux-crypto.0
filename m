Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EBF74E09;
	Fri, 31 May 2024 08:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717144706; cv=none; b=WDy2bppZZicHzqw32KRAJXcrcRlT9dIsgUDkUppmECeYclCxsbRBMa/rcuEW8Jiy2mJVY3E/vgCu2MIFO2k7Cvs44JL2qNfq/vqflPrak53eEzwI7NrVHpahpaHNwjVtjWOezC0P9bJOJC1WejgP4Z6136u5rZ2e3iTE42DYIiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717144706; c=relaxed/simple;
	bh=RQFa9SqmpqIyPfWu62uuWIA4227b4m94JJPN0KNKAAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nxYi4KWv5394Wkg/UwqRlEvVuaVxJLXxVQ5AH2BQspeDOH27WRJD4BoE7HuPFsM4kCVrmPjMwur4XPGEKP6S2EnxkHIs02/nJWBJObNIMtazJa69GJSJnuE5hMcuVi+xmxT0WIyBFNGE55tw2GfX6mk+m3o0ksqRWw/EV8msYag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCxmF-0048PN-06;
	Fri, 31 May 2024 16:38:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 16:38:21 +0800
Date: Fri, 31 May 2024 16:38:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, bvanassche@acm.org
Subject: Re: [PATCH v3 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <ZlmMfbhb5EUu9bkx@gondor.apana.org.au>
References: <20240507002343.239552-7-ebiggers@kernel.org>
 <ZllXDOJKW2pHWBTz@gondor.apana.org.au>
 <20240531061348.GG6505@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531061348.GG6505@sol.localdomain>

On Thu, May 30, 2024 at 11:13:48PM -0700, Eric Biggers wrote:
>
> It can't be asynchronous, period.  As I've explained, that would be far too
> complex, and it would also defeat the purpose because it would make performance
> worse.  Messages *must* be queued up and hashed in the caller's context.

When I say ahash I don't necessarily mean async.  I'm just referring
to the SG-list based API that is known as ahash.  As this user
appears to be doing kmap, it would appear that ahash is a better
fit rather than shash.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
