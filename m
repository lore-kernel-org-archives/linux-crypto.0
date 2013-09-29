From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 2/3] ARM: mxs: crypto: Add Freescale MXS DCP driver
Date: Mon, 30 Sep 2013 00:09:50 +0200
Message-ID: <201309300009.51084.marex@denx.de>
References: <1380194306-5243-1-git-send-email-marex@denx.de> <1380194306-5243-2-git-send-email-marex@denx.de> <CAOMZO5A4rH_id25ROU_CdiOd79MhtU9J3jtFVyqeeD0R+=EuTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"David S. Miller" <davem@davemloft.net>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:49766 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3I2WJv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Sep 2013 18:09:51 -0400
In-Reply-To: <CAOMZO5A4rH_id25ROU_CdiOd79MhtU9J3jtFVyqeeD0R+=EuTw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Fabio Estevam,

[...]

> > + * There can even be only one instance of the MXS DCP due to the
> > + * design of Linux Crypto API.
> 
> Is this true? Usually we don't want to create a global struct.

Yeah, unfortunatelly :-(

> 
> > +
> > +/* AES 128 ECB and AES 128 CBC */
> > +static struct crypto_alg dcp_aes_algs[] = {
> > +       [0] = {
> 
> No need for explicitely add this [0]

I wanted to be explicit here, but OK.

[...]

Rest is fixed, thanks!

Best regards,
Marek Vasut
