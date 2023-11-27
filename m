Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170FE4596F
	for <linux-crypto@vger.kernel.org>; Mon, 27 Nov 2023 22:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pWl0OOlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82473C433C8;
	Mon, 27 Nov 2023 22:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701124085;
	bh=u3wptG9C5pjDjwFDcqfsdteC2XdMmOmC1WMcl2WUcsA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pWl0OOlwLAv0La6VIjdwRkSm7X7r850jN4FzpjqO5M4ekv0ayEDW/pBAY9lygjGWm
	 TrrqxX0+vqKAAIzGTAuNNdFNNNf81Fzm0UP/HftuJH2AJTK2bZ+TxEv535tptfZUgd
	 N3C2gkqpjphjWBsSGiDGBafLEeHWzvVaz13/enJOIxyZk5HBL3nLpzZ1mdYXF8OR4l
	 5ZQ/RfT2++1siRkAnqFPqeHKCEuX0cKhvYzJHwFSzugqqqI6/WxaoDO3q/RlcOxwe+
	 I9kQI2MQqoChHc9STzi4CgwVCMy5flOKGZ+LR6RBcRGh+p10hPRD3Cwtk0G2zbfYvP
	 +AkQ0hyOGKmwQ==
Date: Mon, 27 Nov 2023 14:28:03 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 4/8] crypto: skcipher - Add lskcipher
Message-ID: <20231127222803.GC1463@sol.localdomain>
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
 <20230914082828.895403-5-herbert@gondor.apana.org.au>
 <20230920062551.GB2739@sol.localdomain>
 <ZQvHUc9rd4ud2NCB@gondor.apana.org.au>
 <20230922031030.GB935@sol.localdomain>
 <ZVb38sHNJYJ9x0po@gondor.apana.org.au>
 <20231117054231.GC972@sol.localdomain>
 <ZVctSuGp2SgRUjAM@gondor.apana.org.au>
 <ZWB6jQv4jjBTrRGB@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWB6jQv4jjBTrRGB@gondor.apana.org.au>

On Fri, Nov 24, 2023 at 06:27:25PM +0800, Herbert Xu wrote:
> On Fri, Nov 17, 2023 at 05:07:22PM +0800, Herbert Xu wrote:
> > On Thu, Nov 16, 2023 at 09:42:31PM -0800, Eric Biggers wrote:
> > .
> > > crypto_lskcipher_crypt_sg() assumes that a single en/decryption operation can be
> > > broken up into multiple ones.  I think you're arguing that since there's no
> 
> OK I see where some of the confusion is coming from.  The current
> skcipher interface assumes that the underlying algorithm can be
> chained.
> 
> So the implementation of chacha is actually wrong as it stands
> and it will produce incorrect results when used through if_alg.
> 

As far as I can tell, currently "chaining" is only implemented by CBC and CTR.
So this really seems like an issue in AF_ALG, not the skcipher API per se.
AF_ALG should not support splitting up encryption/decryption operations on
algorithms that don't support it.

- Eric
