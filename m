Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF25184F;
	Wed, 23 Apr 2025 03:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745379888; cv=none; b=tEkzgT0P6vmE/8CCysVf0XtY3dyCRYyNRcnTU7oJDvu4Fqtx54Q7nrhLkKsZSSd+auBblOJyxgrU3/Pp60L7mHyag9YjoJzJdE3Ed/jkAxGyNy+4hXCQMgOZHHb/YwQGG/YejpDFpqrHoAADt6UHLu+Wbw8uJToRRkC1wmEUNY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745379888; c=relaxed/simple;
	bh=Osj0BgG+zkkOZi8EpZPPH+c9dAzhV9IjVmwCfZOxpXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sp9njy3P+iHn5edDiaQBOjcVRWae94eKSYOFSuKsKfgMiBt/O9NRdz+5nlo0gPhy3Xy3uuOMKW4xDJPb+XlowfjHtG+sBup1VMMpgIjNS/qU2gP/FePZoAZTAl3LbFXj1sDLc8KH71aRXFNF2TMCMXHvZ98Aju2gdBn0+7dMFO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lGDRan0G; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lGDRan0G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0IAtNTiiFTmvO98YCSYKal+t4z989el2HhkhKwvm5Hc=; b=lGDRan0GVPrqzl/s7gkJFCtaIO
	L+lPy9CATcfgM8J9fm457VdtsXvwivAZT7sqMcV6jrmFdIzxF63QuJMDxo+62w8HvCY15FU5qKFvm
	Yb1cGl8TkZrGDL1NJC4gswmhaiLiNUe1VPxvKMgjE05iO5JQypwv9qDdlr3zSZbzXBnDsoC16PHcA
	N9q75nh/eVb90y2012wFuJvwFOjrzgIY0DZ+CH2Pvg+ChwfYMNOorEpXcAWzNsbeOVf7T6ADz+APi
	Q4HLDg2qz2MSXDVoZZkrO2Rsal4U5SUnQzplE55gkq1z5h5Z57cZXWvz5suAE9yQACF4emr/RZG8E
	IxZox5sg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7R2M-000Gkm-2R;
	Wed, 23 Apr 2025 11:44:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Apr 2025 11:44:38 +0800
Date: Wed, 23 Apr 2025 11:44:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>
Subject: Re: Usage of crypto_engine APIs
Message-ID: <aAhiJmKTrBiA-Qu7@gondor.apana.org.au>
References: <01aad6ee-3885-486d-b7b6-2f78b61373bf@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01aad6ee-3885-486d-b7b6-2f78b61373bf@ti.com>

On Tue, Apr 22, 2025 at 12:16:55PM +0530, T Pratham wrote:
> Hi
> 
> I was reading into crypto engine APIs from the kernel documentation as well as other crypto drivers using them, for their proper usage. I found some seemingly contradictory stuff from both sources.
> 
> [1] says the following:
> > You must put, at the start of your transform context your_tfm_ctx, the structure crypto_engine:

That comment is obsolete:

commit e5e7eb023f24653b07329162b6359283b3a03a20
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Aug 13 14:54:49 2023 +0800

    crypto: engine - Move crypto_engine_ops from request into crypto_alg

For an example of what the driver should look like see:

commit 07e34cd39282af37160c978abf18308d5bb287e3
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Aug 13 14:54:51 2023 +0800

    crypto: sun8i-ce - Use new crypto_engine_op interface

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
