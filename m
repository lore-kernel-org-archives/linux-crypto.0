Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E19F14F9FD;
	Fri,  3 May 2024 10:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714731522; cv=none; b=ihicRfzNRPK5brJw7JkHZt2Z57se2j8KMGPEfs/58qnzdcguLQcpHf9/AhaRrIlGkhT2IMaF6rKxojwGTMi/ia4Ja0y1VFh38hdwWSX6RNDi701WTvp8GBVf4qniINnvTuTCPBKV05gEQMsJb9SGL4seV6HwmglSXoMP1bma1Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714731522; c=relaxed/simple;
	bh=bSiwM9bJWMdoeTblNRzq8u1xjjle8uFUX6aDOrxh7ME=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=PmMjbDnnNaFW1SeKsUGN9hdFnHBPR1MTYLkdkq2RuoEzFsBeyPaJqdECUL4OAkBJOiD2ddqFxW77XYNVWi74VLKljMK8jfvgpGk8+B/YqYvaLmEhoas/A2Wey2LF5GIlONjdcXdA+GjRWzszzoWqKfF9Yawy415tNsTiRR2cPeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s2pzr-009uSG-2o;
	Fri, 03 May 2024 18:18:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 May 2024 18:18:32 +0800
Date: Fri, 3 May 2024 18:18:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, bvanassche@acm.org
Subject: Re: [PATCH v2 1/8] crypto: shash - add support for finup2x
Message-ID: <ZjS5-Im1wWGawfUy@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240422203544.195390-2-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
>
> For now the API only supports 2-way interleaving, as the usefulness and
> practicality seems to drop off dramatically after 2.  The arm64 CPUs I
> tested don't support more than 2 concurrent SHA-256 hashes.  On x86_64,
> AMD's Zen 4 can do 4 concurrent SHA-256 hashes (at least based on a
> microbenchmark of the sha256rnds2 instruction), and it's been reported
> that the highest SHA-256 throughput on Intel processors comes from using
> AVX512 to compute 16 hashes in parallel.  However, higher interleaving
> factors would involve tradeoffs such as no longer being able to cache
> the round constants in registers, further increasing the code size (both
> source and binary), further increasing the amount of state that users
> need to keep track of, and causing there to be more "leftover" hashes.

I think the lack of extensibility is the biggest problem with this
API.  Now I confess I too have used the magic number 2 in the
lskcipher patch-set, but there I think at least it was more
justifiable based on the set of algorithms we currently support.

Here I think the evidence for limiting this to 2 is weak.  And the
amount of work to extend this beyond 2 would mean ripping this API
out again.

So let's get this right from the start.  Rather than shoehorning
this into shash, how about we add this to ahash instead where an
async return is a natural part of the API?

In fact, if we do it there we don't need to make any major changes
to the API.  You could simply add an optional flag that to the
request flags to indicate that more requests will be forthcoming
immediately.

The algorithm could then either delay the current request if it
is supported, or process it immediately as is the case now.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
