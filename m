Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B11F33A6F9;
	Sat, 18 Apr 2026 23:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776556234; cv=none; b=NTGT2KhWTOwOOpkUat7xvhiR6FuBQtByqQa5Uh/Sur1zGLm5MfyFWWNvkUIV4RzrlpW2Kpm7+66yd5ZEBvtJW46E1VFVKA+iDvs50T0he/b/R5S/p5luaWomYuy9iEziES7vVcPtwocJ4Chxx/DAYNcvRyANtzan24lRFsDitIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776556234; c=relaxed/simple;
	bh=dQ/SqREdljKaVD6FfxunTIxAFSkkkoOEwyMiQXg1J2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CK9ZkRWePYBIcab3WpYFTylQfnXGC9+XweqKhcnfza9QjoF3iQIHUeOJMCpzn2MKvJbUyqh1kDJDYoDOSOuxjtcWw7cIDPGiIMisxr+rEVloNgoNWTYOpyCj5TdBWB0AKJC0Qex9gsNQR3PoYvHQvizOWtLzIx731ezWat0cf0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1AniFgrr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1AniFgrr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=YM5E7+SXOIPlDYq+DPbzWN/4sPXvf11J2R9Hmvn4ugs=; b=1AniFgrrELUzAjer3HaD+1Vylh
	xwHkc6Cu9tDNIj9HmPHzb+61aQkimzAE2AxHH08jXeUOe921hK8ukyY2c1XS2+FPzsfEvmF2VNi9e
	MPbS60birS7+EIDK2cVnUnN7MXSbBEQ8/J2w3Ql1z49YHgQyzuj+SCTdx5L1SeNtjN3ErUMsp2h09
	caozrYPnQ3s9ofVV5rTL6zdfXPvZ8zEFhjLLtQAL10JrZLSBnnIepE0yOAH3bRVB1/Ec1erAuVytw
	5lqc+PSUNDlMJAOS8w8CloaKaoVFyFwDyuVZltfBmK+bqVaHGIM3tkXJgioS+felafsxtJnSBzJWs
	3kuluxnA==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wEFQY-00000005Knn-0rbq;
	Sat, 18 Apr 2026 23:50:20 +0000
Message-ID: <7c3599f4-8b2a-45af-a99e-6cae8e8c1468@infradead.org>
Date: Sat, 18 Apr 2026 16:50:16 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] docs: kdoc: Expand 'at_least' when creating
 parameter list
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-doc@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>,
 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
References: <20260418192138.15556-1-ebiggers@kernel.org>
 <20260418192138.15556-2-ebiggers@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260418192138.15556-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/18/26 12:21 PM, Eric Biggers wrote:
> sphinx doesn't know that the kernel headers do:
> 
>     #define at_least static
> 
> Do this replacement before declarations are passed to it.
> 
> This prevents errors like the following from appearing once the
> lib/crypto/ kernel-doc is wired up to the sphinx build:
> 
>    linux/Documentation/crypto/libcrypto:128: ./include/crypto/sha2.h:773: WARNING: Error in declarator or parameters
> Error in declarator or parameters
> Invalid C declaration: Expected ']' in end of array operator. [error at 59]
>   void sha512_final (struct sha512_ctx *ctx, u8 out[at_least SHA512_DIGEST_SIZE])
> 
> Acked-by: Jonathan Corbet <corbet@lwn.net>
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  tools/lib/python/kdoc/kdoc_parser.py | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/lib/python/kdoc/kdoc_parser.py b/tools/lib/python/kdoc/kdoc_parser.py
> index 74af7ae47aa47..c3f966da533e0 100644
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
> +            arg = arg.replace('[at_least ', '[static ')
> +
>              # Strip leading/trailing spaces
>              arg = arg.strip()
>              arg = KernRe(r'\s+').sub(' ', arg, count=1)
>  
>              if arg.startswith('#'):

-- 
~Randy
