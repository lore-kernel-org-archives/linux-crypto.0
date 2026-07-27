Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727632264D6;
	Mon, 27 Jul 2026 00:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785112439; cv=none; b=hwFAPof8Ug9M0XW5VCr0+REj+c4xwixyio8oH1p+xEVLgxmGwI00KUomlQAq9yJSlZuudW8HOsqJXA5tts4yT2mouUypLUS16sMF7KxzE0d++gUDsNJfSMPN2K9cNuacPJT/o6XDDjcIJ8WatGGOxx0sefEjhfeYw4H+CVuN95U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785112439; c=relaxed/simple;
	bh=4QHEwUQ9CtR0wm4uo5THUS63KGGT0Hl2vDI2eMIK7ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1pSPbmKFSWsPuRg84Ommq48NTweK0iffalLeVuMP/vy+vjcysD6oxZLN2l+wxSgOSRqDYsRjrhZ+WcCk7jxChNF79VCm7Cvvev7A0sb6Gz3OcwMBv8WDAlUCuhWwYAWyDB3CzE7O58wHokEpGmmi1BvfCo4MAWEFo9ewGWFBlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=EWWFdUIo; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="EWWFdUIo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=UoQXp0iTJIxcODNsRhcd7TMJ7fB8RQAityfIDT0KhF4=; 
	b=EWWFdUIoCL8lqWUGohudRjF0aLM4J7oXAbs0T1gqeXpGMT2z09JfSHRrcZnmoGg69Yvuopouy8c
	9+Ndbc7XpQXRnzLEl9Zvt+5WBcZ+TTXsVAt6dqOlnWPBlkgmok+aPwfF7uEkCy/zc4l6O/xrgPI8c
	eoRMiXOToY645ky30ZVU1y9B+Ae/K4xF20aNF6EnwqPMe9uhul45NlanXim485sWEcT88G1zY3sqf
	9AjW/LGsz7hnjMvHzC+nLqo5FZ21i7QmAbYzq0fmvziF4xivUAhVxD46leOVGyAhT1r16lp2RIdD6
	gu1+s/iCJOLFTcOwbRUhczWMG7R0fehtWY6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wo9Hy-0000000Gyxn-3dbg;
	Mon, 27 Jul 2026 08:33:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jul 2026 10:33:50 +1000
Date: Mon, 27 Jul 2026 10:33:50 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:CLANG/LLVM BUILD SUPPORT:Keyword:b(?i:clang|llvm)b" <llvm@lists.linux.dev>
Subject: Re: [PATCH] crypto: hisilicon/sec: use
 devm_platform_ioremap_resource in sec_map_io
Message-ID: <amanbome-FrXnImA@gondor.apana.org.au>
References: <20260715011533.1278258-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715011533.1278258-1-rosenp@gmail.com>

On Tue, Jul 14, 2026 at 06:15:33PM -0700, Rosen Penev wrote:
> Replace the open-coded platform_get_resource() plus devm_ioremap()
> sequence in the SEC_NUM_ADDR_REGIONS loop with
> devm_platform_ioremap_resource(), which fetches the resource, requests
> the region and maps it in one call. Switch the error check to
> IS_ERR()/PTR_ERR() and drop the now-unused struct resource pointer.
> 
> The driver only maps indices 0 and 1 (SEC_COMMON, SEC_SAA). On hip07 the
> corresponding reg regions (0xd0000000, 0xd2000000) are 0x10000 each and
> disjoint, so the region reservation added by devm_ioremap_resource() is
> exclusive and does not introduce overlap failures.
> 
> Built for arm64 (drivers/crypto/hisilicon/sec/sec_drv.o) with LLVM=1.
> 
> Assisted-by: opencode:hy3-free
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/hisilicon/sec/sec_drv.c | 19 +++----------------
>  1 file changed, 3 insertions(+), 16 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
