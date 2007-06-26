From: Alexander Wuerstlein <snalwuer@cip.informatik.uni-erlangen.de>
Subject: Re: [PATCH] Check files' signatures before doing suid/sgid [2/4]
Date: Tue, 26 Jun 2007 02:27:00 +0200
Message-ID: <20070626002659.GM9741@cip.informatik.uni-erlangen.de>
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de> <1182536729847-git-send-email-arw@arw.name> <a781481a0706221236t3b399afdkf2e07cb109fba226@mail.gmail.com> <20070624225809.GI9741@cip.informatik.uni-erlangen.de> <a781481a0706251653wa2db7e4geb181f3827a10f9d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gm5TwAJMO0F2iVRz"
Cc: Alexander Wuerstlein <arw@arw.name>, linux-kernel@vger.kernel.org,
	Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>,
	linux-crypto@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:46905 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbXFZA1B (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jun 2007 20:27:01 -0400
Content-Disposition: inline
In-Reply-To: <a781481a0706251653wa2db7e4geb181f3827a10f9d@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--gm5TwAJMO0F2iVRz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 070626 01:56, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 6/25/07, Alexander Wuerstlein
> <snalwuer@cip.informatik.uni-erlangen.de> wrote:
>> On 070622 21:40, Satyam Sharma <satyam.sharma@gmail.com> wrote:
>> > [...]
>> We decided against
>> altering the file itself for that and some other reasons.
>> The limitation to suid/sgid was only due to a limited amount of time we=
=20
>> had for
>> implementing our patch. For the future we are planning further uses like
>> setting capabilities only for signed binaries.
>
> Ok, effectively what you have there is a signature on an entire file stor=
ed
> in one of its extended attributes, so I suspect you could think of few ot=
her
> applications for something like this too.

Yes, for example one could sign Java's classfiles and employ a special trus=
ted
Java VM which checks the signatures before execution. Also, this is a more
general case of signing kernel modules (as you mentioned below). There are
really numerous applications one could imagine, we just don't really know w=
hich
ones are practical. We definitely appreciate further ideas on this.

Also the signature-in-ELF can be used complementary to our approach: for
example NFS is currently unable to handle real extended attributes (nfs does
only posix acls). So for binaries delivered over NFS our approach wouldn't
work.

> Ok, so:
>
> 1. Admin is trusted. [ This need not mean the same as: "superuser
> _account_ is trusted", but let's stay in the real world in for now. ]
> 2. Signing happens at some central, assumed-to-be-secure location (and say
> the private key never leaves that central secure location). And let's say=
 the
> admin *repackages* the packages, this time such that the signed files get=
 the
> signature-carrying-extended-attributes with them, so the installation
> automatically copies them correctly. =3D> nothing wrong with this assumpt=
ion.
> 3. Kernel verifies signatures at runtime. =3D> kernel is trusted.
> 4. Public key needs to be *compiled into* the kernel ... so this is not=
=20
> getting into mainline, but fair enough as something site administrators w=
ould
> patch in and build.

Correct up to here.

> 5. Chain-of-trust handled in userspace. =3D> userspace is trusted.

Nope. I unluckily wrote 'userspace' where I should have said something else:
Chain-of-trust is handled in what I would label 'Adminspace' (Where we do t=
he
signing as in points 1 and 2). There is a very small number of signatures (=
in
our example one) known to the kernel and only those are trusted, and those =
are
applied to the binaries by the administrator in your point 2. The kernel do=
es
and should never rely on userspace to tell it which signatures are trustwor=
thy.
Only the administrator may do so by means of the signatures directly compil=
ed
into the kernel.

So in short: Chain-of-trust is handled by the administrator in his secure
central location.

>> So far for the initial idea. Perhaps it would be useful to have more tha=
n=20
>> one
>> key or some more complex scheme for obtaining the keys and checking their
>> validity.  But as all of this would need to be part of the kernel we=20
>> decided to
>> rather keep it as simple as possible, anything complex is better and more
>> flexibly done in userspace.
>
> Well, if you're trusting (privileged) userspace already, I'm suddenly not=
 so
> sure as to what new is this patchset bringing to the table in the first p=
lace
> ...

We do not trust any userspace application, see above.

> could you also describe the attack vectors / threats that you had in mind
> that get blocked with the proposed scheme?

We focus on attacks where an attacker may alter some executable file, for
example by altering a mounted nfs-share, manipulating disk-content by simply
pulling a disk, mounting it and writing to it, etc.

This relies on the kernel beeing trustworthy of course, so one would need to
take special measures to protect the kernel-image from beeing similarly
altered. One (somewhat not-so-secure method) would be supplying kernel imag=
es
by PXE and forbidding local booting, another measure would be using a TPM
and an appropriate bootloader to check the kernel for unwanted modification=
s.

> Have a look at modsign (signed kernel modules) project too (just the key
> management part, specifically the asymmetric crypto and DSA implementation
> that they've already ported to the kernel). You could also go through the=
=20
> lkml archives for whenever that was proposed for inclusion in mainline ...

We already thought about that. Using some existing code is definitely prefe=
rable
to inventing DSA again :)



Ciao,

Alexander Wuerstlein.

--gm5TwAJMO0F2iVRz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (SunOS)

iD8DBQFGgF1TdGSO9ttqk/IRAvlOAKChgE0FCIXToxNePB8jDH8pWsoEuACfYGK3
OD7czeGJ6D3HVsK3oDL/pZs=
=aYoa
-----END PGP SIGNATURE-----

--gm5TwAJMO0F2iVRz--
