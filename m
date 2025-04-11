Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C7B27F4F0
	for <linux-crypto@vger.kernel.org>; Fri, 11 Apr 2025 05:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744350401; cv=none; b=kR506Eq2I40krgtEZljcIZaAYfzHlgiKxYpAkxgMW9hymaoUs3a0up0bkz9jY1Mrtam+yb9g6jOtBj5CU8cA1ScIViApDKZACKciFJfIJNbkZajj5PynDUGwPJ1M+rpKJnAtSZMH5YEd2YejBtZgUFVsnBcO5Sdas21o7UOE+1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744350401; c=relaxed/simple;
	bh=B3LXcmVvku+R3LmmFJU84Mp2UmvN39EmAvE3m4WCkkc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=srbftYkXO3QaqrjarhwSVJ3GRd7S9Qw4bcoFe1AjndOJ7w0QNV6DNGoNiEGdQGarVlzOaWHPrLetGKCOqIkLkm046Un+DP6arhaWU7MPYOgu/h07po3DvJ7DqRw9HHYN2ujJUyMhKSLc+t+vELZlDlLLnJQ5Of5ZqSzFfKqPKkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hbu4yPFQ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hbu4yPFQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=X1JYPYOa6t4PQJ4Ha+CPIxVm5GXO/P7rpOKHibdeHwo=; b=hbu4yPFQKuCfiZtmBmUc7l00WK
	KSb9dyLqmZTR7SwcECQRmsornkr1jQnbsjD9RMFxBj1xLZb/lG3pD7O8BPKnFtFzWAGjjaaxxC0P5
	deUVtpkee82AyzD0exw49JCd/Oekz8j4TLAASEvCHAhI343UV0PWs3/OHvipYBa89gh0KENy5sDp+
	XrA51ffpQi+Hx3TaUGpxuCpkDPuE//x+75EOKX1MqXRlX8rPCgz+kSBMDC3tLoCzopC7tkC0bk+y/
	0q/26HeLS4z2j1MI3k99KEgzrYAz6Q5OSDx1RXJ3YwOg31+6nyn/udeyBZkGtwzvbFL/Gk9nfMhlU
	7iWAidTg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u37Dm-00EkMU-1d;
	Fri, 11 Apr 2025 13:46:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Apr 2025 13:46:34 +0800
Date: Fri, 11 Apr 2025 13:46:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Manorit Chawdhry <m-chawdhry@ti.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>, Udit Kumar <u-kumar1@ti.com>,
	Pratham T <t-pratham@ti.com>
Subject: Re: [v2 PATCH] crypto: sa2ul - Use proper helpers to setup request
Message-ID: <Z_isukjVYANljETv@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
 <20250411053426.5vmvji5nthajphzo@uda0497581-HP>
 <Z_iqg1oxdPecgzlK@gondor.apana.org.au>
 <20250411054458.enlz5be2julr6zlx@uda0497581-HP>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250411054458.enlz5be2julr6zlx@uda0497581-HP>

On Fri, Apr 11, 2025 at 11:14:58AM +0530, Manorit Chawdhry wrote:
>
> I see the chaining patches in 6.15-rc1.. [0] Are you planning to revert
> them as well?
> 
> [0]: https://github.com/torvalds/linux/commits/v6.15-rc1/crypto/ahash.c

With the multibuffer tests removed there is no way to call into
the chaining code in 6.15.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
