From: Alexander Wuerstlein <snalwuer@cip.informatik.uni-erlangen.de>
Subject: Re: [PATCH] Check files' signatures before doing suid/sgid [2/4]
Date: Mon, 25 Jun 2007 00:58:09 +0200
Message-ID: <20070624225809.GI9741@cip.informatik.uni-erlangen.de>
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de> <1182536729847-git-send-email-arw@arw.name> <a781481a0706221236t3b399afdkf2e07cb109fba226@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Cc: Alexander Wuerstlein <arw@arw.name>, linux-kernel@vger.kernel.org,
	Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>,
	linux-crypto@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:56334 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbXFXW6L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Jun 2007 18:58:11 -0400
Content-Disposition: inline
In-Reply-To: <a781481a0706221236t3b399afdkf2e07cb109fba226@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 070622 21:40, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hi Alexander, Johannes,
>
> But first: Have you checked the digsig project? It's been doing
> (for some time) what your current patchset proposes -- and
> it uses public key cryptosystems for the key management,
> which is decidedly better than using secret-keyed hashes
> (HMAC, XCBC). Also, digsig aims to protect executable
> binaries in general, and not just suid / sgid ones.

We have not heard about digsig before, thanks for pointing it out. After a
short look over the source (correct me if I'm wrong): The most important
difference between our project and digsig is that digsig relies on storing
signatures inside the ELF file structure. Therefore a handmade binary-loade=
r or
just COFF binaries could be used to circumvent digsig. We decided against
altering the file itself for that and some other reasons.

The limitation to suid/sgid was only due to a limited amount of time we had=
 for
implementing our patch. For the future we are planning further uses like
setting capabilities only for signed binaries.

> Second: Can we have some discussion on the security model /
> threat model / trust model / cryptographic key management
> scheme of your signing mechanism? [I had read through the
> [0/4] mail you had sent yesterday, but found no relevant
> discussion on these aspects there.]

Our scenario was as follows: Usually system administrators rely on cronjobs
checking their binaries for unwanted suid-bits. Because of the obvious prob=
lems
with this (time between cronjobs, performance) we wrote our patch to replac=
e it.

An admin would verify the to-be-installed binaries (e.g. by reading the sou=
rce,
checking the distribution's package signatures), sign them in a central
location.  He then distributes those signatures along with the installation
packages onto his computers. There should only be one key in use at a site =
the
public part of which is compiled into the kernel. Any kind of chain-of-trust
should be handled in userspace by signing or not signing with the site-wide
key depending on the earlier signatures in the chain.

So far for the initial idea. Perhaps it would be useful to have more than o=
ne
key or some more complex scheme for obtaining the keys and checking their
validity.  But as all of this would need to be part of the kernel we decide=
d to
rather keep it as simple as possible, anything complex is better and more
flexibly done in userspace.

> From the patchset, it appears you use a *common* secret key
> for _all_ signed binaries, and it is set at kernel build-time itself:
> [...]
> Anyway, this is *totally* insecure and broken. Do you realize anybody
> who lays hands on the kernel image can now _trivially_ extract the
> should-have-been-a-secret key from it and use it to sign his own
> binaries?

We do realize that this is really really ugly, broken and nasty and nobody
would or should ever want to use it for anything but playing around as it is
atm. ;)

We only used HMAC because it was already available inside the kernel, for
implementing real asymetric cryptography there was simply no time. Of course
our next objective is to implement that.=20


Ciao,

Alexander Wuerstlein.

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (SunOS)

iD4DBQFGfvcBdGSO9ttqk/IRAuPiAJsF3OrS2tnK5stQS+J6vcagv2GlQQCYulao
gt2i5Xo+aNbIvFEzvQ7f5A==
=oNJU
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
