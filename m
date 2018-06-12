From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v11 00/13] Intel SGX1 support
Date: Tue, 12 Jun 2018 12:50:12 +0200
Message-ID: <20180612105011.GA26931@amd>
References: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
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
In-Reply-To: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2018-06-08 19:09:35, Jarkko Sakkinen wrote:
> Intel(R) SGX is a set of CPU instructions that can be used by applications
> to set aside private regions of code and data. The code outside the encla=
ve
> is disallowed to access the memory inside the enclave by the CPU access
> control.  In a way you can think that SGX provides inverted sandbox. It
> protects the application from a malicious host.

Do you intend to allow non-root applications to use SGX?

What are non-evil uses for SGX?

=2E..because it is quite useful for some kinds of evil:

https://taesoo.kim/pubs/2017/jang:sgx-bomb.pdf

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlsfpWMACgkQMOfwapXb+vJyjACgptNd44vgyUMl4V5k7rJbDQxK
JbEAnjeMHh5kaf/23CfmT5S/0/qhg2Co
=U4Bc
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
