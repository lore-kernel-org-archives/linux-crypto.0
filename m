Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F19313FD84
	for <linux-crypto@vger.kernel.org>; Sat, 14 Sep 2024 08:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726303224; cv=none; b=gFtsYak16hj76keNaCJqHYnVL8L3rQzWPllj77s1UtGGLW4WMhkxL1q4mN1YjLgSBhGm63WK8EfDqGyy8xXRr7JWCl8+uVcFHm+hrwOcPqLX3lBW6aUVwM2XEQid/ZW1wQykegydQq7zaFsLfj60kRcrlS9KIPJdPAhMfgZL6DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726303224; c=relaxed/simple;
	bh=gt7fF5//gij6sTuFATtYqW5NH7EbrOj+8sDSPiCT5YE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YG0V5225GyXGbkEahahSqZzsFoFDYJIgF65RIrFD1UIR/tznjYEatOLU+otPr//Vxxi+kEnOvofMRVGAtJcR7DVYwJ7OysGvU5rID9gxovWN9L9AyFzjJW7GFnDQXjQ6sKwrPu3ipAi+E4dLLGAYmQpuPa2gXvaG/KUCPE22lls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YarOARy4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YarOARy4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tYXOrBSDhAlXET7Tbvzgiywf5HOUwvuVom68ljOuQQw=; b=YarOARy4e/EHrLp+xKPbhrpk3P
	c7DfzLWCUNVeDVZgKDBD/rMw7gTO0L7GjXVAsUFqmcP1ayyIoF0O6mBiy314I/23WEgndjO8106JD
	8wFO9eoW4QyNCPA0uIog1KRn0vyULlseIFxw3fSqwhEsMoucRcPhfJmio9QWpHPcZbFJ0FPPk2bnH
	Xh4rHQRel/sq/W/2LvUOiGOqmizn1sQ5dPjuGy7vMkqt995AIF6l1jTQ6iiV++Q4z/t63bBPI2zvt
	Wl66c4RA3grVnib4GLm7HC9c3ty/JxHTUanaAv9cMxrZsKLFBRkXsazIqF2BYFSFpFp/FMPQlMrTR
	hIYU3/FA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1spOAC-002R9L-0w;
	Sat, 14 Sep 2024 16:40:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Sep 2024 16:40:05 +0800
Date: Sat, 14 Sep 2024 16:40:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
Cc: Li Zetao <lizetao1@huawei.com>, davem@davemloft.net,
	lucas.segarra.fernandez@intel.com, damian.muszynski@intel.com,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH -next] crypto: qat - remove redundant null pointer checks
 in adf_dbgfs_init()
Message-ID: <ZuVL5buxgkqSEzPU@gondor.apana.org.au>
References: <20240903144230.2005570-1-lizetao1@huawei.com>
 <ZuQRqP9CgDp7cuGi@gondor.apana.org.au>
 <ZuRRxIjK8WMvStJ+@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuRRxIjK8WMvStJ+@gcabiddu-mobl.ger.corp.intel.com>

On Fri, Sep 13, 2024 at 03:52:52PM +0100, Cabiddu, Giovanni wrote:
>
> As I understand it, there is no need to check the return value of
> debugfs_create_*() functions. See f0fcf9ade46a ("crypto: qat - no need to check
> return value of debugfs_create functions"), where all checks after the
> debugfs_create_*() were removed.

Right.

> In this particular case, the check is present only to avoid attempting to
> create attributes if the directory is missing, since we know such an
> attempt will fail.

I think this is still buggy.  That if statement should be removed
as otherwise subsequent calls to debugfs_create_file will provide a
NULL parent dentry instead of an error parent dentry.  This causes
debugfs to do things differently.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
