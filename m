From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 9 Aug 2016 17:46:56 +0800
Message-ID: <20160809094656.GB6529@gondor.apana.org.au>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <2569442.q63FVBJjUH@tauon.atsec.com>
 <20160809091755.GA6370@gondor.apana.org.au>
 <1645997.7cVzaEi3NG@tauon.atsec.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:41356 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbcHIJrt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 05:47:49 -0400
Content-Disposition: inline
In-Reply-To: <1645997.7cVzaEi3NG@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 09, 2016 at 11:37:39AM +0200, Stephan Mueller wrote:
> Am Dienstag, 9. August 2016, 17:17:55 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> 
> > On Tue, Aug 09, 2016 at 11:02:58AM +0200, Stephan Mueller wrote:
> > > But shouldn't the default of the rngd then be adjusted a bit?
> > 
> > Please elaborate.
> 
> in rngd_linux.c:random_add_entropy(void *buf, size_t size):
> 
>         entropy.ent_count = size * 8;
>         entropy.size = size;
>         memcpy(entropy.data, buf, size);
> 
>         if (ioctl(random_fd, RNDADDENTROPY, &entropy) != 0) {
> 
> ...
> 
> 
> in rngd.c:do_loop():
> 
>                         retval = iter->xread(buf, sizeof buf, iter);
> ...
>                         rc = update_kernel_random(random_step,
>                                              buf, iter->fipsctx);
> 
> where update_kernel_random simply invokes random_add_entropy in chunks.
> 
> Hence, the rngd reads some bytes from /dev/hwrand and injects it into /dev/
> random with an entropy estimate that is equal to the read bytes.
> 
> With less than perfect noise sources, entropy.ent_count should be much 
> smaller.

You're supposed to tweak the quality of the input.  In any case,
this is not affected by whether we whiten the result.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
