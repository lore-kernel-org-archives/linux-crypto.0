From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 9 Aug 2016 17:56:57 +0800
Message-ID: <20160809095657.GB6618@gondor.apana.org.au>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <1645997.7cVzaEi3NG@tauon.atsec.com>
 <20160809094656.GB6529@gondor.apana.org.au>
 <12791731.pG3fmEhvyp@tauon.atsec.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:38743 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165AbcHIJ5x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 05:57:53 -0400
Content-Disposition: inline
In-Reply-To: <12791731.pG3fmEhvyp@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 09, 2016 at 11:56:08AM +0200, Stephan Mueller wrote:
> Am Dienstag, 9. August 2016, 17:46:56 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> > 
> > You're supposed to tweak the quality of the input.  In any case,
> 
> How is that tweak supposed to happen? The rngd does not allow changing the 
> amount of read data relative to the assumed entropy.

Hmm, I guess it depends on your distro.  Some do.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
