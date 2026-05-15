Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF5E3CEB89;
	Fri, 15 May 2026 10:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840485; cv=none; b=RgDKNOjdjCtUkwbNIDHVXcv49I0WZjccCshYJbxBg1EEpqMD7se04Mkvbcxx6MFhKurmTtYKhzRvtXIN3saFpvpeI9DyxGBCGIvKQjy7U1e3zrsMlpMiBsvyg1uujnXAdxxT1dXDSf3PAr8eX0R0UcHNVho53cI7TD82F8pRL7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840485; c=relaxed/simple;
	bh=gHfAuz0+7gTQ+RYzNmEZHNfQsx/3qfdTaE2iisKDTUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kx+GXO+fcwIiyjo5Ou8IGpUVaJoo0ecKEvKU/4ASGms05/LmH2VfXLqtcn+a8zwgpOe3OyJbvzJGBXmUcafGQw9GkE31X5HltSVeDUymwWFLjYkF4p7tAOnLFiuz2n/aBbn/E0N46u5buLnD0JT7bOc1oPedflxEiS7ZJikaXWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qvDoA6jX; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qvDoA6jX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qj5Lji3H9Rxy72bmCqrHUiTLlSgBl/T3vQDU14hFe5c=; 
	b=qvDoA6jXXMRJ8eZu9rzIgH5hGK9MTONG8dM+mkgq9dzrRrE+vcZ+q2GUeBM9LoiIhhzDr7H1OPw
	E8KsgO2G2M3jioNFx6EpOIExjYqC4aoFOXxXbI/DS7wWudIqjDZ5oX3dC044/MCfPNhUDMpU4oHqc
	TLG1wNsXcTXqe/5lS+XLEleamfxKBCJhZ0eYtXybbG0Dv7mYWgdgqZNGl2+0uXmbKROxlDMBkKSBr
	tdUucDNReKZr2fL3yjx2EQPD9SwYSIlhUdL2tfLyUMKVM7r7eLNY4qfY/3BRviCJm2KuL/ZlROl+j
	sJFTXAruAgmkEM265QxG40wIW5XatOHrfVYQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wNpfI-00EOUp-1F;
	Fri, 15 May 2026 18:21:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 May 2026 18:21:08 +0800
Date: Fri, 15 May 2026 18:21:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
	Lars Persson <lars.persson@axis.com>,
	"David S. Miller" <davem@davemloft.net>, linux-arm-kernel@axis.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: artpec6 - refactor crypto_setup_out_descr for
 readability
Message-ID: <agbzlHfI-yTqGi8r@gondor.apana.org.au>
References: <20260506091627.177426-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506091627.177426-3-thorsten.blum@linux.dev>

On Wed, May 06, 2026 at 11:16:28AM +0200, Thorsten Blum wrote:
> Replace if-else with an early return to reduce code nesting, and move
> the variable declarations to the top of the function.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/axis/artpec6_crypto.c | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
