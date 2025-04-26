Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6147D1A3163
	for <linux-crypto@vger.kernel.org>; Sat, 26 Apr 2025 06:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745648200; cv=none; b=HLEOQe4ei8BEkoCWKKpvFPjDY0OKQSe0Q1EH3Z3hwwYowAKAnK7NgMRJfsEsRBUMvuBVbEE1yJq6cB4qY5+ZizHIOxJPe3GCI6jgnrAgdQmxxyTvTlejieUagZmEGoFkXY9FsQmr0mIQgv87zfA7u73/uoy4pa9falLTNlSW52A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745648200; c=relaxed/simple;
	bh=dyodr5rNNQo+T19uRtFEKnYnQVGzoS+0FyJwruWw/2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hUbLJTDyZThWWXeRfcieuUO9nppiA28WcSGNudLaXlOmoOJ6lC7Evwk7psTzr6HahnP+351CaQ5hC7b9f1DDdouITzGsOBS5I+fq+GmsZA9ZYykTKlJoujDrWQ0cfHP8LScca+DBbYKinrx9BAZnoEACPhCroJZnw9uxek7f4eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=BZrL3GIm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="BZrL3GIm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=weMigD7OC6kyWtGLCmWxkNmo06WycJrULE+/tMyBAnw=; b=BZrL3GImqFSA5vx0gkr2AIatVi
	h0IfuOjbhyu7DMXzqp3kG64WMWPNBupUJyuH/v5SNNsiELCHQclYQ4eCNVwpM8a/0Bovn1FpTGKV0
	21/ZQDTmnAWdwPZtE9lIlGHx8RwTRiE9E/n7CcAOLowaJVQ6gZcoiZXEZTMl0L4kcq1RLviAtgIHq
	9+5vlF/1KxiHNvz7D6fKnP4YlSPQwexrdp+UhhJuRKz+wx8TN5mekVT3UNWC3vDNQ9QM4KX/570ct
	WXvVykd940/jVc7ZBUPrrcjRcBpXH/NBMOGVoYkT8tUHyxRHNHsaB11VjElqrZ4T234j+ZphQ3Hob
	DUbkeO6A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u8Ypv-001AKQ-2e;
	Sat, 26 Apr 2025 14:16:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Apr 2025 14:16:27 +0800
Date: Sat, 26 Apr 2025 14:16:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 2/3] crypto: scatterwalk - Add memcpy_sglist
Message-ID: <aAx6O0rrIm67WgJm@gondor.apana.org.au>
References: <cover.1741318360.git.herbert@gondor.apana.org.au>
 <18a6df64615a10be64c3c902f8b1f36e472548d7.1741318360.git.herbert@gondor.apana.org.au>
 <20250311043651.GA1263@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250311043651.GA1263@sol.localdomain>

On Mon, Mar 10, 2025 at 09:36:51PM -0700, Eric Biggers wrote:
>
> Actually this new function is useless as-is, since it invokes undefined behavior
> when the source and destination coincide (which can happen even when src ==
> dst), and all the potential callers need to handle that case.  I'm working on a
> fixed version.

Yes I just tried using it in chacha20poly1305 and it was no good,
as it can't deal with the partially identical SG lists that IPsec
creates.

So I've fixed it by rewriting it based on skcipher_walk.  In order
to do so I've moved the common bits of skcipher_walk out of skcipher
and into scatterwalk.

This should be good enough to replace skcipher_null.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
