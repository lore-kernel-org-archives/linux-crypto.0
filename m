Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CBC3A1CE6;
	Fri, 22 May 2026 12:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779453285; cv=none; b=laTNrc2SVsMKaCtPEmo433l3x7LBeMX12WLG9/swxFQak6ZX3BohaoOxQQXnIqBR38CBngsCSKbEvRTX05eZkThfuDP9DyW3weqIONuo2FjXhJiBhZICf4A+AesHng85qZWXnIvj0Qh6U44colZ6jPb5862Cek7B3rqegb1DeVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779453285; c=relaxed/simple;
	bh=X6kJK9NEb9BaMqmIn1T7Jo2lddS4bbHc7OsxBFeQnHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cq/mlxtqjIWt4foBMTA+vWSAYU6ymXh2fUUxdKdqjdk3yDKIqP18QJ6GBHpkJIX+K5ZELT2rG17Nx8Y63e3rWgXkbZpcuKzL+W5jVrnusr9i7n1EC4mOc6l52Y9+p0sAuTcmVvBdXPa4HWLDuwpI+Y2sJoLpoLtiOJA9CYvdnEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=POB5w6Aa; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="POB5w6Aa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=rkOmlK8/vsNxtR4tnHVWW6IWreQiOdShoEWLAKZXg0Q=; 
	b=POB5w6AaTRGoUkM0JwUtlpROCRVCvPyOitXIXiqwgdAr/HSsM5F1So95uEsgIWLizVkqiAoPlJc
	FnUDq7I7lNMCRctmFHChCp6wnaET2t5qoLfrGON+qRjpKdm1K2MHKbV3hI7Uq4+NAiTrI1LR28Ocp
	ipkZNhq9gRXRxYeYNvMxUBUcXKKkmR2yoT2JsMPJKsoACxtI4QrzkK7BY0fEhQKobLXzy8pR4R7+l
	1sGXcfH9jxEeOlrXdgj4d/A1Wunu7eign7m87qFsKEmBXYYu001+nqoffn0F9HNVj21xAu1oV8bH2
	zXBCvdSo2SbvhYR6Uyb89UHFzrZXpw8/r+Sw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP5H-00GSSm-2e;
	Fri, 22 May 2026 20:34:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:34:35 +0800
Date: Fri, 22 May 2026 20:34:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, Kees Cook <kees@kernel.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] crypto: drivers - remove of_match_ptr from OF match
 tables
Message-ID: <ahBNW7b0ebCuwFF1@gondor.apana.org.au>
References: <20260516182337.874311-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260516182337.874311-3-thorsten.blum@linux.dev>

On Sat, May 16, 2026 at 08:23:36PM +0200, Thorsten Blum wrote:
> Drop of_match_ptr() because OF matching is stubbed out when CONFIG_OF=n.
> 
> Indent bcm_spu_pdriver.driver and its members while at it.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> Changes in v2:
> - Drop omap-des.c because it doesn't compile with CONFIG=n and requires
>   other fixes first
> - v1: https://lore.kernel.org/lkml/20260516114941.741140-2-thorsten.blum@linux.dev/
> ---
>  drivers/crypto/bcm/cipher.c | 6 +++---
>  drivers/crypto/qcom-rng.c   | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
