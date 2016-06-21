From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH v9 2/3] crypto: kpp - Add DH software implementation
Date: Tue, 21 Jun 2016 20:57:41 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D031936469@IRSMSX102.ger.corp.intel.com>
References: <1466174265-4546-1-git-send-email-salvatore.benedetto@intel.com>
 <1466174265-4546-3-git-send-email-salvatore.benedetto@intel.com>
 <20160620111524.GB10601@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D03193586D@IRSMSX102.ger.corp.intel.com>
 <20160620234900.GA18131@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23848 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbcFUU6D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 16:58:03 -0400
In-Reply-To: <20160620234900.GA18131@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Tuesday, June 21, 2016 12:49 AM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [PATCH v9 2/3] crypto: kpp - Add DH software implementation
> 
> On Mon, Jun 20, 2016 at 11:43:28AM +0000, Benedetto, Salvatore wrote:
> >
> > > While you're at it, it would be nice if you could make the encoded
> > > format little-endian, that way we can make test vectors for all kpp
> > > algorithms use the same format.
> > >
> >
> > The input format is the same for DH and ECDH.
> > Only the software implementation of ECC requires little-endian format.
> 
> What I mean is to get rid of the DH-specific code in testmgr.c and directly
> encode the secret into the test vector rather than calling the helper.

I prefer to have both DH and ECDH data explicitly encoded with the helpers.
One reason is that it will be less work for me when I'll add other curves support
to ECDH. If you don't have any strong objections I'd rather leave it as it for now. 

Regards,
Salvatore
