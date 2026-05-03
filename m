Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1225033D6CA;
	Sun,  3 May 2026 11:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777808868; cv=none; b=jZN74ntohEZhfBOw8hm2SNCfy0lne7LgiB2aM4QA6CSYA05iRxAEE4rknqkB7qrkBxpurPru2KC8y1vAvQC7nyhWqgiL/lJ7bmdbSOZUOA58g1X9lTOwZK4uRTPmJDWoxHaf810hubNgrO7te0kmSJG151M7E6Wffnce3oUbhB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777808868; c=relaxed/simple;
	bh=rv3piyylOxMcflHWhUtcmhjY5a7/4TpSe6S7aBCBSAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tSzLSMYovaUnkqbORosS7acCp3jw1uuFsbz/yJhVTZkc/TwQjPgcX/Ch9V/OgZXSI8ZOCvBNS7WakqanBHGo5HN5lfh2dzri1jiQJscsm8UKZzD7zdz3Xm3/16Eyss3SVq2f6KwiI/ZwfWpAcUNV0tttocx9ATbCFd8i0MKgXzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id A88DE72C8CC;
	Sun,  3 May 2026 14:38:18 +0300 (MSK)
Received: from altlinux.org (unknown [193.43.10.9])
	by imap.altlinux.org (Postfix) with ESMTPSA id 9896336D0184;
	Sun,  3 May 2026 14:38:18 +0300 (MSK)
Date: Sun, 3 May 2026 14:38:18 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Lukas Wunner <lukas@wunner.de>
Cc: Thorsten Blum <thorsten.blum@linux.dev>, 
	Ignat Korchagin <ignat@linux.win>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ecrdsa - fix unknown OID check in
 ecrdsa_param_curve
Message-ID: <afcyXvjpYxwz4AjS@altlinux.org>
References: <20260502190903.252061-3-thorsten.blum@linux.dev>
 <afZZrCNmn3Bfwauf@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <afZZrCNmn3Bfwauf@wunner.de>

Lukas,

On Sat, May 02, 2026 at 10:08:12PM +0200, Lukas Wunner wrote:
> On Sat, May 02, 2026 at 09:09:04PM +0200, Thorsten Blum wrote:
> > The ->curve_oid check in ecrdsa_param_curve() rejects the valid enum
> > value 0 (OID_id_dsa_with_sha1), but look_up_OID() returns OID__NR on
> > lookup failure. Compare ->curve_oid with OID__NR instead to ensure that
> > only unknown OIDs return -EINVAL.
> > 
> > Fixes: 0d7a78643f69 ("crypto: ecrdsa - add EC-RDSA (GOST 34.10) algorithm")
> > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> 
> Reviewed-by: Lukas Wunner <lukas@wunner.de>
> 
> > +++ b/crypto/ecrdsa.c
> > @@ -145,7 +145,7 @@ int ecrdsa_param_curve(void *context, size_t hdrlen, unsigned char tag,
> >  	struct ecrdsa_ctx *ctx = context;
> >  
> >  	ctx->curve_oid = look_up_OID(value, vlen);
> > -	if (!ctx->curve_oid)
> > +	if (ctx->curve_oid == OID__NR)
> >  		return -EINVAL;
> >  	ctx->curve = get_curve_by_oid(ctx->curve_oid);
> >  	return 0;
> 
> This is a fairly harmless logic bug:  OID_id_dsa_with_sha1 is not
> a valid curve and so get_curve_by_oid() returns NULL, which is
> assigned to ctx->curve.
> 
> The function you're changing, ecrdsa_param_curve(), is called
> from the ecrdsa_params ASN.1 parser, which is invoked from
> ecrdsa_set_pub_key().  That function does perform a NULL pointer
> check for ctx->curve right after the ASN.1 parser returns.
> 
> Your patch will change the return value for an unknown OID from
> -ENOPKG to -EINVAL, but that probably doesn't matter much.

Great review, thanks. Basically, the check is redundant.

Reviewed-by: Vitaly Chikunov <vt@altlinux.org>

Thanks,


> 
> Thanks,
> 
> Lukas
