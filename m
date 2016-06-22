From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH v10 2/3] crypto: kpp - Add DH software implementation
Date: Wed, 22 Jun 2016 08:18:42 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D0319366BB@IRSMSX102.ger.corp.intel.com>
References: <1466541931-2875-1-git-send-email-salvatore.benedetto@intel.com>
 <1466541931-2875-3-git-send-email-salvatore.benedetto@intel.com>
 <20160622005115.GB27134@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D03193664C@IRSMSX102.ger.corp.intel.com>
 <20160622064047.GA29318@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:35265 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbcFVISv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 04:18:51 -0400
In-Reply-To: <20160622064047.GA29318@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Wednesday, June 22, 2016 7:41 AM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [PATCH v10 2/3] crypto: kpp - Add DH software implementation
> 
> On Wed, Jun 22, 2016 at 06:37:50AM +0000, Benedetto, Salvatore wrote:
> >
> > Can you explain me the benefit in doing so?
> 
> The less code we have the better.  Most of our algorithm types have a single
> test function, I have seen no reason why kpp should be different.
> 
> akcipher has been an anomaly and I'm fixing it right now.
> 

Can't I send a smaller patch afterwards just for that?

> > I thought my patchset had reached an 'acceptable' state by now :-)
> 
> Now that the secret is encoded to a format under our control, you can
> generate byte-stream test vectors for both DH and ECDH using the same
> format.  So there is no need to have test functions specific to one algorithm.

If I have to pack the secret into a bytestream, where do you expect the endianness
of the sizes to be handled? If I understood you correctly I'll pack them in little endian,
but when decoding I have to take that into account. Wouldn't that result in pointless
endianness management in the decode functions?

Regards,
Salvatore
