Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792989781;
	b=IxAThlfzDVjoLUKBAITMZnLOYwBlB+vpGoPQsPS2pybqNpwaNWxYFWxjYaYqk8KabnpQ
	 F8r+jZhlMtSQDUDPkFSmw9NTszakAy2JF+14D5oLZVOmq4cblvVnAIHuTYQOPQIlzEreg
	 v8Bb5zJPcoly1XKd1HFigziE0Qm+wKDrE9PnOC4oN+Ilw+pRFyQbrFGX95bnsQQNWgPib
	 67QR7wbzh6wUpZdpeNLPZXW9SxNebpUsXkHY+M3eERantcg4Bvo/XFTh4NNVRwk/TUS+n
	 6gP3+a/sYwLaQpkP/LYjtUb8UPacjN/lQ4MK1N/MuMwgLjEKzalDjZUAwN0Vm1oEVCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792989781;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=0mBZXCvcPmcyrgoCvx1EODCbOp+rR6onLvjINz5UMPE=;
	b=pgpn3sNX4c53dI8yqF2CCvWPHf7bZpNa1ECngjgCZkoa7U4dPhyyVoPLl/zZjTXqRQHB
	 PKZzZBxQTeS738Q8B7bdPusvDRK3poN3Rz3ISZjq7RVbh+fqea0WM11r34TI9ZtHTSLFH
	 aCK66Z5JHBU9xMwRvcaBYZexb2fuYZfXGShiXOEurJeuHcA9MwP6gxVMZjseeQqWiAVHM
	 kAZkZJBBILh2d13296PCPtz/RnMqLZ2mQIjH2zBCsY70wrh8HVBG0tZ6z8FoYvXZq0i/9
	 W/4uXhVe4HXrP9Tcw6LMECgp4Bwg8QVeHQJ3n1Ge7H2vBcdlV8iq9a85iKVuZq3Qd9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=jkETFqNd;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9A8606A31A;
	Mon, 26 Oct 2026 04:42:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B9A8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=jkETFqNd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0mBZXCvcPmcyrgoCvx1EODCbOp+rR6onLvjINz5UMPE=; 
	b=jkETFqNd3BsogIR/i2e0kI2yIByq1bv4TtgCrjIgIOPJCjC93bvZEJLG8tj84xjsWEtLwL6YqY3
	4ahGxE3HvfNyifD4+9P0iTs+BpM5IM6CbCPuwk+JiidHBiLEik+UPJB3APtX9zvTZy7HIh14b5hH1
	8w5bxgbQRIIr7Y8jQRi8iZRo9wGGWoRDg0qB0bvrMLG/n3rhDcWNL9FyTtbQUkop/UnBhdQy3oIzt
	zUE7on2ziDfTvhUASQGxcpGASk/hnDO2/B2roBG2dx3yUYCEy8hPPJv9KbsvU8tle32tj5hRq0pv7
	/fs+62xhLpFLbv5IvXFy/H5iAQi1Nu+epwXQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xLCXm-00000007Xbc-0NqX;
	Mon, 26 Oct 2026 12:42:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 Oct 2026 12:42:46 +0800
Date: Mon, 26 Oct 2026 12:42:46 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [REPOST PATCH] crypto: caam - reject overlong RSA CRT parameters
Message-ID: <at7aRrDPsroWZtuA@gondor.apana.org.au>
References: <20261008093553.384608-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <atCc0iL0RrDLwHHX@gondor.apana.org.au>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <atCc0iL0RrDLwHHX@gondor.apana.org.au>

On Thu, Oct 15, 2026 at 08:28:50PM +1100, Herbert Xu wrote:
> On Thu, Oct 08, 2026 at 09:35:53AM +0000, Jérémy Jean wrote:
> > caam_read_rsa_crt() right-aligns dP, dQ, and qInv in buffers sized
> > from the corresponding prime. rsa_parse_priv_key() only bounds these
> > integers against n, so a malformed key can provide, for example, a
> > two-byte dP with a one-byte p. dstlen - nbytes then underflows and
> > memcpy() writes outside the allocation during set_priv_key(). KASAN
> > reports a slab-out-of-bounds write in caam_read_rsa_crt().
> > 
> > Reject empty or overlong CRT parameters after stripping leading zeros.
> > qInv is consumed by CAAM as a p-sized value, so size it from p rather
> > than q to match the DMA mapping in set_rsa_priv_f3_pdb(). Let the
> > top-level key cleanup handle partial form-3 allocations and return the
> > specific error to the caller.
> > 
> > Also test nbytes before dereferencing it while stripping zeros, so an
> > all-zero integer does not read one byte beyond its input.
> > 
> > Fixes: 4a651b122adb ("crypto: caam - add support for RSA key form 3")
> > Cc: stable@vger.kernel.org
> > Assisted-by: LLM
> > Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> > ---
> >  drivers/crypto/caam/caampkc.c | 69 +++++++++++++++--------------------
> >  1 file changed, 30 insertions(+), 39 deletions(-)
> 
> Sahil, could you please review this patch?

Hi Sahil:

It's been two weeks and you've provided no feedback.

If there isn't going to be timely feedback to patches on this
driver then it will be removed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
