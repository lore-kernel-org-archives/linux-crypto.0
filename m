Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F50E2BF3F3;
	Fri, 13 Mar 2026 23:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773445607; cv=none; b=EplJ1sXa8xhSHyUs+pHVS7KgBhRhIf9SS0AGb46/BPOki5YEn9Dh2uOmObJK1tQvSoSHP9ZvlSzSJe2pnYUCTvTlmaZrS5Sf/zAtgiY4sXE3FnjlMw+a4c9Eq6XhL8xAMdN+puvk8ICZgjVPAgQNhToHCJSb74uepxBVzasgubk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773445607; c=relaxed/simple;
	bh=4u62yTewF4Ria02l+r2EiWYExHlsZaHkcvllXs7rLWs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iq52/fM4sxg9Dj9sRpzLe08sXijci6AgMWC3KnVNG1W0DlJSPNFCD4SSiQvK3PG2FGL7lyM5tUG2paUPLQ+IUg189+Sfli0h5V8ipwBITWKiWseuck73uXnSBh+XtpOK/fku2vbFdxex8en3DLSrd80zNrIrioBiDWnBFnk7P1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ase/MnIe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ase/MnIe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=wGYcxW8yVTFkNY9kQvbfYKPjoAkfGv57TJ3BTio0e/8=; b=Ase/MnIeIH3wrLd0jlh0iWwbJX
	ZEwcR63YdNB8FZQ5lqIzbygu0luhRxphxLg4l0I9qoQOh6Xjkx9dLs/uJGuvPacnOU9L6ayCyDDAJ
	bF4Xve45wwCMbZZNpTo3dFAPPlpcuZ1UDC8Satna4+rocBvqzf57DrvIMA6QcJHKQvAZ61NnozdNr
	l73HEEW1BpDRXy9L4ugCZjr6nXWL6B9fa5/fImx/5Z4QffujH2TRXTx+KHzS5X/52taWUEBFahfjo
	nBlYjwpkXdf3T3wg2FHU5xG+RqfBcj6vYsHPRL0CxJkntgYKoOnEHTG3h1YVOy8bL8RecDGBMkJqJ
	nwScA6xQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w1CDK-00000001KXh-00QJ;
	Fri, 13 Mar 2026 23:46:42 +0000
Message-ID: <91914036-071a-4503-8fe3-9c69cd1f8a41@infradead.org>
Date: Fri, 13 Mar 2026 16:46:40 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: replace broken libkcapi link in Crypto API
 documentation
To: paul.louvel@bootlin.com, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260313-crypto-api-libkcapi-broken-link-v1-1-a218033d7f05@bootlin.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260313-crypto-api-libkcapi-broken-link-v1-1-a218033d7f05@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/13/26 3:00 PM, Paul Louvel via B4 Relay wrote:
> From: Paul Louvel <paul.louvel@bootlin.com>
> 
> The "User Space Interface" section of the Crypto API documentation
> contains a link to the libkcapi project that no longer works.
> 
> Update the link to point to the correct upstream location so that
> users can access the library documentation.
> 
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
> The "User Space Interface" of the Crypto API documentation has a broken
> link to libkcapi. Replacing it with a working one.
> ---
>  Documentation/crypto/userspace-if.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
> index 021759198fe7..79e41845f611 100644
> --- a/Documentation/crypto/userspace-if.rst
> +++ b/Documentation/crypto/userspace-if.rst
> @@ -23,7 +23,7 @@ user space, however. This includes the difference between synchronous
>  and asynchronous invocations. The user space API call is fully
>  synchronous.
>  
> -[1] https://www.chronox.de/libkcapi/index.html
> +[1] https://www.chronox.de/libkcapi/
>  
>  User Space API General Remarks
>  ------------------------------
> @@ -406,4 +406,4 @@ Please see [1] for libkcapi which provides an easy-to-use wrapper around
>  the aforementioned Netlink kernel interface. [1] also contains a test
>  application that invokes all libkcapi API calls.
>  
> -[1] https://www.chronox.de/libkcapi/index.html
> +[1] https://www.chronox.de/libkcapi/
> 
> ---
> base-commit: b84a0ebe421ca56995ff78b66307667b62b3a900
> change-id: 20260313-crypto-api-libkcapi-broken-link-65069e8ce688
> 
> Best regards,

Hi,
Either link works for me (with the same content).
Could it be browser-dependent?


-- 
~Randy

