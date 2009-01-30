From: Pierre Habouzit <madcoder@debian.org>
Subject: Re: [RFC] MPI module
Date: Fri, 30 Jan 2009 09:12:10 +0100
Message-ID: <20090130081210.GA8157@artemis>
References: <20090130001523.GA909@artemis.corp> <20090130032506.GA2822@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="82I3+IH0IqGh5yIs";
	protocol="application/pgp-signature"; micalg=SHA1
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pan.madism.org ([88.191.52.104]:50282 "EHLO hermes.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbZA3IMO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Jan 2009 03:12:14 -0500
Content-Disposition: inline
In-Reply-To: <20090130032506.GA2822@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 30, 2009 at 03:25:06AM +0000, Herbert Xu wrote:
> Pierre Habouzit <madcoder@debian.org> wrote:
> >
> > My endgame is simple, I'd like to see an in-kernel SSL/TLS
> > implementation in Linux happen. There are many reasons to want that,
> > ranging from performance reasons (waking the userland each time you
> > perform a handshake isn't particularly nice, and it's easy to make
> > system-wide session caches) to really cool features being enabled:
> >  - you can send "secure" file descriptors around through Unix Sockets,
> >    or prepare a "secure" socket, let it be your stdin/stdout pair and
> >    exec a service knowing nothing about SSL (think inetd-like stuff) ;
> >  - you can deploy secure services where the actual server knows nothing
> >    about the certificate that is used ;
> >  - you can have a system-wide service dealing with peer certificate
> >    validations and have a real system-wide policy in this regard ;
> >  - you could even think of some netfilter stuff to enforce security on
> >    a given socket, even if the service behind the socket knows nothing
> >    about it (bye bye stunnel)...
> >=20
> > Nowadays, the kernel has most of what we need cipher-wise for TLS/SSL.
> > Only the key-exchange protocols and the very TLS protocol are lacking.
> > I'm currently addressing the former issue, namely, bringing RSA and
> > Diffie-Hellman to the kernel.
>=20
> Stop right there.  There is absolutely no reason why you need
> to do the TLS stuff in kernel to achieve the goals you listed
> above.
>=20
> What you should do is have user-space create the session, and
> then give the keys to the kernel to do the data-path.  Please
> take a look at IPsec for an example of how the work is divided
> between user-space and the kernel.

So let me rephrase that to be sure we've understood each other. What you
suggest is to have an IKE-like daemon dealing with the keys and all the
handshakes, and that the kernel would only deal with the symmetric
ciphers used on the data path. Is that right ?

--=20
=C2=B7O=C2=B7  Pierre Habouzit
=C2=B7=C2=B7O                                                madcoder@debia=
n.org
OOO                                                http://www.madism.org

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmCtlkACgkQvGr7W6HudhwvWgCgiFZc0dqfH1ONjp6FR/nR1KPP
XcsAnA1oZktNbbV9ln5FdJqSJTfOr3bO
=qaRy
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
