From: Stephan Mueller <smueller@chronox.de>
Subject: Re: mxs-dcp: Failed to register sha1 hash
Date: Thu, 26 Nov 2015 16:25:30 +0100
Message-ID: <160969925.mts3FEnayM@myon.chronox.de>
References: <CAOMZO5AyAAfZM07KYHCfRaeia8Ut1F6s=jsFg6C3YYzHx8C5UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Marek =?utf-8?B?VmHFoXV0?= <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34595 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbbKZPZe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Nov 2015 10:25:34 -0500
In-Reply-To: <CAOMZO5AyAAfZM07KYHCfRaeia8Ut1F6s=jsFg6C3YYzHx8C5UA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 26. November 2015, 13:14:12 schrieb Fabio Estevam:

Hi Fabio,

> Hi,
> 
> On kernel 4.1.13 and also on 4.4.0-rc2-next-20151126 I see the
> following error on mx28:
> 
> [    2.245453] mxs-dcp 80028000.dcp: Failed to register sha1 hash!
> [    2.253928] mxs-dcp: probe of 80028000.dcp failed with error -22
> 
> Does anyone have any idea how to fix this?

Briefly looking into drivers/crypto/mxs-dcp.c, it is an ahash and does not 
contain halg.statesize in the algo definitions. Thus it looks very much like 
the same issue that I see with ghash.


-- 
Ciao
Stephan
