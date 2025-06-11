Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3374184;
	Wed, 11 Jun 2025 09:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749634325; cv=none; b=Vmz9cXA/men3SF+0z02ef64B8lOC6ElqlWiYVGr9Vufw1cUuI42B/ajzR7R+eMPbw/2mwSy5aN9/xxgsU+40XioqQWfuotg/7CYz5e/tuzyq9LFuJTtKPpvenF0cMUkFYrtZH49wRvQs383Oo0Kr3rMd8pEZgIRY3Ic7k5rpZbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749634325; c=relaxed/simple;
	bh=LmZ31E7MChujgxR77XXadJkwWr9pvhCZDHHo1V0tBZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GlxpQzsS4JQcTCMCq4a6VtqMzRU3xqJ5cc+n9WZjA8Leev22FoMlwyvdlqTf3uE6pjsOzKoWKkv/xYgfm9zfcFbqrQ2IzqJgf3RZdKcg3WMV8Kxt3c7RnfwWujvYbLO1/V2WUdlnvNgonbH30EnhwdShscF0au4XzKJJ5NxCthk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gtwKM+od; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gtwKM+od"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ef0vG2Qb0B/9UQbtrUTyLcOStPCflHZCkTnTCb3H4no=; b=gtwKM+odIDwwOzeJgQaccGplYh
	SGlLNE60/v3KPAFkaRGwWbsIjiUOlV2/imQP5XD4m3EZ9cmBsFEP9lLZlXDbZc26EqM0PWBMBEezX
	MtMTUgqdYQBeFGRX3WxzmjES4NZNnjgRUENxJAcQNROuzkFnnLGbrgl2w+SzT6QaCXC9rc0d4e7+P
	3Oq5sctZs0DqBxg1JsENcpiLVguX6hCUwog7tUpfiXfP3rxu34GJFnlFOK/obK7lg+3Jdjp1StiJR
	GEvqoAqQ2J0pe7Vz7i0sobH9ulSs6ee2HOj6VsYWNk1VnhXfjqzAOrVAP7N/ZdAoDz51ciVQuAxwS
	MdBIsgBw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uPHoJ-00CJMi-1a;
	Wed, 11 Jun 2025 17:31:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Jun 2025 17:31:55 +0800
Date: Wed, 11 Jun 2025 17:31:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5 2/2] crypto: ti: Add driver for DTHE V2 AES Engine
 (ECB, CBC)
Message-ID: <aElNCwUZnlgXzuPW@gondor.apana.org.au>
References: <20250603124217.957116-1-t-pratham@ti.com>
 <20250603124217.957116-3-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250603124217.957116-3-t-pratham@ti.com>

On Tue, Jun 03, 2025 at 06:07:29PM +0530, T Pratham wrote:
>
> +static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
> +{
> +	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct dthe_data *dev_data = dthe_get_dev(ctx);
> +
> +	memzero_explicit(ctx, sizeof(*ctx));

This is unnecessary.  The tfm context is zeroed by default.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
