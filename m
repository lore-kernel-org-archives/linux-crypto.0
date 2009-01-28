From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v5
Date: Wed, 28 Jan 2009 14:59:37 +1100
Message-ID: <20090128035937.GA13157@gondor.apana.org.au>
References: <1231788650.5533.16.camel@jhsiao-usb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kim.phillips@freescale.com, jwboyer@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org
To: James Hsiao <jhsiao@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40811 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751557AbZA1D7v (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Jan 2009 22:59:51 -0500
Content-Disposition: inline
In-Reply-To: <1231788650.5533.16.camel@jhsiao-usb>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 12, 2009 at 11:30:50AM -0800, James Hsiao wrote:
> This is the 5th submission of AMCC's security driver.
> - remove aad support in build pd function, since we didn't release any
> algorithm that use aead yet.
> 
> - changed some hardcode value to #defines
> 
> - changed local_irq_disable/enable to spinlock_irq_save/restore
> 
> - fixed bug in crypto4xx_probe on error exit.
> 
> 
> Signed-off-by: James Hsiao <jhsiao@amcc.com>

I was going to apply this but you didn't give me a changelog
that I can throw into the tree without feeling guilty!

Please always attach a proper changelog with each submission
so I don't have to do this.  You can put the changelog elsewhere
in the email.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
