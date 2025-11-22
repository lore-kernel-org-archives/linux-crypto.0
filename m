Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67CC270ED2;
	Sat, 22 Nov 2025 02:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763779063; cv=none; b=ZLzQDr+dvUOoaggWNsUdTFyx2KRRMdqipqIRsK2m+ZROi1aLc/yO7izVhIbz4iraACgxsXanrc8QF/HwPtDALPBhDPB5Wuc4Q3qvhStAMpObX5sYf8d+oUByrEyOxSJi2fwkltyK9UAICsAivoOyiA8LE24teiO4Yk9J4tbjECo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763779063; c=relaxed/simple;
	bh=5e9N76tvwUQmtUt37hkWeXFeKUlPyM/OHAcMDmAIJlc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=DZSMkGWE/QXenp+2rEklBiBRNqZTauRZRAMxLUF5PptH/HGCru8TEyyhpoFw8+oyLgtZVmrJZod7vvDjGymytQbk2GrtmwS6PjXqjKu5LEg/mMPrGHwM3s+lvHgQIJjYTGFi4jZ+ifdk/mFWOF5tQIRxJNuAJsDXq7FT6Y/qzO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MA5Oi4UC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MA5Oi4UC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=/J2O5d5Chr/SUBnrePa8cft+dHugF7HnaposLx81rQw=; b=MA5Oi4UCVnwGH/xqFB3/iasrOf
	Jc/iUuNmwwmi8R8UcE0Zx0P8Ctfag9liMBIJmskGCbY3Rzh7Ng+jtteuu513Zhga8ziz2A6C/H0wW
	BcN520nKdKwnrZ9s6uNQrH8cGdwbabBb8IRWhfoo/7CQUoOySXGsyf+qL3l+EoYKiJs/Zxc3Mue/T
	qRRDojpmmOrU2RTdGfYxF9L4iEWK7WOwFvnjmVtw4XdRyLNT5vBGkD8iHVayPWbfSg+txbsfVZm2K
	HLIP7lwFmVglYgjHF8TztZUkco6Eq5eAkK2gThg7e+btGjV69zgGNNIbe18uqMSdg9Ga1Da0m+Fcz
	MOkLvBBA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMdVD-0056DK-1F;
	Sat, 22 Nov 2025 10:37:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Nov 2025 10:37:31 +0800
Date: Sat, 22 Nov 2025 10:37:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ebiggers@kernel.org, Jason@zx2c4.com, ardb@kernel.org, kees@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH libcrypto 1/2] array_size: introduce min_array_size()
 function decoration
Message-ID: <aSEh684nt05JOYor@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgkKPgsmcC0SFni7hhQM_b3qNjoyzw_JL2ZVs2eWXEZWQ@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> I wouldn't call that "asked for".
> 
> It was more a musing on how random that "static" syntax is and it's
> likely incomprehensible to a lot of people - but also pointing out
> that we already do have users of it, and saying that maybe it won't be
> incomprehensible once we have a lot of users.
> 
> So I'm definitely not pushing for it.
> 
> But I do suspect it makes people understand what the code does more...

Actually there is one reason for using a macro instead of static
directly, sparse still seems to choke on a non-static value for
static:

int foo(int n, int a[static n])
{
        return a[0]++;
}

This compiles correctly with gcc and clang, but sparse chokes on it:

a.c:1:29: error: undefined identifier 'n'
a.c:1:29: error: bad constant expression type

I was trying to use it in crypto/ecc.c where the arrays are
defined as ECC_MAX_DIGITS, but only the first ndigits are valid.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
