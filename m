Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEB626AC3;
	Mon,  5 Oct 2026 03:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791171183; cv=none; b=hTifob4gHgWqd+A3nwjU7CyYQ4tqIOyX5zyBr+ZpsmEzWzvtKS3AkhXA90W2jqU5dw7St5fZlSURX4PROS+V5Rxra3JdbO0CtovFY/lSRs5p9EKlbK/CnN+meBTjK4hDzJ09xbwpgqoI4FKZM2S2X3V+NtmhwupZLP7D+x62mqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791171183; c=relaxed/simple;
	bh=yxbujoWVSCjtVaHf3TRK7uaQrZ4FFMYjS/+jT1RGem4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7ai/tY21A53swiw2ROfpLklkT5PQAm/6ALAp9Gc5xYNsmSRsHFy/v93cQ/dcitY4N77wQ23Iw2LG1uTCx3pFDOis6hPsxd4FBh5mgjMw9f1uDwRHdw+iXFnhZ5XBGWbq6go+6WP1lzpzw8OZuwNcPaePDyUmF/tGrZX799FnFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cG73eXWV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cG73eXWV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=w3u3WhIUsAmVXpd2DbmdKazE74Jt9Bboj8+iMMDQiU8=; 
	b=cG73eXWVCWCBtbvZn02Wt8e1a54y+Q7WJXw1pS7ENAevogGRwrC2rfWpLCZXR8akbDIhi34pc/u
	yp/5hXlfcKDZr2uzlcOHQM4tX9FqDmw0ssuAD9Yf1TpzdZTf4wuK2+txb52Cq8+vJ7Jdsj3EOHV1f
	aaAEXb4lBmLTMaWTJ32lUPpPdtbUDRihYxFZuIcpC0/nSLhjFIu0w+PTf4rKHIg7ivXzl2RAto8Rz
	idcQJil5q7Qpe8XN6nW09493p27PR6FC1Hj6yQmY6aAJfCEeTTiDqYXkoF7YMA/6+WOojfxt9GW3c
	/JRAXygq/diuEsRg/1SY/7TjL4XGN3qC0wng==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xDZRO-00000000jEF-0M0k;
	Mon, 05 Oct 2026 11:32:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 Oct 2026 14:32:38 +1100
Date: Mon, 5 Oct 2026 14:32:38 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Erwin Pawliczek <pawliczekerwin@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Paul Louvel <paul.louvel@bootlin.com>
Subject: Re: [PATCH] crypto: ecc - Use constant-time modular inversion in
 ecc_point_mult()
Message-ID: <asMaVj3KFINl3je0@gondor.apana.org.au>
References: <20260928042641.307683-1-pawliczekerwin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928042641.307683-1-pawliczekerwin@gmail.com>

On Sun, Sep 27, 2026 at 11:26:41PM -0500, Erwin Pawliczek wrote:
> vli_mod_inv() is a binary extended Euclidean algorithm whose branches
> and iteration count depend on the input. ecc_point_mult() uses it to
> invert the projective Z coordinate, which depends on the secret scalar,
> so ECDH leaks information about the private key through its running
> time.
> 
> Reimplement it with the Bernstein-Yang divstep algorithm ("Fast
> constant-time gcd computation and modular inversion", 2019,
> https://eprint.iacr.org/2019/266), and keep the old code as
> vli_mod_inv_vartime(). Only ecc_point_mult() uses the constant-time
> vli_mod_inv(). Signature verification now uses vli_mod_inv_vartime()
> because its inputs are public: the s^-1 inversion in ecdsa.c, the
> inversion in ecrdsa.c, and ecc_point_mult_shamir() and ecc_point_add(),
> which only they call.

Last I checked we have no in-kernel users of private keys at all.
So does this actually have a real in-kernel use-case?

In fact we should probably strip out all the unused private key
support code from the kernel.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
