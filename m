Return-Path: <SRS0=JV5w=NB=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:37092 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbeJUPT5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Oct 2018 11:19:57 -0400
From: <yael.chemla@foss.arm.com>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: "'Gilad Ben-Yossef'" <gilad@benyossef.com>,
        "'David Miller'" <davem@davemloft.net>,
        "'Linux Crypto Mailing List'" <linux-crypto@vger.kernel.org>,
        "'Ofir Drang'" <ofir.drang@arm.com>,
        "'Linux kernel mailing list'" <linux-kernel@vger.kernel.org>
References: <1539867599-20504-1-git-send-email-yael.chemla@foss.arm.com> <CAOtvUMe8ACJtadM1B50qBT=TBwD45rPN-89Pw+AdU20uMqyU-g@mail.gmail.com>
In-Reply-To: <CAOtvUMe8ACJtadM1B50qBT=TBwD45rPN-89Pw+AdU20uMqyU-g@mail.gmail.com>
Subject: RE: [PATCH 0/3] crypto: ccree: add SM3 support
Date: Sun, 21 Oct 2018 10:06:30 +0300
Message-ID: <000901d4690c$9ae267c0$d0a73740$@foss.arm.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: en-il
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert, 
I'm sorry for notifying just now, but this patch set should be applies on top of
"crypto: ccree: add CryptoCell 713 baseline support" patch set by Gilad Ben-Yossef
Hence failures reported by kbuild test robot .

> -----Original Message-----
> From: Gilad Ben-Yossef <gilad@benyossef.com>
> Sent: Thursday, 18 October 2018 16:26
> To: yaeceh01 <yael.chemla@foss.arm.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>; David Miller
> <davem@davemloft.net>; Linux Crypto Mailing List <linux-
> crypto@vger.kernel.org>; Ofir Drang <ofir.drang@arm.com>; Linux kernel
> mailing list <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH 0/3] crypto: ccree: add SM3 support
> 
> On Thu, Oct 18, 2018 at 4:00 PM Yael Chemla <yael.chemla@foss.arm.com>
> wrote:
> >
> > Add support for SM3 in CryptoCell 713.
> >
> > Yael Chemla (3):
> >   crypto: ccree: adjust hash length to suit certain context specifics
> >   crypto: ccree:  modify set_cipher_mode usage from cc_hash
> >   crypto: ccree: add SM3 support
> >
> >  drivers/crypto/Kconfig                  |   1 +
> >  drivers/crypto/ccree/cc_aead.c          |  19 +++-
> >  drivers/crypto/ccree/cc_crypto_ctx.h    |   4 +-
> >  drivers/crypto/ccree/cc_driver.c        |  10 +-
> >  drivers/crypto/ccree/cc_driver.h        |   2 +-
> >  drivers/crypto/ccree/cc_hash.c          | 175 +++++++++++++++++++++++------
> ---
> >  drivers/crypto/ccree/cc_hw_queue_defs.h |  27 +++++
> >  7 files changed, 182 insertions(+), 56 deletions(-)
> >
> > --
> > 2.7.4
> >
> 
> Herbert, these go on top of my own previous patch set that adds the
> CryptoCell 713 and its SM4 cipher support.
> 
> Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>
> 
> Thanks,
> Gilad
> 
> --
> Gilad Ben-Yossef
> Chief Coffee Drinker
> 
> values of β will give rise to dom!
