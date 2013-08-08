From: Garg Vakul-B16394 <B16394@freescale.com>
Subject: RE: Questions about the Crypto API
Date: Thu, 8 Aug 2013 14:50:41 +0000
Message-ID: <065BBB7616BCE543832A2EF096986B940A05ADCD@039-SN2MPN1-011.039d.mgd.msft.net>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:44729
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757850Ab3HHOwF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Aug 2013 10:52:05 -0400
In-Reply-To: <20130806070010.GB19754@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert


> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Herbert Xu
> Sent: Tuesday, August 06, 2013 12:30 PM
> To: Marcelo Cerri
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: Questions about the Crypto API
> 
> On Mon, Aug 05, 2013 at 05:25:57PM -0300, Marcelo Cerri wrote:
> >
> > My first doubt is regarding which kind of concurrency the Crypto API
> > allows. For example, can a single `struct crypto_tfm` be used by two
> > concurrent calls? I'm asking about that because I noticed that for
> 
> Yes.
> 

In this post, you mentioned that tfm is single threaded.
Am I misinterpreting your statement?

http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg08689.html



> > blkcipher the only implementation-specific context that can be used is
> > allocated inside the tfm struct.
> 
> Both blkcipher and ablkcipher are meant to be fully reentrant.
> So you must take necessary precautions if your implementation is not
> reentrant, e.g., by locking.
> 
> > I'm working to fix some bugs in the NX driver (located in
> > drivers/crypto/nx), and one issue that we are facing is that NFS when
> > using Kerberos uses the same tfm with different kthreads. That causes
> > concurrent accesses to the internal data stored into the context and
> > incorrect results.
> >
> > So my question here is: should this type of concurrency be handled by
> > the driver or a caller is not allowed to use the same tfm for
> > concurrent calls?
> 
> From what you've said NFS seems to be doing the right thing, so the bug
> would be in the driver.
> 
> > My second doubt is regarding the difference between ablkcipher and
> > blkcipher. I do understand their difference from caller's point of
> view.
> > But I'm not sure what are the consequences of implementing a driver
> > using one or another option.
> >
> > For example, can a blkcipher implementation be used asynchronously and
> > vice versa?
> 
> In general which model you pick for drivers depend on what your hardware
> looks like.  For example, padlock-aes uses the blkcipher model because
> the hardware presents itself through a synchronous CPU instruction, while
> most other drivers use the ablkcipher interface because the underlying
> hardware completes asynchronously.
> 
> A blkcipher implementation is always available through both the blkcipher
> and the ablkcipher interface.  While an ablkcipher implementaiton can
> only be used through the ablkcipher interface.
> 
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto"
> in the body of a message to majordomo@vger.kernel.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html
