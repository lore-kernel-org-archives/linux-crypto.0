Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25777184E
	for <linux-crypto@vger.kernel.org>; Thu, 15 Feb 2024 02:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707963003; cv=none; b=jDL0dlwSLmyVpcxbT/EO7BU9uyLrUMFL5tgtlvygOJCQ1rVoZfpOA8l2RxiDxUJl/olbvEJ92ZFVZFD568X+7Z+YnoTi2+st1qGVQ977rW7JyWQ/74KbhzL+Qv0acBRyo922rgPnCfeTJzdz8q0CoSUxjw1i5AP20Ce6XA0OegU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707963003; c=relaxed/simple;
	bh=a11KoA7zLLeUim2TnIFTCV7sDcnwppo6BP2nlFy70AY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q+Zf7rb/aJjv+IWj6BRY2e+gSSKVTzuU2039IYxfSiwSJ50UuegsurU2nYGq6M7cSndvkPJqWY55XIrtSOLVA6S/gMA4g7K1w/wUyFmbpQ2z6gH24N9H350ye8gKWukUiMGQuSGBqtSrINkyjiYZVypf3jAaPNBwnE3ip9+/L2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1raRC7-00DnJQ-8a; Thu, 15 Feb 2024 10:09:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Feb 2024 10:10:01 +0800
Date: Thu, 15 Feb 2024 10:10:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: HelenH Zhang <helenz98@yahoo.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>
Subject: Re: code question for dh to kernel v6.5
Message-ID: <Zc1yebAjAJoY2rwW@gondor.apana.org.au>
References: <334623130.1130500.1707860532447.ref@mail.yahoo.com>
 <334623130.1130500.1707860532447@mail.yahoo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <334623130.1130500.1707860532447@mail.yahoo.com>

On Tue, Feb 13, 2024 at 09:42:12PM +0000, HelenH Zhang wrote:
>
> at line 373:
>                 n = roundup_pow_of_two(2 * safe_prime->max_strength);
>                 WARN_ON_ONCE(n & ((1u << 6) - 1));
>                 n >>= 6; /* Convert N into units of u64. */

n is the number of 8-byte words at this point and is used as such
to allocate memory.

> at line 444:
>                 /* n is in units of u64, convert to bytes. */
>                 *key_size = n << 3;

This converts n to a number of bytes again.

> Should line 375 be: 
>                 n >>= 3;

That would break the memroy allocation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
