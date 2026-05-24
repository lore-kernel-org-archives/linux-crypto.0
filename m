Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07EE23909C
	for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 07:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779606631; cv=none; b=E/FCqTsKQUWwD1W7QmL8La32GEQwPZVsP/7cP1cPDGZ7HvFzVPZ+nTLOnwGwD0xzuyIAQjsI2Ki1yEvcLGRg06Ihe8Bb2OjBwghDctvNu7hLXMZOWHqVadj7cxS853qqTN4PMZuwweuI3Ivx9/SYqzaLFBZeWV1/iA+hZxdvXD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779606631; c=relaxed/simple;
	bh=CadOtTPs2huEqFzY459tuJVru51zfMqNKXGJL2Gub1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DpCShZlbDhfN7xic00zqhIgn3GIkVZJc9fBUTC9Irp3ZH4NjNtDm6PgwsdzNv/fONAkoDIUW/xGYvgA+fZIMCV4ASAscY+XfxArTjxoR7pohOnxitgO/mCrb8WL47wlkMBx5CJP6j3q6pAddjm86xGs7wCd7dvHENct9yk/9y+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-45d96d21e82so4772544f8f.0
        for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 00:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779606628; x=1780211428;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xlYkz6g3wbQ9IFHWyxO5Z4osnU5OrF8poVvRpYxaIgg=;
        b=d8kFatP1JyPc/f1uEtyg/fNJjVTqIXb1m4R9s+x7OPY9nb5+e2ImfHmRF3q1NtTfni
         hezRrO/XehWY6USE8r9zeH94r9Cr57FOU84qn9jeHalLF37/K8eE3i6b1W2LqAR4A2m+
         bbnap0f6Tv0l9CNM+qqLqV40Kr3Co09xFzNypvaEh12f3xFRiqDBoNyUi3kJzgw0e/AZ
         8+PsNRf6sx2sLCdi0fge6MPLfubJCVF2EPjTdK7omB4wJnoq4mJaL7Z+0O6ajxEltANO
         I81PVW5ERrciur8HyLqyrbno1765kR313zHXWK9qKpNKQsXJb3SuYejmbgnjjaroy328
         4XGQ==
X-Forwarded-Encrypted: i=1; AFNElJ8POz4lq6cr0Q0rG+xuR88q7Y/Loxj8SUXclUOfw3xdLD1PJ5YCYTUCYsORdwLTo9u7LBImaUQj0RdvUyc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgFfwI1sZUCANuCMyEimgIiPhdcgzgQKXvKLqomekeoFLxiGTo
	keEwrpIpKGj7bHQJo+68uvDji0eGOv+ntJv2w10rxh51MiH9Ml5ANff+
X-Gm-Gg: Acq92OE0/1EcnPQ6KfB7gEuPDpGQZID2OOtuU8x25vuXNVmF9o8rIhJTWou6IBLIJAF
	+J/DP1tLzVlyWNbS/60UPgRjbhwkcOqesTCVQ0cLayF+7kj3MgWnUEnAdFJew/VIqab/Ft7e+LI
	EpdIbXN3jMIED1uIncSIl4uD5ZO8IHcIegO92RFSAZpWkyUeYQS4GPDNaD/UoTEEn2KgEMyuSuX
	VPjqM/45ZAQ9rOuKywnqN5cdag+Sz7HGZkh+y2YrZEWGxRBaXspVY1SF3CBgYxAxVjBW8MMmdU8
	pKU7cNiHE98HWf+l40JTAaP3PpWKAefU4jdZRkIDq4YTHXxxrcSj1WLmz65sCChq+JyeZwB1elw
	ybMZ9sEMV/3m8A8c7k6bg8OiyDIGCAEAAtp938bjPSRLHvn1hOcgh2hCWztCsuRnn0Rvvd3Bx5N
	cr+oJmLwU4tXzojqzDqqERttUU8QRPy4Y=
X-Received: by 2002:a05:6000:4b12:b0:43d:7e34:889c with SMTP id ffacd0b85a97d-45eb38b5a04mr16209425f8f.39.1779606627897;
        Sun, 24 May 2026 00:10:27 -0700 (PDT)
Received: from gmail.com ([62.197.47.167])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6c9ba2esm18077988f8f.8.2026.05.24.00.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 00:10:27 -0700 (PDT)
Date: Sun, 24 May 2026 08:10:26 +0100
From: Breno Leitao <leitao@debian.org>
To: Sam James <sam@gentoo.org>
Cc: Nayna Jain <nayna@linux.ibm.com>, 
	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@google.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Calvin Buckley <calvin@cmpct.info>, Brad Spengler <brad.spengler@opensrcsec.com>, 
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: nx: fix nx_crypto_ctx_exit argument
Message-ID: <ahKkTuPAf7UsU1Hx@gmail.com>
References: <a3e89c1e8342ffa415b0d29725a0571a4f355d34.1779472902.git.sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3e89c1e8342ffa415b0d29725a0571a4f355d34.1779472902.git.sam@gentoo.org>

On Fri, May 22, 2026 at 07:01:42PM +0000, Sam James wrote:
> nx_crypto_ctx_shash_exit calls nx_crypto_ctx_exit with crypto_shash_ctx(...)
> but crypto_shash_ctx gives a nx_crypto_ctx *, not a crypto_tfm *.
> 
> Fix the type in nx_crypto_ctx_exit and drop the bogus crypto_tfm_ctx
> call.
> 
> This fixes the following oops:
> 
>   BUG: Unable to handle kernel data access at 0xc0403effffffffc8
>   Faulting instruction address: 0xc000000000396cb4
>   Oops: Kernel access of bad area, sig: 11 [#15]
>   Call Trace:
>    nx_crypto_ctx_shash_exit+0x24/0x60
>    crypto_shash_exit_tfm+0x28/0x40
>    crypto_destroy_tfm+0x98/0x140
>    crypto_exit_ahash_using_shash+0x20/0x40
>    crypto_destroy_tfm+0x98/0x140
>    hash_release+0x1c/0x30
>    alg_sock_destruct+0x38/0x60
>    __sk_destruct+0x48/0x2b0
>    af_alg_release+0x58/0xb0
>    __sock_release+0x68/0x150
>    sock_close+0x20/0x40
>    __fput+0x110/0x3a0
>    sys_close+0x48/0xa0
>    system_call_exception+0x140/0x2d0
>    system_call_common+0xf4/0x258
> 
> .. which came from hardlink(1) opportunistically using AF_ALG.
> 
> The same problem exists with nx_crypto_ctx_skcipher_exit getting a context
> it wasn't expecting, but apparently nobody hit that for years.
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Fixes: bfd9efddf990 ("crypto: nx - convert AES-ECB to skcipher API")
> Fixes: 9420e628e7d8 ("crypto: nx - Use API partial block handling")
> Reported-by: Calvin Buckley <calvin@cmpct.info>
> Tested-by: Calvin Buckley <calvin@cmpct.info>
> Suggested-by: Brad Spengler <brad.spengler@opensrcsec.com>
> Signed-off-by: Sam James <sam@gentoo.org>

Acked-by: Breno Leitao <leitao@debian.org>
