Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A03C3859C3
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2026 08:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776673860; cv=none; b=Ge18RQjBKmQ1Y5SxQ1wWrcb42SRV78DSXhKxiYUGu9qjEpPv1iSm8DfaK5ivouj/p1DB2czyLsdhYxXsRTcCS1NiJ14rxKFiT9pMKtvxREVwrarbmDy/uuvFH9vxbMDXF6LjDwZI1FDu78PxwIN/+JtGVaKmLh5SW3QqDhciJog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776673860; c=relaxed/simple;
	bh=KWQFEWMNTH7tAzVonXg77JCgPVLRoWHii14n3bzxW0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mzpShsC4uF5pTg1oA3/WvnFP+6byQdLcJkjzSyaxbj0FxAzJmzd5XCPhCYVVLTxDoZm3DF5qw6Ov0vTeJJf39aGow9H1HUBcGD68XIE9naRYfbcy6qFPZlJJRgHOx7psxKiCedhrnhXVGH9HTXK+YRp5tY7zEukvh/s3OYU9n34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=kGHn6c1I; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="kGHn6c1I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=F1rUmSgBcqUQ3ry1pjZiS1HtJxwsEcaBtivjqEUQpZ8=; 
	b=kGHn6c1IObREQSId+Rx5aPVFgdfpjrB77meIy/4IWd5taCYzmmnJkctw7CT5keZwcDiaUOTR7P8
	l4CBrh+Zef8yxdprB+SIUjvePj511NrgU5+9HfiRa6weiFDVRL0lKU6Mf5yPecu45tzWc9NUX0Usv
	hJY8wA/KDTU3mXf10Y1juQPyqWWym20d4N1zi1v2kBKtCvFSb80vEE8nyGNFFD1BIpl2IquuEe5J2
	JNrbE+f4RCegodRQaYicJ6GRMD8CGmKBtnBAq9J8HuuQgfebREFuHzoGakg6Ofxmdgxap8tejAbxL
	PyWSIJQTzgS6+bM7lIQC/bXNAyZkAtk66A1Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wEk1v-007LbE-05;
	Mon, 20 Apr 2026 16:30:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 20 Apr 2026 16:30:55 +0800
Date: Mon, 20 Apr 2026 16:30:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net, smueller@chronox.de,
	yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
	bird@lzu.edu.cn, tr0jan@lzu.edu.cn, kanolyc@gmail.com,
	ldy3087146292@gmail.com, enjou1224@outlook.com
Subject: Re: [PATCH v2 1/2] crypto: algif_aead - snapshot IV for async AEAD
 requests
Message-ID: <aeXkP5D79PcczV0Y@gondor.apana.org.au>
References: <43955efb67bf85481da7457b73bd30539d8e5d79.1776578475.git.enjou1224@outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43955efb67bf85481da7457b73bd30539d8e5d79.1776578475.git.enjou1224@outlook.com>

On Sun, Apr 19, 2026 at 04:52:59PM +0800, Ren Wei wrote:
> From: Douya Le <ldy3087146292@gmail.com>
> 
> AF_ALG AEAD AIO requests currently use the socket-wide IV buffer during
> request processing.  For async requests, later socket activity can
> update that shared state before the original request has fully
> completed, which can lead to inconsistent IV handling.
> 
> Snapshot the IV into per-request storage when preparing the AEAD
> request, so in-flight operations no longer depend on mutable socket
> state.
> 
> Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
> Cc: stable@kernel.org
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Co-developed-by: Luxing Yin <tr0jan@lzu.edu.cn>
> Signed-off-by: Luxing Yin <tr0jan@lzu.edu.cn>
> Tested-by: Yucheng Lu <kanolyc@gmail.com>
> Signed-off-by: Douya Le <ldy3087146292@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
> Signed-off-by: ENJOU1224 <enjou1224@outlook.com>
> ---
> changes in v2:
>   - split the original combined fix and keep only the algif_aead IV
>     snapshot change in this patch
>   - rebase onto the current crypto-2.6 tree context after the recent
>     algif_aead async-path updates
>   - v1 Link: https://lore.kernel.org/all/9ccd66d3acbdb4fec21e58c3167fc51eec4b63d2.1775841543.git.ldy3087146292@gmail.com

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
