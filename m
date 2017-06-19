From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: do not warn when there are no devices
Date: Mon, 19 Jun 2017 14:21:15 +0800
Message-ID: <20170619062115.GA13498@gondor.apana.org.au>
References: <20170512041734.31945-1-vapier@gentoo.org>
 <CANc+2y5si9imDg7NEC-3XsnjPFfoUMu=2T5gxKDqgoo24XHCaA@mail.gmail.com>
 <CAAbOSc=e07W8LL8PAHv5awt_uPk8yNJ6wTTu3Ebe-Mww+inG8A@mail.gmail.com>
 <CANc+2y6=TtMGFknqgc5oAjY-pHkU6J31+QQaa7=6oAS=Omc0cg@mail.gmail.com>
 <CANc+2y5YDcJYcwyCUtdCcvW_07HhjTzSrShyWFkfCjXYTsi0QQ@mail.gmail.com>
 <CAAbOSck2Uzk7kRHErLwEGRoPkMVV+=3bvdz1nnSOsE6UTQZF0A@mail.gmail.com>
 <CANc+2y40u1vviM9_m8TX896Skr=qCjmvvSq86Y=tkX923Q_3fg@mail.gmail.com>
 <20170619041234.GA12984@gondor.apana.org.au>
 <CAAbOSckrApUs26m7+iGyex43tEaWthNOuuN2jjBu-apj-y-Rdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
To: Mike Frysinger <vapier@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:59604 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdFSGVj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 02:21:39 -0400
Content-Disposition: inline
In-Reply-To: <CAAbOSckrApUs26m7+iGyex43tEaWthNOuuN2jjBu-apj-y-Rdw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 18, 2017 at 10:00:17PM -0700, Mike Frysinger wrote:
> 
> in order to make tpm-rng react in the way you're implying, the TPM
> subsystem would need to add a notification chain for transitions from
> none<->some devices, then tpm-rng could subscribe to that, and during
> those transition points, it would call hwrng_register/hwrng_unregister
> to make itself visible accordingly to the hwrng subsystem.  maybe
> someone on the TPM side would be interested in writing all that logic,
> but it sounds excessive for this minor usage.  the current tpm-rng
> driver is *extremely* simple -- it's 3 funcs, each of which are 1
> line.

It's simple and it's broken, as far as the way it hooks into the
hwrng is concerned.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
