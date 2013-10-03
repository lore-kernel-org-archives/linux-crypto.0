From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: Re: crypto: GCM API usage
Date: Thu, 3 Oct 2013 09:10:01 -0300
Message-ID: <20131003121001.GC8346@mhcerri.ibm.com>
References: <65abe254e199230984fd6a15dec39a76.squirrel@faumail.uni-erlangen.de>
 <20130916183411.GC3380@d-paulus.de>
 <20130919203316.GA31494@oc8526070481.ibm.com>
 <b2497b2c434ee21c2c700427f48cc398.squirrel@faumail.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dominik Paulus <dominik@d-paulus.de>, linux-crypto@vger.kernel.org,
	davem@davemloft.net, linux-kernel@i4.cs.fau.de
To: tobias.polzer@fau.de, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:49367 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab3JCMKL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Oct 2013 08:10:11 -0400
Received: from /spool/local
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Thu, 3 Oct 2013 09:10:08 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.13.184.25])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id C4F213520064
	for <linux-crypto@vger.kernel.org>; Thu,  3 Oct 2013 08:10:04 -0400 (EDT)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by d24relay03.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r93C8RUX48103474
	for <linux-crypto@vger.kernel.org>; Thu, 3 Oct 2013 09:08:27 -0300
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
	by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r93CA3vk011526
	for <linux-crypto@vger.kernel.org>; Thu, 3 Oct 2013 09:10:04 -0300
Content-Disposition: inline
In-Reply-To: <b2497b2c434ee21c2c700427f48cc398.squirrel@faumail.uni-erlangen.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 03, 2013 at 08:03:45AM +0200, tobias.polzer@fau.de wrote:
> > I haven't used the IV generation facility of the Crypto API, but it
> > seems to be very straightforward although there's no documentation
> > about that.
> >
> > You should use aead_givcrypt_set_callback(), aead_givcrypt_set_assoc()
> > and aead_givcrypt_set_crypt() as you would use the regular aead
> > functions, that includes that you have to provide a buffer with length
> > equals to the algorithm block size for the IV. And then you should call
> > aead_givcrypt_set_giv() passing a counter and another IV buffer.
> >
> > The difference between the two IV buffers that you have to provide to
> > aead_givcrypt_set_crypt() and aead_givcrypt_set_giv() is that the first
> > one will be updated by the algorithm during the encryption of each block
> > and the second one will contain the generated IV that you will have to
> > use to decrypt data.
> >
> > The last step is to call crypto_aead_givencrypt() as you would call
> > crypto_aead_encrypt().
> 
> We discovered those functions, yet the only way we found how to use them was
> to use one of the ipsec modes, e.g.:
> 	crypto_alloc_aead("rfc4106(gcm(aes))", 0, 0)
> 
> Is this the only way this API should be used, or is there some high level
> interface to use iv generators like seqiv?

In order to use IV generation, the targeted algorithm must specify a
generation method and the "plain" GCM implementation actually doesn't do
it.

Both rfc4106 and rfc4543 (gmac) say that the implementation "can use any
IV generation method that meets the uniqueness requirement without
coordinating with the receiver". I think that is the reason that only
these two variations of GCM explicitly define an IV generation method.

If I'm not wrong the Crypto API was first designed to support ipsec
needs, so it makes sense that it simplify things for it. However, I
don't see any reason for GCM itself not have a default IV generation
method, since regular and giv interfaces can be used.

So you should keep explicitly handling the IV generation or maybe submit
a patch adding a default geniv for GCM. I think Herbert can give us more
information about the "history" behind the geniv support and correct me
if I said anything wrong.

> 
> Thank you for your help,
> 	Dominik Paulus and Tobias Polzer
> 
