From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Wed, 8 Aug 2018 19:58:45 +0200
Message-ID: <20180808175845.GB16217@amd>
References: <20180723162302.GA4503@sandybridge-desktop>
 <1532590246.7411.3.camel@suse.com>
 <20180726081404.GG4244@linux-l9pv.suse>
 <20180730170415.GQ4244@linux-l9pv.suse>
 <20180803033702.GB416@sandybridge-desktop>
 <20180803053445.GC4244@linux-l9pv.suse>
 <CADjb_WSURQz86+E8kakNf7UBDM+aho+uaz3QdDkuGsEgan=szw@mail.gmail.com>
 <20180805100200.GB22948@amd>
 <20180806084534.GB12124@chenyu-desktop>
 <20180806103958.GI27062@linux-l9pv.suse>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Cc: Yu Chen <yu.c.chen@intel.com>, Ryan Chen <yu.chen.surf@gmail.com>,
        oneukum@suse.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ebiggers@google.com, Theodore Ts'o <tytso@mit.edu>,
        smueller@chronox.de, denkenz@gmail.com,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kookoo.gu@intel.com, Zhang Rui <rui.zhang@intel.com>
To: joeyli <jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180806103958.GI27062@linux-l9pv.suse>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2018-08-06 18:39:58, joeyli wrote:
> On Mon, Aug 06, 2018 at 04:45:34PM +0800, Yu Chen wrote:
> > Hi Pavel,
> > On Sun, Aug 05, 2018 at 12:02:00PM +0200, Pavel Machek wrote:
> > > Hi!
> > >=20
> > > > > User space doesn't need to involve. The EFI root key is generated=
 by
> > > > > EFI boot stub and be transfer to kernel. It's stored in EFI boot =
service
> > > > > variable that it can only be accessed by trusted EFI binary when
> > > > > secure boot is enabled.
> > > > >
> > > > Okay, this apply to the 'suspend' phase, right?
> > > > I'm still a little confused about the 'resume' phase.
> > > > Taking encryption as example(not signature),
> > > > the purpose of doing hibernation encryption is to prevent other use=
rs
> > > > from stealing ram content. Say, user A uses a  passphrase to genera=
te the
> > >=20
> > > No, I don't think that's purpose here.
> > >=20
> > > Purpose here is to prevent user from reading/modifying kernel memory
> > > content on machine he owns.
> > >
> > Say, A puts his laptop into hibernation and walks away,
> > and B walks by, and opens A's laptop and wakes up the system and he
> > can do what he wants. Although EFI key/TPM trusted key is enabled,
> > currently there's no certification during resume, which sounds
> > unsafe to me. Afterall, the original requirement is to probe
> > user for password during resume, which sounds more natural.
>=20
> OK, I saw your case. This is a physical accessing.
>=20
> I have a question: The suspend to memory also has the same behavior
> and more people are using suspend. Should we think a common solution
> to cover S3 and S4?=20

Well, we have similar problem during runtime, too ;-).

Anyway, I don't think we should encrypt memory during S3 in kernel.

If you wanted to do that, you could use uswsusp to take snapshot,
store it in ram, encrypt, erase originals (new API might be
needed... hmm. does not exactly sound easy... kexec?), trigger S3, decrypt,
resume from snapshot...

Sounds like a bit of work...

Best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAltrL1UACgkQMOfwapXb+vKFDwCff3blvM3rAHLkiEXPpIldRgRl
b2YAnjV9fbZsH9FDXiTJOYJ/YcxhL69c
=kQRP
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
