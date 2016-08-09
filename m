From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 09 Aug 2016 11:02:58 +0200
Message-ID: <2569442.q63FVBJjUH@tauon.atsec.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org> <4731753.YZZKimtrHM@tauon.atsec.com> <20160809085858.GA6172@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	Matt Mackall <mpm@selenic.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"jason@lakedaemon.net" <jason@lakedaemon.net>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34288 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbcHIJDC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 05:03:02 -0400
In-Reply-To: <20160809085858.GA6172@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 9. August 2016, 16:58:58 CEST schrieb Herbert Xu:

Hi Herbert,

> On Tue, Aug 09, 2016 at 10:07:29AM +0200, Stephan Mueller wrote:
> > Herbert, Matt, should such noise sources be added to the HW random
> > framework? The thing is that the in-kernel HW random to input_pool link
> > per default uses a more conservative entropy estimate than the user space
> > rngd. I would think that the in-kernel link would appropriate for that
> > rng. But the user space rngd tool with its default behavior is not really
> > suited here.
> 
> Yes hwrng would be the best fit, with a quality of zero to be safe.
> 
> Contrary to the quoted thread, there is no need to whiten the output
> /dev/hw_random.  It was always meant to go through some intermediate
> processing such as rngd before it is used.

But shouldn't the default of the rngd then be adjusted a bit?
> 
> Cheers,



Ciao
Stephan
