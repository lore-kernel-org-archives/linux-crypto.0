Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDE04FD79B;
	Thu, 15 Oct 2026 09:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792056786; cv=none; b=U1QNVXQ9oaNR13as27sv2XIXAHmI9yssqSp3K/q5fd+zGOwmg2RiOYLqOIeVqRLhjoDHBTWu5jUwtu7ebkBt0aIb5a5mF2jP3ikcgGXA4Fqs8vhlcXeKaDczZGRli7bfNmbY/yul2oT9kbxEqUitkXispXy4KdT9ThWNDnkJRUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792056786; c=relaxed/simple;
	bh=LpNClCQP5Is+elo/pq8lLIDHPbjUVBpwERR2/acZ+h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AfFkWvzc/bMVOSKda5julfi9hKmnpY4/j4SM8zU10m9D5uvAwwb2BifPetgsHSHIXuYooYFcCCT6A+sqC41kDzQkdnCaexXDZ1ZY4Euha9UOx0KTgARmjFtIXQ4BOMQbwpJOYlQ37sgLB22OXH4aJDQaafVm/4u69mlABogRPoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Td4Bk9E2; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Td4Bk9E2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=gqXL7E3N1x1LB8og9YdmknDi+YHVB1OXC5g35twuSCs=; 
	b=Td4Bk9E29YBqTwLpaSyL0uIyAgwH02M2fYxO7/X8OGffbsCHsvS8iSS7ct97aWJGrzaJ5PQyXJN
	Sttoq04OQLcRd8d8zV/VfBbv3RQ8Nszlc4RzYTeAFYVXltKZSzI4sOzjpHPLFdGqCFBKsjTsy+3td
	LCvDeuCyk6TRikkn4XiDOQeHzmbeut56ydMyIxMNRMreUqgbGDNucUb/NrJ7+xNdX3TxKr29JjbVg
	yorq1gQkKB3fml/e/rRZS0YJMrVUyCjVvTwhBukyGC5P2UC9XknakmfC28JZPa1dtCkN0LJe4BeKp
	z/PqUycrslgimsUQMNdi4sILZP9fnGSVYDKw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHHpa-000000047NJ-2kY4;
	Thu, 15 Oct 2026 17:32:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Oct 2026 20:32:58 +1100
Date: Thu, 15 Oct 2026 20:32:58 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH v2] crypto: inside-secure: initialize EIP93 state before
 requesting IRQ
Message-ID: <atCdyvlEqqhgK-Fz@gondor.apana.org.au>
References: <asXl69ABi0_1ZKIJ@gondor.apana.org.au>
 <20261009033149.1127441-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009033149.1127441-1-runyu.xiao@seu.edu.cn>

On Fri, Oct 09, 2026 at 11:31:49AM +0800, Runyu Xiao wrote:
> devm_request_threaded_irq() can invoke the handler as soon as registration
> starts. Initialize EIP93 state before requesting it and leave device
> interrupts disabled until registration succeeds.
> 
> If IRQ registration fails after the hardware and rings are initialized,
> call eip93_cleanup() before returning. This shuts down the engine and
> clears the ring registers before devres releases the DMA rings.
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
> ---
> Changes in v2:
> - Call eip93_cleanup() if IRQ registration fails after device initialization.
> 
>  drivers/crypto/inside-secure/eip93/eip93-main.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)

Please check the Sashiko comments:

https://sashiko.dev/#/patchset/20261009033149.1127441-1-runyu.xiao%40seu.edu.cn

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
