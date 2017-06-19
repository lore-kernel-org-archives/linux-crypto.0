From: Mike Frysinger <vapier@chromium.org>
Subject: Re: [PATCH] hwrng: do not warn when there are no devices
Date: Sun, 18 Jun 2017 22:00:17 -0700
Message-ID: <CAAbOSckrApUs26m7+iGyex43tEaWthNOuuN2jjBu-apj-y-Rdw@mail.gmail.com>
References: <20170512041734.31945-1-vapier@gentoo.org> <CANc+2y5si9imDg7NEC-3XsnjPFfoUMu=2T5gxKDqgoo24XHCaA@mail.gmail.com>
 <CAAbOSc=e07W8LL8PAHv5awt_uPk8yNJ6wTTu3Ebe-Mww+inG8A@mail.gmail.com>
 <CANc+2y6=TtMGFknqgc5oAjY-pHkU6J31+QQaa7=6oAS=Omc0cg@mail.gmail.com>
 <CANc+2y5YDcJYcwyCUtdCcvW_07HhjTzSrShyWFkfCjXYTsi0QQ@mail.gmail.com>
 <CAAbOSck2Uzk7kRHErLwEGRoPkMVV+=3bvdz1nnSOsE6UTQZF0A@mail.gmail.com>
 <CANc+2y40u1vviM9_m8TX896Skr=qCjmvvSq86Y=tkX923Q_3fg@mail.gmail.com> <20170619041234.GA12984@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:36131 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdFSFAs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 01:00:48 -0400
Received: by mail-ua0-f173.google.com with SMTP id g40so52154478uaa.3
        for <linux-crypto@vger.kernel.org>; Sun, 18 Jun 2017 22:00:48 -0700 (PDT)
In-Reply-To: <20170619041234.GA12984@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 18, 2017 at 9:12 PM, Herbert Xu wrote:
> On Fri, May 12, 2017 at 01:49:52PM +0530, PrasannaKumar Muralidharan wrote:
> > I leave it to Herbert to decide whether to accept this patch in
> > current form or not.
>
> I think the correct fix would be for the TPM subsystem to signal that
> it is ready and then register the tpm-rng device.

the TPM subsystem is ready.  it's like saying "the USB subsystem
should signal when it's ready".  the TPM subsystem provides a bus (of
sorts) and clients (like tpm-rng) can use whatever backend happens to
be available.

in order to make tpm-rng react in the way you're implying, the TPM
subsystem would need to add a notification chain for transitions from
none<->some devices, then tpm-rng could subscribe to that, and during
those transition points, it would call hwrng_register/hwrng_unregister
to make itself visible accordingly to the hwrng subsystem.  maybe
someone on the TPM side would be interested in writing all that logic,
but it sounds excessive for this minor usage.  the current tpm-rng
driver is *extremely* simple -- it's 3 funcs, each of which are 1
line.
-mike
