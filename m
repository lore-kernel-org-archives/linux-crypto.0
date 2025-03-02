Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6B214900B;
	Sun,  2 Mar 2025 06:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740896942; cv=none; b=JixC3nDNTsngruELmWiaBmLCY2oXqL3S21gZuRqP+A9N3eCm1kETcV9Gpu7jV7ovJOgTTXk9VOhi8IvTsXRj63IyiRrC98yKTz+HZeyOfhcWt4N3h8gAzOZfLTvw5ytexWMZYNzibGFk5ynRWcxpgoeuFJZqfem0Kch/Ysw7l3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740896942; c=relaxed/simple;
	bh=TrTd0+Z1FvkAZL88c4Vpg0ib0Vnmq2g+HJPozWb76WQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ZRthcLiIdF60qj7C7J4QAqMWC1Y/263FJaRLjRiaD1y/QvUtHyd/vV/ymni1xbWRNnvEM8D4P2fmKS/LaZBk5GeFpnKlURLSP0yY/YHy6i43LlRTZAUiU5Ir44sBqsLpqIF7pFnDNpmC/yTH7s8qsHkTdR62MbHDbxxeGJmFgj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=V5ipIGdd; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="V5ipIGdd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MwT/CddUMKEZCQgw2gOfmCt2b/V3IB6h/8HWkYv6V6s=; b=V5ipIGddDVSU5k1MCcH3X/tmPz
	tZjyo+h5kgO7yMsbpc/yP0us7Qs8C3piYo9LXcpsyQe6ts8W7a1dsAxn8jNoBVkkzLjzyOwsJK4Py
	M9N5rukGAxMkUXCQV6cCK/sBp417nERoIOOtKHzf3OGmwppdI7Shj8QPdOvTcH6wPyE+41DdSJc/h
	WO0umd3aBVY3mLHNb0z10Br2NyCiyyrJGDAOyaKcJp/ew96eMvpKyhItro+U2tv2mXFfhR+kyfjnm
	Z9nfQuzB78csj3Q45bZBz/tTGyiBkTEZMxcfs3kwQwGxVwnZru82eBRFWHQ1i2jfjrNV50N3f0Ds6
	c7e+aByQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tocoq-002zV7-0k;
	Sun, 02 Mar 2025 14:28:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 02 Mar 2025 14:28:56 +0800
Date: Sun, 2 Mar 2025 14:28:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v3 03/19] crypto: scatterwalk - add new functions for
 iterating through data
Message-ID: <Z8P6qOt4DQ3_FkMo@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219182341.43961-4-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel,apana.lists.os.linux.netdev

Eric Biggers <ebiggers@kernel.org> wrote:
>
> +static inline void scatterwalk_done_src(struct scatter_walk *walk,
> +                                       const void *vaddr, unsigned int nbytes)
> +{
> +       scatterwalk_unmap((void *)vaddr);

Please send an incremental patch to eliminate this cast by making
scatterwalk_unmap take a const void * just like kunmap_local.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
