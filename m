Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAF215E81F
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 08:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715328191; cv=none; b=bwBBDW/nLNiddDxk9jwOSe+6pqmUK1IpjteCtoXkLP8j9TlKRcvvcRv4eHdLscw25XoTl2nHqEypeqtGoXrxz0NXXaVF9dVg0dfMtetVvs+TiDyzs0aP6poUM8Sm/N96SxSeMIFMb9jxOdnkIiiyHo2J40/IT/oJmyKicTPcrwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715328191; c=relaxed/simple;
	bh=SnrpAU33hM8+ADVnINYK9JcSNam7szLnDzahl0PuEOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivztWJ+C5AHRwCZOTpbXiB7zcfQ8P5eQ4nMy7YJHnJOFA4uCGOUNQBHCrHyffbDfVf/v2JA0/m+4SanyphBai+r0RlbxULWcMShYZ7hbetQCsVvddpsO9FsRGBkXv4x9hj+tISNdFrFOIVd8wr6VH8HJwtELiDfc9OXZYg8Rih8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s5LDa-00DHYg-1i;
	Fri, 10 May 2024 16:03:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 May 2024 16:03:03 +0800
Date: Fri, 10 May 2024 16:03:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v3 3/7] Add SPAcc ahash support
Message-ID: <Zj3Ut7ToXihFEDip@gondor.apana.org.au>
References: <20240426042544.3545690-1-pavitrakumarm@vayavyalabs.com>
 <20240426042544.3545690-4-pavitrakumarm@vayavyalabs.com>
 <ZjS8fQE5No1rDygF@gondor.apana.org.au>
 <CALxtO0m2wC3=yP5zE3_2nboVBVRVuhwuHx9Pdfj25wynky3E-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALxtO0m2wC3=yP5zE3_2nboVBVRVuhwuHx9Pdfj25wynky3E-A@mail.gmail.com>

On Tue, May 07, 2024 at 09:49:57AM +0530, Pavitrakumar Managutte wrote:
>
> About the export function, yes its hash state that's present inside
> "spacc_crypto_ctx".

Please show me exactly where the partial hash state is stored in the
request context because I couldn't find the spot.  It can't be in
spacc_crypto_ctx as that is the tfm context and shared by multiple
reqeusts.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
