From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Padlock SHA1 failed at boot time
Date: Mon, 21 Sep 2009 18:56:05 -0700
Message-ID: <20090922015605.GA26922@gondor.apana.org.au>
References: <20090921061324.GA16944@gondor.apana.org.au> <4AB73020.1050403@e-teleport.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: technique@e-teleport.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55030 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751671AbZIVB4I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2009 21:56:08 -0400
Content-Disposition: inline
In-Reply-To: <4AB73020.1050403@e-teleport.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 21, 2009 at 09:49:52AM +0200, S=E9guier R=E9gis wrote:
>
> it's good for me now.

Thanks for confirming! I'll push it with this changelog

crypto: padlock-sha - Fix stack alignment

The PadLock hardware requires the output buffer for SHA to be
128-bit aligned.  We currentply place the buffer on the stack,
and ask gcc to align it to 128 bits.  That doesn't work on i386
because the kernel stack is only aligned to 32 bits.  This patch
changes the code to align the buffer by hand so that the hardware
doesn't fault on unaligned buffers.

Reported-by: S=E9guier R=E9gis <rguier@e-teleport.net>
Tested-by: S=E9guier R=E9gis <rguier@e-teleport.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
