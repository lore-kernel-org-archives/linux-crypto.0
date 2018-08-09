From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation
 encryption
Date: Thu, 9 Aug 2018 08:53:06 +0200
Message-ID: <20180809065306.GA24201@amd>
References: <1532590246.7411.3.camel@suse.com>
 <20180726081404.GG4244@linux-l9pv.suse>
 <20180730170415.GQ4244@linux-l9pv.suse>
 <20180803033702.GB416@sandybridge-desktop>
 <20180803053445.GC4244@linux-l9pv.suse>
 <CADjb_WSURQz86+E8kakNf7UBDM+aho+uaz3QdDkuGsEgan=szw@mail.gmail.com>
 <20180805100200.GB22948@amd>
 <20180806084534.GB12124@chenyu-desktop>
 <20180808175036.GA16217@amd>
 <20180809030135.GA21364@chenyu-desktop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Cc: Ryan Chen <yu.chen.surf@gmail.com>, jlee@suse.com,
        oneukum@suse.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ebiggers@google.com, Theodore Ts'o <tytso@mit.edu>,
        smueller@chronox.de, denkenz@gmail.com,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kookoo.gu@intel.com, Zhang Rui <rui.zhang@intel.com>
To: Yu Chen <yu.c.chen@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180809030135.GA21364@chenyu-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Define unsafe.
> >=20
> > If you want security against bad people resuming your machines, please
> Yes, this is one of the requirements.

> > But I thought you were trying to do something for secure boot, and "bad
> > person resumes your machine" is out of scope there.
> >=20
> Not exactly, secure boot is one solution to meet the requirement.

Is it? AFAICT secure boot is something else. "Not even owner can see
kernel memory".

> > So please always explain security against _what kind of attack_ you
> > are trying to improve; intelligent communication is not possible
> > without that.
> >=20
> User requirement:
> A is the user, B is the attacker, user A launches a STD and
> encrypts A's ram data, then writes these encrypted data onto
> the disk,  so that: Even if user B has access to the disk,
> B could not know the content of A. Which implies:
> 1. If B unplugs the disk from A's machine, and plugs the disk onto
>    another machine, B could not decode the content without A's
>    'permission'.
> 2. If B is using the same machine as A, even A has walked away leaving
>    the system suspend, B could not resume to A's context without
>    A's 'permission'.

Ok. Let's call this "effective resume password".

> Previously, there are three proposal for this:
> a. Enhance the uswsusp(Pavel)

Actually you don't have to enhance anything. Uswsusp already provides
"effective resume password".

If you only want to ask for password on resume, RSA is needed.

> Then let's talk a little more about secure boot. According
> to my understanding, the situation secure boot tries to deal
> with is a little different from the user case we raised above -
> It is an enhancement for case 1, because it refuses to resume
> once the machine is changed. And it does not cover case 2. But
> if it is a requirement from the user, that's ok.

That does not match my understanding of secure boot.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAltr5NIACgkQMOfwapXb+vK4zACggeM5cg14StvKcoK9EU+6eGLp
e5QAmLIzAxViZsXEdTTFXtBoQWAO0gM=
=8X+b
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
