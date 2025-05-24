Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDA719B3EE;
	Sat, 24 May 2025 06:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748069498; cv=none; b=BL1I9VZFvKKIOzQc1jG1B5tFa/tNav+PlT6sS/pSLjoXNSnvHvWOkHTe9gBsF/wSQAh7VUGrAdzTL2IoW5X0dz1wU2Zg9+o0ZDI+oXHU/erzeWPqfb5rnCNQOEHiiMZyYfE3VSXDUhc+1cJPwDI+wxx4oDSZyMB1OznEfpBo0BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748069498; c=relaxed/simple;
	bh=0wA5rW5VBpIahjBbCpSFE/roaCLxL+HElGxGV/AFTBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oD0xvd8X4/6uNSW32SIFSZZcyQrPzEB7oVhJoFpHC4QCPFNyPmcgLeRqUs0jJveKA+YfQ2RmuJACgrmTrjSuISEzHgfty7IBOLdrWh+C7h6/LPs7qgN+zOdqMKOVVT6/zSPuAwXlYnf6K02KGcOONqxK2WAX/hotuo+EOa1RgMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MMRibPhc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MMRibPhc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=z2n7ndNPUiLQjYGGaJNnEctawS/IW2vcBvKuMaloW+0=; b=MMRibPhcSINuypIsPWgun1Pxp+
	eVw635F/WpVrN5KsbruNUE3yqKI39GRTD0a351v/exyeXoz151UyPt2OAN5gt8p1kqalAcmv4PdgU
	6rpN3+UbN6RHqilFZjhT2W2OrxQCE3RDDhOTlQjsAxZ4+nDPkmZm/hGEFXunkChsUN20i4Qu/X4KK
	eXOsTiNXs+rvb+oGKbyWGHzhhI74EZI+58gCfrhudh5RyK0MeVuTl8T9etyKXXApySBiTLT2u1nWy
	+vLVaDW4+z1jidmXxannevWZRGANZ7uPxk9WmU5b58lu81Ae692Br+o+rrUg+b6aGGxI21FpYtj0Q
	EtyqqkVA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uIiim-008Ur0-1m;
	Sat, 24 May 2025 14:51:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 May 2025 14:51:04 +0800
Date: Sat, 24 May 2025 14:51:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: Dominik Grzegorzek <dominik.grzegorzek@oracle.com>,
	"aishwarya.tcv@arm.com" <aishwarya.tcv@arm.com>,
	"chenridong@huawei.com" <chenridong@huawei.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"steffen.klassert@secunet.com" <steffen.klassert@secunet.com>
Subject: Re: [PATCH] padata: do not leak refcount in reorder_work
Message-ID: <aDFsWA43h8ToQUhZ@gondor.apana.org.au>
References: <20250518174531.1287128-1-dominik.grzegorzek@oracle.com>
 <20250522131041.8917-1-aishwarya.tcv@arm.com>
 <afc8bfdaf9f14fa1f77c62f2969c4a5403ad771d.camel@oracle.com>
 <01bc9f1e-5a49-4387-b0cb-c2f8647e3b6e@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01bc9f1e-5a49-4387-b0cb-c2f8647e3b6e@sirena.org.uk>

On Thu, May 22, 2025 at 03:02:14PM +0100, Mark Brown wrote:
>
> The hugepages code does make use of padata and it's a hugepages test so
> there's some potential connection there, definitely not an obvious one
> though.

I just had a look at this and the hugepage use of padata has
nothing to do with the patch in question at all.  In fact, the
two users of padata pretty much live in separate universes.  The
only connection between them is the shared set of work structs.

So I think is a false-positive bisection result.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
