From: Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 2/2] crypto: Fix out-of-bounds access of the AAD buffer in generic-gcm-aesni
Date: Wed, 20 Dec 2017 13:51:26 -0800
Message-ID: <3380731.nSvSnl1kt0@js-desktop.svl.corp.google.com>
References: <20171219221750.34148-1-junaids@google.com> <2283674.Cix72tvP9W@js-desktop.svl.corp.google.com> <20171220211254.GB38504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        andreslc@google.com, davem@davemloft.net, gthelen@google.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:34499 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755501AbdLTVv3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 16:51:29 -0500
Received: by mail-pg0-f45.google.com with SMTP id j4so12448561pgp.1
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 13:51:29 -0800 (PST)
In-Reply-To: <20171220211254.GB38504@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, December 20, 2017 1:12:54 PM PST Eric Biggers wrote:
> >=20
> > We do need both registers, though we could certainly swap their usage t=
o make
> > r12 the temp register. The reason we need the second register is becaus=
e we
> > need to keep the original length to perform the pshufb at the end. But,=
 of
> > course, that will not be needed anymore if we avoid the pshufb by dupli=
cating
> > the _read_last_lt8 block or utilizing pslldq some other way.
> >=20
>=20
> If READ_PARTIAL_BLOCK can clobber 'DLEN' that would simplify it even more=
 (no
> need for 'TMP1'), but what I am talking about here is how INITIAL_BLOCKS_=
DEC and
> INITIAL_BLOCKS_ENC maintain two copies of the remaining length in lock-st=
ep in
> r11 and r12:
>=20
> _get_AAD_blocks\num_initial_blocks\operation:
>         movdqu     (%r10), %xmm\i
>         PSHUFB_XMM %xmm14, %xmm\i # byte-reflect the AAD data
>         pxor       %xmm\i, \XMM2
>         GHASH_MUL  \XMM2, \TMP3, \TMP1, \TMP2, \TMP4, \TMP5, \XMM1
>         add        $16, %r10
>         sub        $16, %r12
>         sub        $16, %r11
>         cmp        $16, %r11
>         jge        _get_AAD_blocks\num_initial_blocks\operation
>=20
> The code which you are replacing with READ_PARTIAL_BLOCK actually needed =
the two
> copies, but now it seems that only one copy is needed, so it can be simpl=
ified
> by only using r11.
>=20

Sorry, I misunderstood earlier. I=E2=80=99ll remove the extra register from=
 the preceding code in INIITIAL_BLOCKS_ENC/DEC.

Thanks,
Junaid
