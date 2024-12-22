Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024F7A35;
	Sun, 22 Dec 2024 11:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734868498; cv=none; b=m2DePP8tnbnDZxJ2MU5svo5B7H5N+TgPbWtlpQkLZ9OBCr7u7qzL8thOQlyGeKWMH5HKZqdMoSTudpNfFtpHsX/pyRXhlQcClOW9Knxx2qsLQqtfACdxRDoKUU5gEdjB+wEApYRJNNRY5APXhamHvQ3x5pu1pg0nxTXzek3zIHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734868498; c=relaxed/simple;
	bh=aCoYV99pE0D5Yw9axAGRa1j+CW6YXXVZzSiuO2y/FNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DudATxNkl3kV0YauPhC3RuR4uYeHHi4l+iOlum7a9vXVx5LrZcVv0gAGmHqKdVX+J5gOM2ipp3yxiZaSPjuo0PmVqRXoon4tM5MySY9bhNzuknuVd2bGakeDZVnfMdjZOANEgtJr0iyXclCUTN0H1bok4KDWOZHZTZQxFgOPmtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=ng86LOI9; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="ng86LOI9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=ZUjZGx9oXcpKGtsUtrPyuB4/soGn0+H0/gGEY2JZYk8=; b=ng86LOI9eVYWbWTw
	WbU9ZQwr6I+Vdb30ghhQ5X/cE3JshUkmbBhd0GcJtpIBOGgRG0kUwS4n7Wkdtk28jPUSwDHbtowCW
	sXt57B8nrkIhN3dMaLnKwL7ObxeAvs41rYyccvMHa6PzrS+WM3O4dTiIHY0BpM2uEgRL14X0yJWWX
	dDbIEb1QqB5pVFRJXSvdjbOHQp8ynJG5b28FPbu4YBvympLGM9nGREpVjL1iZIFvsIWBoWLMuoh6P
	IKsZUM38u3o0IEQHfx0RQb7ZUqQMOuHG9OXmzYUeMb4FwPTKqBgdEOUhbSxhPmdBDxqERHH3G4+WP
	/bsjmcuBGfk9OHkscw==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1tPKXp-006kVF-2m;
	Sun, 22 Dec 2024 11:54:49 +0000
Date: Sun, 22 Dec 2024 11:54:49 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/gf128mul - Remove some bbe deadcode
Message-ID: <Z2f-CXgNGkstB4ds@gallifrey>
References: <20241211220218.129099-1-linux@treblig.org>
 <Z2eTGr3l-Zu_Tgi3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <Z2eTGr3l-Zu_Tgi3@gondor.apana.org.au>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 11:54:06 up 227 days, 23:08,  1 user,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Wed, Dec 11, 2024 at 10:02:18PM +0000, linux@treblig.org wrote:
> > From: "Dr. David Alan Gilbert" <linux@treblig.org>
> >=20
> > gf128mul_4k_bbe(), gf128mul_bbe() and gf128mul_init_4k_bbe()
> > are part of the library originally added in 2006 by
> > commit c494e0705d67 ("[CRYPTO] lib: table driven multiplications in
> > GF(2^128)")
> >=20
> > but have never been used.
> >=20
> > Remove them.
> > (BBE is Big endian Byte/Big endian bits
> > Note the 64k table version is used and I've left that in)
> >=20
> > Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> > ---
> >  include/crypto/gf128mul.h |  6 +---
> >  lib/crypto/gf128mul.c     | 75 ---------------------------------------
> >  2 files changed, 1 insertion(+), 80 deletions(-)
>=20
> Patch applied.  Thanks.

Thanks!  I'd appreciate if you could also look back at one
=66rom September:
  async_xor: Remove unused 'async_xor_val'
  Message ID: 20240929132148.44792-1-linux@treblig.org

Thanks again,

Dave

> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>=20
--=20
 -----Open up your eyes, open up your mind, open up your code -------  =20
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \=20
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
