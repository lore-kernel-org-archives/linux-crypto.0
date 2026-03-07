Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C851A682D
	for <linux-crypto@vger.kernel.org>; Sat,  7 Mar 2026 05:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772861606; cv=none; b=CGEo8uoOdrrxzuh4tIA58xXiKuZAxm1zVnssalEe+RZ/KgHjOYFOW6e7UeqsVJbQ2l3RNQ5bMVR7klw0kqD2KbfEd87GVTophEVk3h4UV3uhX9iU2emvWCmeMBfvTa70wsu/omBcKRZmQJ1WhVzJalUpDLsQi+JRTkyuwSyrxOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772861606; c=relaxed/simple;
	bh=t6C8ABY4NozGaZF2V8uUav9/4xVsnTL6vJhBkCeBiLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NvuvW3KNjkfUxDbsEq9L2eSfNnEHxAdkIMG3wRH0Jkkoz4OuGHWm2uiWW0crh1M56zHvIdKQ3cSTNnjgU++SvEhnWIXhlMkdbRos62zstupIO0VuqoY1uyyAuLecaa8Nlz3KkjD8m8IRi3ymv+asC5yQYxWLDBtyUm8RhGZJt98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=OeH3gp8P; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="OeH3gp8P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0VwEmzWozW/oJrnPpXt6mOMZ6lupaAHLdWU04c6FfLQ=; 
	b=OeH3gp8PSQYKgx6vMFB3wWP2PuYJLlOMMTknFWohOJYAsMLJWSsk3DShR3wexx36tNogiEGU29y
	et5wPO32NfU9R89A3srfSfzoMACeDJ08OD1Y6CnCPWenyu0RtdBnl2OcBWRhxXTkyouhQaT9QTspK
	cvxWYUekm4MBqTPdxw1axTGAq7YYiwrDgx60/t4i1O0+hCEkYb3RXITPzDGDJV+dq5aSbdZKhQ3Sm
	pWjr20BzL1y9g/NsDqYHRAuI7w13pRgF8Jai7w7IuXcmOBuzJYODLkwoU9Q6JYJh0JOK2nBp+ZSMV
	NApF4h5cfuCkY9EqRfO6hTCWUDa4dG3r282w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vykHx-00CJaM-0g;
	Sat, 07 Mar 2026 13:33:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 07 Mar 2026 14:33:21 +0900
Date: Sat, 7 Mar 2026 14:33:21 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>
Cc: linux-crypto@vger.kernel.org, tgraf@suug.ch, ast@kernel.org,
	andrii@kernel.org, kernel-team@meta.com,
	Mykyta Yatsenko <yatsenko@meta.com>
Subject: Re: [PATCH] rhashtable: consolidate hash computation in
 rht_key_get_hash()
Message-ID: <aau4oQWfvg_V33rj@gondor.apana.org.au>
References: <20260224192954.819444-1-mykyta.yatsenko5@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224192954.819444-1-mykyta.yatsenko5@gmail.com>

On Tue, Feb 24, 2026 at 07:29:54PM +0000, Mykyta Yatsenko wrote:
> From: Mykyta Yatsenko <yatsenko@meta.com>
> 
> The else-if and else branches in rht_key_get_hash() both compute a hash
> using either params.hashfn or jhash, differing only in the source of
> key_len (params.key_len vs ht->p.key_len). Merge the two branches into
> one by using the ternary `params.key_len ?: ht->p.key_len` to select
> the key length, removing the duplicated logic.
> 
> This also improves the performance of the else branch which previously
> always used jhash and never fell through to jhash2. This branch is going
> to be used by BPF resizable hashmap, which wraps rhashtable:
> https://lore.kernel.org/bpf/20260205-rhash-v1-0-30dd6d63c462@meta.com/
> 
> Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
> ---
>  include/linux/rhashtable.h | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
