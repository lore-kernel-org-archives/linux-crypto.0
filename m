From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v11 00/13] Intel SGX1 support
Date: Tue, 19 Jun 2018 22:04:15 +0200
Message-ID: <20180619200414.GA3143@amd>
References: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
 <20180612105011.GA26931@amd>
 <20180619145943.GC8034@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Cc: x86@kernel.org, platform-driver-x86@vger.kernel.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com,
        Alexei Starovoitov <ast@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "open list:INTEL SGX" <intel-sgx-kernel-dev@lists.01.org>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "open list:KERNEL VIRTUAL M
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180619145943.GC8034@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2018-06-19 17:59:43, Jarkko Sakkinen wrote:
> On Tue, Jun 12, 2018 at 12:50:12PM +0200, Pavel Machek wrote:
> > On Fri 2018-06-08 19:09:35, Jarkko Sakkinen wrote:
> > > Intel(R) SGX is a set of CPU instructions that can be used by applica=
tions
> > > to set aside private regions of code and data. The code outside the e=
nclave
> > > is disallowed to access the memory inside the enclave by the CPU acce=
ss
> > > control.  In a way you can think that SGX provides inverted sandbox. =
It
> > > protects the application from a malicious host.
> >=20
> > Do you intend to allow non-root applications to use SGX?
> >=20
> > What are non-evil uses for SGX?
> >=20
> > ...because it is quite useful for some kinds of evil:
>=20
> The default permissions for the device are 600.

Good. This does not belong to non-root. But question still remains:

What are some non-evil uses for SGX?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlspYb4ACgkQMOfwapXb+vJoHgCfQETW41371wt6g9JNvkkPCbRX
L7kAn1QrI68f6vHPl4zK49NAGUx7naPO
=WZ8V
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
