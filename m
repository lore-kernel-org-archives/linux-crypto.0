From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: talitos: Prevent panic in probe error path
Date: Mon, 10 Aug 2015 23:41:08 +0800
Message-ID: <20150810154108.GB21143@gondor.apana.org.au>
References: <355366700.773095.1438811528320.JavaMail.zimbra@xes-inc.com>
 <1959818441.276958.1438886742548.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Christophe Leroy <christophe.leroy@c-s.fr>
To: Aaron Sierra <asierra@xes-inc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46060 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbbHJPlQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Aug 2015 11:41:16 -0400
Content-Disposition: inline
In-Reply-To: <1959818441.276958.1438886742548.JavaMail.zimbra@xes-inc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 06, 2015 at 01:45:42PM -0500, Aaron Sierra wrote:
>
> I just found this drvdata cleanup hasn't been required for a few years,
> due to the following commit:
> 
>     commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
>     Author: Hans de Goede <hdegoede@redhat.com>
>     Date:   Wed May 23 00:09:34 2012 +0200
> 
>         device-core: Ensure drvdata = NULL when no driver is bound
> 
> Should I submit a v3 patch without this cleanup, assuming there aren't
> other changes requested?

I have applied your patch with the dev_set_drvdata change removed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
