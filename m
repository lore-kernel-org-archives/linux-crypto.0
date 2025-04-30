Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352E55228
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 02:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745979733; cv=none; b=Qfohr2+3V9gLtSLnujZfQNMz49TG1skgkCTkKmDbQDKV2utOtXP8C9yIqT2ZOrlmhrqQMnvEKqNMtUJlsrb8My+VSGXKRnmkOMWAaAnA4p6qD0a8ZAtr+LOOZj0yVOBZSmtz05rAWFJYqoUSvzuyY3dO3MIgB05S+ZKZGF9jf0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745979733; c=relaxed/simple;
	bh=fYoYrol44a6PpoWCBdId3oTojhXsKLLbPWvXKfn12yo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IeA1M0fBAG2hF8nhjAsTE81j1vRwCWsuWpTwA1V43GfoYiHxPfVmRYTFWUddLLbmCWNsn3RfUmqUWpLtyth3ZCqWwJETXnwaRjKOGuDc1/l166j/tPC6yz0ao1cVSeL+5q/6IbMk4apK4ca+lULygG2Fk7sj8JKMAR+8e/DqglY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Bf9AQHqx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Bf9AQHqx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lvum5XCfFrxHwKWxhaT6sHn49tBcEFyJxVQEKPLPfjo=; b=Bf9AQHqxwwQB8Z4GXaYsTQRIOC
	1B9THgt9LKDKjVKEpJN7I7HdE8u3GeCjzs+JZtzSb/Y+ETeKNGVAt86QhpwPiv0Ta2zRQw7vPPey/
	a715YW0voBrVFZQEfxZaUqk2qH0Y1J+GgF453sGUc4Zk5fNypAp7p1123eRab3osZiDBt91nl4T5a
	D5tlHgnZYX/0sbfld1+8oFHVZmJwzKZok3AeIrPvlMsd0hu6FiZCfsV8zyto8tsOuMTyTyBI3Y6ci
	Z2oNKwaC/2J75xRQIhcpm8v9UPfMyW5AAMPJxz49CFEI/xJJXNNSA548+5ft8xo3MYPB3nGVUSjRN
	Y4FuP33Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9x5D-0028qb-0F;
	Wed, 30 Apr 2025 10:22:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 10:21:59 +0800
Date: Wed, 30 Apr 2025 10:21:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/1] Revert "crypto: run initcalls for generic
 implementations earlier"
Message-ID: <aBGJR55J3hkFZvfJ@gondor.apana.org.au>
References: <aBBoqm4u6ufapUXK@gondor.apana.org.au>
 <20250429164100.GA1743@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250429164100.GA1743@sol.localdomain>

On Tue, Apr 29, 2025 at 09:41:00AM -0700, Eric Biggers wrote:
>
> arch/*/lib/ should be kept at arch_initcall.  It makes sense (it's arch/ code);
> it's library code with no dependencies on any other initcalls; and it can be

There aren't any direct dependencies but if you end up executing
the code protected by those static branches things may well break.

For example, fpu_state_size_dynamic() is only initialised at
arch_initcall.  So if you enable these lib/crypto static branches,
*and* someone actually calls them early enough during arch_initcall,
they may end up hitting the FPU code before it's been properly
initialised.

I think it's prudent to delay the initialisation of these static
keys until later in the boot process, unless there is a demonstrated
need for accessing them early.

> use arch_initcall.  (And FWIW I'll keep doing that arch/*/lib/crc*.c, even if
> you decide to mess up arch/*/lib/crypto/.)

I'm not going to touch the crc stuff.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
