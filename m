From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/2] hwrng: chaoskey - Add support for Araneus Alea I USB
 RNG
Date: Tue, 7 Jun 2016 15:03:11 -0700
Message-ID: <20160607220311.GB4744@kroah.com>
References: <1464952388-2405-1-git-send-email-bob.ham@collabora.com>
 <20160607105345.GE520@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bob Ham <bob.ham@collabora.com>, linux-crypto@vger.kernel.org,
	linux-usb@vger.kernel.org, Keith Packard <keithp@keithp.com>,
	Matt Mackall <mpm@selenic.com>,
	Clemens Ladisch <clemens@ladisch.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652AbcFGWDN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2016 18:03:13 -0400
Content-Disposition: inline
In-Reply-To: <20160607105345.GE520@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 07, 2016 at 06:53:45PM +0800, Herbert Xu wrote:
> On Fri, Jun 03, 2016 at 12:13:06PM +0100, Bob Ham wrote:
> > Two patches to add support for the Araneus Alea I USB RNG to the
> > chaoskey driver.  The first simply includes the Alea I as a device,
> > the second fixes an issue with the timeout on the first read.
> > 
> > Bob Ham (2):
> >   hwrng: chaoskey - Add support for Araneus Alea I USB RNG
> >   hwrng: chaoskey - Fix URB warning due to timeout on Alea
> > 
> >  drivers/usb/misc/Kconfig    | 11 ++++++-----
> >  drivers/usb/misc/chaoskey.c | 21 +++++++++++++++++++--
> >  2 files changed, 25 insertions(+), 7 deletions(-)
> 
> Both applied.  Thanks.

Ok, but usually drivers/usb/misc/ patches go through my tree :)
