Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F0E64CF9
	for <linux-crypto@vger.kernel.org>; Fri, 26 Jan 2024 09:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706260230; cv=none; b=qD/TpeIKfoEKDREumpWyNJ5lqyVNHmDpmTdEGVYRhsY2ZW3ChB8KiY6nGSrelDsQpGm1TpRJjOZQ1VpxxS3k1GItje6ok4hKhPQ/Yo1O41hQJnMT5btuS8KBoVJ8j0xlIYFnfWrZhyS/abG+OlauLyF0qUrucau3rpvOICOHuYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706260230; c=relaxed/simple;
	bh=Ufj/5fASrf5uZOKl+4u0QX+Su7BuF59lAmtDWy0Rb5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZNuUSfob+wFVDRJFr0dettGM6iOHTklfPxyWV18b+zyqZk0R5M9boHQ5j3fT3ztIn5UM5SOYkLbgHJODdlZjwBp+TTgStCoGwZErYPXY7EHr0ZifmrfvisfnHS69JeIXNLDFa2xcCqnPG8pIIpNuTfHjMUZDLUfCzQ+YQgpWjlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rTIEB-006F0D-7a; Fri, 26 Jan 2024 17:10:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Jan 2024 17:10:35 +0800
Date: Fri, 26 Jan 2024 17:10:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joachim Vandersmissen <git@jvdsn.com>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: remove unused xts4096 and xts512 algorithms from
 testmgr.c
Message-ID: <ZbN3C+1b5Lv5Xzjy@gondor.apana.org.au>
References: <20240121194526.344007-1-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240121194526.344007-1-git@jvdsn.com>

On Sun, Jan 21, 2024 at 01:45:26PM -0600, Joachim Vandersmissen wrote:
> Commit a93492cae30a ("crypto: ccree - remove data unit size support")
> removed support for the xts512 and xts4096 algorithms, but left them
> defined in testmgr.c. This patch removes those definitions.
> 
> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
> ---
>  crypto/testmgr.c | 8 --------
>  1 file changed, 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
