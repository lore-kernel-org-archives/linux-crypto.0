From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/2] crypto: bfin_crc: ignore duplicated registration
 of the same algorithm
Date: Wed, 16 Apr 2014 21:49:34 +0800
Message-ID: <20140416134934.GE4684@gondor.apana.org.au>
References: <1397208625-23522-1-git-send-email-sonic.adi@gmail.com>
 <201404111133.37451.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sonic Zhang <sonic.adi@gmail.com>, linux-crypto@vger.kernel.org,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:52067 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277AbaDPNtg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Apr 2014 09:49:36 -0400
Content-Disposition: inline
In-Reply-To: <201404111133.37451.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 11, 2014 at 11:33:37AM +0200, Marek Vasut wrote:
> On Friday, April 11, 2014 at 11:30:25 AM, Sonic Zhang wrote:
> > From: Sonic Zhang <sonic.zhang@analog.com>
> > 
> > in case of multiple crc devices are probed.
> > Call platform_set_drvdata() before adding new CRC device into the list.
> > 
> > Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> > ---
> > v3-change:
> > - check list_is_singular() before register the algorithm
> > 
> >  drivers/crypto/bfin_crc.c | 18 +++++++++---------
> >  1 file changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
> > index cea3e8c..892b6d2 100644
> > --- a/drivers/crypto/bfin_crc.c
> > +++ b/drivers/crypto/bfin_crc.c
> > @@ -665,19 +665,19 @@ static int bfin_crypto_crc_probe(struct
> > platform_device *pdev) if (timeout == 0)
> >  		dev_info(&pdev->dev, "init crc poly timeout\n");
> > 
> > +	platform_set_drvdata(pdev, crc);
> > +
> >  	spin_lock(&crc_list.lock);
> >  	list_add(&crc->list, &crc_list.dev_list);
> >  	spin_unlock(&crc_list.lock);
> > 
> > -	platform_set_drvdata(pdev, crc);
> > -
> > -	ret = crypto_register_ahash(&algs);
> > -	if (ret) {
> > -		spin_lock(&crc_list.lock);
> > -		list_del(&crc->list);
> > -		spin_unlock(&crc_list.lock);
> > -		dev_err(&pdev->dev, "Cann't register crypto ahash device\n");
> > -		goto out_error_dma;
> > +	if (list_is_singular(&crc_list.dev_list)) {
> > +		ret = crypto_register_ahash(&algs);
> > +		if (ret) {
> > +			dev_err(&pdev->dev,
> > +				"Cann't register crypto ahash device\n");
> 
> "Cann't" with two Ns ;-/
> 
> Well, add "Reviewed-by: Marek Vasut <marex@denx.de>" into the next go please :)

Both patches applied and I've fixed the typo.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
