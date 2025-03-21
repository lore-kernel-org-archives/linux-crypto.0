Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D00208A7
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 02:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742524615; cv=none; b=J3oJkbcOczOKPFc0eBoFdrZUiM7G9kO8NoTA4qafNbOLuGY9hFB9h/eyt5VsrZCITGX5mw67jX2/6j2J+QHogneVUAj50JJ6zZhn0aIjKKb6/+1CFmhx3r0nNrNmdCvUqcgnb0I5oIm/ljHg4KAYoge+5wZmEZcOtA3wzvQ3MiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742524615; c=relaxed/simple;
	bh=YGtwEKTJqU1JIujquaCQdWU+CB+5Q/Y9dgFFkMF2/14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSt9m94mAs24iyHe6BUFe0/aZt4j4fCgPstn15iwj/5znRhScwIstjTelKbMzdg7LP9zhIqNZnglt7Mj2QQ149cyjhY9OwgTr90HUfzmiE/jfKv07/RDytu5qOuVK/iXnXqouZZzFHoYxNI0GhLK5IUUS4fxpi5pniYHJebMj5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=oAIeOVy4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="oAIeOVy4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5EsWK4dvcDBJZFey1wRWPC/pWTcodP9QhI4Nh92kyxA=; b=oAIeOVy43pxP7FIWcaavCE2kF3
	C6aco/lxSVdaf8T9r5bTf5VaxIbV3LuzOFr/9K9PlgjyEOxQU68MuAW3f7eeoF3bJqwNvXCwMX4ID
	aj+E+V8hJeF95kPnNG9sxcq+fBpPnv7c1AXTo/FNYBJWHxR6ZQ21uh0EabLQ+t5+yA8XyDEzsK42V
	H8fiVVr3bC+8WMfiuo2bvQyqtxx3bksHouO+rkijsyNIlvCTzVKYjv9oLdZtAiq7/GWnp2/5VW/oS
	zRLJD2Yh/C60gDpRGTyavIXaR3a3JhcXP+X3WnppJ5jdHhvF9isW6UMk8NItT54GaOqCuCFXto3ba
	zm1K+tgA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tvSFb-008ufM-0C;
	Fri, 21 Mar 2025 10:36:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Mar 2025 10:36:47 +0800
Date: Fri, 21 Mar 2025 10:36:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	YOSHIFUJI =?utf-8?B?SGlkZWFraS/lkInol6Toi7HmmI4=?= <hideaki.yoshifuji@miraclelinux.com>
Subject: Re: [PATCH 0/3] crypto: Add SG support to deflate
Message-ID: <Z9zQv16-Wq3Ojgyi@gondor.apana.org.au>
References: <cover.1742364215.git.herbert@gondor.apana.org.au>
 <CAMj1kXGAokDnf_spFU85qCh+quU4eewgWwCO6-UpCWDdf5Q0Og@mail.gmail.com>
 <Z9vOUut7CWJK0kVJ@gondor.apana.org.au>
 <CAMj1kXHXZoaf3H4brxm2O+mvw0iebEUkO2euNj4CeDVn4dz40w@mail.gmail.com>
 <20250320173450.GA697647@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250320173450.GA697647@google.com>

On Thu, Mar 20, 2025 at 05:34:50PM +0000, Eric Biggers wrote:
>
> Then again this patchset doesn't apply, so it's unreviewable anyway.

You can test it at

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git acomp2
 
> The kernel's zlib was forked from upstream zlib in the 90s and hasn't been
> re-synced since then.

It was updated in 2006, three years after the USAGI workaround:

commit 4f3865fb57a04db7cca068fed1c15badc064a302
Author: Richard Purdie <rpurdie@rpsys.net>
Date:   Thu Jun 22 14:47:34 2006 -0700

    [PATCH] zlib_inflate: Upgrade library code to a recent version

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
