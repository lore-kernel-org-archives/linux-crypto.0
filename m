From: Stephan Mueller <smueller@chronox.de>
Subject: Re: a few questions on AF_ALG specification (AEAD, socket/connection, ...)
Date: Tue, 26 Jul 2016 13:54:40 +0200
Message-ID: <2101527.nPISZxk4jO@tauon.atsec.com>
References: <57974E05.3030502@kalray.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Nicolas Brunie <nicolas.brunie@kalray.eu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33784 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbcGZLyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jul 2016 07:54:43 -0400
In-Reply-To: <57974E05.3030502@kalray.eu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 26. Juli 2016, 13:48:21 CEST schrieb Nicolas Brunie:

Hi Nicolas,

> Hi All,
>     I am developping a driver for a crypto offloading solution which
> uses the AF_ALG interface. I am trying to stay as close as possible t=
o
> the specification but apart from the kernel crypto source code and a =
few
> documents (such as
> https://www.kernel.org/doc/htmldocs/crypto-API/ch04s06.html ) I have =
not
> found a lot of details on AF_ALG specification and many points are no=
t
> very clear to me, it someone could point me towards reference to answ=
er
> the following questions it will be deeply appreciated.

See [1] for the library around it.
> *
> **
>=20
> Socket / Connection :
>=20
> Is it legal to open multiple connections on an AF_ALG socket ? How is
> the behavior defined

Yes, you get a handle (i.e. a file descriptor) for each connection.
>=20
> *From what I could test, at least for digests, multiple connections a=
re
> OK, but it seems odd to allow multiple connection to a cipher while
> using a**shared key and multiple IVs. One of the use I could think of
> will be parallelizing several encryption/decryption with the same
> symmetric key.

It is allowed

> *
>=20
> Is it true that the key (defined via setsockopt) is common to all the
> connections but the IV (defined through message control header) is
> specific to each connection ?

Yes.
>=20
> *
> *
>=20
> Send/Recv interleaving
>=20
> When computing a digest (e.g. sha256) it seems the recv call is
> triggering the end of the digest accumulation, such a behavior can be
> obtained by using/not using MSG_MORE flags, which *of the two*the
> canonical way to compute a hash over several send messages ? It does =
not
> seem possible to compute a partial digest (through a recv call) and t=
hen
> continue accumulating through other send calls (apart from the securi=
ty
> risk of exposing a te*mporary digest, is there a reason why the recv
> ends a digest computation ?)*.*

You can read intermediary results. recv does not check for the MSG_MORE=
 flag.

>=20
> *
>=20
> AES-GCM / AEAD
>=20
> Does the aead_assoclen must be set once and for all for each stream o=
r
> is it a by message option ?

Assoclen is handled like the IV, per message where a message may be sen=
t in=20
multiple chunks.
>=20
> Option 0: set aead_assoclen during the first sendmsg and then stream
> accross several sendmsg the full AAD and then the full plaintext/ciph=
ertext
>=20
> Option 1: set aead_assoclen for each of the first sendmsg containing =
aad
> data. Once the aead_assoclen is strictly less than the msg=E2=80=99s =
data length
> then the next messages must have aead_assoclen set to 0

Option 1, if I read your text right.
>=20
> *

[1] http://www.chronox.de/libkcapi.html
>=20
> best regards,
> Nicolas Brunie
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypt=
o" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Ciao
Stephan
