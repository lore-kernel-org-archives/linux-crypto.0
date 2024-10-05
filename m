Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2700938F83;
	Sat,  5 Oct 2024 05:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728106453; cv=none; b=Mc256h4OFXiO2vSPa6UfH2m1dt7lZoPt5BxzJZRVKPP7Fgp/O5E5p1iQlCjetjXjESlAJXg/15mMbXwE9R7xiw2VO95PbVsz9sEGVo1LImIyhxwmkypUpGm9bvvziClQXsc57nZUE9hMECZXAV0sPlDdbjpAEfqhSDsf/GwK8Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728106453; c=relaxed/simple;
	bh=RISXuUmm4MwpRlpsCZYj/PJe8WMr0ju0zPqu91euvaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uePZU2JajJyVDxwsMNpcCrJvHZ9rfmfRJdUIXviTDf0Fd2jbA9XvJF3ihPVHDunvGD7PnMHv0K0S7tnn+R9l70meS3Ggu/dDocB4r9M29A7mA3bA1M249laaJDhRVtTpcLmmdRYLIEdL5AoVucZQNkgo8J3mplhClJESyJ47SEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AW7qRkV8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AW7qRkV8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3106WfcoB/CM8AXxFDJvSUQmcbul0VQskSTRUwA6BEw=; b=AW7qRkV827Pv5p+h6uIibqtqsI
	v78knfqT2hvanlhq6TH1YfJWzi6zSafOD7mYdsGe5w1UkZf2Y9OCj8jhLAOwpoAF0tXCM4yh7fCBS
	XpstcT+GFs2mKB8ypgFvQnriNNMm0mDGTlhAQZYMy60pBG5rmAqkDVsDO5usaiUZ6J1Bq/83cO/42
	zD3uu9ObUn6U2D/v7qUcX8I5AMVMVohnuVkN8HcRLAdD2zHe376C+MgNwdL02oSD89BJT1K2NDH6J
	KxdARiiv1LOEX6H0kCvzbAl7gPIBzY0SmX23OL4PAxJKCWUpVV2SiVHV2tbtf0+6YRjKlGNmet+yh
	Z01huFRQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1swxGa-0071a9-1R;
	Sat, 05 Oct 2024 13:33:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2024 13:33:58 +0800
Date: Sat, 5 Oct 2024 13:33:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: Drop explicit initialization of struct
 i2c_device_id::driver_data to 0
Message-ID: <ZwDPxhnIiZuome3n@gondor.apana.org.au>
References: <20240918123150.1540161-10-u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240918123150.1540161-10-u.kleine-koenig@baylibre.com>

On Wed, Sep 18, 2024 at 02:31:52PM +0200, Uwe Kleine-König wrote:
> These drivers don't use the driver_data member of struct i2c_device_id,
> so don't explicitly initialize this member.
> 
> This prepares putting driver_data in an anonymous union which requires
> either no initialization or named designators. But it's also a nice
> cleanup on its own.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> ---
>  drivers/crypto/atmel-ecc.c     | 2 +-
>  drivers/crypto/atmel-sha204a.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
