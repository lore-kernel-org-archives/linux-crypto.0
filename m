From: Pavel Machek <pavel@ucw.cz>
Subject: Re: x86: PIE support and option to extend KASLR randomization
Date: Fri, 6 Oct 2017 12:39:33 +0200
Message-ID: <20171006103933.GA9497@amd>
References: <CAJcbSZFTX3uiS2g8JriS6+z_+WrG8z3hrQo4OSuyHpiyUDJWYA@mail.gmail.com>
 <20170815075609.mmzbfwritjzvrpsn@gmail.com>
 <CAJcbSZE+TiY2whT94WqCJNXzR=2ATOHcQ10H5RqBZA1j=k1VHQ@mail.gmail.com>
 <20170816151235.oamkdva6cwpc4cex@gmail.com>
 <20170821133222.2ek6bhqgdeoymxsg@hirez.programming.kicks-ass.net>
 <20170821142854.dmuusnbc2tsrai3v@hirez.programming.kicks-ass.net>
 <c830ba59-65d3-187f-3868-732059269f28@zytor.com>
 <20170923100029.6nzpui6c3ke76bbs@gmail.com>
 <20170924223708.GA12616@amd>
 <20170925073342.2yoghmanhx6c75ho@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
	Thomas Garnier <thgarnie@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>,
	Brian Gerst <brgerst@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	"Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Tejun Heo <tj@kernel.org>,
	Christo
To: Ingo Molnar <mingo@kernel.org>
Return-path: <kernel-hardening-return-10092-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <20170925073342.2yoghmanhx6c75ho@gmail.com>
List-Id: linux-crypto.vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-09-25 09:33:42, Ingo Molnar wrote:
>=20
> * Pavel Machek <pavel@ucw.cz> wrote:
>=20
> > > For example, there would be collision with regular user-space mapping=
s, right?=20
> > > Can local unprivileged users use mmap(MAP_FIXED) probing to figure ou=
t where=20
> > > the kernel lives?
> >=20
> > Local unpriviledged users can probably get your secret bits using cache=
 probing=20
> > and jump prediction buffers.
> >=20
> > Yes, you don't want to leak the information using mmap(MAP_FIXED), but =
CPU will=20
> > leak it for you, anyway.
>=20
> Depends on the CPU I think, and CPU vendors are busy trying to mitigate t=
his=20
> angle.

I believe any x86 CPU running Linux will leak it. And with CPU vendors
putting "artifical inteligence" into branch prediction, no, I don't
think it is going to get better.

That does not mean we shoudl not prevent mmap() info leak, but...

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlnXXWUACgkQMOfwapXb+vLHdQCfT0gtt1DcnPzO7HUoTmQNbTIP
73cAn2DmS20EcLXQtKA4VV7Dur1vaFqH
=9iUT
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
