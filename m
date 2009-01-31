From: Pierre Habouzit <madcoder@debian.org>
Subject: Re: [RFC] MPI module
Date: Sat, 31 Jan 2009 23:34:55 +0100
Message-ID: <20090131223455.GA18560@artemis.corp>
References: <20090130081210.GA8157@artemis> <20090130124110.GA6827@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D605CBC9A8@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="cNdxnHkX5QqsyA0e";
	protocol="application/pgp-signature"; micalg=SHA1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Loc Ho <lho@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pan.madism.org ([88.191.52.104]:49690 "EHLO hermes.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZAaWfB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 31 Jan 2009 17:35:01 -0500
Content-Disposition: inline
In-Reply-To: <0CA0A16855646F4FA96D25A158E299D605CBC9A8@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 30, 2009 at 06:54:16PM +0000, Loc Ho wrote:
> Hi,
>=20
> I would like to add that you can even handle the TLS/DTLS/SSL packet
> formation in the kernel as well if you provide an algorithms that does
> just that. Right now, most user just use the kernel for the hashing
> and cipher parts. There is no reason that the current framework cannot
> handle processing the full packet in hardware. All you need is to
> create another algorithm name that is aead type. Then, from user space
> (using Linux CryptoAPI user space interface) creates that algorithms.
> The underlying CryptoAPI will call the appropriate function that
> provided by your driver and the result of the operation will be an
> TLS/DTLS/SSL packet formation.=20

Okay, this sounds nifty, though I'm not 100% sure I follow you. When
you're talking about "Linux CryptoAPI userspace interface" are you
talking about things like cryptodev[1] that aren't (AFAICT) merged into
the mainline kernel ?

Or do you mean that I should write a new aead algorithm, plus provide a
way (probably ioctl ?) to "activate" that algorithm on my socket once
user-land has negociated the ciphers and similar stuff ?

Also, this has the drawback, unless I'm mistaken, that the program using
the socket has to be aware it's using SSL/TLS/DTLS. Of course, when
writing something doing SMTP with STARTTLS it has to be somehow aware of
the SSL layer, since the handshake is delayed. But it would be quite sad
to be unable to secure a socket without the user noticing it at any
time. For example, it would be quite nifty to do through iptables
something that would redirect a given port to another one and adding SSL
at the same time (e.g. redirect 1.2.3.4:443 to 127.0.0.1:80 _and_ adding
SSL on the top).


It makes sense to want to put the handshakes and negociations in
user-space, and the system-wide ssl daemon for that task makes sense to
me. So I was basically trying to figure out a clean way to "redirect"
all non data SSL/TLS payloads (IOW handshakes and stuff like that) to
the daemon, and the rest to the actual socket/application[2]. So either
I'm wrong about what I'm trying to design, or I miss something in how
your hint can help me.

Anyways, I would be delighted if you can give me more details about what
you meant :)




  [1] http://www.logix.cz/michal/devel/cryptodev/

  [2] Which rises issues since unlike IPSec we have some programs
      _aware_ that they want to use SSL: it's okay to _have_ to write
      configuration for the system-wide daemon if you're securing
      something behind the original program's back. But I want that
      programs are still able to chose their certificate themselves and
      stuff like that, and it's somehow "hard" (as in racy and/or
      insecure) that a given program creates a socket, mark it as secure
      (e.g. using a setsockopt) and uploading informations about that
      new socket to the regulatory daemon (in the sense that anyone can
      claim that it possess that given socket, only the kernel really
      knows about it).  But I assume those issues can be resolved later
      once I've accustomed myself with the kernel crypto a bit more.

--=20
=C2=B7O=C2=B7  Pierre Habouzit
=C2=B7=C2=B7O                                                madcoder@debia=
n.org
OOO                                                http://www.madism.org

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmE0g4ACgkQvGr7W6HudhweNACfbVZwxyZ34TFdOUYEDm62ygM9
tgAAn0V0HINDbWuDlSNsU3KrVgwP12rz
=qz5V
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
