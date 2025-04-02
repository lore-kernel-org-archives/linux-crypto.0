Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA87233D72;
	Wed,  2 Apr 2025 08:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743582149; cv=none; b=TQ0FjOs2UzWphLxd8rXqvJXQ9lWTU4Up7wvO0exu5ub6woNYCO2BBe5UNidMmMIDrUdlqeNyVPej7WpdLEkfAsDYIgDihp2gOScWILLLojJ64caLEH4+N6iVBJ5RguX/dryraHWCSmtdy1IySXjLmFUPIeBypc3fZTJ79yW3ZgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743582149; c=relaxed/simple;
	bh=YTuNCC3dzXvhWv3tOYifX7JQa2j82JyQXJk6Kj0R96Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pM3v0/sm7qWnG5DHqv/3/2TlDc0M2v+AGq/XQJIBlVoL/8tZd+ALxm2hh3xBiFKk7RcyE5SIDkhwrI+XdpKyh+q8N6bM0D+XZQooYvzARSrTW4iM7YJXPMUQarBTJ9Uiveysz7m2iPtdaS78oDLeJgLayDLbZlkE4zIMLIJol88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GFnQsJ+e; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GFnQsJ+e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aT8K0h3pG+xcT+gsG2ninLrWocsNCdfYUpJ4jZt+NXE=; b=GFnQsJ+eDCdu7/SnS+ZisJ2fQg
	t3EPgKobSwi6a+6hBjr1eHiQzmtd6AOb0LQnHlRGSL/DjUxhTjNeTBlXvZySu5VNqQTxIDiL7EobH
	+V6cKwGJiSx+gPlvieTuTmoIjp3FKa5rGROj2NzTuuqj8nwvCky7a7OaPYmKyY336Vdq0LQDLQmi0
	grvgGVGgpTcLZpja9hn4VjFqFtfiV9WxuFr/vRBVTGVxIqEyEPKYCQ3Sv+y3rh6zf6DVb8GLJGow9
	3M1L2P0AC1UrW84LvTL4gj7EeGPjXBhewC3NwtO9UI/ffS6saOECDS0fqPDzOmecT/ksZ+vbTncJF
	xtINxV0A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tztMb-00C4Dl-2S;
	Wed, 02 Apr 2025 16:22:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Apr 2025 16:22:21 +0800
Date: Wed, 2 Apr 2025 16:22:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2 0/9] crypto: x86 - stop using the SIMD helper
Message-ID: <Z-zzvXbjt3xzquXb@gondor.apana.org.au>
References: <20250402002420.89233-1-ebiggers@kernel.org>
 <Z-yrf_9D2rV1Q136@gondor.apana.org.au>
 <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
 <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>

On Wed, Apr 02, 2025 at 09:34:30AM +0300, Ard Biesheuvel wrote:
>
> Ah, never mind - I see some calls on 32-bit ARM to
> simd_skcipher_create_compat(), which have become redundant now that
> SIMD is guaranteed to be available in softirq context.

Thanks!

We could also remove all the calls to crypto_simd_usable in the
Crypto API hashing code, e.g., arch/arm64/crypto/sha1-ce-glue.c.

For the lib/crypto code I think we should make it a rule to
not allow any hardirq usage just like the Crypto API.  Does
anyone know of any uses of lib/crypto in a hardirq?

I thought /dev/random might do that but it looks like Jason has
fixed it so that crypto code is no longer used in hardirqs:

commit e3e33fc2ea7fcefd0d761db9d6219f83b4248f5c
Author: Jason A. Donenfeld <Jason@zx2c4.com>
Date:   Fri May 6 18:30:51 2022 +0200

    random: do not use input pool from hard IRQs

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
