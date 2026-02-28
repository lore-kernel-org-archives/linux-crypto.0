Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F951FBEB0;
	Sat, 28 Feb 2026 03:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772251092; cv=none; b=LE4fg5teryigwbEqHlFASiRPzhOxuPljsasj6RL6yvyU8i6+5dbT5QrhYf7mmxeMmR2H/bJcPm3fVcTYuL4sfd60D8o1xFJw/JmINgdcpTT4TbMc8eaq+9v91y+R68Hz9okVmWXutsR7csBJahZBZZsG1wca7lKrQq84HSOSKVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772251092; c=relaxed/simple;
	bh=v2kf1/1nYy8JzmeK1ZDAZsFUZiSFVGD8ySzIQHMF5E8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZxDvXbBXQuFEouB9s0UaEeXvCbqwSwaF4EiRsAqOzmTl9S3nNJ54eDP7JxumggGoAscO8i8O/dTDEA+XkUHCk9N09Yvu5ncrMKAEdYmBVFi2y45Sag9gTLrD4LBiEvP4+9kOWhGvDz+hLldhAvdbuQ70LLb44acAYmNmPmgw95E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=EllUQ1pC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="EllUQ1pC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=MapvXKIgZcSH6XYFwKqaVhakeATd/fTnbhprlqIbc4k=; 
	b=EllUQ1pCHHB2knPhwyo3vTP53eATzo0J2CcqJcrCg1S7vmcsuq9Oq8Q4R6dyM8eEJyPTiolfYIa
	gxKpCK1Ih7p6wx8o1mgYRioHxIKIwSAthLrBfKsDJi07wmhmOfoEA58FJ0SJu+nniIT026UCTR97Z
	LvfssKE98JX8hMsfwaC9YTSgnIFvZwy9AGTfmr1NLGfHIn20v8k6u5l8sdkKtrrCPM2QYwfcplgem
	6qES5I3iuwdShix/rji0k+tIdSd/wJdM5Ep2zPhSBasrqeFKjDFPGSUUets7gQyhU5iSdeRtyjh2N
	gEmf6iJNmvXFgo/oC4Be4Ql0GWfxiaOakJ4g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vwBSq-00ABj3-0d;
	Sat, 28 Feb 2026 11:58:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 28 Feb 2026 12:58:00 +0900
Date: Sat, 28 Feb 2026 12:58:00 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - Replace snprintf with strscpy in
 caam_hash_alloc
Message-ID: <aaJnyD05ye1mynMZ@gondor.apana.org.au>
References: <20260202230117.936865-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202230117.936865-2-thorsten.blum@linux.dev>

On Tue, Feb 03, 2026 at 12:01:17AM +0100, Thorsten Blum wrote:
> Replace snprintf("%s", ...) with the faster and more direct strscpy().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/caam/caamalg_qi2.c | 13 +++++--------
>  drivers/crypto/caam/caamhash.c    | 12 ++++--------
>  2 files changed, 9 insertions(+), 16 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
