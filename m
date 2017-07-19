From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC 13/22] x86/power/64: Adapt assembly for PIE support
Date: Wed, 19 Jul 2017 20:41:27 +0200
Message-ID: <20170719184127.GA1285@amd>
References: <20170718223333.110371-1-thgarnie@google.com>
 <20170718223333.110371-14-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Matthias Kaehlcke <mka@chromium.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
	Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	"Rafael J . Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Tejun Heo <tj@kernel.org>,
	Chris
To: Thomas Garnier <thgarnie@google.com>
Return-path: <kernel-hardening-return-9061-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <20170718223333.110371-14-thgarnie@google.com>
List-Id: linux-crypto.vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-07-18 15:33:24, Thomas Garnier wrote:
> Change the assembly code to use only relative references of symbols for t=
he
> kernel to be PIE compatible.
>=20
> Position Independent Executable (PIE) support will allow to extended the
> KASLR randomization range below the -2G memory limit.
>=20
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

(But not tested; testing it would be nice).
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllvp9cACgkQMOfwapXb+vIO8gCgpBYoGg7aQUDBer0KqNDdRxMr
PN0AnAkhnZL2b5/6noFSLfiKXYwfgtge
=XHtW
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
