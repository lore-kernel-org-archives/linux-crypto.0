From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: Re: [PATCH] crypto: ctr: avoid VLA use
Date: Wed, 14 Mar 2018 14:46:29 +0100
Message-ID: <CAJHCu1LOhCcCcYqbKWFi1ac+raxoHGm75Y_njGHQD=S+9ZE1Xg@mail.gmail.com>
References: <1521033450-14447-1-git-send-email-s.mesoraca16@gmail.com> <4726635.XOh0VtZf4O@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-kernel@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kees Cook <keescook@chromium.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4726635.XOh0VtZf4O@tauon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

2018-03-14 14:31 GMT+01:00 Stephan Mueller <smueller@chronox.de>:
> Am Mittwoch, 14. M=C3=A4rz 2018, 14:17:30 CET schrieb Salvatore Mesoraca:
>
> Hi Salvatore,
>
>>       if (walk.nbytes) {
>> -             crypto_ctr_crypt_final(&walk, child);
>> -             err =3D blkcipher_walk_done(desc, &walk, 0);
>> +             err =3D crypto_ctr_crypt_final(&walk, child);
>> +             err =3D blkcipher_walk_done(desc, &walk, err);
>
> I guess you either want to handle the error from crypto_ctr_crypt_final o=
r do
> an err |=3D blkcipher_walk_done.

I think that blkcipher_walk_done handles and returns the error for me.
Am I wrong?

Best regards,

Salvatore
