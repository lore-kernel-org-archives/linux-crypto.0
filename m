From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 2/3] ARM: mxs: crypto: Add Freescale MXS DCP driver
Date: Sun, 1 Dec 2013 23:20:43 +0100
Message-ID: <201312012320.43292.marex@denx.de>
References: <1380194306-5243-1-git-send-email-marex@denx.de> <201311101848.12215.marex@denx.de> <20131120112010.GA20958@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Christoph G. Baumann" <cb@sgoc.de>, linux-crypto@vger.kernel.org,
	Shawn Guo <shawn.guo@linaro.org>,
	Fabio Estevam <festevam@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Tobias Rauter <tobiasrauter@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:33651 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab3LAW5z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Dec 2013 17:57:55 -0500
In-Reply-To: <20131120112010.GA20958@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

[...]

> > > I can do that. I wonder if we can't agree to nuke the in-tree driver
> > > altogether instead and replace it by this one though. Does it not sound
> > > more reasonable?
> > 
> > Bump?
> 
> Well as it's been months and nobody has stepped up to maintain
> the in-tree driver then yes we can get rid of it.

OK, I updated the DCP patches and re-posted them. Thanks!

Best regards,
Marek Vasut
