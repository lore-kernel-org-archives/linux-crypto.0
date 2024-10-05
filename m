Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB34443AB9;
	Sat,  5 Oct 2024 05:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106794; cv=none; b=M67U8bzq1WyYXP0DosxMa+t3ikmt242b5pR4I1RwXTZ72M5gBqZpiB88k+YwGERR4N2dyB/bweHgHR0N0znrMuRxeOa6srmyYr+BJYx4Q+DvEG7IkBWsKX84QhuNuNHwERpkzP4SxR3sYUT4XEndP5RnLArZNlEIUq4pO+q+Lqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106794; c=relaxed/simple;
	bh=hmMRCplK2Hd1mpUgm6GTZ2NIVzGMtd9wk5+sEZS3ER4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhqZFmaqCDRkxNFhgXx1EkuTK0QwwRQtpNjeoZrK56UvN8MeZPAIKSBCiV5dsipPrew/tsUfb7mW+LuyQLkuE5Qm0Pb7VMqpBWVaRnSXYRKu8cu6DNLIQsXC43Q7fnlHjZQ2NF+zxekydUcGg+0x5fW5+B6jsMhekdYMwXn0pPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rC/Uvyw9; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rC/Uvyw9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4llMdeemsu6f+K97h5abfDouAwV3Yebvw9H3iLwRW2w=; b=rC/Uvyw93YjQuvQgpE3Pc0zeOJ
	OpoxkUcbULXYkBXgTNBVsJ8X7nNw15zF8HvV3U5m9cDTqnvYRJGMXP/vlAs8aowYqPRnrcuj3bDfM
	yMuJrJ9LSkiRTpxHSNsEdmoDokXoFTXOfZl2b7uDcpDdfv86gOpJ7Mq0cDPgokmatVpikzthVI4n0
	+Tgty2Ty0bmAQKue3Qjxfop+IFLscJspyLkUIm6Ip/KlCuSqHdGgb7bsWQaK9ZoXbKu7vt/iFaJj4
	mFiQndYKHAAYQAAH7vNUqDQ1B1L3HfwH1sunF1dyg8N/f/sL6z0q3M1SlDxihDzDkV4lXFTnOTPml
	wAzX2NVg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxM7-0071de-2p;
	Sat, 05 Oct 2024 13:39:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:39:41 +0800
Date: Sat, 5 Oct 2024 13:39:41 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Tero Kristo <tero.kristo@linux.intel.com>,
	Jie Wang <jie.wang@intel.com>,
	Shashank Gupta <shashank.gupta@intel.com>,
	Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Adam Guerin <adam.guerin@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - (qat_4xxx) fix off by one in uof_get_name()
Message-ID: <ZwDRHX1334pV8B9N@gondor.apana.org.au>
References: <cca43549-7715-44ba-a1c0-61dd027ed3b5@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cca43549-7715-44ba-a1c0-61dd027ed3b5@stanley.mountain>

On Sat, Sep 28, 2024 at 01:05:08PM +0300, Dan Carpenter wrote:
> The fw_objs[] array has "num_objs" elements so the > needs to be >= to
> prevent an out of bounds read.
> 
> Fixes: 10484c647af6 ("crypto: qat - refactor fw config logic for 4xxx")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
