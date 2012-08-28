From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 5/5] crypto: talitos - add IPsec ESN support
Date: Tue, 28 Aug 2012 08:52:13 -0700
Message-ID: <20120828155213.GA15705@gondor.apana.org.au>
References: <1344440805-20324-1-git-send-email-horia.geanta@freescale.com>
 <20120808202215.da5ef82b25f655956cabae80@freescale.com>
 <20120820083212.GE22951@gondor.apana.org.au>
 <FD18E5D573A8AB48A365D4D78185DE992E16AB@039-SN1MPN1-001.039d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
To: Geanta Neag Horia Ioan-B05471 <B05471@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:48619 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752909Ab2H1PwS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Aug 2012 11:52:18 -0400
Content-Disposition: inline
In-Reply-To: <FD18E5D573A8AB48A365D4D78185DE992E16AB@039-SN1MPN1-001.039d.mgd.msft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 28, 2012 at 03:47:19PM +0000, Geanta Neag Horia Ioan-B05471 wrote:
>
> What about patches [1-4]/5 ?
> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg07507.html
> 
> Patch 5/5 won't work without these.
> 4/5 adds "support for handling non-contiguous assoc data and iv", which is
> exactly how native IPsec submits SPI + ESN to talitos.

Oops, I picked up your v2 which only had the last patch.  I'll fix
this up.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
