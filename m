From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: fix AEAD tag memory handling
Date: Fri, 28 Oct 2016 00:20:29 +0200
Message-ID: <4087872.10iu4A8UFE@tauon.atsec.com>
References: <4006219.iWaCqWYv1B@positron.chronox.de> <alpine.OSX.2.20.1610271419040.52583@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47040 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942481AbcJ0WUe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 18:20:34 -0400
In-Reply-To: <alpine.OSX.2.20.1610271419040.52583@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 27. Oktober 2016, 14:42:14 CEST schrieb Mat Martineau:

Hi Mat,

> Stephan and Herbert,
> 
> On Thu, 27 Oct 2016, Stephan Mueller wrote:
> > Hi Herbert,
> > 
> > for this patch, I have updated the testing for libkcapi accordingly and
> > all
> > tests pass. I will push the libkcapi code 0.12 with that test code change
> > out shortly. Using the current upstream version of 0.11.1 will show
> > failures as it expects the correct recv return code. As stated below,
> > that return code has changed which implies that some of the tests will
> > fail.
> > 
> > ---8<---
> > 
> > For encryption, the AEAD ciphers require AAD || PT as input and generate
> > AAD || CT || Tag as output and vice versa for decryption. Prior to this
> > patch, the AF_ALG interface for AEAD ciphers requires the buffer to be
> > present as input for encryption. Similarly, the output buffer for
> > decryption required the presence of the tag buffer too. This implies
> > that the kernel reads / writes data buffers from/to user space
> > even though this operation is not required.
> > 
> > This patch changes the AF_ALG AEAD interface to be consistent with the
> > in-kernel AEAD cipher memory requirements.
> > 
> > In addition, the code now handles the situation where the provided
> > output buffer is too small by reducing the size of the processed
> > input buffer accordingly. Due to this handling, the changes are
> > transparent to user space with one exception: the return code of recv
> > indicates the processed of output buffer size. That output buffer has a
> > different size compared to before the patch which implies that the
> > return code of recv will also be different. For example, a decryption
> > operation uses 16 bytes AAD, 16 bytes CT and 16 bytes tag, the AF_ALG
> > AEAD interface before showed a recv return code of 48 (bytes) whereas
> > after this patch, the return code is 32 since the tag is not returned
> > any more.
> 
> I tested out these changes and found that recv() or read() do not update
> all of the indicated bytes. In your decrypt example where there are 16
> bytes AAD, 16 bytes CT, and 16 bytes tag, read(sk, buf, 32) returns 32.

Please check the current patch (the one I sent to you as a pre-release did not 
contain the fix for the decryption part -- the patch sent to the list and what 
we discuss here contains the appropriate handling for the decryption side).

With your example using 16 bytes AAD, 16 bytes CT and 16 bytes Tag, the read 
will *only* show the return code of 16 (bytes) now, because only the CT part 
is converted into PT.

Yet, you are completely correct that the first 16 bytes of the AAD are skipped 
by the read call.

Thus, the read call returns exactly the amount of changed bytes, but it 
deviates from the POSIX logic by seeking to the end of the AAD buffer to find 
the offset it shall place the resulting data to.

> However, the first 16 bytes of buf are *unchanged* and the second 16 bytes
> contain the plaintext. In other words, 16 bytes were skipped over and 16
> bytes were read.

Correct. Again, with the current patch we discuss here, the read will return 
16 as it processed 16 bytes.
> 
> I see how this is similar to the documented use of the dst buffer in
> aead_request_set_crypt(), but it is not consistent with POSIX read()
> semantics.

Ciao
Stephan
