Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A1A3F6C55;
	Fri,  4 Sep 2026 10:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788516278; cv=none; b=Cy5hZ87SM3BqiIFl7+DxkDKX4YNhyx/1I2NjB9BEJVeok5+ndaI3aESHg4g7OmORj/7/XXFvHluEtjv1s4sAhI5aGnoVreRUE9m0L27cP3xY9SvS5wVCKmNtH6tysjJs3eoOcyMaNKAFPK23mii1sdbT/QmcHxqUax2Y8x3YbZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788516278; c=relaxed/simple;
	bh=v3q2SAL/XxFCVEVYDnFptaSAeJEAid6GvLyGY/QUdvU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=GRbm1mCeAX3fHcVUx700F5HiwZX5AMvH8zcSppGiYLU+cMO6zP744rqodLsAyXhXYB8Nmk3rxwvAfyX85PTJJi5mGBmCkJVM9B+SbF8hrvZChp/mErkicuBuidS2CwO+D47KVp54VVvizoWCMWqsV6JCIYo+1gJPYPmu6jbqEx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ZYYsRqNC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ZYYsRqNC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	content-type:references:reply-to;
	bh=FxUsYpZQhouWDh7pT16OMilpvZSAmW1vpul25OUCxfU=; b=ZYYsRqNCSFrcbMfDdrT2sPy00Q
	3xAECbs1TMR25Bt+lNK8VRVeG6JZgnrUblWOFcWB87Ui5ApXVSociJz6Wqyp3d7Bj5sYnwk4PwwOK
	03AeF7Nfqk+gcCLmHILZAl0Z6lS1XCGtxYrFg30unOVlXu4luUGYPQZJFxCTP/8iApQf1gnUAmcrJ
	AaSe3ipo2vdJGPjEloP8A+8PEpaQe5m8MmDGrlyXNYMQF5Xk7lDLshrSXJPggWpzSuo9W0Qo/SdcO
	SqYq3BdpelXcCnPuQgU1s1wccxmKuZciJEk5C6pnNSKVg0EKpDahoge2XA8c517H38kfzxxYi65sk
	EUaC3U7A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2Qmd-0000000AnQE-2uVu;
	Fri, 04 Sep 2026 18:04:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 20:04:31 +1000
Date: Fri, 4 Sep 2026 20:04:31 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiawen Liu <1298662399@qq.com>
Cc: jiajie.ho@starfivetech.com, william.qiu@starfivetech.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: jh7110-cryp: handle clock enable failures
Message-ID: <apqXr_z9kvUYYxne@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_3C130FE0F8AF7CA544FD44D113E4966E8E06@qq.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Jiawen Liu <1298662399@qq.com> wrote:
> Return error from failed clock enable.
> 
> starfive_cryp_probe ignores clk_prepare_enable return for hclk/ahb, then
> remove/error paths unconditionally clk_disable_unprepare both clocks.
> 
> Check consecutive clk_prepare_enable(cryp->hclk)/cryp->ahb returns in
> starfive_cryp_probe.
> 
> Signed-off-by: jiawen <1298662399@qq.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
