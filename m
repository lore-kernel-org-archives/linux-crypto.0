From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Mon, 14 Aug 2017 08:03:19 +0200
Message-ID: <3253864.NSkFVeIncy@tauon.chronox.de>
References: <26359147.tCiuJ5s8mz@positron.chronox.de> <CAOq732KZ6nNkix6P1yxYCcfRrF7Zby5qeP9WpcBR6Z_=7MFaNA@mail.gmail.com> <alpine.OSX.2.21.1708111158510.37345@bciftcio-mobl.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andrew Zaborowski <balrogg@googlemail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58746 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752244AbdHNGDV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 02:03:21 -0400
In-Reply-To: <alpine.OSX.2.21.1708111158510.37345@bciftcio-mobl.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 11. August 2017, 21:43:15 CEST schrieb Mat Martineau:

Hi Mat,

> 
> I also would like to have more of those algorithms exposed to userspace,
> and I'd like to make sure the API is a good fit. There was extensive
> discussion of AF_ALG akcipher last year. v8 of the patch set updates the
> implementation but doesn't address the API concerns that kept the previous
> versions from being merged, so we seem to be at just as much of an impasse
> as before.

During last year's discussion, I think we have concluded (and please correct 
me if I miss something), that the export of the asymmetric HW implementations 
to user space should

- allow a streaming mode where the user space uses the kernel as an 
accelerator (maybe user space has another way of storing keys)

- allow the private key to be retained in kernel space (or even in hardware 
only) -- i.e. user space only has a handle to the key for a full asym 
operation

The first part is clearly where AF_ALG fits and keyctl does not. This is 
provided with the current patch set. As the keyctl API only handles, well, 
keys, access to the raw ciphers may not be possible through this API. And let 
us face it, a lot of user space code shall support many different OSes. Thus, 
if you have a crypto lib in user space who has its own key management (which 
is a core element of such libraries and thus cannot be put into an 
architecture-dependent code part), having only the keyctl API on Linux for 
accelerated asym support may not be helpful.

The second part is a keyctl domain. I see in-kernel support for this scenario, 
but have not yet seen the kernel/user interface nor the user space support.

Both options are orthogonal, IMHO.

Tadeusz Struck provided a patch to link the kernel crypto API / algif_akcipher 
with the keys subsystem to allow the second requirement to be implemented in 
algif_akcipher. That patch is on my desk and I plan to integrate it and even 
make it generic to allow its use for all different cipher types. I have not 
yet integrated it to allow a small patch set to be reviewed. If it is the will 
of the council, I can surely add that code to the initial patch set and 
resubmit.


Ciao
Stephan
