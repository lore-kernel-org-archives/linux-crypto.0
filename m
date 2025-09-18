Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF547199934
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 02:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758162429; cv=none; b=exLyzmZFk7cOuu4e12y+iqma+dibGAEX9J6P9062hJYe5Ru3a47Qv/4ujTJY+YKg9Ljh4y+OCXE3jQFD/nHa5joHvTVdu8sOatt5/HTJ8bUVwrQagObO1C/IniPK0JTCf5gyRylWasYeUykCBbtb47X4f8lyBTEGtOEJT+ivE44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758162429; c=relaxed/simple;
	bh=XxD0q6HFEHNIr8aBx8Jg0tnEaTeqkBLEGtDsG8B8vvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6wFv39XaXpf6AyFhE48LnBmOY0HTkJv/IHQPH3L4DePyLkB/gJuTgYL9r8yjYmu/+PT6nokcb9FqMiz2m9M6kXRDG/ZHt/MQ0rNzBppZkjlWpWhYHeMj33U618V2kd51fgLO5ivkJGHa2iibutHmATXi2ixKL5BwEpQ2KKB0Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IpAcLjQM; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IpAcLjQM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g797N7w8ENsnFBqwK0Hg/d/C3j11AzpRyBlxY2uwLp0=; b=IpAcLjQMIPXnP5+Jf8xercvlnI
	5zz0WcdKxCJK37NVhYtEF6d/+5h0W0Sf4bkwdSD9rzhxplWKLRdCQtLGE7Q8WnfGOjYKqBe+bZ6uB
	FtgjrtZstv7QUy8VOck0dDBh8rDPjsicKUT8r/gSXG39hDgyXKszEXBuHKw5NImn/vogns9aXL4Bg
	QIuP/jQU69PPONKRaYPfzAyfuoZw1OUN85N7sqDAGk47TLExDv9p9bQIKNKkoGFejAPG6x6WqxK4T
	I6x5YvFJt3vOkokjPJ3ccZEhqepLvjbuuwtm9pmvbYyJgzR2Aq5TiXe/2vH5xRXtbZqI/KdpxJq/o
	KCKDwouA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uz46y-006LDq-38;
	Thu, 18 Sep 2025 10:27:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 18 Sep 2025 10:27:01 +0800
Date: Thu, 18 Sep 2025 10:27:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Thorsten Blum <thorsten.blum@linux.dev>, qat-linux@intel.com
Subject: Re: [PATCH] crypto: qat - Return pointer directly in
 adf_ctl_alloc_resources
Message-ID: <aMtt9X6jWR1IKBW6@gondor.apana.org.au>
References: <aMTyFx91lhp9galJ@gondor.apana.org.au>
 <aMqh+eZrRvyLQGUF@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMqh+eZrRvyLQGUF@gcabiddu-mobl.ger.corp.intel.com>

On Wed, Sep 17, 2025 at 12:56:41PM +0100, Giovanni Cabiddu wrote:
>
> I don't see this warning with W=1 on gcc 15.2.1,
>     make M=drivers/crypto/intel/qat W=1 -j
> What version is reporting this warning?

It's not visible with W=1 because uninitialized warnings are
disabled by default.  I saw them with

make KBUILD_CFLAGS_KERNEL=-Wmaybe-uninitialized CFLAGS_MODULE=-Wmaybe-uninitialized

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
