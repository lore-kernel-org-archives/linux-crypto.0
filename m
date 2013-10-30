From: "Fernandes, Joel" <joelf@ti.com>
Subject: RE: [RFC] Unaligned CTR mode tests in crypto/testmgr.h
Date: Wed, 30 Oct 2013 18:34:34 +0000
Message-ID: <083BC63EECB6FD41B8E81CF7FD87CC0F2E56A7A9@DLEE08.ent.ti.com>
References: <52704EAB.5000308@ti.com>
 <20131030015424.GA1855@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "jussi.kivilinna@mbnet.fi" <jussi.kivilinna@mbnet.fi>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45810 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab3J3Seo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Oct 2013 14:34:44 -0400
In-Reply-To: <20131030015424.GA1855@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.hengli.com.au]
> Sent: Tuesday, October 29, 2013 8:54 PM
> To: Fernandes, Joel
> Cc: jussi.kivilinna@mbnet.fi; linux-crypto@vger.kernel.org
> Subject: Re: [RFC] Unaligned CTR mode tests in crypto/testmgr.h
> 
> Joel Fernandes <joelf@ti.com> wrote:
> > Hi,
> >
> > Some tests such as test 5 in AES CTR mode in crypto/testmgr.h have a
> > unaligned input buffer size such as 499 which is not aligned to any > 0
> power of 2.
> >
> > Due to this, omap-aes driver, and I think atmel-aes too error out when
> > encryption is requested for these buffers.
> >
> > pr_err("request size is not exact amount of AES blocks\n") or a similar
> message.
> >
> > Is this failure considered a bug? How do we fix it?
> 
> Set your alignmask correctly and the crypto API will align the input buffer for
> you.

Thanks! I'll try this today and follow up with a patch if I can get past the error.

Regards,

-Joel
