From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: talitos_probe hangs
Date: Tue, 5 May 2009 12:49:13 -0500
Message-ID: <20090505124913.b7f75e55.kim.phillips@freescale.com>
References: <728619.83165.qm@web50504.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@redhat.com>
To: kishor_ravula@yahoo.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:37221 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbZEERty (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 May 2009 13:49:54 -0400
In-Reply-To: <728619.83165.qm@web50504.mail.re2.yahoo.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 4 May 2009 23:01:23 -0700 (PDT)
Ravula Kishor <kishor_ravula@yahoo.com> wrote:

> I am using ltib-20080811 (2.6.25 kernel) . I am porting it to custom board based on mcf5474. I observed that talitos_probe hangs during the kernel initialization.
> 
> Is it a known issue. 

so the the mcf5474 utilizes SEC h/w version 1.1 (or a variant thereof),
with which the talitos driver is currently incompatible. Even if
you've managed to fake the device tree node properties, the driver has
the master reset bit in a different position than the one on the
mcf547x, so it doesn't even know how to reset the device properly.

you might try entering a ticket with the freescale coldfire support
web - who knows, they might be willing to assist you in porting the
driver to handle sec h/w versions < 2.0.  AFAIK, various registers,
various bits within registers, and the descriptor submission method
differ in the h/w, and the driver needs to double as a platform
driver for coldfire arch.

Kim
