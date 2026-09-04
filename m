Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C87F448BAB;
	Fri,  4 Sep 2026 10:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516092; cv=none; b=cOC2o/dyoOwlfc/z07dDii4/La8JUBDALyA4tkd9PwpqaBV66ieY7h7Q3lUKlPAHTj7ql177IXNS7d7h0wGiMLLCjfYOSZsENRXysSRV7LvLpB/woicN8ptBclOXnM+s7onCO9OF+p/TCx6uhsFXaOsFOh05mbiwzB5BwAO8pe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516092; c=relaxed/simple;
	bh=ngRMtBFrSao5szf3YSxSCn6DvNTfFy1ilkWKXrKaa9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oqtuucxAYtuDjDm4QinwboQB/nXM4x+aBnU0ZO25YcoFD3H+6M/zlcTUrg52wX1lk2ZJNRa0+JpZcmfNwtuqKNUnKMYmaYXgxpb9iXFftKIqQdszGALGzPgPM6a+kuKw7KIfi2Xx38quhttG32KvtWGPWqGPpPBJjQ24sVgC22o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fRVYFVGo; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fRVYFVGo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=e44zkj1IMT00mrh4C9JvWBdpJDB5PPT1CQ6U1hHFlfQ=; 
	b=fRVYFVGom2IniiSAFqpw+zFCcjwRExBZrSJ88F+YGkWm5wVpTUPJu48ZLiwy/2EbwxTE21B659I
	s+2GMRqXAqt1i0gzBR70hiN3GAHmOJmwsKncVOjUfHX83PEvBNp1YTIekAfRmFR1ME9qIksgU/we0
	i5nz3CtcYhp16pindXWDNEVKI7SsbTUe4cUwVIoSWiCBf7tCE1Kva9SY5ofyixXGITnwF4pX+X2g5
	Xj2yycGSMGPw4wKNX18HRxJiiVgrC9Z11T2olfQV/+veG65oNkZoG0tCMIqmtgTVkOmovAnSJPIZR
	k9LqbTAbSQ8UVfw7MQSW2W5fkn8jb9aYhz+g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2Qjc-0000000AnKd-2bwF;
	Fri, 04 Sep 2026 18:01:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 20:01:24 +1000
Date: Fri, 4 Sep 2026 20:01:24 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: NeilBrown <neil@brown.name>
Cc: quanyeyang <quanyemostima@gmail.com>, Thomas Graf <tgraf@suug.ch>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] rhashtable: use private lockdep class for all locks.
Message-ID: <apqW9KXs0JywvG2L@gondor.apana.org.au>
References: <178677504716.2852630.10509837046652973246@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178677504716.2852630.10509837046652973246@noble.neil.brown.name>

On Sat, Aug 15, 2026 at 04:24:07PM +1000, NeilBrown wrote:
> 
> This patch builds on
>  Commit: 060d4e94b8d4 ("rhashtable: give each instance its own lockdep class")
> 
> to allow lockdep to see each rhashtable as unique with respect to all of
> the locks, not just the ht->mutex.
> 
> This is needed if rhashtable is to be used tracepoint BPF which could
> run while an rhashtable lock (in a different table) is held - see Link
> below.
> 
> Rather then adding extra keys for the other locks, we use distinct
> sub-classes for the different locks.
> rhashtable->lock uses class 0
> rhashtable->mutex uses class 1
> bucket bitlocks, which are the only ones that are ever nested, use
>  classes 2 and 3.
> 
> Currently rht_lock() and rht_lock_nested() are quite separate code
> despite the near-identical function.  This patch moves rht_lock() to
> after rht_lock_nested(), and simply calls that other function with a
> nesting level of zero.
> 
> Link: https://lore.kernel.org/all/20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c@gmail.com/
> Closes: https://syzkaller.appspot.com/bug?extid=ef8d17bae14efb960935
> Tested-by: quanyeyang <quanyeyang@proton.me>
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
> 
> v2 includes a change to test_rhashtable.c as advised by sashiko.dev
> NeilBrown
> 
> 
>  include/linux/rhashtable-types.h |  3 +++
>  include/linux/rhashtable.h       | 22 +++++++++-------------
>  lib/rhashtable.c                 | 14 +++++++++++---
>  lib/test_rhashtable.c            |  2 +-
>  4 files changed, 24 insertions(+), 17 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
