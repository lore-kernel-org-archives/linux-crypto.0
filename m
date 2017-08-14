From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Mon, 14 Aug 2017 09:23:51 +0200
Message-ID: <2880013.tS8KcRZytZ@tauon.chronox.de>
References: <26359147.tCiuJ5s8mz@positron.chronox.de> <3253864.NSkFVeIncy@tauon.chronox.de> <959CA6EF-E63F-4116-A02C-153D5C436879@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Andrew Zaborowski <balrogg@googlemail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <david@woodhou.se>
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58774 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752421AbdHNHXx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 03:23:53 -0400
In-Reply-To: <959CA6EF-E63F-4116-A02C-153D5C436879@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 14. August 2017, 08:26:22 CEST schrieb Marcel Holtmann:

Hi Marcel,

> > The first part is clearly where AF_ALG fits and keyctl does not. This is
> > provided with the current patch set. As the keyctl API only handles, well,
> > keys, access to the raw ciphers may not be possible through this API. And
> > let us face it, a lot of user space code shall support many different
> > OSes. Thus, if you have a crypto lib in user space who has its own key
> > management (which is a core element of such libraries and thus cannot be
> > put into an architecture-dependent code part), having only the keyctl API
> > on Linux for accelerated asym support may not be helpful.
> 
> That argument is just non-sense.

How interesting. For example, what about NSS with its own key database?

Ciao
Stephan
