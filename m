From: Marek Vasut <marex@denx.de>
Subject: Re: Crypto driver -DCP
Date: Mon, 8 Jun 2015 10:45:53 +0200
Message-ID: <201506081045.53449.marex@denx.de>
References: <554BBD05.3050807@freescale.com> <201506051638.03892.marex@denx.de> <20150608045200.GA25459@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jay Monkman <jay.monkman@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:51016 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbbFHIpw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Jun 2015 04:45:52 -0400
In-Reply-To: <20150608045200.GA25459@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday, June 08, 2015 at 06:52:00 AM, Herbert Xu wrote:
> On Fri, Jun 05, 2015 at 04:38:03PM +0200, Marek Vasut wrote:
> > In general, it would probably make sense to add a flag to .setkey() to
> > store the key in a keyslot. The keyslot allocation would be up to the
> > driver. In case all keyslots would be full, the setkey() with the flag
> > set would simply fail. This would imply you would need to have a
> > counterpart function to .setkey() to free keyslots -- something like
> > .unsetkey() .
> 
> Changing setkey is going to cause too much churn.  In any case
> I don't think these key slots should be written to by the kernel
> since the intention appears to be for entites outside the kernel
> to place secret keys in there that can then be used but not read
> by the kernel.

You mean like bootloader or you mean userspace code ? Maybe Jay
can explain how these slots are intended to be used. I'd like to
know the expected usecase.

> So as far as the kernel is concerned these are constant keys.
> 
> Therefore there should be no need for unsetkey.
> 
> So perhaps just add a new call setkey_slot that is optional and
> only needs to be implemented by drivers such as ccp.

Might work as well ... but let's maybe wait for the usecase.

Best regards,
Marek Vasut
