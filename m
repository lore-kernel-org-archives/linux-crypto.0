Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [83.223.95.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9B92D7DEF;
	Sat,  2 May 2026 20:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777753100; cv=none; b=F2ZwMDCgkH+awq+TUxA2nobTpVX6me2zdbLHYGWGU0FHb2GgfIpIruMWTXIKtYct2l4WkPLCFNkQElbPnWmKHyepwnQ1mliKR26pyfeGMRf74/N3FLDq4DO5nBOFf8yxf0N16uuxGoC2lYa6uFGqLLZkTPwy5UxpyeLQlS4+tKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777753100; c=relaxed/simple;
	bh=Oc8JqvCsGcw3Cn8xm1DWHPB5ZvHWKHt4sXz5mP9fVDs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hxrd/7gcx7RsUU/9utYybCaAyEsLOmkkvO7Iqse3IIMg/QYHv1YFyCmDNg78bKn62YXxYiCXyMvbXb2fV2FqZvTsGSR8G5XivVSPzK8ElerpYrYhqRSm4xrsxz5Zzz8eutkRLw9pSalYRh/o0HFThG6v+/j9p5SMpgwuUN4Ega4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=83.223.95.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout1.hostsharing.net (Postfix) with ESMTPS id C9AF135F;
	Sat, 02 May 2026 22:08:12 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id B5841600D3A9; Sat,  2 May 2026 22:08:12 +0200 (CEST)
Date: Sat, 2 May 2026 22:08:12 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Vitaly Chikunov <vt@altlinux.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ecrdsa - fix unknown OID check in
 ecrdsa_param_curve
Message-ID: <afZZrCNmn3Bfwauf@wunner.de>
References: <20260502190903.252061-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260502190903.252061-3-thorsten.blum@linux.dev>

On Sat, May 02, 2026 at 09:09:04PM +0200, Thorsten Blum wrote:
> The ->curve_oid check in ecrdsa_param_curve() rejects the valid enum
> value 0 (OID_id_dsa_with_sha1), but look_up_OID() returns OID__NR on
> lookup failure. Compare ->curve_oid with OID__NR instead to ensure that
> only unknown OIDs return -EINVAL.
> 
> Fixes: 0d7a78643f69 ("crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Reviewed-by: Lukas Wunner <lukas@wunner.de>

> +++ b/crypto/ecrdsa.c
> @@ -145,7 +145,7 @@ int ecrdsa_param_curve(void *context, size_t hdrlen, unsigned char tag,
>  	struct ecrdsa_ctx *ctx = context;
>  
>  	ctx->curve_oid = look_up_OID(value, vlen);
> -	if (!ctx->curve_oid)
> +	if (ctx->curve_oid == OID__NR)
>  		return -EINVAL;
>  	ctx->curve = get_curve_by_oid(ctx->curve_oid);
>  	return 0;

This is a fairly harmless logic bug:  OID_id_dsa_with_sha1 is not
a valid curve and so get_curve_by_oid() returns NULL, which is
assigned to ctx->curve.

The function you're changing, ecrdsa_param_curve(), is called
from the ecrdsa_params ASN.1 parser, which is invoked from
ecrdsa_set_pub_key().  That function does perform a NULL pointer
check for ctx->curve right after the ASN.1 parser returns.

Your patch will change the return value for an unknown OID from
-ENOPKG to -EINVAL, but that probably doesn't matter much.

Thanks,

Lukas
