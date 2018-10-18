Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-vs1-f66.google.com ([209.85.217.66]:36432 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbeJRV1Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 17:27:16 -0400
Received: by mail-vs1-f66.google.com with SMTP id c205so23043859vsd.3
        for <linux-crypto@vger.kernel.org>; Thu, 18 Oct 2018 06:26:13 -0700 (PDT)
MIME-Version: 1.0
References: <1539867599-20504-1-git-send-email-yael.chemla@foss.arm.com>
In-Reply-To: <1539867599-20504-1-git-send-email-yael.chemla@foss.arm.com>
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Thu, 18 Oct 2018 16:26:01 +0300
Message-ID: <CAOtvUMe8ACJtadM1B50qBT=TBwD45rPN-89Pw+AdU20uMqyU-g@mail.gmail.com>
Subject: Re: [PATCH 0/3] crypto: ccree: add SM3 support
To: yaeceh01 <yael.chemla@foss.arm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 18, 2018 at 4:00 PM Yael Chemla <yael.chemla@foss.arm.com> wrot=
e:
>
> Add support for SM3 in CryptoCell 713.
>
> Yael Chemla (3):
>   crypto: ccree: adjust hash length to suit certain context specifics
>   crypto: ccree:  modify set_cipher_mode usage from cc_hash
>   crypto: ccree: add SM3 support
>
>  drivers/crypto/Kconfig                  |   1 +
>  drivers/crypto/ccree/cc_aead.c          |  19 +++-
>  drivers/crypto/ccree/cc_crypto_ctx.h    |   4 +-
>  drivers/crypto/ccree/cc_driver.c        |  10 +-
>  drivers/crypto/ccree/cc_driver.h        |   2 +-
>  drivers/crypto/ccree/cc_hash.c          | 175 +++++++++++++++++++++++---=
------
>  drivers/crypto/ccree/cc_hw_queue_defs.h |  27 +++++
>  7 files changed, 182 insertions(+), 56 deletions(-)
>
> --
> 2.7.4
>

Herbert, these go on top of my own previous patch set that adds the
CryptoCell 713 and its SM4 cipher support.

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
