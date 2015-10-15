From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/5] crypto: ensure algif_hash does not pass a
 zero-sized state
Date: Thu, 15 Oct 2015 17:41:47 +0800
Message-ID: <20151015094147.GA2157@gondor.apana.org.au>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
 <E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
 <20151013143312.GA7903@gondor.apana.org.au>
 <20151015093930.GA32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42397 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbbJOJmF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 05:42:05 -0400
Content-Disposition: inline
In-Reply-To: <20151015093930.GA32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 15, 2015 at 10:39:30AM +0100, Russell King - ARM Linux wrote:
>
> The CAAM driver is similarly buggy - it has export/import functions in
> its ahash drivers, but zero statesize.
> 
> User exploitable kernel stack smashing... I'd suggest putting this patch
> into stable kernels as high priority, as I'm pretty sure this could be

I agree.  It should already be on its way to stable as Linus has
pulled it into his tree and it carries a stable cc.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
