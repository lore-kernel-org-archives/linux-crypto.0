From: Bob Ham <bob.ham@collabora.com>
Subject: Re: [PATCH] hwrng: alea - Add support for Araneus Alea I USB RNG
Date: Thu, 02 Jun 2016 12:12:21 +0100
Message-ID: <1464865941.2437.14.camel@collabora.com>
References: <1464853939-7027-1-git-send-email-bob.ham@collabora.com>
	 <c68e0fd6-f12f-f127-1cc9-896ab7a3d079@ladisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-usb@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Keith Packard <keithp@keithp.com>
To: Clemens Ladisch <clemens@ladisch.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47959 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbcFBLMk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 07:12:40 -0400
In-Reply-To: <c68e0fd6-f12f-f127-1cc9-896ab7a3d079@ladisch.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2016-06-02 at 12:43 +0200, Clemens Ladisch wrote:
> Bob Ham wrote:
> > Adds support for the Araneus Alea I USB hardware Random Number
> > Generator.  This RNG creates entropy at a high rate, about 100kb/s.
> >
> > Signed-off-by: Bob Ham <bob.ham@collabora.com>
> > ---
> >
> > +++ b/drivers/char/hw_random/alea.c
> 
> Why didn't you just add the device ID to chaoskey.c?
> (Because that one is hidden in drivers/usb/misc? ;-)

Argh!  Because that one is hidden in drivers/usb/misc!  Pfft :-)

Thanks.

-- 
Bob Ham <bob.ham@collabora.com>
Software Engineer
Collabora

>>>>>>>>
Open First
Collabora is hiring!
Please check out our latest opportunities here:
http://bit.ly/Collabora-Careers
<<<<<<<<
