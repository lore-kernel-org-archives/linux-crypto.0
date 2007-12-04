From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] Make crypto core API modular
Date: Tue, 4 Dec 2007 15:08:01 +0100
Message-ID: <20071204140801.GA9651@Chamillionaire.breakpoint.cc>
References: <20071201121910.GA8048@Chamillionaire.breakpoint.cc> <20071202150950.GA15213@Chamillionaire.breakpoint.cc> <20071204011035.GA29403@gondor.apana.org.au>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45832 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753268AbXLDOIH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Dec 2007 09:08:07 -0500
Content-Disposition: inline
In-Reply-To: <20071204011035.GA29403@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2007-12-04 12:10:35 [+1100]:

>However, could you please fix all the crypto users to select CRYPTO
>first? We can then do the modularisation for the next release.
I mailed two patches to netdev where modules where using crypto code and
were not selecting crypto in Kconfig. This is _now_ broken even before
this patch. Others seemed to be fine on the first look.

>I think we should also get rid of the ifdef CONFIG_CRYPTO because it
>has no legitimate uses.
Okey, I try to get rid of this and I will check the crypto users.

>Thanks,
Sebastian
