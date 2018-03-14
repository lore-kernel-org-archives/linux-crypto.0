From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: ctr: avoid VLA use
Date: Wed, 14 Mar 2018 14:52:29 +0100
Message-ID: <2286764.GK92XWVYGX@tauon.chronox.de>
References: <1521033450-14447-1-git-send-email-s.mesoraca16@gmail.com> <4726635.XOh0VtZf4O@tauon.chronox.de> <CAJHCu1LOhCcCcYqbKWFi1ac+raxoHGm75Y_njGHQD=S+9ZE1Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Return-path: <kernel-hardening-return-12599-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAJHCu1LOhCcCcYqbKWFi1ac+raxoHGm75Y_njGHQD=S+9ZE1Xg@mail.gmail.com>
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 14. M=E4rz 2018, 14:46:29 CET schrieb Salvatore Mesoraca:

Hi Salvatore,

> 2018-03-14 14:31 GMT+01:00 Stephan Mueller <smueller@chronox.de>:
> > Am Mittwoch, 14. M=E4rz 2018, 14:17:30 CET schrieb Salvatore Mesoraca:
> >=20
> > Hi Salvatore,
> >=20
> >>       if (walk.nbytes) {
> >>=20
> >> -             crypto_ctr_crypt_final(&walk, child);
> >> -             err =3D blkcipher_walk_done(desc, &walk, 0);
> >> +             err =3D crypto_ctr_crypt_final(&walk, child);
> >> +             err =3D blkcipher_walk_done(desc, &walk, err);
> >=20
> > I guess you either want to handle the error from crypto_ctr_crypt_final=
 or
> > do an err |=3D blkcipher_walk_done.
>=20
> I think that blkcipher_walk_done handles and returns the error for me.
> Am I wrong?

You are right as you want to finalize the crypto operation even though the=
=20
encryption fails.

Please disregard my comment.
>=20
> Best regards,
>=20
> Salvatore



Ciao
Stephan
