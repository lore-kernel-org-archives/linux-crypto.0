Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F44F3D0D5;
	Sun, 22 Dec 2024 04:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734841127; cv=none; b=nYC5rSgSbWT/Z29qleRYzTddhyIk/tOPeMcOgQdnSrjMTmU30wp7DdS86y3lwiy69OU5HNMOP+A4TrvqvKTEhu/oKK2mobyCMGIeeOanpA0m9FS47zQBQxXtCTDOOx1LxR5a26rB6/f1fLpg0jnpg85UqRyWEjMkm8dEGh2dbwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734841127; c=relaxed/simple;
	bh=BDoSX/wqE5lY/f0ZwWyy6/9Tel5yWk/ISkC3sMJ/S+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TRbTfTqcjyWZ/ToHYcJy1EX7BtU4HNXp0pzKo8zIMDy9cfDDoZ8fHQO62fWFibb3tJqcJEYVNZuGfbd6s5Q8KVZvkiOworp2CwrfJSkhzmPOSHa22vfAgxr0xhriAlWP2/tgg6kOx5XjVdPfGkim0a7U3fVZL7p1AfYOrh114TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GMM+ra+F; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GMM+ra+F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bBiJGbaeIfb0l2SwM2QklOYlobbEa/oDF8ZaGc2ve4U=; b=GMM+ra+FEsBaarUMCeQ2XlkMzN
	U6n6BOoiy3j/3Jpdh+ar2IdgaDm5HX6q0aLjkvOJDJulX1u0eIHmo3UT72DA8NFLa1Yt9tKYmxfL1
	uAFKbRzjVAbclpUQz9GOBCt+TaDEk5Dh2GF+DX5CLY7Cp1uZUc6orjVdYoZyHQxOETL+3RVw5E26T
	pLk8xrmA7XWW67uXdJ3wJiQSOcQzGM0An3NBB8h4kWyiP1XF55dKS7yF8qGzAw+bEV1nmEQf+g1QG
	mLaUbUZ955tFKQzg6QojyDJ1eWvJh1NeDAKV9R5HYUNvU0bUpY83LjoiSTj3YOCDdN0R7PgtM7FEm
	FyJO4BpA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tPDDN-002UeO-39;
	Sun, 22 Dec 2024 12:18:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 22 Dec 2024 12:18:34 +0800
Date: Sun, 22 Dec 2024 12:18:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: linux@treblig.org
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: lib/gf128mul - Remove some bbe deadcode
Message-ID: <Z2eTGr3l-Zu_Tgi3@gondor.apana.org.au>
References: <20241211220218.129099-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211220218.129099-1-linux@treblig.org>

On Wed, Dec 11, 2024 at 10:02:18PM +0000, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> gf128mul_4k_bbe(), gf128mul_bbe() and gf128mul_init_4k_bbe()
> are part of the library originally added in 2006 by
> commit c494e0705d67 ("[CRYPTO] lib: table driven multiplications in
> GF(2^128)")
> 
> but have never been used.
> 
> Remove them.
> (BBE is Big endian Byte/Big endian bits
> Note the 64k table version is used and I've left that in)
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  include/crypto/gf128mul.h |  6 +---
>  lib/crypto/gf128mul.c     | 75 ---------------------------------------
>  2 files changed, 1 insertion(+), 80 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
