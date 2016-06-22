From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH v10 2/3] crypto: kpp - Add DH software implementation
Date: Wed, 22 Jun 2016 10:06:32 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D0319367A3@IRSMSX102.ger.corp.intel.com>
References: <1466541931-2875-1-git-send-email-salvatore.benedetto@intel.com>
 <1466541931-2875-3-git-send-email-salvatore.benedetto@intel.com>
 <20160622005115.GB27134@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D03193664C@IRSMSX102.ger.corp.intel.com>
 <20160622064047.GA29318@gondor.apana.org.au>
 <309B30E91F5E2846B79BD9AA9711D0319366BB@IRSMSX102.ger.corp.intel.com>
 <20160622100341.GA30383@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9907 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbcFVKSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 06:18:49 -0400
In-Reply-To: <20160622100341.GA30383@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Wednesday, June 22, 2016 11:04 AM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [PATCH v10 2/3] crypto: kpp - Add DH software implementation
> 
> On Wed, Jun 22, 2016 at 08:18:42AM +0000, Benedetto, Salvatore wrote:
> >
> > If I have to pack the secret into a bytestream, where do you expect
> > the endianness of the sizes to be handled? If I understood you
> > correctly I'll pack them in little endian, but when decoding I have to
> > take that into account. Wouldn't that result in pointless endianness
> management in the decode functions?
> 
> It is not pointless if it means that we can have a single test function like most
> other types.

It is pointless because it will only be used for the testmanager.
I can merge the test functions but I'll still have two set_secret functions
based on the alg value. Would that be enough for you?

Regards,
Salvatore 
