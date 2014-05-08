From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 00/11] crypto: caam: Error reporting fixes
Date: Thu, 8 May 2014 16:50:08 +0200
Message-ID: <201405081650.08654.marex@denx.de>
References: <1398362722-16430-1-git-send-email-marex@denx.de> <20140508140106.GA13769@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Horia Geanta <horia.geanta@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:57311 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaEHPI7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 May 2014 11:08:59 -0400
In-Reply-To: <20140508140106.GA13769@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, May 08, 2014 at 04:01:06 PM, Herbert Xu wrote:
> On Thu, Apr 24, 2014 at 08:05:11PM +0200, Marek Vasut wrote:
> > First stab at reworking the error.c thing in Freescale CAAM.
> > This patchset cleans it up so it's not doing any too insane
> > string messing anymore.
> > 
> > NOTE: Can someone please test this on real hardware? I have
> > 
> >       none at hand, so THIS IS COMPILE-TESTED ONLY!
> > 
> > Marek Vasut (11):
> All applied.  Thanks Marek.

Thank you!

Best regards,
Marek Vasut
