Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB233368A0;
	Thu,  7 May 2026 08:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778141492; cv=none; b=tnbNitcYBrlGpeTwjWfUL2BJFfdwbKpNkQWas9eOt4dJibSAyrgTKrasAvKSAgWw4CJ+KT+hK+AEMqsPo1L4a7/S06YX7U0H6JDl4g8QWnA24mbuJmocHC75NvvhyNi55wAzRmCGk/F1wo9wy6O4PBQOXA6uigCmAChT+jWalV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778141492; c=relaxed/simple;
	bh=LJXzJLslmiA+IdxAQYdNVM8kdYvI7bAUo2IuKVryaZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LkAJfA5fhSwSwxobduvFniNANX7MbzKgcNkLMAgRfYhOf4OjLH9F1ta3G0J0PMjwUlMxEodDNMLeLN3+Jsg7TXyYeK2uqwhYoN2L4kO7KeHMUNzhVOfty3WC6WFk57pXo7AMo6ZOFuXGda2qW5wmzTTTC4WqtzFoLagmHAkknaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ejD0edD0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ejD0edD0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4ZnC8Ta9QoHgs1aqP+fxojktVLYVG6sApCSeqyX6nR8=; 
	b=ejD0edD00oFdsLjY0Gfbk3ayxsAyNtAkZVJJsccgqIm9fPi3ubCEb+guqliWX1owUgAv00FWOGU
	WnMI1LsenQ7t7S59WBBhxD/3bfncFJ9NhOvfqOk248NvcEpMXp+PPuI9q/h+9DfpiJcQcnYSZl1h0
	14V6/fq/D/igDwCjsLcyR0e5XgNYofCiT5/cU5rGLgagU9O5JU/aU86eoN4eMUSpqxAPiYLjwgx1S
	McJFIcrX00SGhYf+Rz7uoCpgSAa1jXjkICWLH231qmaSM9iDux+AbALUqWFuEL1A3fLqndYg85KQy
	XvNdvEjY7cLswKmWHX7SFkyJs+G0le0LBcmA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKtoz-00C0tD-13;
	Thu, 07 May 2026 16:11:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 07 May 2026 16:11:01 +0800
Date: Thu, 7 May 2026 16:11:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] crypto: ecc - Unbreak the build on arm with
 CONFIG_KASAN_STACK=y
Message-ID: <afxJFVww58btgxIS@gondor.apana.org.au>
References: <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>
 <afms-fn-mpwJPfa-@gondor.apana.org.au>
 <aftFAexDFrYbIeBM@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aftFAexDFrYbIeBM@wunner.de>

On Wed, May 06, 2026 at 03:41:21PM +0200, Lukas Wunner wrote:
>
> My apologies Herbert, I was working on a v2 for this patch
> but unfortunately didn't finish it until today:
> 
> https://lore.kernel.org/r/7e3d64a53efb28740b32d1f934e78c10086208ab.1778073318.git.lukas@wunner.de/
> 
> Would it be possible for you to replace the patch you've already applied
> with the new one?  I am very sorry for the hassle.

OK I've backed it out for now.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
