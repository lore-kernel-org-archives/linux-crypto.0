From: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v3 1/2] i.MX27: Add clock support for SAHARA2.
Date: Mon, 11 Mar 2013 00:08:56 +0100
Message-ID: <20130310230856.GU1906@pengutronix.de>
References: <1362137873-8827-1-git-send-email-javier.martin@vista-silicon.com>
 <1362137873-8827-2-git-send-email-javier.martin@vista-silicon.com>
 <20130304075306.GA1906@pengutronix.de>
 <CACKLOr2kuWXMreEFA4wqyYVRNnPwmEoHPM2+V+tN5P_1bQ+iJQ@mail.gmail.com>
 <20130310083401.GB10448@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: javier Martin <javier.martin@vista-silicon.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	davem@davemloft.net, kernel@pengutronix.de, gcembed@gmail.com,
	shawn.guo@linaro.org, arnd@arndb.de, swarren@nvidia.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39831 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab3CJXJM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Mar 2013 19:09:12 -0400
Content-Disposition: inline
In-Reply-To: <20130310083401.GB10448@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Mar 10, 2013 at 04:34:01PM +0800, Herbert Xu wrote:
> > >
> > > https://patchwork.kernel.org/patch/1817741/
> > >
> > > So the change above becomes unnecessary
> > 
> > Very good. Then this patch can be safely dropped.
> 
> So should I take this patch or not?

This clk patch, no. The sahara patch, yes, if it is fine for you.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
