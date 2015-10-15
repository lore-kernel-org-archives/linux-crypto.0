From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/5] crypto: ensure algif_hash does not pass a
 zero-sized state
Date: Thu, 15 Oct 2015 21:13:38 +0800
Message-ID: <20151015131338.GA3901@gondor.apana.org.au>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
 <E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
 <20151013143312.GA7903@gondor.apana.org.au>
 <20151015093930.GA32532@n2100.arm.linux.org.uk>
 <20151015094147.GA2157@gondor.apana.org.au>
 <20151015125944.GB32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
	Horia Geant? <horia.geanta@freescale.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46749 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbbJONN7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 09:13:59 -0400
Content-Disposition: inline
In-Reply-To: <20151015125944.GB32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 15, 2015 at 01:59:44PM +0100, Russell King - ARM Linux wrote:
>
> I think the CAAM driver is pretty unfixable from a trivial point of
> view.  This driver exports a huge amount of state - it contains both a
> struct caam_hash_ctx and a struct caam_hash_state, which totals up to
> 1600 bytes.  This fails the:

Right just dumping the state out as is not going to work.  This
is not supposed to be how export works anyway.  But it doesn't
look too bad as most of that 1600 is consumed by the hardware
program descriptor which can easily be regenerated upon import.

The only things that need to be exported AFAICS are key and buf_X.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
