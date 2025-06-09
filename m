Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B33250C06
	for <linux-crypto@vger.kernel.org>; Mon,  9 Jun 2025 09:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749462287; cv=none; b=jFBZeLJWSSsJOUA2dwmd4fnsoB4zvpGSMEciIUgstzFNYTROrRebJ3QhXaXO1Jzf9RuawyCcMLpWjKgTMXlZXmcP1HSl/NbCRboJN/nyFNFXt/QHiNas/q4+Ms6cG91Q9wM0nqp/vX+kDI9qEz6ETqBpNfe6RPhrKR77XvvWdH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749462287; c=relaxed/simple;
	bh=TMPxXdq4jGrDkb2Ozj2l4LteFXhWy8GLoIAeL8/2gGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJ7Tx/E7I9YpWGXvA7IHa6ptOmXJnN+tcoSwh6Lb9yI6TznlOjY0Ci3VmdA+M6nZu4dsmF/lvsroLB/5DMGkainhUUIJ4pKv4rkqYsbxie+WpVdM33WybiofbOXOKrJ3k0bx8GlGFsWPN/HxQFprMmA+DWk9SAoF2EesOG6FgTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JM/zNc8o; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JM/zNc8o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6tjAF87/TUBbCAABiMg31x0SGghFy1w7vyoG5xc+TYE=; b=JM/zNc8o+YapycOoA/atWMBfBn
	+VznbBpGgRmHsvuJbus1BQeI6H4Us4gflkcP29+69yO5+WnCLfbzwmrYvExAFqDKfPSkqlI3GUy29
	VRdKUuDDzqv+KlLBWjusGZf9XP5GatjJtVBESxComYO0M7xj9ijRbRir6/lFOQ1H/p5l7foyfv6Po
	JUSjYq39Hj3N8t97iXnm/S7OdHJQYJ2HFQK8ol5mS7cbCbvi4rYpOFOvTPxWF9sj+GdrTXFfzIPrT
	74BHGKhN8rWyrMunUvWmfgjnIQdQFeNw84gJnadNIwilEfCF94id9rz5pj6HLEUGBIPXNzt/ogF8Z
	3U+S4B5A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uOZ3W-00BlOT-1r;
	Mon, 09 Jun 2025 17:44:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 09 Jun 2025 17:44:38 +0800
Date: Mon, 9 Jun 2025 17:44:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@google.com>
Subject: Re: [v2 PATCH] Revert "crypto: run initcalls for generic
 implementations earlier"
Message-ID: <aEatBjcAmPr2Yrlg@gondor.apana.org.au>
References: <aBBoqm4u6ufapUXK@gondor.apana.org.au>
 <aBHcftWYX1Pe9Ogh@gondor.apana.org.au>
 <aEGp0MahOepfGpsm@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEGp0MahOepfGpsm@wunner.de>

On Thu, Jun 05, 2025 at 04:29:36PM +0200, Lukas Wunner wrote:
>
> I just wanted to provide a heads-up and an opportunity for early feedback
> to this patch.

Thanks for the heads up.

Ideally the PCI enumeration should happen later, but I could
certainly live with moving the required algorithms earlier.
 
> diff --git a/crypto/algboss.c b/crypto/algboss.c
> index 846f586..74517f2 100644
> --- a/crypto/algboss.c
> +++ b/crypto/algboss.c
> @@ -247,7 +247,7 @@ static void __exit cryptomgr_exit(void)
>  	BUG_ON(err);
>  }
>  
> -module_init(cryptomgr_init);
> +subsys_initcall(cryptomgr_init);

Shouldn't this be one earlier than subsys_initcall as otherwise
you're at the whim of linker ordering?

> diff --git a/crypto/sha256.c b/crypto/sha256.c
> index 4aeb213..a20c920 100644
> --- a/crypto/sha256.c
> +++ b/crypto/sha256.c
> @@ -264,7 +264,7 @@ static int __init crypto_sha256_mod_init(void)
>  		num_algs -= 2;
>  	return crypto_register_shashes(algs, ARRAY_SIZE(algs));
>  }
> -module_init(crypto_sha256_mod_init);
> +subsys_initcall(crypto_sha256_mod_init);

This also depends on lib/crypto/sha256 which would need to be moved
as well.  However, I think rather than moving lib/crypto/sha256 even
earlier, we should simply register the Crypto API sha256-arch later.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
