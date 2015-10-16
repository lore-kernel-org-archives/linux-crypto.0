From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: Re: [PATCH v3 1/5] crypto: ensure algif_hash does not pass a
 zero-sized state
Date: Fri, 16 Oct 2015 16:24:54 -0700
Message-ID: <20151016162454.64d1102514dfc9c84a9d8be1@freescale.com>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
	<E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
	<20151013143312.GA7903@gondor.apana.org.au>
	<20151015093930.GA32532@n2100.arm.linux.org.uk>
	<20151015094147.GA2157@gondor.apana.org.au>
	<20151015125944.GB32532@n2100.arm.linux.org.uk>
	<20151015131338.GA3901@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Horia Geant? <horia.geanta@freescale.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bbn0105.outbound.protection.outlook.com ([157.56.111.105]:36252
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751492AbbJPXZH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Oct 2015 19:25:07 -0400
In-Reply-To: <20151015131338.GA3901@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 15 Oct 2015 21:13:38 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Thu, Oct 15, 2015 at 01:59:44PM +0100, Russell King - ARM Linux wrote:
> >
> > I think the CAAM driver is pretty unfixable from a trivial point of
> > view.  This driver exports a huge amount of state - it contains both a
> > struct caam_hash_ctx and a struct caam_hash_state, which totals up to
> > 1600 bytes.  This fails the:
> 
> Right just dumping the state out as is not going to work.  This
> is not supposed to be how export works anyway.  But it doesn't
> look too bad as most of that 1600 is consumed by the hardware
> program descriptor which can easily be regenerated upon import.
> 
> The only things that need to be exported AFAICS are key and buf_X.

I just pushed out a patch for export/import functions in the CAAM driver. The
patch has been through testing with OpenSSL and the AF_ALG plugin on the MX6.

> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Victoria Milhoan <vicki.milhoan@freescale.com>
