Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD4C2137F;
	Fri, 10 May 2024 08:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715329837; cv=none; b=eCUGslpPZGfN/q3EpXC+ISg5AX9FFYmFyyqBgxV3gD3us30xnFQ81Cug+xVE1ta35XK7GaXJRqVeCONVd6cJDxnq4QZU5G42wd6ugn0anWBVy1zBjY58vVRb1t1UkD6JZeertxnE40ezApCWT4UOK0XRAfMLmVOSj0VoQpnFKzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715329837; c=relaxed/simple;
	bh=Kzt8c8bnihz6U6KXC9c1nCKDLisYF9rz5Zj24nDYBxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXk6g7zREUpJfRsKOx9vAbt9o+1Pkn86C2qGoodbWtYMgePTHrRp1Ct1/W35H1+4wVlBhkgSj2K3lz8azazKH0IyxPeRezSTmYEFRp0g/n2q0Y3ObQupUIAZq7UV4iiiPsWJt4k5170kn/SF5ljjx6/QWPXbjUcSPhR3dRloQa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s5Ldt-00DI3R-29;
	Fri, 10 May 2024 16:30:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 May 2024 16:30:14 +0800
Date: Fri, 10 May 2024 16:30:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCHv3 00/19] zram: convert to custom compression API and
 allow algorithms tuning
Message-ID: <Zj3bFngCxSbO2I4a@gondor.apana.org.au>
References: <20240508074223.652784-1-senozhatsky@chromium.org>
 <ZjzFB2CzCh1NKlfw@infradead.org>
 <20240510051509.GI8623@google.com>
 <Zj3PXKcpqUPuFJRu@gondor.apana.org.au>
 <20240510080827.GB950946@google.com>
 <Zj3W7OK9kDpneKXR@gondor.apana.org.au>
 <20240510082850.GC950946@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240510082850.GC950946@google.com>

On Fri, May 10, 2024 at 05:28:50PM +0900, Sergey Senozhatsky wrote:
>
> OK.  I guess for drivers' params support (dictionaries handling etc.)
> we take take some code from this series.  You mentioned acomp, does this
> mean setparam is for async compression only?

It would be for both acomp and scomp.  I have no intention to
add it to the legacy comp interface.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
