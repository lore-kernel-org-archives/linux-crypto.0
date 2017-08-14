From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Mon, 14 Aug 2017 11:26:43 +0200
Message-ID: <744D2EC6-01B1-4BE3-94A1-8FC7704D67A0@holtmann.org>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
 <3253864.NSkFVeIncy@tauon.chronox.de>
 <959CA6EF-E63F-4116-A02C-153D5C436879@holtmann.org>
 <2880013.tS8KcRZytZ@tauon.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Andrew Zaborowski <balrogg@googlemail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <david@woodhou.se>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:53162 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752246AbdHNJ0p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 05:26:45 -0400
In-Reply-To: <2880013.tS8KcRZytZ@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

>>> The first part is clearly where AF_ALG fits and keyctl does not. This is
>>> provided with the current patch set. As the keyctl API only handles, well,
>>> keys, access to the raw ciphers may not be possible through this API. And
>>> let us face it, a lot of user space code shall support many different
>>> OSes. Thus, if you have a crypto lib in user space who has its own key
>>> management (which is a core element of such libraries and thus cannot be
>>> put into an architecture-dependent code part), having only the keyctl API
>>> on Linux for accelerated asym support may not be helpful.
>> 
>> That argument is just non-sense.
> 
> How interesting. For example, what about NSS with its own key database?

a lot of applications create their own key or certificate database. It also means they need to reload and reload them over and over again for each process. A lot of things are possible, but why keep doing things more complicated than they need to be. As I said before, if you only have a hammer ..

Regards

Marcel
