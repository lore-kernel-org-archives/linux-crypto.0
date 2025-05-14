Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3791F4281;
	Wed, 14 May 2025 05:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747199705; cv=none; b=V6GnFHFO/it3oflEws/x6N5WK3K0sjnERj/M+Iers39qSQkyPD+GJDtZsKjGE/Dz9GmGSTL9Qfb35qbuk9pWvEc68aavLVEpKStx1CyVeRADBNamALuTEESV/DsgnqzjXny0oxKVCcZFh2f1W9GLtuWSgBRc3oQ8W10rYhC9oAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747199705; c=relaxed/simple;
	bh=hoge9D2mSjKOtaJKv/jYyK3UIA1n2r6xt550GXehXV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Op/MCgXbVz5ddBPGc8tDDlOlE3kvQhQUo4lUbM+W0qAFoy6Mvq2FEp5aUbMpEWTNMmrWMhDYqz7/AVyKU+76X9QI5aoclB9YPro3OWWSj5fW+y/nBX9dXOhhuveZBqKvXqRLSBrDJ/RCF9tuV76KC5buuJOowVccLAHN85sumOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pJVxEwgY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pJVxEwgY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RXMQrcEfKqnWQN1+EdIIyggXXSvqo3Wi1fgUbQZ7v58=; b=pJVxEwgYcPOCg45zcY+i+eSo66
	tkKkLD1ittwSssNPhXHvCQfMAZ1zejqWqr8866rCvQmuU1VE4t24qvxCtU5M5gyiV9Eg9bLdyJh3Z
	d6cW7DB+Fl6uvH0kIwPPhCakyKf416JLFMN+3B15UH6RHqX1QlUEDj862PJYbpLQlsxGywaCk0Zrb
	sKfrZfq0eTDRcQcpw1h6dommgcGhH/19JhcOtABSPN6sGDn2P2eKcyTt+1VCFccQzibW7pgP3uNrr
	H+l4kuQ5j08Fu0vGbSrPr8rdvAMW3zJ6vIGFLA1K8NRG8oH+6LCiWHdA90lFVXE0fe7dXieBJD0FO
	5eZUm7kg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uF4SH-005x4H-2J;
	Wed, 14 May 2025 13:14:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 May 2025 13:14:57 +0800
Date: Wed, 14 May 2025 13:14:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
References: <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <dd55ba91a5aebce0e643cab5d57e4c87a006600f.camel@gmail.com>
 <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
 <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>
 <aB8t1ZTVBexqGlcm@gondor.apana.org.au>
 <dcb0b04e479d6f3cfed87795d100ea09e4fbcf53.camel@gmail.com>
 <aCAX8rj2ie4QMnTo@gondor.apana.org.au>
 <28184fb96e2de8a0af32816f5ff1b3d776b57217.camel@gmail.com>
 <aCMOyWVte4tw85_F@gondor.apana.org.au>
 <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>

On Wed, May 14, 2025 at 07:12:52AM +0200, Klaus Kudielka wrote:
>
> drivers/crypto/marvell/cesa/hash.c: In function ‘mv_cesa_ahash_complete’:
> drivers/crypto/marvell/cesa/hash.c:403:25: error: implicit declaration of function ‘HASH_FBREQ_ON_STACK’; did you mean ‘SHASH_DESC_ON_STACK’? [-Wimplicit-function-declaration]
>   403 |                         HASH_FBREQ_ON_STACK(fbreq, ahashreq);
>       |                         ^~~~~~~~~~~~~~~~~~~
>       |                         SHASH_DESC_ON_STACK
> drivers/crypto/marvell/cesa/hash.c:403:45: error: ‘fbreq’ undeclared (first use in this function)
>   403 |                         HASH_FBREQ_ON_STACK(fbreq, ahashreq);
>       |                                             ^~~~~
> drivers/crypto/marvell/cesa/hash.c:403:45: note: each undeclared identifier is reported only once for each function it appears in
> drivers/crypto/marvell/cesa/hash.c:405:25: error: implicit declaration of function ‘crypto_ahash_import_core’; did you mean ‘crypto_ahash_import’? [-Wimplicit-function-declaration]
>   405 |                         crypto_ahash_import_core(fbreq, &state);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~
>       |                         crypto_ahash_import
>   CC [M]  drivers/crypto/marvell/cesa/tdma.o
> drivers/crypto/marvell/cesa/hash.c:407:25: error: implicit declaration of function ‘crypto_ahash_export_core’; did you mean ‘crypto_ahash_export’? [-Wimplicit-function-declaration]
>   407 |                         crypto_ahash_export_core(fbreq, &state);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~
>       |                         crypto_ahash_export
> make[9]: *** [scripts/Makefile.build:203: drivers/crypto/marvell/cesa/hash.o] Error 1

Sorry, should've mentioned that this goes on top of the current
cryptodev tree:

https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/log/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
