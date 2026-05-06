Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [144.76.133.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E194423A97;
	Wed,  6 May 2026 13:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778075786; cv=none; b=F9cI5JY5JI+IjU8ar4YxfRc45X9fTaTVKmrlmjcX3DsDsbvr2CsAGAjtO8FRJ6dAJqJSTT8Z1fgWwBhrcjkOYaiZmSTJVdofXVNVrepvd68SF0lvMtOV3AsPsIGDy9Ljjf6MqTOOP2siYKKpWlL6z8HjVTJg54WQlnS/g/Rj7Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778075786; c=relaxed/simple;
	bh=tVRq+BOljkBR2FdArjybyrrLwVriPvKB9FLHscCudQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fL4Y3148vNMb4YImEAgIi4EeHmSzJi/gvDG+V7wXZiFzZwXV9IN0yyjgYULL3KOD/scffDkfDDBynA1JtPCzMNcgMQHmLk/+kBPRQpvVnNQyU9gU7ZigIjBurjy/WSHpCIk5HSrphqf6NhWTXghV/cXZNMVry3OGkd1POZdZG/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=144.76.133.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id 2C9B6C99;
	Wed, 06 May 2026 15:56:23 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id EC83E6001EB0; Wed,  6 May 2026 15:56:22 +0200 (CEST)
Date: Wed, 6 May 2026 15:56:22 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
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
	Eric Biggers <ebiggers@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2] crypto: ecc - Unbreak the build on arm with
 CONFIG_KASAN_STACK=y
Message-ID: <aftIhnaK7RKCO6F7@wunner.de>
References: <7e3d64a53efb28740b32d1f934e78c10086208ab.1778073318.git.lukas@wunner.de>
 <aftFQUoLcQTgW_CO@ashevche-desk.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aftFQUoLcQTgW_CO@ashevche-desk.local>

On Wed, May 06, 2026 at 04:42:25PM +0300, Andy Shevchenko wrote:
> On Wed, May 06, 2026 at 03:27:49PM +0200, Lukas Wunner wrote:
> > A longterm solution is to refactor ecc.c for reduced stack usage.  It
> > currently performs ECC point multiplication with a Montgomery ladder
> > which uses co-Z (conjugate) addition to trade off memory for speed.
> > The algorithm is susceptible to timing attacks and needs to be replaced
> > with a constant time Montgomery ladder, which should consume less memory
> > and thus resolve the stack usage issue as a side effect.
[...]
> > +# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=124949
> 
> Perhaps also mention the algo change as that one sounds to me even more
> critical than this issue per se.

Hm, but it's already mentioned above in the commit message?
