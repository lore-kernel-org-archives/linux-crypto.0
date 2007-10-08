From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1 take 2] HIFN 795x driver.
Date: Mon, 8 Oct 2007 11:15:10 +0800
Message-ID: <20071008031510.GA32087@gondor.apana.org.au>
References: <20071002150013.GA6023@2ka.mipt.ru> <20071006215857.GB3645@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1579 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752864AbXJHDPP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Oct 2007 23:15:15 -0400
Content-Disposition: inline
In-Reply-To: <20071006215857.GB3645@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Oct 06, 2007 at 11:58:57PM +0200, Sebastian Siewior wrote:
> * Evgeniy Polyakov | 2007-10-02 19:00:13 [+0400]:
> 
> >+MODULE_LICENSE("GPL");
> >+MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
> >+MODULE_DESCRIPTION("Driver for HIFN 795x crypto accelerator chip.");
> 
> Please also add MODULE_ALIAS for algos (that was aes, des and 3des as
> far as I remember).

Actually this one should register aliases of "cbc(aes)", etc. as
it doesn't implement plain old AES.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
