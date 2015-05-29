From: Marek Vasut <marex@denx.de>
Subject: Re: Crypto driver -DCP
Date: Fri, 29 May 2015 02:40:54 +0200
Message-ID: <201505290240.55075.marex@denx.de>
References: <554BBD05.3050807@freescale.com> <55673BF4.3040108@freescale.com> <20150529003700.GC14942@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jay Monkman <jay.monkman@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:57900 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbbE2Ak6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 20:40:58 -0400
In-Reply-To: <20150529003700.GC14942@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, May 29, 2015 at 02:37:00 AM, Herbert Xu wrote:
> On Thu, May 28, 2015 at 11:01:56AM -0500, Jay Monkman wrote:
> > Marek,
> > 
> > I have a question about the proper way to implement a feature. The
> > DCP has the ability to read a key for encryption/decryption from on
> > chip fuses. The current driver doesn't support this and as far as I
> > can tell, there's no clean way to do that within the Linux crypto
> > API.
> > 
> > Do you have any suggestions on how to handle that?
> > 
> > My best idea so far is to modify the driver so that if setkey is
> > passed a key with a length of 1 byte, the driver uses the on chip
> > key. I'm not sure if that would make it into the official kernel.
> 
> What is this key and who is supposed to have access to it?

It's an AES128 key stored in the CPU's OTP registers, so noone ought
to be able to read it out.

Best regards,
Marek Vasut
