From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: libcrc32c should select crc32c
Date: Tue, 20 Jan 2009 08:08:26 +1100
Message-ID: <20090119210826.GA6609@gondor.apana.org.au>
References: <alpine.LSU.2.00.0901172346500.14505@fbirervta.pbzchgretzou.qr> <20090118053713.GB23663@gondor.apana.org.au> <alpine.LSU.2.00.0901180910390.14063@fbirervta.pbzchgretzou.qr> <20090118204542.GA2978@uranus.ravnborg.org> <alpine.LSU.2.00.0901192050550.11601@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-crypto@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49650 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754406AbZASVIj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Jan 2009 16:08:39 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0901192050550.11601@fbirervta.pbzchgretzou.qr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 19, 2009 at 08:51:49PM +0100, Jan Engelhardt wrote:
>
> So what will the crypto subsystem try to do then, implementation-wise,
> given that kbuild cannot be manually tuned this way?

Well if nobody wants to do the work to get the explcit dependencies
than I suggest that you hardcode this into your mkinitrd.

The patch you gave initially is unacceptable because it means
that most people will be stuck with the unoptimised version.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
