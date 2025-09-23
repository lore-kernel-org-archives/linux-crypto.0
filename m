Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2551AD24;
	Tue, 23 Sep 2025 03:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758599259; cv=none; b=EKpPmwgea3ui8V1NUsQQGyQp8y8467oMATtPqc54WPomQttFNeuXoO/qtOQAt4bufV2M4bqr/RsBWssYwgQGWrpTyWMkmSwC9IKsd//a9ygHMDufNRHQwoaO5nvUeo4zBgF2hfIF6jONbBbvPwWsyJFWh8ENwStEJO3Al/am4Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758599259; c=relaxed/simple;
	bh=VhdoVNBgm6X5qYz6gn0vHAYfUBuCXLK7xB+54qTojnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a559vM/ARstNx625t4iMtCBIBKvMmaCzwxNjq7BuNBJzqWNFBWJhjMPw+0qWJTS9n8pVrP6L1Hy17nUEN2FbPh6TkZP28s5H+1xJYZvVavjCZaPYfw7qXmUVop9YpA8u8rQ5fHkQfX8e3GyLEb8LzWZa/I4f8tr9mB6NYAflvmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hq9SgPV1; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hq9SgPV1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=FGYTrCooQJBuf7my5KhHNwL4DZ/TWFdIhPLkYZYv7Q4=; b=hq9SgPV1CgQITcaGyUKSE7TfV/
	vEVwmNYT4PlcL2yDjL7pEypDWtmat2hfF5RJEJqcawdjlh268T6NCg7Vx/okBOgxYnWvIbIzftB7W
	dwX5wFiGirC7J6CGDmJtO4USoKi3K7oClz6Rw0dIUqjgHOu7Gvev3025bFtRDWsM0tKKEylsgVM8K
	Q2d9XoyJz9ISBi3laZE3eAXl9Cu3XcYIcJqCno/2P5+HuOdAmSkA/P7yXxqeTHWin2mmQz9SOlR/d
	00WyxQmnoEpYTVp1knrAe6rTvUW+hyd0s6KVUHGgoH/z2FiQk6FVlzsazmE5YW3GsPXv9gpsku9in
	RA6DV38w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v0tzy-007ZOl-1g;
	Tue, 23 Sep 2025 11:47:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 23 Sep 2025 11:47:26 +0800
Date: Tue, 23 Sep 2025 11:47:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>, linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com,
	linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
	agk@redhat.com, snitzer@kernel.org,
	Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] crypto/authenc: don't return -EBUSY when enqueuing the
 hash request
Message-ID: <aNIYTm6neC3lC6dP@gondor.apana.org.au>
References: <20250908131642.385445532@debian4.vm>
 <3a6b6f8f-5205-459c-810a-2425aae92fc8@linux.ibm.com>
 <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com>
 <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
 <8cb59ed5-1c9a-49de-beee-01eda52ad618@linux.ibm.com>
 <1af710ec-0f23-2522-d715-e683b9e557d8@redhat.com>
 <f799d7ab97470f2529b8dcb5566fd673@linux.ibm.com>
 <e26aedc6-7132-46c3-78f3-a3582b1c4f9a@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e26aedc6-7132-46c3-78f3-a3582b1c4f9a@redhat.com>

On Mon, Sep 22, 2025 at 09:08:42PM +0200, Mikulas Patocka wrote:
>
> When we return -EBUSY from encryption routines, the caller is supposed to
> sleep until it receives -EINPROGRESS in the callback method.
> 
> However when using authenc with asynchronous hash, the hash function may 
> return -EBUSY. In this case, the crypto API never calls the caller with 
> -EINPROGRESS and it causes deadlock in dm-crypt.
> 
> Fix this by turning -EBUSY into -EINPROGRESS.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org
> 
> ---
>  crypto/authenc.c |   10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/crypto/authenc.c
> ===================================================================
> --- linux-2.6.orig/crypto/authenc.c	2025-09-22 20:32:02.000000000 +0200
> +++ linux-2.6/crypto/authenc.c	2025-09-22 20:35:38.000000000 +0200
> @@ -146,8 +146,11 @@ static int crypto_authenc_genicv(struct
>  				   authenc_geniv_ahash_done, req);
>  
>  	err = crypto_ahash_digest(ahreq);
> -	if (err)
> +	if (err) {
> +		if (err == -EBUSY)
> +			err = -EINPROGRESS;
>  		return err;
> +	}

If authenc gets EBUSY from the ahash, then the ahash is responsible
for sending an EINPROGRESS notification.  I just checked the authenc
code and it does pass the notification back up to the caller (which
is dm-crypt).

So if EINPROGRESS is not being received, then it's a bug in the
ahash layer or the underlying ahash algorithm.

Which phmac implementation was this?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
