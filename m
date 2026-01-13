Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56858378D72;
	Tue, 13 Jan 2026 08:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768291509; cv=none; b=PxMVGy5lXzlZBsB3AbIPIoPAxEV+qf2U/7QlPUnYc2KZpaAtn4NGqw8sigy0+8YCt4AkZkAVp6xzQlaKUFvNtTR2ZlWEdbDGp6A0LA4bVAKGvkah8IEd3eUMVTAj6Ou0fcaAOnuiTWtQMyk6ZqO1clWCZpl9p1ZURoew8N1u5QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768291509; c=relaxed/simple;
	bh=H6FQlmnL1adTtev9Ir/cwQ1vFd83ldOeVR0WDWp8FDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=seFcnzaxGexkCratFZ4OBl6oHU0L2LhujJbbp/7SLUYOfD7XM8XphRQ0Q8wjnq5t11Il26seEIjrn3UqtTh6pculVjcl/x7sHeoyyChiTxHTP1ywY6uMyRMuZ9tg7luyth0sfxy9KlUM1sFbBl/FHwoQ8fG0VStkdlRbuVXN/qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=cUno6lji; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="cUno6lji"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=aR6YtaYR01A/U2s4oukMvYuwh6xuiUY1vycYUKhzdKw=; 
	b=cUno6ljiaoagDOJYGHIGG2h1UloYLSKESbvBKIKkFjIVqQcbJPT4aDwtS0IBIPx0z4UZdTNXgGC
	FVUtWm8eUSlg/+WiTTQtzVDUC3v2NtgtX68+KrOK7ySJ6AilLCwx2u17MorkEaB2HjV3QNVzYeUQ6
	CdmV7NAiMGPaU3yfDLKftChLEmNp62ULiHTDE9jqEY3UQzPrdfb5it3zdkPR/3W1hIB7JHRndzYh8
	6A8TJxd8AH0Ik7iJrZ7kbdmi6cYfIS++N7c5ug2TN3avutS1rlQrhySuqhwdCeWFsfV1vArQwHyeU
	WT5ucUn8vWLuA8r/3tBQUDFmfrNag4aK0F3w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vfZOa-00GJB1-2q;
	Tue, 13 Jan 2026 16:04:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Jan 2026 16:04:56 +0800
Date: Tue, 13 Jan 2026 16:04:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Xin Long <lucien.xin@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [v2 PATCH] crypto: seqiv - Do not use req->iv after
 crypto_aead_encrypt
Message-ID: <aWX8qNm9iwYFyoxO@gondor.apana.org.au>
References: <3c52d1ab5bf6f591c4cc04061e6d35b8830599fd.1765748549.git.lucien.xin@gmail.com>
 <aUJKjXoro9erJgSG@gondor.apana.org.au>
 <CADvbK_e1b1uF9izfeV3KOuEOckCBXnFKL4NRjb3ZGHih7F89hA@mail.gmail.com>
 <aUijI8zYq31rSY16@gondor.apana.org.au>
 <CADvbK_dORpkN7Gu-xP7WyEcCJmzn6Cr-Fu5_1aHB5Bp=Ahzcrw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_dORpkN7Gu-xP7WyEcCJmzn6Cr-Fu5_1aHB5Bp=Ahzcrw@mail.gmail.com>

On Wed, Dec 31, 2025 at 04:06:48PM -0500, Xin Long wrote:
>
> BTW, Do you think it might have the similar issue in essiv_aead_crypt()?
> 
>         if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
>                 kfree(rctx->assoc);

We should fix this, but I believe this dereference (after free) is
harmless.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
