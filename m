Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3865613B7BC;
	Sun, 10 Nov 2024 03:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731210506; cv=none; b=HUCGde9tqd1aqOdTJEu69hZyqYWZBUdyuwg7Kiz11ijv7rgVetav4A6gyIG6fW2VpOXoJdSuGM3SKPrgjEe0+FOXxwfv5DcLmBjuMKmDncFHuZacKxJ0rVTwfI9dmvEuZkMHGWk762NUy7DzOX0zhkxd42VNS2lPQlTOGtJgOnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731210506; c=relaxed/simple;
	bh=iP2IfchInClbIFxbHmNCK8J+QsZ4TmrefBkr67ucP8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kTAu2r3YLmCZYrCrKXPhPSns8AsspajjGBUYLV5cFBAzFiR3u2maqxIAGd+go1e5nqZr0cYpFFNjJxmqXbMUaiX/XTUn5/TKyvVVYM8VgG/qH0/VViUblIrzttO9EW3MQxB+fDVflPagRhYE98JJ1wosW+PHlBWRglNzpuWGQhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sbqExd2p; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sbqExd2p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VMmFZUPHeE4jmEveAxE3+7pM6F9Q/EnroxK+vV0ClSE=; b=sbqExd2pLRXs/z9gJ5amVAHNzT
	e9yb1mspisR/98Gv+tPmVedo/sgRT/Hsg/37kL5ZqPM1KJ1TWXF+Oz1fDY8hESqcq6AUjKjtZV5Kv
	5vZuaXyWGyD6QWbqlNRjkjhqnpQjEiRnht8RJT+0TUQ3fkartW+w8xn/+n7DZoc4a6mySqN4WPSfE
	MN3DJDZrcvPNo0NYDKUx87BvNWQmYCwOrmVLcjI0dxCTWcSqyoTRp80zECFBbHqrYWRr1cL7YLSMs
	GPhsNBrreSppmOkEJpkI7qKFC8VTiOFBC4tYZGbnySoVuxVmBas1TigkolceZIe8/NpT98y8K9CUa
	OyLLC0JQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t9yvr-00FkCz-39;
	Sun, 10 Nov 2024 11:48:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 10 Nov 2024 11:48:11 +0800
Date: Sun, 10 Nov 2024 11:48:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v6 3/3] crypto: Add Mediatek EIP-93 crypto engine support
Message-ID: <ZzAs--iaKCXIY-Kq@gondor.apana.org.au>
References: <20241102175045.10408-1-ansuelsmth@gmail.com>
 <20241102175045.10408-3-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241102175045.10408-3-ansuelsmth@gmail.com>

On Sat, Nov 02, 2024 at 06:50:35PM +0100, Christian Marangi wrote:
> Add support for the Mediatek EIP-93 crypto engine used on MT7621 and new
> Airoha SoC.
> 
> EIP-93 IP supports AES/DES/3DES ciphers in ECB/CBC and CTR modes as well as
> authenc(HMAC(x), cipher(y)) using HMAC MD5, SHA1, SHA224 and SHA256.
> 
> EIP-93 provide regs to signal support for specific chipers and the
> driver dynamically register only the supported one by the chip.
> 
> Signed-off-by: Richard van Schagen <vschagen@icloud.com>
> Co-developed-by: Christian Marangi <ansuelsmth@gmail.com>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Please ensure that this passes the kernel crypto fuzz testing
(CRYPTO_MANAGER_EXTRA_TESTS).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
