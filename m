From: Andreas Gerlich <agl@online.de>
Subject: Re: HIFN driver update.
Date: Tue, 11 Nov 2008 20:38:48 +0100
Message-ID: <4919DF48.9000703@online.de>
References: <20081111190553.GB18218@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:52477 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYKKTiz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Nov 2008 14:38:55 -0500
In-Reply-To: <20081111190553.GB18218@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

Evgeniy Polyakov wrote:
> Hi.
> 
> Updated version is based on old Patrick McHardy's patches, and contains
> several bug fixes from me.
> Great thanks to Andreas Gerlich (agl_online.de), who provided remote
> access to the machine with the HIFN card in.
> 
> Now it is very stable and passed lots of stress tests for the last several days.

I let running the 'stress' processes and I start an additional copy
process with 30 GB to the crypted partition and let this running in the
next days, to see if the machine keeps stable.

> Patch includes unaligned fixes, ring size changes, watchdog update,
> backlog processing fixes, dma cleanups.
> 
> Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
> 
> diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
> index 4d22b21..3900a3c 100644
> --- a/drivers/crypto/hifn_795x.c
> +++ b/drivers/crypto/hifn_795x.c
> @@ -38,9 +38,6 @@
>  .......

Best Regards
Andreas Gerlich
-- 
Andreas Gerlich, University of Ulm, Germany
open source project --> http://yaze-ag.de/ (Yet Another Z80 Emulator)
