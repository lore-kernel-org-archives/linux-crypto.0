Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACEE19ABC6
	for <linux-crypto@vger.kernel.org>; Fri,  6 Dec 2024 08:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733475496; cv=none; b=AhSl90k6S8O6AoWjhWLUrX7ckQ8VD3DBBMGN7fycRSq6xl1KK0Tdt8HcfWnqFsfGvJde7vXx3vyL8uK9v5uXBfpudV8A9nzMTJcJ4dQuBfqDagJztECmcqRjVGyZHMhE4IqzuACnZF+2Hq3HN6kloNOuEd6rUQTKVQdZZ+BL/X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733475496; c=relaxed/simple;
	bh=BgH/X3uXOX7pWd4kUC0UXmq4z9BGBCB2amyUfkeDe1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ETW8Qzn3D0SnImOWmg3uZpxFGpkMkSjDgjFSynVlrYlxzRvzgrP4mVdqzevCaGB+SQeoYbJkhIhbeh5rw+rKLvffBHNW/XLsMaXanBFGQBnUOMLrW0tldCiBK5GLjjKjnYEZp2rm5nmmqTaFT7W8w6u2M7BcD0CdqEaAP2b5Jso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=byRN8aGI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="byRN8aGI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UnzTIawHaIIosCzRc6rT2Q2B93aT18p1pmThfZnrHFg=; b=byRN8aGIaEOBByqxAslifsbWlB
	ZYxsModWKFwtAdVr1NXNZprUFBDNXDPDt9KXKGHiuCfFQVXGsxFJ5+stoK9pbVGULOlpTSrZmLxNq
	udMyCA9+4nrQML37BIeeJ0XasO1UYuQq9a46zDIwY5ZUySyK4mxVj+gxDJ1dHgzVDNvlGIqrwcVOw
	1YOR9CIsp5wijWDpIw6QR4gci2d+gUZsxXqp8KMDLymtQ9R81ma3lKyBsVb+08wzoXbIliHft5SkE
	ml/KHBiHB6zoW+44qb5iVmi/fZkG+CQa/GrVyP5wLEcfR0DiJKTRh0+QFbV4qyVNO/ERyslfg42Ac
	vdUcAYcw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tJTKE-000LY0-10;
	Fri, 06 Dec 2024 16:17:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Dec 2024 16:17:47 +0800
Date: Fri, 6 Dec 2024 16:17:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: "David S. Miller" <davem@davemloft.net>, Zorro Lang <zlang@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH crypto-2.6] crypto: rsassa-pkcs1 - Avoid pointing to
 rodata in scatterlists
Message-ID: <Z1KzK7L0JNQUId5E@gondor.apana.org.au>
References: <3de5d373c86dcaa5abc36f501c1398c4fbf05f2f.1732865109.git.lukas@wunner.de>
 <Z0ly-QVERkD5Wtfu@gondor.apana.org.au>
 <Z1Kym1-9ka8kGHrM@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1Kym1-9ka8kGHrM@wunner.de>

On Fri, Dec 06, 2024 at 09:15:23AM +0100, Lukas Wunner wrote:
>
> The caller cannot predict which crypto implementation (software or
> accelerator) is going to be used and thus cannot know whether
> location and length of the src buffer works for the dmaengine.

If the caller is supplying an SG list then it is expected to
have already taken care of DMA alignment issues.

This is how it works throughout the kernel.

For virtual addresses on the other hand of course there is *no*
guarantee.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
