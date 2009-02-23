From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1 v8] Add CryptoAPI User Interface Support v8
Date: Mon, 23 Feb 2009 21:53:44 +0800
Message-ID: <20090223135344.GA12776@gondor.apana.org.au>
References: <DB599F406D04E34389140B7D99C71B1B06F2B86C@SDCEXCHANGE01.ad.amcc.com> <20090128044634.GE13157@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D605D3F8FD@SDCEXCHANGE01.ad.amcc.com> <20090223093558.GC10515@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Evgeniy Polyakov <zbr@ioremap.net>,
	Shasi Pulijala <spulijala@amcc.com>
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39609 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754259AbZBWNxs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Feb 2009 08:53:48 -0500
Content-Disposition: inline
In-Reply-To: <20090223093558.GC10515@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 23, 2009 at 05:35:58PM +0800, Herbert Xu wrote:
>
> 4. Operate.
> 
> 	sendmsg(fd, msg, flags);
> 
> Here struct msghdr provides for both the IOV array and space for
> ancillary information.

In fact we should take this one step further.  Instead of having
write/send do both input as well as output, it should just do the
former.  That is, we should call read/recv to get the output.

This might seem a step backwards, but in fact it's the only sane
way to do zero-copy.  In order to get zero copy with this, you'd
use splice instead of write (the setup can be done with the usual
corking method), and the receive side would use vmsplice + splice.

You might argue that this is too much overhead.  However, it isn't
because

1) For the cases where you have less than a page of data, just
use send/recv as the overhead of the copy is dwarfed by the overhead
of the rest of the crypto operation.

2) Where zero-copy does matter the setup overhead is immaterial.

Of course to make vmsplice + splice work, we don't want to start
the operation until the first read request from the user is issued.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
