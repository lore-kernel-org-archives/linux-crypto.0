Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6385B1F3B87;
	Fri, 17 Oct 2025 08:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760688974; cv=none; b=JFXUCxpPt6fVn+xdrQ3QtXZ1N7zixZG5Wk1Lf0sxfJNy6ze/Joj6HtonB7PHusQuKT8D7/x/hiNTjyiuZy47hlCdNuyIuVxUUbabagXQzbFsJvdcDkUXTzxP0OQKfutohTAbeYJPC2ZgMzcMXR750XDFUQDkFqLhlwtz2tDLcsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760688974; c=relaxed/simple;
	bh=POrrQUTkV3QABaE2hihANkWPPl3+Up3p9SjPSQ0lz6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xy1KJCbUR2zEpDMYD/2a7K+BSHO9oKpkMPD1caXmSDrbzHfEtULqGsO/a9FA7HYu50h/D7B3UkhArG6r5yFokgdB4298FA90T/1+yb93JFzRAMHnHmiN2gmjj5b2Eo7crXtq+SVl6XnCoBQodaxXMb8wOfZ0E3t6XS/jnUjxe6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=BC/YJYK9; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="BC/YJYK9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IsMK5EH0osJpvrGLfTbkTUT9vrlVCxvqFe4on0Fk5so=; 
	b=BC/YJYK9VnDEtF0WF7Lq6FrirsayYikd9VozZd6N3ujmMV2t07q7ilvPmlPBScUJ1I7cZ5jo22i
	Fez6URnp9LIAin3kCnCi8pUxVVOya9sxb3bjHjtK3QAIKJ6e0lA/JSNjE8DOYPio/EIlsaQ9H92Gk
	M2IYc5OEHoCr2faZSaP/lBhXb8gqatkPd1/Z9FwAJJDztM0F1vQF3aSX1dpCtqZxXZRQQBkz6KnKm
	WrLG5ZACy93da2EU1Oilvx0QvF8tTBg6N6YFAEh62HawZpb3GGXKKeyrnolCWbSO/ME0gha3elAA1
	ZZUytaJXCm/CD/yBjxQtbAdpEf0wpGa800Hw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9fd5-00DMy0-2d;
	Fri, 17 Oct 2025 16:16:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 16:16:03 +0800
Date: Fri, 17 Oct 2025 16:16:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: fips - replace simple_strtol with kstrtoint to
 improve fips_enable
Message-ID: <aPH7Q6q7gxzN4bB3@gondor.apana.org.au>
References: <20250915221244.2419149-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915221244.2419149-2-thorsten.blum@linux.dev>

On Tue, Sep 16, 2025 at 12:12:45AM +0200, Thorsten Blum wrote:
> Replace simple_strtol() with the recommended kstrtoint() for parsing the
> 'fips=' boot parameter. Unlike simple_strtol(), which returns a long,
> kstrtoint() converts the string directly to an integer and avoids
> implicit casting.
> 
> Check the return value of kstrtoint() and reject invalid values. This
> adds error handling while preserving existing behavior for valid values,
> and removes use of the deprecated simple_strtol() helper.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/fips.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
