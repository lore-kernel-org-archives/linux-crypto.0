Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1301917F4;
	Wed, 25 Jun 2025 03:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750823359; cv=none; b=NJsOGp+ARMTqQTfvSt7boUAxukzKJX5ViJCOkWbisAzpGpxUdLEcEuVp/Cc4nStRy9kZzUTbbzRZqCvj66CUwvaW4HL9zZ6RThPbczJzzI1HZVzZsiiapvBvowjIBG/ymI+Q/yBAmyeS3doNCdzGF35hCwq73QB3ss9qX4Ejr3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750823359; c=relaxed/simple;
	bh=X0pN2UJYxjgZeGP9g6Xzu03ehdxRQ/VXhN6E3tzMD8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNsBupqSAPkvuM2UM68FTNAXE/fG1NNZeBqNSKqpg6nL/8aAdwMESs3UADLQAa7v69lroFETpIjfT27H8CH0MabiF8nuMNSvAVjgA8EqJEqV68lK1urSczktGMN1AVTvjQsca7zrbJZ6MpiNewGsp44Ef6K4Sn6ZFmQfR4WOMx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Agt9GXyI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Agt9GXyI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6i5J4X0Hy7jkXI7Y+Drwuxdx/VFjIHMKpqXzVyFRGOE=; b=Agt9GXyI/8fLEMASAlVbdbsqXM
	YYfnTNYcajiEs2VEFbQFg5UjtssYepQxp092n/GMZA1wTA9wJ9RZRKH9ZH7SAZfv7Y2za/kPlYCI5
	R1e5xx5t01lUqt3arMvAAhMD3SWYv7ZJeBkIr9Ytg63kxsC90D1ToXmgRRFkv1fl4bWoMv3rGpuH4
	ict/rYlr+TKkF7qELYuq4WZQ5GpXqn/FXETJ/I8wd0tx3K5pgKZnZ5vINhmgqgRCqEfBRBS6CK9sL
	KWGdPjw3Cso3t8BB0GLmlTDUBOrwM/rO/O0KAA46IN6DuCQaOmJN0Aw+FsnVU5dS72HOSZ3VXmQRl
	c5Nsvh6Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uUGsn-000nLU-02;
	Wed, 25 Jun 2025 11:49:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 25 Jun 2025 11:49:05 +0800
Date: Wed, 25 Jun 2025 11:49:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Fixes for 6.16
Message-ID: <aFtxsQx5D_nIWDU9@gondor.apana.org.au>
References: <aFtidDP6MLX1V2A6@gondor.apana.org.au>
 <20250625030404.GA8962@sol>
 <aFtpj5y4HtzVDChg@gondor.apana.org.au>
 <20250625033238.GB8962@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625033238.GB8962@sol>

On Tue, Jun 24, 2025 at 08:32:38PM -0700, Eric Biggers wrote:
>
> These legacy drivers should just use the library functions.

As it's currently structured yes this would be a perfect place
to use the lib/crypto interface.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
