From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCHv4 0/2] omap-sham: OMAP SHA1/MD5 driver
Date: Wed, 5 May 2010 11:38:50 -0700
Message-ID: <20100505183849.GB29604@atomide.com>
References: <cover.1272464135.git.dmitry.kasatkin@nokia.com>
 <20100503031139.GA31376@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>,
	linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:61187 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0EESjA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 May 2010 14:39:00 -0400
Content-Disposition: inline
In-Reply-To: <20100503031139.GA31376@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu <herbert@gondor.apana.org.au> [100502 20:07]:
> On Wed, Apr 28, 2010 at 05:18:05PM +0300, Dmitry Kasatkin wrote:
> > Changes to v4:
> > - concurrent requests support via queue
> > - hmac
> > - shash support removed
> > 
> > Dmitry Kasatkin (2):
> >   crypto: updates omap sham device related platform code
> >   crypto: omap-sham - omap sha1 & md5 driver
> 
> Both patches applied.  Thanks for all your hard work Dmitry!

Just noticed that the first patch should be updated:

CONFIG_ARCH_OMAP2 instead of CONFIG_ARCH_OMAP24XX
CONFIG_ARCH_OMAP3 instead of CONFIG_ARCH_OMAP34XX

BTW, chances are that this part will conflict with other
omap patches. But if that happens, we can move it to
the omap for-next.

Regards,

Tony
