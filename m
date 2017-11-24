From: Stephan Mueller <smueller@chronox.de>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Fri, 24 Nov 2017 17:23:39 +0100
Message-ID: <2736456.D9ivBHHY1a@tauon.chronox.de>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com> <2926823.qMJ9kpMUtP@tauon.chronox.de> <CACT4Y+YLfRhvOL=XDq_46JuwcBv6DMaD1AntitP_G+GTJ3oUHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers@google.com>,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42484 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752479AbdKXQXl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Nov 2017 11:23:41 -0500
In-Reply-To: <CACT4Y+YLfRhvOL=XDq_46JuwcBv6DMaD1AntitP_G+GTJ3oUHQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 24. November 2017, 17:18:08 CET schrieb Dmitry Vyukov:

Hi Dmitry,
> 
> >                 {"rfc7539esp", []int{ALG_BLKCIPHER, ALG_HASH}},
> >                 {"rfc7539", []int{ALG_BLKCIPHER, ALG_HASH}},
> >                 {"rfc4543", []int{ALG_AEAD}},
> >                 {"rfc4106", []int{ALG_AEAD}},
> > 
> > These are no ciphers per se, but simply formatting mechanisms. For
> > example, to make use of rfc4106, you must split the IV: the first four
> > bytes need to be appended to the key and the trailing 8 bytes are used as
> > the IV. Any other formatting should cause an error. Besides, these
> > implementations should only work with some AEAD ciphers like GCM.
> 
> So rfc4543 consumes AEAD and itself is a AEAD (can be passed whenever
> AEAD is requried), right?

Yes. Again, it is purely formatting of input data.

> If yes, then it works the way you described
> (minus the part that is works only with _some_ AEAD ciphers, fuzzer
> will try to blindly combine it with all of them).
> 
> rfc7539 consumes 2 args, not 1, right? I figured out that it consumes
> BLKCIPHER and HASH.

Right, it is intended for the combo of chacha20 and poly1305.

> >                 {"generic-gcm-aesni", nil},
> > 
> > Does this exist?
> 
> I can create it:
> 
> strcpy(addr.salg_type, "aead");
> strcpy(addr.salg_name, "generic-gcm-aesni");
> 
> bind(3, {sa_family=0x26 /* AF_??? */,
> sa_data="aead\0\0\0\0\0\0\0\0\0\0"}, 88) = 0

Ok, I have not seen that one before.

> > xts() is a template.
> > 
> > Note, starting with 4.9, you must use xts(ecb(aes)).
> 
> "xts(aes)" also works on upstream (4.15):
> 
> strcpy(addr.salg_type, "skcipher");
> strcpy(addr.salg_name, "xts(aes)");
> 
> bind(3, {sa_family=0x26 /* AF_??? */, sa_data="skcipher\0\0\0\0\0\0"}, 88) =
> 0

Ok, I stand corrected. At one point, this did not work :-)


Ciao
Stephan
