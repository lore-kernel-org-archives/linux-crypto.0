Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F797273803;
	Fri, 17 Apr 2026 07:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776410311; cv=none; b=O9xKfq16W8/Lt/41cjkC0mMUXH6qBD9PIXAQfjXElCmKN3ZLA8SnnunmBOJkbdUxYSMscDdcWB8oCIXIMD5EU7OBWJK5AP5kc7OebzQYJP0CD70H9z6isAonnNoMyc1Ngqqt4NSaF+8odcSjfTU3rXS4cr2BubIlpEf4tMOogCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776410311; c=relaxed/simple;
	bh=258ZKujM0y5DTt2ogvbu9vQOcySP4Xd/m5ECp26pMq4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nZ4S4YRIjSXJiol5txXcywnvlJh+KO153xCHIX+CoHNNZFQcp5CpP0CQn7tCoPh9QlWzCUh+Je/A/6mPhD3cPtGN3p6YIgGwkhCjWp5lFvr4Hl8g99Tmtcz8jgyVK5eB87XmC6YgLQTOGOMyDQtZTSlnHAHvdJSlakT6ZODa/s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=N7Rp+xI6; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="N7Rp+xI6"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 1A7FD41084
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1776410302; bh=MB+8nl4dLzeTdISgxfk8tdcsyK5ghTLAbW/QLoapOcI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=N7Rp+xI6DVtBcpI0q5lwhCtIOKgKy8rIqizw9hLZ2Ng+mE8v9C0kDIfBTWdfmaY9v
	 EMaYc+ygULUT/OwzsPGbMQ+BqcGQ8JXHinKRotdJr6AmOtKSJDwQSldEWVpoM9/PWT
	 dHQEvMtmAtXeHidfhYxsW9kFK2XAEC6yBZjPp9O3kPiVyIBaXyKCj3yPubzv7kkbay
	 uJrU1h+/4fXXffJ6hxTVGejYqPztBnR+vNog7yKoW0T4NXpQ5fbJDioa87uOmxDBGO
	 GqUz0y2eN2Iue5uKltO7f2YrhcuPEA7l1Ke9eLnXICUJ3D5W4Tc8rk/bWE1bLKi0OL
	 JeDb4B965fa2w==
Received: from localhost (mdns.lwn.net [45.79.72.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 1A7FD41084;
	Fri, 17 Apr 2026 07:18:21 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, "Jason A
 . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 linux-doc@vger.kernel.org, Mauro Carvalho Chehab
 <mchehab+huawei@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Eric
 Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 1/2] docs: kdoc: Expand 'at_least' when creating
 parameter list
In-Reply-To: <20260417065529.64925-2-ebiggers@kernel.org>
References: <20260417065529.64925-1-ebiggers@kernel.org>
 <20260417065529.64925-2-ebiggers@kernel.org>
Date: Fri, 17 Apr 2026 01:18:18 -0600
Message-ID: <878qamys05.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Eric Biggers <ebiggers@kernel.org> writes:

> sphinx doesn't know that the kernel headers do:
>
>     #define at_least static
>
> Do this replacement before declarations are passed to it.
>
> This prevents errors like the following from appearing once the
> lib/crypto/ kerneldoc is wired up to the sphinx build:
>
>    linux/Documentation/crypto/libcrypto:128: ./include/crypto/sha2.h:773: WARNING: Error in declarator or parameters
> Error in declarator or parameters
> Invalid C declaration: Expected ']' in end of array operator. [error at 59]
>   void sha512_final (struct sha512_ctx *ctx, u8 out[at_least SHA512_DIGEST_SIZE])
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  tools/lib/python/kdoc/kdoc_parser.py | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/tools/lib/python/kdoc/kdoc_parser.py b/tools/lib/python/kdoc/kdoc_parser.py
> index 74af7ae47aa47..f982db7fddac2 100644
> --- a/tools/lib/python/kdoc/kdoc_parser.py
> +++ b/tools/lib/python/kdoc/kdoc_parser.py
> @@ -437,10 +437,15 @@ class KernelDoc:
>  
>          for arg in args.split(splitter):
>              # Ignore argument attributes
>              arg = KernRe(r'\sPOS0?\s').sub(' ', arg)
>  
> +            # Replace '[at_least ' with '[static '.  This allows sphinx to parse
> +            # array parameter declarations like 'char A[at_least 4]', where
> +            # 'at_least' is #defined to 'static' by the kernel headers.
> +            arg = KernRe(r'\[at_least ').sub('[static ', arg)
> +

This could be a regular string replacement rather than a regex.  Not
something I'm willing to dig in my heels on, though... so if you want to
push this, either way:

Acked-by: Jonathan Corbet <corbet@lwn.net>

Thanks,

jon
