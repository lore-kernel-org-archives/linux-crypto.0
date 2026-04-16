Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5D44C97;
	Thu, 16 Apr 2026 09:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776330562; cv=none; b=PPMrKM7owvMZhZq6TaYvCYkFLmKecCdBN+xLR2/8gHvr6m3u1O1mbYlI47aH3ZWikO4UJmN9Z+dCQGiN+3Qll89fnMfHfza79BV4wrljzFWkUotF6a31nCP9z9xy92dPo0bepGm3I3iJvf49IcWa4OjUYMIRAZbEM6rpzUz3NDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776330562; c=relaxed/simple;
	bh=/phvmWvxnzh7LNSBTDVqCfk5m1nx3Gr9sO2IZrSdrak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mLYj/nMru00lvB899pwW+3GVDu7kYobYQnf2G0X6EG+sIIU712PqnUnw+uBde4q/cjI8tINawS6EjAPTlA3LR5QisNsHLM6G5DQCrjfmdX0oHRKOY+/lLhdiRV5Nxn4BJok+e4nwrAPZZdJsBkmvP4TBE8XqiHPim33guwnENTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ErtA4N6e; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ErtA4N6e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=TixMsx0BPtUUqZSYORuHKunvvHdtwvU6CPQXYjdpSlc=; 
	b=ErtA4N6ex00IG5sZ4R0/6XrK72MfXtk43TUatl9ZTOD3lft947oTiyFT0exBCmptfvdJdoU1VvZ
	Wt08uMK3BhnbLjof2cfOrdkxCsqmKuEaXQNNlou2dFrB6jujgDNmvrTc123nKdNtttyh9tFndMcmq
	5+Ii13rLjyYRHJ6/kztKxajGxgZTUUoaKYzvUVWqknnd/rQswOFCSI7/sC9L3ZJt+p9Y+wdPuxgcr
	2NN7tsnBqVUr48q/0zB64Khuc24EmMw4LufBb+QNIO83m3WkKT1gpDpSDRw2EOvnZ8c0WT5l7JllM
	cv+avDHc4qKLlvNOWWfDT/stzw4FR7KDXhaA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wDIik-006VE2-0F;
	Thu, 16 Apr 2026 17:09:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Apr 2026 17:09:10 +0800
Date: Thu, 16 Apr 2026 17:09:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jeff Barnes <jeffbarnes@linux.microsoft.com>,
	Paul Monson <paul.monson@capgemini.com>
Subject: Re: [PATCH] crypto: tstmgr - guard xxhash tests
Message-ID: <aeCnNsNrK5o2JcMu@gondor.apana.org.au>
References: <20260407192859.270745-1-hamzamahfooz@linux.microsoft.com>
 <adYNClYB6RY820Xl@gondor.apana.org.au>
 <adffSYxKIuaDLZit@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <aeCmk6LbLFT4Keo2@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeCmk6LbLFT4Keo2@gondor.apana.org.au>

On Thu, Apr 16, 2026 at 05:06:27PM +0800, Herbert Xu wrote:
>
> So the error is coming from tcrypt.  I think that's where the ifdef
> should be added.

On second thought, fips_allowed should not mean that an algorithm
must be present.

So we should change it such that an -ENOENT is not fatal, or at least
when it's called from tcrypt.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
