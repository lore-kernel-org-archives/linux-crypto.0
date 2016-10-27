From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH] crypto: fix AEAD tag memory handling
Date: Thu, 27 Oct 2016 14:42:14 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1610271419040.52583@mjmartin-mac01.local>
References: <4006219.iWaCqWYv1B@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:35520 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965092AbcJ0VmQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2016 17:42:16 -0400
In-Reply-To: <4006219.iWaCqWYv1B@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Stephan and Herbert,

On Thu, 27 Oct 2016, Stephan Mueller wrote:

> Hi Herbert,
>
> for this patch, I have updated the testing for libkcapi accordingly and all
> tests pass. I will push the libkcapi code 0.12 with that test code change
> out shortly. Using the current upstream version of 0.11.1 will show failures
> as it expects the correct recv return code. As stated below, that return
> code has changed which implies that some of the tests will fail.
>
> ---8<---
>
> For encryption, the AEAD ciphers require AAD || PT as input and generate
> AAD || CT || Tag as output and vice versa for decryption. Prior to this
> patch, the AF_ALG interface for AEAD ciphers requires the buffer to be
> present as input for encryption. Similarly, the output buffer for
> decryption required the presence of the tag buffer too. This implies
> that the kernel reads / writes data buffers from/to user space
> even though this operation is not required.
>
> This patch changes the AF_ALG AEAD interface to be consistent with the
> in-kernel AEAD cipher memory requirements.
>
> In addition, the code now handles the situation where the provided
> output buffer is too small by reducing the size of the processed
> input buffer accordingly. Due to this handling, the changes are
> transparent to user space with one exception: the return code of recv
> indicates the processed of output buffer size. That output buffer has a
> different size compared to before the patch which implies that the
> return code of recv will also be different. For example, a decryption
> operation uses 16 bytes AAD, 16 bytes CT and 16 bytes tag, the AF_ALG
> AEAD interface before showed a recv return code of 48 (bytes) whereas
> after this patch, the return code is 32 since the tag is not returned
> any more.

I tested out these changes and found that recv() or read() do not update 
all of the indicated bytes. In your decrypt example where there are 16 
bytes AAD, 16 bytes CT, and 16 bytes tag, read(sk, buf, 32) returns 32. 
However, the first 16 bytes of buf are *unchanged* and the second 16 bytes 
contain the plaintext. In other words, 16 bytes were skipped over and 16 
bytes were read.

I see how this is similar to the documented use of the dst buffer in 
aead_request_set_crypt(), but it is not consistent with POSIX read() 
semantics.


--
Mat Martineau
Intel OTC
