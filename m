From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v2
Date: Tue, 28 Oct 2008 17:49:32 -0500
Message-ID: <20081028174932.36f264c1.kim.phillips@freescale.com>
References: <1225158336-8777-1-git-send-email-jhsiao@amcc.com>
	<1225158932.4768.29.camel@jhsiao-usb>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: jhsiao@amcc.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:61083 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbYJ1Wkh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Oct 2008 18:40:37 -0400
In-Reply-To: <1225158932.4768.29.camel@jhsiao-usb>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 27 Oct 2008 18:55:32 -0700
James Hsiao <jhsiao@amcc.com> wrote:

> Hi All,
> 
> This patch was reviewed by Kim Phillips. 
> Kim suggest us submit this to linuxppc-dev for more review.

Are you going to send it?

use of device_type usage in the dts and dma_ mapping operations getting
passed NULL are just two examples of issues that are undergoing
transition in powerpc arch.

> > Signed-off-by: James Hsiao <jhsiao@amcc.com>
> > ---
> >  arch/powerpc/boot/dts/kilauea.dts       |   10 +-
> >  drivers/crypto/Kconfig                  |    9 +
> >  drivers/crypto/Makefile                 |    1 +
> >  drivers/crypto/amcc/Makefile            |   27 +
> >  drivers/crypto/amcc/crypto4xx_alg.c     |  404 ++++++++++
> >  drivers/crypto/amcc/crypto4xx_core.c    | 1220 +++++++++++++++++++++++++++++++
> >  drivers/crypto/amcc/crypto4xx_core.h    |  200 +++++
> >  drivers/crypto/amcc/crypto4xx_reg_def.h |  291 ++++++++
> >  drivers/crypto/amcc/crypto4xx_sa.c      |   98 +++
> >  drivers/crypto/amcc/crypto4xx_sa.h      |  223 ++++++

and please don't (a) top-post, and (b) leave the entire patch in your
reply.

Thanks,

Kim
