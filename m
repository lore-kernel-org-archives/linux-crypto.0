Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135E528469B;
	Fri, 17 Oct 2025 08:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689638; cv=none; b=pqT+yQzVfXWsfJOuKGZ1pnfwpuxhQi817lvbq8mKNnRGJTOTkcsLcCt9LJhjprg7SkP0+QB1JEfGmv5J29Esu+2gsiS2DeXkx520SlB/pce3qX9S3Eu3XPdtKV3f4T1vuUdcfBl29kbQ4uD7uhv+nN+bAyHveKNpUsz/p2t7NfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689638; c=relaxed/simple;
	bh=ZqkL0xpf0N3Vr71mKQ/EHF/d/mO7pKnjSmhjKch/00c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OBbGMS66BqVM9kbVS64rWcqbwSWpnjbpIFzuwmULJZKyIF4Z/l4Byy2U8Mbtx7+jKKWMxp+BngBvtODbMqSVEJmapKx0uyF5CFcbzJN00ZG4WCREKsSXQFexUob3SB6iAirEcb4PWpp4Wmn2/TjEp0TuvLgn+p92AUKrXry8qA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=A7rk5Ao4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="A7rk5Ao4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qNAu1ZYjBpqPzLkLSg8e3NDqlLi+RZkL4fU6lvd999w=; 
	b=A7rk5Ao4RfoqcZa37SJ0auNUoM63drlXvC870nYYOJMfYjBu7q/aAjuVnc4U2556yRQaJgh6Whh
	jYR6TCsdICrDEwjZxYbSnZuMYM4nPR+1epClpvc7IRDEahEajEe+eb34eThNE1r8v2QEYotiCK6vJ
	I03voHV+trSxRnPvQMO7IvPLomLN72W7X6/5IJfqr775JKXAu7opvV7cy99Jv2p8KZbnY0Aycgost
	otyX1dvqvBjhzHNQxlSnTrBtTvVM6IizLcZCMdONi4+pJ0jiG2oB8RzVa56Yg7/ZwkW4Rzfhph0Ni
	wb1hUSdMstuJjvM/xLx29MGkvSwn9jxa5cmg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9fnq-00DNA3-0l;
	Fri, 17 Oct 2025 16:27:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 16:27:10 +0800
Date: Fri, 17 Oct 2025 16:27:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Menglong Dong <menglong8.dong@gmail.com>
Cc: neilb@ownmail.net, tgraf@suug.ch, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, jiang.biao@linux.dev
Subject: Re: [PATCH v2] rhashtable: use likely for rhashtable lookup
Message-ID: <aPH93n2tm4jlF5M7@gondor.apana.org.au>
References: <20251011014855.73649-1-dongml2@chinatelecom.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011014855.73649-1-dongml2@chinatelecom.cn>

On Sat, Oct 11, 2025 at 09:48:55AM +0800, Menglong Dong wrote:
> Sometimes, the result of the rhashtable_lookup() is expected to be found.
> Therefore, we can use likely() for such cases.
> 
> Following new functions are introduced, which will use likely or unlikely
> during the lookup:
> 
>  rhashtable_lookup_likely
>  rhltable_lookup_likely
> 
> A micro-benchmark is made for these new functions: lookup a existed entry
> repeatedly for 100000000 times, and rhashtable_lookup_likely() gets ~30%
> speedup.
> 
> Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
> ---
> v2:
> - remove the unlikely, as it's not suitable
> 
> This patch base on the patch that I commit before:
>   rhashtable: use __always_inline for rhashtable
> 
> The new functions that we introduced can be used by other modules, and I'm
> not sure if it is a good idea to do it in this series, as they belong to
> different tree. So I decide to do it in the target tree after this patch
> merged.
> ---
>  include/linux/rhashtable.h | 70 +++++++++++++++++++++++++++++++-------
>  1 file changed, 58 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
