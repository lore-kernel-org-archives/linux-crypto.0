From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 00/27] x86: PIE support and option to extend KASLR
	randomization
Date: Thu, 15 Mar 2018 09:48:36 +0100
Message-ID: <20180315084836.GA15953@amd>
References: <20180313205945.245105-1-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2098409007256012406=="
Cc: Kate Stewart <kstewart@linuxfoundation.org>,
	Nicolas Pitre <nicolas.pitre@linaro.org>, Michal Hocko <mhocko@suse.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Petr Mladek <pmladek@suse.com>, Len Brown <len.brown@intel.com>,
	Peter Zijlstra <peterz@infradead.org>, Christopher Li <sparse@chrisli.org>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-kernel@vger.kernel.org,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	"H . Peter Anvin" <hpa@zytor.com>, kernel-hardening@lists.openwall.com,
	Christoph Lameter <cl@linux.com>, Jiri Slaby <jslaby@suse.cz>,
	Alok Kataria <akataria@vmware.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Baoquan He <bhe@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Ra
To: Thomas Garnier <thgarnie@google.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180313205945.245105-1-thgarnie@google.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org


--===============2098409007256012406==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> These patches make the changes necessary to build the kernel as Position
> Independent Executable (PIE) on x86_64. A PIE kernel can be relocated bel=
ow
> the top 2G of the virtual address space. It allows to optionally extend t=
he
> KASLR randomization range from 1G to 3G.

Would you explain why PIE code is good idea?

You are adding less than 2 bits of randomness. Cost is new config
option, some size and performance impact, and more than 1000 lines of
code...

Is there some grand plan of adding 30 more bits of randomness with
future patch or something?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlqqM2QACgkQMOfwapXb+vIPUQCgiwtu3igz+Mea6JgZEWaFBEa4
DdUAn1zcqcTDjpsItrwfFnQZ9XU/fRNQ
=OpfY
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--

--===============2098409007256012406==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Virtualization mailing list
Virtualization@lists.linux-foundation.org
https://lists.linuxfoundation.org/mailman/listinfo/virtualization
--===============2098409007256012406==--
