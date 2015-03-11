From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AES-NI: fix memory usage in GCM decryption
Date: Wed, 11 Mar 2015 09:01:02 +0100
Message-ID: <1521038.6EeQHtyvI4@tachyon.chronox.de>
References: <22281096.OZkxDCz0xu@tachyon.chronox.de> <20150310094543.GA17358@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46481 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbbCKIsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2015 04:48:36 -0400
In-Reply-To: <20150310094543.GA17358@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 10. M=E4rz 2015, 20:45:43 schrieb Herbert Xu:

Hi Herbert,

> On Sun, Mar 08, 2015 at 07:49:58PM +0100, Stephan Mueller wrote:
> > The RFC4106 GCM decryption operation tries to overwrite cryptlen me=
mory
> > in req->dst. As the destination buffer for decryption only needs to=
 hold
> > the plaintext memory but cryptlen references the input buffer holdi=
ng
> > (ciphertext || authentication tag), the assumption of the destinati=
on
> > buffer length in RFC4106 GCM operation leads to a too large size.
> >=20
> > This patch simply subtracts the authentication tag size from cryptl=
en.
> > The kernel crypto API logic requires the caller to provide the
> > length of (ciphertext || authentication tag) as cryptlen for the
> > AEAD decryption operation. Thus, the cipher implementation must
> > caculate the size of the plaintext output itself and cannot simply =
use
> > cryptlen.
> >=20
> > Note, this fixes a kernel crash that can be triggered from user spa=
ce
> > via AF_ALG(aead)  without it (simply use the libkcapi test applicat=
ion
> > from [1] and update it to use rfc4106-gcm-aes).
> >=20
> > [1] http://www.chronox.de/libkcapi.html
> >=20
> > CC: Tadeusz Struk <tadeusz.struk@intel.com>
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
>=20
> Good catch.  However, I think the same confusion exists in the
> code that allocates src which may also trigger a crash.  So could
> you fix that as well?

If you are referring to __driver_rfc4106_decrypt, I do not see that con=
fusion=20
when src is allocated. src is allocated in the first else branch. src i=
s of=20
size cryptlen + assoc len which implies (ciphertext || tag || AAD). As =
this=20
buffer receives a copy of the input data provided by the caller via req=
->src=20
which holds ciphertext || tag, I think the allocation and size of src i=
s=20
correct. Note the last line in the else branch: dst =3D src which means=
 that we=20
have an in-place decryption.

However, I think there is an error in the calculation of the AAD pointe=
r=20
offset. That offset is currently calculated as:

assoc =3D (src + req->cryptlen + auth_tag_len);

But instead, it should be:

assoc =3D (src + req->cryptlen);

as our buffer is only cryptlen + assolen in size.

If you concur, I will write a patch and test it.

If you are referring to the __driver_rfc4106_encrypt function, I cannot=
 find=20
an error either for the allocation of src. Although src only holds the=20
plaintext, the final dst=3Dsrc implies that the same buffer shall hold =
the=20
result of the encrypt operation. As the result has the size of cipherte=
xt ||=20
tag || AAD, I think the buffer has the right size. Note, the calculatio=
n of=20
the assoc pointer offset is correct IMHO as the room for the newly gene=
rated=20
auth tag must be preserved. Also, src is sufficiently large to hold the=
 result=20
of the encryption operation.


In addition, I just saw an issue with my patch: instead of calculating =
the=20
length of the plaintext with (req->cryptlen - auth_tag_len), I instead =
should=20
use tempCipherLen that already holds the size of the plaintext.

--=20
Ciao
Stephan
