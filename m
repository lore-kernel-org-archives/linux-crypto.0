Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD00948C8D9;
	Wed, 16 Sep 2026 09:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789549279; cv=none; b=gfO0UvWH/G3vwBYxRk+4SIb8NVf4EAZbp+dpexVL8dGyWkwo1UX0mD0eEb7ZDXWp3MiWVizoD7rbPzU77nkfft63eR7FOWiw0aItyM34uj5tHprgrsoae+vaIA/wA8UHIWlDhnfnuhvj4PEqs9A5nYUdrIh86vaB0izOBTGqRY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789549279; c=relaxed/simple;
	bh=lsUiaPqrnhcbNGhDA5AkfzMAi/7X+7ytnA2kFDnU2Yk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GKmnwEDFUDdw7R3QQzyvZub6QJe8xnTihjm3QJI/D5nUBdhD2ni6+RS3pdhvtBAjWSPe6/i/I3iny5T70FhHeg2UFHSxBusolSswujtDrtwCFhGLQG0Ua0hbnFiZADLWB02xArHfs73EIoWqKBKNXf79+LBkr8kmpTit7CjXT6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=JkINH3do; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="JkINH3do"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=J62InCrimYMZ27rtw0DoyvxPBEcbtBLFfYYmokblwpU=; 
	b=JkINH3do7MiMnIXbrkujMQRH5H2i3PZ3JEmMIsui0B0s2bRuosH1yJszQudAirDRQVCTBxr+u8a
	m3sgzUGtu/x/YpPrutnHstLhdH0vkG7VSmSESHrD4ogUrXfxNOam0hybPNy8YPfuFdR25A7r4tTCp
	vw4QhF/5XTHe29zU6VHyqf0oRWWjzMViiKfnrMLxW2pZi5IQvr/qpFfVMLb2sEFpwdJnDOzkAvKCe
	RFWeX6CpxHDmoXzhmFDg4brNaqgJ4JPU5x/kJkWlT5OPFD0bxuyERP8Z9QPHn/MDJGH81d97m5Q8H
	ugqEsfJ0wXHdjRO7Piqu8Paq941hrSNUBwTw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6lVY-0000000EY4g-46rE;
	Wed, 16 Sep 2026 17:00:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 19:00:48 +1000
Date: Wed, 16 Sep 2026 19:00:48 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: davem@davemloft.net, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, srk@ti.com
Subject: Re: [PATCH v2] crypto: sa2ul - Fix stack overflow in
 sa_prepare_iopads
Message-ID: <aqpawGagrSvRkpTi@gondor.apana.org.au>
References: <20260831055141.1632832-1-s-vadapalli@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831055141.1632832-1-s-vadapalli@ti.com>

On Mon, Aug 31, 2026 at 11:21:38AM +0530, Siddharth Vadapalli wrote:
>
> Since crypto_shash_export() writes 105 bytes into this 104-byte union, it
> overflows by one byte into the adjacent stack frame.

This should be converted to crypto_shash_export_core which exports
just the hash state without the partial block buffer.
 
> Changes since v1:
> - Propagated error from sa_prepare_iopads throughout the call chain.
> - Added missing check for authentication key size being within limits.
> Above changes are based on Sashiko review of the v1 patch at:
> https://sashiko.dev/#/patchset/20260819142357.3950463-1-s-vadapalli%40ti.com

Looks like Sashiko is still not happy:

https://sashiko.dev/#/patchset/20260831055141.1632832-1-s-vadapalli%40ti.com

Let's split this up.  Just do a one-liner to switch shash_export
to shash_export_core, that should fix the stack overrun.  Then
fix the long key issue in a separate patch.

I think you should support long keys properly by hashing them as
crypto/hmac.c does.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
