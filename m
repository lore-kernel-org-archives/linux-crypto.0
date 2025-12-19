Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D5025E469;
	Fri, 19 Dec 2025 07:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766128073; cv=none; b=kdk3avdoqKAgoQuGrodemeEN4TMECT65T8oudcfkRPOn4pUeJoyc5fj2BDlBTomhuLO+Z2B2hW53rIkx/rhkmW0puDs8LS5dqepJWg7v+Ddg0YJAiapwoCDA/5h2OtOr8sY0rGhaAu/qtzCWQGDuq3JEs9n3XpxMp++1wm7o8aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766128073; c=relaxed/simple;
	bh=SQDSoNbGYMl8xjIYwHEJ3b5IopPFj8COdph9O7yzLyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XnzubwKZ9tOXfpst622Addmpo6SgYQUBSRR0YUXBoYC9FHXrsMIAS+XJd4yfmq9Do4l3JQ56Gr2v3Os/w9UZRcpgNRoDhLtRSpwu5tNxdzs4x9mm/ig6+hEmyr1shZQv3zcr5dbehNI3F4AmUIS2OsYDrG5VVCNowqa8q+hcbZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=azfE8z4J; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="azfE8z4J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=cPAtcsmcLpI0vPronq8+fkgvluYv4Hz2Vmc+jkd0MOk=; 
	b=azfE8z4JbvquGFywljswxiVq+or53WnWimMxwqGDlVLDdFWWaMtK8uKbBXe8vOI8xCIO1kNSgQH
	XhCztoArHEEjXVGWdESBioFhUTY10TPJ10kAHxouO8vgtruKC2XCWq2EhAcMWSnx9HtNZjM/r7zR1
	qOdbZKa+09tGNE4KuOQnf69olc87IapA/6ODTGFk8SBsquFHm0OREmv/GeZ0shS8AOkH3HybL0rrE
	+WOmlp2goAyfiG45ZpKd2j1pKCKg4Lkv0ctGpe70dnMurT8cSnJhJwHxEGx6aSnoGSQJaJN8RZ054
	1XZ5Gxqo3ihweGyiuq7/P8CgyrUHddb2N7VA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWUaW-00BEg6-1U;
	Fri, 19 Dec 2025 15:07:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 15:07:44 +0800
Date: Fri, 19 Dec 2025 15:07:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Can Peng <pengcan@kylinos.cn>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: fips: annotate fips_enable() with __init to
 free init memory after boot
Message-ID: <aUT5wK9AXAzFvIy3@gondor.apana.org.au>
References: <20251208095010.2712698-1-pengcan@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251208095010.2712698-1-pengcan@kylinos.cn>

On Mon, Dec 08, 2025 at 05:50:10PM +0800, Can Peng wrote:
> The fips_enable() function is only invoked early during kernel boot via the
> __setup() macro ("fips=" command line parameter), and is never used again
> after initialization completes.
> 
> Annotating it with __init places the function in the .init.text section,
> allowing the kernel to free its memory after init (when freeing_initmem()
> runs), reducing runtime memory footprint.
> 
> This is a standard practice for setup/early-parse functions and has no
> functional impact — the parsing logic, return values, and fips mode
> setting behavior remain unchanged.
> 
> Signed-off-by: Can Peng <pengcan@kylinos.cn>
> ---
>  crypto/fips.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
