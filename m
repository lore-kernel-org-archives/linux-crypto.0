Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032512CCC6;
	Fri,  2 Oct 2026 10:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790935831; cv=none; b=Tzi34+eYYs+M3K0Ero722NonMZ8weXu8sEQLxzJN7gvx5Gc9hLHopO0/57S6PWJMThscQctAK7bjf80w+aYAxWmJgPt6znfLl/QqBWoeAXwyo1/0jAQZR7Gx02wjSDPZ5ICv1jYqlTV45szh+d7OuFcc8xUE41MFtSDJdjiIh5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790935831; c=relaxed/simple;
	bh=GHCrpkg472bq3Pz0bi/rDsiOVXd3mpN4m8zXgQSnHUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A/XyPMOk1Ij81m48IpUq0xXGFpMyYWY8p03o++5OEM5X0na9e+iinvKq76GJwt+GVZt7bUZibAUJ/hZjUqf5kuyseXX8gPJSDnbp+b+K4UufGjTbNp7LobdAWwlU+vUoq7QEi/eBDp47cygElyt6W+kNAImegTnkWQyzFGTcKUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=d+yR/nem; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="d+yR/nem"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=LeOlpBZnPK62BI76C0n6ASQt4MKFPfhCkee5/3Jb1zY=; 
	b=d+yR/nemGoEpzmeIgQFwwvWbzEj6tv7fqyEBCASq2IHBytt62/WMhiHl0tjCUa1MEL00pMRM6Pv
	vq42lW8/G65KMW5eMx5U5tJnQ4Quw02dgn0hM+NldTrJHGNDjxxbiqiCii2/URJx1tH44ArRxlnhe
	xLJ3ERGLUhcrXusU4tG1lnAhrTmIsCsg1qIeMnkIxcsJvq2h6PEQz5wHxW+5PDCPe61PdotVR6P2X
	3q1VEsQwIhBVp8BBB14VrUThoLm+c3fMzvdk/y0kNCzywgLY/fCsq5LAeBfFRAMiIsXm9g92XgxPm
	+v5flWq8TWx+8/OhxTUj9rCi/jf339OxAT9w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCaDb-000000001gu-1WDd;
	Fri, 02 Oct 2026 18:10:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 20:10:19 +1000
Date: Fri, 2 Oct 2026 20:10:19 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: ZhaoJinming <zhaojinming@uniontech.com>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S . Miller" <davem@davemloft.net>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Radu Alexe <radu.alexe@nxp.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: caam - fix double-free in
 caam_rsa_set_priv_key_form()
Message-ID: <ar-DCzGGyqB7cxm9@gondor.apana.org.au>
References: <FF2F0DC4D3930E6A+20260923101457.204629-1-zhaojinming@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FF2F0DC4D3930E6A+20260923101457.204629-1-zhaojinming@uniontech.com>

On Wed, Sep 23, 2026 at 06:14:57PM +0800, ZhaoJinming wrote:
> caam_rsa_set_priv_key_form() frees the partially allocated key
> components (p, q, tmp1, tmp2, dp, dq) with kfree_sensitive() on its
> error path, but does not set those pointers to NULL afterward.
> 
> When the function returns an error, caam_rsa_set_priv_key() jumps to
> its err label and calls caam_rsa_free_key(), which frees all of those
> same pointers again, resulting in a double-free.
> 
> This is reachable when the allocation of q, tmp1, tmp2, dp, dq or qinv
> fails, e.g. under memory pressure, or for a malformed key whose CRT
> members decode to zero length and make caam_read_rsa_crt() return NULL.
> 
> Set each pointer to NULL right after freeing it so that the subsequent
> caam_rsa_free_key() call becomes a no-op for the already-freed fields.
> 
> Fixes: 52e26d77b8b3 ("crypto: caam - add support for RSA key form 2")
> Cc: stable@vger.kernel.org
> Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
> ---
>  drivers/crypto/caam/caampkc.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
