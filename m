From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos: Prevent panic in probe error path
Date: Tue, 4 Aug 2015 15:18:05 +0800
Message-ID: <20150804071805.GA29697@gondor.apana.org.au>
References: <985540634.83104.1438363661992.JavaMail.zimbra@xes-inc.com>
 <296998949.155413.1438375938630.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Christophe Leroy <christophe.leroy@c-s.fr>
To: Aaron Sierra <asierra@xes-inc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50960 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbbHDHSV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Aug 2015 03:18:21 -0400
Content-Disposition: inline
In-Reply-To: <296998949.155413.1438375938630.JavaMail.zimbra@xes-inc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 31, 2015 at 03:52:18PM -0500, Aaron Sierra wrote:
>
> @@ -2905,8 +2919,7 @@ static int talitos_probe(struct platform_device *ofdev)
>  	priv->reg = of_iomap(np, 0);
>  	if (!priv->reg) {
>  		dev_err(dev, "failed to of_iomap\n");
> -		err = -ENOMEM;
> -		goto err_out;
> +		return -ENOMEM;
>  	}

This is the only bit that seems remotely related to your change
description.  Please ensure that your patch actually corresponds
to your changelog and do not include unrelated changes without
documenting them.

And even this bit is wrong because you're leaking priv.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
