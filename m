Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0261B2040BF
	for <linux-crypto@vger.kernel.org>; Fri, 21 Feb 2025 09:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740129855; cv=none; b=ZQ3h10Difjxuh5QtHCofMV5RDBN2H7gjC4ezTax3aRLoLGfJamdgEdIWB20DXFMiMtz21ZGGlWFp0G9XDBw3M9wpLpayJ4eQ9lj82eC3kii3HTR30da93CYvxgPImYJ7jIiXaW0IUXVvqx/4BYnhKvKQzbsuUKumteXMvvc8Dz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740129855; c=relaxed/simple;
	bh=einN6J0nkRLIwaY+N/IzB5qg2t741wpwt//3sf27+2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGoAdSAIKxt8jFTISA56nhkCx2g34xDsnurEDSkMrg9H2KsIJU1ARMO767A4I+eNI6PD33bsvqS2n5R2rtNXJhq9CjYGAuQuVX8HqoAFtFyRRioXI2qGGW2hjp6SnIs9r/trdOQsQzDAwyJu71QZRM3/zrxWvnSedL2gxf7F3Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Zm/dcOKf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Zm/dcOKf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=X1Hwcy3+046hTAutic8nhrolX9IE+MqUXOHeHrq4izA=; b=Zm/dcOKfOfFSxAyvYyCkGDPM8T
	66cOYVNALziUfjrDbNzBcCzqAucaiQsaz4zwVscAOAseZ4JktrvBfHa5RX0l/MbNbNciRSpf3VxUv
	t8+SyRYQs4XKTphJ5u2J+hDzabpdAuD1vzs+w7EzgAknH1S2wgSmC+14O1OUXe5YOGl+6vKYiXmFB
	v6RfzTZGvDbGrMsx53graUc/QSJWrIFRv3K9D9Sy37mE8/3yJWpJYUWi4n1ZKW1AMomqIOKx+gctM
	fnUpxjuHfpTh4J4gYVpE97OC2q8ZrRvx7TR6wsT3svMTwma7r4n7grqUsMPxBXssVNKYYo8tDlWMe
	5Q2FB+dg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tlPGT-000YMg-1E;
	Fri, 21 Feb 2025 17:24:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Feb 2025 17:24:09 +0800
Date: Fri, 21 Feb 2025 17:24:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, andriy.shevchenko@intel.com,
	qat-linux@intel.com
Subject: Re: [PATCH 0/2] crypto: qat - improvements to Makefiles
Message-ID: <Z7hGOe2nHG2hrYhW@gondor.apana.org.au>
References: <20250211095952.14442-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211095952.14442-1-giovanni.cabiddu@intel.com>

On Tue, Feb 11, 2025 at 09:58:51AM +0000, Giovanni Cabiddu wrote:
> This small series aligns the Makefiles in the QAT driver to the kbuild
> documentation, by fixing the object goals, and reorders the objects in
> the qat_common Makefile for making it easier to maintain.
> 
> Patch #1 does not have an explicit Fixes tag as there isn't any
> outstanding issue caused by the current Makefiles.
> 
> Giovanni Cabiddu (2):
>   crypto: qat - fix object goals in Makefiles
>   crypto: qat - reorder objects in qat_common Makefile
> 
>  drivers/crypto/intel/qat/qat_420xx/Makefile   |  2 +-
>  drivers/crypto/intel/qat/qat_4xxx/Makefile    |  2 +-
>  drivers/crypto/intel/qat/qat_c3xxx/Makefile   |  2 +-
>  drivers/crypto/intel/qat/qat_c3xxxvf/Makefile |  2 +-
>  drivers/crypto/intel/qat/qat_c62x/Makefile    |  2 +-
>  drivers/crypto/intel/qat/qat_c62xvf/Makefile  |  2 +-
>  drivers/crypto/intel/qat/qat_common/Makefile  | 66 +++++++++----------
>  .../crypto/intel/qat/qat_dh895xcc/Makefile    |  2 +-
>  .../crypto/intel/qat/qat_dh895xccvf/Makefile  |  2 +-
>  9 files changed, 41 insertions(+), 41 deletions(-)
> 
> -- 
> 2.48.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
