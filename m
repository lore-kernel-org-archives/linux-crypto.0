Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125C613C908
	for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2024 04:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729052135; cv=none; b=gPufakg0kXYGsNqb35W1Os8guvz9Y6yftrs7TR+UCVf/oQ9vWMaO2zmLhF83u6Zmgz+105Hx2yeDe3mu5R3bz29Z6hop8P3y2IR/7gdu7osSXtNCkpab3bcA31nWmxiDwwjeEaOrKHHnhO6H3y1/hVdsCwgzGHKelLr6zPd9CW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729052135; c=relaxed/simple;
	bh=EH2Kad6apna3V6fCJPn9M4+Lrju73vUU6xJoxlU5phk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dhmW5DLlGWojEj4rm3eBqtaBHKZFxxk5fwnTCWrIh6K9Lt9Hzu2dYb9AlKPsEGuV22Wfes5ld50tEK8CjRxyL4Ss6+gfMxmgOcvCHfYnctBkGVt4RblbpdHn4NDBIwSj4Qqfpb4Yne8V7I/c6SoGqej7gP+gLoFvq5BE+Gqr2ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bJ7n+pwN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bJ7n+pwN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=R2Q8N6orZLNFrMoE5EAkk4NEdcbZvVsJH/QybQ7Jakk=; b=bJ7n+pwNTc1yTbS5LDyizvwMXa
	KXb/IetGIduBaHMaVt7uzxw54NtpIob2XFsxcqCy7Y9YSPCdv6l8YpFEIblc1OEQySQOg/Gc6N92D
	ZnZ0+y0dR//cxMUc2dPGBPqMlcAkTvDtCjOwiQWoNjcQXMutTw4hHFm8su72fbDHshKSTIDk1bI3X
	XSEakHk/zqGXO2cvAc39DwbQFgz0Er3Eu5V49x0YQl91a91ynqbVkT7wonmYMs+IyZYORc/GUuydT
	rIc9hnyWKJt7NgAW0Hahfdp/VqyjBaqNNLn7LV5jC+1qwyDHRk3Hl4Y43cjac0L6lcCzYW4+nZBjG
	wGuv1CJQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t0vHc-009jGg-0Q;
	Wed, 16 Oct 2024 12:15:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Oct 2024 12:15:25 +0800
Date: Wed, 16 Oct 2024 12:15:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 0/2] crypto: Enable fuzz testing for generic crc32/crc32c
Message-ID: <Zw893e1MySfQRjK0@gondor.apana.org.au>
References: <20241015141514.3000757-4-ardb+git@google.com>
 <20241016022051.GA1138@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016022051.GA1138@sol.localdomain>

On Tue, Oct 15, 2024 at 07:20:51PM -0700, Eric Biggers wrote:
>
> Wouldn't it make more sense to make crc32-generic actually be the generic
> implementation, and add crc32-arm64 and crc32-riscv?  Likewise for crc32c.  That
> is the usual way that the algorithms get wired up.

Agreed.  The library interface can expose the optimal algorithm,
but the Crypto API should not expose the library interface and
should instead hook directly to the C implementation.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
