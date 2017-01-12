From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Thu, 12 Jan 2017 23:51:28 +0800
Message-ID: <20170112155127.GA19252@gondor.apana.org.au>
References: <1486189.x0AQ4O6r2j@positron.chronox.de>
 <2789022.qIBfP2h8Cy@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36723 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750791AbdALPvn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 10:51:43 -0500
Content-Disposition: inline
In-Reply-To: <2789022.qIBfP2h8Cy@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 25, 2016 at 06:15:06PM +0100, Stephan Müller wrote:
>
> + * The following concept of the memory management is used:
> + *
> + * The kernel maintains two SGLs, the TX SGL and the RX SGL. The TX SGL is
> + * filled by user space with the data submitted via sendpage/sendmsg. Filling
> + * up the TX SGL does not cause a crypto operation -- the data will only be
> + * tracked by the kernel. Upon receipt of one recvmsg call, the caller must
> + * provide a buffer which is tracked with the RX SGL.
> + *
> + * During the processing of the recvmsg operation, the cipher request is
> + * allocated and prepared. To support multiple recvmsg operations operating
> + * on one TX SGL, an offset pointer into the TX SGL is maintained. The TX SGL
> + * that is used for the crypto request is scatterwalk_ffwd by the offset
> + * pointer to obtain the start address the crypto operation shall use for
> + * the input data.

I think this is overcomplicating things.  The async interface
should be really simple.  It should be exactly the same as the
sync interface, except that completion is out-of-line.

So there should be no mixing of SGLs from different requests.
 Just start with a clean slate after each recvmsg regardless of
whether it's sync or async.

The only difference in the async case is that you need to keep a
reference to the old pages and free them upon completion.  But this
should in no way interfere with subsequent requests.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
