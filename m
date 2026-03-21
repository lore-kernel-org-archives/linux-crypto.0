Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5B42C3261;
	Sat, 21 Mar 2026 08:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774083147; cv=none; b=N/mjV9uFl+QwhZE25DkRppJXt30Q6cSmBBAaY4jccgJC43YbmjaURRFNbuOiKp5a/0F929LX+X1oorV6FOT8O+4vVIJoJmhvIoVB//BoGICDdi+UtSBisLsmuBRWhkwaQjbDqiTxrCzZMPb7a844xi4+7rvRNED2gVmYO7Lx8oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774083147; c=relaxed/simple;
	bh=1E4iU3molbCWXyGYgSqOSzAjHLsILImmnVvpjgMKItQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p2l5ELpKuB+oGZ9yiayI9r/eKXz4bRq5dwVkfV829JaDSoag3xdWV557VYI44LE9486J6rjZcxhlOZ8qQSr2mz3F2mk8nLwgJeX46PpioFzJoNXHwgr1UGfUcgSJlq+lrx2Oykbk42pJrKY5e1ZWr9o1lHtXNPvRtdpAy/i93GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qt7NxOcI; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qt7NxOcI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=cUgPvEmZkfWAjm+rya7CIP5Epkeo1dYvaYC0EbpZJdE=; 
	b=qt7NxOcIydf9d5V7hjSi6+9LButk8o+CLE5dfCx1yKRuF7+KGs9FnFk5RRuS2iRzfwBtgWESkaO
	tJntPnut89aHgjzSWJSObph3PwLqo0N7FfIxIjZ6t9FcZDg0Tc2TNyLa3POchWvC3pjfV7A3sRtpC
	dRCJ6hyf0uclvDhfW3X2U1tcruFe/Ll6ivFqYLn9dTqaSRx6FDIa1h+tYZChPfLTITSkSXoChO6GQ
	nTAPYRCIlU3Hg3E15GBcHD/YMjWniilcPm/IMaIXOaKe9kn9Rlva2shxA8Vk9czSpDlMrZEI3bp4N
	3TMtTmrxxsouEzyjkdTiSR17KTRnidB56a3A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w3s4E-00GJG3-2S;
	Sat, 21 Mar 2026 16:52:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Mar 2026 17:52:22 +0900
Date: Sat, 21 Mar 2026 17:52:22 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kit Dallege <xaum.io@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] crypto: add missing kernel-doc for anonymous union
 members
Message-ID: <ab5cRmttmqeCPYnn@gondor.apana.org.au>
References: <20260315145722.24081-1-xaum.io@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260315145722.24081-1-xaum.io@gmail.com>

On Sun, Mar 15, 2026 at 03:57:22PM +0100, Kit Dallege wrote:
> Document the anonymous SKCIPHER_ALG_COMMON and COMP_ALG_COMMON struct
> members in skcipher_alg, scomp_alg, and acomp_alg, following the
> existing pattern used by HASH_ALG_COMMON in shash_alg.
> 
> This fixes the following kernel-doc warnings:
> 
>   include/crypto/skcipher.h:166: struct member 'SKCIPHER_ALG_COMMON' not described in 'skcipher_alg'
>   include/crypto/internal/scompress.h:39: struct member 'COMP_ALG_COMMON' not described in 'scomp_alg'
>   include/crypto/internal/acompress.h:55: struct member 'COMP_ALG_COMMON' not described in 'acomp_alg'
> 
> Signed-off-by: Kit Dallege <xaum.io@gmail.com>
> ---
>  include/crypto/internal/acompress.h | 1 +
>  include/crypto/internal/scompress.h | 1 +
>  include/crypto/skcipher.h           | 1 +
>  3 files changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
