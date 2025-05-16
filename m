Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A8F15530C;
	Fri, 16 May 2025 09:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747386931; cv=none; b=HOzlNYToO+zSShKsxMaJUBOUGaK7OdQqVesCwcoYyJfwDWQhb3GJz9Nh2SpjxO4H5OMW8rdoxuTTq+b6SIsSdg6ZibUUN+qbhgjnmUlDbO7oFMDV7knW2XexSC+yDEmiU5dDzBHx6DptVfuGP3FKJPeiMcA3L3xqDysdYuBHN7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747386931; c=relaxed/simple;
	bh=Egq6ce+2LZGhqq68EbS43+HWg39KGQZYoiRiijHJx8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t1p/hqWKheh0lk+J4TnE8+Ufs/Ct8/y8dSTuK3uJYChdVrudNvlTo2Y14gN3mi09Qtjsv22MBoGhGfHNmUJeV/XxBcnDNtEUsny2K6cGogquflZApchYZQfcPVLxhulHifnVKnTqccDs67x4BnpY0d8SM9gG8Il+zdxA5y+6vnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pOiRdlbi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pOiRdlbi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hM9ptJv7/5jhuLI6nnEktZ1AuLR89/+CBZuj9DpF90g=; b=pOiRdlbiZGhGiZSB161nVy+52O
	EyGoaR9L90eWPQfk2tdlNj964JBH9EOanc+RVr9SRnxu22QUBheEYCsx4U27ohuNF/+pUuX+x62yc
	J3QkQ2k5IUA76wRNtcyziiEYVB6gfOLMjDIkYkvE/u82QN5knJiEfnTbNP1h51udHFdR4jRP0q5MA
	pFV+IKs6EXJy6wEPCbE6NUBCHBZZ/dyBl47SPR6x0MdRWOOO3//LBgn2FSjhqYv/LNYBvPqY66E0g
	mt8w4FNAEcW/jTcnqcnzMl67zeB8mG1XzngSkdPz0dRe2Oag84ma1r7Ylg+wrzy2LrEnpyQK4ocbB
	Yb/JTCjw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFrA0-006XuR-2c;
	Fri, 16 May 2025 17:15:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 May 2025 17:15:20 +0800
Date: Fri, 16 May 2025 17:15:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: lrw - Only add ecb if it is not already there
Message-ID: <aCcCKJ0NpdvIpvsH@gondor.apana.org.au>
References: <202505151503.d8a6cf10-lkp@intel.com>
 <aCWlmOE6VQJoYeaJ@gondor.apana.org.au>
 <20250515200455.GL1411@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515200455.GL1411@quark>

On Thu, May 15, 2025 at 01:04:55PM -0700, Eric Biggers wrote:
>
> It didn't actually make a difference until 795f85fca229 ("crypto: algboss - Pass
> instance creation error up") though, right?  Before then, if "ecb(...)" gave
> ENOENT then "ecb(ecb(...))" gave ENOENT too.

I would consider this a success, it actually caught lrw doing
something silly by trying to allocate "ecb(ecb(XXX))".  Sure we
can sweep all of this under the rug with ENOENT but it might end
up blowing up in a much worse place.

Also I don't think it's true that ecb(ecb(XXX)) will always give an
ENOENT if ecb(XXX) gives an ENOENT.  The error is actually originating
from the lskcipher code, which tries to construct ecb from either an
lskcipher, or a simple cipher.  It is the latter that triggers the
EINVAL error since the ecb template cannot create a simple cipher.

> As I said in
> https://lore.kernel.org/linux-crypto/20240924222839.GC1585@sol.localdomain/,
> that commit (which had no explanation) just seems wrong.  We should have simply
> stuck with ENOENT.
> 
> But as usual my concern just got ignored and it got pushed out anyway.

I don't ignore all your concerns, just the ones that I think are
unwarranted :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
