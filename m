From: Marek Vasut <marex@denx.de>
Subject: Re: Crypto driver -DCP
Date: Mon, 1 Jun 2015 15:24:03 +0200
Message-ID: <201506011524.03531.marex@denx.de>
References: <554BBD05.3050807@freescale.com> <201505291502.59208.marex@denx.de> <20150529133018.GB20596@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jay Monkman <jay.monkman@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:48918 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbbFANim (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 09:38:42 -0400
In-Reply-To: <20150529133018.GB20596@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, May 29, 2015 at 03:30:18 PM, Herbert Xu wrote:
> On Fri, May 29, 2015 at 03:02:59PM +0200, Marek Vasut wrote:
> > This does look somewhat hacky to me. Wouldn't it make more sense to
> > add a CRYPTO_TFM_REQ flag ?
> 
> What are you going to do when you have more than one hard-coded
> key? A flag is a non-starter.

Well, abusing a non-well-defined part of the API is also not a nice
way to do it. Maybe we should consider some other -- third -- option ?

Best regards,
Marek Vasut
