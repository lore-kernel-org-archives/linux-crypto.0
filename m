From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Thu, 12 Jan 2017 16:56:04 +0100
Message-ID: <3051008.MbfH4VO98W@tauon.atsec.com>
References: <1486189.x0AQ4O6r2j@positron.chronox.de> <2789022.qIBfP2h8Cy@positron.chronox.de> <20170112155127.GA19252@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55490 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751045AbdALP4J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 10:56:09 -0500
In-Reply-To: <20170112155127.GA19252@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 12. Januar 2017, 23:51:28 CET schrieb Herbert Xu:

Hi Herbert,

> On Sun, Dec 25, 2016 at 06:15:06PM +0100, Stephan Müller wrote:
> > + * The following concept of the memory management is used:
> > + *
> > + * The kernel maintains two SGLs, the TX SGL and the RX SGL. The TX SGL
> > is
> > + * filled by user space with the data submitted via sendpage/sendmsg.
> > Filling + * up the TX SGL does not cause a crypto operation -- the data
> > will only be + * tracked by the kernel. Upon receipt of one recvmsg call,
> > the caller must + * provide a buffer which is tracked with the RX SGL.
> > + *
> > + * During the processing of the recvmsg operation, the cipher request is
> > + * allocated and prepared. To support multiple recvmsg operations
> > operating + * on one TX SGL, an offset pointer into the TX SGL is
> > maintained. The TX SGL + * that is used for the crypto request is
> > scatterwalk_ffwd by the offset + * pointer to obtain the start address
> > the crypto operation shall use for + * the input data.
> 
> I think this is overcomplicating things.  The async interface
> should be really simple.  It should be exactly the same as the
> sync interface, except that completion is out-of-line.
> 
> So there should be no mixing of SGLs from different requests.
>  Just start with a clean slate after each recvmsg regardless of
> whether it's sync or async.
> 
> The only difference in the async case is that you need to keep a
> reference to the old pages and free them upon completion.  But this
> should in no way interfere with subsequent requests.

That would mean that we would only support one IOCB.

At least with algif_skcipher, having multiple IOCBs would reduce the number of 
system calls user space needs to make for multiple plaintext / ciphertext 
blocks. But then, with the use of IOVECs, user space could provide all input 
data with one system call anyway.

Ok, I will update the patch as suggested.
> 
> Cheers,



Ciao
Stephan
