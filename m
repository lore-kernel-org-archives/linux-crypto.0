Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49943612FE;
	Fri,  6 Feb 2026 10:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375531; cv=none; b=bvoUxb9EUcC97LJwLjI0iAkynbXfF7LUXgIYgaSSZA8z5GTIeFZA0JcMNWUhyxqZ3UfFB0L0fZngHkg2PHFR/zjadh4cK38HZBUwUXukVt2czJts+RxblP57YdNuL5Sb4MJL70ek+RtwFQZKsuA8gfVILb7JqQVGp6mQ9JYVdKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375531; c=relaxed/simple;
	bh=qCgd+NGrc+WY7VNlDf02HQqWh0CoSFHBfITKM35Kglo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qRpTyHoPGGunWjVYQ5746TykHnv2i9xNxIgBEhTsqWg4XqGs8C3LGetss6qx2OYMCRiTNmNVHqC7X7MNkVWwVNeeudqqKt8qLfHKQ7aYI4rkQjrtggN2ZCwJjmCnIdcLq+E6/VixAQ1PxIS8DmOcCB7U3V3dLKYmnHropJWtUzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=f+sdyDzh; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="f+sdyDzh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=s6PtmROzd+O5nnBGS1z+1XPE++3x1xM/uYQ3FTegpig=; 
	b=f+sdyDzhPnXhAHbmjoz7F5jqlUJAHke1M4DzR5WLsbftfgrKV4QuLSEK26w+SyCV4KUMy5Fl0Es
	yCXTBOwWUuW6/Jc3hT7QM6I4mnmwE3ysXH5Yq2G6im6h2vdr/WT40lm1Qq/azWlc5wAak+JiquIba
	qeJxZFn0RSInlqt+26sORY+0I3Lh/oG46RrBxcRISjQ8DEndNtY7qWuuoY5Hz0O97KrB4rojwc3Mi
	LIJtMVBw6kNPSwqYValqPeF/6u0eGgRaX+uQ+DbTZBzXwXzzo4vBQhR8cOSQ+rF5sTMuNwBHBmSot
	TvHSuDJ6048W+3eadAbkYNhx3jF/UpIxy6KA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voJXj-004zUe-28;
	Fri, 06 Feb 2026 18:58:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 18:58:31 +0800
Date: Fri, 6 Feb 2026 18:58:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel - Use unregister_{aeads,ahashes,skciphers}
Message-ID: <aYXJV-XUwtAEXfz2@gondor.apana.org.au>
References: <20260126174704.237141-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126174704.237141-1-thorsten.blum@linux.dev>

On Mon, Jan 26, 2026 at 06:47:03PM +0100, Thorsten Blum wrote:
> Replace multiple for loops with calls to crypto_unregister_aeads(),
> crypto_unregister_ahashes(), and crypto_unregister_skciphers().
> 
> Remove the definition of atmel_tdes_unregister_algs() because it is
> equivalent to calling crypto_unregister_skciphers() directly, and the
> function parameter 'struct atmel_tdes_dev *' is unused anyway.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-aes.c  | 17 ++++++-----------
>  drivers/crypto/atmel-sha.c  | 27 ++++++++++-----------------
>  drivers/crypto/atmel-tdes.c | 25 ++++++-------------------
>  3 files changed, 22 insertions(+), 47 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
