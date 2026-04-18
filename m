Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1CC29AAF3;
	Sat, 18 Apr 2026 23:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776556351; cv=none; b=CC27a6UwKDHbJw9Dz6grOZlZYpR5qciHzgOjTqPndnciEnjhRsEmgmzD/BrFaCR5VaMuD6Y8Ba4LxUgiNLtSfNuAiiJtjBjDk7X2XiNWIVT8bITb2RvAkgI7HIHP3kcxjYi89dC1boyDyGGeS2RfbQZrF4+hlr/GI5D/2kLmqZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776556351; c=relaxed/simple;
	bh=8sj0LB7vRs97YPJ3eUBTA5AxlXkRZPMdaIMhReW+bYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eUVEiedzY/aaJAZLyzWUABni8WBoBayhwsJVY4NH/5ExS3GI+H2nG1icwvEwyhqq4NnvwGt9pv1arlyYuI8h6t0q6ZDokrLmht2hRS0C4HRJ2QDg1i937JpgH2eXpziwygUUtbsI35+R2REbr7+mJG86AoZNRtaiF6lv8bl4kBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qi40OZZn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qi40OZZn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=y9OQqXRvkvsl8GwgwOgbpA0ljpdAAoE+nFUbyuM2bNo=; b=Qi40OZZn1hQQ29Y5PVqIFvxKyy
	wK7NzfTRkjXlFnmKeH1OXQJ3zzgNeOJ9qXOLNKekgCnJLmhjg5ZCdZeytmt3M+M9TIXVQn8JXku/r
	1gpbp8fIjF3B025AmdMIbI3um43TXbPzoVGSLwrS7MHX3xE/OJiAzclbeMhzfJEaM3VfgNJG/rvyW
	3tX1nAxh+Fi4FBji0BzbWiW7E/2aAwvU7T3rQ9qwOeuz8veOhndq5F1yd+vaUzSob7jqlirwmfVtk
	5KsKf09UckVJngW+ax5C6mjy1Xd8gPXxOsMzn8bNZd9CbHEZrIScnW6ClpTR6lEgWj8jY6sHDAr8l
	OaW3CNKQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wEFSc-00000005KvL-09Ga;
	Sat, 18 Apr 2026 23:52:28 +0000
Message-ID: <5f476f04-b6ea-4c56-b416-da4c5cec19a0@infradead.org>
Date: Sat, 18 Apr 2026 16:52:25 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] lib/crypto: docs: Add rst documentation to
 Documentation/crypto/
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-doc@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>,
 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
References: <20260418192138.15556-1-ebiggers@kernel.org>
 <20260418192138.15556-3-ebiggers@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260418192138.15556-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/18/26 12:21 PM, Eric Biggers wrote:
> Add a documentation file Documentation/crypto/libcrypto.rst which
> provides a high-level overview of lib/crypto/.
> 
> Also add several sub-pages which include the kernel-doc for the
> algorithms that have it.  This makes the existing, quite extensive
> kernel-doc start being included in the HTML and PDF documentation.
> 
> Note that the intent is very much *not* that everyone has to read these
> Documentation/ files.  The library is intended to be straightforward and
> use familiar conventions; generally it should be possible to dive right
> into the kernel-doc.  You shouldn't need to read a lot of documentation
> to just call `sha256()`, for example, or to run the unit tests if you're
> already familiar with KUnit.  (This differs from the traditional crypto
> API which has a larger barrier to entry.)
> 
> Nevertheless, this seems worth adding.  Hopefully it is useful and makes
> LWN no longer consider the library to be "meticulously undocumented".
> 
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  Documentation/crypto/index.rst                |   2 +-
>  .../crypto/libcrypto-blockcipher.rst          |  19 ++
>  Documentation/crypto/libcrypto-hash.rst       |  86 +++++++++
>  Documentation/crypto/libcrypto-signature.rst  |  11 ++
>  Documentation/crypto/libcrypto-utils.rst      |   6 +
>  Documentation/crypto/libcrypto.rst            | 165 ++++++++++++++++++
>  Documentation/crypto/sha3.rst                 |   2 +
>  7 files changed, 290 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/crypto/libcrypto-blockcipher.rst
>  create mode 100644 Documentation/crypto/libcrypto-hash.rst
>  create mode 100644 Documentation/crypto/libcrypto-signature.rst
>  create mode 100644 Documentation/crypto/libcrypto-utils.rst
>  create mode 100644 Documentation/crypto/libcrypto.rst
> 

-- 
~Randy
