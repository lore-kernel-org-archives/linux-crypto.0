Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5470F30748F;
	Wed, 25 Jun 2025 03:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750821276; cv=none; b=GC8jqoRYitA57h+XVYPWPiSvzLCXZ3TSJ/echxj2KNyuDQCF4OvQgNTBAYweYYV9rT38nC8bQ8t1EfbxBk18YdINtlYZugqyzG+Wqkx+YN4sCU62Dyped47S1NUdzNUnvaHmt4OrTQpoFQd4aTqD58F5CMfB5Iw2GnBHLR9Q9dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750821276; c=relaxed/simple;
	bh=6QFb5r6SPjqqiK8FSGJR2twXd8F5NiEsiYqLGrIzwHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E6KigOPbEjzvjlg36dhgCgdoCAKlBgh2+Yi76VTc3uOBoGPJDN+Xxku44/SQiIvh4fawqOFhwW7LmbD2U10ZTQcDnX5QRuC+jG85XbEwPev1kyUwP3DuIaHqvi+R4NbvypNV9aaAxkHgvuOavj7EYTaPUWk3JL9p38DMMPlM6wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lP84bPDP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lP84bPDP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oNP1bNxUEDeNp/jksbY98qbZ/s+Wi4rNkegDPAo1QIs=; b=lP84bPDP3Nr6ckmiee4d2IqCjU
	S5/t1gLGJ8AAGu5xWIlHXEPVWLNgMwQxFvwIrRnS189fHfjhfhtqgv5EwCGmv5W7K3kYtr/TINy3k
	97VHEtRpMmEAAEBlwMl5+Tv6/fBWHu7mjknWdCXD+UWbyzUCpE8qz5I132l0UiPY5M/5YGmEpOBIU
	CELPuLe+na8nZzcOe3LtlPu28fwpXyvBruDzVAyzSrLBxp95rTdI2sg1FtB3rgWqsyBWCEAYdcBwf
	V7qdPAiyfH1/3kXdab3LVvlPNxgxu44tYZDh6a7alzFP+4ouiBPzoYHBnzcdlOQGr0Uoxkpfyvf5L
	T7gy95lw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uUGLD-000mvD-13;
	Wed, 25 Jun 2025 11:14:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 25 Jun 2025 11:14:23 +0800
Date: Wed, 25 Jun 2025 11:14:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Fixes for 6.16
Message-ID: <aFtpj5y4HtzVDChg@gondor.apana.org.au>
References: <aFtidDP6MLX1V2A6@gondor.apana.org.au>
 <20250625030404.GA8962@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625030404.GA8962@sol>

On Tue, Jun 24, 2025 at 08:04:04PM -0700, Eric Biggers wrote:
>
> Wouldn't it make more sense to revert the "Crypto API partial block handling"
> stuff?  It's been causing a huge number of problems, and it's been getting
> superseded by the librarification changes anyway.

The partial block handling simplifies the implementation of both
software and hardware hash algorithms.  Just look at the diffstat.

In this particular instance, I thought nobody used hmac on wp512
which is why I didn't do the conversion for it initially.  But
apparently someone does use it.

> Indeed, I just found that a lot of drivers in drivers/crypto/ haven't been
> updated to be aware of the extra byte that comes back from
> crypto_shash_export().  So there are a bunch of buffer overflows there too.
> (Not like drivers/crypto/ actually matters, but apparently your changes are for
> its benefit?  So it's interesting that it was actually broken by them.)

If anything this proves that enforcing a consistent hash format
is the right thing to do.  All those buggy code paths were assuming
that the export format is fixed which was not the case prior to the
partial blocks work.

But thanks for pointing me to these buggy drivers and I will send
out fixes for them.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
