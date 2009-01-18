From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: libcrc32c should select crc32c
Date: Sun, 18 Jan 2009 16:37:13 +1100
Message-ID: <20090118053713.GB23663@gondor.apana.org.au>
References: <alpine.LSU.2.00.0901172346500.14505@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37458 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750838AbZARFhS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Jan 2009 00:37:18 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0901172346500.14505@fbirervta.pbzchgretzou.qr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 17, 2009 at 11:48:42PM +0100, Jan Engelhardt wrote:
>
> Looking at libcrc32c.c shows that it essentially depends on the
> crc32c crypto module, which was not packed into my initramfs image
> by mkinitrd because.. there is no dependency.

Actually the whole point of doing the crc32c/libcrc32c reversal
was to allow multiple providers of crc32c.  As it stands we have
a generic C version plus an Intel version.

So by applying yuor patch we'll go back to always using the C
version which is unacceptable.

I think a better way of tackling this is to note this information
explicitly in the module.  For example, just like module aliases
we can add explicit module dependencies.  mkinitrd can then use
this for its computation.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
