Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AEA4503B;
	Thu, 11 Sep 2025 04:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757566018; cv=none; b=fQU5Vu3MLTY174+L+eif39UOvGPY2s5UWZ8IdZdR4Bnu6e0iAEFmU2jGUCCSXibQfhrCfpV4YTl+lgwONbHTTOiAhtzLv8JYjJ+bOQtRzEraYpKSPmCjA+BMETUyvpakfgLKr9TjDSTu3hGJwH6l0VZBxRVjU0O33r+1ycoqfKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757566018; c=relaxed/simple;
	bh=+AaezXRAaXomHaC2FC9YNy6Kl9xfSCRU4DimubtKqqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWOxHfDtDYgO1eZLqoWDaNvQkoqqSV5radtbIczQ9tU2ycAtPoCLFP7GLGepe+6l2OLnz36KcbvOxbjxmaSY8ggXJn3ymRwi/fFbM5m2Uu6zu/ZiTxfhIJesYoVKv0QXEBQ+8H48XK3x19IrA+cnABXIkmdeXb9U5RRf76+N+Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jALFbp11; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jALFbp11"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kgQJEDzVoS/E6CHGtCTx6K8B0soRWlIV0PKYS2W5y8M=; b=jALFbp11Y/yk/R/HIkEEPcy/M2
	wg25mFk/EU4Q+D1QJTMkCx02A6G7TtTxrdCoXMPFr2hbOEu7J3DwTeVgoBzGyZF2bMUiS1zFA4+KB
	z2CfMF7JJMwP0cSaq2LWYuESaXPCvm6m45IlwB/Y3ip7aZfxLgigFXT3pei3QSrgbNcKot41lBvUq
	LYChecFkwXZZ/szakn3fxBOZWeXzZDmwYpfLTCT7tbzFUKjmruuXlt/lH0t0q8Hu80VKD9kvdQqih
	FfSMWPLxvYyXJl6Hp7XQNR9AfICkMVigOehmPHSkaDvOrDa3EkWoLb7Q31ntNGVaArmgfvOzwu1OJ
	Ok1ceILQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uwYxK-004R1U-0Z;
	Thu, 11 Sep 2025 12:46:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Sep 2025 12:46:42 +0800
Date: Thu, 11 Sep 2025 12:46:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: crypto ahash requests on the stack
Message-ID: <aMJUMo9CtPi1Z62N@gondor.apana.org.au>
References: <94b8648b-5613-d161-3351-fee1f217c866@redhat.com>
 <b20529cc85868607dbec25489daa0404@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b20529cc85868607dbec25489daa0404@linux.ibm.com>

On Tue, Sep 09, 2025 at 04:01:45PM +0200, Harald Freudenberger wrote:
>
> The problem with this 'on the stack' is also with the buffer addresses.
> The asynch implementations get scatterlists. By playing around there,
> I found out that the addresses in scatterlists are checked:

Right.  If we ever move to iov_iter this could be supported but
for now dynamic allocation is fine.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
