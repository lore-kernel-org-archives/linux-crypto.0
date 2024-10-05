Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D1C28FC;
	Sat,  5 Oct 2024 05:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106296; cv=none; b=dVZtNeJDEBj3JbZ+zW6l8c6XGLVouo8q79l3y39y+FBVLRDFd8/c14UKinEyg6nL8c1PzhN8Sue1kyZn4cRjGC7B1otgw9eQvJgd3Gg+EFwRpuM16AcYTOFvbhDlN2YV9ql9iiCqUkK6lZLMuwqjjLOSEXLWGgtPEpEmtoRpPmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106296; c=relaxed/simple;
	bh=KsAFsSTSMV42EfR9nMQo8boCPaEMPU2fH1ZBipC20tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L7grwkUg0/GgLJlpB1mVHKi3UtwEoogvgUGj8ju+/F1XqT1khnmr/CwQbzMHUM9ABikMrA6qjThNTkcal/V8h4upWwoo4nV0OszbIoM/Gzd8v8k4ZW77uuQEQGF2Szwwk0zzpFUHd2X5VvbNwY/X9/DjiDoY2Rwn6egQBx0hrc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pbCmpuAJ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pbCmpuAJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vpmdv8NIiwnxO0d809lST7yc6i8sKw7fBZZnL0/TIQY=; b=pbCmpuAJ1eYWQYBpMH6JHvQVZO
	WUxXDfMnu+P5NSsoMoqBIO1+X8sYmCx1KzXzDIVlTw1MAwXHP48Mt932C1IytJXOAj5MSWvfBxSOp
	Cp8kqfwuiEdJCSV+dtdWduMwis5tayRicfyg0Jd99Uk582I5bp7WOZu83QTS+2NRqZILU+zaC4J+f
	6SwV+CbevOzm7AF4MPtJuXV3mbwDVhCIvenJweMOYVqgL6ho1pjG/VTxnE6K4CrB2Z5oIK0Z+X2R/
	UEJA6IsXHX6Ym+4of4Dnh9WnoJMOR1Z/Tq4aSuxrUKwxs+2tB7xtVd8KkUpENZF6IlSxc3wcglsZB
	HbFMP8fg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxE9-0071Vu-1c;
	Sat, 05 Oct 2024 13:31:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:31:27 +0800
Date: Sat, 5 Oct 2024 13:31:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Qianqiang Liu <qianqiang.liu@163.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/mpi - Fix an "Uninitialized scalar variable"
 issue
Message-ID: <ZwDPLzchPuopuAZK@gondor.apana.org.au>
References: <20240913140741.5944-1-qianqiang.liu@163.com>
 <ZuTeivSjXN_uP-dZ@iZbp1asjb3cy8ks0srf007Z>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuTeivSjXN_uP-dZ@iZbp1asjb3cy8ks0srf007Z>

On Sat, Sep 14, 2024 at 08:53:30AM +0800, Qianqiang Liu wrote:
> On Fri, Sep 13, 2024 at 10:07:42PM +0800, Qianqiang Liu wrote:
> > The "err" variable may be returned without an initialized value.
> > 
> > Fixes: 8e3a67f2de87 ("crypto: lib/mpi - Add error checks to extension")
> > Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
> > ---
> >  lib/crypto/mpi/mpi-mul.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/lib/crypto/mpi/mpi-mul.c b/lib/crypto/mpi/mpi-mul.c
> > index 892a246216b9..7e6ff1ce3e9b 100644
> > --- a/lib/crypto/mpi/mpi-mul.c
> > +++ b/lib/crypto/mpi/mpi-mul.c
> > @@ -21,7 +21,7 @@ int mpi_mul(MPI w, MPI u, MPI v)
> >  	int usign, vsign, sign_product;
> >  	int assign_wp = 0;
> >  	mpi_ptr_t tmp_limb = NULL;
> > -	int err;
> > +	int err = 0;
> >  
> >  	if (u->nlimbs < v->nlimbs) {
> >  		/* Swap U and V. */
> > -- 
> > 2.34.1
> 
> Could you please review this patch?

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
