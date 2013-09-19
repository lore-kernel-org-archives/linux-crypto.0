From: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Subject: Re: crypto: GCM API usage
Date: Thu, 19 Sep 2013 17:33:16 -0300
Message-ID: <20130919203316.GA31494@oc8526070481.ibm.com>
References: <65abe254e199230984fd6a15dec39a76.squirrel@faumail.uni-erlangen.de>
 <20130916183411.GC3380@d-paulus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, tobias.polzer@fau.de,
	linux-kernel@i4.cs.fau.de
To: Dominik Paulus <dominik@d-paulus.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:51315 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3ISUd2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Sep 2013 16:33:28 -0400
Received: from /spool/local
	by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <mhcerri@linux.vnet.ibm.com>;
	Thu, 19 Sep 2013 17:33:25 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.13.184.25])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id 0BF411DC0063
	for <linux-crypto@vger.kernel.org>; Thu, 19 Sep 2013 16:33:22 -0400 (EDT)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
	by d24relay03.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r8JKVm8f50266344
	for <linux-crypto@vger.kernel.org>; Thu, 19 Sep 2013 17:31:48 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
	by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r8JKXKm8005797
	for <linux-crypto@vger.kernel.org>; Thu, 19 Sep 2013 17:33:21 -0300
Content-Disposition: inline
In-Reply-To: <20130916183411.GC3380@d-paulus.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 16, 2013 at 08:34:11PM +0200, Dominik Paulus wrote:
> Hi,
> 
> On Mon, Sep 16, 2013 at 12:58:40PM +0200, dominik.d.paulus@studium.uni-erlangen.de wrote:
> > We are currently trying to add encryption support to the usbip kernel
> > driver. Unfortunately, there is almost no documentation for the kernel
> > crypto API. So far, we couldn't figure out how to use the GCM encryption
> > mode in the kernel. There seems to be infrastructure for IV generation
> > in place (e.g. seqiv.c, the geniv stuff and the RFC 4106 implementation),
> > but no code directly using it.
> > 
> > What's the recommended way to use the IV generators with a "high-level"
> > API?
> 
> Sorry, that mail probably got a bit too short. To explain our problem a bit
> more: We are currently using a 64-bit counter to generate IVs. As the
> keys are randomly generated for each session and thus never reused,
> that's probably a not too bad idea (if it is, please tell us why ;)),
> assuming this counter is never going to overflow. We pass the IVs
> directly to aead_request_set_crypt for each message. This currently
> works quite fine.

It's usual the use of random IVs but I don't think that any known
pattern (as a counter) in the IV generation should cause any reduction
in the algorithm strength (and if it does, it's probably a weakness in
the algorithm itself). The only thing that should be avoided for sure is
the reuse of the same IV.

> 
> However, we would expect that IV generation is at least partially handled
> by the crypto API. As I said, there seems to be infrastructure for that,
> that abstracts the sequence number quite nicely. The seqiv generator
> seems to provide a high-level interface to the AEAD crypto, including an 
> abstraction for the sequence number generation. However, due to the lack
> of documentation and/or reference code using the API, we couldn't find
> out how to use it yet.

I haven't used the IV generation facility of the Crypto API, but it
seems to be very straightforward although there's no documentation
about that.

You should use aead_givcrypt_set_callback(), aead_givcrypt_set_assoc()
and aead_givcrypt_set_crypt() as you would use the regular aead
functions, that includes that you have to provide a buffer with length
equals to the algorithm block size for the IV. And then you should call
aead_givcrypt_set_giv() passing a counter and another IV buffer.

The difference between the two IV buffers that you have to provide to
aead_givcrypt_set_crypt() and aead_givcrypt_set_giv() is that the first
one will be updated by the algorithm during the encryption of each block
and the second one will contain the generated IV that you will have to
use to decrypt data.

The last step is to call crypto_aead_givencrypt() as you would call
crypto_aead_encrypt().

Under the cover the Crypto API will generate a random salt in the first
use of each request. This salt will be xor'd with the given counter to
create the new IV. That has an advantage over a simple count, that
usually will start with the same value every time the system is
rebooted.

> 
> Any help on this would be appreciated. If we feel competent enough to do 
> so after finishing this project, we would also volunteer to extend the
> introduction in Documentation/crypto/api-intro.txt a bit.
> 

That is probably a very good idea! I also want to improve the
documentation as soon I have some time to do it :)

> Regards,
>         Tobias Polzer and Dominik Paulus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
