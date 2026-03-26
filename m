Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D0A35DA5D;
	Thu, 26 Mar 2026 09:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774516406; cv=none; b=ZeLXckoqpWnlC0ZnWyViOwTtXuv60EMQgZghQ5eHzpsyiqAIFWaKyTMlaMoZPzpC2T4CLqC7yH3MJsncuPOeyKMPC36g9u8GMhZwC789V7qIpmGPAo3NrFpWMgHHxfxdGkcWRtu3yua7fAQaiYBFrrFK3d0MUMAgQUfDgHiZ3yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774516406; c=relaxed/simple;
	bh=fnMgJZZt+8NhaK1JkeENBPDakWhoL2JWHDAEY3jJIns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e6mS3phokJHK4J6GPyGsSpmKX8jIvDaJ4Fb1qVZUgD0xEEYYVlKVtRa4kHKA+nOlr4FmZFRjxXScefd3kBvTMS/0WH9VHA7QZg+JjZXZf3Rj3PJowcbcXMuLv0Qc0ygY9koiWOQo7iisz/YyqViwNMgNQ6Kq1ZamQH2vgTR4jvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=niAheoMl; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="niAheoMl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=uSSPAq6Xik9nGaf6SAgQnpT/y0zYt468rwfRwomlkbc=; 
	b=niAheoMla6VxNRa86gNpbNjiZ2fQsd21q8pjc3rwq44Sd7E4uSNFb5eXTZhudeeZgOuSD/OA1Gh
	g+f8UPcNpAZvDTgBNlp15CQYZ8eHwK4rFKA/feOHsFXTbll2/6Oj5vFwXFWDzsOlhITq5SWlc8LeW
	fUmrBHKiNkrMVofyqQZVyDYCnUXXhl4b4qDZVXAuaAOs9xge/vSb8SybgBpkQ2Axre7uV+6H0F+Fn
	IOfivBl/lT6wCrBARxw/uhgf7C8Yuke8toUpXrDNDblIEaN8cOPPE0UQYLq6CTCa3Vc3hLJZeT4NC
	c3fTuU+DM3R+i58gEiPI9Xu9gG0kmv/lzOmw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w5gMj-001Fpw-2c;
	Thu, 26 Mar 2026 17:13:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Mar 2026 18:13:16 +0900
Date: Thu, 26 Mar 2026 18:13:16 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Paul Bunyan <pbunyan@redhat.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	NXP S32 Linux Team <s32@nxp.com>, imx@lists.linux.dev
Subject: Re: [PATCH v2] crypto: caam - fix DMA corruption on long hmac keys
Message-ID: <acT4rG1sSt17MBYC@gondor.apana.org.au>
References: <20260317102514.3882809-1-horia.geanta@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260317102514.3882809-1-horia.geanta@nxp.com>

On Tue, Mar 17, 2026 at 12:25:13PM +0200, Horia Geantă wrote:
> When a key longer than block size is supplied, it is copied and then
> hashed into the real key.  The memory allocated for the copy needs to
> be rounded to DMA cache alignment, as otherwise the hashed key may
> corrupt neighbouring memory.
> 
> The rounding was performed, but never actually used for the allocation.
> Fix this by replacing kmemdup with kmalloc for a larger buffer,
> followed by memcpy.
> 
> Fixes: 199354d7fb6e ("crypto: caam - Remove GFP_DMA and add DMA alignment padding")
> Reported-by: Paul Bunyan <pbunyan@redhat.com>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> ---
>  drivers/crypto/caam/caamhash.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
