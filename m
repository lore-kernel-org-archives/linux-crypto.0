Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24533C0C;
	Mon, 22 Dec 2025 01:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766368051; cv=none; b=Oa6tpxgH1RiUXnmveQWH/QEl0ulgiWJg9tHWmHrcqz1hDAoEKO7GbJlqmKTXRWhtoJPWSd2RDP9RuD8icaTRAASLAsosqdqr2BELBpDIZ2Alfh9oXEmiZVxwu6lCEpaSDraWjkLKg3xHDQX2z3neFfrSa3Da0vQDBAtGVMuLy98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766368051; c=relaxed/simple;
	bh=DjZLWqtdGFDEroNv2k/S7ue21wevfsVeRD9JLE+IijM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lHM2J7g83k1KxbvZY+2+EAGQ5Lx/sxwBlSVHfmVsYlv0aKWp7wTc5tjMPEp8XA8Msgpf9fYkDKZNA1EjRt6ymlHsMyjjOaN0E8qlK4vprjKJkyAh4VymVmq/04ne+Z59KeA7CqZpolvA+M/qbtcrJV8uM2eSdDa8k5JVrxunGrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=J1kVetkf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="J1kVetkf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=txATX9MBsIk/OXfs5xYrS2RMcvNE4wWDMHmIEl9RHZ4=; 
	b=J1kVetkfDGBsX7v/Bc3urUyrpZ3sB8NCt9yA1dl+kZJcUHeCq5LnyZstmoTeBXL6Cix44B0IaCU
	BBZfr5jwnzkw+kPQZLRK56KOcds0vMTB3zOsSs9WoSbQu+COZ2w4COQx1acmSg++if7PntpbxRJuj
	3d1jX+v29xKXVtZclnezZ1yqB4sSASgdLYrPe2WzdVkHie8v0gVpWzp9LemBP8zXA/EhBtLqp0c0x
	1qeQJCYm6tXwUq6mEJXMxMyj0jQOz13Cpbgu8wjAapqaqNEirXH5RKmslosL7J+/Y+tSw4VD/Rt4s
	BIm4KM0UVG9mcBxFFt1DwwfVLZmrfPpFcJ4w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vXV11-00Bkgn-26;
	Mon, 22 Dec 2025 09:47:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 22 Dec 2025 09:47:15 +0800
Date: Mon, 22 Dec 2025 09:47:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Xin Long <lucien.xin@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [v2 PATCH] crypto: seqiv - Do not use req->iv after
 crypto_aead_encrypt
Message-ID: <aUijI8zYq31rSY16@gondor.apana.org.au>
References: <3c52d1ab5bf6f591c4cc04061e6d35b8830599fd.1765748549.git.lucien.xin@gmail.com>
 <aUJKjXoro9erJgSG@gondor.apana.org.au>
 <CADvbK_e1b1uF9izfeV3KOuEOckCBXnFKL4NRjb3ZGHih7F89hA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_e1b1uF9izfeV3KOuEOckCBXnFKL4NRjb3ZGHih7F89hA@mail.gmail.com>

On Fri, Dec 19, 2025 at 12:58:49PM -0500, Xin Long wrote:
>
> Which upstream git repo will this patch be applied to?

I intend to push this to Linus for 6.19.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
