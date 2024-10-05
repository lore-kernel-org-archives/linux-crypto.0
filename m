Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BAE450F2;
	Sat,  5 Oct 2024 05:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106490; cv=none; b=kxvWxMSrCQIPZTMIOX7hh7Qz3VomO1D6TOP0F8cNOOJ0lCThqyDshUFQykMeyOVlJSuVE2R8ZDnCwVMt1ekNOx8q1S+FgQs4hTL8XUOYaxMUpjYatTOBf+gLgOmgHFeihhldgNutTX0qKxhS7bda5yw/AIYwB/dh0yXvNPLnQdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106490; c=relaxed/simple;
	bh=0GZUcDjSnzCgUbaC38svbsaehRbF0zY6EmIliEi7G9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m92a8VK8kTYXoSE8L6Ys/+Erhb9GNbSJORVpeI3XZ8xww9++5IWAGppZ3gY98Eu5cPts6JgEVr/ROm2EbzqmPjq+ndot+5YXVyT716sawyvVQ+3NlF7+noVMz9pKF3x0LCA2bKkqa44I8E/VNxaos9n/a7ODIgxHVAXnq4OD7I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PX7N6jB+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PX7N6jB+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OsvWDAtefqmPIRrd1N2Y+pvb6fpdjk40YCedZVF2ju4=; b=PX7N6jB+94DnDk0r95czsTjbai
	Hd8kio0MN7RDvGErAtRANiNSLQ1MvcME1iILA2HaumHq334cINJUe2JD1S34V6rBiIR73F9ndenqL
	+XglRpEhJ4+cxM2FcDdV6gg3XJ5tz6uSxRxPFsJUG9T+TPKF7sA7XZm5g4rB0ShjSX1oELDop6z3V
	P/kWkabajzQsOF9MMEN4zV3FnGYV8Wjtq0k9D4CIV+076NOgr/xhb0c5OU0EfdgVpMbl1iANM7U3x
	GnMx4prJ/U32auB4gFGm2OzP0kOw+n42Uty25TL9SMCKhJoRyaNr8MT2z5z5l+pqN+WWhYNUD7zbS
	bqJH7Bxw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxH4-0071as-38;
	Sat, 05 Oct 2024 13:34:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:34:28 +0800
Date: Sat, 5 Oct 2024 13:34:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Shen Lichuan <shenlichuan@vivo.com>
Cc: davem@davemloft.net, nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com, claudiu.beznea@tuxon.dev,
	gcherian@marvell.com, ayush.sawal@chelsio.com,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Subject: Re: [PATCH v1] crypto: Correct multiple typos in comments
Message-ID: <ZwDP5Jpt3wc3tXOn@gondor.apana.org.au>
References: <20240920061141.10720-1-shenlichuan@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240920061141.10720-1-shenlichuan@vivo.com>

On Fri, Sep 20, 2024 at 02:11:41PM +0800, Shen Lichuan wrote:
> Fixed some confusing spelling errors, the details are as follows:
> 
> -in the code comments:
> 	fininishing	-> finishing
> 	commad		-> command
> 	intrepretation	-> interpretation
> 	inuput		-> input
> 	overfloa	-> overflow
> 	Iniialize	-> Initialize
> 
> Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
> ---
>  drivers/crypto/atmel-tdes.c                  | 2 +-
>  drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 4 ++--
>  drivers/crypto/cavium/nitrox/nitrox_lib.c    | 2 +-
>  drivers/crypto/chelsio/chcr_algo.c           | 2 +-
>  drivers/crypto/sa2ul.c                       | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
