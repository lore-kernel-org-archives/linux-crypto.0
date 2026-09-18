Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E0C2931CE;
	Fri, 18 Sep 2026 09:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723644; cv=none; b=WmQt360purKbBHnNpHpp56ZoiRJaIN2YXSgbd2L8oyMw6CCs4tfY0MzpJqlq6eXxuvhNx9Sl/Y88p25LPNQywNHSTwnBh5R5nij2uUcK98evHtax1zVHinyppJqjBWeUd6fhu+Pt3CRG06F5/9Xy0XdgnFplJaLEFI8U2QoI+HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723644; c=relaxed/simple;
	bh=fernGzWNyVMwLy6NIIIvd9nVpqm/pX2fFfdvnExQfo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jTX65rM8NPx8Ko9Rrf+DemFK+M2yC1K0EKiH/oqsAbEhMX48zF29Hk77Uo1WvJspjOFm0z1B+1THWnQuNryL9LcGiVbfe6aV5ssY3thOnHsfAb7mZUNB6UbO1sPwAf82CicJZB2HVtj7V1/jcwq5r/nzQ/DhEz5KfCEMYZfJa1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=AYpViywB; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="AYpViywB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ZFx6ggnuMXIkOpQg2S6htFhQ0923sSWYAsS4rEIjNfU=; 
	b=AYpViywBU/6XWQ7N88IhxYEFcuQiu8ksZpBpheh5SwNh/9LDk+vS++31Y5qtfUNA+zaaNkgtcoD
	RKlSjeYqiAoSxmkqY+Ra1ijBH8h67OA5xlwvjluwITBhtSxgL5VpNhlb2huvQr1kM9hB7TxjLWM8p
	WZZ2rlnFtwAcmR4cIxtiNOoHpyOHj9XE13cbS3dBeeayuGfxEd0qhGEY/wMJAbAjzrWkP3uMdzveY
	/xrkURc3iQAOWH+T5V8DYEbK3co09JuRl6BMny+7qSIVMRI/li3C9q1nDeZpDuOxzXcisqPOEgSfr
	SgyuE5arQtmU+o6w97QnVL2UcdGpf5JWEvag==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7UsG-0000000FLQ2-1DNc;
	Fri, 18 Sep 2026 17:27:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:27:16 +1000
Date: Fri, 18 Sep 2026 19:27:16 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/19] crypto: talitos - Driver cleanup
Message-ID: <aq0D9KV4JQJNwZJU@gondor.apana.org.au>
References: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907-7-1-rc1_talitos_cleanup-v5-0-860f43cd7317@bootlin.com>

On Mon, Sep 07, 2026 at 03:22:34PM +0200, Paul Louvel wrote:
>
>   A note on Sashiko third comment [1]:
> 
>   - If the current digest operation errors out because the driver
>     returned -EAGAIN, it indeed clears the partial block buffer in the
>     core with CRYPTO_AHASH_ALG_BLOCK_ONLY.
> 
>     Looking at how the API handles it, it means for me that the entire
>     digest operation must be restarted, not just the current chunk of
>     data currently being processed with .update() or .finup(). In this
>     case, no need to keep the partial block buffer.
> 
>     If I am mistaken, how should this be handled?

How does it work currently?

Looking at the code briefly, it appears that it simply returns
EAGAIN to the Crypto API.  There any error is treated as fatal
so the entire hash operation is aborted and any subsequent attempt
to update/finalise the hash results in a bogus hash value.

Of course memory associated with the request will still be freed
correctly.

AFAICS returning EAGAIN under the new interface is identical.
The partial buffer is cleared but that doesn't matter because
the entire hash state in the request buffer is now irrelevant.

If there is a memory corruption (not hash result corruption)
issue then that would be a real bug but I don't see it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
