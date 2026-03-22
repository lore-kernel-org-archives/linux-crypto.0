Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFE340DFBE;
	Sun, 22 Mar 2026 02:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774145980; cv=none; b=jq7LBX+a5XkTdxFO2TiypMe3otXP/gV/19KtN7/l3gEiphf6RdiSuwIBjF22zfLhbgCuTC4lXTxFFTcqRc3Kvh8NnwkGBeSSWAJzHAdVr8QLUQRcBzExmLdfg43yJQ8yjIIF/zb2rSyYnfn0Um9xu9CN09JnOY4SeQyKkQ6J+m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774145980; c=relaxed/simple;
	bh=Y9FRz5h5YmEd63G1rR3QNbOwA7tCiqvFTD5pAThVUfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O2OA3qaremcCR7UbJ7EiCYUC6Ao5AYIXul/CmS4FlEmNa2FeFuVdSqBaqyg7S5wvTNsJ2RDi7EMT45qEL8p2OqBaI6ZWdXcRxPpXsOBO8xC7271tVWoVlyjRKnN+KWbtyvG/8dJK79gphYvfdrK0V7YZqFF8GTFaVsWBw0WyjdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=c3ceLe6v; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="c3ceLe6v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Jpa0L6dM/gHFuGcVJmFRR50dCokLJlK9AOT7wXIiP8A=; 
	b=c3ceLe6vYD0WgtfFQSKvWXSZbMSMM3MHtAH/vwXnXfTirEwsH6O41wwl6pq89DgcGhgsIH0edxU
	P0MDYurnk/0G7TUUQ6Qfj3JbVpVeR29BksQzxJ9lGniF9cFaFpfd2z+3qejmN/dXIxUpTBTi10N5q
	HCNpmXPA7VC0L05xAqTVlAA+ipI7yfsjNVXO+K27btmTOnIdqP/CyMKNm1xlrT/VXY1BRZY/1XkQN
	9Z9jcz1xr9R4quUVhF2u6T9v58syU8n5YQKhPW3PsOQDPh45vzDET9vFKp7I2qcoiBgXT3Vlnv9PO
	3PTxvoyCj0vP9PMXGkt5V5p7MTTC1D9YGQpQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w48PW-00GSPc-26;
	Sun, 22 Mar 2026 10:19:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 22 Mar 2026 11:19:26 +0900
Date: Sun, 22 Mar 2026 11:19:26 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: Ignat Korchagin <ignat@cloudflare.com>, akpm@linux-foundation.org,
	dhowells@redhat.com, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	ignat@linux.win
Subject: Re: [PATCH] MAINTAINERS: update email address for Ignat Korchagin
Message-ID: <ab9RrsZmvPLC3dew@gondor.apana.org.au>
References: <20260309173445.71393-1-ignat@cloudflare.com>
 <ab5ajEP3OL-3RLCr@gondor.apana.org.au>
 <ab7041i5NKEH0Uvp@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab7041i5NKEH0Uvp@wunner.de>

On Sat, Mar 21, 2026 at 08:43:31PM +0100, Lukas Wunner wrote:
>
> Andrew already applied it and forwarded it to Linus.
> This is now commit 182b9b3d8d1d in Linus' tree.

Thanks, I've backed it out again.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
