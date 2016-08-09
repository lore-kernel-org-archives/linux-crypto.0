From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 9 Aug 2016 16:58:58 +0800
Message-ID: <20160809085858.GA6172@gondor.apana.org.au>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <4627645.oz3l49ICL3@tauon.atsec.com>
 <69af156ac93a4fe6ab1844dfcc35c266@aptaiexm02f.ap.qualcomm.com>
 <4731753.YZZKimtrHM@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	Matt Mackall <mpm@selenic.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"jason@lakedaemon.net" <jason@lakedaemon.net>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36445 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbcHIJAS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 05:00:18 -0400
Content-Disposition: inline
In-Reply-To: <4731753.YZZKimtrHM@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 09, 2016 at 10:07:29AM +0200, Stephan Mueller wrote:
> 
> Herbert, Matt, should such noise sources be added to the HW random framework? 
> The thing is that the in-kernel HW random to input_pool link per default uses 
> a more conservative entropy estimate than the user space rngd. I would think 
> that the in-kernel link would appropriate for that rng. But the user space 
> rngd tool with its default behavior is not really suited here.

Yes hwrng would be the best fit, with a quality of zero to be safe.

Contrary to the quoted thread, there is no need to whiten the output
/dev/hw_random.  It was always meant to go through some intermediate
processing such as rngd before it is used.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
