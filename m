From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 00/13] crypto: copy AAD during encrypt for AEAD ciphers
Date: Thu, 12 Jan 2017 16:50:46 +0100
Message-ID: <19793111.SdtrLVTG75@tauon.atsec.com>
References: <10526995.lyZ7Je1KMx@positron.chronox.de> <2819680.QEYfZCVF62@tauon.atsec.com> <20170112153924.GA16347@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55486 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750980AbdALPux (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 10:50:53 -0500
In-Reply-To: <20170112153924.GA16347@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 12. Januar 2017, 23:39:24 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Jan 12, 2017 at 04:34:39PM +0100, Stephan Müller wrote:
> > We would only be able to remove it if all AEAD implementations are
> > converted. But for the conversion time, we do face that issue.
> 
> It doesn't matter.  Nobody in the kernel uses that.  In fact I
> wonder whether we should even do it for the kernel API.  We only
> need it for the user-space API because it goes through read/write.

So you say that we could remove it from authenc() entirely (this is currently 
the only location where such copy operation is found for the encryption 
direction)?

I would concur that the kernel does not need that.
> 
> > Are you suggesting that the entire data in the src SGL is first copied to
> > the dst SGL by algif_aead? If yes, that still requires significant
> > src/dst SGL tinkering as we have the tag -- the src SGL for encrypt does
> > not have the tag space where the dst SGL for encrypt is required to have
> > the tag size. This is vice versa for the decryption operation.
> 
> It's really only a problem for decryption.  In that case you can
> extend the dst SG list to include the tag.

If we only want to solve that for algif_aead, wouldn't it make more sense if 
the user space caller takes care of that (such as libkcapi)? By tinkering with 
the SGLs and copying the data to the dst buffer before the cipher operation 
takes place, I guess we will add performance degradation and more complexity 
in the kernel.

Having such logic in user space would keep the algif_aead cleaner IMHO.

Ciao
Stephan
