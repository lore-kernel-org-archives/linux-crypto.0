Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114EF1386DA;
	Fri, 29 Nov 2024 08:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732867406; cv=none; b=mEKKcjZhDzwsH0KwOoTDFrmXgPMmIBPqn0ZDhA3aJ5TzA8EfeQN99pk8ZvAQMwv0dv17sLVzvhexEkxzE795tjkwVAzSYObi64ZI4LkFXGBDNxCIZjUCgK9Ot18Ai2bNN+LK1uEZwo0cQSh4plCQZ3FG00e0TDZYCIV/c67JECY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732867406; c=relaxed/simple;
	bh=kGri16/ImZOKDGaiLaic3Uv52gfxoK3N4CEXKjQlzD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/K4z+j8Og9bPZJg58biv8aW+eKA21zPvPyo7LP6bRREKRXjX0eMrLDWn+YMJT4gyQWQWM0myPDipTPyiYhZaifvC+kwpr5kdlCpCHwBYueoJfFB+ajX3HQoZDUU47kF//lyaLv741FeuGkiNAnfvTnbuPzC9UdvlJBI5DJec7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZoWIEVu8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZoWIEVu8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5/BSC2qpFBtcihW54L9NVV8nUFlWPNDr07rwh6J6P+o=; b=ZoWIEVu8alMzYOmGZlTjmTDgUU
	N1ndBYJhEbat49Os/jX5cL5Lqoh27bLe3WMeUrCjolouW4YJywXjSav5PO/8yEFuLWxWpOiBGHJhO
	uds/5VuxPoUS0Mst0Vo60kjGhZrv5mnn0xnpMFKGMRiOhMdK2mjy6mmOxvtN8WMxSGixFr4XuJf5M
	RPFMJx8OWs/OfedoKc+Bv7SW6ilHz1BVJSlRiwkbrmy/UfI/RjiT5kP98YoCQbD/xHM3zbZY1cgak
	FWqpxnfzsGt166OCjWGv4CdoK+kqFUUe28U+G8/7mLJMOQUEj+3gez3RrITVTptzLQr4G2ik4x0Jy
	vpZ8sMiA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tGvy5-002LZn-00;
	Fri, 29 Nov 2024 16:03:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Nov 2024 16:03:12 +0800
Date: Fri, 29 Nov 2024 16:03:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: Ard Biesheuvel <ardb@kernel.org>, Zorro Lang <zlang@redhat.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bug report] kernel BUG at include/linux/scatterlist.h
Message-ID: <Z0l1QI4-zK9EVNnJ@gondor.apana.org.au>
References: <20241122045106.tzhvm2wrqvttub6k@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAMj1kXGAuJSdDWvu7D5-PT6mSbNG9FeLObnYmpHeT08eNxaJWQ@mail.gmail.com>
 <Z0A2W1FTTPt9PeI5@gondor.apana.org.au>
 <Z0BCtZi2YJywGJAk@gondor.apana.org.au>
 <Z0NTLDYJQC242GMB@wunner.de>
 <Z0OzDle-VrrXf8rW@gondor.apana.org.au>
 <Z0RRiq-BJp8CYdNk@wunner.de>
 <Z0RTgsb5Va9psaIs@gondor.apana.org.au>
 <Z0lzOw7mQGuPrXlD@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0lzOw7mQGuPrXlD@wunner.de>

On Fri, Nov 29, 2024 at 08:54:35AM +0100, Lukas Wunner wrote:
>
> I'm proposing an optimized approach which auto-detects whether
> duplicating into the linear map is actually necessary:
> 
> https://lore.kernel.org/r/3de5d373c86dcaa5abc36f501c1398c4fbf05f2f.1732865109.git.lukas@wunner.de/

No this is not going to work.  Linux runs on many platforms,
there is no portable way of doing DMA over arbitrary kernel
memory.

Only memory specifically allocated for DMA is safe to use in
an SG list.

Since you're refusing to fix this I'll take care of it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
