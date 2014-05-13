From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: s5p-sss: fix multiplatform build
Date: Tue, 13 May 2014 19:45:10 +0800
Message-ID: <20140513114510.GA22078@gondor.apana.org.au>
References: <4525493.CM3akEXMYf@wuerfel>
 <000701cf6d8a$399b0990$acd11cb0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Arnd Bergmann' <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	"'David S. Miller'" <davem@davemloft.net>,
	'Naveen Krishna Chatradhi' <ch.naveen@samsung.com>,
	'Tomasz Figa' <t.figa@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	'Vladimir Zapolskiy' <vz@mleia.com>
To: Jingoo Han <jg1.han@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:42654 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaEMLp0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 May 2014 07:45:26 -0400
Content-Disposition: inline
In-Reply-To: <000701cf6d8a$399b0990$acd11cb0$%han@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 12, 2014 at 11:31:05AM +0900, Jingoo Han wrote:
> On Friday, May 09, 2014 8:36 PM, Arnd Bergmann wrote:
> > 
> > As we are preparing to enable multiplatform support on EXYNOS,
> > we can no longer include mach/*.h or plat/*.h headers from device
> > drivers.
> > 
> > The s5p-sss driver was just enabled for EXYNOS when it used to
> > be used only on s5pv210, and it includes two samsung platform
> > specific header files for historic reasons. Fortunately, it no
> > longer actually needs them, so we can remove the #includes and
> > avoid the problem
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> > Cc: Tomasz Figa <t.figa@samsung.com>
> > Cc: <linux-samsung-soc@vger.kernel.org>
> > Cc: Vladimir Zapolskiy <vz@mleia.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> 
> I checked that these machine specific headers are
> unnecessary. Thanks!
> 
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
