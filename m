Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBA9231CB1;
	Sat,  5 Oct 2024 05:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106708; cv=none; b=WXkM+SQjC9irSJ370cgVnbxTl17xtTTrG1/vCfXNYTSZ+3W6iTeeWswAdazf9ZQ3RbNIc11XzNVQinEWcArPGZ1Pf2CMUBhUcGQctEgGqHuDB5wt8tq1lUOioiLnTjAD4LY2iuazOm4bIU4K6Btva7Tay1i5b+S0psAIhYuMJx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106708; c=relaxed/simple;
	bh=GuNaRBdFMs8lMZr3MaJoINKTCUdS8t/qVVasobkQHxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gsrXRwc+1OEdAZlJak3bf9EX/lP+0NFr2B6U+MRHr69A7Hk4RK1UPyg8nH1fE1ZXuKddm3SRfUNNofDfoV+60GqNAK1P+hPbmj+OFerJ1mSdFrHGZB7GdCWRxWOkyX4prRJZuPseHLipbbMd5ZXmNOUzeNS3oxZtiHacujgc1pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dwSibZ2q; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dwSibZ2q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3TkvKOMXMhj3hu2Uvd5oDasxBleh5BTiSZLRAR5JBlg=; b=dwSibZ2qrNCN4o7FfSG88tBZB/
	p9qFANUGDUMzseOgtOGie2P8Yc5KBDneOU8QgDpqBIsTnI8ED9RhSMLRAx+wlvjpBWD2jc9inr8lU
	CA1M5MUR0M8nVLQ0PUGz9HJXLoNzr/7dQ3c6q335E51B/Sk8ZCpOztAl9whrJatpSvugI99qhZZbR
	009RD0kSoW0ErmiMdZOG0F158VqzzBo3isewpiN9RZ9XhF0Y98/hy8aFiUYs8ygjGHbO1C/OUxYg3
	vmsNdrby55wnfrLDZkRTQ32213nQTXgCpapo1ud0i40QgMGUM8aIwp5Q3s2oYeR1p4IAk0WGPCDnT
	xJSNdE7Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxKo-0071cm-11;
	Sat, 05 Oct 2024 13:38:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:38:19 +0800
Date: Sat, 5 Oct 2024 13:38:19 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Zanussi, Tom" <tom.zanussi@linux.intel.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>,
	zanussi@kernel.org
Subject: Re: [PATCH 0/2] iaa_crypto bugfix and maintainer change
Message-ID: <ZwDQy-9lz9tzcnA8@gondor.apana.org.au>
References: <733a19ce-16f2-4d06-bce9-85d7473c9a4d@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <733a19ce-16f2-4d06-bce9-85d7473c9a4d@linux.intel.com>

On Fri, Sep 27, 2024 at 01:45:42PM -0500, Zanussi, Tom wrote:
> Hi Herbert,
> 
> The first patch here fixes a bug seen on some systems with broken IAA
> hardware; it doesn't fix the hardware issue itself but exposes an
> issue with trusting the hardware to either send a completion or
> trigger a timeout - if neither happens, it shouldn't spin endlessly.
> 
> The second patch hands over iaa_crypto maintainership, since I'll be
> retiring from Intel and won't have access to IAA hardware myself.
> 
> Thanks,
> 
> Tom
> 
> Tom Zanussi (2):
>   crypto: iaa - Remove potential infinite loop in check_completion()
>   MAINTAINERS: Make Kristen Accardi the IAA crypto driver maintainer
> 
>  MAINTAINERS                                |  2 +-
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 10 ++++++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> -- 
> 2.38.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
