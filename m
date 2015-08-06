From: Aaron Sierra <asierra@xes-inc.com>
Subject: Re: [PATCH v2] crypto: talitos: Prevent panic in probe error path
Date: Thu, 6 Aug 2015 13:45:42 -0500 (CDT)
Message-ID: <1959818441.276958.1438886742548.JavaMail.zimbra@xes-inc.com>
References: <355366700.773095.1438811528320.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Christophe Leroy <christophe.leroy@c-s.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xes-mad.com ([216.165.139.218]:6960 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756016AbbHFSqu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2015 14:46:50 -0400
In-Reply-To: <355366700.773095.1438811528320.JavaMail.zimbra@xes-inc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> For completeness, this patch also sets device drvdata to NULL after
> the private structure is freed in talitos_remove().

[snip]

> @@ -2745,6 +2754,7 @@ static int talitos_remove(struct platform_device
> *ofdev)
>  	iounmap(priv->reg);
>  
>  	kfree(priv);
> +	dev_set_drvdata(dev, NULL);
>  
>  	return 0;
>  }

I just found this drvdata cleanup hasn't been required for a few years,
due to the following commit:

    commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
    Author: Hans de Goede <hdegoede@redhat.com>
    Date:   Wed May 23 00:09:34 2012 +0200

        device-core: Ensure drvdata = NULL when no driver is bound

Should I submit a v3 patch without this cleanup, assuming there aren't
other changes requested?

-Aaron
