From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: fix AEAD tag memory handling
Date: Mon, 31 Oct 2016 11:11:33 +0100
Message-ID: <2822295.gL4fqFHz8h@positron.chronox.de>
References: <4006219.iWaCqWYv1B@positron.chronox.de> <4087872.10iu4A8UFE@tauon.atsec.com> <alpine.OSX.2.20.1610281501490.9348@mjmartin-mac01.wa.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47052 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764425AbcJaKLl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Oct 2016 06:11:41 -0400
In-Reply-To: <alpine.OSX.2.20.1610281501490.9348@mjmartin-mac01.wa.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 28. Oktober 2016, 15:21:19 CET schrieb Mat Martineau:

Hi Mat,
> > 
> > Please check the current patch (the one I sent to you as a pre-release did
> > not contain the fix for the decryption part -- the patch sent to the list
> > and what we discuss here contains the appropriate handling for the
> > decryption side).
> > 
> > With your example using 16 bytes AAD, 16 bytes CT and 16 bytes Tag, the
> > read will *only* show the return code of 16 (bytes) now, because only the
> > CT part is converted into PT.
> > 
> > Yet, you are completely correct that the first 16 bytes of the AAD are
> > skipped by the read call.
> > 
> > Thus, the read call returns exactly the amount of changed bytes, but it
> > deviates from the POSIX logic by seeking to the end of the AAD buffer to
> > find the offset it shall place the resulting data to.
> 
> I re-built my kernel using the patch from this email thread, and I still
> see the total read() length including the "skipped" AAD byte count. Here's
> an strace excerpt for a decrypt operation with AAD length of 32 and
> plaintext length of 32:

That is absolutely correct as the patch' intention is to avoid the 
superflowous Tag memory consideration for input data during encryption and for 
output data for decryption. This prevents the kernel from reading/writing 
memory that it does not need to touch.

The patch is not intended for coverting the AAD you reported. Though, I am not 
yet sure about whether we need to cover that aspect. My interpretation is that 
the kernel is responsible for the entire memory of AAD || PT/CT and 
potentially the tag. If the kernel sees that it does not need to change the 
AAD, it will not do that and simply change the parts of the buffer it needs 
to. Then, the kernel reports the changed bytes.

Note, if we change the kernel to operate as you suggest, there is more memory 
re-calculation operation in the kernel as well as in user space. To me, that 
is an invtation to errors. Besides, I see that only as an interpretation of 
how POSIX is to be applied.

However, I can make another proposal: we change the read/recv handler such 
that it returns the actually processed memory, regardless whether it really 
touched it. I.e. read will return the following bytes in its return code:

- encryption: AAD + CT + Tag

- decryption: AAD + PT

Even though read would report that amount of memory, we all know that the AAD 
part will not be actually written. Yet, the kernel returns the amount of bytes 
it processed.

Regardless, all of this discussion revolves around a topic that is separate to 
this patch. I.e. this patch was not intended to handle the AAD. This patch is 
only provided to handle the tag.

...


Ciao
Stephan
