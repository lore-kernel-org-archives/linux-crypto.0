Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795557039;
	b=o+phFy68fex1rZ2WHSljPP6RlcoaP/JnuU3xpwWapdgm+/7iCLQ8ES/WsLFWD5rwt//1
	 wBfDyurCxGr1cMjYRwLT1TCaB3Nv9yvXJWtxnaihdsq9ugpX+pFZPo+D2UjMU5jQ/51lv
	 iO2rOEGbhr6luJZ4Qqgd94S0IlAVnJ/Zug4HvkWunysTOsBwNKl3VforSZ5z/y2Lnogso
	 25SOAbWvu/ghJlblFw+wDWpj3CvnORicGhINkX3d5GIkn++KAfgR3Z1IcCiLC1iw7r6ae
	 5KVKVgNG+rMSHDdzGiwhdDZf+Si27P4XGR19Lz2wjLpjEDBPT5zXf8Bix0kyr6EbpSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795557039;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=HPQGhKZOJYbcgM9bz9ZQjAOFYxjCQ/qr2l3E19IpCeA=;
	b=DdaKc3PX/J62e0DH4qmmpW/m/GjQFxJFZ5YJnBhHZjGpithtvfP8imyvUd9sVDRW5Fp9
	 T8hHekexLXw6s8brWBQdPK7c/Ynhsw5I2jFj+zZr1TSd1Br6XufwN5e7Hsp4E92YinTHu
	 jCaRVVVj6GLRIQE5cehTBKvdGaQITfBu9b3326BIjGxR6rvvzqP6sHxAVBn8uPlj1imM2
	 qhlczytU+muvzaSnLVXL6/A77QiZCgNNPkXSSrEqegOZ/NBssY61HschuyhVGbGFjl2YX
	 p/5/k5eVanb8RygZSrzmkS1v7FC1WJV9oMqDC5fqMFsPUi48zM5rl4YomZsErXWUVNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jc7OOvaP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236A0606A326;
	Tue, 24 Nov 2026 21:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jc7OOvaP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7301F000E0;
	Tue, 24 Nov 2026 21:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795557038;
	bh=HPQGhKZOJYbcgM9bz9ZQjAOFYxjCQ/qr2l3E19IpCeA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jc7OOvaPR9KhpUEr3/6FLFv27Uabh1Q3B0tiRuK7P69iUJkNdpDNEg3nraglUcLLz
	 yVQxsYtLr4SXFdGZiPFhIxzZrG2M2XNG5ZTTl0p3ofLyn35D+dKTfrwD1DEc607VHq
	 tQuAO7VIqpSyFi0o7KxHcZYW13RG1fQqcsFE/iIfyenNTrpKj2UEX9Ic5VzlrKZJcT
	 t1zKl91o4GUJSSrWgmalI/j5Yb0aPRI6m+JxJJu0rXOY86hcVFceirH2Wh1sKwqGHk
	 vwJk+sn/Q1va0JBDfNz1g+z45NOaoJM2bnPdjHLpTBdFjbAQS4f9d7wBOXGPcUgG9h
	 YY8EEDtHeIoiQ==
Date: Tue, 24 Nov 2026 21:50:35 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
	Lukas Wunner <lukas@wunner.de>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v2 6/9] KEYS: Factor out KEYCTL_PKEY
Message-ID: <20261124215035.GE2227373@google.com>
References: <20261124194043.1651679-1-jarkko@kernel.org>
 <20261124194043.1651679-7-jarkko@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124194043.1651679-7-jarkko@kernel.org>

On Tue, Nov 24, 2026 at 09:40:40PM +0200, Jarkko Sakkinen wrote:
> diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
> index c73979b2e98e..1c78a9a663c5 100644
> --- a/crypto/asymmetric_keys/Kconfig
> +++ b/crypto/asymmetric_keys/Kconfig
> @@ -2,6 +2,7 @@
>  menuconfig ASYMMETRIC_KEY_TYPE
>  	bool "Asymmetric (public-key cryptographic) key type"
>  	depends on KEYS
> +	select KEYCTL_PKEY
>  	help
>  	  This option provides support for a key type that holds the data for
>  	  the asymmetric keys used for public key cryptographic operations such

Could we use this opportunity to give CONFIG_KEYCTL_PKEY an
off-by-default prompt like CONFIG_KEY_DH_OPERATIONS, please?  There are
a lot of systems that need ASYMMETRIC_KEY_TYPE for verifying signatures
but don't the KEYCTL_PKEY keyctls.  The fact that the KEYCTL_PKEY
keyctls get pulled in too has always been a huge problem, given the
additional attack surface they expose as well as other issues like the
kernel's RSA code not being resistant to timing attacks.

- Eric
