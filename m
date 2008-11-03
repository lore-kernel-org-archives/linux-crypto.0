From: Dean Jenkins <djenkins@mvista.com>
Subject: Re: IPsec books and how to add async hardware encryption ?
Date: Mon, 3 Nov 2008 10:50:59 +0000
Message-ID: <200811031050.59710.djenkins@mvista.com>
References: <200810311508.48703.djenkins@mvista.com> <20081031203251.GC32720@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:58699 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbYKCKvD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Nov 2008 05:51:03 -0500
In-Reply-To: <20081031203251.GC32720@ioremap.net>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Evgeniy,

> > Also, how do I find info on the cypto APIs eg. how to use cryptd (2.6.24
> > kernel) ?
> >
> > I'm working on a project that uses an embedded hardware encryption engine
> > that needs to use async off-load. Is cryptd the entity for async hardware
> > crypto off-loading ?
>
> cryptd is an software engine example of how hardware driver could be
> implemented.

Are you saying that to implement an async hardware driver I could use the APIs 
used by cryptd and create my own hwcryptd ?

If yes, is there any documentation for the APIs used by cryptd ?

Thanks,

Regards,
Dean Jenkins
MontaVista Software 
