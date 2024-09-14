Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159F61CF280
	for <linux-crypto@vger.kernel.org>; Sat, 14 Sep 2024 11:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726314050; cv=none; b=iwZg1xzjrzvAv7xh7QoZ9h0B+hvXUSwFigCHw8tH1Zz2TT6HFay0tj5PcuDo3MNcFjCsJrf5o7AT95BvS5OLSMB+ppsqQaKLzNMvvEME7ciQE8tTDZPxT6044KtVDlGTwydZN7cTrdBt7A08Wo9jMphQgm50c/LGLb+Nwr4n5dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726314050; c=relaxed/simple;
	bh=70Z3jWbmNHWPqOpw4lJieUmR3n9PiHh25KcbULcWcms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rwnrQMy60HWDGQn9QR07zGODv5iM8d7wyUpUbtsrqf5XmZqmPKhDIjQsFoIZaWIRp0zmZbgciBSzOtZ0bdk1bwlutf5lEZ/SzZ5op39ofGjPuIN7ee24ejgWs9AM1EQx2fvqQiDVnVgQ9heIPRXV5ThVHQVv5NBE0A0She8YlC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=f/01Dqx4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="f/01Dqx4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IWZaBejBgP6lOezZyPT98JihsSrHbTbh94fvQnPuy2M=; b=f/01Dqx47Yd/ofh54BVtbMnuQ0
	glqnOL5ChKnIB09zdBeOAMMKxM0Yo5imzMwunsKdBIGntGjHIPUl+uct3XWKQm//MA+d8Ux0BaLNJ
	I7s6kxvtmfjhHXkQuSNdjQe16UuT6e64wiiUEEf5iNvL3mlRxxmuz22+JWIufVe0vVCAPX1HIh8YB
	O7VIZsQQe9ogBMXZWKrlMu25ignqr78VQfQaSiEZ13O3FvJS7N+8/uP7R6/brsdybl4yRLUyAKCAN
	uraZN1z2u/fKDsPkfdkOvdk8B9T4GklYfw4Q2aNo14HHkMdkl5VPHtnJRX9eCTXfYmPRY44jcYlsF
	u5QWgpRA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1spQyn-002Sdh-2n;
	Sat, 14 Sep 2024 19:40:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Sep 2024 19:40:31 +0800
Date: Sat, 14 Sep 2024 19:40:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
	Li Zetao <lizetao1@huawei.com>, davem@davemloft.net,
	lucas.segarra.fernandez@intel.com, damian.muszynski@intel.com,
	qat-linux@intel.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH -next] crypto: qat - remove redundant null pointer checks
 in adf_dbgfs_init()
Message-ID: <ZuV2L2WQXSEgcsy6@gondor.apana.org.au>
References: <20240903144230.2005570-1-lizetao1@huawei.com>
 <ZuQRqP9CgDp7cuGi@gondor.apana.org.au>
 <ZuRRxIjK8WMvStJ+@gcabiddu-mobl.ger.corp.intel.com>
 <ZuVL5buxgkqSEzPU@gondor.apana.org.au>
 <2024091452-freight-irritant-f160@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024091452-freight-irritant-f160@gregkh>

On Sat, Sep 14, 2024 at 10:50:33AM +0200, Greg Kroah-Hartman wrote:
>
> > I think this is still buggy.  That if statement should be removed
> > as otherwise subsequent calls to debugfs_create_file will provide a
> > NULL parent dentry instead of an error parent dentry.  This causes
> > debugfs to do things differently.
> 
> debugfs, if something goes wrong, will return a real error, never NULL,
> so any return value from a call can be passed back in.

Right, that's why we should remove the if statement so that the
error is saved and can then be passed back into the next debugfs
call.

With the error-checking if statement there, the error is discarded
and the next debugfs call from this driver will simply get a NULL
parent dentry.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
