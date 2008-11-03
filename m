From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: IPsec books and how to add async hardware encryption ?
Date: Mon, 3 Nov 2008 14:13:16 +0300
Message-ID: <20081103111316.GA19920@ioremap.net>
References: <200810311508.48703.djenkins@mvista.com> <20081031203251.GC32720@ioremap.net> <200811031050.59710.djenkins@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dean Jenkins <djenkins@mvista.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cet.com.ru ([195.178.208.66]:37872 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbYKCLNT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Nov 2008 06:13:19 -0500
Content-Disposition: inline
In-Reply-To: <200811031050.59710.djenkins@mvista.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Dean.

On Mon, Nov 03, 2008 at 10:50:59AM +0000, Dean Jenkins (djenkins@mvista.com) wrote:
> > cryptd is an software engine example of how hardware driver could be
> > implemented.
> 
> Are you saying that to implement an async hardware driver I could use the APIs 
> used by cryptd and create my own hwcryptd ?

Yes for the APIs used in cryptd, but usually hardware driver does not
need to have any threads attached, since completion of the event is
handled in the interrupt handler.

> If yes, is there any documentation for the APIs used by cryptd ?

No, there is no documentation except source code.
In some files you can even find this comments:

         * HEAVY TODO: needs to kick Herbert XU to write documentation.

Herbert is a crypto maintainer who created async crypto interfaces you
found in cryptd. You can also check hardware crypto drivers in
drivers/crypto/ directory.

-- 
	Evgeniy Polyakov
